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
    /// 郵便物受領書（請求書）生成クラス
    /// </summary>
    public class PostBillCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002320";
        
        /// <summary>
        /// :paymentdate
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            string wkStaDate = queryParams["startdate"];
            string wkEndDate = queryParams["enddate"];

            DateTime wkDate;
            //終了日が未設定の場合は開始日を設定
            if (!DateTime.TryParse(wkEndDate, out wkDate))
            {
                wkEndDate = wkStaDate;
            }

            //入力チェック
            if (!DateTime.TryParse(wkStaDate, out wkDate))
            {
                messages.Add("開始日が正しくありません。");
            }

            if (!DateTime.TryParse(wkEndDate, out wkDate))
            {
                messages.Add("終了日が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// 郵便物受領書（請求書）データを読み込む
        /// </summary>
        /// <returns>郵便物受領書（請求書）データ</returns>
        protected override List<dynamic> GetData()
        {

            string sql = @"
                select
                    dispatch.closedate as closedate
                    , dispatch.branchno as branchno
                    , dispatch.billseq as billseq
                    , dispatch.dispatchdate as dispatchdate
                    , orgaddr.orgname as orgname
                    , orgaddr.chargename as chargename 
                from
                    dispatch
                    , bill
                    , org
                    , orgaddr 
                where
                    dispatch.dispatchdate between :startdate and :enddate 
                ";

            if ( queryParams["loginId"].Trim() != "")
            {
                sql += @"
                    and dispatch.upduser = :loginID 
                ";
            }

            sql += @"
                    and dispatch.closedate = bill.closedate 
                    and dispatch.billseq = bill.billseq 
                    and dispatch.branchno = bill.branchno 
                    and bill.orgcd1 = org.orgcd1 
                    and bill.orgcd2 = org.orgcd2 
                    and org.orgcd1 = orgaddr.orgcd1(+) 
                    and org.orgcd2 = orgaddr.orgcd2(+) 
                    and org.billaddress = orgaddr.addrdiv(+) 
                    order by
                        dispatch.upddate
                ";

            string wkStaDate = queryParams["startdate"];
            string wkEndDate = queryParams["enddate"];

            if (!DateTime.TryParse(wkEndDate, out DateTime wkDate))
            {
                //終了日指定がない場合は開始日を設定
                wkEndDate = wkStaDate;
            }

            // パラメータセット
            var sqlParam = new
            {
                startdate = wkStaDate,
                enddate = wkEndDate,
                loginID = queryParams["loginId"]
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">郵便物受領書（請求書）データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var dispatchdateField = (CnDataField)cnObjects["DISPATCHDATE"];
            var pageField = (CnDataField)cnObjects["PAGE"];
            var orgnameListField = (CnListField)cnObjects["ORGNAME"];
            var chargenameListField = (CnListField)cnObjects["CHARGENAME"];
            var noListField = (CnListField)cnObjects["No."];

            string sysdate = DateTime.Today.ToShortDateString();

            int pageNo = 0;
            int outCnt = 0;

            //発送日
            DateTime disPatchDate;
            DateTime.TryParse(Util.ConvertToString(data[0].DISPATCHDATE), out disPatchDate);

            //キー設定
            string newKey = disPatchDate.ToString("yyyy/MM/dd");
            string oldKey = newKey;

            short currentLine = 0;

            long outNo = 0;

            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                //発送日
                DateTime.TryParse(Util.ConvertToString(detail.DISPATCHDATE), out disPatchDate);

                //キー設定
                newKey = disPatchDate.ToString("yyyy/MM/dd");

                // ページ内最大行に達した場合、またはキーが異なった場合に改ページ
                if ( (currentLine == noListField.ListRows.Length) || (newKey != oldKey))
                {
                    pageNo++;

                    // ページ番号
                    pageField.Text = pageNo.ToString();

                    // 発送日
                    dispatchdateField.Text = oldKey;

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    //現在編集行のリセット
                    currentLine = 0;

                    //キーブレイクによる改ページ処理
                    if (newKey != oldKey)
                    {
                        oldKey = newKey;
                        outNo = 0;
                    }
                }

                //団体名
                orgnameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ORGNAME);
                //受取人氏名
                chargenameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.CHARGENAME);
                //No.
                noListField.ListCell(0, currentLine).Text = (outNo + 1).ToString();

                // 行カウントをインクリメント
                currentLine++;

                // 件数をインクリメント
                outCnt++;

                // 連番をインクリメント
                outNo++;

            }

            //終了処理
            if (outCnt > 0)
            {
                pageNo++;

                // ページ番号
                pageField.Text = pageNo.ToString();

                // 発送日
                dispatchdateField.Text = oldKey;

                // ドキュメントの出力
                PrintOut(cnForm);

                //現在編集行のリセット
                currentLine = 0;

            }

        }

    }
}
