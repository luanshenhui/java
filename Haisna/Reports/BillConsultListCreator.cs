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
    public class BillConsultListCreator : CsvCreator
    {
        /// <summary>
        /// 請求受診情報一覧データを読み込み
        /// </summary>
        /// <returns>請求受診情報一覧データ</returns>
        protected override List<dynamic> GetData()
        {

            string startDate = queryParams["startdate"];
            string endDate = queryParams["enddate"];
            string noDemandData = Util.ConvertToString(queryParams["nodemanddata"]);
            string billNo = queryParams["billno"];
            int mode = int.Parse(queryParams["mode"]);
            double dbillNo;
            string closeDate;
            DateTime dcloseDate = System.DateTime.Now;
            long billSeq = 0;
            long branchNo = 0;
            bool isBillNo = false;

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
                        baseinfo.orgcd1 負担団体コード１
                        , baseinfo.orgcd2 負担団体コード２
                        , org.orgname 負担元名称
                        , baseinfo.cscd 負担コースコード
                        , course_p.csname 負担コース名
                        , to_char(closemng.closedate, 'YYYYMMDD') || trim(to_char(closemng.billseq, '00000')) || to_char(closemng.branchno)
                         as 請求書番号
                        , consult.csldate 受診日
                        , baseinfo.rsvno 予約番号
                        , consult.perid 個人ｉｄ
                        , person.lastname || '　' || person.firstname 氏名
                        , person.lastkname || '　' || person.firstkname カナ氏名
                        , decode(person.gender, 1, '男性', '女性') 性別
                        , person.birth 生年月日
                        , round(consult.age, 0) 年齢
                        , consult.isrsign 健保記号
                        , consult.isrno 健保番号
                        , consult.orgcd1 依頼団体コード１
                        , consult.orgcd2 依頼団体コード２
                        , cslorg.orgname 依頼団体名
                        , ( 
                            select
                                sum(price) 
                            from
                                consult_m 
                            where
                                consult_m.rsvno = baseinfo.rsvno 
                                and consult_m.orgcd1 = baseinfo.orgcd1 
                                and consult_m.orgcd2 = baseinfo.orgcd2 
                                and consult_m.cscd = baseinfo.cscd
                        ) 金額
                        , ( 
                            select
                                sum(editprice) 
                            from
                                consult_m 
                            where
                                consult_m.rsvno = baseinfo.rsvno 
                                and consult_m.orgcd1 = baseinfo.orgcd1 
                                and consult_m.orgcd2 = baseinfo.orgcd2 
                                and consult_m.cscd = baseinfo.cscd
                        ) 調整金額
                        , ( 
                            select
                                sum(taxprice) 
                            from
                                consult_m 
                            where
                                consult_m.rsvno = baseinfo.rsvno 
                                and consult_m.orgcd1 = baseinfo.orgcd1 
                                and consult_m.orgcd2 = baseinfo.orgcd2 
                                and consult_m.cscd = baseinfo.cscd
                        ) 税額
                        , ( 
                            select
                                sum(edittax) 
                            from
                                consult_m 
                            where
                                consult_m.rsvno = baseinfo.rsvno 
                                and consult_m.orgcd1 = baseinfo.orgcd1 
                                and consult_m.orgcd2 = baseinfo.orgcd2 
                                and consult_m.cscd = baseinfo.cscd
                        ) 調整税額
                    from
                        course_p
                        , org
                        , closemng
                        , consult
                        , person
                        , org cslorg
                        , ( 
                            select distinct
                                consult_m.rsvno
                                , consult_m.orgcd1
                                , consult_m.orgcd2
                                , consult_m.cscd 
                            from
                                consult_m 
                            where
                                consult_m.rsvno in
                    ";

            // 受診日指定時の条件節
            if (mode == 0)
            {
                sql += @" 
                        ( 
                            select
                                consult.rsvno 
                            from
                                receipt
                                , consult 
                            where
                                consult.csldate between :strcsldate and :endcsldate 
                                and consult.cancelflg = :cancelflg 
                                and receipt.rsvno = consult.rsvno
                        ) 
                    ";
            }
            // 請求書No指定時の条件節
            else
            {
                sql += @" 
                        ( 
                            select
                                closemng.rsvno 
                            from
                                closemng 
                            where
                                closemng.closedate = :closedate 
                                and closemng.billseq = :billseq 
                                and closemng.branchno = :branchno
                        ) 
                    ";
            }

            sql +=
                  @"
                    ) baseinfo 
                    where
                        baseinfo.rsvno = closemng.rsvno(+) 
                        and baseinfo.orgcd1 = closemng.orgcd1(+) 
                        and baseinfo.orgcd2 = closemng.orgcd2(+) 
                        and org.orgcd1 = baseinfo.orgcd1 
                        and org.orgcd2 = baseinfo.orgcd2 
                        and course_p.cscd = baseinfo.cscd 
                        and consult.rsvno = baseinfo.rsvno 
                        and person.perid = consult.perid 
                        and cslorg.orgcd1 = consult.orgcd1 
                        and cslorg.orgcd2 = consult.orgcd2
                    ";

            // 未請求情報のみの場合は条件を追加
            if (noDemandData == "1" && mode == 0)
            {
                sql +=
                      @"
                        and closemng.closedate is null 
                        and closemng.billseq is null 
                        and closemng.branchno is null
                    ";
            }

            sql +=
                  @"
                    order by
                        baseinfo.orgcd1
                        , baseinfo.orgcd2
                        , baseinfo.cscd
                    ";

            var sqlParam = new
            {
                strcsldate = startDate,
                endcsldate = endDate,
                closedate = (isBillNo == true) ? dcloseDate : (DateTime?)null,
                billseq = (isBillNo == true) ? billSeq : (long?)null,
                branchno = (isBillNo == true) ? branchNo : (long?)null,
                cancelflg = ConsultCancel.Used
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
                // 請求書番号の場合
                {
                    tmpMsg = WebHains.CheckNumeric("請求書番号", queryParams["billno"], 14);
                    if (!string.IsNullOrEmpty(tmpMsg))
                    {
                        messages.Add(tmpMsg);
                    }
                }

            }

            return messages;
        }
    }
}
