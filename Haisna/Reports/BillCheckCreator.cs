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
    /// 請求書チェックリスト生成クラス
    /// </summary>
    public class BillCheckCreator : PdfCreator
    {

        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002350";

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            if (string.IsNullOrEmpty(queryParams["year"]) || string.IsNullOrEmpty(queryParams["month"]))
            {
                messages.Add("受診年月が未入力です。");
            }
            else
            {
                if (! DateTime.TryParse(queryParams["year"] + "/" + queryParams["month"] + "/01", out DateTime wkDate))
                {
                    messages.Add("受診年月が正しくありません。");
                }
            }

            return messages;
        }

        /// <summary>
        /// 請求書チェックリストデータを読み込む
        /// </summary>
        /// <returns>請求書チェックリストデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select distinct
                    com.orgcd1 as orgcd1
                    , com.orgcd2 as orgcd2
                    , og.orgname as orgname
                    , decode(og.ticketaddbill, 1, '○', ' ') as ticketaddbill
                    , decode(og.billreport, 1, '○', ' ') as billreport
                    , decode(og.billreport, 2, '○', ' ') as billlaw
                    , decode(og.billspecial, 1, '○', ' ') as billspecial
                    , decode(og.billfd, 1, '○', ' ') as billfd
                    , decode(og.billins, 1, '○', ' ') as billins
                    , decode(og.billcsldiv, 1, '○', ' ') as billcsldiv
                    , decode(og.billage, 1, '○', ' ') as billage
                    , decode(og.insreport, 1, '○', ' ') as insreport
                    , decode(og.reptcsldiv, 1, '○', ' ') as reptcsldiv
                    , :startdate_dtm as startdate
                    , :startdate as cslyyyymm 
                from
                    consult co
                    , consult_m com
                    , org og 
                where
                    co.rsvno = com.rsvno 
                    and og.orgcd1 = com.orgcd1 
                    and og.orgcd2 = com.orgcd2 
                    and co.cancelflg = :cancelflg 
                    and com.orgcd1 not in (:orgcd1_person) 
                    and com.orgcd2 not in (:orgcd2_person) 
                    and co.csldate between to_date(:startdate, 'YYYY/MM') and last_day(to_date(:startdate, 'YYYY/MM')) 
                order by
                    com.orgcd1
                    , com.orgcd2
                ";

            // パラメータセット
            string strDate = "";
            DateTime.TryParse(queryParams["year"] + "/" + queryParams["month"] + "/01", out DateTime startdate);
            strDate = startdate.ToString("yyyyMM");

            var sqlParam = new
            {
                startdate_dtm = startdate.ToString("yyyy/MM/dd"),
                startDate = strDate,
                orgcd1_person = WebHains.ORGCD1_PERSON,
                orgcd2_person = WebHains.ORGCD2_PERSON,

                cancelflg = ConsultCancel.Used
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">請求書チェックリストデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var closedateField = (CnDataField)cnObjects["CLOSEDATE"];
            var prtdateField = (CnDataField)cnObjects["PRINTDATE"];
            var pagenoField = (CnDataField)cnObjects["PAGENO"];
            var orgnameListField = (CnListField)cnObjects["ORGNAME"];
            var ticketaddbillListField = (CnListField)cnObjects["TICKETADDBILL"];
            var billreportListField = (CnListField)cnObjects["BILLREPORT"];
            var billlawListField = (CnListField)cnObjects["BILLLAW"];
            var billspecialListField = (CnListField)cnObjects["BILLSPECIAL"];
            var billfdListField = (CnListField)cnObjects["BILLFD"];
            var billinsListField = (CnListField)cnObjects["BILLINS"];
            var billcsldivListField = (CnListField)cnObjects["BILLCSLDIV"];
            var billageListField = (CnListField)cnObjects["BILLAGE"];
            var insreportListField = (CnListField)cnObjects["INSREPORT"];
            var reptcsldivListField = (CnListField)cnObjects["REPTCSLDIV"];

            string sysdate = DateTime.Today.ToShortDateString();

            int pageNo = 0;
            int outCnt = 0;

            short currentLine = 0;

            //キー設定
            //（パラメタで年月指定されているが、おそらく年月毎に改ページさせようとしていたため踏襲）
            string newKey = "";
            string oldKey = "";
            string csldate = "";

            if ( data.Count > 0 )
            {
                newKey = data[0].CSLYYYYMM;
                oldKey = newKey;
                DateTime.TryParse(Util.ConvertToString(data[0].STARTDATE), out DateTime csldate_dtm);
                csldate = WebHains.EraDateFormat(csldate_dtm, "ggyy年 MM月分");
            }

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // キー設定
                newKey = detail.CSLYYYYMM;
                DateTime.TryParse(Util.ConvertToString(detail.STARTDATE), out DateTime csldate_dtm);
                csldate = WebHains.EraDateFormat(csldate_dtm, "ggyy年 MM月分");

                // ページ内最大行に達した場合か、キーが変わった場合
                if (currentLine == orgnameListField.ListRows.Length || newKey != oldKey)
                {
                    pageNo++;

                    // ページ番号
                    pagenoField.Text = pageNo.ToString();

                    // 印刷日
                    prtdateField.Text = sysdate;

                    // 締め日
                    closedateField.Text = csldate;

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    // 行カウントをクリア
                    currentLine = 0;

                    // キー更新
                    if (newKey != oldKey)
                    {
                        oldKey = newKey;
                    }

                }

                //団体名
                orgnameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ORGNAME);

                //利用券添付
                ticketaddbillListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.TICKETADDBILL);

                //レポート3連
                billreportListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.BILLREPORT);

                //レポート法定項目
                billlawListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.BILLLAW);

                //特定健診
                billspecialListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.BILLSPECIAL);

                //FD発送
                billfdListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.BILLFD);

                //請求書（保険証）
                billinsListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.BILLINS);

                //請求書（本/家）
                billcsldivListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.BILLCSLDIV);

                //請求書（年齢）
                billageListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.BILLAGE);

                //レポート（保険証）
                insreportListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.INSREPORT);

                //レポート（本/家）
                reptcsldivListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.REPTCSLDIV);

                //要注意
                var retPubNote = GetPubNote(detail.ORGCD1, detail.ORGCD2, detail.CSLYYYYMM);
                if (retPubNote != null)
                {
                    var pubnoteTextField = (CnTextField)cnObjects["PUBNOTE" + (currentLine + 1).ToString()];

                    pubnoteTextField.Text = Util.ConvertToString(retPubNote.PUBNOTE);
                }

                //行インクリメント
                currentLine++;

                //件数インクリメント
                outCnt++;

            }

            //終了処理
            if (currentLine > 0 )
            {
                pageNo++;

                // ページ番号
                pagenoField.Text = pageNo.ToString();

                // 印刷日
                prtdateField.Text = sysdate;

                // 締め日
                closedateField.Text = csldate;

                // ドキュメントの出力
                PrintOut(cnForm);

            }

        }

        /// <summary>
        /// 要注意事項取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>取得リストデータ</returns>
        private dynamic GetPubNote(string orgCd1, string orgCd2, string cslyyyymm)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    report_bill_check(:orgcd1, :orgcd2, :csldate) as pubnote 
                from
                    dual
                ";

            // パラメータセット
            var sqlParam = new
            {
                orgcd1 = orgCd1,
                orgcd2 = orgCd2,
                csldate = cslyyyymm
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return result;
        }

    }
}
