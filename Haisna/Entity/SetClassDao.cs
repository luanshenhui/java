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
    /// セット分類情報データアクセスオブジェクト
    /// </summary>
    public class SetClassDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public SetClassDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// セット分類テーブルレコードを削除する
        /// </summary>
        /// <param name="setClassCd">セット分類コード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteSetClass(string setClassCd)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("setclasscd", setClassCd.Trim());

            // セット分類テーブルレコードの削除
            sql = @"
                    delete setclass
                    where
                      setclasscd = :setclasscd
                ";
            connection.Execute(sql, param);

            // 戻り値の設定
            return true;

        }

        /// <summary>
        /// 進捗管理用分類テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">進捗管理用分類テーブル情報
        /// setClassCd 進捗管理用分類コード
        /// setClassName 進捗管理用分類名
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistSetClass(string mode, JToken data)
        {
            string sql; // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("setclasscd", Convert.ToString(data["setClassCd"]));
            param.Add("setclassname", Convert.ToString(data["setClassName"]));

            while (true)
            {
                // 進捗管理用分類テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update setclass
                            set
                              setclassname = :setclassname
                            where
                              setclasscd = :setclasscd
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす進捗管理用分類テーブルのレコードを取得
                sql = @"
                        select
                          setclasscd
                        from
                          setclass
                        where
                          setclasscd = :setclasscd
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
                        into setclass(setclasscd, setclassname)
                        values (:setclasscd, :setclassname)
                    ";

                connection.Execute(sql, param);

                ret = Insert.Normal;
                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// セット分類の一覧を取得する
        /// </summary>
        /// <returns>
        /// setClassCd　セット分類コード
        /// setClassName　セット分類名
        /// </returns>
        public List<dynamic> SelectSetClassList()
        {
            string sql; // SQLステートメント

            // 文章テーブルよりレコードを取得
            sql = @"
                    select
                      setclasscd
                      , setclassname
                    from
                      setclass
                    order by
                      setclasscd
                ";
            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// セット分類コードに対するセット分類名を取得する
        /// </summary>
        /// <param name="setClassCd">セット分類コード</param>
        /// <returns>
        /// setClassName セット分類名
        /// </returns>
        public dynamic SelectSetClass(string setClassCd)
        {
            string sql; // SQLステートメント

            // 対象検査グループコードが設定されていない場合はエラー
            if (String.IsNullOrEmpty(setClassCd))
            {
                throw new ArgumentException();
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("setclasscd", setClassCd.Trim());

            // 検索条件を満たすセット分類テーブルのレコードを取得
            sql = @"
                    select
                      setclassname
                    from
                      setclass
                    where
                      setclasscd = :setclasscd
                ";
            return connection.Query(sql, param).FirstOrDefault();
        }
    }
}
