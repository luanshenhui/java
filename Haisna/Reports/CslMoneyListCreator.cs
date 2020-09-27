using Dapper;
using Hainsi.ReportCore;
using Hainsi.Common;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    //[LoggingParam]
    public class CslMoneyListCreator : CsvCreator
    {
        /// <summary>
        /// 個人受診金額一覧データを読み込み
        /// </summary>
        /// <returns>個人受診金額一覧データ</returns>
        protected override List<dynamic> GetData()
        {

            string startDate = queryParams["startdate"];
            string endDate = queryParams["enddate"];
            string csCd = queryParams["cscd"];
            string orgCd1 = queryParams["orgcd1"];
            string orgCd2 = queryParams["orgcd2"];
            string billNo = queryParams["billno"];
            double dbillNo;
            string closeDate;
            bool isBillNo = false;
            // 仮の初期値を設定
            DateTime dcloseDate = System.DateTime.Now;
            long billSeq = 0;
            long branchNo = 0;
            

            if (double.TryParse(billNo, out dbillNo))
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

            string sql =
                  @"
                    select
                        consult.orgcd1 団体コード１
                        , consult.orgcd2 団体コード２
                        , org.orgname 団体名称
                        , consult.cscd コースコード
                        , course_p.csname コース名
                        , consult.csldate 受診日
                        , consult.rsvno 予約番号
                        , consult.perid 個人ＩＤ
                        , rtrim(person.lastname || '　' || person.firstname, '　') 氏名
                        , rtrim( 
                            person.lastkname || '　' || person.firstkname
                            , '　'
                        ) カナ氏名
                        , decode(person.gender, 1, '男性', 2, '女性', null) 性別
                        , person.birth 生年月日
                        , round(consult.age, 0) 年齢
                        , consult.isrsign 健保記号
                        , consult.isrno 健保番号
                        , receipt.dayid 当日ＩＤ
                        , decode( 
                            consult.collectticket
                            , null
                            , '未回収'
                            , 1
                            , '回収済み'
                            , ''
                        ) 利用券回収
                        , consult.ctrptcd 契約パターンコード
                        , consult_m.orgcd1 負担元団体コード１
                        , consult_m.orgcd2 負担元団体コード２
                        , org2.orgname 負担元名称
                        , consult_m.optcd　 || '-' || consult_m.optbranchno 請求明細分類コード
                        , ctrpt_opt.optname 請求明細分類名
                        , consult_m.price 金額
                        , consult_m.editprice 調整金額
                        , consult_m.taxprice 税額
                        , consult_m.edittax 調整税額
                        , to_char(consult_m.dmddate, 'YYYYMMDD') || trim(to_char(consult_m.billseq, '00000')) || consult_m.branchno
                         個人負担請求書NO 
                    from
                        dmdlineclass
                        , org org2
                        , consult_m
                        , ctrpt_opt
                        , receipt
                        , course_p
                        , person
                        , org
                        , consult
                    ";

            // 受診日指定時の条件節
            int mode = int.Parse(queryParams["mode"]);
            if (mode == 0)
            {
                sql += @" 
                    where
                        consult.csldate between :startdate and :enddate 
                        and consult.cscd = nvl(:cscd, consult.cscd) 
                        and consult.orgcd1 = nvl(:orgcd1, consult.orgcd1) 
                        and consult.orgcd2 = nvl(:orgcd2, consult.orgcd2)
                    ";

                // 未受付受診情報を含まない場合は条件を追加
                string allowUnReceipt = Util.ConvertToString(queryParams["allowunreceipt"]);
                if (allowUnReceipt == "0")
                {
                    sql += @" 
                        and exists ( 
                                        select
                                            rsvno 
                                        from
                                            receipt 
                                        where
                                            rsvno = consult.rsvno 
                                            and receipt.comedate is not null
                                    ) 
                    ";
                }

            }
            // 締め日指定時の条件節
            else
            {
                if (string.IsNullOrEmpty(billNo))
                {
                    sql = sql.TrimEnd() + @" 
                            , ( 
                                select distinct
                                    closemng.rsvno 
                                from
                                    closemng
                                    , bill 
                                where
                                    bill.closedate between :startdate and :enddate 
                                    and bill.orgcd1 = nvl(:orgcd1, bill.orgcd1) 
                                    and bill.orgcd2 = nvl(:orgcd2, bill.orgcd2) 
                                    and bill.closedate = nvl(:closedate, bill.closedate) 
                                    and bill.billseq = nvl(:billseq, bill.billseq) 
                                    and bill.branchno = nvl(:branchno, bill.branchno) 
                                    and bill.closedate = closemng.closedate 
                                    and bill.billseq = closemng.billseq 
                                    and bill.branchno = closemng.branchno
                            ) closedconsult 
                            where
                                closedconsult.rsvno = consult.rsvno
                    ";
                }
                else
                {
                    sql = sql.TrimEnd() + @" 
                            , ( 
                                select distinct
                                    closemng.rsvno 
                                from
                                    closemng
                                    , bill 
                                where
                                    bill.closedate = nvl(:closedate, bill.closedate) 
                                    and bill.billseq = nvl(:billseq, bill.billseq) 
                                    and bill.branchno = nvl(:branchno, bill.branchno) 
                                    and bill.closedate = closemng.closedate 
                                    and bill.billseq = closemng.billseq 
                                    and bill.branchno = closemng.branchno
                            ) closedconsult 
                            where
                                closedconsult.rsvno = consult.rsvno
                    ";
                }
            }

            sql +=
                  @"
                    and consult.orgcd1 = org.orgcd1 
                    and consult.orgcd2 = org.orgcd2 
                    and consult.perid = person.perid 
                    and consult.rsvno = receipt.rsvno(+) 
                    and consult.csldate = receipt.csldate(+) 
                    and consult.cscd = course_p.cscd 
                    and consult.rsvno = consult_m.rsvno(+) 
                    and consult_m.orgcd1 = org2.orgcd1(+) 
                    and consult_m.orgcd2 = org2.orgcd2(+) 
                    and consult_m.ctrptcd = ctrpt_opt.ctrptcd(+) 
                    and consult_m.optcd = ctrpt_opt.optcd(+) 
                    and consult_m.optbranchno = ctrpt_opt.optbranchno(+) 
                    and consult_m.dmdlineclasscd = dmdlineclass.dmdlineclasscd(+) 
                    order by
                        consult.orgcd1
                        , consult.orgcd2
                        , person.lastkname
                        , person.firstkname nulls first
                        , consult.csldate
                        , consult.cscd
                        , consult_m.orgcd1
                        , consult_m.orgcd2
                        , consult_m.cscd
                        , consult_m.dmdlineclasscd
                    ";

            var sqlParam = new
            {
                startdate = startDate,
                enddate = endDate,
                cscd = csCd,
                orgcd1 = orgCd1,
                orgcd2 = orgCd2,
                closedate = (isBillNo == true) ? dcloseDate : (DateTime?)null,
                billseq = (isBillNo == true) ? billSeq : (long?)null,
                branchno = (isBillNo == true) ? branchNo : (long?)null
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

            if (int.TryParse(queryParams["mode"], out mode))
            {
                if (mode == 0)
                // 受診日指定の場合
                {
                    if (! DateTime.TryParse(queryParams["startdate"], out tmpDate))
                    {
                        messages.Add("開始受診日の入力形式が正しくありません。");
                    }
                    if (!DateTime.TryParse(queryParams["enddate"], out tmpDate))
                    {
                        messages.Add("終了受診日の入力形式が正しくありません。");                        
                    }
                }
                else
                // 締め日指定の場合
                {
                    if (!DateTime.TryParse(queryParams["startdate"], out tmpDate))
                    {
                        messages.Add("開始締め日の入力形式が正しくありません。");
                    }
                    if (!DateTime.TryParse(queryParams["enddate"], out tmpDate))
                    {
                        messages.Add("終了締め日の入力形式が正しくありません。");
                    }
                }

                String tmpMsg = WebHains.CheckNumeric("請求書番号", queryParams["billno"], 14);
                if (!string.IsNullOrEmpty(tmpMsg))
                {
                    messages.Add(tmpMsg);
                }

            }

            return messages;
        }
    }
}
