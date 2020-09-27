using Dapper;
using Hainsi.ReportCore;
using Hainsi.Common;
using Hainsi.Common.Constants;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    //[LoggingParam]
    public class BillDetailListCreator : CsvCreator
    {
        /// <summary>
        /// 請求書明細情報データを読み込み
        /// </summary>
        /// <returns>請求書明細情報データ</returns>
        protected override List<dynamic> GetData()
        {

            string startDate = queryParams["startdate"];
            string endDate = queryParams["enddate"];
            string orgCd1 = queryParams["orgcd1"];
            string orgCd2 = queryParams["orgcd2"];
            string billNo = queryParams["billno"];
            double dbillNo;
            string closeDate;
            DateTime dcloseDate = System.DateTime.Now;
            long billSeq = 0;
            long branchNo = 0;
            bool isBillNo = false;
            bool noBillNo = false;

            if (double.TryParse(billNo, out dbillNo))
            {
                noBillNo = true;
                // 請求書番号が指定されている場合
                if (dbillNo > 0 && billNo.Length == 14)
                {
                    // 請求書番号を分解
                    closeDate = billNo.Substring(0, 4) + "/" + billNo.Substring(4, 2) + "/" + billNo.Substring(6, 2);
                    if (long.TryParse(billNo.Substring(8, 5), out billSeq))
                    {
                        if (long.TryParse(billNo.Substring(13, 1), out branchNo))
                        {
                            if (DateTime.TryParse(closeDate, out dcloseDate))
                            {
                                isBillNo = true;
                            }
                        }
                    }
                }
            }

            string sql =
                  @"
                    select
                        to_char(bill.closedate, 'YYYYMMDD') || trim(to_char(bill.billseq, '00000')) || to_char(bill.branchno)
                         as 請求書番号
                        , bill.closedate 締め日
                        , bill.orgcd1 負担元団体コード１
                        , bill.orgcd2 負担元団体コード２
                        , org.orgname 負担元名称
                        , decode(bill.method, 0, '手入力', '締め処理') 作成方法
                        , bill.taxrates 適用税率
                        , to_char(bill.prtdate, 'YYYY/MM/DD') 請求書出力日
                        , billdetail.lineno 明細行番号
                        , billdetail.detailname 明細
                        , ( 
                            billdetail.price + nvl( 
                                ( 
                                    select
                                        sum(price) price 
                                    from
                                        billdetail_items 
                                    where
                                        billdetail.closedate = billdetail_items.closedate 
                                        and billdetail.billseq = billdetail_items.billseq 
                                        and billdetail.branchno = billdetail_items.branchno 
                                        and billdetail.lineno = billdetail_items.lineno 
                                    group by
                                        closedate
                                        , billseq
                                        , branchno
                                        , lineno
                                ) 
                                , 0
                            )
                        ) 金額
                        , ( 
                            billdetail.editprice + nvl( 
                                ( 
                                    select
                                        sum(editprice) editprice 
                                    from
                                        billdetail_items 
                                    where
                                        billdetail.closedate = billdetail_items.closedate 
                                        and billdetail.billseq = billdetail_items.billseq 
                                        and billdetail.branchno = billdetail_items.branchno 
                                        and billdetail.lineno = billdetail_items.lineno 
                                    group by
                                        closedate
                                        , billseq
                                        , branchno
                                        , lineno
                                ) 
                                , 0
                            )
                        ) 調整金額
                        , ( 
                            billdetail.taxprice + nvl( 
                                ( 
                                    select
                                        sum(taxprice) taxprice 
                                    from
                                        billdetail_items 
                                    where
                                        billdetail.closedate = billdetail_items.closedate 
                                        and billdetail.billseq = billdetail_items.billseq 
                                        and billdetail.branchno = billdetail_items.branchno 
                                        and billdetail.lineno = billdetail_items.lineno 
                                    group by
                                        closedate
                                        , billseq
                                        , branchno
                                        , lineno
                                ) 
                                , 0
                            )
                        ) 税額
                        , ( 
                            billdetail.edittax + nvl( 
                                ( 
                                    select
                                        sum(edittax) edittax 
                                    from
                                        billdetail_items 
                                    where
                                        billdetail.closedate = billdetail_items.closedate 
                                        and billdetail.billseq = billdetail_items.billseq 
                                        and billdetail.branchno = billdetail_items.branchno 
                                        and billdetail.lineno = billdetail_items.lineno 
                                    group by
                                        closedate
                                        , billseq
                                        , branchno
                                        , lineno
                                ) 
                                , 0
                            )
                        ) 調整税額
                        , billdetail.perid 個人id
                        , billdetail.lastkname || '　' || billdetail.firstkname カナ氏名
                        , billdetail.lastname || '　' || billdetail.firstname 氏名
                        , billdetail.csldate 受診日
                        , billdetail.dayid 当日ｉｄ
                        , case 
                            when bill.secondflg = :secondflg 
                                then '２次検査' 
                            end 二次検査種別
                        , case 
                            when bill.delflg = :delflg 
                                then '取消伝票' 
                            end 伝票種別 
                    from
                        billdetail
                        , org
                        , bill
                    ";

            if (noBillNo == true)
            {
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
                            bill.closedate between :strclosedate and :endclosedate
                    ";

                // 負担元指定
                if (!string.IsNullOrEmpty(orgCd1) && !string.IsNullOrEmpty(orgCd2))
                {
                    sql += @" 
                            and bill.orgcd1 = :orgcd1 
                            and bill.orgcd2 = :orgcd2
                    ";
                }
            }

            sql +=
                  @"
                    and org.orgcd1 = bill.orgcd1 
                    and org.orgcd2 = bill.orgcd2 
                    and billdetail.closedate = bill.closedate 
                    and billdetail.billseq = bill.billseq 
                    and billdetail.branchno = bill.branchno 
                    order by
                        bill.closedate
                        , bill.billseq
                        , bill.branchno
                        , billdetail.lineno
                    ";

            var sqlParam = new
            {
                strclosedate = (noBillNo == false) ? startDate : "",
                endclosedate = (noBillNo == false) ? endDate : "",
                orgcd1 = (noBillNo == false) ? orgCd1 : "",
                orgcd2 = (noBillNo == false) ? orgCd2 : "",
                closedate = (isBillNo == true) ? dcloseDate : (DateTime?)null,
                billseq = (isBillNo == true) ? billSeq : (long?)null,
                branchno = (isBillNo == true) ? branchNo : (long?)null,
                delflg = DelFlg.Deleted,
                secondflg = SCourse.Second
            };

            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージのリスト</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            int mode;
            DateTime tmpDate;
            String tmpMsg;

            if (int.TryParse(queryParams["mode"], out mode))
            {

                if (! DateTime.TryParse(queryParams["startdate"], out tmpDate))
                {
                    messages.Add("開始締め日の入力形式が正しくありません。");
                }
                if (!DateTime.TryParse(queryParams["enddate"], out tmpDate))
                {
                    messages.Add("終了締め日の入力形式が正しくありません。");                        
                }

                tmpMsg = WebHains.CheckNumeric("請求書番号", queryParams["billno"], 14);
                if (!string.IsNullOrEmpty(tmpMsg))
                {
                    messages.Add(tmpMsg);
                }

            }

            return messages;
        }
    }
}
