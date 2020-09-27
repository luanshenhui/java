using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Transactions;

namespace Hainsi.Entity
{
    /// <summary>
    /// ユーザ情報データアクセスオブジェクト
    /// </summary>
    public class HainsUserDao : AbstractDao
    {
        const string ITEMCD_DOCTOR = "30910";

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public HainsUserDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// ユーザIDとパスワードをチェックする
        /// </summary>
        /// <param name="data">入力データ</param>
        /// <returns>ユーザデータ</returns>
        public dynamic CheckIDandPassword(JToken data)
        {
            string userid = Convert.ToString(data["username"]);
            string password = Convert.ToString(data["password"]);

            // パスワードをエンコード
            // string secret = password.EncryptUserPassword();
            string secret = AuthUtil.SecretCodeMake(password);

            // SQLパラメータ
            var sqlParam = new
            {
                userid = userid.ToUpper().Trim(),
                password = secret,
            };

            // SQLステートメント
            string sql = @"
                    select
                        username
                        , authtblmnt
                        , authrsv
                        , authrsl
                        , authjud
                        , authprn
                        , authdmd
                        , ignoreflg
                        , authext1
                        , deptcd
                        , usrgrpcd
                    from
                        hainsuser
                    where
                        userid = :userid
                        and password = :password
                        and delflg is null
                ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <param name="userid">ユーザID</param>
        /// <param name="passDecode">TRUE:デコードしてパスワードを返す</param>
        /// <returns>ユーザテーブルレコード</returns>
        public dynamic SelectHainsUser(string userid, bool passDecode)
        {
            // SQLパラメータ
            var sqlParam = new
            {
                userid = userid.ToUpper().Trim(),
                itemcd_doctor = ITEMCD_DOCTOR,
                itemtype = ItemType.Standard

            };

            // SQLステートメント
            string sql = @"
                        select
                          username
                          , password
                          , authtblmnt
                          , authrsv
                          , authrsl
                          , authjud
                          , authprn
                          , authdmd
                          , kname
                          , ename
                          , menflg
                          , hanflg
                          , kanflg
                          , eiflg
                          , shinflg
                          , ignoreflg
                          , authnote
                          , defnotedispkbn
                          , naiflg
                          , sentencecd
                          , (
                            select
                              shortstc
                            from
                              sentence
                            where
                              itemcd = :itemcd_doctor
                              and itemtype = :itemtype
                              and stccd = sentencecd
                          ) shortstc
                          , authext1
                          , authext2
                          , authext3
                          , delflg
                          , deptcd
                          , usrgrpcd
                        from
                          hainsuser
                        where
                          userid = :userid
                    ";

            // SQL実行
            dynamic data = connection.Query(sql, sqlParam).FirstOrDefault();

            // レコードが存在する場合
            if (data != null)
            {
                // Decode済みのパスワードを返す場合
                if (passDecode)
                {
                    string secret = AuthUtil.EncryptUserPassword(data.PASSWORD);
                    data.PASSWORD = secret;
                }
            }

            return data;
        }

        /// <summary>
        /// ユーザ一覧を取得する
        /// </summary>
        /// <param name="searchCode">検索用コード（省略可）</param>
        /// <param name="searchString">検索用文字列（省略可）</param>
        /// <returns>
        /// userID         ユーザコード
        /// userName       ユーザ名
        /// delFlg         削除フラグ
        /// </returns>
        public List<dynamic> SelectUserList(string searchCode = "", string searchString = "")
        {
            bool whereFlg = false;

            // ユーザテーブルより判定ユーザのレコードを取得
            string sql = @"
                        select
                          userid
                          , username
                          , delflg
                        from
                          hainsuser
                    ";

            // 検索用文字列の設定（マスタメンテ用？）
            if (searchCode.Trim() != "")
            {
                sql += " where userid like '%" + searchCode + "%'";
                whereFlg = true;
            }

            if (searchString.Trim() != "")
            {
                if (whereFlg == false)
                {
                    sql += " where username like '%" + searchString + "%'";
                }
                else
                {
                    sql += " and username like '%" + searchString + "%'";
                }
            }

            sql += " order by userid";

            // SQL実行
            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// ユーザ名を取得する
        /// </summary>
        /// <param name="userID">ユーザＩＤ</param>
        /// <param name="doctorFlg">判定医フラグ（省略可）</param>
        /// <returns>ユーザ名</returns>
        public string SelectUserName(string userID, string doctorFlg = null)
        {
            string userName;  // ユーザ名

            // SQLパラメータ
            var sqlParam = new
            {
                userid = userID.ToUpper().Trim()
            };

            // SQLステートメント
            string sql = @"
                        select
                          h.username
                        from
                          hainsuser h
                        where
                          h.userid = :userid
                    ";

            // SQL実行
            dynamic data = connection.Query(sql).FirstOrDefault();

            if (data != null)
            {
                userName = data.USERNAME;
            }
            else
            {
                userName = null;
            }

            return userName;
        }

        /// <summary>
        /// ユーザテーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード ("INS":挿入、"UPD":更新、"PWD"：パスワード変更)</param>
        /// <param name="data">ユーザ情報
        /// userid       ユーザＩＤ
        /// username     ユーザ名
        /// password     パスワード
        /// authtblmnt   テーブルメンテナンス権限
        /// authrsv      予約業務権限
        /// authrsl      結果入力業務権限
        /// authjud      判定入力業務権限
        /// authprn      印刷、データ抽出業務権限
        /// authdmd      請求業務権限
        /// doctorflg    判定医フラグ
        /// kname        利用者カナ氏名
        /// ename        利用者英字氏名
        /// </param>
        /// <returns>
        ///	Insert.Normal     正常終了
        ///	Insert.Duplicate  同一キーのレコード存在
        ///	Insert.Error      異常終了
        ///	</returns>
        public Insert RegistHainsUser(string mode, JToken data)
        {
            string sql; // SQLステートメント

            Insert ret = Insert.Error;  // 関数戻り値

            int result; // SQL実行戻り値

            // パスワードをエンコード
            string secret = AuthUtil.SecretCodeMake(Convert.ToString(data["password"]).Trim());

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("userid", Convert.ToString(data["userid"]).ToUpper().Trim());
            param.Add("username", Convert.ToString(data["username"]).Trim());
            param.Add("password", secret);
            param.Add("delflg", Convert.ToString(data["delflg"]).Trim());
            param.Add("authtblmnt", Convert.ToInt32(data["authtblmnt"]));
            param.Add("authrsv", Convert.ToInt32(data["authrsv"]));
            param.Add("authrsl", Convert.ToInt32(data["authrsl"]));
            param.Add("authjud", Convert.ToInt32(data["authjud"]));
            param.Add("authprn", Convert.ToInt32(data["authprn"]));
            param.Add("authdmd", Convert.ToInt32(data["authdmd"]));
            param.Add("authext1", Convert.ToInt32(data["authext1"]));
            param.Add("authext2", Convert.ToInt32(data["authext2"]));
            param.Add("authext3", Convert.ToInt32(data["authext3"]));
            param.Add("menflg", Convert.ToInt32(data["menflg"]));
            param.Add("hanflg", Convert.ToInt32(data["hanflg"]));
            param.Add("kanflg", Convert.ToInt32(data["kanflg"]));
            param.Add("eiflg", Convert.ToInt32(data["eiflg"]));
            param.Add("shinflg", Convert.ToInt32(data["shinflg"]));
            param.Add("naiflg", Convert.ToString(data["naiflg"]).Trim());
            param.Add("ignoreflg", Convert.ToInt32(data["ignoreflg"]));
            param.Add("authnote", Convert.ToInt32(data["authnote"]));
            param.Add("kname", Convert.ToString(data["kname"]).Trim());
            param.Add("ename", Convert.ToString(data["ename"]).Trim());
            param.Add("sentencecd", Convert.ToString(data["sentencecd"]).Trim());
            param.Add("defnotedispkbn", Convert.ToString(data["defnotedispkbn"]).Trim());
            param.Add("deptcd", Convert.ToString(data["deptcd"]).Trim());
            param.Add("usrgrpcd", Convert.ToString(data["usrgrpcd"]).Trim());

            try
            {
                while (true)
                {
                    // パスワードのみの更新
                    if ("PWD".Equals(mode))
                    {
                        sql = @"
                                update hainsuser
                                set
                                  password = :password
                                  , pwdsetdate = sysdate
                                where
                                  userid = :userid
                              ";

                        result = connection.Execute(sql, param);

                        if (result > 0)
                        {
                            ret = Insert.Normal;
                        }
                        break;
                    }

                    // ユーザテーブルレコードの更新
                    if ("UPD".Equals(mode))
                    {
                        sql = @"
                            update hainsuser
                            set
                              username = :username
                              , password = :password
                              , delflg = :delflg
                              , authtblmnt = :authtblmnt
                              , authrsv = :authrsv
                              , authrsl = :authrsl
                              , authjud = :authjud
                              , authprn = :authprn
                              , authdmd = :authdmd
                              , authext1 = :authext1
                              , authext2 = :authext2
                              , authext3 = :authext3
                              , deptcd = :deptcd
                              , usrgrpcd = :usrgrpcd
                              , menflg = :menflg
                              , hanflg = :hanflg
                              , kanflg = :kanflg
                              , eiflg = :eiflg
                              , shinflg = :shinflg
                              , ignoreflg = :ignoreflg
                              , authnote = :authnote
                              , kname = :kname
                              , ename = :ename
                              , sentencecd = :sentencecd
                              , defnotedispkbn = :defnotedispkbn
                              , naiflg = :naiflg
                            where
                              userid = :userid
                        ";

                        result = connection.Execute(sql, param);

                        if (result > 0)
                        {
                            ret = Insert.Normal;
                        }
                        break;
                    }

                    // 検索条件を満たすユーザテーブルのレコードを取得
                    sql = "select userid from hainsuser where userid = :userid";

                    var current = connection.Query(sql, param).FirstOrDefault();

                    // 存在した場合、新規挿入不可
                    if (current != null)
                    {
                        ret = Insert.Duplicate;
                        break;
                    }

                    // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                    sql = @" insert
                            into hainsuser(
                              userid
                              , password
                              , delflg
                              , authtblmnt
                              , authrsv
                              , authrsl
                              , authjud
                              , authprn
                              , authdmd
                              , authext1
                              , authext2
                              , authext3
                              , menflg
                              , hanflg
                              , kanflg
                              , eiflg
                              , shinflg
                              , ignoreflg
                              , authnote
                              , username
                              , kname
                              , ename
                              , sentencecd
                              , defnotedispkbn
                              , naiflg
                              , deptcd
                              , usrgrpcd
                              , pwdsetdate
                            )
                            values (
                              :userid
                              , :password
                              , :delflg
                              , :authtblmnt
                              , :authrsv
                              , :authrsl
                              , :authjud
                              , :authprn
                              , :authdmd
                              , :authext1
                              , :authext2
                              , :authext3
                              , :menflg
                              , :hanflg
                              , :kanflg
                              , :eiflg
                              , :shinflg
                              , :ignoreflg
                              , :authnote
                              , :username
                              , :kname
                              , :ename
                              , :sentencecd
                              , :defnotedispkbn
                              , :naiflg
                              , :deptcd
                              , :usrgrpcd
                              , sysdate
                        ) ";

                    connection.Execute(sql, param);

                    ret = Insert.Normal;
                    break;
                }

                return ret;
            }
            catch
            {
                return Insert.Error;
            }
        }

        /// <summary>
        /// 氏名、カナ氏名、英字氏名を更新する（カルテ利用者連携用）
        /// </summary>
        /// <param name="userId">ユーザID</param>
        /// <param name="userName">利用者漢字氏名</param>
        /// <param name="kName">利用者カナ氏名</param>
        /// <param name="eName">利用者英字氏名</param>
        /// <param name="windowsLoginId">WindowsログインID</param>
        /// <returns></returns>
        public int MergeUserName(string userId, string userName, string kName, string eName, string windowsLoginId)
        {
            using (var ts = new TransactionScope())
            {
                // SQL定義
                string sql = @"
                    merge 
                    into hainsuser 
                        using (
                            select
                                :userid userid
                                , :password password
                                , :username username
                                , :kname kname
                                , :ename ename
                                , :windowsloginid windowsloginid
                            from
                                dual
                        ) phantom 
                            on (
                                hainsuser.userid = phantom.userid
                            )
                    when matched then 
                        update set
                            username = phantom.username
                            , kname = phantom.kname
                            , ename = phantom.ename 
                            , windowsloginid = phantom.windowsloginid
                    when not matched then 
                        insert (
                            userid
                            , password
                            , username
                            , kname
                            , ename
                            , windowsloginid
                        ) 
                        values (
                            :userid
                            , :password
                            , :username
                            , :kname
                            , :ename
                            , :windowsloginid
                        )
                ";

                // パラメータセット
                var sqlParam = new
                {
                    userid = userId,
                    password = userId,
                    username = userName,
                    kname = kName,
                    ename = eName,
                    windowsloginid = windowsLoginId,
                };

                // SQL実行
                var result = connection.Execute(sql, sqlParam);
                if (result == 0)
                {
                    return 0;
                }

                // トランザクションをコミット
                ts.Complete();

                return 1;
            }
        }

        /// <summary>
        /// ユーザテーブルレコードを削除する
        /// </summary>
        /// <param name="userID">ユーザID</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool DeleteHainsUser(string userID)
        {

            string sql;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("userid", userID.ToUpper().Trim());

            // ユーザテーブルレコードの削除
            sql = "delete hainsuser where userid = :userid";

            connection.Execute(sql, param);

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> Validate(JToken data)
        {
            var messages = new List<string>();

            //グループコード未入力チェック
            if (string.IsNullOrEmpty(Convert.ToString(data["username"])))
            {
                messages.Add(string.Format("ユーザIDが入力されていません。"));
            }

            return messages;
        }
    }
}
