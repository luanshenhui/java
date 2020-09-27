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
    /// 定型面接文章情報データアクセスオブジェクト
    /// </summary>
    public class StdContactStcDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public StdContactStcDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 定型面接文章テーブルレコードを削除する
        /// </summary>
        /// <param name="guidanceDiv">指導内容区分</param>
        /// <param name="stdContactStcCd">定型面接文章コード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteStdContactStc(int guidanceDiv, string stdContactStcCd)
        {
            string sql = "";        // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("guidancediv", guidanceDiv);
            param.Add("stdcontactstccd", stdContactStcCd.Trim());

            // 定型面接文章テーブルレコードの削除
            sql = @"
                    delete stdcontactstc
                    where
                      guidancediv = :guidancediv
                      and stdcontactstccd = :stdcontactstccd
            ";

            connection.Execute(sql, param);

            return true;
        }

        /// <summary>
        /// 定型面接文章テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">更新データ
        /// guidancediv         指導内容区分
        /// stdcontactstccd     定型面接文章コード
        /// contactstc          面接文章
        /// </param>
        /// <returns>
        /// Insert.Normal     正常終了
        /// Insert.Duplicate  同一キーのレコード存在
        /// Insert.Error      異常終了
        /// </returns>
        public Insert RegistStdContactStc(string mode, JToken data)
        {
            string sql = "";                                // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("guidancediv", Convert.ToString(data["guidancediv"]).Trim());
            param.Add("stdcontactstccd", Convert.ToString(data["stdcontactstccd"]).Trim());
            param.Add("contactstc", Convert.ToString(data["contactstc"]).Trim());

            while (true)
            {
                // 定型面接文章テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update stdcontactstc
                            set
                              contactstc = :contactstc
                            where
                              guidancediv = :guidancediv
                              and stdcontactstccd = :stdcontactstccd
                    ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす定型面接文章テーブルのレコードを取得
                sql = @"
                        select
                          secondlinedivcd
                        from
                          secondlinediv
                        where
                          secondlinedivcd = :secondlinedivcd
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
                        into secondlinediv(
                          secondlinedivcd
                          , secondlinedivname
                          , stdprice
                          , stdtax
                        )
                        values (
                          :secondlinedivcd
                          , :secondlinedivname
                          , :stdprice
                          , :stdtax
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
        /// 定型面接文章コードに対する定型面接文章名を取得する
        /// </summary>
        /// <param name="guidanceDiv">指導内容区分</param>
        /// <param name="stdContactStcCd">定型面接文章コード</param>
        /// <returns>contactstc 面接文章</returns>
        public dynamic SelectStdContactStc(int guidanceDiv, string stdContactStcCd)
        {
            string sql = "";                                // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("guidancediv", guidanceDiv);
            param.Add("stdcontactstccd", stdContactStcCd.Trim());

            // 検索条件を満たす定型面接文章テーブルのレコードを取得
            sql = @"
                    select
                      contactstc
                    from
                      stdcontactstc
                    where
                      guidancediv = :guidancediv
                      and stdcontactstccd = :stdcontactstccd
            ";

            return connection.Query(sql).FirstOrDefault();
        }

        /// <summary>
        /// 定型面接文章の一覧を取得する
        /// </summary>
        /// <returns>
        /// guidancediv 指導内容区分
        /// stdcontactstccd 定型面接文章コード
        /// contactstc 面接文章
        /// </returns>
        public dynamic SelectStdContactStcList()
        {
            string sql = "";                                // SQLステートメント

            // 定型面接文章テーブルの全レコードを取得
            sql = @"
                    select
                      guidancediv
                      , stdcontactstccd
                      , contactstc
                    from
                      stdcontactstc
                    order by
                      guidancediv
                      , stdcontactstccd
            ";

            return connection.Query(sql).ToList();
        }

    }
}