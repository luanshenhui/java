using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Mail;

namespace Hainsi.Entity
{
    /// <summary>
    /// メール送信用データアクセスオブジェクト
    /// </summary>
    public class SenderDao : AbstractDao
    {
        private const string TRANSACTIONDIV_RSVSEND = "LOGRSVSEND";    // 予約確認メール送信用のログ処理ＩＤ

        /// <summary>
        /// 汎用情報アクセス
        /// </summary>
        readonly FreeDao freeDao;

        /// <summary>
        /// 連携データアクセスオブジェクト
        /// </summary>
        readonly CooperationDao cooperationDao;

        /// <summary>
        /// ログ情報アクセスオブジェクト
        /// </summary>
        readonly HainsLogDao hainsLogDao;

        /// <summary>
        /// ユーザ情報アクセス
        /// </summary>
        readonly HainsUserDao hainsUserDao;

        /// <summary>
        /// メール送信設定アクセス
        /// </summary>
        readonly ConfigDao configDao;

        /// <summary>
        /// メールテンプレート情報アクセス
        /// </summary>
        readonly TemplateDao templateDao;

        /// <summary>
        /// 受診情報アクセス
        /// </summary>
        readonly MailConsultDao mailConsultDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">Oracleコンテキスト</param>
        /// <param name="freeDao">汎用情報アクセス</param>
        /// <param name="hainsLogDao">ログ情報アクセスオブジェクト</param>
        /// <param name="cooperationDao">連携データアクセスオブジェクト</param>
        /// <param name="hainsUserDao">ユーザ情報アクセス</param>
        /// <param name="configDao">メール送信設定アクセス</param>
        /// <param name="templateDao">メールテンプレート情報アクセス</param>
        /// <param name="mailConsultDao">受診情報アクセス</param>
        public SenderDao(IDbConnection connection, FreeDao freeDao, HainsLogDao hainsLogDao, CooperationDao cooperationDao,
            HainsUserDao hainsUserDao, ConfigDao configDao, TemplateDao templateDao, MailConsultDao mailConsultDao) : base(connection)
        {
            this.freeDao = freeDao;
            this.hainsLogDao = hainsLogDao;
            this.cooperationDao = cooperationDao;
            this.hainsUserDao = hainsUserDao;
            this.configDao = configDao;
            this.templateDao = templateDao;
            this.mailConsultDao = mailConsultDao;
        }

        /// <summary>
        ///  姓名を結合する
        /// </summary>
        /// <param name="lastName">姓</param>
        /// <param name="firstName">名</param>
        /// <returns>結合後の氏名</returns>
        private string JoinName(string lastName, string firstName)
        {
            return string.Join("　", new string[] { lastName, firstName });
        }

        /// <summary>
        /// オプション名称を結合する
        /// </summary>
        /// <param name="optionName">オプション名称</param>
        /// <param name="Delimiter">デリミタ</param>
        /// <param name="flg">null: オプション名称結合; en : オプション英語名称</param>
        /// <returns></returns>
        private string JoinOptionName(List<dynamic> optionName, string Delimiter, string flg = null)
        {
            string ret = "";

            if (optionName.Count == 1)
            {
                if (!string.IsNullOrEmpty(flg))
                {
                    // オプション英語名称場合
                    ret = optionName[0]["optionename"];
                }
                else
                {
                    // オプション名称結合
                    ret = optionName[0]["optionname"];
                }
            }
            else if (optionName.Count > 1)
            {
                List<string> optionNames = new List<string>();
                for (int i = 0; i < optionName.Count; i++)
                {
                    if (!string.IsNullOrEmpty(ret))
                    {
                        // デリミタ
                        ret += Delimiter;
                    }

                    if (!string.IsNullOrEmpty(flg))
                    {
                        // オプション英語名称場合
                        ret += optionName[i]["optionename"];
                    }
                    else
                    {
                        // オプション名称結合
                        ret += optionName[i]["optionname"];
                    }
                }

            }

            return ret;
        }

        /// <summary>
        /// 予約確認メールの送信
        /// </summary>
        /// <param name="userId">ユーザID</param>
        /// <param name="templateCd">テンプレートコード</param>
        /// <param name="arrRsvNo">予約番号</param>
        /// <returns>送信件数</returns>
        public long Send(string userId, string templateCd, List<string> arrRsvNo)
        {
            long count = 0;                     // 送信件数
            bool ret = false;                   // 戻り値

            string title = "";                  // 表題
            int transactionId;                  // トランザクションＩＤ
            string userName = "";               // ユーザ名

            string serverName = "";             // SMTPサーバ名
            string mailFrom = "";               // FROM
            string mailTo = "";                 // TO
            string body = "";                   // 本文

            string message = "";                // メッセージ
            string errMessage = "";             // メール送信時のエラーメッセージ
            string perName = "";                // 氏名
            string sendMailDivName = "";        // 予約確認メール送信先名称

            // トランザクションＩＤの取得
            transactionId = hainsLogDao.IncreaseTransactionId();

            // 汎用テーブルから表題を取得
            dynamic current = freeDao.SelectFree(0, TRANSACTIONDIV_RSVSEND).FirstOrDefault();

            // レコードが存在する場合
            if (current != null)
            {
                title = current.FREENAME;
            }

            // 開始ログの発行
            cooperationDao.PutHainsLog(transactionId, TRANSACTIONDIV_RSVSEND, "I", "", new List<string> { title + "処理を開始します。" }, new List<string> { "" });

            while (true)
            {
                // ユーザ情報の取得
                if (hainsUserDao.SelectUserName(userId) == null)
                {
                    cooperationDao.PutHainsLog(transactionId, TRANSACTIONDIV_RSVSEND, "E", "", new List<string> { "指定されたユーザIDは存在しません。" }, new List<string> { "ユーザID=" + userId });
                    break;
                }

                // メール送信設定の取得
                dynamic mailconf = configDao.SelectMailConf();
                if (mailconf == null)
                {
                    cooperationDao.PutHainsLog(transactionId, TRANSACTIONDIV_RSVSEND, "E", "", new List<string> { "メール送信設定の読み込みに失敗しました。" }, new List<string> { "" });
                    break;
                }

                ret = true;

                // メール送信設定の必須項目チェック
                while (true)
                {
                    // 送信元メールアドレスの必須チェック
                    if (string.IsNullOrEmpty(Convert.ToString(mailconf.MAILFROM)))
                    {
                        cooperationDao.PutHainsLog(transactionId, TRANSACTIONDIV_RSVSEND, "E", "", new List<string> { "送信元メールアドレスが設定されていません。" }, new List<string> { "" });
                        ret = false;
                    }

                    // サーバ名の必須チェック
                    if (string.IsNullOrEmpty(Convert.ToString(mailconf.MAILFROM)))
                    {
                        cooperationDao.PutHainsLog(transactionId, TRANSACTIONDIV_RSVSEND, "E", "", new List<string> { "SMTPサーバーが設定されていません。" }, new List<string> { "" });
                        ret = false;
                    }

                    break;
                }

                if (!ret)
                {
                    break;
                }

                // メールテンプレート情報の取得
                dynamic mailTemplate = templateDao.SelectMailTemplate(templateCd);
                if (mailTemplate == null)
                {
                    cooperationDao.PutHainsLog(transactionId, TRANSACTIONDIV_RSVSEND, "E", "", new List<string> { "指定されたメールテンプレートは存在しません。" }, new List<string> { "テンプレートコード" + templateCd });
                    break;
                }

                // 指定テンプレートの通知
                cooperationDao.PutHainsLog(transactionId, TRANSACTIONDIV_RSVSEND, "I", "", new List<string> { "次のメールテンプレートが指定されました。" }, new List<string> { "テンプレートコード=" + templateCd + "(" & mailTemplate.TEMPLATENAME + ")" });

                // メール送信メソッドのためのパラメータ設定
                serverName = Convert.ToString(mailconf.SERVERNAME + (!string.IsNullOrEmpty(Convert.ToString(mailconf.PORTNO)) ? (":" + Convert.ToString(mailconf.PORTNO)) : ""));
                mailFrom = Convert.ToString(mailconf.MAILFROM);
                if (!string.IsNullOrEmpty(Convert.ToString(mailconf.USERID)) ||
                   !string.IsNullOrEmpty(Convert.ToString(mailconf.PASSWORD)))
                {
                    mailFrom = mailFrom + "\t" + Convert.ToString(mailconf.USERID) + ":" + Convert.ToString(mailconf.PASSWORD);
                }

                // 受診情報の検索
                for (int i = 0; i < arrRsvNo.Count; i++)
                {
                    while (true)
                    {

                        message = "予約番号=" + arrRsvNo[i];

                        // 受診情報読み込み
                        dynamic consult = mailConsultDao.SelectConsult(arrRsvNo[i]);

                        if (consult == null)
                        {
                            cooperationDao.PutHainsLog(transactionId, TRANSACTIONDIV_RSVSEND, "W", "", new List<string> { "受診情報が存在しません。" }, new List<string> { message });
                            break;
                        }

                        // 胃部受診項目読み込み
                        dynamic stomacConsultInfo = mailConsultDao.SelectStomacConsultInfo(arrRsvNo[i]);

                        // オプション名称読み込み
                        List<dynamic> optionNameList = mailConsultDao.SelectOptionNameList(arrRsvNo[i]);

                        perName = Convert.ToString(consult.LASTNAME) + "　" + Convert.ToString(consult.FIRSTNAME);
                        perName = perName.Trim();
                        message = message + "、受診者名=" + perName;

                        switch (Convert.ToInt32(consult.SENDMAILDIV))
                        {
                            case 1:
                                sendMailDivName = "住所（自宅）";
                                break;
                            case 2:
                                sendMailDivName = "住所（勤務先）";
                                break;
                            case 3:
                                sendMailDivName = "住所（その他）";
                                break;
                            default:
                                sendMailDivName = "なし";
                                break;
                        }

                        // 送信先メールアドレスの存在チェック
                        if (string.IsNullOrEmpty(Convert.ToString(consult.EMAIL)))
                        {
                            cooperationDao.PutHainsLog(transactionId, TRANSACTIONDIV_RSVSEND, "W", "", new List<string> { "送信先メールアドレスが存在しません。" }, new List<string> { message + "、送信対象=" + sendMailDivName });
                            break;
                        }

                        // メール送信メソッドのための送信先設定
                        mailTo = string.IsNullOrEmpty(Convert.ToString(consult.EMAIL));
                        if (!string.IsNullOrEmpty(Convert.ToString(mailconf.CC)))
                        {
                            mailTo = mailTo + "cc" + "\t" + Convert.ToString(mailconf.CC).Replace("\r\n", "\t");
                        }
                        if (!string.IsNullOrEmpty(mailconf.BCC))
                        {
                            mailTo = mailTo + "bcc" + "\t" + Convert.ToString(mailconf.BCC).Replace("\r\n", "\t");
                        }

                        // 本文のテンプレート変換開始
                        body = mailTemplate.BODY;

                        // 氏名
                        body = body.Replace("{toName}", JoinName(Convert.ToString(consult.LASTNAME), Convert.ToString(consult.FIRSTNAME)));
                        body = body.Replace("{toKName}", JoinName(Convert.ToString(consult.LASTKNAME), Convert.ToString(consult.FIRSTKNAME)));
                        body = body.Replace("{toEName}", Convert.ToString(consult.ROMENAME));

                        // 受診日
                        body = body.Replace("{jDate}", DateTime.Parse(Convert.ToString(consult.CSLDATE)).ToString("yyyy. MM. dd"));
                        body = body.Replace("{jYear}", DateTime.Parse(Convert.ToString(consult.CSLDATE)).Year);
                        body = body.Replace("{jMonth}", DateTime.Parse(Convert.ToString(consult.CSLDATE)).Month);
                        body = body.Replace("{jDay}", DateTime.Parse(Convert.ToString(consult.CSLDATE)).Day);

                        //受付時間
                        body = body.Replace("{uKaiTm}", Convert.ToInt16(consult.STRTIME).ToString("#0:#0"));
                        body = body.Replace("{uShuTm}", Convert.ToInt16(consult.ENDTIME).ToString("#0:#0"));

                        // コース名
                        body = body.Replace("{corsNm}", Convert.ToString(consult.CSNAME));
                        body = body.Replace("{corsENm}", Convert.ToString(consult.CSENAME));


                        // 胃部受診項目
                        body = body.Replace("{stomacNm}", Convert.ToString(stomacConsultInfo.CONSULTNAME));
                        body = body.Replace("{stomacENm}", Convert.ToString(stomacConsultInfo.CONSULTENAME));

                        // オプション名称
                        body = body.Replace("{optNms}", JoinOptionName(optionNameList, "、"));
                        body = body.Replace("{optNmsV}", JoinOptionName(optionNameList, "\r\n"));


                        // オプション英語名称
                        body = body.Replace("{optENms}", JoinOptionName(optionNameList, "、", "en"));
                        body = body.Replace("{optENmsV}", JoinOptionName(optionNameList, "\r\n", "en"));

                        // 個人負担金額、受診金額
                        body = body.Replace("{perPrice}", Convert.ToInt64(consult.PERPRICE).ToString("#,##0"));
                        body = body.Replace("{price}", Convert.ToInt64(consult.PRICE).ToString("#,##0"));

                        // 個人ID
                        body = body.Replace("{perId}", (Convert.ToString(consult.PERID).Substring(0, 1).Equals("@") ? "" : Convert.ToString(consult.PERID)));

                        // 生年月日
                        body = body.Replace("{birth}", DateTime.Parse(Convert.ToString(consult.BIRTH)).ToString("yyyy. MM. dd"));

                        // 性別
                        body = body.Replace("{gender}", (("1").Equals(Convert.ToString(consult.GENDER)) ? "男性" : "女性"));
                        body = body.Replace("{genderE}", (("1").Equals(Convert.ToString(consult.GENDER)) ? "male" : "female"));

                        // 団体名
                        body = body.Replace("{orgName}", Convert.ToString(consult.ORGNAME));
                        body = body.Replace("{orgEName}", Convert.ToString(consult.ORGENAME));

                        // 署名の追加
                        if (!string.IsNullOrEmpty(Convert.ToString(mailconf.SIGNATURE)))
                        {
                            body += "\r\n" + "\r\n" + Convert.ToString(mailconf.SIGNATURE);
                        }

                        // メール送信
                        try
                        {
                            SmtpClient mail = new SmtpClient();
                            mail.Host = serverName;
                            MailMessage mailmessage = new MailMessage(mailFrom, mailTo, mailTemplate.SUBJECT, body);
                            mail.Send(mailmessage);
                        }
                        catch
                        {
                            cooperationDao.PutHainsLog(transactionId, TRANSACTIONDIV_RSVSEND, "E", "", new List<string> { "予約確認メール送信時にエラーが発生しました。" }, new List<string> { message + "、送信担当者=" + userName + "、詳細=" + errMessage });
                            break;
                        }

                        // 送信完了ログの出力
                        cooperationDao.PutHainsLog(transactionId, TRANSACTIONDIV_RSVSEND, "I", "", new List<string> { "予約確認メールが送信されました。" }, new List<string> { message + "、送信担当者=" + userName });

                        // 信件数をインクリメント
                        count++;

                        // 受診情報の更新
                        if (!mailConsultDao.UpdateConsult(new JObject { arrRsvNo[i], userId }))
                        {
                            cooperationDao.PutHainsLog(transactionId, TRANSACTIONDIV_RSVSEND, "E", "", new List<string> { "受診情報の更新時にエラーが発生しました。" }, new List<string> { message });
                            break;
                        }

                        break;
                    }
                }

                break;
            }

            // 終了ログ
            cooperationDao.PutHainsLog(transactionId, TRANSACTIONDIV_RSVSEND, "I", "", new List<string> { "処理を終了します。" }, new List<string> { "送信件数=" + count + "件" });

            return count;
        }
    }
}