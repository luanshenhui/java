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
    public class AbsenceOrgBillCreator : CsvCreator
    {

        /// <summary>
        /// 汎用マスタ
        /// </summary>
        private const string FREE_ORGBILL = "A-ORGBILL";

        /// <summary>
        /// 団体請求明細データを読み込み
        /// </summary>
        /// <returns>団体請求明細データ</returns>
        protected override List<dynamic> GetData()
        {
            string startDate = queryParams["startdate"];
            string endDate = queryParams["enddate"];
            string orgCd1 = queryParams["orgcd1"];
            string orgCd2 = queryParams["orgcd2"];
            string billNo = queryParams["billno"];
            string closeDate;
            DateTime dcloseDate = System.DateTime.Now;
            long billSeq = 0;
            long branchNo = 0;
            bool isBillNo = false;
            bool noBillNo = false;

            // 請求書番号の妥当性チェック
            if (double.TryParse(billNo, out double dbillNo))
            {
                noBillNo = true;
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
                        bill.orgcd1 as orgcd1
                        , bill.orgcd2 as orgcd2
                        , bill.prtdate as prtdate
                        , bill.closedate as closedate
                        , bill.billseq as billseq
                        , bill.branchno as branchno
                        , billdetail.lastname || '　' || billdetail.firstname as name
                        , billdetail.detailname as detailname
                        , instr(billdetail.detailname, '１日ドック') as stcourse
                        , instr(billdetail.detailname, '乳房') as bscourse
                        , substr( 
                            billdetail.detailname
                            , 0
                            , length(billdetail.detailname) - 1
                        ) as detailheader
                        , substr( 
                            billdetail.detailname
                            , length(billdetail.detailname)
                        ) as detailfooter
                        , (billdetail.price + billdetail.editprice) as price
                        , (billdetail.taxprice + billdetail.edittax) as tax
                        , ( 
                            billdetail.price + billdetail.editprice + billdetail.taxprice + billdetail.edittax
                        ) as billtotal
                        , to_char(billdetail.csldate, 'YYYYMMDD') as csldate
                        , billdetail.dayid as dayid
                        , billdetail.rsvno as rsvno
                        , decode(person.gender, 1, '男', 2, '女') as gender
                        , to_char(person.birth, 'YYYYMMDD') as birth
                        , org.orgbillname as orgbillname
                        , org.billcsldiv as billcsldiv
                        , org.billins as billins
                        , org.billempno as billempno
                        , org.billage as billage
                        , consult.isrsign as isrsign
                        , consult.isrno as isrno
                        , consult.empno as empno
                        , trunc(consult.age) as age
                        , billdetail.perid as perid
                        , billdetail.lineno as lineno
                        , bill.secondflg as secondflg
                        , consult.billprint as billprint
                        , decode(consult.billprint, 1, '本人', 2, '家族', ' ') as billprintname
                        , decode(free.freefield1, null, '0', free.freefield1) as limitprice
                        , nvl( 
                            ( 
                                select
                                    bd.detailname as detailname 
                                from
                                    billdetail bd 
                                where
                                    bd.rsvno = billdetail.rsvno 
                                    and bd.closedate = billdetail.closedate 
                                    and bd.billseq = billdetail.billseq 
                                    and bd.branchno = billdetail.branchno 
                                    and bd.detailname in ('乳房Ｘ線', '乳房超音波', '乳房Ｘ線・乳房超音波')
                            ) 
                            , ''
                        ) as breast_name
                        , nvl( 
                            ( 
                                select
                                    (bd.price + bd.editprice) as price 
                                from
                                    billdetail bd 
                                where
                                    bd.rsvno = billdetail.rsvno 
                                    and bd.closedate = billdetail.closedate 
                                    and bd.billseq = billdetail.billseq 
                                    and bd.branchno = billdetail.branchno 
                                    and bd.detailname in ('乳房Ｘ線', '乳房超音波', '乳房Ｘ線・乳房超音波')
                            ) 
                            , 0
                        ) as breast_price
                        , nvl( 
                            ( 
                                select
                                    (bd.taxprice + bd.edittax) as tax 
                                from
                                    billdetail bd 
                                where
                                    bd.rsvno = billdetail.rsvno 
                                    and bd.closedate = billdetail.closedate 
                                    and bd.billseq = billdetail.billseq 
                                    and bd.branchno = billdetail.branchno 
                                    and bd.detailname in ('乳房Ｘ線', '乳房超音波', '乳房Ｘ線・乳房超音波')
                            ) 
                            , 0
                        ) as breast_tax
                        , nvl( 
                            ( 
                                select
                                    ( 
                                        bd.price + bd.editprice + bd.taxprice + bd.edittax
                                    ) as total 
                                from
                                    billdetail bd 
                                where
                                    bd.rsvno = billdetail.rsvno 
                                    and bd.closedate = billdetail.closedate 
                                    and bd.billseq = billdetail.billseq 
                                    and bd.branchno = billdetail.branchno 
                                    and bd.detailname in ('乳房Ｘ線', '乳房超音波', '乳房Ｘ線・乳房超音波')
                            ) 
                            , 0
                        ) as breast_total 
                    from
                        bill
                        , billdetail
                        , org
                        , consult
                        , person
                        , free
                    ";

            if (noBillNo)
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

                if (!string.IsNullOrEmpty(queryParams["orgcd1"]) && !string.IsNullOrEmpty(queryParams["orgcd2"]))
                {
                    sql += @" 
                            and bill.orgcd1 = :orgcd1 
                            and bill.orgcd2 = :orgcd2
                    ";
                }
            }

            sql += @" 
                    and bill.orgcd1 = org.orgcd1 
                    and bill.orgcd2 = org.orgcd2 
                    and 'LO' || org.orgcd1 || org.orgcd2 = free.freecd(+) 
                    and bill.closedate = billdetail.closedate 
                    and bill.billseq = billdetail.billseq 
                    and bill.branchno = billdetail.branchno 
                    and billdetail.rsvno = consult.rsvno(+) 
                    and billdetail.perid = person.perid(+) 
                    --取消（削除）明細は出力対象外
                    and bill.delflg = :delflg 
                    --返金等の△金額の明細は出力対象外
                    and billdetail.price > 0 
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

            var sqlParam = new
            {
                strclosedate = (noBillNo == false) ? startDate : "",
                endclosedate = (noBillNo == false) ? endDate : "",
                orgcd1 = (noBillNo == false) ? orgCd1 : "",
                orgcd2 = (noBillNo == false) ? orgCd1 : "",
                closedate = (isBillNo == true) ? dcloseDate : (DateTime?)null,
                billseq = (isBillNo == true) ? billSeq : (long?)null,
                branchno = (isBillNo == true) ? branchNo : (long?)null,
                delflg = DelFlg.Used
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

            IList<dynamic> tagData = freeDao.SelectFree(1, FREE_ORGBILL);

            // 出力データの編集
            foreach (IDictionary<string, object> rec in data)
            {

                //
                if (Util.ConvertToString(rec["BSCOURSE"]) == "1" && Util.ConvertToString(rec["LIMITPRICE"]) != "0")
                {
                    continue;
                }

                var mainDic = new Dictionary<string, object>();

                foreach (var tagRec in tagData)
                {

                    int stCourse = 0;
                    string tmpData = "";

                    switch (Util.ConvertToString(tagRec.FREEFIELD1))
                    {
                        case "BAS":
                            // 抽出結果から出力
                            foreach (dynamic field in rec.Keys)
                            {
                                if (field == Util.ConvertToString(tagRec.FREEFIELD3))
                                {
                                    // SQLで取得したフィールド名と汎用テーブルが一致
                                    tmpData = Util.ConvertToString(rec[field]).Trim();
                                    break;
                                }
                            }
                            break;

                        case "CHK":
                            switch (Util.ConvertToString(tagRec.FREEFIELD3))
                            {
                                case "BILLPRINTNAME":
                                    if (Util.ConvertToString(rec["BILLCSLDIV"]) == "1")
                                    {
                                        tmpData = Util.ConvertToString(rec["BILLPRINTNAME"]).Trim();
                                    }
                                    break;

                                case "ISRSIGN":
                                    if (Util.ConvertToString(rec["BILLINS"]) == "1")
                                    {
                                        tmpData = Util.ConvertToString(rec["ISRSIGN"]).Trim();
                                    }
                                    break;

                                case "ISRNO":
                                    if (Util.ConvertToString(rec["BILLINS"]) == "1")
                                    {
                                        tmpData = Util.ConvertToString(rec["ISRNO"]).Trim();
                                    }
                                    break;

                                case "EMPNO":
                                    if (Util.ConvertToString(rec["BILLEMPNO"]) == "1")
                                    {
                                        tmpData = Util.ConvertToString(rec["EMPNO"]).Trim();
                                    }
                                    break;

                                case "AGE":
                                    if (Util.ConvertToString(rec["BILLAGE"]) == "1")
                                    {
                                        tmpData = Util.ConvertToString(rec["AGE"]).Trim();
                                    }
                                    break;
                            }
                            break;

                        case "EDT":

                            int.TryParse(Util.ConvertToString(rec["STCOURSE"]), out stCourse);

                            if (stCourse > 0 && !string.IsNullOrEmpty(Util.ConvertToString(rec["BREAST_NAME"])))
                            {
                                if (Util.ConvertToString(rec["LIMITPRICE"]).Trim() != "0")
                                {
                                    tmpData = Util.ConvertToString(rec["LIMITPRICE"]) + "・" + Util.ConvertToString(rec["BREAST_NAME"]) + Util.ConvertToString(rec["DETAILFOOTER"]);
                                }
                                else
                                {
                                    tmpData = Util.ConvertToString(rec["DETAILNAME"]).Trim();
                                }
                            }
                            else
                            {
                                //特定団体に限って限度額負担金の内訳を印刷する
                                if (Util.ConvertToString(rec["DETAILNAME"]).Trim() == "限度額負担")
                                {
                                    if (Util.ConvertToString(rec["LIMITPRICE"]).Trim() != "0")
                                    {
                                        // 限度額負担内訳取得
                                        if (int.TryParse(Util.ConvertToString(rec["RSVNO"]), out int rsvno))
                                        {

                                            dynamic limitData = GetD_Limit(rsvno);

                                            if (limitData.Count > 0)
                                            {
                                                tmpData = "限度額（";

                                                foreach (var detail in limitData)
                                                {
                                                    if (!string.IsNullOrEmpty(detail.FREEFIELD1.Trim()))
                                                    {
                                                        if (tmpData == "限度額（")
                                                        {
                                                            tmpData += "、" + detail.FREEFIELD1.Trim();
                                                        }
                                                        else
                                                        {
                                                            tmpData += detail.FREEFIELD1.Trim();
                                                        }
                                                    }
                                                }

                                                tmpData += "）";
                                            }
                                            else
                                            {
                                                tmpData = Util.ConvertToString(rec["DETAILNAME"]).Trim();
                                            }
                                        }
                                    }
                                    else
                                    {
                                        tmpData = Util.ConvertToString(rec["DETAILNAME"]).Trim();
                                    }
                                }
                                else
                                {
                                    tmpData = Util.ConvertToString(rec["DETAILNAME"]).Trim();
                                }
                            }
                            break;

                        case "AMT":
                            // 編集
                            if (Util.ConvertToString(tagRec.FREEFIELD3) == "BILLTOTAL")
                            {
                                int.TryParse(Util.ConvertToString(rec["STCOURSE"]), out stCourse);
                                if (stCourse > 0 && Util.ConvertToString(rec["LIMITPRICE"]) != "0")
                                {
                                    int billTotal = 0;
                                    int breastTotal = 0;

                                    int.TryParse(Util.ConvertToString(rec["BILLTOTAL"]), out billTotal);
                                    int.TryParse(Util.ConvertToString(rec["BREAST_TOTAL"]), out breastTotal);

                                    tmpData = Util.ConvertToString(billTotal + breastTotal);
                                }
                                else
                                {
                                    tmpData = Util.ConvertToString(rec["BILLTOTAL"]);
                                }
                            }
                            break;

                        case "FIX":
                            // 固定値
                            tmpData = Util.ConvertToString(tagRec.FREEFIELD5).Trim();
                            break;
                    }

                    mainDic.Add(Util.ConvertToString(tagRec.FREEFIELD4), tmpData);
                }

                returnData.Add(mainDic);

            }

            return returnData;
        }

        /// <summary>
        /// 限度額負担金内訳取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>編集後データ</returns>
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
                                    and 'LIMIT' || ctrpt_opt.setclasscd = free.freecd
                            ) lastview 
                        where
                            lastview.price > 0
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo
            };

            // SQLステートメント実行
            return connection.Query(sql, sqlParam).ToList();

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
