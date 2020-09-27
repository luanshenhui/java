using Dapper;
using Hainsi.Common.Constants;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace Hainsi.Entity
{
    /// <summary>
    /// メール送信設定情報データアクセスオブジェクト
    /// </summary>
    public class ConfigDao : AbstractDao
    {
        private const long MAILCONF_ID = 1;     // メール送信設定レコードのID値（"1"で固定）

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ConfigDao(IDbConnection connection) : base(connection)
        {

        }

        /// <summary>
        /// メール送信設定を取得する
        /// </summary>
        /// <returns>
        /// mailfrom FROM
        /// cc CC
        /// bcc BCC
        /// signature 署名
        /// servername SMTPサーバ名
        /// userid ユーザID
        /// password パスワード
        /// portno ポート番号
        /// </returns>
        public Dictionary<string, object> SelectMailConf()
        {
            string sql = "";                                // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("id", MAILCONF_ID);

            // 検索条件を満たすレコードを取得
            sql = @"
                    select
                      mailfrom
                      , cc
                      , bcc
                      , signature
                      , servername
                      , userid
                      , password
                      , portno
                    from
                      mailconf
                    where
                      id = :id
            ";

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // 検索レコードが存在する場合
            Dictionary<string, object> retData = null;
            if (current != null)
            {
                retData = new Dictionary<string, object>();

                retData["mailfrom"] = current.MAILFROM;
                retData["cc"] = System.Text.Encoding.UTF8.GetString(current.CC);
                retData["bcc"] = System.Text.Encoding.UTF8.GetString(current.BCC);
                retData["signature"] = System.Text.Encoding.UTF8.GetString(current.SIGNATURE);
                retData["servernamE"] = current.SERVERNAME;
                retData["userid"] = current.USERID;
                retData["password"] = current.PASSWORD;
                retData["portno"] = current.PORTNO;
            }

            return retData;
        }

        /// <summary>
        /// メール送信設定を登録する
        /// </summary>
        /// <param name="data">
        /// id ID
        /// mailfrom FROM
        /// servername SMTPサーバ名
        /// userid ユーザID
        /// password パスワード
        /// portno ポート番号
        /// cc CC
        /// bcc BCC
        /// signature 署名
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistMailConf(JToken data)
        {
            string sql = "";              // SQLステートメント

            byte[] cc;
            byte[] bcc;
            byte[] signature;

            Insert ret = Insert.Error;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("id", MAILCONF_ID);
            param.Add("mailfrom", Convert.ToString(data["mailfrom"]).Trim());

            param.Add("servername", Convert.ToString(data["servername"]).Trim());
            param.Add("userid", Convert.ToString(data["userid"]).Trim());
            param.Add("password", Convert.ToString(data["password"]).Trim());
            if (!string.IsNullOrEmpty(Convert.ToString(data["portno"])))
            {
                param.Add("portno", long.Parse("0" + Convert.ToString(data["portno"])));
            }
            else
            {
                param.Add("portno", null);
            }

            cc = System.Text.Encoding.GetEncoding(932).GetBytes(Convert.ToString(data["cc"]));
            if (!string.IsNullOrEmpty(Convert.ToString(data["cc"]).Trim()))
            {
                param.Add("cc", cc);
            }
            else
            {
                param.Add("cc", null);
            }

            bcc = Encoding.GetEncoding(932).GetBytes(Convert.ToString(data["bcc"]).Trim());
            if (!string.IsNullOrEmpty(Convert.ToString(data["bcc"]).Trim()))
            {
                param.Add("bcc", bcc);
            }
            else
            {
                param.Add("bcc", null);
            }

            signature = Encoding.GetEncoding(932).GetBytes(Convert.ToString(data["signature"]).Trim());
            if (!string.IsNullOrEmpty(Convert.ToString(data["signature"]).Trim()))
            {
                param.Add("signature", signature);
            }
            else
            {
                param.Add("signature", null);
            }

            // SQLステートメントの定義
            sql = @"
                    merge
                    into mailconf
                      using (
                            select
                              :id id
                              , :mailfrom mailfrom
                              , :cc cc
                              , :bcc bcc
                              , :signature signature
                              , :servername servername
                              , :userid userid
                              , :password password
                              , :portno portno
                            from
                              dual
                      ) basedmailconf
                      on (mailconf.id = basedmailconf.id)
            ";

            // レコード存在時は上書き
            sql += @"
                      when matched then update
                          set
                            mailconf.mailfrom = basedmailconf.mailfrom
                            , mailconf.cc = basedmailconf.cc
                            , mailconf.bcc = basedmailconf.bcc
                            , mailconf.signature = basedmailconf.signature
                            , mailconf.servername = basedmailconf.servername
                            , mailconf.userid = basedmailconf.userid
                            , mailconf.password = basedmailconf.password
                            , mailconf.portno = basedmailconf.portno
            ";


            // レコード非存在時は挿入
            sql += @"
                      when not matched then
                          insert (
                            mailconf.id
                            , mailconf.mailfrom
                            , mailconf.cc
                            , mailconf.bcc
                            , mailconf.signature
                            , mailconf.servername
                            , mailconf.userid
                            , mailconf.password
                            , mailconf.portno
            ";

            sql += @"
                          )
                          values (
                            basedmailconf.id
                            , basedmailconf.mailfrom
                            , basedmailconf.cc
                            , basedmailconf.bcc
                            , basedmailconf.signature
                            , basedmailconf.servername
                            , basedmailconf.userid
                            , basedmailconf.password
                            , basedmailconf.portno
                          )
            ";

            connection.Execute(sql, param);

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }
    }
}