using Dapper;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;

namespace Hainsi.Entity
{
    /// <summary>
    /// データアクセスオブジェクトの基底クラス
    /// </summary>
    public abstract class AbstractDao
    {
        // 拡張ログメッセージ用フォーマット
        private const string LogFormat = "Source Class = {0}\r\nSource Method = {1}\r\n";

        /// <summary>
        /// コネクションオブジェクト
        /// </summary>
        protected IDbConnection connection;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        protected AbstractDao(IDbConnection connection)
        {
            this.connection = connection;
        }

        /// <summary>
        /// トランザクションを開始する
        /// </summary>
        /// <returns>トランザクション</returns>
        protected IDbTransaction BeginTransaction()
        {
            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }

            return connection.BeginTransaction();
        }

        /// <summary>
        /// 読込用SQL実行
        /// </summary>
        /// <param name="sql">SQL文</param>
        /// <param name="parameter">パラメータ</param>
        /// <param name="commandType">コマンドタイプ</param>
        /// <returns>読込結果</returns>
        private IEnumerable<dynamic> ExecQuery(string sql, object parameter = null, CommandType? commandType = null)
        {
            // 読込実行
            return connection.Query(
                sql,
                parameter,
                commandType: commandType
            );
        }

        /// <summary>
        /// SQL文にページネーション用SQL文を追加して実行する
        /// </summary>
        /// <param name="sql">SQL文</param>
        /// <param name="page">ページ</param>
        /// <param name="limit">行数</param>
        /// <param name="parameter">SQLパラメータ</param>
        /// <returns>実行結果</returns>
        protected IEnumerable<dynamic> Query(string sql, string page, string limit, object parameter = null)
        {
            // ページネーション用SQL文を作成
            sql = CreatePagenationSql(sql, page, limit);

            // 読込実行
            return ExecQuery(sql, parameter);
        }

        /// <summary>
        /// ページネーション用SQL文を返す
        /// </summary>
        /// <param name="sql">SQLステートメント</param>
        /// <param name="page">ページ</param>
        /// <param name="limit">行数</param>
        /// <returns>ページネーション用SQL文</returns>
        private string CreatePagenationSql(string sql, string page, string limit)
        {
            // ページ指定されている場合、値を設定する
            if (!Int32.TryParse(page, out int wkpage))
            {
                wkpage = 0;
            }

            // ページあたりの取得件数が指定されている場合、値を設定する
            if (!Int32.TryParse(limit, out int wklimit))
            {
                wklimit = 0;
            }

            return CreatePagenationSql(sql, wkpage, wklimit);
        }

        /// <summary>
        /// ページネーション用SQL文を返す
        /// </summary>
        /// <param name="sql">SQLステートメント</param>
        /// <param name="page">ページ</param>
        /// <param name="limit">行数</param>
        /// <returns>ページネーション用SQL文</returns>
        private string CreatePagenationSql(string sql, int page, int limit)
        {
            // ページネーション用SQLフォーマット
            string pagenationSql = @"
                               select contents.*
                                    , count(*) over() totalcount
                                 from ({0}) contents
                               offset {1} rows fetch first {2} rows only
                            ";

            // ページ番号と行数が指定されていたらページネーション用に加工して返す
            if (page > 0 && limit > 0)
            {
                return string.Format(pagenationSql, sql, (page - 1) * limit, limit);
            }

            return sql;
        }

        /// <summary>
        /// SQLステートメントを実行し、影響を受ける行数を戻します。
        /// </summary>
        /// <param name="cmd">OracleCommandオブジェクト</param>
        /// <param name="sql">SQLコマンド</param>
        /// <returns>影響を受ける行数</returns>
        protected int ExecuteNonQuery(OracleCommand cmd, string sql)
        {
            cmd.BindByName = true;
            cmd.CommandText = sql;

            return ExecuteNonQuery(cmd);
        }

        /// <summary>
        /// SQLステートメントを実行し、影響を受ける行数を戻します。
        /// </summary>
        /// <param name="cmd">IDbCommandをImplementしたオブジェクト</param>
        /// <returns>影響を受ける行数</returns>
        private int ExecuteNonQuery(IDbCommand cmd)
        {
            // コマンドオブジェクトにコネクションがなければcontextのコネクションを代入する
            if (cmd.Connection == null)
            {
                cmd.Connection = connection;
            }

            // 実行前のコネクションが閉じているかどうかをチェック
            var isClosed = cmd.Connection.State == ConnectionState.Closed;

            try
            {
                // コネクションが閉じていたら開く
                if (isClosed)
                {
                    cmd.Connection.Open();
                }

                // SQLを実行する
                return cmd.ExecuteNonQuery();
            }
            finally
            {
                // 実行前のコネクションが閉じていたら閉じる
                if (isClosed)
                {
                    cmd.Connection.Close();
                }
            }
        }
    }

}
