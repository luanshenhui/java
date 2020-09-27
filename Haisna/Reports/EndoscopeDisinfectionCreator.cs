using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.ReportCore;
using Hos.CnDraw;
using Hos.CnDraw.Object;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    /// <summary>
    /// 内視鏡洗浄消毒履歴生成クラス
    /// </summary>
    public class EndoscopeDisinfectionCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002100";

        /// <summary>
        /// コースコード（１日人間ドック）
        /// </summary>
        string CSCD_100 = "100";

        /// <summary>
        /// コースコード（職員定期健康診断(ドック)）
        /// </summary>
        string CSCD_105 = "105";

        /// <summary>
        /// コースコード（企業健診）
        /// </summary>
        string CSCD_110 = "110";

        /// <summary>
        /// コースコード（オプション大腸鏡）
        /// </summary>
        string CSCD_120 = "120";

        /// <summary>
        /// コースコード（後日胃内視鏡）
        /// </summary>
        string CSCD_130 = "130";

        /// <summary>
        /// グループコード（胃内視鏡(MAP)）
        /// </summary>
        string GRPCD_M622 = "M622";

        /// <summary>
        /// グループコード（大腸内視鏡(MAP)）
        /// </summary>
        string GRPCD_M629 = "M629";

        /// <summary>
        /// 当日ID（ダミーID）
        /// </summary>
        int DAYID_DUMMY = 9999;

        /// <summary>
        /// 空行件数
        /// </summary>
        int ROWNUM_DUMMY = 11;

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            if (!DateTime.TryParse(queryParams["csldate"], out DateTime wkDate))
            {
                messages.Add("日付が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// 内視鏡洗浄消毒履歴データを読み込む
        /// </summary>
        /// <returns>内視鏡洗浄消毒履歴データ</returns>
        protected override List<dynamic> GetData()
        {
            // パラメータ値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("csldate", queryParams["csldate"]);
            sqlParam.Add("cscd100", CSCD_100);
            sqlParam.Add("cscd105", CSCD_105);
            sqlParam.Add("cscd110", CSCD_110);
            sqlParam.Add("cscd120", CSCD_120);
            sqlParam.Add("cscd130", CSCD_130);
            sqlParam.Add("grpcdm622", GRPCD_M622);
            sqlParam.Add("grpcdm629", GRPCD_M629);
            sqlParam.Add("cancelflg", ConsultCancel.Used);
            sqlParam.Add("dayiddummy", DAYID_DUMMY);
            sqlParam.Add("rownumdummy", ROWNUM_DUMMY);

            // SQLステートメント定義
            string sql = @"
                    select
                        consult.csldate as csldate
                        , receipt.dayid as dayid
                        , consult.perid as perid
                        , person.lastname || ' ' || person.firstname as name 
                    from
                        consult
                        , receipt
                        , person
                        , grp_i
                        , rsl 
                    where
                        consult.csldate = :csldate 
                        and consult.cancelflg = :cancelflg 
                        and consult.cscd in (:cscd100, :cscd105, :cscd110, :cscd120, :cscd130) 
                        and consult.rsvno = receipt.rsvno 
                        and consult.perid = person.perid 
                        and consult.rsvno = rsl.rsvno 
                        and grp_i.grpcd in (:grpcdm622, :grpcdm629) 
                        and grp_i.itemcd = rsl.itemcd 
                        and grp_i.suffix = rsl.suffix 
                    union all 
                    select
                        consult.csldate as csldate
                        , :dayiddummy as dayid
                        , '' as perid
                        , '' as name 
                    from
                        consult 
                    where
                        consult.csldate = :csldate 
                        and consult.cancelflg = :cancelflg 
                        and consult.cscd in (:cscd100, :cscd105, :cscd110, :cscd120, :cscd130) 
                        and rownum < :rownumdummy 
                    order by
                        1
                        , 2
                ";

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">内視鏡洗浄消毒履歴データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var pageNoField = (CnDataField)cnObjects["PAGENO"];
            var paraCslDateField = (CnDataField)cnObjects["CSLDATE"];
            var countListField = (CnListField)cnObjects["COUNT"];
            var dayIdListField = (CnListField)cnObjects["DAYID"];
            var perIdListField = (CnListField)cnObjects["PERID"];
            var nameListField = (CnListField)cnObjects["NAME"];

            int rowCount = 0;
            int pageNo = 0;

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // 編集行を特定する
                var currentLine = (short)(rowCount % countListField.ListRows.Length);

                // No
                countListField.ListCell(0, currentLine).Text = (rowCount + 1).ToString("0");
                // 当日ID
                dayIdListField.ListCell(0, currentLine).Text = 
                    (Util.ConvertToString(detail.DAYID) == DAYID_DUMMY.ToString()) ? "" : Util.ConvertToString(detail.DAYID);
                // 患者番号
                perIdListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.PERID);
                // 氏名
                nameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.NAME);

                // ページ内最大行に達したか、レコード最大数に達した場合
                if (currentLine == countListField.ListRows.Length - 1 || rowCount == data.Count - 1)
                {
                    pageNo++;

                    // 受診日
                    if (DateTime.TryParse(Util.ConvertToString(detail.CSLDATE), out DateTime cslDate))
                    {
                        paraCslDateField.Text = cslDate.ToString("yyyy年MM月dd日");
                    }

                    // ページ番号
                    pageNoField.Text = pageNo.ToString("0");

                    // ドキュメントの出力
                    PrintOut(cnForm);
                }

                // 行カウントをインクリメント
                rowCount++;
            }
        }
    }
}
