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
    /// 団体請求書生成クラス
    /// </summary>
    public class OrgBillCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "000310";

        /// <summary>
        /// 請求　二次検査フラグ
        /// </summary>
        private const string BILL_SECONDFLG = "1";

        /// <summary>
        /// 汎用コード
        /// </summary>
        private const string FREECD_CSCD = "LST00031%";     //対象コース

        /// <summary>
        /// セットコード
        /// </summary>
        private const string SETCLASS_LIMIT = "LIMIT";

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            string wkStaDate = queryParams["startdate"];
            string wkEndDate = queryParams["enddate"];

            DateTime wkDate;

            //入力チェック
            if (!DateTime.TryParse(wkStaDate, out wkDate))
            {
                messages.Add("開始日が正しくありません。");
            }

            if (!DateTime.TryParse(wkEndDate, out wkDate))
            {
                messages.Add("終了日が正しくありません。");
            }

            //請求番号チェック　※桁数誤りでエラーになるため追加
            string billno = queryParams["billno"].Trim();
            if (!string.IsNullOrEmpty(billno))
            {
                if (billno.Length != 14 )
                {
                    //以外はエラー
                    messages.Add("請求番号が正しくありません。");
                }
            }

            return messages;
        }

        /// <summary>
        /// 団体請求書データを読み込む
        /// </summary>
        /// <returns>団体請求書データ</returns>
        protected override List<dynamic> GetData()
        {

            string sql = @"
                select
                    bill.orgcd1
                    , bill.orgcd2
                    , bill.prtdate
                    , bill.closedate
                    , bill.billseq
                    , bill.branchno
                    , billdetail.lastname
                    , billdetail.firstname
                    , billdetail.detailname
                    , billdetail.csldate
                    , billdetail.dayid
                    , billdetail.rsvno
                    , (billdetail.price + billdetail.editprice) price
                    , (billdetail.taxprice + billdetail.edittax) tax
                    , org.billcsldiv
                    , org.billins
                    , org.billempno
                    , pref.prefname
                    , orgaddr.zipcd
                    , orgaddr.orgname addorgname
                    
                    --請求用団体名称がヌルの場合、団体名称を印刷
                    , decode( 
                        org.orgbillname
                        , null
                        , org.orgname
                        , org.orgbillname
                    ) orgname
                    , orgaddr.cityname
                    , orgaddr.address1
                    , orgaddr.address2
                    , orgaddr.chargepost
                    , orgaddr.chargename
                    , consult.isrsign
                    , consult.isrno
                    , consult.empno
                    , trunc(consult.age) age
                    , org.billage
                    , org.billreport
                    , billdetail.perid
                    , bill.secondflg
                    , billdetail.lineno
                    , ( 
                        select
                            nvl( 
                                sum(a.price + a.editprice + a.taxprice + a.edittax)
                                , 0
                            ) 
                        from
                            billdetail a 
                        where
                            a.closedate = bill.closedate 
                            and a.billseq = bill.billseq 
                            and a.branchno = bill.branchno
                    ) totalprice
                    , ( 
                        select
                            nvl(sum(a.taxprice + a.edittax), 0) 
                        from
                            billdetail a 
                        where
                            a.closedate = bill.closedate 
                            and a.billseq = bill.billseq 
                            and a.branchno = bill.branchno
                    ) totaltax
                    , ( 
                        select
                            nvl(count(distinct rsvno), 0) 
                        from
                            billdetail a 
                        where
                            a.closedate = bill.closedate 
                            and a.billseq = bill.billseq 
                            and a.branchno = bill.branchno
                    ) cslcnt
                    , ( 
                        select
                            nvl(count(distinct perid), 0) 
                        from
                            billdetail a 
                        where
                            a.closedate = bill.closedate 
                            and a.billseq = bill.billseq 
                            and a.branchno = bill.branchno
                    ) cslcnt2
                    , consult.billprint
                    , consult.isrno
                    , decode(free.freefield1, null, '0', free.freefield1) freefield1 
                from
                    bill
                    , billdetail
                    , org
                    , orgaddr
                    , consult
                    , free
                    , pref 
                where
                    bill.orgcd1 = org.orgcd1 
                    and bill.orgcd2 = org.orgcd2 

                    --特定団体に限って限度額負担金の内訳を印刷できるように
                    and 'LO' || org.orgcd1 || org.orgcd2 = free.freecd(+) 

                    and org.orgcd1 = orgaddr.orgcd1(+) 
                    and org.orgcd2 = orgaddr.orgcd2(+) 
                    and org.billaddress = orgaddr.addrdiv(+) 
                    and orgaddr.prefcd = pref.prefcd(+) 
                    and bill.closedate = billdetail.closedate 
                    and bill.billseq = billdetail.billseq 
                    and bill.branchno = billdetail.branchno 
                    and billdetail.rsvno = consult.rsvno(+) 
               ";

            ///団体コード１
            if (queryParams["orgcd1"] != "")
            {
                sql += @"
                    and bill.orgcd1 = :orgcd1 
                ";
            }

            ///団体コード２
            if (queryParams["orgcd2"] != "")
            {
                sql += @"
                    and bill.orgcd2 = :orgcd2 
                ";
            }

            ///請求書番号指定
            string closeDate = "";
            decimal billSeq = 0;
            decimal branchNo = 0;

            string billno = queryParams["billno"].Trim();
            if (billno != "")
            {
                closeDate = billno.Substring(0, 4) + "/" + billno.Substring(4, 2) + "/" + billno.Substring(6, 2);
                decimal.TryParse(billno.Substring(8, 5), out billSeq);
                decimal.TryParse(billno.Substring(13, 1), out branchNo);

                sql += @"
                    and bill.closedate = :closedate 
                    and bill.billseq = :billseq 
                    and bill.branchno = :branchno 
                ";
            }
            else
            {
                sql += @"
                    and bill.closedate >= :startdate 
                    and bill.closedate <= :enddate 
                ";
            }

            ///出力対象
            if (queryParams["object"] == "2")
            {
                sql += @"
                    and bill.prtdate is null 
                ";
            }
            else if (queryParams["object"] == "3")
            {
                sql += @"
                    and bill.prtdate is not null 
                ";
            }

            ///取り消し伝票
            if (queryParams["delflg"] != "1")
            {
                sql += @"
                    and bill.delflg = :delflg 
                ";
            }

            ///区分
            if ( queryParams["kbn"] == "0")
            {
                sql += @"
                    and bill.secondflg is null 
                ";
            }
            else if (queryParams["kbn"] == "1")
            {
                sql += @"
                    and bill.secondflg = :secondflg
                ";
            }

            ///ソート
            sql += @"
                order by
                    bill.orgcd1
                    , bill.orgcd2
                    , bill.closedate
                    , bill.billseq
                    , bill.branchno
                    , billdetail.csldate
                    , billdetail.dayid
                    , billdetail.lineno

                ";

            //請求日
            DateTime.TryParse(queryParams["startdate"], out DateTime dSdate);
            DateTime.TryParse(queryParams["enddate"], out DateTime dEdate);

            // 開始日より終了日が過去であれば値を交換
            if (dSdate > dEdate)
            {
                DateTime wkDate = dSdate;
                dSdate = dEdate;
                dEdate = wkDate;
            }

            // パラメータセット
            var sqlParam = new
            {
                orgcd1 = queryParams["orgcd1"],
                orgcd2 = queryParams["orgcd2"],
                closedate = closeDate,
                billseq = billSeq,
                branchno = branchNo,
                startdate = dSdate,
                enddate = dEdate,

                delflg = DelFlg.Used,
                secondflg = BILL_SECONDFLG,
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">団体請求書データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {

            //ページ設定
            CnForm cnForm = cnForms[0];
            CnForm cnForm2 = cnForms[1];
            CnForm cnForm3 = cnForms[2];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;
            CnObjects cnObjects2 = cnForm2.CnObjects;
            CnObjects cnObjects3 = cnForm3.CnObjects;

            // フォームの各項目を変数にセット
            // １ページ目
            var orgnameField = (CnDataField)cnObjects["ORGNAME"];
            var zipcdField = (CnDataField)cnObjects["ZIPCD"];
            var citynameField = (CnDataField)cnObjects["CITYNAME"];
            var address1Field = (CnDataField)cnObjects["ADDRESS1"];
            var address2Field = (CnDataField)cnObjects["ADDRESS2"];
            var orgname2Field = (CnDataField)cnObjects["ORGNAME2"];
            var chargepostField = (CnDataField)cnObjects["CHARGEPOST"];
            var chargenameField = (CnDataField)cnObjects["CHARGENAME"];
            var barbillnoField = (CnBarcodeField)cnObjects["BARBILLNO"];
            var billnoField = (CnDataField)cnObjects["BILLNO"];
            var billno2Field = (CnDataField)cnObjects["BILLNO2"];
            var closedateField = (CnDataField)cnObjects["CLOSEDATE"];
            var orgname3Field = (CnDataField)cnObjects["ORGNAME3"];
            var totalField = (CnDataField)cnObjects["TOTAL"];
            var taxField = (CnDataField)cnObjects["TAX"];
            var closemonthField = (CnDataField)cnObjects["CLOSEMONTH"];
            var pageField = (CnDataField)cnObjects["PAGE"];
            var billnoteTextField = (CnTextField)cnObjects["TXTBILLNOTE"];
            var lblbillnoteText = (CnText)cnObjects["LBLBILLNOTE"];

            //２ページ目
            var orgname4Field = (CnDataField)cnObjects2["ORGNAME"];
            var billno3Field = (CnDataField)cnObjects2["BILLNO"];
            var closedate2Field = (CnDataField)cnObjects2["CLOSEDATE"];
            var cslcntField = (CnDataField)cnObjects2["CSLCNT"];
            var nameListField = (CnListField)cnObjects2["NAME"];
            var csldateListField = (CnListField)cnObjects2["CSLDATE"];
            var dayidListField = (CnListField)cnObjects2["DAYID"];
            var csnameListField = (CnListField)cnObjects2["CSNAME"];
            var subtotalListField = (CnListField)cnObjects2["SUBTOTAL"];
            var tax2ListField = (CnListField)cnObjects2["TAX"];
            var sonotaListField = (CnListField)cnObjects2["SONOTA"];
            var page2Field = (CnDataField)cnObjects2["PAGE"];

            //３ページ目
            var orgname5Field = (CnDataField)cnObjects3["ORGNAME"];
            var name2Field = (CnDataField)cnObjects3["NAME"];
            var peridField = (CnDataField)cnObjects3["PERID"];
            var csldate2Field = (CnDataField)cnObjects3["CSLDATE"];
            var d_csldateField = (CnDataField)cnObjects3["D_CSLDATE"];
            var secondlinedivnameListField = (CnListField)cnObjects3["SECONDLINEDIVNAME"];
            var priceListField = (CnListField)cnObjects3["PRICE"];
            var subtotal2Field = (CnDataField)cnObjects3["SUBTOTAL"];
            var tax3Field = (CnDataField)cnObjects3["TAX"];
            var total2Field = (CnDataField)cnObjects3["TOTAL"];

            string sysdate = DateTime.Today.ToShortDateString();

            int pageNo = 0;
            int outCnt = 0;

            //キー設定
            var firstdata = data[0];

            string newKey = firstdata.CLOSEDATE.ToString("yyyyMMdd") + (firstdata.BILLSEQ).ToString("00000") + firstdata.BRANCHNO;
            string oldKey = "";

            string newRsvNo = "";   //改ページキー
            string oldRsvNo = "";   //改ページキー（前行）

            //請求番号
            string billNo = newKey;

            short lineCnt = 0;
            short currentLine = 0;

            //受診日ワーク
            string d_CslDate = "";  //ドック受診日
            string cslDate1 = "";   //受診日

            //合計
            decimal price = 0;      //金額（２次検査用）
            decimal subTotal = 0;   //合計金額（２次検査用）
            decimal tax2 = 0;       //消費税（２次検査用）
            decimal total2 = 0;     //総合計（２次検査用）

            decimal price2 = 0;     //金額（計算用）
            decimal subTotal2 = 0;  //合計金額（計算用）
            decimal tax3 = 0;       //消費税（計算用）
            decimal taxTotal = 0;   //合計消費税（計算用）

            string oldCslDate = "";

            int cnt = 0;

            //印刷団体変更時（改ページ時）退避用フィールド
            string headerOrgName = ""; //団体名
            string cslCntStr = ""; //受診人数
            string headerBillNo2 = ""; //請求書No
            string headerCloseDate = ""; //締め日

            string cslCnt2Str = "";    //受診人数（２次検査）
            string secondFlg2 = ""; //２次検査フラグ

            //３枚目用
            List<string> secondFlgList = new List<string>();
            List<string> orgNameList = new List<string>();
            List<string> cslDate2List = new List<string>();
            List<string> perId2List = new List<string>();
            List<string> closeDateList = new List<string>();
            List<string> billseqList = new List<string>();
            List<string> branchnoList = new List<string>();
            List<string> linenoList = new List<string>();

            DateTime wkCsldate;

            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                //改ページ判定用キー設定
                newKey = detail.CLOSEDATE.ToString("yyyyMMdd") + (detail.BILLSEQ).ToString("00000") + detail.BRANCHNO;

                newRsvNo = detail.RSVNO + "-" + detail.PERID;

                //最大行印刷、もしくはキーが変わった場合（１枚目以外）は明細行を印字する。
                if ( ((currentLine == nameListField.ListRows.Length) || (newKey != oldKey)) && (outCnt > 0) )
                {
                    //２枚目のヘッダ部
                    orgname4Field.Text = headerOrgName;         //請求団体名
                    billno3Field.Text = headerBillNo2;          //請求書番号
                    closedate2Field.Text = headerCloseDate;     //締め日
                    if (secondFlg2.Trim() == "1")
                    {
                        cslcntField.Text = cslCnt2Str;             //人数
                    }
                    else
                    {
                        cslcntField.Text = cslCntStr;              //人数
                    }
                    //ページ
                    pageNo++;
                    page2Field.Text = pageNo.ToString();

                    // ドキュメントの出力
                    PrintOut(cnForm2);

                    //現在行のリセット
                    currentLine = 0;

                    //改ページした場合には、１行目に名称印字
                    oldRsvNo = "";

                }

                //前回とキーが異なるなら、表題ページ印刷
                if (newKey != oldKey)
                {
                    if ( outCnt != 0 )
                    {
                        for ( int i = cnt; i <= outCnt -1; i++ )
                        {
                            if ( secondFlgList[i] == "1")
                            {
                                //データ取得
                                cslDate1 = cslDate2List[i].Trim();

                                //名前が空白だった場合読み飛ばし
                                dynamic ret2 = null;
                                if ( perId2List[i].Trim() != "")
                                {
                                    //受診データ取得
                                    ret2 = GetD_Date(cslDate1, perId2List[i].Trim());
                                }

                                var ret3 = GetData2(cslDate1, perId2List[i].Trim(), closeDateList[i], billseqList[i], branchnoList[i], linenoList[i]);

                                if (ret3.Count > 0)
                                {
                                    //３枚目対象データあり
                                    if ( ret2 != null )
                                    {
                                        //受診データあり

                                        //ドック利用年月
                                        DateTime.TryParse( Util.ConvertToString(ret2.CSLDATE), out wkCsldate);

                                        d_csldateField.Text = WebHains.EraDateFormat(wkCsldate, "ggyy年M月d日");

                                    }
                                    else
                                    {
                                        d_csldateField.Text = "";
                                    }

                                    price = 0;
                                    subTotal = 0;
                                    tax2= 0;
                                    total2 = 0;
                                    lineCnt = 0;

                                    //３枚目のヘッダ部
                                    var ret3_firstData = ret3[0];

                                    //請求団体名
                                    orgname5Field.Text = orgNameList[i] + "　御中";

                                    //名前
                                    name2Field.Text = Util.ConvertToString(ret3_firstData.LASTNAME) + "　" + Util.ConvertToString(ret3_firstData.FIRSTNAME) + "　様";
                                    peridField.Text = Util.ConvertToString(ret3_firstData.PERID);

                                    //受診日
                                    DateTime.TryParse(Util.ConvertToString(ret3_firstData.CSLDATE), out wkCsldate);
                                    csldate2Field.Text = WebHains.EraDateFormat(wkCsldate, "ggyy年M月d日");

                                    //編集処理開始
                                    foreach ( var ret3data in ret3)
                                    {
                                        //最大行の場合
                                        if (lineCnt == secondlinedivnameListField.ListRows.Length )
                                        {
                                            if (total2 == 0)
                                            {
                                                total2 = subTotal + tax2;
                                            }
                                            else
                                            {
                                                total2 = subTotal + tax2 + total2;
                                            }

                                            subtotal2Field.Text = subTotal.ToString("#,##0");
                                            tax3Field.Text = tax2.ToString("#,##0");
                                            total2Field.Text = total2.ToString("#,##0");

                                            // ドキュメントの出力
                                            PrintOut(cnForm3);

                                            price = 0;
                                            subTotal = 0;
                                            tax2 = 0;
                                            lineCnt = 0;

                                            //３枚目のヘッダ部
                                            //請求団体名
                                            orgname5Field.Text = orgNameList[i] + "　御中";

                                            if (ret2 != null)
                                            {
                                                d_csldateField.Text = d_CslDate;
                                            }
                                            else
                                            {
                                                d_csldateField.Text = "";
                                            }

                                            //名前
                                            name2Field.Text = Util.ConvertToString(ret3data.LASTNAME) + "　" + Util.ConvertToString(ret3data.FIRSTNAME) + "　様";   
                                            peridField.Text = Util.ConvertToString(ret3data.PERID).Trim();

                                            //受診日
                                            DateTime.TryParse(Util.ConvertToString(ret3data.CSLDATE), out wkCsldate);
                                            csldate2Field.Text = WebHains.EraDateFormat(wkCsldate, "ggyy年M月d日");

                                        }

                                        decimal.TryParse(Util.ConvertToString(ret3data.PRICE), out decimal wkPrice);
                                        decimal.TryParse(Util.ConvertToString(ret3data.EDITPRICE), out decimal wkEditPrice);
                                        decimal.TryParse(Util.ConvertToString(ret3data.TAXPRICE), out decimal wkTax);
                                        decimal.TryParse(Util.ConvertToString(ret3data.EDITTAX), out decimal wkEditTax);

                                        secondlinedivnameListField.ListCell(0, lineCnt).Text = Util.ConvertToString(ret3data.SECONDLINEDIVNAME).Trim();
                                        if (wkPrice != 0 || wkEditPrice != 0)
                                        {
                                            price = wkPrice + wkEditPrice;
                                            priceListField.ListCell(0, lineCnt).Text = price.ToString("#,##0");
                                            subTotal = subTotal + price;
                                        }
                                        else
                                        {
                                            priceListField.ListCell(0, lineCnt).Text = "";
                                        }
                                        if (wkTax != 0 || wkEditTax != 0)
                                        {
                                            tax2 = tax2 + wkTax + wkEditTax;
                                        }

                                        //行インクリメント
                                        lineCnt++;
                                    }

                                    //合計計算
                                    if (total2 == 0)
                                    {
                                        total2 = subTotal + tax2;
                                    }
                                    else
                                    {
                                        total2 = subTotal + tax2 + total2;
                                    }

                                    //合計出力
                                    subtotal2Field.Text = subTotal.ToString("#,##0");
                                    tax3Field.Text = tax2.ToString("#,##0");
                                    total2Field.Text = total2.ToString("#,##0");

                                    // ドキュメントの出力
                                    PrintOut(cnForm3);

                                }

                            }

                            cnt++;

                        }

                    }

                    //請求番号
                    billNo = detail.CLOSEDATE.ToString("yyyyMMdd") + (detail.BILLSEQ).ToString("00000") + detail.BRANCHNO;

                    headerOrgName = Util.ConvertToString(detail.ORGNAME).Trim();
                    cslCntStr = Util.ConvertToString(detail.CSLCNT);
                    cslCnt2Str = Util.ConvertToString(detail.CSLCNT2);
                    if (Util.ConvertToString(detail.SECONDFLG).Trim() == "1")
                    {
                        secondFlg2 = Util.ConvertToString(detail.SECONDFLG);
                    }
                    else
                    {
                        secondFlg2 = "";
                    }
                    headerBillNo2 = "No." + billNo;
                    DateTime.TryParse(Util.ConvertToString(detail.CLOSEDATE), out DateTime wkClosedate);
                    headerCloseDate = WebHains.EraDateFormat(wkClosedate, "ggyy年M月d日");

                    orgnameField.Text = headerOrgName;
                    zipcdField.Text = "〒" + Convert.ToString(detail.ZIPCD).Substring(0, 3) + "-" + Convert.ToString(detail.ZIPCD).Substring(3, 4);
                    citynameField.Text = Util.ConvertToString(detail.PREFNAME).Trim() + Util.ConvertToString(detail.CITYNAME).Trim();
                    address1Field.Text = Util.ConvertToString(detail.ADDRESS1).Trim();
                    address2Field.Text = Util.ConvertToString(detail.ADDRESS2).Trim();
                    orgname2Field.Text = Util.ConvertToString(detail.ADDORGNAME).Trim();
                    chargepostField.Text = Util.ConvertToString(detail.CHARGEPOST).Trim();
                    chargenameField.Text = Util.ConvertToString(detail.CHARGENAME).Trim() + "　様";
                    barbillnoField.Data = "A" + billNo + "A";
                    billnoField.Text = "A" + billNo + "A";
                    billno2Field.Text = headerBillNo2;
                    closedateField.Text = headerCloseDate;
                    orgname3Field.Text = headerOrgName + "　御中";

                    if (Util.ConvertToString(detail.SECONDFLG).Trim() == "1")
                    {
                        var ret4 = GetData3(detail.CLOSEDATE, Util.ConvertToString(detail.BILLSEQ), Util.ConvertToString(detail.BRANCHNO));
                        if (ret4.Count > 0)
                        {
                            subTotal2 = 0;
                            taxTotal = 0;
                            foreach (var ret4data in ret4)
                            {
                                decimal.TryParse(Util.ConvertToString(ret4data.PRICE), out decimal wkPrice);
                                decimal.TryParse(Util.ConvertToString(ret4data.EDITPRICE), out decimal wkEditPrice);
                                decimal.TryParse(Util.ConvertToString(ret4data.TAXPRICE), out decimal wkTax);
                                decimal.TryParse(Util.ConvertToString(ret4data.EDITTAX), out decimal wkEditTax);

                                if (wkPrice != 0 || wkEditPrice != 0)
                                {
                                    price2 = wkPrice + wkEditPrice;
                                    subTotal2 = subTotal2 + price2;
                                }
                                if (wkTax != 0 || wkEditTax != 0)
                                {
                                    tax3 = wkTax + wkEditTax;
                                    taxTotal = taxTotal + tax3;
                                }
                            }
                        }
                        subTotal2 = subTotal2 + taxTotal;
                        totalField.Text = subTotal2.ToString("#,##0");
                        taxField.Text = taxTotal.ToString("#,##0");
                    }
                    else
                    {
                        decimal.TryParse(Util.ConvertToString(detail.TOTALPRICE), out decimal wkTotalPrice);
                        decimal.TryParse(Util.ConvertToString(detail.TOTALTAX), out decimal wkTotalTax);

                        totalField.Text = wkTotalPrice.ToString("#,##0");
                        taxField.Text = wkTotalTax.ToString("#,##0");
                    }

                    DateTime.TryParse(Util.ConvertToString(detail.CLOSEDATE), out DateTime wkCloseDate);
                    closemonthField.Text = WebHains.EraDateFormat(wkClosedate, "ggyy年M月分");
                    pageNo = 1;
                    pageField.Text = pageNo.ToString();

                    string billNote = queryParams["billnote"].Trim();
                    if (billNote.Trim() != "")
                    {
                        billnoteTextField.Text = billNote;
                    }
                    else
                    {
                        lblbillnoteText.Visible = true;
                        billnoteTextField.Visible = false;
                    }

                    //ドキュメントの出力
                    PrintOut(cnForm);

                    //キー設定
                    oldKey = newKey;
                    oldRsvNo = "";

                }

                //前行と同じ受診者ならグループインディケイトする
                if (oldRsvNo != newRsvNo)
                {
                    //名前
                    nameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.LASTNAME) + "　" + Util.ConvertToString(detail.FIRSTNAME);
                    //受診日
                    DateTime.TryParse(Util.ConvertToString(detail.CSLDATE), out wkCsldate);
                    csldateListField.ListCell(0, currentLine).Text = wkCsldate.ToString("MM/dd");
                    //当日ＩＤ
                    dayidListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.DAYID).Trim();
                }
                else
                {
                    //名前
                    nameListField.ListCell(0, currentLine).Text = "";

                    //日付が違う場合、受診日と当日IDを両方出力する
                    if ((Util.ConvertToString(detail.CSLDATE).Trim()) != "" && (Util.ConvertToString(detail.CSLDATE).Trim() != oldCslDate))
                    {
                        //受診日
                        DateTime.TryParse(Util.ConvertToString(detail.CSLDATE), out wkCsldate);
                        csldateListField.ListCell(0, currentLine).Text = wkCsldate.ToString("MM/dd");
                        ////当日ＩＤ
                        dayidListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.DAYID).Trim();
                    }
                    else
                    {
                        csldateListField.ListCell(0, currentLine).Text = "";
                        dayidListField.ListCell(0, currentLine).Text = "";
                    }
                }


                //特定団体に限って限度額負担金の内訳を印刷
                string limitName = "";

                if (Util.ConvertToString(detail.DETAILNAME).Trim() == "限度額負担" )
                {
                    if (Util.ConvertToString(detail.FREEFIELD1).Trim() != "0")
                    {
                        //## 限度額負担内訳取得
                        var ret6 = GetD_Limit(detail.RSVNO);
                        if (ret6.Count > 0)
                        {
                            limitName = "限度額(";

                            foreach (var ret6data in ret6)
                            {
                                if (Util.ConvertToString(ret6data.FREEFIELD1).Trim() != "")
                                {
                                    if (limitName != "限度額(")
                                    {
                                        limitName = limitName + "," + Util.ConvertToString(ret6data.FREEFIELD1).Trim();
                                    }
                                    else
                                    {
                                        limitName = limitName + Util.ConvertToString(ret6data.FREEFIELD1).Trim();
                                    }
                                }
                            }
                            limitName = limitName + ")";
                            csnameListField.ListCell(0, currentLine).Text = limitName;
                        }
                        else
                        {
                            //コース名
                            csnameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.DETAILNAME).Trim();
                        }
                    }
                    else
                    {
                        //コース名
                        csnameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.DETAILNAME).Trim();
                    }

                }
                else
                {
                    csnameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.DETAILNAME).Trim();
                }


                //２次明細の金額加算処理
                if (Util.ConvertToString(detail.SECONDFLG).Trim() == "1")
                {
                    var ret3 = GetData2(Util.ConvertToString(detail.CSLDATE), Util.ConvertToString(detail.PERID), Util.ConvertToString(detail.CLOSEDATE), Util.ConvertToString(detail.BILLSEQ), Util.ConvertToString(detail.BRANCHNO), Util.ConvertToString(detail.LINENO));
                    price = 0;
                    subTotal = 0;
                    tax2 = 0;
                    if (ret3.Count > 0)
                    {
                        foreach (var ret3data in ret3)
                        {
                            decimal.TryParse(Util.ConvertToString(ret3data.PRICE), out decimal wkPrice);
                            decimal.TryParse(Util.ConvertToString(ret3data.EDITPRICE), out decimal wkEditPrice);
                            decimal.TryParse(Util.ConvertToString(ret3data.TAXPRICE), out decimal wkTax);
                            decimal.TryParse(Util.ConvertToString(ret3data.EDITTAX), out decimal wkEditTax);

                            if ( wkPrice != 0 || wkEditPrice != 0 )
                            {
                                price = wkPrice + wkEditPrice;
                                subTotal = subTotal + price;
                            }

                            if ( wkTax != 0 || wkEditTax != 0 )
                            {
                                tax2 = tax2 + wkTax + wkEditTax;
                            }
                        }
                    }
                    //受診料金＋消費税
                    subtotalListField.ListCell(0, currentLine).Text = (subTotal + tax2).ToString("#,##0");

                }
                else
                {
                    decimal.TryParse(Util.ConvertToString(detail.PRICE), out decimal wkPrice);
                    decimal.TryParse(Util.ConvertToString(detail.TAX), out decimal wkTax);

                    //受診料金＋消費税
                    subtotalListField.ListCell(0, currentLine).Text = (wkPrice + wkTax).ToString("#,##0");
                }

                //備考欄編集
                string sonota = "";
                if (Util.ConvertToString(detail.SECONDFLG).Trim() == "1")
                {
                    //## 2次検査請求の場合
                    var ret5 = GetD_ISR(detail.CSLDATE, Util.ConvertToString(detail.PERID));
                    if (ret5 != null)
                    {
                        //本人家族出力判断
                        if (detail.BILLCSLDIV == 1)
                        {
                            switch (Util.ConvertToString(ret5.BILLPRINT))
                            {
                                case "1":
                                    sonota = sonota + "本人" + " ";
                                    break;
                                case "2":
                                    sonota = sonota + "家族" + " ";
                                    break;
                            }
                        }

                        if (detail.BILLINS == 1)
                        {
                            sonota += ret5.ISRSIGN + " " + ret5.ISRNO + " ";
                        }
                        if (detail.BILLEMPNO == 1)
                        {
                            sonota += ret5.EMPNO + " ";
                        }
                        if (detail.BILLAGE == 1)
                        {
                            //明細の備考欄に年齢を追加表記
                            sonota += Util.ConvertToString(ret5.AGE) + "歳";
                        }
                    }

                }
                else
                {
                    //## 1次検査請求の場合
                    //本人家族出力判断
                    if (detail.BILLCSLDIV == 1)
                    {
                        switch (Util.ConvertToString(detail.BILLPRINT))
                        {
                            case "1":
                                sonota = sonota + "本人" + " ";
                                break;
                            case "2":
                                sonota = sonota + "家族" + " ";
                                break;
                        }
                    }

                    if (detail.BILLINS == 1)
                    {
                        sonota = sonota + detail.ISRSIGN + " " + detail.ISRNO + " ";
                    }
                    if (detail.BILLEMPNO == 1)
                    {
                        sonota = sonota + detail.EMPNO + " ";
                    }
                    if (detail.BILLAGE == 1)
                    {
                        //明細の備考欄に年齢を追加表記
                        sonota = sonota + Util.ConvertToString(detail.AGE) + "歳";
                    }

                }
                sonotaListField.ListCell(0, currentLine).Text = sonota;


                //３枚目の引数の配列への格納
                if (Util.ConvertToString(detail.SECONDFLG).Trim() == "1")
                {
                    secondFlgList.Add(Util.ConvertToString(detail.SECONDFLG));
                }
                else
                {
                    secondFlgList.Add("");
                }
                orgNameList.Add(headerOrgName);
                cslDate2List.Add(Util.ConvertToString(detail.CSLDATE));
                perId2List.Add(Util.ConvertToString(detail.PERID));
                closeDateList.Add(Util.ConvertToString(detail.CLOSEDATE));
                billseqList.Add(Util.ConvertToString(detail.BILLSEQ));
                branchnoList.Add(Util.ConvertToString(detail.BRANCHNO));
                linenoList.Add(Util.ConvertToString(detail.LINENO));

                oldCslDate = Util.ConvertToString(detail.CSLDATE).Trim();
                        
                // 行カウントをインクリメント
                currentLine++;

                // データカウントアップ
                outCnt++;

                // キー退避
                oldRsvNo = newRsvNo;

            }

            //終了処理
            if ( currentLine > 0)
            {
                //２枚目のヘッダ部
                orgname4Field.Text = headerOrgName;         //請求団体名
                billno3Field.Text = headerBillNo2;          //請求書番号
                closedate2Field.Text = headerCloseDate;     //締め日
                if (secondFlg2.Trim() == "1")
                {
                    cslcntField.Text = cslCnt2Str;             //人数
                }
                else
                {
                    cslcntField.Text = cslCntStr;              //人数
                }
                //ページ
                pageNo++;
                page2Field.Text = pageNo.ToString();

                // ドキュメントの出力
                PrintOut(cnForm2);

                //現在行のリセット
                currentLine = 0;

            }

            //３枚目の帳票の出力判定
            for( int i = cnt; i <= (outCnt - 1); i++)
            {
                if (secondFlgList[i] == "1")
                {
                    //データ取得
                    cslDate1 = cslDate2List[i].Trim();

                    //名前が空白だった場合読み飛ばし
                    dynamic ret2 = null;
                    if (perId2List[i].Trim() != "")
                    {
                        //受診データ取得
                        ret2 = GetD_Date(cslDate1, perId2List[i].Trim());
                    }

                    var ret3 = GetData2(cslDate1, perId2List[i].Trim(), closeDateList[i], billseqList[i], branchnoList[i], linenoList[i]);

                    if (ret3.Count > 0)
                    {
                        //３枚目対象データあり
                        if (ret2 != null)
                        {
                            //受診データあり

                            //ドック利用年月
                            DateTime.TryParse(Util.ConvertToString(ret2.CSLDATE), out wkCsldate);

                            d_csldateField.Text = WebHains.EraDateFormat(wkCsldate, "ggyy年M月d日");

                        }
                        else
                        {
                            d_csldateField.Text = "";
                        }

                        price = 0;
                        subTotal = 0;
                        tax2 = 0;
                        total2 = 0;
                        lineCnt = 0;

                        //３枚目のヘッダ部
                        var ret3_firstData = ret3[0];

                        //請求団体名
                        orgname5Field.Text = orgNameList[i] + "　御中";

                        //名前
                        name2Field.Text = Util.ConvertToString(ret3_firstData.LASTNAME) + "　" + Util.ConvertToString(ret3_firstData.FIRSTNAME) + "　様";
                        peridField.Text = Util.ConvertToString(ret3_firstData.PERID);

                        //受診日
                        DateTime.TryParse(Util.ConvertToString(ret3_firstData.CSLDATE), out wkCsldate);
                        csldate2Field.Text = WebHains.EraDateFormat(wkCsldate, "ggyy年M月d日");

                        //編集処理開始
                        foreach (var ret3data in ret3)
                        {
                            //最大行の場合
                            if (lineCnt == secondlinedivnameListField.ListRows.Length)
                            {
                                if (total2 == 0)
                                {
                                    total2 = subTotal + tax2;
                                }
                                else
                                {
                                    total2 = subTotal + tax2 + total2;
                                }

                                subtotal2Field.Text = subTotal.ToString("#,##0");
                                tax3Field.Text = tax2.ToString("#,##0");
                                total2Field.Text = total2.ToString("#,##0");

                                // ドキュメントの出力
                                PrintOut(cnForm3);

                                price = 0;
                                subTotal = 0;
                                tax2 = 0;
                                lineCnt = 0;

                                //３枚目のヘッダ部
                                //請求団体名
                                orgname5Field.Text = orgNameList[i] + "　御中";

                                if (ret2 != null)
                                {
                                    d_csldateField.Text = d_CslDate;
                                }
                                else
                                {
                                    d_csldateField.Text = "";
                                }

                                //名前
                                name2Field.Text = Util.ConvertToString(ret3data.LASTNAME) + "　" + Util.ConvertToString(ret3data.FIRSTNAME) + "　様";
                                peridField.Text = Util.ConvertToString(ret3data.PERID).Trim();

                                //受診日
                                DateTime.TryParse(Util.ConvertToString(ret3data.CSLDATE), out wkCsldate);
                                csldate2Field.Text = WebHains.EraDateFormat(wkCsldate, "ggyy年M月d日");

                            }

                            decimal.TryParse(Util.ConvertToString(ret3data.PRICE), out decimal wkPrice);
                            decimal.TryParse(Util.ConvertToString(ret3data.EDITPRICE), out decimal wkEditPrice);
                            decimal.TryParse(Util.ConvertToString(ret3data.TAXPRICE), out decimal wkTax);
                            decimal.TryParse(Util.ConvertToString(ret3data.EDITTAX), out decimal wkEditTax);

                            secondlinedivnameListField.ListCell(0, lineCnt).Text = Util.ConvertToString(ret3data.SECONDLINEDIVNAME).Trim();
                            if (wkPrice != 0 || wkEditPrice != 0)
                            {
                                price = wkPrice + wkEditPrice;
                                priceListField.ListCell(0, lineCnt).Text = price.ToString("#,##0");
                                subTotal = subTotal + price;
                            }
                            else
                            {
                                priceListField.ListCell(0, lineCnt).Text = "";
                            }
                            if (wkTax != 0 || wkEditTax != 0)
                            {
                                tax2 = tax2 + wkTax + wkEditTax;
                            }

                            //行インクリメント
                            lineCnt++;
                        }

                        //合計計算
                        if (total2 == 0)
                        {
                            total2 = subTotal + tax2;
                        }
                        else
                        {
                            total2 = subTotal + tax2 + total2;
                        }

                        //合計出力
                        subtotal2Field.Text = subTotal.ToString("#,##0");
                        tax3Field.Text = tax2.ToString("#,##0");
                        total2Field.Text = total2.ToString("#,##0");

                        // ドキュメントの出力
                        PrintOut(cnForm3);

                    }

                }

            }

            if (outCnt > 0)
            {
                for (int i = 0; i <= outCnt - 1; i++)
                {
                    secondFlgList[i] = "";
                    cslDate2List[i] = "";
                    perId2List[i] = "";
                }

                //1件以上処理された場合、印刷日付を更新する
                int retUpd = UpdateBillPrtDate();

            }

        }

        /// <summary>
        /// 対象受診データ取得
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns></returns>
        private dynamic GetD_Date(string cslDate, string perId)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    consult.perid
                    , consult.cscd
                    , receipt.csldate
                    , receipt.rsvno
                    , receipt.comedate
                    , course_p.csname
                    , free.freecd
                    , free.freefield1 
                from
                    consult
                    , receipt
                    , course_p
                    , free 
                where
                    consult.rsvno = receipt.rsvno 
                    and consult.cscd = course_p.cscd 
                    and consult.csldate <= :csldate 
                    and consult.perid = :perid 
                    and receipt.comedate is not null 
                    and free.freecd like :freecd_cscd 
                    and free.freefield1 = course_p.cscd 
                order by
                    receipt.csldate desc
                ";

            // パラメータセット
            DateTime.TryParse(cslDate, out DateTime csldate_para);

            var sqlParam = new
            {
                csldate = csldate_para,
                perid = perId,
                freecd_cscd = FREECD_CSCD
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 対象データ取得(３枚目取得)
        /// </summary>
        /// <param name="cslDate">受診年月日</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="closeDate">締め日</param>
        /// <param name="billSeq">請求書seq</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <param name="lineNo">明細Ｎｏ</param>
        /// <returns></returns>
        private dynamic GetData2(string cslDate, string perId, string closeDate, string billSeq, string branchNo, string lineNo)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    bill.orgcd1                                        --団体コード１
                    , bill.orgcd2                                      --団体コード２
                    , bill.closedate                                   --締め日
                    , bill.billseq                                     --請求書seq
                    , bill.branchno                                    --請求書枝番
                    , billdetail.lineno                                --明細Ｎｏ
                    , billdetail.lastname                              --姓
                    , billdetail.firstname                             --名
                    , billdetail.csldate                               --受診日
                    , billdetail.dayid                                 --当日ＩＤ
                    , billdetail.rsvno                                 --予約番号
                    , billdetail.perid                                 --個人ＩＤ
                    , billdetail_items.secondlinedivcd                 --２次請求明細コード
                    , nvl(billdetail_items.price, 0) price             --金額
                    , nvl(billdetail_items.editprice, 0) editprice     --調整金額
                    , nvl(billdetail_items.taxprice, 0) taxprice       --税額
                    , nvl(billdetail_items.edittax, 0) edittax         --税調整税額
                    , secondlinediv.secondlinedivname                  --２次請求明細名
                    , secondlinediv.stdprice                           --標準単価
                    , secondlinediv.stdtax                             --標準税額
                    , org.orgname                                      --漢字名称
                    , orgaddr.orgname addorgname                       --漢字名称
                from
                    bill
                    , billdetail
                    , billdetail_items
                    , secondlinediv
                    , org
                    , orgaddr 
                where
                    bill.orgcd1 = org.orgcd1 
                    and bill.orgcd2 = org.orgcd2 
                    and org.orgcd1 = orgaddr.orgcd1(+) 
                    and org.orgcd2 = orgaddr.orgcd2(+) 
                    and org.billaddress = orgaddr.addrdiv(+) 
                    and bill.closedate = billdetail.closedate 
                    and bill.billseq = billdetail.billseq 
                    and bill.branchno = billdetail.branchno 
                    and billdetail.closedate = billdetail_items.closedate(+) 
                    and billdetail.billseq = billdetail_items.billseq(+) 
                    and billdetail.branchno = billdetail_items.branchno(+) 
                    and billdetail.lineno = billdetail_items.lineno(+) 
                    and billdetail_items.secondlinedivcd = secondlinediv.secondlinedivcd(+) 
            ";

            //受診日指定
            if (cslDate.Trim() != "")
            {
                sql += @"
                    and billdetail.csldate = :csldate 
                ";
            }

            //個人ＩＤ指定
            if ( perId.Trim() != "")
            {
                sql += @"
                    and billdetail.perid = :perid 
                ";
            }

            //締め日,請求書Seq,請求書枝番指定
            sql += @"
                    and billdetail_items.closedate = :closedate 
                    and billdetail_items.billseq = :billseq 
                    and billdetail_items.branchno = :branchno 
                ";

            //明細Ｎｏ指定
            sql += @"
                    and billdetail_items.lineno = :lineno 
                ";

            //ソート
            sql += @"
                order by
                    bill.orgcd1
                    , bill.orgcd2
                    , bill.closedate
                    , bill.billseq
                    , bill.branchno
                    , billdetail.csldate
                    , billdetail.dayid
                    , billdetail.lineno
                    , billdetail_items.secondlinedivcd
                ";

            // パラメータセット
            DateTime.TryParse(cslDate, out DateTime csldate_para);
            DateTime.TryParse(closeDate, out DateTime closedate_para);

            var sqlParam = new
            {
                csldate = csldate_para,
                perid = perId,
                closedate = closedate_para,
                billseq = billSeq,
                branchno = branchNo,
                lineno = lineNo
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 対象データ取得(１、２枚目計算用取得)
        /// </summary>
        /// <param name="closeDate">締め日</param>
        /// <param name="billSeq">請求書seq</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <returns></returns>
        private dynamic GetData3(DateTime closeDate, string billSeq, string branchNo)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    bill.orgcd1
                    , bill.orgcd2
                    , bill.closedate
                    , bill.billseq
                    , bill.branchno
                    , billdetail.lineno
                    , billdetail.lastname
                    , billdetail.firstname
                    , billdetail.csldate
                    , billdetail.dayid
                    , billdetail.rsvno
                    , billdetail.perid
                    , billdetail_items.secondlinedivcd
                    , nvl(billdetail_items.price, 0) price
                    , nvl(billdetail_items.editprice, 0) editprice
                    , nvl(billdetail_items.taxprice, 0) taxprice
                    , nvl(billdetail_items.edittax, 0) edittax
                    , secondlinediv.secondlinedivname
                    , secondlinediv.stdprice
                    , secondlinediv.stdtax
                    , org.orgname
                    , orgaddr.orgname addorgname 
                from
                    bill
                    , billdetail
                    , billdetail_items
                    , secondlinediv
                    , org
                    , orgaddr 
                where
                    bill.orgcd1 = org.orgcd1 
                    and bill.orgcd2 = org.orgcd2 
                    and org.orgcd1 = orgaddr.orgcd1(+) 
                    and org.orgcd2 = orgaddr.orgcd2(+) 
                    and org.billaddress = orgaddr.addrdiv(+) 
                    and bill.closedate = billdetail.closedate 
                    and bill.billseq = billdetail.billseq 
                    and bill.branchno = billdetail.branchno 
                    and billdetail.closedate = billdetail_items.closedate(+) 
                    and billdetail.billseq = billdetail_items.billseq(+) 
                    and billdetail.branchno = billdetail_items.branchno(+) 
                    and billdetail.lineno = billdetail_items.lineno(+) 
                    and billdetail_items.secondlinedivcd = secondlinediv.secondlinedivcd(+) 
                    --締め日,請求書Seq,請求書枝番指定
                    and billdetail_items.closedate = :closedate
                    and billdetail_items.billseq = :billseq 
                    and billdetail_items.branchno = :branchno
                    --ソート
                 order by
                    bill.orgcd1
                    , bill.orgcd2
                    , bill.closedate
                    , bill.billseq
                    , bill.branchno
                    , billdetail.csldate
                    , billdetail.dayid
                    , billdetail.lineno
            ";

            // パラメータセット
            var sqlParam = new
            {
                closedate = closeDate,
                billseq = billSeq,
                branchno = branchNo
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 対象データ取得(限度額負担金取得)
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns></returns>
        private dynamic GetD_Limit(int rsvNo)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    lastview.rsvno as rsvno
                    , lastview.freefield1 as freefield1 
                from
                    ( 
                        select
                            consult.rsvno as rsvno
                            , free.freefield1 as freefield1
                            , ( 
                                select
                                    sum(price) + sum(tax) as price 
                                from
                                    ctrpt_price 
                                where
                                    ctrptcd = consult_o.ctrptcd 
                                    and optcd = consult_o.optcd 
                                    and optbranchno = consult_o.optbranchno
                            ) as price 
                        from
                            consult
                            , consult_o
                            , ctrpt_opt
                            , free 
                        where
                            consult.rsvno = :rsvno 
                            and consult.rsvno = consult_o.rsvno 
                            and consult.ctrptcd = consult_o.ctrptcd 
                            and consult_o.ctrptcd = ctrpt_opt.ctrptcd 
                            and consult_o.optcd = ctrpt_opt.optcd 
                            and consult_o.optbranchno = ctrpt_opt.optbranchno 
                            and ctrpt_opt.exceptlimit is null 
                            and :setclass_limit || ctrpt_opt.setclasscd = free.freecd
                    ) lastview 
                where
                    lastview.price > 0
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                setclass_limit = SETCLASS_LIMIT
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 対象データ取得(直近の予約情報から保険証記号・番号などの情報取得)
        /// </summary>
        /// <param name="cslDate">受診年月日</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns></returns>
        private dynamic GetD_ISR(DateTime cslDate, string perId)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    final.csldate as csldate
                    , final.dayid as dayid
                    , final.perid as perid
                    , final.rsvno as rsvno
                    , final.isrsign as isrsign
                    , final.isrno as isrno
                    , final.billprint as billprint
                    , final.empno as empno
                    , final.age as age 
                from
                    ( 
                        select
                            consult.csldate as csldate
                            , receipt.dayid as dayid
                            , consult.perid as perid
                            , consult.rsvno as rsvno
                            , consult.isrsign as isrsign
                            , consult.isrno as isrno
                            , consult.billprint as billprint
                            , consult.empno as empno
                            , trunc(consult.age) as age 
                        from
                            consult
                            , receipt
                            , course_p
                            , free 
                        where
                            consult.rsvno = receipt.rsvno 
                            and consult.cscd = course_p.cscd 
            ";

            //受診日指定
            if (cslDate.ToString().Trim() != "")
            {
                sql += @"
                    and consult.csldate <= :csldate 
                ";
            }

            //個人ＩＤ指定
            if (perId.Trim() != "")
            {
                sql += @"
                    and consult.perid = :perid 
                ";
            }

            sql += @"
                            and receipt.comedate is not null 
                            and free.freecd like :freecd_cscd
                            and free.freefield1 = course_p.cscd 
                        order by
                            receipt.csldate desc
                    ) final 
                where
                    rownum < 2
                ";

            // パラメータセット
            var sqlParam = new
            {
                csldate = cslDate,
                perid = perId,
                freecd_cscd = FREECD_CSCD
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 請求書分類テーブルレコードを更新する
        /// </summary>
        /// <returns>更新成功：True　　更新失敗：False</returns>
        private dynamic UpdateBillPrtDate()
        {
            // SQLステートメント定義
            string sql = @"
                update bill 
                set
                    prtdate = sysdate 
                ";

            ///請求書番号指定
            string closeDate = "";
            decimal billSeq = 0;
            decimal branchNo = 0;

            string billno = queryParams["billno"].Trim();
            if (billno != "")
            {
                closeDate = billno.Substring(0, 4) + "/" + billno.Substring(4, 2) + "/" + billno.Substring(6, 2);
                decimal.TryParse(billno.Substring(8, 5), out billSeq);
                decimal.TryParse(billno.Substring(13, 1), out branchNo);

                sql += @"
                where
                    bill.closedate = :closedate 
                    and bill.billseq = :billseq 
                    and bill.branchno = :branchno 
                ";
            }
            else
            {
                sql += @"
                where
                    bill.closedate between :startdate and :enddate 
                ";
            }

            ///団体コード１
            if (queryParams["orgcd1"] != "")
            {
                sql += @"
                    and bill.orgcd1 = :orgcd1 
                ";
            }

            ///団体コード２
            if (queryParams["orgcd2"] != "")
            {
                sql += @"
                    and bill.orgcd2 = :orgcd2 
                ";
            }

            ///出力対象
            if (queryParams["object"] == "2")
            {
                sql += @"
                    and bill.prtdate is null 
                ";
            }
            else if (queryParams["object"] == "3")
            {
                sql += @"
                    and bill.prtdate is not null 
                ";
            }

            ///取り消し伝票
            if (queryParams["delflg"] != "1")
            {
                sql += @"
                    and bill.delflg = :delflg 
                ";
            }

            ///区分
            if (queryParams["kbn"] == "0")
            {
                sql += @"
                    and bill.secondflg is null 
                ";
            }
            else if (queryParams["kbn"] == "1")
            {
                sql += @"
                    and bill.secondflg = :secondflg
                ";
            }

            // パラメータセット
            var sqlParam = new
            {
                orgcd1 = queryParams["orgcd1"],
                orgcd2 = queryParams["orgcd2"],
                closedate = closeDate,
                billseq = billSeq,
                branchno = branchNo,
                startdate = queryParams["startdate"],
                enddate = queryParams["enddate"],

                delflg = DelFlg.Used,
                secondflg = BILL_SECONDFLG,
            };

            // SQLステートメント実行
            return connection.Execute(sql, sqlParam);
        }



    }
}
