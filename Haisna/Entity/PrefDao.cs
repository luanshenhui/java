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
    /// 都道府県情報データアクセスオブジェクト
    /// </summary>
    public class PrefDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public PrefDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 都道府県テーブルレコードを削除する
        /// </summary>
        /// <param name="prefCd">都道府県コード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeletePref(string prefCd)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("prefcd", prefCd.Trim());

            // 都道府県テーブルレコードの削除
            sql = @"
                    delete pref
                    where
                      prefcd = :prefcd
                ";
            connection.Execute(sql, param);

            // 戻り値の設定
            return true;

        }

        /// <summary>
        /// 都道府県テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">都道府県テーブル情報
        /// prefCd 都道府県コード
        /// prefName 都道府県名
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistPref(string mode, JToken data)
        {
            string sql; // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("prefcd", Convert.ToString(data["prefcd"]));
            param.Add("prefname", Convert.ToString(data["prefname"]));

            while (true)
            {
                // 都道府県テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update pref
                            set
                              prefname = :prefname
                            where
                              prefcd = :prefcd
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす都道府県テーブルのレコードを取得
                sql = @"
                        select
                          prefname
                        from
                          pref
                        where
                          prefcd = :prefcd
                    ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 存在した場合、新規挿入不可
                if (current != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 新規挿入
                sql = @"
                        insert
                        into pref
                        (
                          prefcd
                          , prefname
                        )
                        values
                        (
                          :prefcd
                          , :prefname)
                    ";

                connection.Execute(sql, param);

                ret = Insert.Normal;
                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 都道府県コードに対する都道府県名を取得する
        /// </summary>
        /// <param name="prefCd">都道府県コード</param>
        /// <returns>
        /// prefName 都道府県名
        /// </returns>
        public dynamic SelectPref(string prefCd)
        {
            string sql; // SQLステートメント

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("prefcd", prefCd);

            // 検索条件を満たす都道府県テーブルのレコードを取得
            sql = @"
                    select
                      prefname
                    from
                      pref
                    where
                      prefcd = :prefcd
                ";
            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 都道府県の一覧を取得する
        /// </summary>
        /// <returns>
        /// prefCd　都道府県コード
        /// prefName　都道府県名
        /// </returns>
        public List<dynamic> SelectPrefList()
        {
            string sql; // SQLステートメント

            // 都道府県テーブルの全レコードを取得
            sql = @"
                    select
                      prefcd
                      , prefname
                    from
                      pref
                    order by
                      prefcd
                ";
            return connection.Query(sql).ToList();
        }
    }
}
