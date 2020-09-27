using Dapper;
using Hainsi.Common.Constants;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 帳票パラメータ管理情報データアクセスオブジェクト
    /// </summary>
    public class ReportCtlDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ReportCtlDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 帳票パラメータ管理テーブルレコードの読み込み
        /// </summary>
        /// <param name="reportCd">帳票コード</param>
        /// <returns>受信日</returns>
        public dynamic SelectReportCtl(string reportCd)
        {

            string sql = "";        // SQLステートメント

            // 初期処理
            String cslDate = null;  // 受信日

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("reportcd", reportCd);

            // 指定帳票コードの受信日を取得する
            sql = @"
                    select
                        csldate
                      from
                        reportctl
                      where
                        reportcd = :reportcd
            ";

            // SQL実行
            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // レコードが存在する場合
            if (current != null)
            {
                // 戻り値の設定
                cslDate = String.Format("yyyyMMdd", current.CSLDATE);
            }

            return cslDate;
        }

        /// <summary>
        /// 帳票パラメータ管理テーブルに書き込み
        /// </summary>
        /// <param name="reportCd">帳票コード</param>
        /// <param name="cslDate">受信日</param>
        /// <param name="updUser">更新ユーザ</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert InsertReportCtl(string reportCd, DateTime cslDate, string updUser)
        {
            string sql = "";                                // SQLステートメント

            Insert ret = Insert.Error;

            // 変数初期化
            bool blnRecFlg = false;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("reportcd", reportCd);

            // 帳票コードに該当するレコードの存在チェック
            sql = @"
                    select
                      csldate
                    from
                      reportctl
                    where
                      reportcd = :reportcd
            ";

            // SQL実行
            dynamic current = connection.Query(sql, param).ToList();

            // レコード無の場合Insert。有の場合Update
            if (current != null)
            {
                // レコード有
                blnRecFlg = true;
            }

            // キー及び更新値の設定
            param.Add("csldate", cslDate);
            param.Add("upduser", updUser);

            if (blnRecFlg == false)
            {
                // レコード無し

                // 帳票パラメータ管理テーブル追加処理
                sql = @"
                    insert
                    into reportctl(
                        reportcd
                        , csldate
                        , upduser
                        , upddate
                    )
                    values (
                        :reportcd
                        , :csldate
                        , :upduser
                        , sysdate
                    )
                ";
            }
            else
            {
                // レコード有り

                // 帳票パラメータ管理テーブル更新処理
                sql = @"
                        update reportctl
                        set
                            csldate = :csldate
                            , upduser = :upduser
                            , upddate = sysdate
                        where
                            reportcd = :reportcd
                ";
            }

            // SQL実行
            connection.Execute(sql, param);

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }
    }
}
