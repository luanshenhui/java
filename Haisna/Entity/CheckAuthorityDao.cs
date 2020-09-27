using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

#pragma warning disable CS1591

namespace Hainsi.Entity
{
    /// <summary>
    /// プログラム使用権限情報データアクセスオブジェクト
    /// </summary>
    public class CheckAuthorityDao : AbstractDao
    {
        public string curPageName;
        public int curPageAuthority;

        /// <summary>
        /// プログラム操作権限
        /// </summary>
        public enum AUTHORITY
        {
            AUTHORITY_NOTING = 0,       // 権限なし
            AUTHORITY_SELECT = 1,       // 参照のみ
            AUTHORITY_INSERT = 2,       // 登録、更新のみ
            AUTHORITY_DELETE = 3,       // 削除のみ
            AUTHORITY_ALL = 4           // すべて権限
        };

        private const int TERM_EXPIRE = 90;
        private const int TERM_ALERT = 14;
        private const string MSG_EXPIRE1 = "パスワードの有効期間が満了しました。";
        private const string MSG_EXPIRE2 = "今パスワードを変更してください。";
        private const string MSG_ALERT1 = "現在のパスワードの使用可能期間は";
        private const string MSG_ALERT2 = "までです。";

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public CheckAuthorityDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// プログラムの使用権限を取得する
        /// </summary>
        /// <param name="userID">ユーザーＩＤ</param>
        /// <param name="userGrp">ユーザーグループ</param>
        /// <param name="fileName">ファイル名</param>
        /// <param name="pgmGrant">(Out)プログラム操作権限</param>
        /// <param name="message">(Out)メッセージ</param>
        /// <returns>
        /// true  権限
        /// false 権限なし
        /// </returns>
        public bool GetAuthority(string userID, string userGrp, string fileName, ref int pgmGrant, ref string message)
        {
            string sql = "";  // SQLステートメント
            string pgmName = "";
            int findPos = 0;
            string findName = "";

            findPos = fileName.LastIndexOf("/", StringComparison.Ordinal);

            if (findPos >= 0)
            {
                findName = fileName.Trim().Substring(findPos + 1).Trim();
            }

            if (!CheckPgmInfo(findName.Trim(), ref pgmName))
            {
                // マスターに登録が抜け落ちされた場合には既存と等しい状態を維持する。
                curPageName = fileName.Trim();
                curPageAuthority = 4;
                pgmGrant = 4;
                return true;
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("userid", userID.Trim());
            sqlParam.Add("usergrpcd", userGrp.Trim());
            sqlParam.Add("pgmfilename", findName.Trim());

            // 検索条件を満たす依頼項目テーブルのレコードを取得
            sql = @"
                    select
                      gpi.usrgrpcd
                      , gpi.pgmcd
                      , gpi.pgmgrant
                      , pi.pgmname
                      , pi.pgmfilename
                    from
                      grp_pgminfo gpi
                      , pgminfo pi
                    where
                      gpi.usrgrpcd = :usergrpcd
                      and gpi.pgmcd = pi.pgmcd
                      and pi.pgmfilename = :pgmfilename
                      and pi.delflg = 0
                ";

            dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

            if (current != null)
            {
                // オブジェクトの参照設定
                curPageName = current.PGMFILENAME;
                curPageAuthority = current.PGMGRANT;

                // プログラム操作権限
                // 1:参照、2:登録(変更）、3:削除　、4:すべて
                pgmGrant = current.PGMGRANT;

                return true;
            }
            else
            {
                message = userGrp + ": " + findName + "【" + pgmName + "】" + " ごのプログラムの使用権限がありません。";
                return false;
            }
        }

        /// <summary>
        /// プログラム名を取得する
        /// </summary>
        /// <param name="pgmFileName">ファイル名</param>
        /// <param name="pgmName">プログラム名</param>
        /// <returns>
        /// true  権限
        /// false 権限なし
        /// </returns>
        private bool CheckPgmInfo(string pgmFileName, ref string pgmName)
        {
            string sql = "";  // SQLステートメント

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("filename", pgmFileName.Trim());

            // 検索条件を満たす依頼項目テーブルのレコードを取得
            sql = @"
                    select
                      pi.pgmcd
                      , pi.pgmname
                      , pi.pgmfilename
                    from
                      pgminfo pi
                    where
                      pi.pgmfilename = :pgmfilenam
                ";

            dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current != null)
            {
                pgmName = Convert.ToString(current.PGMNAME);
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// パスワードの有効期間をチェック
        /// </summary>
        /// <param name="userId">ユーザーＩＤ</param>
        /// <param name="message">(Out)メッセージ</param>
        /// <returns>
        /// 2  有効
        /// 1  有効期間が満了
        /// </returns>
        public int CheckPwdDate(string userId, ref string message)
        {
            string sql = "";  // SQLステートメント
            int expire;
            int alert;
            string expire1 = "";
            string expire2 = "";
            string alert1 = "";
            string alert2 = "";
            int use;
            int ret = 0;
            string expDate;
            DateTime passDate = new DateTime();

            message = "";

            // パスワードの有効期間を取得する
            dynamic expireInfo = GetExpireInfo();

            if (expireInfo == null)
            {
                expire = TERM_EXPIRE;
                alert = TERM_ALERT;
                expire1 = MSG_EXPIRE1;
                expire2 = MSG_EXPIRE2;
                alert1 = MSG_ALERT1;
                alert2 = MSG_ALERT2;
            }
            else
            {
                expire = Convert.ToInt32(expireInfo.EXPTERM);
                alert = Convert.ToInt32(expireInfo.ALTTERM);
                expire1 = Convert.ToString(expireInfo.EXPMSG1);
                expire2 = Convert.ToString(expireInfo.EXPMSG2);
                alert1 = Convert.ToString(expireInfo.ALTMSG1);
                alert2 = Convert.ToString(expireInfo.ALTMSG2);
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("userid", userId.Trim().ToUpper());

            // 検索条件を満たす依頼項目テーブルのレコードを取得
            sql = @"
                    select
                      nvl(pwdsetdate, sysdate -" + expire + alert + ") PWDSETDATE  ";

            sql += @"
                    from
                      hainsuser
                    where
                      userid = :userid
                ";

            dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current != null)
            {
                passDate = Convert.ToDateTime(current.PASSDATE);
            }

            use = ((TimeSpan)(DateTime.Now - passDate)).Days;

            if (use >= expire)
            {
                message = expire1 + "\n" + expire2;
                ret = 2;
            }
            else if ((expire - use) <= alert)
            {
                expDate = DateTime.Now.AddDays(expire - use).ToString("yyyy/MM/dd");
                message = alert1 + "【" + expDate + "】" + alert2;
                ret = 1;
            }

            return ret;
        }

        /// <summary>
        /// パスワードの有効期間を取得する
        /// </summary>
        /// <returns>
        /// expterm
        /// altterm
        /// expmsg1
        /// expmsg2
        /// altmsg1
        /// altmsg2
        /// </returns>
        private dynamic GetExpireInfo()
        {
            string sql = "";  // SQLステートメント

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("freecd", "PWDSET");

            sql = @"
                    select
                      freefield1 expterm
                      , freefield2 altterm
                      , freefield3 expmsg1
                      , freefield4 expmsg2
                      , freefield5 altmsg1
                      , freefield6 altmsg2
                    from
                      free
                    where
                      freecd = :freecd

                ";

            // 戻り値の設定
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }
    }
}