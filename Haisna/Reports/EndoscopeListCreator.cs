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
    /// 内視鏡受付一覧生成クラス
    /// </summary>
    public class EndoscopeListCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002090";

        /// <summary>
        /// グループコード（胃内視鏡(MAP)）
        /// </summary>
        string GRPCD_M622 = "M622";

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            if (!DateTime.TryParse(queryParams["startdate"], out DateTime wkStartDate))
            {
                messages.Add("開始日付が正しくありません。");
            }

            if (!DateTime.TryParse(queryParams["enddate"], out DateTime wkEndDate))
            {
                messages.Add("終了日付が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// 内視鏡受付一覧データを読み込む
        /// </summary>
        /// <returns>内視鏡受付一覧データ</returns>
        protected override List<dynamic> GetData()
        {
            // パラメータ値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("startdate", queryParams["startdate"]);
            sqlParam.Add("enddate", queryParams["enddate"]);
            sqlParam.Add("grpcdm622", GRPCD_M622);
            sqlParam.Add("cancelflg", ConsultCancel.Used);

            // SQLステートメント定義
            string sql = @"
                    select distinct
                        consult.csldate as csldate
                        , receipt.dayid as dayid
                        , consult.perid as perid
                        , person.lastname || '　' || firstname as name
                        , person.lastkname || '　' || firstkname as kname
                        , trunc( 
                            getcslage( 
                                to_char(person.birth, 'yyyymmdd')
                                , to_char(consult.csldate, 'yyyymmdd')
                                , to_char(consult.csldate, 'yyyymmdd')
                            )
                        ) || '歳(' || trunc(consult.age) || '歳)' as age
                        , decode(person.gender, 1, '男', 2, '女') as gender 
                    from
                        consult
                        , consultitemlist cil_v
                        , receipt
                        , person
                        , grp_i 
                    where
                        consult.csldate >= :startdate 
                        and consult.csldate <= :enddate 
                        and cil_v.csldate >= :startdate 
                        and cil_v.csldate <= :enddate 
                        and cil_v.rsvno = consult.rsvno 
                        and replace (cil_v.itemcd, ' ', null) is not null 
                        and receipt.rsvno = consult.rsvno 
                        and person.perid = consult.perid 
                        and cil_v.itemcd = grp_i.itemcd 
                        and grp_i.grpcd = :grpcdm622 
                        and consult.cancelflg = :cancelflg 
                    order by
                        consult.csldate
                        , receipt.dayid
                ";

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">内視鏡受付一覧データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var pageNoField = (CnDataField)cnObjects["PAGENO"];
            var printDateField = (CnDataField)cnObjects["PRINTDATE"];
            var paraCslDateField = (CnDataField)cnObjects["CSLDATE"];
            var countListField = (CnListField)cnObjects["COUNT"];
            var dayIdListField = (CnListField)cnObjects["DAYID"];
            var perIdListField = (CnListField)cnObjects["PERID"];
            var nameListField = (CnListField)cnObjects["NAME"];
            var kNameListField = (CnListField)cnObjects["KNAME"];
            var ageListField = (CnListField)cnObjects["AGE"];
            var genderListField = (CnListField)cnObjects["GENDER"];
            var sekoiListField = (CnListField)cnObjects["SEKOI"];
            var bxListField = (CnListField)cnObjects["BX"];
            var sedesyonListField = (CnListField)cnObjects["SEDESYON"];

            string sysdate = DateTime.Today.ToString("yyyy年MM月dd日");

            int pageNo = 0;
            short lineCount = 0;
            string pageBreakKeyCslDate = "";

            // ページ内の項目に値をセット
            for (int dataCount = 0; dataCount < data.Count; dataCount++)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                var detail = data[dataCount];

                // 改ページキーを取得する
                string tmpCslDate = "";
                if (DateTime.TryParse(Util.ConvertToString(detail.CSLDATE), out DateTime dt))
                {
                    tmpCslDate = dt.ToString("yyyy年MM月dd日");
                }

                // 改ページの判定を行う
                bool isPageBreak = false;
                if (dataCount > 0 &&
                    !pageBreakKeyCslDate.Equals(tmpCslDate))
                {
                    // 改ページキーが異なる場合は改ページを行う
                    isPageBreak = true;

                    // 次回のループで今回のデータの処理を行うため
                    // カウントを１つ戻す
                    dataCount--;
                } else
                {
                    // 最初のデータの場合
                    // 改ページキーを退避する
                    if (dataCount == 0)
                    {
                        pageBreakKeyCslDate = tmpCslDate;
                    }

                    // No
                    countListField.ListCell(0, lineCount).Text = (dataCount + 1).ToString("0");
                    // 当日ID
                    dayIdListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.DAYID);
                    // 患者番号
                    perIdListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.PERID);
                    // 氏名
                    nameListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.NAME);
                    // カナ氏名
                    kNameListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.KNAME);
                    // 年齢
                    ageListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.AGE);
                    // 性別
                    genderListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.GENDER);
                    // 施行医
                    sekoiListField.ListCell(0, lineCount).Text = "増田･熊倉･加藤･（        ）";
                    // BX
                    bxListField.ListCell(0, lineCount).Text = "有･無";
                    // セデーション
                    sedesyonListField.ListCell(0, lineCount).Text = "有･無";

                    // 出力行位置をカウントアップする
                    lineCount++;
                }

                // 下記の何れかの場合に改ページ処理を行う
                // ・改ページキーが異なる場合
                // ・ページの最終行に達した場合
                // ・ループの最後のデータの場合
                if (isPageBreak ||
                    lineCount == (countListField.ListRows.Length - 1) ||
                    dataCount == (data.Count - 1))
                {
                    pageNo++;

                    // ページ番号
                    pageNoField.Text = pageNo.ToString("0");

                    // 印刷日
                    printDateField.Text = sysdate;

                    // 受診日
                    paraCslDateField.Text = pageBreakKeyCslDate;

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    // 出力行位置を初期化する
                    lineCount = 0;

                    // 改ページキーを退避する
                    pageBreakKeyCslDate = tmpCslDate;
                }
            }
        }
    }
}
