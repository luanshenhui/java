using Dapper;
using Hainsi.Common.Constants;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 定型所見データアクセスオブジェクト
    /// </summary>
    public class StdJudDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public StdJudDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 定型所見の一覧を取得する
        /// </summary>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="searchCode">検索用コード（省略可）</param>
        /// <param name="searchString">検索用文字列（省略可）</param>
        /// <returns>
        /// stdjudcd 定型所見コード
        /// judclasscd 判定分類コード
        /// stdjudnote 定型所見名称
        /// </returns>
        public dynamic SelectStdJudList(long judClassCd, string searchCode = null, string searchString = null)
        {
            string sql = "";                // SQLステートメント
            bool whereFlg = false;          // SQL条件文にWHERE句を追加したかどうか

            // 定型所見テーブルよりレコードを取得
            sql = @"
                    select
                      judclasscd
                      , stdjudcd
                      , stdjudnote
                    from
                      stdjud
            ";

            if (judClassCd > 0)
            {
                sql += " where judclasscd = " + judClassCd;
                whereFlg = true;
            }

            // 検索用文字列の設定（マスタメンテ用？）
            if (!string.IsNullOrEmpty(searchCode))
            {
                if (whereFlg)
                {
                    sql += "   and stdjud.stdjudcd like '%" + searchCode + "%' ";
                }
                else
                {
                    sql += " where stdjud.stdjudcd like '%" + searchCode + "%' ";
                    whereFlg = true;
                }

            }

            if (!string.IsNullOrEmpty(searchString))
            {
                if (whereFlg)
                {
                    sql += "   and stdjud.stdjudnote like '%" + searchString + "%' ";
                }
                else
                {
                    sql += " where stdjud.stdjudnote like '%" + searchString + "%' ";
                    whereFlg = true;
                }

            }

            sql += " order by stdjudcd ";

            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 定型所見名称を取得する
        /// </summary>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="stdJudCd">定型所見コード</param>
        /// <returns>定型所見名称</returns>
        public dynamic SelectStdJudNote(string judClassCd, string stdJudCd)
        {
            string sql = "";                // SQLステートメント

            var param = new Dictionary<string, object>();
            param.Add("judclasscd", judClassCd.Trim());
            param.Add("stdjudcd", stdJudCd.Trim());

            // 検索条件を満たす定型所見テーブルのレコードを取得
            sql = @"
                    select
                      sj.stdjudnote
                    from
                      stdjud sj
                    where
                      sj.judclasscd = :judclasscd
                      and sj.stdjudcd = :stdjudcd
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 定型所見名称を取得する
        /// </summary>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="stdJudCd">定型所見コード</param>
        /// <returns>
        /// stdjudnote 定型所見名称
        /// judclassname 判定分類名称
        /// </returns>
        public dynamic SelectStdJud(string judClassCd, string stdJudCd)
        {
            string sql = "";                // SQLステートメント

            var param = new Dictionary<string, object>();
            param.Add("judclasscd", judClassCd.Trim());
            param.Add("stdjudcd", stdJudCd.Trim());

            // 検索条件を満たす定型所見テーブルのレコードを取得
            sql = @"
                    select
                      sj.stdjudnote
                      , jc.judclassname
                    from
                      judclass jc
                      , stdjud sj
                    where
                      sj.judclasscd = :judclasscd
                      and sj.stdjudcd = :stdjudcd
                      and sj.judclasscd = jc.judclasscd
            ";

            return connection.Query(sql, param).FirstOrDefault();

        }

        /// <summary>
        /// 定型所見テーブルレコードを登録する
        /// </summary>
        /// <param name="mode"> 登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// judclasscd 判定分類コード
        /// stdjudcd 定型所見コード
        /// stdjudnote 定型所見名
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistStdJud(string mode, JToken data)
        {
            string sql = "";            // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("judclasscd", Convert.ToString(data["judclasscd"]).Trim());
            param.Add("stdjudcd", Convert.ToString(data["stdjudcd"]).Trim());
            param.Add("stdjudnote", Convert.ToString(data["stdjudnote"]).Trim());

            while (true)
            {
                // 定型所見テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update stdjud
                            set
                              stdjudnote = :stdjudnote
                            where
                              judclasscd = :judclasscd
                              and stdjudcd = :stdjudcd
                    ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす定型所見テーブルのレコードを取得
                sql = @"
                        select
                          stdjudcd
                        from
                          stdjud
                        where
                          judclasscd = :judclasscd
                          and stdjudcd = :stdjudcd
                ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 存在した場合、新規挿入不可
                if (current != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                sql = @"
                        insert
                        into stdjud(
                          judclasscd
                          , stdjudcd
                          , stdjudnote
                        )
                        values (
                          :judclasscd,
                          :stdjudcd,
                          :stdjudnote
                        )
                ";

                connection.Execute(sql, param);

                ret = Insert.Normal;
                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 定型所見テーブルレコードを削除する
        /// </summary>
        /// <param name="data">
        /// judclasscd 判定分類コード
        /// stdjudcd 定型所見コード
        /// </param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteStdJud(JToken data)
        {
            string sql = "";        // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("judclasscd", Convert.ToString(data["judclasscd"]));
            param.Add("stdjudcd", Convert.ToString(data["stdjudcd"]));

            // 検索条件を満たす２次請求明細テーブルのレコードを取得
            sql = @"
                    delete stdjud
                    where
                      judclasscd = :judclasscd
                      and stdjudcd = :stdjudcd
            ";

            connection.Execute(sql, param);

            return true;
        }

    }
}