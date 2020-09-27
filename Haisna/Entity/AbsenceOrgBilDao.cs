using Dapper;
using Hainsi.Common;
using Microsoft.VisualBasic;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 請求書明細CSV作成用データアクセスオブジェクト
    /// </summary>
    public class AbsenceOrgBillDao : AbstractDao
    {
        private const String CNST_FILENAME = "団体請求明細";

        /// <summary>
        /// 印刷ログ情報データアクセスオブジェクト
        /// </summary>
        readonly ReportLogDao reportLogDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        /// <param name="reportLogDao">印刷ログ情報データアクセスオブジェクト</param>
        public AbsenceOrgBillDao(IDbConnection connection, ReportLogDao reportLogDao) : base(connection)
        {
            this.reportLogDao = reportLogDao;
        }

        /// <summary>
        /// 請求書明細CSV作成
        /// </summary>
        /// <param name="data">
        /// userId          ユーザＩＤ
        /// strCloseDate    開始締め日
        /// endCloseDate    終了締め日
        /// </param>
        /// <param name="billNo">請求書番号</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <returns>印刷ログ情報のプリントSEQ値</returns>
        public long PrintAbsenceOrgBill(JToken data, string billNo = "", string orgCd1 = "", string orgCd2 = "")
        {

            string outFile;
            long printSeq;             // プリントSEQ
            string filePath = "";      // CSVファイル格納パス
            string baseFileName = "";  // ファイル名
            string fileName = "";      // 実際に作成されたファイル名

            outFile = CNST_FILENAME + ".csv";
            data["reportname"] = outFile;

            // プリントSEQの取得
            printSeq = reportLogDao.GetNextPrintSeq();
            data["printseq"] = printSeq;

            // 印刷ログテーブルレコードの挿入(帳票コードは書かない。名前のみ。)
            reportLogDao.InsertReportLog2(data);

            // ドキュメントファイルの格納場所を指定（ドキュメントファイル（出力結果）の位置）
            filePath = WebHains.ReadIniFile("COREPORT", "BILLPATH");

            // ◆ここからのCSVファイル名定義ロジックについて、特に規約はありませんが、帳票内容にそぐった任意の命名をお願いします。
            // ファイル名の作成
            baseFileName = filePath + filePath.Substring(filePath.Length - 1, 1) != "\\" ? "\\" : "" + outFile;

            fileName = SelectAbsenceListFile(baseFileName, Convert.ToDateTime(data["strclosedate"]), Convert.ToDateTime(data["endclosedate"]), billNo, orgCd1, orgCd2);

            // 戻り値の設定
            if (!"".Equals(fileName))
            {
                // 印刷ログテーブルレコードの更新
                data["status"] = 1;
                data["reporttempid"] = fileName;
                reportLogDao.UpdateReportLog2(data);

                // 戻り値の設定
                return printSeq;
            }
            else
            {
                // 印刷ログテーブルレコードの削除
                reportLogDao.DeleteReportLog(printSeq.ToString());

                // 戻り値の設定
                return  0;

            }
        }

        /// <summary>
        /// 請求書明細CSV作成
        /// </summary>
        /// <param name="fileName">ファイル名</param>
        /// <param name="strCloseDate">開始締め日</param>
        /// <param name="endCloseDate">終了締め日</param>
        /// <param name="billNo">請求書番号</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <returns>実際に作成されたCSVファイル名</returns>
        public string SelectAbsenceListFile(string fileName, DateTime strCloseDate, DateTime endCloseDate, string billNo = "", string orgCd1 = "", string orgCd2 = "")
        {

            string csvFileName = "";  // 作成されたファイル名
            int pos;                  // 文字列検索用
            string closeDate = "";    // 締め日
            int billSeq = 0;          // 請求書Seq
            int branchNo = 0;         // 請求書枝番
            bool isBillNo;            // TRUE:請求書番号が指定されている

            // 初期設定
            isBillNo = false;

            // キー値の設定
            var param = new Dictionary<string, object>();

            if (!"".Equals(billNo.Trim()) && Util.IsNumber(billNo))
            {
                // 請求書番号の妥当性チェック
                isBillNo = false;
                if (double.Parse(billNo) > 0)
                {
                    if (billNo.Length == 14)
                    {
                        // 請求書番号を分解
                        closeDate = billNo.Substring(0, 4) + "/" + billNo.Substring(4, 2) + "/" + billNo.Substring(6, 2);
                        billSeq = int.Parse(billNo.Substring(8, 5));
                        branchNo = int.Parse(billNo.Substring(13, 1));
                        DateTime dt;
                        if (DateTime.TryParse(closeDate, out dt))
                        {
                            isBillNo = true;
                        }
                    }
                }
                // 正しい請求書番号が入力されていない場合はNULLで検索をかける。
                if (isBillNo)
                {
                    param.Add("closedate", Convert.ToDateTime(closeDate));
                    param.Add("billseq", billSeq);
                    param.Add("branchno", branchNo);
                }
                else
                {
                    param.Add("closedate", null);
                    param.Add("billseq", null);
                    param.Add("branchno", null);
                }
            }
            else
            {
                // 締め日範囲指定
                param.Add("strclosedate", strCloseDate);
                param.Add("endclosedate", endCloseDate);

                // 負担元指定
                if (!"".Equals(orgCd1.Trim()) && !"".Equals(orgCd2.Trim()))
                {
                    param.Add("orgcd1", orgCd1);
                    param.Add("orgcd2", orgCd2);
                }
            }

            string sql = @"
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
                              , billdetail.csldate as csldate
                              , billdetail.dayid as dayid
                              , billdetail.rsvno as rsvno
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
                              , decode(consult.billprint, 1, '本人', 2, '家族', '') as billprintname
                              , decode(free.freefield1, null, '0', free.freefield1) as limitprice
                              , (
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
                              ) as breast_name
                              , (
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
                              ) as breast_price
                              , (
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
                              ) as breast_tax
                            from
                              bill
                              , billdetail
                              , org
                              , consult
                              , free
                       ";

            if (!"".Equals(billNo.Trim()) && Util.IsNumber(billNo))
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
                sql += " where bill.closedate between :strclosedate and :endclosedate ";

                // 負担元指定
                if (!"".Equals(orgCd1.Trim()) && !"".Equals(orgCd2.Trim()))
                {
                    sql += " and bill.orgcd1 = :orgcd1 ";
                    sql += " and bill.orgcd2 = :orgcd2 ";
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
                    and bill.delflg = 0
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

            // 検索条件を満たすレコードを取得
            dynamic current = connection.Query(sql, param).FirstOrDefault();

            if (current != null)
            {
                // #ToDo CSVを作成する方法をどうするか
                //objOraDyna.MoveFirst
                //'ダイナセットからCSVファイルを作成
                //Set objCreateCsv = CreateObject("HainsCreateCsvOrgBill.CreateCsvOrgBill")
                //strCsvFileName = objCreateCsv.CreateCsvFile(objOraDyna, strFileName)

                // 戻り値用としてドキュメントファイルのファイル名部分だけを抽出
                pos = csvFileName.Length - 1 - csvFileName.LastIndexOf("\\");
                if (pos != 0)
                {
                    csvFileName = csvFileName.Substring(pos);
                }
            }

            return csvFileName;
        }

        #region "新設メソッド"
        /// <summary>
        /// 引数値の妥当性チェックを行う
        /// </summary>
        /// <param name="strCloseDate">開始締め年月日</param>
        /// <param name="endCloseDate">終了締め年月日</param>
        /// <param name="billNo">請求書番号</param>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> ValidateOrgBill(string strCloseDate,
                                            string endCloseDate,
                                            string billNo)
        {
            var messages = new List<string>();

            if (!Information.IsDate(strCloseDate))
            {
                messages.Add("開始締め日の入力形式が正しくありません。");
            }

            if (!Information.IsDate(endCloseDate))
            {
                messages.Add("終了締め日の入力形式が正しくありません。");
            }

            // 請求書番号
            messages.Add(WebHains.CheckNumeric("請求書番号", billNo, 14));

            return messages;
        }
        #endregion "新設メソッド"
    }
}