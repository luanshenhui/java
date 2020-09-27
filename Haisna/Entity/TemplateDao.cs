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
    /// メールテンプレート情報データアクセスオブジェクト
    /// </summary>
    public class TemplateDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public TemplateDao(IDbConnection connection) : base(connection)
        {

        }

        /// <summary>
        /// メールテンプレートの一覧を取得する
        /// </summary>
        /// <returns>
        /// templatecd テンプレートコード
        /// templatename テンプレート名
        /// </returns>
        public List<dynamic> SelectMailTemplateList()
        {
            string sql = "";           // SQLステートメント

            // テンプレートテーブルよりレコードを取得
            sql = @"
                    select
                      templatecd
                      , templatename
                    from
                      mailtemplate
                    order by
                      templatecd
            ";

            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// メールテンプレートデータを取得する
        /// </summary>
        /// <param name="templateCd">テンプレートコード</param>
        /// <returns>
        /// templatename テンプレート名
        /// subject 表題
        /// body 本文
        /// </returns>
        public dynamic SelectMailTemplate(string templateCd)
        {
            string sql = "";                                // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("templatecd", templateCd);

            // 検索条件を満たすメールテンプレートテーブルのレコードを取得
            sql = @"
                    select
                      templatename
                      , subject
                      , body
                    from
                      mailtemplate
                    where
                      templatecd = :templatecd
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// メールテンプレートテーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// templatecd テンプレートコード
        /// templatename テンプレート名
        /// subject 表題
        /// body 本文
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistMailTemplate(string mode, JToken data)
        {
            string sql = "";                                // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("templatecd", Convert.ToString(data["templatecd"]).Trim());
            param.Add("templatename", Convert.ToString(data["templatename"]).Trim());
            param.Add("subject", Convert.ToString(data["subject"]).Trim());
            param.Add("body", System.Text.Encoding.GetEncoding(932).GetBytes(Convert.ToString(data["body"])));

            while (true)
            {
                // メールテンプレートテーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update mailtemplate
                            set
                              templatename = :templatename
                              , subject = :subject
                              , body = :body
                            where
                              templatecd = :templatecd
                    ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たすメールテンプレートテーブルのレコードを取得
                sql = @"
                        select
                          templatecd
                        from
                          mailtemplate
                        where
                          templatecd = :templatecd
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
                        into mailtemplate(
                            templatecd
                            , templatename
                            , subject, body
                        )
                        values (
                            :templatecd
                            , :templatename
                            , :subject, :body
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
        /// メールテンプレートテーブルレコードを削除する
        /// </summary>
        /// <param name="templateCd">テンプレートコード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteMailTemplate(string templateCd)
        {
            string sql = "";                                // SQLステートメント

            bool ret = false;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("templatecd", templateCd);

            // メールテンプレートテーブルレコードの削除
            sql = @"
                    delete mailtemplate
                    where
                      templatecd = :templatecd
                ";

            connection.Execute(sql, param);

            ret = true;

            // 戻り値の設定
            return ret;
        }

    }
}