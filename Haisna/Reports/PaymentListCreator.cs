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
    /// 団体入金台帳生成クラス
    /// </summary>
    public class PaymentListCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "000800";

        /// <summary>
        /// 出力区分
        /// </summary>
        private const string OUTCLS_ALL = "0";      //入金済
        private const string OUTCLS_ACCRUED = "1";  //未収
        private const string OUTCLS_PAYMENT = "2";  //入金

        /// <summary>
        /// 汎用分類コード
        /// </summary>
        private const string FREECLASSCD_PAYMENTDIV = "PAYMENTDIV";    //入金種別

        /// <summary>
        /// :paymentdate
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            DateTime wkDate;
            if (!DateTime.TryParse(queryParams["s_startymd"], out wkDate))
            {
                messages.Add("開始締め日が正しくありません。");
            }

            if (!DateTime.TryParse(queryParams["s_endymd"], out wkDate))
            {
                messages.Add("終了締め日が正しくありません。");
            }

            //出力区分が入金済みの場合
            if ( queryParams["outputcls"] == OUTCLS_PAYMENT)
            {
                //入金日チェック
                if (!DateTime.TryParse(queryParams["n_startymd"], out wkDate))
                {
                    messages.Add("開始入金日が正しくありません。");
                }

                if (!DateTime.TryParse(queryParams["n_endymd"], out wkDate))
                {
                    messages.Add("終了入金日が正しくありません。");
                }
            }

            return messages;
        }

        /// <summary>
        /// 団体入金台帳データを読み込む
        /// </summary>
        /// <returns>団体入金台帳データ</returns>
        protected override List<dynamic> GetData()
        {
            bool closeDateFlg = false;      //TRUE:締め日範囲が指定されている
            bool paymentDateFlg = false;   //TRUE:入金日範囲が指定されている
            bool isPaymentFlg = false;     //TRUE:未収「入金済みのみ」が指定されている
            bool isNoPaymentFlg = false;   //TRUE:未収「未収のみ」が指定されている

            string orderPaymentDate = "9999/01/01"; //ソート用の入金日

            DateTime wkN_startymd;
            DateTime wkN_endtymd;

            //締め日範囲の妥当性チェック
            if ((!DateTime.TryParse(queryParams["s_startymd"], out wkN_startymd)) && (!DateTime.TryParse(queryParams["s_endymd"], out wkN_endtymd)))
            {
                //締め日指定フラグを立てる
                closeDateFlg = true;
            }

            //締め日範囲が正しく設定されていない場合は終了
            if (closeDateFlg == true)
            {
                return null;
            }

            //入金日範囲の妥当性チェック
            if ( (!DateTime.TryParse(queryParams["n_startymd"], out wkN_startymd)) && (!DateTime.TryParse(queryParams["n_endymd"], out wkN_endtymd)) )
            {
                //入金日指定フラグを立てる
                paymentDateFlg = true;
            }

            //出力区分の判断
            switch (queryParams["outputcls"])
            {
                case OUTCLS_ACCRUED:
                    //未収
                    isNoPaymentFlg = true;
                    break;

                case OUTCLS_PAYMENT:
                    //入金済み
                    isPaymentFlg = true;
                    break;
            }

            // SQLステートメント定義

            //Rownumで範囲指定するため、結果セットを丸ごとViewにする
            string sql = @"
                select
                    base_view.* 
                from
                    ( 
                        select
                            main_view.*
                            , rownum as rowseq 
                        from
                            ( 
                                --基本部分SELECT句
                                select
                                    bill.closedate
                                    , bill.billseq
                                    , bill.branchno
                                    , to_char(bill.closedate, 'YYYYMMDD') || trim(to_char(bill.billseq, '00000')) || to_char(bill.branchno)
                                     as billno
                                    , payment_view.seq as paymentseq
                                    , bill.orgcd1
                                    , bill.orgcd2
                                    , bill.prtdate
                                    , bill.method
                                    , org.orgname
                                    , org.orgkname
                                    , nvl(sum_billdetail.pricetotal, 0) + nvl(sum_billdetail_items.pricetotal, 0) as pricetotal
                                    , nvl(sum_billdetail.taxtotal, 0) + nvl(sum_billdetail_items.taxtotal, 0) as taxtotal
                                    , nvl(sum_billdetail.pricetotal, 0) + nvl(sum_billdetail.taxtotal, 0) + nvl(sum_billdetail_items.pricetotal, 0)
                                     + nvl(sum_billdetail_items.taxtotal, 0) as billtotal
                                    , last_dispatch.dispatchdate
                                    , sum_payment.sum_paymentprice
                                    , payment_view.seq
                                    , payment_view.paymentprice
                                    , payment_view.paymentdate
                                    , payment_view.upduser
                                    , payment_view.username
                                    , payment_view.paymentdiv
                                    , nvl(payment_view.paymentdate, :orderPaymentdate) as order_paymentdate
                                    , bill.delflg 
                                    , free_paydiv.freefield2 as paydivname 
                                from
                                    bill
                                    , org
                                    --請求書明細サマリ部分
                                    , ( 
                                        select
                                            billdetail.closedate
                                            , billdetail.billseq
                                            , billdetail.branchno
                                            , sum(billdetail.price) as price
                                            , sum(billdetail.editprice) as editprice
                                            , sum(billdetail.price) + sum(billdetail.editprice) as pricetotal
                                            , sum(billdetail.taxprice) as taxprice
                                            , sum(billdetail.edittax) as edittax
                                            , sum(billdetail.taxprice) + sum(billdetail.edittax) as taxtotal
                 ";

            //入金日範囲が設定されている(かつ入金済みのみ抽出）
            if ((paymentDateFlg == true) && (isPaymentFlg == true))
            {
                sql += @"
                    from
                        billdetail
                        , payment
                ";
            }
            else
            {
                sql += @"
                    from
                        billdetail
                ";
            }

            //締め日指定
            sql += @"
                    where
                        billdetail.closedate between :strclosedate and :endclosedate
                ";

            //入金日範囲が設定されている(かつ入金済みのみ抽出）
            if ((paymentDateFlg == true) && (isPaymentFlg == true))
            {
                sql += @"
                    and payment.paymentdate between :strpaymentdate and :endpaymentdate 
                    and billdetail.closedate = payment.closedate 
                    and billdetail.billseq = payment.billseq 
                    and billdetail.branchno = payment.branchno
                ";
            }

            sql += @"
                group by
                    billdetail.closedate
                    , billdetail.billseq
                    , billdetail.branchno) sum_billdetail
                    --２次請求書明細サマリ部分
                    , ( 
                        select
                            billdetail_items.closedate
                            , billdetail_items.billseq
                            , billdetail_items.branchno
                            , sum(billdetail_items.price) as price
                            , sum(billdetail_items.editprice) as editprice
                            , sum(billdetail_items.price) + sum(billdetail_items.editprice) as pricetotal
                            , sum(billdetail_items.taxprice) as taxprice
                            , sum(billdetail_items.edittax) as edittax
                            , sum(billdetail_items.taxprice) + sum(billdetail_items.edittax) as taxtotal
                ";

            //入金日範囲が設定されている(かつ入金済みのみ抽出）
            if ((paymentDateFlg == true) && (isPaymentFlg == true))
            {
                sql += @"
                    from
                        billdetail_items
                        , payment
                ";
            }
            else
            {
                sql += @"
                    from
                        billdetail_items
                ";
            }

            //締め日指定
            sql += @"
                    where
                        billdetail_items.closedate between :strclosedate and :endclosedate
                ";

            //入金日範囲が設定されている(かつ入金済みのみ抽出）
            if ((paymentDateFlg == true) && (isPaymentFlg == true))
            {
                sql += @"
                    and payment.paymentdate between :strpaymentdate and :endpaymentdate 
                    and billdetail_items.closedate = payment.closedate 
                    and billdetail_items.billseq = payment.billseq 
                    and billdetail_items.branchno = payment.branchno
                ";
            }

            sql += @"
                group by
                    billdetail_items.closedate
                    , billdetail_items.billseq
                    , billdetail_items.branchno) sum_billdetail_items
                    --入金情報サマリ部分
                    , 
                    ( 
                        select
                            payment.closedate
                            , payment.billseq
                            , payment.branchno
                            , sum(payment.paymentprice) as sum_paymentprice 
                        from
                            payment 
                        where
                            payment.closedate between :strclosedate and :endclosedate
                ";

            //入金日範囲が設定されている(かつ入金済みのみ抽出）
            if ((paymentDateFlg == true) && (isPaymentFlg == true))
            {
                sql += @"
                        and payment.paymentdate between :strpaymentdate and :endpaymentdate
                ";
            }

            sql += @"
                    group by
                        payment.closedate
                        , payment.billseq
                        , payment.branchno) sum_payment

                        --入金管理部分
                        , ( 
                            select
                                payment.closedate
                                , payment.billseq
                                , payment.branchno
                                , payment.seq
                                , payment.paymentprice
                                , payment.paymentdiv
                                , payment.paymentdate
                                , payment.upduser
                                , hainsuser.username 
                            from
                                payment
                                , hainsuser 
                            where
                                payment.upduser = hainsuser.userid 
                                and payment.closedate between :strclosedate and :endclosedate
                ";

            //入金日範囲が設定されている(かつ入金済みのみ抽出）
            if ((paymentDateFlg == true) && (isPaymentFlg == true))
            {
                sql += @"
                        and payment.paymentdate between :strpaymentdate and :endpaymentdate
                ";
            }

            sql += @"
                    ) payment_view

                    --発送日最終レコード取得部分
                    , ( 
                        select
                            dispatch.closedate
                            , dispatch.billseq
                            , dispatch.branchno
                            , to_char(dispatch.dispatchdate, 'YYYY/MM/DD') as dispatchdate 
                        from
                            dispatch 
                        where
                            (closedate, billseq, branchno, seq) in ( 
                                select
                                    dispatch.closedate
                                    , dispatch.billseq
                                    , dispatch.branchno
                                    , max(dispatch.seq) as sum_paymentprice
                ";

            //入金日範囲が設定されている(かつ入金済みのみ抽出）
            if ((paymentDateFlg == true) && (isPaymentFlg == true))
            {
                sql += @"
                    from
                        dispatch
                        , payment
                ";
            }
            else
            {
                sql += @"
                    from
                        dispatch
                ";
            }

            //締め日指定
            sql += @"
                where
                    dispatch.closedate between :strclosedate and :endclosedate
                ";

            //入金日範囲が設定されている(かつ入金済みのみ抽出）
            if ((paymentDateFlg == true) && (isPaymentFlg == true))
            {
                sql += @"
                    and payment.paymentdate between :strpaymentdate and :endpaymentdate 
                    and dispatch.closedate = payment.closedate 
                    and dispatch.billseq = payment.billseq 
                    and dispatch.branchno = payment.branchno
                ";
            }

            sql += @"
                group by
                    dispatch.closedate
                    , dispatch.billseq
                    , dispatch.branchno)
                    ) last_dispatch 
                    , ( 
                        select
                            * 
                        from
                            free 
                        where
                            freeclasscd = :free_paymentdiv
                    ) free_paydiv

                --基本部分WHERE句
                where
                    sum_payment.closedate(+) = bill.closedate 
                    and sum_payment.billseq(+) = bill.billseq 
                    and sum_payment.branchno(+) = bill.branchno 
                    and last_dispatch.closedate(+) = bill.closedate 
                    and last_dispatch.billseq(+) = bill.billseq 
                    and last_dispatch.branchno(+) = bill.branchno 
                    and payment_view.closedate(+) = bill.closedate 
                    and payment_view.billseq(+) = bill.billseq 
                    and payment_view.branchno(+) = bill.branchno 
                    and sum_billdetail.closedate(+) = bill.closedate 
                    and sum_billdetail.billseq(+) = bill.billseq 
                    and sum_billdetail.branchno(+) = bill.branchno 
                    and bill.delflg = :delflg 
                    and bill.orgcd1 = org.orgcd1 
                    and bill.orgcd2 = org.orgcd2 
                    and sum_billdetail_items.closedate(+) = bill.closedate 
                    and sum_billdetail_items.billseq(+) = bill.billseq 
                    and sum_billdetail_items.branchno(+) = bill.branchno
                    and payment_view.paymentdiv = free_paydiv.freefield1(+) 
                ";

            //締め日指定
            sql += @"
                    and bill.closedate between :strclosedate and :endclosedate
                ";


            //入金日範囲が設定されている(かつ入金済みのみ抽出）
            if ((paymentDateFlg == true) && (isPaymentFlg == true))
            {
                sql += @"
                    and payment_view.paymentdate between :strpaymentdate and :endpaymentdate
                ";
            }

            //入金済みのみが設定されている
            if ( isPaymentFlg == true)
            {
                sql += @"
                    and nvl( 
                        sum_billdetail.pricetotal + sum_billdetail.taxtotal + nvl( 
                            sum_billdetail_items.pricetotal + sum_billdetail_items.taxtotal
                            , 0
                        ) - sum_payment.sum_paymentprice
                        , sum_billdetail.pricetotal + sum_billdetail.taxtotal + nvl( 
                            sum_billdetail_items.pricetotal + sum_billdetail_items.taxtotal
                            , 0
                        )
                    ) = 0
                ";
            }

            //未収のみが設定されている
            if (isNoPaymentFlg == true)
            {
                sql += @"
                    and nvl( 
                        sum_billdetail.pricetotal + sum_billdetail.taxtotal + nvl( 
                            sum_billdetail_items.pricetotal + sum_billdetail_items.taxtotal
                            , 0
                        ) - sum_payment.sum_paymentprice
                        , sum_billdetail.pricetotal + sum_billdetail.taxtotal + nvl( 
                            sum_billdetail_items.pricetotal + sum_billdetail_items.taxtotal
                            , 0
                        )
                    ) <> 0
                ";
            }

            //基本部分ORDER BY句
            sql += @"
                    order by
                ";


            //並び順選択できるように変更（「入金日＞入金種別＞請求番号」と「入金日＞入金種別＞団体カナ名称」中で選択）
            if (queryParams["sortkind"] == "1")
            {
                sql += @"
                    order_paymentdate
                    , payment_view.paymentdiv
                    , bill.closedate
                    , bill.billseq
                    , bill.branchno
                ";
            }
            else
            {
                sql += @"
                    order_paymentdate
                    , payment_view.paymentdiv
                    , org.orgkname
                ";
            }

            sql += @"
                    ) main_view) base_view
                ";


            // パラメータセット
            var sqlParam = new
            {
                strclosedate = queryParams["s_startymd"],
                endclosedate = queryParams["s_endymd"],
                strpaymentdate = queryParams["n_startymd"],
                endpaymentdate = queryParams["n_endymd"],

                orderPaymentdate = orderPaymentDate,
                free_paymentdiv = FREECLASSCD_PAYMENTDIV,

                delflg = DelFlg.Used
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">団体入金台帳データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var prtdateField = (CnDataField)cnObjects["txtDate"];
            var pageField = (CnDataField)cnObjects["txtPage"];
            var closedateListField = (CnListField)cnObjects["CLOSEDATE"];
            var billnoListField = (CnListField)cnObjects["BILLNO"];
            var orgknameListField = (CnListField)cnObjects["ORGKNAME"];
            var orgnameListField = (CnListField)cnObjects["ORGNAME"];
            var pricetotalListField = (CnListField)cnObjects["PRICETOTAL"];
            var taxtotalListField = (CnListField)cnObjects["TAXTOTAL"];
            var billtotalListField = (CnListField)cnObjects["BILLTOTAL"];
            var nopaymentpriceListField = (CnListField)cnObjects["NOPAYMENTPRICE"];
            var paymentdateListField = (CnListField)cnObjects["PAYMENTDATE"];
            var paymentpriceListField = (CnListField)cnObjects["PAYMENTPRICE"];
            var paymentdivListField = (CnListField)cnObjects["PAYMENTDIV"];
            var usernameListField = (CnListField)cnObjects["USERNAME"];
            var dispatchdateListField = (CnListField)cnObjects["DISPATCHDATE"];
            var keiListField = (CnListField)cnObjects["KEI"];

            string sysdate = DateTime.Today.ToShortDateString();

            int pageNo = 0;
            int outCnt = 0;

            // ページ内の項目に値をセット
            string newKey = "";
            string oldKey = "";
            string newKey2 = "";
            string oldKey2 = "";

            decimal priceTotal_KEI = 0;        //小計の小計
            decimal taxTotal_KEI = 0;          //消費税の小計
            decimal billTotal_KEI = 0;         //請求金額の小計
            decimal noPaymentPrice_KEI = 0;    //未収額の小計
            decimal paymentPrice_KEI = 0;      //入金額の小計

            short currentLine = 0;
            
            //キー設定
            if (data.Count > 0)
            {
                var firstData = data[0];

                //入金日
                if ( (Util.ConvertToString(firstData.PAYMENTDATE) != "") && (Util.ConvertToString(firstData.PAYMENTDATE) != "0"))
                {
                    newKey = Convert.ToString(firstData.PAYMENTDATE);
                }
                else
                {
                    newKey = "";
                }
                oldKey = newKey;

                //入金種別
                newKey2 = Util.ConvertToString(firstData.PAYMENTDIV).Trim() ?? "";
                oldKey2 = newKey2;
            }

            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                //キー退避
                //入金日
                if ((Util.ConvertToString(detail.PAYMENTDATE) != "") && (Util.ConvertToString(detail.PAYMENTDATE) != "0"))
                {
                    newKey = Convert.ToString(detail.PAYMENTDATE);
                }

                //入金種別
                newKey2 = Util.ConvertToString(detail.PAYMENTDIV).Trim() ?? "";

                // ページ内最大行に達した場合、改ページ
                if (currentLine == closedateListField.ListRows.Length  )
                {
                    pageNo++;

                    // 印刷日
                    prtdateField.Text = sysdate;

                    // ページ番号
                    pageField.Text = pageNo.ToString();

                    // ドキュメントの出力
                    PrintOut(cnForm);
                    
                    //現在編集行のリセット
                    currentLine = 0;

                    //キーブレイクによる改ページ処理
                    if ( newKey != oldKey)
                    {
                        oldKey = newKey;
                    }

                }

                //小計の編集（入金日または金種が変わったら小計を出力する）
                if ( (newKey != oldKey) || (newKey2 != oldKey2) )
                {

                    //小計行出力
                    keiListField.ListCell(0, currentLine).Text = "合計";
                    //小計
                    pricetotalListField.ListCell(0, currentLine).Text = priceTotal_KEI.ToString("#,##0");
                    //消費税
                    taxtotalListField.ListCell(0, currentLine).Text = taxTotal_KEI.ToString("#,##0");
                    //請求金額
                    billtotalListField.ListCell(0, currentLine).Text = billTotal_KEI.ToString("#,##0");
                    //未収額
                    nopaymentpriceListField.ListCell(0, currentLine).Text = noPaymentPrice_KEI.ToString("#,##0");
                    //入金額
                    paymentpriceListField.ListCell(0, currentLine).Text = paymentPrice_KEI.ToString("#,##0");

                    //キー設定
                    oldKey = newKey;
                    oldKey2 = newKey2;

                    //現在行をインクリメント
                    currentLine++;

                    // 件数をインクリメント
                    outCnt++;

                    //小計情報の初期化
                    priceTotal_KEI = 0;
                    taxTotal_KEI = 0;
                    billTotal_KEI = 0;
                    noPaymentPrice_KEI = 0;
                    paymentPrice_KEI = 0;

                    //改ページ処理
                    if (currentLine == closedateListField.ListRows.Length )
                    {
                        pageNo++;

                        // 印刷日
                        prtdateField.Text = sysdate;

                        // ページ番号
                        pageField.Text = pageNo.ToString();

                        // ドキュメントの出力
                        PrintOut(cnForm);

                        //現在編集行のリセット
                        currentLine = 0;

                        //キーブレイクによる改ページ処理
                        if (newKey != oldKey)
                        {
                            oldKey = newKey;
                        }

                    }


                }

                //締め日
                closedateListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.CLOSEDATE).Trim();

                //請求書№
                billnoListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.BILLNO).Trim();

                //団体カナ名
                orgknameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ORGKNAME).Trim();

                //団体名
                orgnameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ORGNAME).Trim();

                //小計
                decimal wkPriceTotal = detail.PRICETOTAL ?? 0;
                pricetotalListField.ListCell(0, currentLine).Text = wkPriceTotal.ToString("#,##0");

                //消費税
                decimal wkTaxTotal = detail.TAXTOTAL ?? 0;
                taxtotalListField.ListCell(0, currentLine).Text = wkTaxTotal.ToString("#,##0");

                //請求金額
                decimal billTotal = 0;
                billTotal = detail.BILLTOTAL ?? 0;
                billtotalListField.ListCell(0, currentLine).Text = billTotal.ToString("#,##0");

                //入金額
                decimal paymentPrice = 0;
                paymentPrice = detail.PAYMENTPRICE ?? 0;
                paymentpriceListField.ListCell(0, currentLine).Text = paymentPrice.ToString("#,##0");

                //未収額
                decimal noPaymentPrice = billTotal - paymentPrice;
                nopaymentpriceListField.ListCell(0, currentLine).Text = noPaymentPrice.ToString("#,##0");

                //入金日
                if ( (Util.ConvertToString(detail.PAYMENTDATE) != "") && Util.ConvertToString(detail.PAYMENTDATE) != "0")
                {
                    paymentdateListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.PAYMENTDATE);
                }
                else
                {
                    paymentdateListField.ListCell(0, currentLine).Text = "";
                }

                //入金種別
                if (detail.PAYMENTDIV != null)
                {
                    if ( Convert.ToString( detail.PAYMENTDIV ).Trim() != "0" )
                    {
                        paymentdivListField.ListCell(0, currentLine).Text = detail.PAYDIVNAME;
                    }
                }

                //処理担当
                usernameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.USERNAME).Trim() ?? "";

                //請求書発送日
                if ((Util.ConvertToString(detail.DISPATCHDATE) != "") && (Util.ConvertToString(detail.DISPATCHDATE) != "0"))
                {
                    dispatchdateListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.DISPATCHDATE);
                }
                else
                {
                    dispatchdateListField.ListCell(0, currentLine).Text = "";
                }

                //金種別小計
                priceTotal_KEI += wkPriceTotal;
                taxTotal_KEI += wkTaxTotal;
                billTotal_KEI += billTotal;
                noPaymentPrice_KEI += noPaymentPrice;
                paymentPrice_KEI += paymentPrice;

                //現在行をインクリメント
                currentLine++;

                // 件数をインクリメント
                outCnt++;

            }

            //終了処理
            //改ページ処理
            if (currentLine == closedateListField.ListRows.Length)
            {
                pageNo++;

                // 印刷日
                prtdateField.Text = sysdate;

                // ページ番号
                pageField.Text = pageNo.ToString();

                // ドキュメントの出力
                PrintOut(cnForm);

                //現在編集行のリセット
                currentLine = 0;

            }

            if (outCnt > 0)
            {
                pageNo++;

                // 印刷日
                prtdateField.Text = sysdate;

                // ページ番号
                pageField.Text = pageNo.ToString();

                //小計行出力
                keiListField.ListCell(0, currentLine).Text = "合計";
                //小計
                pricetotalListField.ListCell(0, currentLine).Text = priceTotal_KEI.ToString("#,##0");
                //消費税
                taxtotalListField.ListCell(0, currentLine).Text = taxTotal_KEI.ToString("#,##0");
                //請求金額
                billtotalListField.ListCell(0, currentLine).Text = billTotal_KEI.ToString("#,##0");
                //未収額
                nopaymentpriceListField.ListCell(0, currentLine).Text = noPaymentPrice_KEI.ToString("#,##0");
                //入金額
                paymentpriceListField.ListCell(0, currentLine).Text = paymentPrice_KEI.ToString("#,##0");
                
                // ドキュメントの出力
                PrintOut(cnForm);

                //現在編集行のリセット
                currentLine = 0;

            }

        }

    }
}
