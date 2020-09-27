using Dapper;
using Hainsi.ReportCore;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    //[LoggingParam]
    public class AbsenceListBillCreator : CsvCreator
    {

        /// <summary>
        /// 汎用コード(請求情報抽出対象外団体)
        /// </summary>
        private const string FREECD = "BILLNOT%";

        /// <summary>
        /// 汎用マスタ
        /// </summary>
        private const string FREE_BILL = "A-BILL";

        /// <summary>
        /// 経理システム連携用データを読み込み
        /// </summary>
        /// <returns>経理システム連携用データ</returns>
        protected override List<dynamic> GetData()
        {
           
            string billNo = queryParams["billno"];
            string closeDate;
            DateTime dcloseDate = System.DateTime.Now;
            long billSeq = 0;
            long branchNo = 0;
            bool isBillNo = false;
            bool isDispatch = false;
            bool isNoDispatch = false;
            bool isPayment = false;
            bool isNoPayment = false;

            // 請求書番号の妥当性チェック
            if (double.TryParse(billNo, out double dbillNo))
            {
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

            // 請求書発送状態が設定されている。
            if (queryParams["isdispatch"].Trim() == "1")
            {
                isDispatch = true;
            }
            else if (queryParams["isdispatch"].Trim() == "2")
            {
                isNoDispatch = true;
            }

            // 入金状態が設定されている。
            if (queryParams["ispayment"].Trim() == "1")
            {
                isPayment = true;
            }
            else if (queryParams["ispayment"].Trim() == "2")
            {
                isNoPayment = true;
            }

            // 設定されている団体コードパラメータの件数を取得する
            int dicno = 0;
            var orgcdDic = new Dictionary<int, List<string>>();
            if (!string.IsNullOrEmpty(queryParams["orgcd11"]) || !string.IsNullOrEmpty(queryParams["orgcd12"]))
            {
                var orgcdList = new List<string>();
                orgcdList.Add(queryParams["orgcd11"]);
                orgcdList.Add(queryParams["orgcd12"]);
                orgcdDic.Add(dicno, orgcdList);
                dicno++;
            }
            if (!string.IsNullOrEmpty(queryParams["orgcd21"]) || !string.IsNullOrEmpty(queryParams["orgcd22"]))
            {
                var orgcdList = new List<string>();
                orgcdList.Add(queryParams["orgcd21"]);
                orgcdList.Add(queryParams["orgcd22"]);
                orgcdDic.Add(dicno, orgcdList);
                dicno++;
            }
            if (!string.IsNullOrEmpty(queryParams["orgcd31"]) || !string.IsNullOrEmpty(queryParams["orgcd32"]))
            {
                var orgcdList = new List<string>();
                orgcdList.Add(queryParams["orgcd31"]);
                orgcdList.Add(queryParams["orgcd32"]);
                orgcdDic.Add(dicno, orgcdList);
                dicno++;
            }
            if (!string.IsNullOrEmpty(queryParams["orgcd41"]) || !string.IsNullOrEmpty(queryParams["orgcd42"]))
            {
                var orgcdList = new List<string>();
                orgcdList.Add(queryParams["orgcd41"]);
                orgcdList.Add(queryParams["orgcd42"]);
                orgcdDic.Add(dicno, orgcdList);
                dicno++;
            }
            if (!string.IsNullOrEmpty(queryParams["orgcd51"]) || !string.IsNullOrEmpty(queryParams["orgcd52"]))
            {
                var orgcdList = new List<string>();
                orgcdList.Add(queryParams["orgcd51"]);
                orgcdList.Add(queryParams["orgcd52"]);
                orgcdDic.Add(dicno, orgcdList);
                dicno++;
            }

            string sql =
                  @"
                    select
                        to_char(bill.closedate, 'YYYY/MM/DD') as closedate
                        , bill.billseq as billseq
                        , bill.branchno as branchno
                        , to_char(bill.closedate, 'YYYYMMDD') || trim(to_char(bill.billseq, '00000')) || to_char(bill.branchno)
                         as billno
                        , to_char(sysdate, 'YYYY/MM/DD') as hd_request_date
                        , to_char(sysdate, 'YYYYMMDD') || '_' || trim(to_char(companyno.nextval, '000000')) as if_system_no
                        , payment_view.seq as paymentseq
                        , trim(bill.orgcd1) || '-' || trim(bill.orgcd2) as orgcd
                        , bill.orgcd1 as orgcd1
                        , bill.orgcd2 as orgcd2
                        , bill.prtdate as prtdate
                        , bill.method as method
                        , org.orgname as orgname
                        , org.orgkname as orgkname
                        , nvl(sum_billdetail.pricetotal, 0) + nvl(sum_billdetail_items.pricetotal, 0) as pricetotal
                        , nvl(sum_billdetail.taxtotal, 0) + nvl(sum_billdetail_items.taxtotal, 0) as taxtotal
                        , nvl(sum_billdetail.pricetotal, 0) + nvl(sum_billdetail_items.pricetotal, 0) + nvl(sum_billdetail.taxtotal, 0)
                         + nvl(sum_billdetail_items.taxtotal, 0) as billtotal
                        , last_dispatch.dispatchdate as dispatchdate
                        , sum_payment.sum_paymentprice as sum_paymentprice
                        , payment_view.seq as seq
                        , payment_view.paymentprice as paymentprice
                        , payment_view.paymentdate as paymentdate
                        , payment_view.upduser as upduser
                        , payment_view.username as username
                        , nvl(payment_view.paymentdate, '') as order_paymentdate
                        , bill.billcomment as billcomment
                        , :userid as userid 
                    from
                        bill
                        , org

                    --請求書明細サマリ部分
                        ,( 
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
                            from
                                billdetail
                    ";

            if (isBillNo)
            {
                // 請求書番号が指定されている
                sql += @" 
                        where
                            billdetail.closedate = :closedate 
                            and billdetail.billseq = :billseq 
                            and billdetail.branchno = :branchno
                    ";
            }
            else
            {
                // 締め日範囲が設定されている（請求書番号がない場合のみ）
                sql += @" 
                        where
                            billdetail.closedate between :frdate and :todate
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
                            from
                                billdetail_items
                    ";

            if (isBillNo)
            {
                // 請求書番号が指定されている
                sql += @" 
                        where
                            billdetail_items.closedate = :closedate 
                            and billdetail_items.billseq = :billseq 
                            and billdetail_items.branchno = :branchno
                    ";
            }
            else
            {
                // 締め日範囲が設定されている（請求書番号がない場合のみ）
                sql += @" 
                        where
                            billdetail_items.closedate between :frdate and :todate
                    ";
            }

            sql += @" 
                    group by
                        billdetail_items.closedate
                        , billdetail_items.billseq
                        , billdetail_items.branchno) sum_billdetail_items

                        --入金情報サマリ部分
                        ,( 
                            select
                                payment.closedate
                                , payment.billseq
                                , payment.branchno
                                , sum(payment.paymentprice) as sum_paymentprice 
                            from
                                payment
                    ";

            if (isBillNo)
            {
                // 請求書番号が指定されている
                sql += @" 
                        where
                            payment.closedate = :closedate 
                            and payment.billseq = :billseq 
                            and payment.branchno = :branchno
                    ";
            }
            else
            {
                // 締め日範囲が設定されている（請求書番号がない場合のみ）
                sql += @" 
                        where
                            payment.closedate between :frdate and :todate
                    ";
            }

            sql += @" 
                    group by
                        payment.closedate
                        , payment.billseq
                        , payment.branchno) sum_payment

                        --入金管理部分
                        ,( 
                            select
                                payment.closedate
                                , payment.billseq
                                , payment.branchno
                                , payment.seq
                                , payment.paymentprice
                                , payment.paymentdate
                                , payment.upduser
                                , hainsuser.username 
                            from
                                payment
                                , hainsuser 
                            where
                                payment.upduser = hainsuser.userid
                    ";

            if (isBillNo)
            {
                // 請求書番号が指定されている
                sql += @" 
                        and payment.closedate = :closedate 
                        and payment.billseq = :billseq 
                        and payment.branchno = :branchno
                    ";
            }
            else
            {
                // 締め日範囲が設定されている（請求書番号がない場合のみ）
                sql += @" 
                        and payment.closedate between :frdate and :todate
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
                                from
                                    dispatch
                    ";

            if (isBillNo)
            {
                // 請求書番号が指定されている
                sql += @" 
                        where
                            dispatch.closedate = :closedate 
                            and dispatch.billseq = :billseq 
                            and dispatch.branchno = :branchno
                    ";
            }
            else
            {
                // 締め日範囲が設定されている（請求書番号がない場合のみ）
                sql += @" 
                        where
                            dispatch.closedate between :frdate and :todate
                    ";
            }

            sql += @" 
                    group by
                        dispatch.closedate
                        , dispatch.billseq
                        , dispatch.branchno)) last_dispatch

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
                        and bill.orgcd1 = org.orgcd1 
                        and bill.orgcd2 = org.orgcd2 
                        and sum_billdetail_items.closedate(+) = bill.closedate 
                        and sum_billdetail_items.billseq(+) = bill.billseq 
                        and sum_billdetail_items.branchno(+) = bill.branchno 
                        --取消伝票は抽出しない
                        and bill.delflg = :delflg
                    ";

            if (isBillNo)
            {
                // 請求書番号が指定されている
                sql += @" 
                        and bill.closedate = :closedate 
                        and bill.billseq = :billseq 
                        and bill.branchno = :branchno
                    ";
            }
            else
            {
                // 締め日範囲が設定されている（請求書番号がない場合のみ）
                sql += @" 
                        and bill.closedate between :frdate and :todate
                    ";
            }

            // 団体コードが設定されている
            if (dicno > 0)
            {
                sql += @" 
                        and (
                    ";

                bool isFirst = true;
                foreach (KeyValuePair<int ,List<string>> row in orgcdDic)
                {
                    if (isFirst==false)
                    {
                        sql += @" 
                                    or 
                                ";
                    }

                    sql += @"(bill.orgcd1 = '";
                    sql += row.Value[0];
                    sql += @"' and bill.orgcd2 = '";
                    sql += row.Value[1];
                    sql += "')";

                    isFirst = false;
                }

                sql += @" 
                        ) 
                    ";
            }

            // 請求対象外団体は除いて抽出（汎用マスターで管理）
            sql += @" 
                    and (bill.orgcd1, bill.orgcd2) not in ( 
                        select
                            free.freefield1
                            , free.freefield2 
                        from
                            free 
                        where
                            free.freecd like :freecd
                    ) 
                    ";

            // 発送済みのみが設定されている
            if (isDispatch)
            {
                sql += @" 
                        and last_dispatch.dispatchdate is not null 
                    ";
            }

            // 未発送のみが設定されている
            if (isNoDispatch)
            {
                sql += @" 
                        and last_dispatch.dispatchdate is null 
                    ";
            }

            // 入金済みのみが設定されている
            if (isPayment)
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

            // 未収のみが設定されている
            if (isNoPayment)
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

            // TODO
            string userId = "HAINS$";

            var sqlParam = new
            {
                frdate = (!isBillNo) ? queryParams["startdate"] : "",
                todate = (!isBillNo) ? queryParams["enddate"] : "",
                userid = userId,
                closedate = (isBillNo) ? dcloseDate : (DateTime?)null,
                billseq = (isBillNo) ? billSeq : (long?)null,
                branchno = (isBillNo) ? branchNo : (long?)null,
                delflg = DelFlg.Used,
                freecd = FREECD
            };

            return CreateCsvFile(connection.Query(sql, sqlParam).ToList());
        }


        private List<dynamic> CreateCsvFile(List<dynamic> data)
        {

            var returnData = new List<dynamic>();

            // 件数0なら処理しない
            if (data.Count == 0)
            {
                return returnData;
            }

            // 汎用マスタの読み込み
            var freeDao = new FreeDao(connection);

            IList<dynamic> tagData = freeDao.SelectFree(1, FREE_BILL);

            // 出力データの編集
            foreach (IDictionary<string, object> rec in data)
            {
                var mainDic = new Dictionary<string, object>();

                foreach (var tagRec in tagData)
                {

                    int tmp;

                    switch (tagRec.FREEFIELD1)
                    {
                        case "FIX":
                            // 固定値
                            if (int.TryParse(tagRec.FREEFIELD6, out tmp))
                            {
                                mainDic.Add(tagRec.FREEFIELD4, CheckSize(CheckSpace(tagRec.FREEFIELD5), tmp));
                            }
                            else
                            {
                                mainDic.Add(tagRec.FREEFIELD4, CheckSpace(tagRec.FREEFIELD5));
                            }
                            break;

                        case "BAS":
                            // 抽出結果から出力
                            foreach (dynamic field in rec.Keys)
                            {
                                if (field == tagRec.FREEFIELD3)
                                {
                                    // SQLで取得したフィールド名と汎用テーブルが一致
                                    if (int.TryParse(tagRec.FREEFIELD6, out tmp))
                                    {
                                        mainDic.Add(tagRec.FREEFIELD4, CheckSize(CheckSpace(Util.ConvertToString(rec[field])), tmp));
                                    }
                                    else
                                    {
                                        mainDic.Add(tagRec.FREEFIELD4, CheckSpace(Util.ConvertToString(rec[field])));
                                    }
                                    break;
                                }
                            }
                            break;
                    }
                }

                returnData.Add(mainDic);

            }

            return returnData;
        }

        /// <summary>
        /// 空白削除
        /// </summary>
        /// <param name="value">文字列</param>
        /// <returns>削除後文字列</returns>
        private string CheckSpace(string value)
        {
            string ret = Util.ConvertToString(value);



            //空白削除
            ret = ret.Replace(" ", "").Replace("　", "");

            return ret;
        }

        /// <summary>
        /// 文字列のサイズ（Byte）計算
        /// </summary>
        /// <param name="value">文字列</param>
        /// <param name="size">サイズ</param>
        /// <returns>編集後文字列</returns>
        private string CheckSize(string value, int size)
        {
            string ret = "";

            if (string.IsNullOrEmpty(value))
            {
                return "";
            }

            for (int i = 1; i <= value.Length; i++)
            {

                int nextByte = WebHains.LenB(value.Trim().Substring(i - 1, 1));

                if ((WebHains.LenB(ret) + nextByte) <= size)
                {
                    ret += value.Trim().Substring(i - 1, 1);
                }
                else
                {
                    break;
                }

            }

            return ret;
        }

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージのリスト</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            DateTime tmpDate;

            if (! DateTime.TryParse(queryParams["startdate"], out tmpDate))
            {
                messages.Add("開始受診日の入力形式が正しくありません。");
            }
            if (!DateTime.TryParse(queryParams["enddate"], out tmpDate))
            {
                messages.Add("終了受診日の入力形式が正しくありません。");                        
            }

            return messages;
        }
    }
}
