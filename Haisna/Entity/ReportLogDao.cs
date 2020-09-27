using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Microsoft.VisualBasic;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 印刷ログ情報データアクセスオブジェクト
    /// </summary>
    public class ReportLogDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ReportLogDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 次プリントSEQの取得
        /// </summary>
        /// <returns>次に発番するプリントSEQ</returns>
        public long GetNextPrintSeq()
        {
            string sql = "";    // SQLステートメント
            long ret;           // 関数戻り値

            // 初期処理
            ret = -1;

            // プリントSEQの取得
            sql = @"
                select
                    printseq_seq.nextval as printseq
                from
                    dual
            ";

            // SQL実行
            dynamic current = connection.Query(sql).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current != null)
            {
                ret = long.Parse(Convert.ToString(current.PRINTSEQ));
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 指定日以前の印刷ログテーブルレコードを削除する
        /// </summary>
        /// <param name="printDate">印刷開始日時</param>
        /// <param name="printSeq">印刷SEQ</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteReportLog(String printDate = null, String printSeq = null)
        {
            bool blnDateMode = false;   // TRUE:日付削除モード
            bool blnSeqMode = false;    // FALSE:SEQ削除モード
            string sql;                 // SQLステートメント

            while (true)
            {
                // Seqが有効指定されている場合、日付設定されていても無視
                if (!String.IsNullOrEmpty(printSeq))
                {
                    if (Util.IsNumber(printSeq))
                    {
                        blnSeqMode = true;
                        break;
                    }
                }

                // 日付がまともな日付なら日付モード
                if (!String.IsNullOrEmpty(printDate))
                {
                    if (Information.IsDate(printDate))
                    {
                        blnDateMode = true;
                    }
                }

                break;
            }

            // 日付もSEQもまともに指定されていないなら処理終了
            if ((blnSeqMode == false) && (blnDateMode == false))
            {
                // 戻り値の設定
                return false;
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();

            // 指定日以前の印刷ログテーブルレコードを削除
            sql = @"
                    delete reportlog
            ";

            if (blnDateMode)
            {
                param.Add("printdate", Convert.ToDateTime(printDate));
                sql += " where printdate < :printdate ";
            }

            if (blnSeqMode)
            {
                param.Add("printseq", long.Parse(printSeq));
                sql += " where printseq = :printseq ";
            }

            // SQL実行
            connection.Execute(sql, param);

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// 帳票ログデータを取得する
        /// </summary>
        /// <param name="printDate">出力日時</param>
        /// <param name="reportCd">帳票コード</param>
        /// <param name="sortOld">TRUE:古い順に表示（省略時は最新順）</param>
        /// <param name="prtStatus">ステータス</param>
        /// <param name="userId">ユーザＩＤ</param>
        /// <returns>
        /// printSeq プリントＳＥＱ
        /// printDate 印刷開始日時
        /// reportCd 帳票コード
        /// reportName 帳票名
        /// userId ユーザＩＤ
        /// userName ユーザ名
        /// status ステータス
        /// reportTempID 帳票一時ファイル名
        /// endDate 印刷終了時間
        /// count 出力枚数
        /// </returns>
        public List<dynamic> SelectReportLog(String printDate = null, String reportCd = null, bool sortOld = false, String prtStatus = null, String userId = null)
        {
            string sql = "";                                // SQLステートメント
            var param = new Dictionary<string, object>();   // キー値の設定

            // 団体請求書分類テーブル検索
            sql = @"
                    select
                      reportlog.printseq
                      , reportlog.printdate
                      , reportlog.reportcd
                      , nvl(reportlog.reportname, report.reportname) reportname
                      , reportlog.userid
                      , hainsuser.username
                      , reportlog.status
                      , reportlog.reporttempid
                      , reportlog.enddate
                      , reportlog.count
                    from
                      report report
                      , hainsuser hainsuser
                      , reportlog reportlog
                    where
                      reportlog.userid = hainsuser.userid
                      and reportlog.reportcd = report.reportcd(+)
             ";

            // 出力日時指定の場合
            if (!String.IsNullOrEmpty(printDate))
            {
                if (Information.IsDate(printDate))
                {
                    param.Add("printdate", Convert.ToDateTime(printDate));
                    sql += " and reportlog.printdate >= :printdate ";
                }
            }

            // 帳票コード指定の場合
            if (!String.IsNullOrEmpty(reportCd))
            {
                if (Util.IsNumber(reportCd))
                {
                    param.Add("reportcd", reportCd.Trim());
                    sql += " and reportlog.reportcd = :reportcd ";
                }
            }

            // 出力ユーザ指定の場合
            if (!String.IsNullOrEmpty(userId))
            {
                if (Util.IsNumber(userId))
                {
                    param.Add("userid", userId.Trim());
                    sql += " and reportlog.userid = :userid ";
                }
            }

            // ステータス指定の場合
            if (!String.IsNullOrEmpty(prtStatus))
            {
                if (Util.IsNumber(prtStatus))
                {
                    param.Add("status", prtStatus.Trim());
                    sql += " and reportlog.status = :status ";
                }
            }

            // ソート順指定の場合
            if (sortOld)
            {
                sql += " order by reportlog.printdate asc ";
            }
            else
            {
                sql += " order by reportlog.printdate desc ";
            }

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 印刷ログテーブルに書き込み
        /// </summary>
        /// <param name="data">
        /// printseq プリントｓｅｑ
        /// reportcd 帳票コード
        /// userid ユーザｉｄ
        /// status ステータス
        /// reporttmpid 帳票一時ファイル名
        /// count 出力枚数
        /// </param>
        /// <param name="printSeq">プリントＳＥＱ</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert InsertReportLog(JToken data, ref long printSeq)
        {
            string sql = "";    // SQLステートメント

            var param = new Dictionary<string, object>();
            Insert ret = Insert.Error;

            if (Convert.ToString(data["printseq"]).Equals("0"))
            {
                // 追加処理

                // プリントＳＥＱ取得処理
                sql = @"
                        select
                          printseq_seq.nextval as printseq
                        from
                          dual
                ";
                dynamic current = connection.Query(sql).FirstOrDefault();

                // 検索レコードが存在する場合
                if (current != null)
                {
                    printSeq = long.Parse(current.PRINTSEQ);
                }

                // キー及び更新値の設定
                param.Add("printseq", Convert.ToString(data["printseq"]));
                param.Add("reportcd", Convert.ToString(data["reportcd"]));
                param.Add("userid", Convert.ToString(data["userid"]));
                param.Add("status", Convert.ToString(data["status"]));

                // 印刷ログテーブル追加処理
                sql = @"
                        insert
                        into reportlog(
                            printseq
                            , printdate
                            , reportcd
                            , userid, status
                        )
                        values (
                            :printseq
                            , sysdate
                            , :reportcd
                            , :userid
                            , :status
                        )
                ";
            }
            else
            {
                // 更新処理

                // キー及び更新値の設定
                param.Add("printseq", Convert.ToString(data["printseq"]));
                param.Add("status", Convert.ToString(data["status"]));
                param.Add("reporttmpid", Convert.ToString(data["reporttmpid"]));
                param.Add("count", Convert.ToString(data["count"]));

                // 印刷ログテーブル更新処理
                sql = @"
                        update reportlog
                        set
                          status = :status
                          , reporttempid = :reporttempid
                          , enddate = sysdate
                          , count = :count
                        where
                          printseq = :printseq
                ";
            }

            // SQL実行
            connection.Execute(sql, param);

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        ///  印刷ログテーブルレコードの新規作成
        /// </summary>
        /// <param name="data">
        /// printSeq プリントSEQ
        /// reportCd 帳票コード
        /// userId ユーザID
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert InsertReportLog2(JToken data)
        {
            string sql = "";    // SQLステートメント

            Insert ret = Insert.Error;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("printseq", Convert.ToString(data["printseq"]));
            param.Add("reportcd", Convert.ToString(data["reportcd"]));
            param.Add("userid", Convert.ToString(data["userid"]));
            param.Add("reportname", Convert.ToString(data["reportname"]));

            // 印刷ログテーブル追加処理
            sql = @"
                    insert
                    into reportlog(
                      printseq
                      , printdate
                      , reportcd
                      , reportname
                      , userid
                      , status
                    )
                    values (
                      :printseq
                      , sysdate
                      , :reportcd
                      , :reportname
                      , :userid
                      , 0
                    )
                ";

            // SQL実行
            connection.Execute(sql, param);

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 印刷ログテーブルレコードの読み込み
        /// </summary>
        /// <param name="printSeq">プリントSEQ</param>
        /// <returns>
        /// reportTempId 帳票一時ファイル名
        /// reportCd 帳票コード
        /// </returns>
        public dynamic SelectReportLog2(long printSeq)
        {
            string sql = "";    // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("printseq", printSeq);

            // 検索条件を満たす判定テーブルのレコードを取得
            sql = @"
                    select
                      reporttempid
                      , reportcd
                    from
                      reportlog
                    where
                      printseq = :printseq
                ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 印刷ログテーブルレコードの更新
        /// </summary>
        /// <param name="data">
        /// printseq プリントSEQ
        /// status ステータス
        /// reporttempid 帳票一時ファイル名
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateReportLog2(JToken data)
        {
            string sql = "";    // SQLステートメント

            Insert ret = Insert.Error;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("printseq", Convert.ToString(data["printseq"]));
            param.Add("status", Convert.ToString(data["status"]));
            param.Add("reporttempid", Convert.ToString(data["reporttempid"]));

            // 印刷ログテーブルレコードの更新
            sql = @"
                    update reportlog
                    set
                      status = :status
                      , reporttempid = :reporttempid
                      , enddate = sysdate
                    where
                      printseq = :printseq
            ";

            // SQL実行
            connection.Execute(sql, param);

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        #region "新設メソッド"

        /// <summary>
        /// ファイルデータをテーブルから読み込む
        /// </summary>
        /// <param name="printSeq">プリントSEQ</param>
        /// <returns></returns>
        public dynamic FindFile(long printSeq)
        {
            string sql = @"
                select
                    datafile
                    , mimetype
                    , filename
                from
                    reportlog
                where
                    printseq = :printseq
            ";

            var sqlParam = new
            {
                printseq = printSeq
            };

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 進捗状況を取得する
        /// </summary>
        /// <param name="printSeq">プリントSEQ</param>
        /// <returns>進捗データ</returns>
        public dynamic FindProgress(long printSeq)
        {
            string sql = @"
                select
                    status
                    , nvl(count, 0) count
                from
                    reportlog
                where
                    printseq = :printseq
            ";

            var sqlParam = new
            {
                printseq = printSeq
            };

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// プリントSEQからROWIDを取得する
        /// </summary>
        /// <param name="printSeq">プリントSEQ</param>
        /// <returns>ROWID</returns>
        public string GetRowId(long printSeq)
        {
            string sql = @"
                select
                    rowid
                from
                    reportlog
                where
                    printseq = :printseq
            ";

            var sqlParam = new { printseq = printSeq };

            // SQL実行
            dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

            return (current != null) ? Convert.ToString(current.ROWID) : null;
        }

        // TODO 本メソッドは別ブランチでマイグレーションされるInsertReportLog2メソッドと同型。要統合。

        /// <summary>
        /// ログレコード追加
        /// </summary>
        /// <param name="printSeq">プリントSEQ</param>
        /// <param name="reportCd">帳票コード</param>
        /// <param name="reportName">帳票名</param>
        /// <param name="userId">ユーザID</param>
        public void InsertReportLog(long printSeq, string reportCd, string reportName, string userId)
        {
            string sql = @"
                insert
                into reportlog(
                    printseq
                    , printdate
                    , reportcd
                    , reportname
                    , userid
                    , status
                )
                values (
                    :printseq
                    , sysdate
                    , :reportcd
                    , :reportname
                    , :userid
                    , :status
                )
            ";

            var sqlParam = new
            {
                printseq = printSeq,
                reportcd = reportCd,
                reportname = reportName,
                userid = userId,
                status = Report.ConvertStatusCode(Report.Status.Processing)
            };

            connection.Execute(sql, sqlParam);
        }

        /// <summary>
        /// 指定ROWIDの印刷ログレコードを読み込みます。
        /// </summary>
        /// <param name="rowid">RowID</param>
        /// <returns>印刷ログレコード</returns>
        public dynamic Select(string rowid)
        {
            string sql = @"
                select
                    canceled
                from
                    reportlog
                where
                    rowid = :row_id
            ";

            var sqlParam = new { row_id = rowid };

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// ログ書き込み処理
        /// </summary>
        /// <param name="rowId">ROWID値</param>
        /// <param name="status">ステータス</param>
        /// <param name="count">出力枚数</param>
        /// <param name="dataFile">ファイル</param>
        /// <param name="mimeType">MIMEタイプ</param>
        /// <param name="fileName">ファイル名</param>
        public void UpdateReportLog(string rowId, Report.Status status, int count, byte[] dataFile, Report.MimeType mimeType, string fileName)
        {
            string sql = @"
                update reportlog
                set
                    count = :count
                    , status = :status
            ";

            // 処理中でなければ終了日時を追加
            if (status != Report.Status.Processing)
            {
                sql += @"
                    , enddate = sysdate
                ";
            }

            // 正常終了処理ならファイルをセット
            if (status == Report.Status.Success)
            {
                sql += @"
                    , datafile = :datafile
                    , mimetype = :mimetype
                    , filename = :filename
                ";
            }

            sql += @"
                where
                    rowid = :row_id
            ";

            // パラメータ設定
            var sqlParam = new
            {
                status = Report.ConvertStatusCode(status),
                row_id = rowId,
                mimetype = Report.ConvertMimeType(mimeType),
                datafile = dataFile,
                filename = fileName,
                count = count
            };

            // SQL実行
            connection.Execute(sql, sqlParam);
        }

        #endregion
    }
}
