using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 請求書情報データアクセスオブジェクト
    /// </summary>
    public class BillDao : AbstractDao
    {
        private const int ITEMCNT = 4;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public BillDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 請求書テーブルからレコードを取得する。
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="startCloseDate">締め日（開始日）</param>
        /// <param name="endCloseDate">締め日（終了日）</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="billClassCd">請求書分類コード</param>
        /// <param name="outPutCls">出力対象区分</param>
        /// <returns>
        /// billNo             請求書Ｎｏ
        /// closeDate          締め日
        /// orgCd1             団体コード１
        /// orgCd2             団体コード２
        /// billClassCd        請求書分類コード
        /// method             作成方法
        /// taxRates           適用税率
        /// prtDate            請求書出力日
        /// orgName            団体名称
        /// orgBillName        請求書用名称
        /// chageName          担当者名
        /// orgDiv             団体種別
        /// billClassName      請求書分類名
        /// </returns>
        public List<dynamic> SelectPrintBill(string billNo, string startCloseDate, string endCloseDate, string orgCd1, string orgCd2, string billClassCd, string outPutCls)
        {
            // 初期設定
            string conditionStr = " where ";

            // キー値の設定
            var param = new Dictionary<string, object>();
            if (!"".Equals(billNo))
            {
                param.Add("billno", billNo);
            }
            if (!"".Equals(startCloseDate))
            {
                param.Add("startclosedate", startCloseDate);
            }
            if (!"".Equals(endCloseDate))
            {
                param.Add("endclosedate", endCloseDate);
            }
            if (!"".Equals(orgCd1))
            {
                param.Add("orgcd1", orgCd1);
            }
            if (!"".Equals(orgCd2))
            {
                param.Add("orgcd2", orgCd2);
            }
            if (!"".Equals(billClassCd))
            {
                param.Add("billclasscd", billClassCd);
            }

            // 請求書テーブルから取得
            string sql = @"
                            select
                              bill.billno
                              , bill.closedate
                              , bill.orgcd1
                              , bill.orgcd2
                              , bill.billclasscd
                              , bill.method
                              , bill.taxrates
                              , bill.prtdate
                              , org.orgname
                              , org.orgbillname
                              , org.chargename
                              , org.orgdiv
                              , billclass.billclassname
                            from
                              bill
                              , org
                              , billclass
                        ";

            if (!"".Equals(billNo) || !"".Equals(startCloseDate)
                || !"".Equals(endCloseDate) || !"".Equals(orgCd1)
                || !"".Equals(orgCd2) || !"".Equals(billClassCd))
            {
                // 請求書番号
                if (!"".Equals(billNo))
                {
                    sql += conditionStr + " bill.billno    = :billno ";
                    conditionStr = " and ";
                }
                else
                {
                    // 締め日（開始日）
                    if (!"".Equals(startCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    >= :startclosedate ";
                        conditionStr = " and ";
                    }

                    // 締め日（終了日）
                    if (!"".Equals(endCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    <= :endclosedate ";
                        conditionStr = " and ";
                    }

                    // 団体コード１
                    if (!"".Equals(orgCd1))
                    {
                        sql += conditionStr + " bill.orgcd1    = :orgcd1 ";
                        conditionStr = " and ";
                    }

                    // 団体コード２
                    if (!"".Equals(orgCd2))
                    {
                        sql += conditionStr + " bill.orgcd2    = :orgcd2 ";
                        conditionStr = " and ";
                    }

                    // 請求書分類コード
                    if (!"".Equals(billClassCd))
                    {
                        sql += conditionStr + " bill.billclasscd    = :billclasscd ";
                        conditionStr = " and ";
                    }
                }
            }

            // 出力条件の設定
            switch (outPutCls)
            {
                case "1":
                    sql += conditionStr + " bill.prtdate is null ";
                    conditionStr = " and ";
                    break;

                case "2":
                    sql += conditionStr + " bill.prtdate is not null ";
                    conditionStr = " and ";
                    break;
            }

            sql += conditionStr + @"
                                    bill.orgcd1 = org.orgcd1
                                    and bill.orgcd2 = org.orgcd2
                                    and bill.billclasscd = billclass.billclasscd
                                    order by
                                      bill.billno
                                ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 請求書団体別コース管理テーブルからレコードを取得する。
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="seq">ＳＥＱ</param>
        /// <param name="csSeq">コースＳＥＱ</param>
        /// <param name="lineNo">明細Ｎｏ</param>
        /// <returns>
        /// billNo             請求書番号
        /// seq                ＳＥＱ
        /// csSeq              コースＳＥＱ
        /// csCd               コースコード
        /// strDate            開始受診日
        /// endDate            終了受診日
        /// cslCnt             受診人数
        /// csName             コース名
        /// </returns>
        public List<dynamic> SelectPrintBillOrg(string billNo, string seq, string csSeq, string lineNo)
        {
            // 初期設定
            string conditionStr = " where ";

            // キー値の設定
            var param = new Dictionary<string, object>();
            if (!"".Equals(billNo))
            {
                param.Add("billno", billNo);
            }
            if (!"".Equals(seq))
            {
                param.Add("seq", seq);
            }
            if (!"".Equals(csSeq))
            {
                param.Add("csseq", csSeq);
            }
            if (!"".Equals(lineNo))
            {
                param.Add("lineno", lineNo);
            }

            // 請求書明細テーブルから取得
            string sql = @"
                            select
                              bill_course.billno
                              , bill_course.cscd
                              , min(bill_course.strdate) strdate
                              , max(bill_course.enddate) enddate
                              , sum(bill_course.cslcnt) cslcnt
                              , (
                                select
                                  course_p.csname
                                from
                                  course_p
                                where
                                  bill_course.cscd = course_p.cscd
                              ) csname
                            from
                              bill_course
                       ";

            if (!"".Equals(billNo) || !"".Equals(seq)
                || !"".Equals(csSeq))
            {
                // 請求書番号
                if (!"".Equals(billNo))
                {
                    sql += conditionStr + " billno    = :billno ";
                    conditionStr = " and ";
                }

                // ＳＥＱ
                if (!"".Equals(seq))
                {
                    sql += conditionStr + " seq    = :seq ";
                    conditionStr = " and ";
                }

                // コースＳＥＱ
                if (!"".Equals(csSeq))
                {
                    sql += conditionStr + " csseq    = :csseq ";
                    conditionStr = " and ";
                }
            }

            // グルーピングの設定
            sql += @"
                    group by
                      billno
                      , cscd
                    order by
                      billno
                      , cscd
                 ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 請求書明細テーブルの金額，消費税，合計の総和を取得する。
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="seq">ＳＥＱ</param>
        /// <param name="csSeq">コースＳＥＱ</param>
        /// <param name="lineNo">明細Ｎｏ</param>
        /// <param name="groupCls">合計分類</param>
        /// <returns>
        /// billNo             請求書番号
        /// seq                ＳＥＱ
        /// csSeq              コースＳＥＱ
        /// lineNo             明細番号
        /// totalCnt           合計人数
        /// subTotal           金額
        /// tax                消費税
        /// discount           値引き
        /// total              合計
        /// </returns>
        public List<dynamic> SelectSumBillDetail(string billNo, string seq, string csSeq, string lineNo, int groupCls)
        {
            string conditionStr;
            string clm;
            string[] arrClmName = new string[ITEMCNT];

            if (groupCls > ITEMCNT || groupCls < 1)
            {
                throw new ArgumentException();
            }

            // 初期設定
            conditionStr = " where ";
            arrClmName[0] = "billno";
            arrClmName[1] = "seq";
            arrClmName[2] = "csseq";
            arrClmName[3] = "lineno";
            clm = "";

            for (int i = 0; i <= (groupCls - 1); i++)
            {
                if (i == 0)
                {
                    clm = clm + arrClmName[i];
                }
                else
                {
                    clm = clm + "," + arrClmName[i];
                }
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            if (!"".Equals(billNo))
            {
                param.Add("billno", billNo);
            }
            if (!"".Equals(seq))
            {
                param.Add("seq", seq);
            }
            if (!"".Equals(csSeq))
            {
                param.Add("csseq", csSeq);
            }
            if (!"".Equals(lineNo))
            {
                param.Add("lineno", lineNo);
            }

            // 請求書明細テーブルから取得
            string sql = " select " + clm;

            sql += @"
                    , sum(totalcnt) totalcnt
                    , sum(subtotal) subtotal
                    , sum(tax) tax
                    , sum(discount) discount
                    , sum(total) total
                    from
                      billdetail
                  ";

            if (!"".Equals(billNo) || !"".Equals(seq)
                || !"".Equals(csSeq) || !"".Equals(lineNo))
            {
                // 請求書番号
                if (!"".Equals(billNo))
                {
                    sql += conditionStr + " billno    = :billno ";
                    conditionStr = " and ";
                }

                // ＳＥＱ
                if (!"".Equals(seq))
                {
                    sql += conditionStr + " seq    = :seq ";
                }

                // コースＳＥＱ
                if (!"".Equals(csSeq))
                {
                    sql += conditionStr + " csseq    = :csseq ";
                }

                // 明細番号
                if (!"".Equals(lineNo))
                {
                    sql += conditionStr + " lineno    = :lineno ";
                }
            }

            // グルーピングの設定
            sql += " group by " + clm + " order by " + clm;

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 請求書団体別コース管理テーブルからレコードを取得する。
        /// </summary>
        /// <param name="sumCls">グルーピング分類</param>
        /// <param name="billNo">請求書番号</param>
        /// <param name="seq">ＳＥＱ</param>
        /// <param name="csSeq">コースＳＥＱ</param>
        /// <param name="lineNo">明細Ｎｏ</param>
        /// <returns>
        /// billNo             請求書番号
        /// seq                ＳＥＱ
        /// csSeq              コースＳＥＱ
        /// csCd               コースコード
        /// strDate            開始受診日
        /// endDate            終了受診日
        /// cslCnt             受診人数
        /// csName             コース名
        /// </returns>
        public List<dynamic> SelectPrintBillCourse(string sumCls, string billNo, string seq, string csSeq, string lineNo)
        {
            // 初期設定
            string conditionStr = " where ";
            string group = "";

            switch (sumCls)
            {
                case "1":
                    group = " bill_course.billno,bill_course.cscd ";
                    break;
                case "2":
                    group = " bill_course.billno,bill_course.seq ";
                    break;
                default:
                    group = " bill_course.billno,bill_course.seq, bill_course.csseq ";
                    break;
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            if (!"".Equals(billNo))
            {
                param.Add("billno", billNo);
            }
            if (!"".Equals(seq))
            {
                param.Add("seq", seq);
            }
            if (!"".Equals(csSeq))
            {
                param.Add("csseq", csSeq);
            }
            if (!"".Equals(lineNo))
            {
                param.Add("lineno", lineNo);
            }

            // 請求書明細テーブルから取得
            string sql = " select " + group + " , ";
            sql += @"
                     min(bill_course.strdate) strdate
                     , max(bill_course.enddate) enddate
                     , sum(bill_course.cslcnt) cslcnt
                 ";

            if (sumCls == "1")
            {
                sql += " , (select course_p.csname from course_p where bill_course.cscd = course_p.cscd ) csname ";
            }

            sql += " from  bill_course ";

            if (!"".Equals(billNo) || !"".Equals(sql)
                || !"".Equals(csSeq))
            {
                // 請求書番号
                if (!"".Equals(billNo))
                {
                    sql += conditionStr + " billno    = :billno ";
                    conditionStr = " and ";
                }

                // ＳＥＱ
                if (!"".Equals(seq))
                {
                    sql += conditionStr + " seq    = :seq ";
                    conditionStr = " and ";
                }

                // コースＳＥＱ
                if (!"".Equals(csSeq))
                {
                    sql += conditionStr + " csseq    = :csseq ";
                    conditionStr = " and ";
                }
            }

            // *****  コースに関係ない請求はコースコードがNULLとなるため、CSCDがNULLのレコードは対象外とする
            sql += " and  cscd  is not  null ";

            // グルーピングの設定
            sql += " group by " + group + " order by " + group;

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 請求書明細テーブルからレコードを取得する。
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="seq">ＳＥＱ</param>
        /// <param name="csSeq">コースＳＥＱ</param>
        /// <param name="lineNo">明細Ｎｏ</param>
        /// <returns>
        /// billNo             請求書番号
        /// seq                ＳＥＱ
        /// csSeq              コースＳＥＱ
        /// lineNo             明細番号
        /// dmdLineClassCd     請求書明細分類コード
        /// noPrint            請求書未出力フラグ
        /// detailName         名称
        /// ageDiv             年齢区分
        /// existsIsr          健保有無区分
        /// totalCnt           合計人数
        /// subTotal           金額
        /// tax                消費税
        /// discount           値引き
        /// total              合計
        /// csCd               コースコード
        /// csName             コース名
        /// </returns>
        public List<dynamic> SelectPrintBillDetail(string billNo, string seq, string csSeq, string lineNo)
        {
            if (!Util.IsNumber(billNo))
            {
                throw new ArgumentException();
            }

            // 初期設定
            string conditionStr = " where ";

            // キー値の設定
            var param = new Dictionary<string, object>();
            if (!"".Equals(billNo))
            {
                param.Add("billno", billNo);
            }
            if (!"".Equals(seq))
            {
                param.Add("seq", seq);
            }
            if (!"".Equals(csSeq))
            {
                param.Add("csseq", csSeq);
            }
            if (!"".Equals(lineNo))
            {
                param.Add("lineno", lineNo);
            }

            // 検索条件を満たす請求書団体管理情報のレコードを取得
            string sql = @"
                            select
                              billdetail.billno
                              , billdetail.seq
                              , billdetail.csseq
                              , billdetail.lineno
                              , billdetail.dmdlineclasscd
                              , billdetail.noprint
                              , billdetail.detailname
                              , billdetail.agediv
                              , billdetail.existsisr
                              , billdetail.price
                              , billdetail.totalcnt
                              , billdetail.subtotal
                              , billdetail.tax
                              , billdetail.discount
                              , billdetail.total
                              , bill_course.cscd
                              , (
                                select
                                  csname
                                from
                                  course_p
                                where
                                  bill_course.cscd = course_p.cscd
                              ) csname
                            from
                              billdetail
                              , bill_course
                       ";

            if (!"".Equals(billNo) || !"".Equals(seq)
                || !"".Equals(csSeq) || !"".Equals(lineNo))
            {
                // 請求書番号
                if (!"".Equals(billNo))
                {
                    sql += conditionStr + " billdetail.billno    = :billno ";
                    conditionStr = " and ";
                }

                // ＳＥＱ
                if (!"".Equals(seq))
                {
                    sql += conditionStr + " billdetail.seq    = :seq ";
                    conditionStr = " and ";
                }

                // コースＳＥＱ
                if (!"".Equals(csSeq))
                {
                    sql += conditionStr + " billdetail.csseq    = :csseq ";
                    conditionStr = " and ";
                }

                // 明細番号
                if (!"".Equals(lineNo))
                {
                    sql += conditionStr + " billdetail.lineno    = :lineno ";
                    conditionStr = " and ";
                }
            }

            sql += @"
                    and billdetail.noprint = 0
                    and billdetail.billno = bill_course.billno
                    and billdetail.seq = bill_course.seq
                    and billdetail.csseq = bill_course.csseq
                    order by
                      billdetail.billno
                      , billdetail.seq
                      , billdetail.csseq
                      , billdetail.lineno
                 ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 請求書テーブルからレコードを取得する。
        /// </summary>
        /// <param name="data">
        /// billNo             請求書番号
        /// startCloseDate     締め日（開始日）
        /// endCloseDate       締め日（終了日）
        /// orgCd1             団体コード１
        /// orgCd2             団体コード２
        /// billClassCd        請求書分類コード
        /// </param>
        /// <returns>取得件数</returns>
        public int UpdateBillPrtDate(JToken data)
        {

            // 初期設定
            string conditionStr = " where ";
            // 締め日請求書番号
            string billNo = Convert.ToString(data["billno"]);
            // 締め日（開始日）
            DateTime startCloseDate = Convert.ToDateTime(data["startclosedate"]);
            // 締め日（終了日）
            DateTime endCloseDate = Convert.ToDateTime(data["endclosedate"]);
            // 団体コード１
            string orgCd1 = Convert.ToString(data["rgcd1"]);
            // 団体コード２
            string orgCd2 = Convert.ToString(data["rgcd2"]);
            // 請求書分類コード
            string billClassCd = Convert.ToString(data["billclasscd"]);

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            if (!"".Equals(billNo))
            {
                param.Add("billno", billNo);
            }
            if (!"".Equals(startCloseDate))
            {
                param.Add("startclosedate", startCloseDate);
            }
            if (!"".Equals(endCloseDate))
            {
                param.Add("endclosedate", endCloseDate);
            }
            if (!"".Equals(orgCd1))
            {
                param.Add("orgcd1", orgCd1);
            }
            if (!"".Equals(orgCd2))
            {
                param.Add("orgcd2", orgCd2);
            }
            if (!"".Equals(billClassCd))
            {
                param.Add("billclasscd", billClassCd);
            }

            // 請求書テーブルから取得
            string sql = @"
                           update bill
                           set
                             prtdate = sysdate
                        ";

            if (!"".Equals(billNo) || !"".Equals(startCloseDate)
                || !"".Equals(endCloseDate) || !"".Equals(orgCd1)
                || !"".Equals(orgCd2) || !"".Equals(billClassCd))
            {
                // 請求書番号
                if (!"".Equals(billNo))
                {
                    sql += conditionStr + " bill.billno    = :billno ";
                    conditionStr = " and ";
                }

                // 締め日（開始日）
                if (!"".Equals(startCloseDate))
                {
                    sql += conditionStr + " bill.closedate    >= :startclosedate ";
                    conditionStr = " and ";
                }

                // 締め日（終了日）
                if (!"".Equals(endCloseDate))
                {
                    sql += conditionStr + " bill.closedate    <= :endclosedate ";
                    conditionStr = " and ";
                }

                // 団体コード１
                if (!"".Equals(orgCd1))
                {
                    sql += conditionStr + " bill.orgcd1    = :orgcd1 ";
                    conditionStr = " and ";
                }

                // 団体コード２
                if (!"".Equals(orgCd2))
                {
                    sql += conditionStr + " bill.orgcd2    = :orgcd2 ";
                    conditionStr = " and ";
                }

                // 請求書分類コード
                if (!"".Equals(billClassCd))
                {
                    sql += conditionStr + " bill.billclasscd    = :billclasscd ";
                    conditionStr = " and ";
                }
            }

            // 出力条件の設定
            sql += conditionStr + " bill.prtdate is null ";

            int ret = connection.Execute(sql, param);

            if (ret < 0)
            {
                ret = int.Parse(Insert.Duplicate.ToString());
            }
            return ret;
        }

        /// <summary>
        /// 入力条件に合致する請求書，請求書団体管理テーブルのデータを取得する
        /// </summary>
        /// <param name="sortFlg">ソートフラグ</param>
        /// <param name="strCloseDate">締め日（開始日）</param>
        /// <param name="endCloseDate">締め日（終了日）</param>
        /// <param name="isrOrgCd1">健保団体コード１</param>
        /// <param name="isrOrgCd2">健保団体コード２</param>
        /// <param name="orgDiv">団体分類</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="isrSign">健保記号</param>
        /// <param name="billNo">請求書番号</param>
        /// <param name="billClassCd">請求書分類コード</param>
        /// <returns>
        /// billNo             請求書番号
        /// orgCd1             団体コード１
        /// orgCd2             団体コード２
        /// closeDate          締め日
        /// billTitol          請求書用タイトル
        /// billClassCd        請求書分類コード
        /// billClassCd        請求書分類名
        /// orgName            団体名称
        /// seq                ＳＥＱ
        /// cslOrgCd1          受診団体コード１
        /// cslOrgCd2          受診団体コード２
        /// isrSign            健保記号
        /// cslOrgName         受診団体名称
        /// chargeName         担当者名
        /// orgBillName        団体請求名
        /// </returns>
        public List<dynamic> SelectDemandDetailList(string sortFlg, string strCloseDate, string endCloseDate, string isrOrgCd1, string isrOrgCd2, string orgDiv, string orgCd1, string orgCd2, string isrSign, string billNo, string billClassCd)
        {
            // 初期設定
            string conditionStr = " where ";

            // キー値の設定
            var param = new Dictionary<string, object>();
            if (!"".Equals(strCloseDate))
            {
                param.Add("strclosedate", Convert.ToDateTime(strCloseDate));
            }
            if (!"".Equals(endCloseDate))
            {
                param.Add("endclosedate", Convert.ToDateTime(endCloseDate));
            }
            if (!"".Equals(isrOrgCd1))
            {
                param.Add("isrorgcd1", isrOrgCd1);
            }
            if (!"".Equals(isrOrgCd2))
            {
                param.Add("isrorgcd2", isrOrgCd2);
            }
            if (!"".Equals(orgDiv))
            {
                param.Add("orgdiv", orgDiv);
            }
            if (!"".Equals(orgCd1))
            {
                param.Add("orgcd1", orgCd1);
            }
            if (!"".Equals(orgCd2))
            {
                param.Add("orgcd2", orgCd2);
            }
            if (!"".Equals(isrSign))
            {
                param.Add("isrsign", isrSign);
            }
            if (!"".Equals(billClassCd))
            {
                param.Add("billclasscd", billClassCd);
            }

            // 請求書テーブルからデータを取得
            string sql = @"
                            select
                              billtbl.billno billno
                              , billtbl.orgcd1 orgcd1
                              , billtbl.orgcd2 orgcd2
                              , billtbl.billclasscd billclasscd
                              , billtbl.closedate closedate
                              , billtbl.billtitle billtitle
                              , billtbl.orgname orgname
                              , billtbl.billclassname billclassname
                              , billorgtbl.seq seq
                              , billorgtbl.cslorgcd1 cslorgcd1
                              , billorgtbl.cslorgcd2 cslorgcd2
                              , billorgtbl.isrsign isrsign
                              , billorgtbl.orgname cslorgname
                              , billorgtbl.chargename chargename
                              , billorgtbl.orgbillname orgbillname
                            from
                              (
                                select
                                  bill.billno
                                  , bill.orgcd1
                                  , bill.orgcd2
                                  , bill.billclasscd
                                  , bill.closedate
                                  , billclass.billtitle
                                  , billclass.billclassname
                                  , org.orgname
                                from
                                  bill
                                  , org
                                  , billclass
                         ";

            if (!"".Equals(billNo) || !"".Equals(strCloseDate)
                || !"".Equals(endCloseDate) || !"".Equals(isrOrgCd1)
                || !"".Equals(isrOrgCd2) || !"".Equals(billClassCd))
            {
                // 請求書番号
                if (!"".Equals(billNo))
                {
                    sql += conditionStr + " bill.billno    = :billno ";
                    conditionStr = " and ";
                }

                // 健保団体１
                if (!"".Equals(isrOrgCd1))
                {
                    sql += conditionStr + " bill.orgcd1    = :isrorgcd1 ";
                    conditionStr = " and ";
                }

                // 健保団体２
                if (!"".Equals(isrOrgCd2))
                {
                    sql += conditionStr + " bill.orgcd2    = :isrorgcd2 ";
                    conditionStr = " and ";
                }

                if (!"".Equals(strCloseDate) && !"".Equals(endCloseDate))
                {
                    // 締め日（開始日）
                    if (!"".Equals(strCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    >= :strclosedate ";
                        conditionStr = " and ";
                    }

                    // 締め日（終了日）
                    if (!"".Equals(endCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    <= :endclosedate ";
                        conditionStr = " and ";
                    }
                }
                else
                {
                    // 締め日（開始日）
                    if (!"".Equals(strCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    = :strclosedate ";
                        conditionStr = " and ";
                    }

                    // 締め日（終了日）
                    if (!"".Equals(endCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    = :endclosedate ";
                        conditionStr = " and ";
                    }
                }

                // 請求書分類コード
                if (!"".Equals(billClassCd))
                {
                    sql += conditionStr + " bill.billclasscd    = :billclasscd ";
                    conditionStr = " and ";
                }
            }

            sql += @"
                    bill.orgcd1 = org.orgcd1
                    and bill.orgcd2 = org.orgcd2
                 ";

            if (!"".Equals(orgDiv))
            {
                sql += " and   org.orgdiv    =  :orgdiv ";
            }

            sql += " and bill.billclasscd = billclass.billclasscd) billtbl, ";

            // 請求書団体テーブルからデータを取得
            conditionStr = " where ";
            sql += @"
                    (
                      select
                        bill_org.billno
                        , bill_org.seq
                        , bill_org.cslorgcd1
                        , bill_org.cslorgcd2
                        , bill_org.isrsign
                        , org.orgname
                        , org.chargename
                        , org.orgbillname
                      from
                        bill_org
                        , org
                 ";

            if (!"".Equals(orgCd1) || !"".Equals(orgCd2))
            {
                // 団体コード１
                if (!"".Equals(orgCd1))
                {
                    sql += conditionStr + " bill_org.cslorgcd1    = :orgcd1 ";
                    conditionStr = " and ";
                }

                // 団体コード２
                if (!"".Equals(orgCd2))
                {
                    sql += conditionStr + " bill_org.cslorgcd2    = :orgcd2 ";
                    conditionStr = " and ";
                }
            }

            sql += conditionStr + @"
                                    bill_org.cslorgcd1 = org.orgcd1
                                    and bill_org.cslorgcd2 = org.orgcd2) billorgtbl
                                    where
                                      billtbl.billno = billorgtbl.billno
                 ";

            switch (sortFlg)
            {
                case "1":
                    sql += @"
                            order by
                              orgcd1
                              , orgcd2
                              , billclasscd
                              , closedate
                              , isrsign
                              , cslorgcd1
                              , cslorgcd2
                          ";
                    break;

                default:
                    sql += " order by  billno, seq ";
                    break;
            }

            // SQL実行
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 入力条件に合致する請求書，請求書団体管理テーブルのデータを取得する
        /// </summary>
        /// <param name="sumCls">グルーピング分類</param>
        /// <param name="strCloseDate">締め日（開始日）</param>
        /// <param name="endCloseDate">締め日（終了日）</param>
        /// <param name="isrOrgCd1">健保団体コード１</param>
        /// <param name="isrOrgCd2">健保団体コード２</param>
        /// <param name="billClassCd">請求書分類コード</param>
        /// <returns>
        /// orgCd1          団体コード１
        /// orgCd2          団体コード２
        /// billClassCd     請求書分類コード
        /// closeDate       締め日
        /// cslOrgCd1       受診団体コード１
        /// cslOrgCd2       受診団体コード２
        /// isrSign         健保記号
        /// totalCnt        人数
        /// subTotal        金額
        /// tax             消費税
        /// total           金額合計
        /// strDate         受診開始日
        /// endDate         受診終了日
        /// cslCnt As       受診人数
        /// cslOrgName      受診団体名称
        /// </returns>
        public List<dynamic> SelectFirstDemandList(string sumCls, string strCloseDate, string endCloseDate, string isrOrgCd1, string isrOrgCd2, string billClassCd)
        {
            string sql; // SQLステートメント

            // 初期設定
            string conditionStr = " where ";

            // キー値の設定
            var param = new Dictionary<string, object>();
            if (!"".Equals(strCloseDate))
            {
                param.Add("strclosedate", Convert.ToDateTime(strCloseDate));
            }
            if (!"".Equals(endCloseDate))
            {
                param.Add("endclosedate", Convert.ToDateTime(endCloseDate));
            }
            if (!"".Equals(isrOrgCd1))
            {
                param.Add("isrorgcd1", isrOrgCd1);
            }
            if (!"".Equals(isrOrgCd2))
            {
                param.Add("isrorgcd2", isrOrgCd2);
            }
            if (!"".Equals(billClassCd))
            {
                param.Add("billclasscd", billClassCd);
            }

            switch (sumCls)
            {
                case "1":
                    sql = @"
                            select
                              viewbill.orgcd1
                              , viewbill.orgcd2
                              , viewbill.billclasscd
                              , viewbill.closedate
                              , viewbill.isrsign
                              , viewbill.cslorgcd1
                              , viewbill.cslorgcd2
                              , sum(viewbill.totalcnt) totalcnt
                              , sum(viewbill.subtotal) subtotal
                              , sum(viewbill.tax) tax
                              , sum(viewbill.total) total
                              , min(viewbill.strdate) strdate
                              , max(viewbill.enddate) enddate
                              , sum(viewbill.cslcnt) cslcnt
                              , (
                                select
                                  orgname
                                from
                                  org
                                where
                                  viewbill.cslorgcd1 = org.orgcd1
                                  and viewbill.cslorgcd2 = org.orgcd2
                              ) cslorgname
                            from
                         ";
                    break;

                default:
                    sql = @"
                            select
                              viewbill.orgcd1
                              , viewbill.orgcd2
                              , viewbill.billclasscd
                              , viewbill.closedate
                              , sum(viewbill.totalcnt) totalcnt
                              , sum(viewbill.subtotal) subtotal
                              , sum(viewbill.tax) tax
                              , sum(viewbill.total) total
                              , min(viewbill.strdate) strdate
                              , max(viewbill.enddate) enddate
                              , sum(viewbill.cslcnt) cslcnt
                            from
                         ";
                    break;
            }

            sql += @"
                    (
                      select
                        bill.orgcd1
                        , bill.orgcd2
                        , bill.billclasscd
                        , to_char(bill.closedate, 'yyyy/mm') closedate
                        , bill_org.isrsign
                        , bill_org.cslorgcd1
                        , bill_org.cslorgcd2
                        , billdetail.totalcnt totalcnt
                        , billdetail.subtotal subtotal
                        , billdetail.tax tax
                        , billdetail.total total
                        , bill_course.strdate strdate
                        , bill_course.enddate enddate
                        , bill_course.cslcnt cslcnt
                      from
                        bill
                        , bill_org
                        , bill_course
                        , billdetail
                  ";

            if (!"".Equals(strCloseDate) || !"".Equals(endCloseDate)
                || !"".Equals(isrOrgCd1) || !"".Equals(isrOrgCd2)
                || !"".Equals(billClassCd))
            {
                // 健保団体１
                if (!"".Equals(isrOrgCd1))
                {
                    sql += conditionStr + " bill.orgcd1    = :isrorgcd1 ";
                    conditionStr = " and ";
                }

                // 健保団体２
                if (!"".Equals(isrOrgCd2))
                {
                    sql += conditionStr + " bill.orgcd2    = :isrorgcd2 ";
                    conditionStr = " and ";
                }

                if (!"".Equals(strCloseDate) && !"".Equals(endCloseDate))
                {
                    // 締め日（開始日）
                    if (!"".Equals(strCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    >= :strclosedate ";
                        conditionStr = " and ";
                    }

                    // 締め日（終了日）
                    if (!"".Equals(endCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    <= :endclosedate ";
                        conditionStr = " and ";
                    }
                }
                else
                {
                    // 締め日（開始日）
                    if (!"".Equals(strCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    = :strclosedate ";
                        conditionStr = " and ";
                    }

                    // 締め日（終了日）
                    if (!"".Equals(endCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    = :endclosedate ";
                        conditionStr = " and ";
                    }
                }

                // 請求書分類コード
                if (!"".Equals(billClassCd))
                {
                    sql += conditionStr + " bill.billclasscd    = :billclasscd ";
                    conditionStr = " and ";
                }
            }

            sql += conditionStr + @"
                                    bill.billno = bill_org.billno
                                    and bill_org.billno = bill_course.billno
                                    and bill_org.seq = bill_course.seq
                                    and bill_course.billno = billdetail.billno
                                    and bill_course.seq = billdetail.seq
                                    and bill_course.csseq = billdetail.csseq
                 ";

            switch (sumCls)
            {
                case "1":
                    sql += @"
                            ) viewbill
                            group by
                              viewbill.orgcd1
                              , viewbill.orgcd2
                              , viewbill.billclasscd
                              , viewbill.closedate
                              , viewbill.isrsign
                              , viewbill.cslorgcd1
                              , viewbill.cslorgcd2
                            order by
                              viewbill.orgcd1
                              , viewbill.orgcd2
                              , viewbill.billclasscd
                              , viewbill.closedate
                              , viewbill.isrsign
                              , viewbill.cslorgcd1
                              , viewbill.cslorgcd2
                          ";
                    break;

                default:
                    sql += @"
                            ) viewbill
                            group by
                              viewbill.orgcd1
                              , viewbill.orgcd2
                              , viewbill.billclasscd
                              , viewbill.closedate
                            order by
                              viewbill.orgcd1
                              , viewbill.orgcd2
                              , viewbill.billclasscd
                              , viewbill.closedate
                        ";
                    break;
            }

            // SQL実行
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 入力条件に合致する請求書，請求書団体管理テーブルのデータを取得する
        /// </summary>
        /// <param name="sortFlg">ソートフラグ</param>
        /// <param name="sumFlg">フラグ</param>
        /// <param name="strCloseDate">締め日（開始日）</param>
        /// <param name="endCloseDate">締め日（終了日）</param>
        /// <param name="isrOrgCd1">健保団体コード１</param>
        /// <param name="isrOrgCd2">健保団体コード２</param>
        /// <param name="orgDiv">団体分類</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="isrSign">健保記号</param>
        /// <param name="billNo">請求書番号</param>
        /// <param name="billClassCd">請求書分類コード</param>
        /// <param name="otherInCome">雑収入扱い</param>
        /// <returns>
        /// billNo             請求書番号
        /// orgCd1             団体コード１
        /// orgCd2             団体コード２
        /// closeDate          締め日
        /// billTitol          請求書用タイトル
        /// billClassCd        請求書分類コード
        /// billClassCd        請求書分類名
        /// orgName            団体名称
        /// seq                ＳＥＱ
        /// cslOrgCd1          受診団体コード１
        /// cslOrgCd2          受診団体コード２
        /// isrSign            健保記号
        /// cslOrgName         受診団体名称
        /// chargeName         担当者名
        /// orgBillName        団体請求名
        /// </returns>
        public List<dynamic> SelectDemandDetailList2(string sortFlg, string sumFlg, string strCloseDate, string endCloseDate, string isrOrgCd1, string isrOrgCd2, string orgDiv, string orgCd1, string orgCd2, string isrSign, string billNo, string billClassCd, string otherInCome)
        {
            // 初期設定
            string conditionStr = " where ";

            // キー値の設定
            var param = new Dictionary<string, object>();
            if (!"".Equals(strCloseDate))
            {
                param.Add("strclosedate", Convert.ToDateTime(strCloseDate));
            }
            if (!"".Equals(endCloseDate))
            {
                param.Add("endclosedate", Convert.ToDateTime(endCloseDate));
            }
            if (!"".Equals(isrOrgCd1))
            {
                param.Add("isrorgcd1", isrOrgCd1);
            }
            if (!"".Equals(isrOrgCd2))
            {
                param.Add("isrorgcd2", isrOrgCd2);
            }
            if (!"".Equals(orgDiv))
            {
                param.Add("orgdiv", orgDiv);
            }
            if (!"".Equals(orgCd1))
            {
                param.Add("orgcd1", orgCd1);
            }
            if (!"".Equals(orgCd2))
            {
                param.Add("orgcd2", orgCd2);
            }
            if (!"".Equals(isrSign))
            {
                param.Add("isrsign", isrSign);
            }
            if (!"".Equals(billNo))
            {
                param.Add("billno", billNo);
            }
            if (!"".Equals(billClassCd))
            {
                param.Add("billclasscd", billClassCd);
            }
            if (!"".Equals(otherInCome))
            {
                param.Add("otherincome", otherInCome);
            }

            // 請求書テーブルからデータを取得
            string sql = @"
                            select
                              billtbl.billno billno
                              , billorgtbl.seq seq
                              , billtbl.orgcd1 orgcd1
                              , billtbl.orgcd2 orgcd2
                              , billtbl.orgname orgname
                              , billtbl.billclasscd billclasscd
                              , billtbl.billclassname billclassname
                              , billtbl.closedate closedate
                              , billtbl.billtitle billtitle
                              , billorgtbl.cslorgcd1 cslorgcd1
                              , billorgtbl.cslorgcd2 cslorgcd2
                              , billorgtbl.orgname cslorgname
                              , billorgtbl.isrsign isrsign
                              , billorgtbl.chargename chargename
                              , billorgtbl.orgbillname orgbillname
                              , billdetailtbl.price
                              , billdetailtbl.totalcnt
                              , billdetailtbl.subtotal
                              , billdetailtbl.tax
                              , billdetailtbl.discount
                              , billdetailtbl.total
                            from
                              (
                                select
                                  bill.billno
                                  , bill.orgcd1
                                  , bill.orgcd2
                                  , bill.billclasscd
                                  , to_char(bill.closedate, 'yyyy/mm') closedate
                                  , billclass.billtitle
                                  , org.orgname
                                  , billclass.billclassname
                                from
                                  bill
                                  , org
                                  , billclass
                        ";

            if (!"".Equals(billNo) || !"".Equals(strCloseDate)
                || !"".Equals(endCloseDate) || !"".Equals(isrOrgCd1)
                || !"".Equals(isrOrgCd2) || !"".Equals(billClassCd)
                || !"".Equals(otherInCome))
            {
                // 請求書番号
                if (!"".Equals(billNo))
                {
                    sql += conditionStr + " bill.billno    = :billno ";
                    conditionStr = " and ";
                }

                // 健保団体１
                if (!"".Equals(isrOrgCd1))
                {
                    sql += conditionStr + " bill.orgcd1    = :isrorgcd1 ";
                    conditionStr = " and ";
                }

                // 健保団体２
                if (!"".Equals(isrOrgCd2))
                {
                    sql += conditionStr + " bill.orgcd2    = :isrorgcd2 ";
                    conditionStr = " and ";
                }

                if (!"".Equals(strCloseDate) && !"".Equals(endCloseDate))
                {
                    // 締め日（開始日）
                    if (!"".Equals(strCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    >= :strclosedate ";
                        conditionStr = " and ";
                    }

                    // 締め日（終了日）
                    if (!"".Equals(endCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    <= :endclosedate ";
                        conditionStr = " and ";
                    }
                }
                else
                {
                    // 締め日（開始日）
                    if (!"".Equals(strCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    = :strclosedate ";
                        conditionStr = " and ";
                    }

                    // 締め日（終了日）
                    if (!"".Equals(endCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    = :endclosedate ";
                        conditionStr = " and ";
                    }
                }

                // 請求書分類コード
                if (!"".Equals(billClassCd))
                {
                    sql += conditionStr + " bill.billclasscd    = :billclasscd ";
                    conditionStr = " and ";
                }

                // 雑収入扱い
                if (!"".Equals(otherInCome))
                {
                    sql += conditionStr + " billclass.otherincome    = :otherincome ";
                    conditionStr = " and ";
                }
            }

            sql += conditionStr + @"
                                    bill.orgcd1 = org.orgcd1
                                    and bill.orgcd2 = org.orgcd2
                 ";

            if (!"".Equals(orgDiv))
            {
                sql += " and   org.orgdiv    =  :orgdiv ";
            }

            sql += " and bill.billclasscd = billclass.billclasscd) billtbl ";

            // 請求書団体テーブルからデータを取得
            conditionStr = " where ";
            sql += @"
                    , (
                      select
                        bill_org.billno
                        , bill_org.seq
                        , bill_org.cslorgcd1
                        , bill_org.cslorgcd2
                        , bill_org.isrsign
                        , org.orgname
                        , org.chargename
                        , org.orgbillname
                      from
                        bill_org
                        , org
                ";

            if (!"".Equals(orgCd1) || !"".Equals(orgCd2))
            {
                // 団体コード１
                if (!"".Equals(orgCd1))
                {
                    sql += conditionStr + " bill_org.cslorgcd1    = :orgcd1 ";
                    conditionStr = " and ";
                }

                // 団体コード２
                if (!"".Equals(orgCd2))
                {
                    sql += conditionStr + " bill_org.cslorgcd2    = :orgcd2 ";
                    conditionStr = " and ";
                }
            }

            sql += conditionStr + @"
                                    bill_org.cslorgcd1 = org.orgcd1
                                    and bill_org.cslorgcd2 = org.orgcd2) billorgtbl
                 ";

            // 請求書明細テーブルからデータを取得
            switch (sumFlg)
            {
                case "":
                    sql += @"
                            , (
                              select
                                billdetail.billno
                                , billdetail.seq
                                , billdetail.price
                                , billdetail.totalcnt
                                , billdetail.subtotal
                                , billdetail.tax
                                , billdetail.discount
                                , billdetail.total
                              from
                                billdetail
                         ";
                    break;

                default:
                    sql += @"
                            , (
                              select
                                billdetail.billno
                                , billdetail.seq
                                , sum(billdetail.price) price
                                , sum(billdetail.totalcnt) totalcnt
                                , sum(billdetail.subtotal) subtotal
                                , sum(billdetail.tax) tax
                                , sum(billdetail.discount) discount
                                , sum(billdetail.total) total
                              from
                                billdetail
                              group by
                                billdetail.billno
                                , billdetail.seq
                        ";
                    break;
            }

            sql += " )  BILLDETAILTBL ";

            // 請求書関連テーブルの結合条件
            sql += @"
                    where
                      billtbl.billno = billorgtbl.billno
                      and billorgtbl.billno = billdetailtbl.billno
                      and billorgtbl.seq = billdetailtbl.seq
                ";

            switch (sortFlg)
            {
                case "1":
                    sql += @"
                            order by
                              orgcd1
                              , orgcd2
                              , billclasscd
                              , closedate
                              , isrsign
                              , cslorgcd1
                              , cslorgcd2
                        ";
                    break;

                case "2":
                    sql += " order by  closedate, orgcd1,orgcd2, billclasscd ";
                    break;

                default:
                    sql += " order by  billno, seq ";
                    break;
            }

            // SQL実行
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 入力条件に合致する請求書，請求書団体管理テーブルのデータを取得する
        /// </summary>
        /// <param name="sumFlg">フラグ</param>
        /// <param name="strCloseDate">締め日（開始日）</param>
        /// <param name="endCloseDate">締め日（終了日）</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="otherInCome">雑収入扱い</param>
        /// <param name="csCd">コースコード</param>
        /// <returns>
        /// billNo             請求書番号
        /// orgCd1             団体コード１
        /// orgCd2             団体コード２
        /// closeDate          締め日
        /// billTitol          請求書用タイトル
        /// billClassCd        請求書分類コード
        /// billClassCd        請求書分類名
        /// orgName            団体名称
        /// seq                ＳＥＱ
        /// cslOrgCd1          受診団体コード１
        /// cslOrgCd2          受診団体コード２
        /// isrSign            健保記号
        /// cslOrgName         受診団体名称
        /// chargeName         担当者名
        /// orgBillName        団体請求名
        /// </returns>
        public List<dynamic> SelectBsdDemandList(string sumFlg, string strCloseDate, string endCloseDate, string orgCd1, string orgCd2, string otherInCome, object[] csCd)
        {
            string sql; // SQLステートメント

            // 初期設定
            string conditionStr = " where ";

            // キー値の設定
            var param = new Dictionary<string, object>();
            if (!"".Equals(strCloseDate))
            {
                param.Add("strclosedate", Convert.ToDateTime(strCloseDate));
            }
            if (!"".Equals(endCloseDate))
            {
                param.Add("endclosedate", Convert.ToDateTime(endCloseDate));
            }
            if (!"".Equals(orgCd1))
            {
                param.Add("orgcd1", orgCd1);
            }
            if (!"".Equals(orgCd2))
            {
                param.Add("orgcd2", orgCd2);
            }
            if (!"".Equals(otherInCome))
            {
                param.Add("otherincome", otherInCome);
            }

            if ("".Equals(sumFlg))
            {
                sql = @"
                        select
                          to_char(bill.closedate, 'yyyy/mm') closedate
                          , bill.orgcd1 orgcd1
                          , bill.orgcd2 orgcd2
                          , billclass.otherincome otherincome
                          , billclass.billtitle billtitle
                          , bill_course.cscd cscd
                          , course_p.csname csname
                          , bill_course.cslcnt cslcnt
                          , bill_course.strdate strdate
                          , bill_course.enddate enddate
                          , sum(billdetail.price) price
                          , sum(billdetail.totalcnt) totalcnt
                          , sum(billdetail.subtotal) subtotal
                          , sum(billdetail.tax) tax
                          , sum(billdetail.discount) discount
                          , sum(billdetail.total) total
                          , (
                            select
                              orgname
                            from
                              org
                            where
                              bill.orgcd1 = org.orgcd1
                              and bill.orgcd2 = org.orgcd2
                          ) orgname
                        from
                          bill
                          , bill_course
                          , billclass
                          , billdetail
                          , course_p
                     ";
            }
            else
            {
                sql = @"
                        select
                          to_char(bill.closedate, 'yyyy/mm') closedate
                          , bill.orgcd1 orgcd1
                          , bill.orgcd2 orgcd2
                          , bill_course.cscd cscd
                          , course_p.csname csname
                          , sum(bill_course.cslcnt) cslcnt
                          , sum(billdetail.price) price
                          , sum(billdetail.totalcnt) totalcnt
                          , sum(billdetail.subtotal) subtotal
                          , sum(billdetail.tax) tax
                          , sum(billdetail.discount) discount
                          , sum(billdetail.total) total
                          , (
                            select
                              orgname
                            from
                              org
                            where
                              bill.orgcd1 = org.orgcd1
                              and bill.orgcd2 = org.orgcd2
                          ) orgname
                        from
                          bill
                          , bill_course
                          , billclass
                          , billdetail
                          , course_p
                     ";
            }

            if (!"".Equals(strCloseDate) || !"".Equals(endCloseDate)
                || !"".Equals(orgCd1) || !"".Equals(orgCd2) || !"".Equals(otherInCome))
            {

                // 団体１
                if (!"".Equals(orgCd1))
                {
                    sql += conditionStr + " bill.orgcd1    = :orgcd1 ";
                    conditionStr = " and ";
                }

                // 団体２
                if (!"".Equals(orgCd2))
                {
                    sql += conditionStr + " bill.orgcd2    = :orgcd2 ";
                    conditionStr = " and ";
                }

                if (!"".Equals(strCloseDate) && !"".Equals(endCloseDate))
                {
                    // 締め日（開始日）
                    if (!"".Equals(strCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    >= :strclosedate ";
                        conditionStr = " and ";
                    }

                    // 締め日（終了日）
                    if (!"".Equals(endCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    <= :endclosedate ";
                        conditionStr = " and ";
                    }
                }
                else
                {
                    // 締め日（開始日）
                    if (!"".Equals(strCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    = :strclosedate ";
                        conditionStr = " and ";
                    }

                    // 締め日（終了日）
                    if (!"".Equals(endCloseDate))
                    {
                        sql += conditionStr + " bill.closedate    = :endclosedate ";
                        conditionStr = " and ";
                    }
                }

                // 雑収入扱い
                if (!"".Equals(otherInCome))
                {
                    sql += conditionStr + " billclass.otherincome    = :otherincome ";
                    conditionStr = " and ";
                }
            }

            // コースコード条件設定
            if (csCd != null)
            {
                if (csCd is Array)
                {
                    sql += conditionStr + " ( bill_course.cscd = '" + csCd[0] + "'";
                    conditionStr = " and ";
                    for (int i = 0; i <= csCd.Length; i++)
                    {
                        if (!"".Equals(csCd[i]))
                        {
                            sql += " or  bill_course.cscd = '" + csCd[i] + "'";
                        }
                    }
                    sql += " ) ";
                }
                else
                {
                    if (!"".Equals(csCd))
                    {
                        sql += conditionStr + " bill_course.cscd = '" + csCd + "'";
                        conditionStr = " and ";
                    }
                }
            }

            // 請求書関連テーブルＪＯＩＮ条件の設定
            sql += conditionStr + @"
                                    bill.billno = bill_course.billno
                                    and bill_course.billno = billdetail.billno
                                    and bill_course.seq = billdetail.seq
                                    and bill_course.csseq = billdetail.csseq
                                    and bill.billclasscd = billclass.billclasscd
                                    and bill_course.cscd = course_p.cscd
                                ";

            if ("".Equals(sumFlg))
            {
                sql += @"
                        group by
                          bill.closedate
                          , bill.orgcd1
                          , bill.orgcd2
                          , billclass.otherincome
                          , billclass.billtitle
                          , bill_course.cscd
                          , course_p.csname
                          , bill_course.cslcnt
                          , bill_course.strdate
                          , bill_course.enddate
                        order by
                          closedate
                          , orgcd1
                          , orgcd2
                          , cscd
                     ";
            }
            else
            {
                sql += @"
                        group by
                          bill.closedate
                          , bill.orgcd1
                          , bill.orgcd2
                          , bill_course.cscd
                          , course_p.csname
                        order by
                          closedate
                          , orgcd1
                          , orgcd2
                          , cscd
                     ";
            }

            // SQL実行
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 入力条件に合致する請求書，請求書団体管理テーブルのデータを取得する
        /// </summary>
        /// <param name="mode">登録モード</param>
        /// <param name="strCloseDate">締め日（開始日）</param>
        /// <param name="endCloseDate">締め日（終了日）</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="orgBsdCd">事業所コード</param>
        /// <param name="orgRoomCd">室部コード</param>
        /// <param name="orgPostCd1">所属コード１</param>
        /// <param name="orgPostCd2">所属コード２</param>
        /// <param name="billClassCd">請求書分類コード</param>
        /// <returns>
        /// orgCd1             団体コード１
        /// orgCd2             団体コード２
        /// closeDate          締め日
        /// rsvNo              予約番号
        /// csCd               コースコード
        /// empNo              従業員番号
        /// cslDate            受診日
        /// orgBsdName         所属名
        /// price              金額
        /// editPrice          調整金額
        /// taxPrice           消費税
        /// editTax            調整消費税
        /// orgName            団体名称
        /// csName             コース名
        /// </returns>
        public List<dynamic> SelectPostDemandList(string mode, string strCloseDate, string endCloseDate, string orgCd1, string orgCd2, string orgBsdCd, string orgRoomCd, string orgPostCd1, string orgPostCd2, string billClassCd)
        {
            string sql; // SQLステートメント

            // 初期設定
            string conditionStr = " where ";

            // キー値の設定
            var param = new Dictionary<string, object>();
            if (!"".Equals(strCloseDate))
            {
                param.Add("strclosedate", Convert.ToDateTime(strCloseDate));
            }
            if (!"".Equals(endCloseDate))
            {
                param.Add("endclosedate", Convert.ToDateTime(endCloseDate));
            }
            if (!"".Equals(orgCd1))
            {
                param.Add("orgcd1", orgCd1);
            }
            if (!"".Equals(orgCd2))
            {
                param.Add("orgcd2", orgCd2);
            }
            if (!"".Equals(orgBsdCd))
            {
                param.Add("orgbsdcd", orgBsdCd);
            }
            if (!"".Equals(orgRoomCd))
            {
                param.Add("orgroomcd", orgRoomCd);
            }
            if (!"".Equals(orgPostCd1))
            {
                param.Add("orgpostcd1", orgPostCd1);
            }
            if (!"".Equals(orgPostCd2))
            {
                param.Add("orgpostcd2", orgPostCd2);
            }
            if (!"".Equals(billClassCd))
            {
                param.Add("billclasscd", billClassCd);
            }

            if (!"SUM".Equals(mode))
            {
                sql = @"
                        select
                          bill.orgcd1 orgcd1
                          , bill.orgcd2 orgcd2
                          , to_char(bill.closedate, 'yyyy/mm') closedate
                          , consult.orgbsdcd orgbsdcd
                          , consult.orgroomcd orgroomcd
                          , consult.orgpostcd orgpostcd
                          , closemng.cscd cscd
                          , min(consult.csldate) mincsldate
                          , max(consult.csldate) maxcsldate
                          , sum(consult_m.price) price
                          , sum(consult_m.editprice) editprice
                          , sum(consult_m.taxprice) taxprice
                          , sum(consult_m.edittax) edittax
                          , count(distinct consult.rsvno) totalcnt
                          , (
                            select
                              orgname
                            from
                              org
                            where
                              org.orgcd1 = bill.orgcd1
                              and org.orgcd2 = bill.orgcd2
                          ) orgname
                          , (
                            select
                              orgpostname
                            from
                              orgpost
                            where
                              orgpost.orgcd1 = bill.orgcd1
                              and orgpost.orgcd2 = bill.orgcd2
                              and orgpost.orgbsdcd = consult.orgbsdcd
                              and orgpost.orgroomcd = consult.orgroomcd
                              and orgpost.orgpostcd = consult.orgpostcd
                          ) orgpostname
                          , (
                            select
                              csname
                            from
                              course_p
                            where
                              course_p.cscd = closemng.cscd
                          ) csname
                        from
                          bill
                          , consult
                          , consult_m
                          , closemng
                    ";
            }
            else
            {
                sql = @"
                        select
                          bill.orgcd1 orgcd1
                          , bill.orgcd2 orgcd2
                          , to_char(bill.closedate, 'yyyy/mm') closedate
                          , closemng.cscd cscd
                          , sum(consult_m.price) price
                          , sum(consult_m.editprice) editprice
                          , sum(consult_m.taxprice) taxprice
                          , sum(consult_m.edittax) edittax
                          , count(distinct consult.rsvno) totalcnt
                          , (
                            select
                              csname
                            from
                              course_p
                            where
                              course_p.cscd = closemng.cscd
                          ) csname
                        from
                          bill
                          , consult
                          , consult_m
                          , closemng
                     ";
            }

            // 請求書テーブルからデータを取得
            if (!"".Equals(strCloseDate) || !"".Equals(endCloseDate)
                || !"".Equals(orgCd1) || !"".Equals(orgCd2) || !"".Equals(billClassCd)
                || !"".Equals(orgBsdCd) || !"".Equals(orgRoomCd)
                || !"".Equals(orgPostCd1) || !"".Equals(orgPostCd2))
            {

                // 団体１
                if (!"".Equals(orgCd1))
                {
                    sql += conditionStr + " bill.orgcd1    = :orgcd1 ";
                    conditionStr = " and ";
                }

                // 団体２
                if (!"".Equals(orgCd2))
                {
                    sql += conditionStr + " bill.orgcd2    = :orgcd2 ";
                    conditionStr = " and ";
                }

                // 締め日（開始日）
                if (!"".Equals(strCloseDate))
                {
                    sql += conditionStr + " bill.closedate    >= :strclosedate ";
                    conditionStr = " and ";
                }

                // 締め日（終了日）
                if (!"".Equals(endCloseDate))
                {
                    sql += conditionStr + " bill.closedate    <= :endclosedate ";
                    conditionStr = " and ";
                }

                // 請求書分類コード
                if (!"".Equals(billClassCd))
                {
                    sql += conditionStr + " bill.billclasscd    = :billclasscd ";
                    conditionStr = " and ";
                }

                // 事業所コード
                if (!"".Equals(orgBsdCd))
                {
                    sql += conditionStr + " consult.orgbsdcd    = :orgbsdcd ";
                    conditionStr = " and ";
                }

                // 室部
                if (!"".Equals(orgRoomCd))
                {
                    sql += conditionStr + " consult.orgroomcd    = :orgroomcd ";
                    conditionStr = " and ";
                }

                // 所属１
                if (!"".Equals(orgPostCd1))
                {
                    sql += conditionStr + " consult.orgpostcd    >= :orgpostcd1 ";
                    conditionStr = " and ";
                }

                // 所属２
                if (!"".Equals(orgPostCd2))
                {
                    sql += conditionStr + " consult.orgpostcd    >= :orgpostcd2 ";
                    conditionStr = " and ";
                }
            }

            sql += @"
                    bill.billno = closemng.billno
                    and bill.orgcd1 = consult.orgcd1
                    and bill.orgcd2 = consult.orgcd2
                    and consult.rsvno = consult_m.rsvno
                    and consult.cscd = consult_m.cscd
                    and consult.rsvno = closemng.rsvno
                    and consult.orgcd1 = closemng.orgcd1
                    and consult.orgcd2 = closemng.orgcd2
                    and consult.cscd = closemng.cscd
                  ";

            if (!"SUM".Equals(mode))
            {
                sql += @"
                        group by
                          bill.orgcd1
                          , bill.orgcd2
                          , bill.closedate
                          , consult.orgbsdcd
                          , consult.orgroomcd
                          , consult.orgpostcd
                          , closemng.cscd
                        order by
                          bill.orgcd1
                          , bill.orgcd2
                          , bill.closedate
                          , consult.orgbsdcd
                          , consult.orgroomcd
                          , consult.orgpostcd
                          , closemng.cscd
                    ";
            }
            else
            {
                sql += @"
                        group by
                          bill.orgcd1
                          , bill.orgcd2
                          , bill.closedate
                          , closemng.cscd
                        order by
                          bill.orgcd1
                          , bill.orgcd2
                          , bill.closedate
                          , closemng.cscd
                    ";
            }

            // SQL実行
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 入力条件に合致する請求書，請求書団体管理テーブルのデータを取得する
        /// </summary>
        /// <param name="strCloseDate">締め日（開始日）</param>
        /// <param name="endCloseDate">締め日（終了日）</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="perID">個人ＩＤ</param>
        /// <param name="csCd">コースコード</param>
        /// <returns>
        /// orgCd1             団体コード１
        /// orgCd2             団体コード２
        /// closeDate          締め日
        /// rsvNo              予約番号
        /// csCd               コースコード
        /// empNo              従業員番号
        /// cslDate            受診日
        /// orgBsdName         所属名
        /// price              金額
        /// editPrice          調整金額
        /// taxPrice           消費税
        /// editTax            調整消費税
        /// orgName            団体名称
        /// csName             コース名
        /// </returns>
        public List<dynamic> SelectPersonDemandList(string strCloseDate, string endCloseDate, string orgCd1, string orgCd2, string perID, string[] csCd)
        {
            // 初期設定
            string conditionStr = " where ";

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            if (!"".Equals(strCloseDate))
            {
                param.Add("strclosedate", Convert.ToDateTime(strCloseDate));
            }
            if (!"".Equals(endCloseDate))
            {
                param.Add("endclosedate", Convert.ToDateTime(endCloseDate));
            }
            if (!"".Equals(orgCd1))
            {
                param.Add("orgcd1", orgCd1);
            }
            if (!"".Equals(orgCd2))
            {
                param.Add("orgcd2", orgCd2);
            }
            if (!"".Equals(perID))
            {
                param.Add("perid", perID);
            }

            string sql = @"
                            select
                              billtbl.orgcd1 orgcd1
                              , billtbl.orgcd2 orgcd2
                              , billtbl.closedate closedate
                              , billtbl.rsvno rsvno
                              , billtbl.cscd cscd
                              , consulttbl.orgbsdcd orgbsdcd
                              , consulttbl.orgroomcd orgroomcd
                              , consulttbl.orgpostcd orgpostcd
                              , consulttbl.empno empno
                              , consulttbl.isrsign isrsign
                              , consulttbl.isrno isrno
                              , consulttbl.csldate csldate
                              , consulttbl.orgpostname orgpostname
                              , consultmtbl.price price
                              , consultmtbl.editprice editprice
                              , consultmtbl.taxprice taxprice
                              , consultmtbl.edittax edittax
                              , billtbl.orgname orgname
                              , consultmtbl.csname csname
                              , consulttbl.lastname lastname
                              , consulttbl.firstname firstname
                            from
                        ";

            // 請求書テーブルからデータを取得
            sql += @"
                    (
                      select
                        bill.billno
                        , bill.orgcd1
                        , bill.orgcd2
                        , bill.closedate
                        , closemng.rsvno
                        , closemng.cscd
                        , org.orgname
                      from
                        bill
                        , closemng
                        , org
                 ";

            if (!"".Equals(strCloseDate) || !"".Equals(endCloseDate)
                || !"".Equals(orgCd1) || !"".Equals(orgCd2))
            {

                // 団体１
                if (!"".Equals(orgCd1))
                {
                    sql += conditionStr + " bill.orgcd1    = :orgcd1 ";
                    conditionStr = " and ";
                }

                // 団体２
                if (!"".Equals(orgCd2))
                {
                    sql += conditionStr + " bill.orgcd2    = :orgcd2 ";
                    conditionStr = " and ";
                }

                // 締め日（開始日）
                if (!"".Equals(strCloseDate))
                {
                    sql += conditionStr + " bill.closedate    >= :strclosedate ";
                    conditionStr = " and ";
                }

                // 締め日（終了日）
                if (!"".Equals(endCloseDate))
                {
                    sql += conditionStr + " bill.closedate    <= :endclosedate ";
                    conditionStr = " and ";
                }
            }

            conditionStr = " and ";
            // コースコード条件設定
            if (csCd != null)
            {
                if (csCd is Array)
                {
                    sql += conditionStr + " ( closemng.cscd = '" + csCd[0] + "'";
                    conditionStr = " and ";
                    for (int i = 0; i <= csCd.Length; i++)
                    {
                        if (!"".Equals(csCd[i]))
                        {
                            sql += " or  closemng.cscd = '" + csCd[i] + "'";
                        }
                    }
                    sql += " ) ";
                }
                else
                {
                    if (!"".Equals(csCd))
                    {
                        sql += conditionStr + " closemng.cscd = '" + csCd + "'";
                        conditionStr = " and ";
                    }
                }
            }

            sql += " )  billtbl ";

            // 受診情報，個人テーブルからデータを取得
            conditionStr = " where ";
            sql += @"
                    , (
                      select
                        consult.rsvno
                        , consult.orgbsdcd
                        , consult.orgroomcd
                        , consult.orgpostcd
                        , consult.csldate
                        , person.empno
                        , person.lastname
                        , person.firstname
                        , person.isrsign
                        , person.isrno
                        , orgpost.orgpostname
                      from
                        consult
                        , person
                        , orgpost
                 ";

            // 個人ＩＤ
            if (!"".Equals(perID))
            {
                sql += conditionStr + " consult.perid    = :perid ";
            }

            sql += conditionStr + @"
                                    consult.perid = person.perid
                                    and consult.orgcd1 = orgpost.orgcd1
                                    and consult.orgcd2 = orgpost.orgcd2
                                    and consult.orgbsdcd = orgpost.orgbsdcd
                                    and consult.orgroomcd = orgpost.orgroomcd
                                    and consult.orgpostcd = orgpost.orgpostcd) consulttbl
                                ";

            // 受診金額確定テーブルからデータを取得
            conditionStr = " where";
            sql += @"
                    , (
                      select
                        consult_m.rsvno
                        , course_p.cscd
                        , course_p.csname
                        , sum(consult_m.price) price
                        , sum(consult_m.editprice) editprice
                        , sum(consult_m.taxprice) taxprice
                        , sum(consult_m.edittax) edittax
                      from
                        consult_m
                        , course_p consult_m.cscd = course_p.cscd
                      group by
                        consult_m.rsvno
                        , course_p.cscd
                        , course_p.csname
                    ) consultmtbl
                 ";

            // 請求書関連テーブルの結合条件
            sql += @"
                    where
                      billtbl.rsvno = consulttbl.rsvno
                      and consulttbl.rsvno = consultmtbl.rsvno
                      and billtbl.cscd = consultmtbl.cscd
                    order by
                      orgcd1
                      , orgcd2
                      , closedate
                      , orgbsdcd
                      , orgroomcd
                      , orgpostcd
                      , empno
                      , csldate
                      , cscd
                 ";

            // SQL実行
            return connection.Query(sql, param).ToList();
        }
    }
}