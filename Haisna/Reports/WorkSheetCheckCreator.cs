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
    /// ワークシート８項目生成クラス
    /// </summary>
    public class WorkSheetCheckCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002110";

        /// <summary>
        /// 汎用分類コード（帳票固有設定用）
        /// </summary>
        string FREECLASSCD_LST = "LST";

        /// <summary>
        /// 汎用コード（対象コース）
        /// </summary>
        string FREECD_LST000130 = "LST000130%";

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
        /// ワークシート８項目データを読み込む
        /// </summary>
        /// <returns>ワークシート８項目データ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    co.csldate as csldate
                    , re.dayid as dayid
                    , pe.lastkname || ' ' || pe.firstkname as kname
                    , pe.lastname || '　' || pe.firstname as name
                    , pe.perid as perid
                    , trunc(co.age, 0) as age
                    , decode(pe.gender, 1, '男', 2, '女') as gender 
                from
                    consult co
                    , person pe
                    , receipt re
                    , free fr 
                where
                    co.perid = pe.perid 
                    and co.rsvno = re.rsvno 
                    and co.cancelflg = :cancelflg 
                    and fr.freecd like :freecd 
                    and fr.freeclasscd = :freeclasscd 
                    and fr.freefield1 = co.cscd 
                    and co.csldate >= :startdate 
                    and co.csldate <= :enddate 
                order by
                    re.csldate
                    , re.dayid
                ";

            // パラメータセット
            var sqlParam = new
            {
                startdate = queryParams["startdate"],
                enddate = queryParams["enddate"],
                freecd = FREECD_LST000130,
                freeclasscd = FREECLASSCD_LST,
                cancelflg = ConsultCancel.Used,
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">ワークシート８項目データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var pageNoField = (CnDataField)cnObjects["PAGENO"];
            var dateField = (CnDataField)cnObjects["DATE"];
            var paraCslDateField = (CnDataField)cnObjects["CSLDATE"];
            var dayIdListField = (CnListField)cnObjects["DAYID"];
            var kNameListField = (CnListField)cnObjects["KNAME"];
            var nameListField = (CnListField)cnObjects["NAME"];
            var perIdListField = (CnListField)cnObjects["PERID"];
            var ageListField = (CnListField)cnObjects["AGE"];
            var genderListField = (CnListField)cnObjects["GENDER"];
            var checkListField = (CnListField)cnObjects["CHECK"];

            string sysdate = DateTime.Today.ToString("yyyy/MM/dd");

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
                if (DateTime.TryParse(Util.ConvertToString(detail.CSLDATE), out DateTime cslDate))
                {
                    tmpCslDate = cslDate.ToString("yyyy/MM/dd");
                }

                // 改ページの判定を行う
                bool isPageBreak = false;
                if (dataCount > 0 && !pageBreakKeyCslDate.Equals(tmpCslDate))
                {
                    // 改ページキーが異なる場合は改ページを行う
                    isPageBreak = true;

                    // 次回のループで今回のデータの処理を行うため
                    // カウントを１つ戻す
                    dataCount--;
                }
                else
                {
                    // 最初のデータの場合
                    // 改ページキーを退避する
                    if (dataCount == 0)
                    {
                        pageBreakKeyCslDate = tmpCslDate;
                    }

                    // 当日ID
                    dayIdListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.DAYID);

                    // カナ氏名
                    kNameListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.KNAME);

                    // 氏名
                    nameListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.NAME);

                    // 患者番号
                    perIdListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.PERID);

                    // 年齢
                    ageListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.AGE);

                    // 性別
                    genderListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.GENDER);

                    // チェック
                    checkListField.ListCell(0, lineCount).Text = "（　　　　　　　　　） （　　　　　　　　　）";

                    // 出力行位置をカウントアップする
                    lineCount++;
                }

                // 下記の何れかの場合に改ページ処理を行う
                // ・改ページキーが異なる場合
                // ・ページの最終行に達した場合
                // ・ループの最後のデータの場合
                if (isPageBreak ||
                    lineCount == (dayIdListField.ListRows.Length - 1) ||
                    dataCount == (data.Count - 1))
                {
                    pageNo++;

                    // ページ番号
                    pageNoField.Text = pageNo.ToString("0");

                    // 印刷日
                    dateField.Text = sysdate;

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
