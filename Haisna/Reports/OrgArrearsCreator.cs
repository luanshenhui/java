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
    /// 未収団体一覧表生成クラス
    /// </summary>
    public class OrgArrearsCreator : PdfCreator
    {

        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "000760";

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
                if (!DateTime.TryParse(queryParams["year"] + "/" + queryParams["month"] + "/01", out DateTime wkDate))
                {
                    messages.Add("受診年月が正しくありません。");
                }
            }

            return messages;
        }

        /// <summary>
        /// 未収団体一覧表データを読み込む
        /// </summary>
        /// <returns>未収団体一覧表データ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    mainview.*
                    , payment.paymentdate
                    , payment.paymentprice 
                from
                    payment
                    , ( 
                        select distinct
                            a.closedate
                            , a.billseq
                            , a.branchno
                            , a.orgcd1
                            , a.orgcd2
                            , b.orgname
                            , c.chargepost
                            , c.chargename
                            , to_char(a.closedate, 'MM') month
                            , sum( 
                                nvl(d.price, 0) + nvl(d.editprice, 0) + nvl(d.taxprice, 0) + nvl(d.edittax, 0) + nvl(e.price, 0) + nvl
                                (e.editprice, 0) + nvl(e.taxprice, 0) + nvl(e.edittax, 0)
                            ) total 
                        from
                            bill a
                            , org b
                            , orgaddr c
                            , billdetail d
                            , billdetail_items e 
                        where
                            a.closedate between :startdate and :enddate 
                            and a.orgcd1 = b.orgcd1 
                            and a.orgcd2 = b.orgcd2 
                            and a.delflg = 0 
                            and b.billaddress = c.addrdiv(+) 
                            and b.orgcd1 = c.orgcd1(+) 
                            and b.orgcd2 = c.orgcd2(+) 
                            and a.closedate = d.closedate 
                            and a.billseq = d.billseq 
                            and a.branchno = d.branchno 
                            and d.closedate = e.closedate(+) 
                            and d.billseq = e.billseq(+) 
                            and d.branchno = e.branchno(+) 
                            and d.lineno = e.lineno(+) 
                        group by
                            a.closedate
                            , a.billseq
                            , a.branchno
                            , a.orgcd1
                            , a.orgcd2
                            , b.orgname
                            , c.chargepost
                            , c.chargename
                            , to_char(a.closedate, 'YYYY/MM')
                    ) mainview 
                where
                    payment.closedate(+) = mainview.closedate 
                    and payment.billseq(+) = mainview.billseq 
                    and payment.branchno(+) = mainview.branchno 
                order by
                    mainview.orgcd1
                    , mainview.orgcd2
                ";

            //抽出対象日範囲の設定（指定年月の２か月前月初～指定年月月末までの３か月）
            DateTime.TryParse(queryParams["year"] + "/" + queryParams["month"] + "/01", out DateTime paraDate);

            //開始年月日
            string startDate = paraDate.AddMonths(-2).ToString("yyyy/MM") + "/01";

            //終了年月日
            string endDate = paraDate.AddMonths(1).AddDays(-1).ToString("yyyy/MM/dd");

            // パラメータセット
            var sqlParam = new
            {
                startdate = startDate,
                enddate = endDate
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">未収団体一覧表データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var prtdateField = (CnDataField)cnObjects["txtDate"];
            var pageField = (CnDataField)cnObjects["txtPage"];
            var paraField = (CnDataField)cnObjects["txtPARA"];
            var monthListField = (CnListField)cnObjects["lstMONTH"];
            var orgnameListField = (CnListField)cnObjects["lstORGNAME"];
            var postnameListField = (CnListField)cnObjects["lstPOSTNAME"];
            var nameListField = (CnListField)cnObjects["lstNAME"];
            var priceListField = (CnListField)cnObjects["lstPLICE"];
            var totalpliceListField = (CnListField)cnObjects["lstTOTALPLICE"];
            var lblgoukeiText = (CnText)cnObjects["lblGOUKEI"];

            string sysdate = DateTime.Today.ToShortDateString();

            //表示年月
            DateTime.TryParse(queryParams["year"] + "/" + queryParams["month"] + "/01", out DateTime paraDate);

            string printMonth1 = paraDate.AddMonths(-2).ToString("MM");
            string printMonth2 = paraDate.AddMonths(-1).ToString("MM");
            string printMonth3 = paraDate.ToString("MM");

            // 各カウント
            short currentLine = -1;
            int pageNo = 0;

            int outCnt = 0;

            // キーセット
            string newKey = "";
            string oldKey = "";

            if ( data.Count > 0 )
            {
                //１件目のキーセット
                newKey = data[0].ORGCD1 + data[0].ORGCD2;
                oldKey = newKey;
            }

            // 合計ラベル非表示
            lblgoukeiText.Visible = false;

            // 合計保持用リスト設定
            decimal[,] lstPrice = new decimal[4, orgnameListField.ListRows.Length+1]; //未収金額
            decimal[] lstTotal = new decimal[4];                                //未収金額総合計

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // キー設定
                newKey = detail.ORGCD1 + detail.ORGCD2;

                // ページ内最大行に達したか、レコード最大数に達した場合
                if (currentLine + 1 == orgnameListField.ListRows.Length )
                {
                    pageNo++;

                    // 印刷日
                    prtdateField.Text = sysdate;

                    // ページ番号
                    pageField.Text = pageNo.ToString();

                    // 表示年月
                    paraField.Text = paraDate.ToString("yyyy年MM") + "月";
                    monthListField.ListCell(0, 0).Text = printMonth1 + "月";
                    monthListField.ListCell(1, 0).Text = printMonth2 + "月";
                    monthListField.ListCell(2, 0).Text = printMonth3 + "月";

                    // 金額印字
                    for (short i = 0; i <= 3; i++)
                    {
                        for (short j = 0; j <= currentLine; j++)
                        {
                            priceListField.ListCell(i, j).Text = lstPrice[i,j].ToString("#,##0");
                        }
                    }

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    // 集計用領域のクリア
                    for (short i = 0; i <= 3; i++)
                    {
                        for (short j = 0; j <= currentLine; j++)
                        {
                            lstPrice[i, j] = 0;
                        }
                    }

                    // 現在行のクリア
                    currentLine = -1;

                }

                //未入金のデータが編集対象
                if ( string.IsNullOrEmpty(detail.PAYMENTDATE) )
                {
                    //キーブレイクによる改行処理
                    if ( newKey != oldKey )
                    {
                        currentLine++;
                        oldKey = newKey;
                    }
                    else
                    {
                        if (currentLine == -1)
                        {
                            currentLine = 0;
                        }
                    }

                    //団体名
                    orgnameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ORGNAME);

                    //担当部署名
                    postnameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.CHARGEPOST);
                    
                    //担当者名
                    nameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.CHARGENAME);

                    //未収金額
                    decimal.TryParse(Util.ConvertToString(detail.TOTAL), out decimal total);

                    if (Util.ConvertToString(detail.MONTH) == printMonth1)
                    {
                        lstPrice[0, currentLine] += total;
                        lstPrice[3, currentLine] += total;
                        lstTotal[0] += total;
                        lstTotal[3] += total;
                    }
                    else if (Util.ConvertToString(detail.MONTH) == printMonth2)
                    {
                        lstPrice[1, currentLine] += total;
                        lstPrice[3, currentLine] += total;
                        lstTotal[1] += total;
                        lstTotal[3] += total;
                    }
                    else if (Util.ConvertToString(detail.MONTH) == printMonth3)
                    {
                        lstPrice[2, currentLine] += total;
                        lstPrice[3, currentLine] += total;
                        lstTotal[2] += total;
                        lstTotal[3] += total;
                    }

                }

                // 連番をインクリメント
                outCnt++;
            }

            //終了処理
            if (currentLine >= 0)
            {
                // 現在ページおよび日付の編集
                pageNo++;

                // 印刷日
                prtdateField.Text = sysdate;

                // ページ番号
                pageField.Text = pageNo.ToString();

                // 表示年月
                paraField.Text = paraDate.ToString("yyyy年MM") + "月";
                monthListField.ListCell(0, 0).Text = printMonth1 + "月";
                monthListField.ListCell(1, 0).Text = printMonth2 + "月";
                monthListField.ListCell(2, 0).Text = printMonth3 + "月";

                // 金額印字
                for (short i = 0; i <= 3; i++)
                {
                    for (short j = 0; j <= currentLine; j++)
                    {
                        priceListField.ListCell(i, j).Text = lstPrice[i, j].ToString("#,##0");
                    }
                }

                // 合計金額
                totalpliceListField.ListCell(0, 0).Text = lstTotal[0].ToString("#,##0");
                totalpliceListField.ListCell(1, 0).Text = lstTotal[1].ToString("#,##0");
                totalpliceListField.ListCell(2, 0).Text = lstTotal[2].ToString("#,##0");
                totalpliceListField.ListCell(3, 0).Text = lstTotal[3].ToString("#,##0");

                // 合計表示
                lblgoukeiText.Visible = true;
                totalpliceListField.Visible = true;

                // ドキュメントの出力
                PrintOut(cnForm);
                
            }

        }
         
    }
}
