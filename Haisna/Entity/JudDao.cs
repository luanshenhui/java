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
    /// 判定情報データアクセスオブジェクト
    /// </summary>
    public class JudDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public JudDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 最も軽い判定を取得する
        /// </summary>
        /// <returns>判定テーブル
        /// judcd 判定コード
        /// weight 判定用重み
        /// </returns>
        public dynamic SelectJudLightest()
        {
            string sql = "";  // SQLステートメント

            // 判定テーブルの全レコードを重み、判定コードの昇順に取得
            sql = @"
                    select
                      judcd
                      , weight
                    from
                      jud
                    order by
                      weight
                      , judcd
                ";

            return connection.Query(sql).FirstOrDefault();
        }

        /// <summary>
        /// 判定の一覧を取得する
        /// </summary>
        /// <returns>判定テーブル
        /// judcd 判定コード
        /// judsname 判定略称
        /// judrname 報告書用判定名称
        /// weight 判定用重み
        /// </returns>
        public List<dynamic> SelectJudList()
        {
            string sql = "";  // SQLステートメント

            // 検索条件を満たす判定テーブルのレコードを取得
            sql = @"
                    select
                      j.judcd
                      , j.judrname
                      , j.weight
                      , j.judsname
                      , j.webcolor
                    from
                      jud j
                    order by
                      j.judcd
                ";

            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 判定情報を取得する
        /// </summary>
        /// <param name="judCd">判定コード</param>
        /// <returns>判定テーブル
        /// judsname 判定略称
        /// judrname 報告書用判定名称
        /// weight 判定用重み
        /// </returns>
        public dynamic SelectJud(String judCd)
        {
            string sql = "";                                // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("judcd", judCd);

            // 検索条件を満たす判定テーブルのレコードを取得
            sql = @"
                    select
                      j.judsname
                      , j.judrname
                      , j.weight
                    from
                      jud j
                    where
                      j.judcd = :judcd
                ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 判定テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">判定情報
        /// judCd 判定コード
        /// judSName 判定略称
        /// judRName 報告書用判定名称
        /// weight 判定用重み
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistJud(string mode, JToken data)
        {
            string sql = "";                                // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("judcd", Convert.ToString(data["judcd"]));
            param.Add("judsname", Convert.ToString(data["judsname"]));
            param.Add("judrname", Convert.ToString(data["judrname"]));
            param.Add("weight", Convert.ToString(data["weight"]));

            while (true)
            {
                // 判定テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update jud
                            set
                              judsname = :judsname
                              , judrname = :judrname
                              , weight = :weight
                            where
                              judcd = :judcd
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす判定テーブルのレコードを取得
                sql = @"
                        select
                          judcd
                        from
                          jud
                        where
                          judcd = :judcd
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
                        into jud(
                            judcd
                            , judsname
                            , judrname
                            , weight
                        )
                        values (
                            :judcd
                            , :judsname
                            , :judrname
                            , :weight
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
        /// 判定テーブルレコードを削除する
        /// </summary>
        /// <param name="data">判定テーブル
        /// judCd 判定コード</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert DeleteJud(JToken data)
        {
            string sql = "";                                // SQLステートメント

            Insert ret = Insert.Error;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("judcd", Convert.ToString(data["judcd"]));

            // 判定テーブルレコードの削除
            sql = @"
                    delete jud
                    where
                        judcd = :judcd
                ";

            connection.Execute(sql, param);

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 判定略称を取得する
        /// </summary>
        /// <param name="judCd">判定コード</param>
        /// <returns>判定テーブル
        /// judsname 判定略称
        /// </returns>
        public dynamic SelectJudSName(String judCd)
        {
            string sql = "";                                // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("judcd", judCd);

            // 検索条件を満たす判定テーブルのレコードを取得
            sql = @"
                    select
                      j.judsname
                    from
                      jud j
                    where
                      j.judcd = :judcd
                ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 判定コードおよび判定用重みのリストを取得する
        /// </summary>
        /// <returns>判定テーブル
        /// weight 判定用重み
        /// </returns>
        public List<dynamic> SelectJudWeightList()
        {
            string sql = "";  // SQLステートメント

            // 判定テーブルの全レコードを重み、判定コードの昇順に取得
            sql = @"
                    select
                      judcd
                      , weight
                    from
                      jud
                    order by
                      weight
                      , judcd
                ";

            return connection.Query(sql).ToList();
        }
    }
}