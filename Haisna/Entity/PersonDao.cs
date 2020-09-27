using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.Entity.Model;
using Hainsi.Entity.Model.Person;
using Microsoft.VisualBasic;
using Newtonsoft.Json.Linq;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Transactions;

namespace Hainsi.Entity
{
    /// <summary>
    /// 個人情報データアクセスオブジェクト
    /// </summary>
    public class PersonDao : AbstractDao
    {
        private const string VID_PREFIX = "@";  // 仮ＩＤ用の接頭子
        private const string RID_PREFIX = "1";  // 実ＩＤ用の接頭子

        // 個人情報抽出条件
        private const string MODE_CSL = "csl";  // 指定期間の受診者指定
        private const string MODE_ZIP = "zip";  // 郵便番号指定

        private const string PREFIX_PERID = "ID:";  // 検索時の個人ＩＤ指定
        private const string PREFIX_BIRTH = "BIRTH:";  // 検索時の生年月日指定
        private const string PREFIX_GENDER = "GENDER:";  // 検索時の性別指定

        // HOPEの患者ID桁数管理
        private const int LENGTH_HOPE_PERID = 10;

        /// <summary>
        /// 個人住所情報データアクセスオブジェクト
        /// </summary>
        readonly PerAddrDao perAddrDao;

        /// <summary>
        /// 汎用情報データアクセスオブジェクト
        /// </summary>
        readonly FreeDao freeDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        /// <param name="perAddrDao">個人住所情報データアクセスオブジェクト</param>
        /// <param name="freeDao">汎用情報データアクセスオブジェクト</param>
        public PersonDao(IDbConnection connection, PerAddrDao perAddrDao, FreeDao freeDao) : base(connection)
        {
            this.perAddrDao = perAddrDao;
            this.freeDao = freeDao;
        }

        /// <summary>
        /// 個人属性を登録する
        /// </summary>
        /// <param name="param"></param>
        public void RegisterPersonAttribute(PersonAttributeModel param)
        {
            using (var tran = BeginTransaction())
            {
                try
                {
                    // 個人テーブルに該当レコードが存在するかをチェックする
                    bool isExistPerson = (SelectPersonInf(param.PerId) != null);

                    // 個人情報登録
                    RegisterPerson(param);

                    // 住所区分1(自宅)住所登録
                    if (!isExistPerson)
                    {
                        // 個人レコードが存在しない場合のみ登録する
                        perAddrDao.InsertContactPerAddr(param);
                    }

                    // 住所情報登録
                    perAddrDao.RegisterPerAddr(param);

                    // コミット
                    tran.Commit();
                }
                catch (Exception)
                {
                    // ロールバック
                    tran.Rollback();

                    throw;
                }
            }
        }

        /// <summary>
        /// 個人テーブルの登録をする
        /// </summary>
        /// <param name="param">個人情報</param>
        /// <returns>登録件数</returns>
        public int RegisterPerson(PersonAttributeModel param)
        {
            // SQL定義
            string sql = @"
                            merge
                            into person
                                using (
                                    select
                                        :perid perid
                                        , :vidflg vidflg
                                        , :delflg delflg
                                        , sysdate upddate
                                        , :upduser upduser
                                        , :birth birth
                                        , :gender gender
                                        , :firstname firstname
                                        , :lastname lastname
                                        , :firstkname firstkname
                                        , :lastkname lastkname
                                        , :romename romename
                                        , :medrname medrname
                                        , :medname medname
                                        , :medbirth medbirth
                                        , :medgender medgender
                                        , sysdate medupddate
                                        , :postcardaddr postcardaddr
                                        , :mednationcd mednationcd
                                        , :medkname medkname
                                    from
                                        dual
                                ) phantom
                                    on (person.perid = phantom.perid) when not matched then
                            insert (
                                perid
                                , vidflg
                                , delflg
                                , upddate
                                , upduser
                                , birth
                                , gender
                                , firstname
                                , lastname
                                , firstkname
                                , lastkname
                                , romename
                                , medrname
                                , medname
                                , medbirth
                                , medgender
                                , medupddate
                                , postcardaddr
                                , mednationcd
                                , medkname
                            )
                            values (
                                phantom.perid
                                , phantom.vidflg
                                , phantom.delflg
                                , phantom.upddate
                                , phantom.upduser
                                , phantom.birth
                                , phantom.gender
                                , phantom.firstname
                                , phantom.lastname
                                , phantom.firstkname
                                , phantom.lastkname
                                , phantom.romename
                                , phantom.medrname
                                , phantom.medname
                                , phantom.medbirth
                                , phantom.medgender
                                , phantom.medupddate
                                , phantom.postcardaddr
                                , phantom.mednationcd
                                , phantom.medkname
                            ) when matched then update
                            set
                                medrname = phantom.medrname
                                , medname = phantom.medname
                                , medbirth = phantom.medbirth
                                , medgender = phantom.medgender
                                , medupddate = phantom.medupddate
                                , mednationcd = phantom.mednationcd
                                , medkname = phantom.medkname
                ";

            // パラメータセット
            var sqlParam = new
            {
                perid = param.PerId,
                vidflg = param.VidFlg,
                delflg = param.DelFlg,
                upduser = param.UpdUser,
                birth = param.Birth,
                gender = param.Gender,
                firstname = param.FirstName,
                lastname = param.LastName,
                firstkname = param.FirstKName,
                lastkname = param.LastKName,
                romename = param.RomeName,
                medrname = param.MedRName,
                medname = param.MedName,
                medbirth = param.MedBirth,
                medgender = param.MedGender,
                postcardaddr = param.PostCardAddr,
                mednationcd = param.MedNationCd,
                medkname = param.MedKName,
            };

            // SQL実行
            return connection.Execute(sql, sqlParam);
        }

        /// <summary>
        /// 生年月日条件節の追加
        /// </summary>
        /// <param name="sqlParam">SQLパラメータ</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        /// <returns>条件節</returns>
        private string AppendCondition_Birth(Dictionary<string, object> sqlParam, string buffer, int paramNo)
        {
            string stmt = "";  // SQLステートメント
            string birth = "";  // 生年月日
            string paramName = "";  // パラメータ名
            DateTime dateTime = new DateTime(); // 日付

            // 先頭６文字が"BIRTH:"である場合は先頭部を取り除いた部分を生年月日として取得、それ以外は引数値をそのまま使用
            if (buffer.Substring(0, PREFIX_BIRTH.Length).ToUpper() == PREFIX_BIRTH)
            {
                birth = buffer.Substring(PREFIX_BIRTH.Length);
            }
            else
            {
                birth = buffer;
            }

            // すでに日付型である場合
            if (DateTime.TryParse(birth, out dateTime))
            {
                // そのまま適用
                birth = dateTime.ToString("yyyy/M/d");
                
            }
            // 日付型でない(すなわち８桁の数字列である)場合
            else
            {
                // 年がゼロの場合はシステム年を適用し、さもなくばそのまま日付型にして適用
                birth = string.Format("{0:0000/00/00}", birth.Substring(0, 4) == "0000" ? Convert.ToInt32(DateTime.Now.Year.ToString() + birth.Substring(birth.Length - 4)) : Convert.ToInt32(birth));

            }

            // パラメータ追加
            paramName = "birth" + paramNo.ToString();
            sqlParam.Add(paramName, birth);

            // 条件節の編集
            stmt = " person.birth = :" + paramName;

            return stmt;
        }

        /// <summary>
        /// 性別条件節の追加
        /// </summary>
        /// <param name="sqlParam">SQLパラメータ</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        /// <returns>条件節</returns>
        private string AppendCondition_Gender(Dictionary<string, object> sqlParam, string buffer, int paramNo)
        {
            string paramName = "";  // パラメータ名
            string stmt = "";  // SQLステートメント
            string gender = ""; // 性別

            // 先頭６文字が"GENDER:"である場合は先頭部を取り除いた部分を生年月日として取得、それ以外は引数値をそのまま使用
            if (buffer.Substring(0, PREFIX_GENDER.Length).ToUpper() == PREFIX_GENDER)
            {
                gender = buffer.Substring(PREFIX_GENDER.Length);
            }
            else
            {
                gender = buffer;
            }

            // 男性指定か女性指定か？
            switch (gender.ToUpper())
            {
                case "M":
                case "F":
                    // パラメータ追加
                    paramName = "gender" + paramNo.ToString();
                    sqlParam.Add(paramName, "M".Equals(gender.ToUpper()) ? (int)Gender.Male : (int)Gender.Female);

                    stmt = " person.gender = :" + paramName;

                    break;
                default:
                    return "";
            }

            return stmt;
        }

        /// <summary>
        /// 個人ＩＤ条件節の追加
        /// </summary>
        /// <param name="sqlParam">SQLパラメータ</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        /// <returns>条件節</returns>
        private string AppendCondition_PerId(Dictionary<string, object> sqlParam, string buffer, int paramNo)
        {
            string stmt = "";  // SQLステートメント
            string perId = "";  // 個人ＩＤ
            string paramName = "";  // パラメータ名

            // 先頭３文字が"ID:"である場合は先頭部を取り除いた部分を個人IDとして取得、それ以外は引数値をそのまま使用
            if (buffer.Substring(0, PREFIX_PERID.Length).ToUpper() == PREFIX_PERID)
            {
                perId = buffer.Substring(PREFIX_PERID.Length);
            }
            else
            {
                perId = buffer;
            }

            // パラメータ追加
            paramName = "perid" + paramNo.ToString();

            // 文字列の末尾が"*"なら部分検索
            if (perId.Substring(perId.Length - 1) == "*")
            {
                sqlParam.Add(paramName, perId.Substring(0, perId.Length - 1).Trim() + "%");
                stmt = " person.perid like :" + paramName;

                // さもなければ直接指定
            }
            else
            {
                sqlParam.Add(paramName, perId.Trim());
                stmt = " person.perid = :" + paramName;
            }

            return stmt;
        }

        /// <summary>
        /// ローマ字条件節の追加
        /// </summary>
        /// <param name="sqlParam">SQLパラメータ</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        /// <param name="romeNameMultiple">複合検索フラグ</param>
        /// <returns>条件節</returns>
        private string AppendCondition_RomeName(Dictionary<string, object> sqlParam, string buffer, int paramNo, bool romeNameMultiple)
        {
            string paramName = "";  // パラメータ名
            string paramName2 = "";  // パラメータ名
            string stmt = "";  // SQLステートメント
            string buffer2 = "";  // 文字列バッファ
            int pos;

            buffer = buffer.ToUpper();

            while (true)
            {
                // 複合検索を行わない場合
                if (!romeNameMultiple)
                {
                    break;
                }

                // １つ目の空白を検索。見つからない場合は複合検索を行わない場合と同じ
                pos = buffer.IndexOf(" ");
                if (Convert.ToInt32(pos) < 0)
                {
                    romeNameMultiple = false;
                    break;
                }

                // １つ目の空白以降の部分文字列を取得。なければ複合検索を行わない場合と同じ
                buffer2 = buffer.Substring(pos).Trim();
                if (string.IsNullOrEmpty(buffer2))
                {
                    romeNameMultiple = false;
                    break;
                }

                break;
            }

            // パラメータ追加
            paramName = "name" + paramNo.ToString();
            sqlParam.Add(paramName, buffer + "%");

            // 複合検索を行う場合はさらにパラメータ追加
            if (romeNameMultiple)
            {
                paramName2 = "partname" + paramNo.ToString();
                sqlParam.Add(paramName2, buffer2 + "%");
            }

            // 複合検索を行わない場合
            if (!romeNameMultiple)
            {

                // パラメータ値の完全一致検索のみ
                stmt = " person.romename like :" + paramName;

                // 複合検索を行う場合
            }
            else
            {
                // パラメータ値の完全一致検索あるいは部分文字列検索
                stmt = " ( person.romename like :" + paramName + " or person.searchrname like :" + paramName2 + " )";
            }

            return stmt;
        }

        /// <summary>
        /// 全角文字条件節の追加
        /// </summary>
        /// <param name="sqlParam">SQLパラメータ</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        /// <returns>条件節</returns>
        private string AppendCondition_Wide(Dictionary<string, object> sqlParam, string buffer, int paramNo)
        {

            string paramName1 = "";  // パラメータ名
            string paramName2 = "";  // パラメータ名

            string stmt = "";  // SQLステートメント
            string narrow = "";  // 半角変換後の文字列
            bool wideChar;  // カナ漢字チェック用変数
            string buffer2 = "";  // 文字列バッファ

            string lastName = "";  // 姓
            string firstName = "";  // 名

            int pos;  // 空白検索位置

            // カナ以外の全角文字が存在するかをチェック(カナは半角変換でき、漢字・ひらがなは半角変換できない性質を利用)
            narrow = Strings.StrConv(buffer, VbStrConv.Narrow);
            wideChar = false;
            int j = 0;
            for (int i = 0; i < narrow.Length; i++)
            {
                if (narrow[i] == 'ﾞ' || narrow[i] == 'ﾟ')
                {
                    continue;
                }
                if (narrow[i] == buffer[j])
                {
                    wideChar = true;
                    break;
                }
                j++;
            }

            // 姓名で検索するか姓のみで検索するかを判定
            while (true)
            {
                // １つ目の空白を検索。見つからない場合は姓のみ。
                pos = buffer.IndexOf(" ");
                if (pos < 0)
                {
                    lastName = Strings.Trim(buffer);
                    firstName = "";
                    break;
                }

                // １つ目の空白以降の部分文字列を取得。なければ複合検索を行わない場合と同じ
                buffer2 = buffer.Substring(pos).Trim();
                if (string.IsNullOrEmpty(buffer2))
                {
                    lastName = buffer.Trim();
                    firstName = "";
                    break;
                }

                // 姓名に分離
                lastName = buffer.Substring(0, pos).Trim();
                firstName = buffer2;

                break;
            }

            // 姓のみで検索する場合
            if (string.IsNullOrEmpty(firstName))
            {
                // パラメータ追加
                paramName1 = "lastname" + paramNo.ToString();
                sqlParam.Add(paramName1, lastName + "%");

                while (true)
                {
                    // カナ以外の全角文字が含まれる場合
                    if (wideChar == true)
                    {
                        stmt = " ( person.lastname like :" + paramName1 + " )";
                        break;
                    }

                    // 置換前後で文字列値が同一ならば通常の検索を行う
                    stmt = " ( person.lastkname like :" + paramName1 + " ) ";

                    break;
                }
            }
            else
            {
                // パラメータ追加
                paramName1 = "lastname" + paramNo.ToString();
                paramName2 = "firstname" + paramNo.ToString();
                sqlParam.Add(paramName1, lastName);
                sqlParam.Add(paramName2, firstName + "%");

                while (true)
                {
                    // カナ以外の全角文字が含まれる場合
                    if (wideChar == true)
                    {
                        stmt = "( person.lastname = :" + paramName1 + " and person.firstname like :" + paramName2 + " )";
                        break;
                    }

                    // 置換前後で文字列値が同一ならば通常の検索を行う
                    stmt = "( person.lastkname = :" + paramName1 + " and person.firstkname like :" + paramName2 + " )";
                }
            }

            return stmt;
        }

        /// <summary>
        /// 個人ＩＤつけかえ
        /// </summary>
        /// <param name="fromPerID">変更される個人ID</param>
        /// <param name="toPerID">変更する個人ID</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool ChangePerID(string fromPerID, string toPerID)
        {
            string sql = "";  // SQLステートメント
            bool status;

            using (var transaction = BeginTransaction())
            {
                try
                {
                    status = false;

                    // キー及び更新値の設定
                    var sqlParam = new
                    {
                        fromperid = fromPerID.Trim(),
                        toperid = toPerID.Trim()
                    };

                    // 予約情報テーブルの更新
                    sql = @"
                            update consult
                            set
                                perid = :toperid
                            where
                                perid = :fromperid
                        ";
                    connection.Execute(sql, sqlParam);

                    // WEBユーザIDテーブルの更新
                    sql = @"
                           update web_userid
                            set
                              perid = :toperid
                            where
                              perid = :fromperid
                        ";
                    connection.Execute(sql, sqlParam);

                    // 個人検査結果テーブルの更新
                    sql = @"
                           update perresult
                            set
                              perid = :toperid
                            where
                              perid = :fromperid
                        ";
                    connection.Execute(sql, sqlParam);

                    // 団体名簿明細テーブルの更新
                    sql = @"
                           update orgrsv_d
                            set
                              perid = :toperid
                            where
                              perid = :fromperid
                        ";
                    connection.Execute(sql, sqlParam);

                    // アフターケアテーブルの更新
                    sql = @"
                           update aftercare
                            set
                                perid = :toperid
                            where
                                perid = :fromperid
                        ";
                    connection.Execute(sql, sqlParam);

                    // アフターケア管理項目テーブルの更新
                    sql = @"
                           update aftercare_m
                            set
                              perid = :toperid
                            where
                              perid = :fromperid
                        ";
                    connection.Execute(sql, sqlParam);

                    // アフターケア面接文章テーブルの更新
                    sql = @"
                           update aftercare_c
                            set
                                perid = :toperid
                            where
                                perid = :fromperid
                        ";
                    connection.Execute(sql, sqlParam);

                    // アフターケア締め管理テーブルの更新
                    // 請求年度が重複しないものだけをセットする。
                    sql = @"
                           insert
                            into aftercare_close(perid, contactyear, billno)
                            select
                                :toperid perid
                                , aftercare_close.contactyear
                                , aftercare_close.billno
                            from
                                aftercare_close
                            where
                                aftercare_close.perid = :fromperid
                                and aftercare_close.contactyear not in (
                                select
                                    aftercare_close.contactyear
                                from
                                    aftercare_close
                                where
                                    aftercare_close.perid = :toperid
                                )
                        ";
                    connection.Execute(sql, sqlParam);

                    // アフターケア締め管理テーブルの更新
                    sql = @"
                           delete aftercare_close
                            where
                              aftercare_close.perid = :fromperid
                        ";
                    connection.Execute(sql, sqlParam);

                    status = true;

                    if (status)
                    {
                        // トランザクションをコミット
                        transaction.Commit();
                    }
                    else
                    {
                        // エラー発生時はトランザクションをアボートに設定
                        transaction.Rollback();
                    }

                    // 戻り値の設定
                    return true;
                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();

                    throw;
                }
            }
        }

        /// <summary>
        /// 指定個人情報の性別および未来受診情報のチェック
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="gender">性別</param>
        /// <returns>
        /// 1   正常終了
        /// 0   個人情報が存在しない
        /// -1  性別が引数値と異なり、かつ未来受診情報が存在
        /// -2  その他のエラー
        /// </returns>
        private int CheckGenderAndConsult(string perId, int gender)
        {
            string sql = "";  // SQLステートメント
            int curGender;  // 現在の性別
            int ret;  // 関数戻り値

            // キー値の設定
            var sqlParam = new
            {
                perid = perId
            };

            // 現在の性別を取得
            sql = @"
                    select
                        gender
                    from
                        person
                    where
                        perid = :perid for update
                ";
            dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

            while (true)
            {
                // 初期処理
                ret = 1;

                // レコードが存在しない場合は終了
                if (current == null)
                {
                    ret = 0;
                    break;
                }

                // 現在の性別を取得
                curGender = Convert.ToInt32(current.GENDER);

                current = null;

                // 性別に変更がなければチェック不要
                if (gender == curGender)
                {
                    break;
                }

                // システム日付以降において本個人情報の受診情報が存在するかをチェック
                sql = @"
                        select
                            csldate
                        from
                            consult
                        where
                            perid = :perid
                            and csldate >= trunc(sysdate)
                        ";
                current = connection.Query(sql, sqlParam).FirstOrDefault();

                // 存在する場合はエラー
                if (current != null)
                {
                    ret = -1;
                }

                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 個人情報抽出時指定条件の妥当性チェックおよび日付、年齢の編集を行う
        /// </summary>
        /// <param name="data">個人情報
        /// sCase 抽出条件
        /// strYear 受診年(自)
        /// strMonth 受診月(自)
        /// strDay 受診日(自)
        /// endYear 受診年(至)
        /// endMonth 受診月(至)
        /// endDay 受診日(至)
        /// strAgeY 受診時(自)年齢(年)
        /// strAgeM 受診時(自)年齢(月)
        /// endAgeY 受診時(至)年齢(年)
        /// endAgeM 受診時(至)年齢(月)
        /// zipCd1 郵便番号１
        /// </param>
        /// <param name="strDate">(Out)受診年月日(自)</param>
        /// <param name="endDate">(Out)受診年月日(至)</param>
        /// <param name="strAge">(Out)受診時(自)年齢</param>
        /// <param name="endAge">(Out)受診時(至)年齢</param>
        /// <returns>エラー値がある場合、エラーメッセージの配列を返す</returns>
        public List<string> CheckValueDatPerson(JToken data, out DateTime? strDate, out DateTime? endDate, ref string strAge, ref string endAge)
        {
            strDate = null;
            endDate = null;

            var messages = new List<string>();
            const string MSG_NOCONDITION = "抽出条件のいずれかを選択してください。(必須項目)";
            const string MSG_ERRDATE = "受診日の指定に誤りがあります。";
            const string MSG_ERRPERIOD = "期間の指定が誤っています。";
            const string MSG_ERRAGE = "年齢の範囲指定が誤っています。";
            const string MSG_NOZIPCODE = "郵便番号を指定してください。(必須項目)";
            const string STRDATE = "受診年月日(自)";
            const string ENDDATE = "受診年月日(至)";
            const string HTML_BR = "<BR>";

            string message = "";  // エラーメッセージ
            bool errDate;  // 受診年月日エラーステータス
            string errMsg = "";  // 編集用エラーメッセージ
            string subMsg = "";  // エラー補足メッセージ
            string sCase = Convert.ToString(data["sCase"]);  //

            // 各指定値チェック処理
            // 抽出条件チェック
            if (string.IsNullOrEmpty(sCase))
            {
                // エラーメッセージ追加
                messages.Add(MSG_NOCONDITION);
            }

            if (sCase == MODE_CSL)
            {
                // 指定期間の受診者指定時の条件チェック

                // 日付の妥当性チェック
                errDate = false;
                // メッセージ本文
                errMsg = MSG_ERRDATE;
                // 年月日(自)のチェック
                subMsg = WebHains.CheckDate(STRDATE, Convert.ToString(data["strYear"]), Convert.ToString(data["strMonth"]), Convert.ToString(data["strDay"]), out strDate, Check.Necessary);
                if (!string.IsNullOrEmpty(subMsg))
                {
                    // 詳細メッセージの追加
                    errMsg = errMsg + HTML_BR + "(" + subMsg + ")";
                    errDate = true;
                }
                // 年月日(至)のチェック
                subMsg = WebHains.CheckDate(ENDDATE, Convert.ToString(data["endYear"]), Convert.ToString(data["endMonth"]), Convert.ToString(data["endDay"]), out endDate, Check.Necessary);
                if (!string.IsNullOrEmpty(subMsg))
                {
                    // 詳細メッセージの追加
                    errMsg = errMsg + HTML_BR + "(" + subMsg + ")";
                    errDate = true;
                }

                // 受診年月日のチェック
                if (errDate)
                {
                    // 受診年月日のいずれかひとつでもエラーのときエラーメッセージ追加
                    message = errMsg;
                    messages.Add(message);
                }
                else
                {
                    // 指定期間の範囲チェック
                    if (Convert.ToInt32(data["strDate"]) > Convert.ToInt32(data["endDate"]))
                    {
                        // エラーメッセージ追加
                        message = MSG_ERRPERIOD;
                        messages.Add(message);
                    }
                }

                // 受診年齢の編集
                // 受診時年齢(自)
                if (string.IsNullOrEmpty(Convert.ToString(data["strAgeM"])))
                {
                    data["strAgeM"] = "0"; // 年齢(月)未選択時は"0"扱い
                }
                if (!string.IsNullOrEmpty(Convert.ToString(data["strAgeY"])))
                {
                    // 受診時年齢(自)の編集
                    strAge = Convert.ToString(data["strAgeY"]) + "." + (Convert.ToDouble(data["strAgeM"]) < 10 ? "0" : "") + Convert.ToString(data["strAgeM"]);
                }
                else
                {
                    strAge = ""; // 受診時年齢(自)未選択扱い
                }
                // 受診時年齢(至)
                if (string.IsNullOrEmpty(Convert.ToString(data["endAgeM"])))
                {
                    data["endAgeM"] = "0"; // 年齢(月)未選択時は"0"扱い
                }
                if (!string.IsNullOrEmpty(Convert.ToString(data["endAgeY"])))
                {
                    // 受診時年齢(至)の編集
                    endAge = Convert.ToString(data["strEndAgeY"]) + "." + (Convert.ToDouble(data["strEndAgeM"]) < 10 ? "0" : "") + Convert.ToString(data["endAgeM"]);
                }
                else
                {
                    endAge = ""; // 受診時年齢(至)未選択扱い
                }

                // 受診時年齢の範囲チェック
                if (!string.IsNullOrEmpty(strAge) && !string.IsNullOrEmpty(endAge))
                {
                    if (Convert.ToSingle(strAge) > Convert.ToSingle(endAge))
                    {
                        // エラーメッセージ追加
                        message = MSG_ERRAGE;
                        messages.Add(message);
                    }
                }
            }
            else if (sCase == MODE_ZIP)
            {
                // 郵便番号指定時の条件チェック

                // 郵便番号1欄
                if (string.IsNullOrEmpty(Convert.ToString(data["zipCd1"])))
                {
                    // エラーメッセージ追加
                    message = MSG_NOZIPCODE;
                    messages.Add(message);
                }
            }

            // 戻り値の編集
            return messages;
        }

        /// <summary>
        /// 個人テーブル検索用条件節作成
        /// </summary>
        /// <param name="sqlParam">SQLパラメータ</param>
        /// <param name="keyword">検索キーの集合</param>
        /// <param name="birth">生年月日</param>
        /// <param name="gender">性別</param>
        /// <param name="romeNameMultiple">複合検索フラグ</param>
        /// <param name="delFlgUseOnly">True指定時は削除フラグが"0"(使用中)のレコードのみ検索</param>
        /// <returns>個人テーブル検索用の条件節</returns>
        private string CreateConditionForPersonList(Dictionary<string, object> sqlParam, string keyword, DateTime? birth, int gender, bool romeNameMultiple, bool delFlgUseOnly)
        {
            long keyCount = 0;  // 検索キー数

            List<string> condition = new List<string>();  // 条件節の集合
            string buffer = "";  // 文字列バッファ
            List<string> arrKey = new List<string>();

            // 使用中レコードのみ検索する場合は条件を追加
            if (delFlgUseOnly)
            {
                condition.Add("person.delflg = " + DelFlg.Deleted);
            }

            // 検索キー指定時は検索キー集合に追加
            if (!string.IsNullOrEmpty(keyword))
            {
                arrKey.Add(keyword);
                keyCount++;
            }

            // 生年月日指定時は検索キー集合に追加
            if (birth != null)
            {
                arrKey.Add(PREFIX_BIRTH + ((DateTime)birth).ToString("yyyy/MM/dd"));
                keyCount++;
            }

            // 性別指定時は検索キー集合に追加
            if (gender > 0)
            {
                arrKey.Add(PREFIX_GENDER + (gender == Convert.ToInt32(Gender.Male) ? "M" : "F"));
                keyCount++;
            }

            // 検索キー数分の条件節を追加
            for (int i = 0; i < arrKey.Count; i++)
            {
                buffer = arrKey[i];

                // 検索キーのタイプを判別し、条件節に変換して追加
                if (IsWide(buffer))
                {
                    // 全角文字が含まれる(半角カナもここに含まれる)
                    condition.Add(AppendCondition_Wide(sqlParam, buffer, i));
                }
                else if (IsGender(buffer))
                {
                    // 性別
                    condition.Add(AppendCondition_Gender(sqlParam, buffer, i));
                }
                else if (IsPerId(buffer))
                {
                    // 個人ID
                    condition.Add(AppendCondition_PerId(sqlParam, buffer, i));
                }
                else if (true == IsBirth(buffer))
                {
                    // 生年月日
                    condition.Add(AppendCondition_Birth(sqlParam, buffer, i));
                }
                else
                {
                    // 上記以外はローマ字として検索
                    condition.Add(AppendCondition_RomeName(sqlParam, buffer, i, romeNameMultiple));
                }

            }

            if (condition != null && condition.Count > 0)
            {
                return "where " + string.Join(" and ", condition);
            }
            else
            {
                return "";
            }

        }

        /// <summary>
        /// 個人テーブルレコードを削除する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>
        ///  0   正常終了
        ///  -1  アフターケア情報が存在
        ///  -2  受診情報が存在
        ///  -3  傷病休業情報が存在
        ///  -4  個人就労情報が存在
        /// </returns>
        public int DeletePerson(string perId)
        {
            string sql = "";  // SQLステートメント
            int ret = 0;  // 関数戻り値
            using (var transaction = BeginTransaction())
            {
                // エラーハンドラの設定
                try
                {
                    // 検索条件が設定されていない場合は処理を終了する
                    if (string.IsNullOrEmpty(perId.Trim()))
                    {
                        return ret;
                    }

                    // キー値の設定
                    var sqlParam = new
                    {
                        perid = perId.Trim()
                    };

                    // 個人テーブルレコードの削除(削除フラグを立てる)
                    sql = @"
                            delete person
                            where
                              perid = :perid
                        ";

                    connection.Execute(sql, sqlParam);

                    // トランザクションをコミット
                    transaction.Commit();

                    return ret;
                }
                catch (OracleException ex)
                {
                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();

                    while (true)
                    {
                        if (ex.Number == 2292)
                        {
                            if (ex.Message.IndexOf("AFTERCARE", StringComparison.Ordinal) >= 0)
                            {
                                ret = -1;
                                break;
                            }
                            else if (ex.Message.IndexOf("CONSULT", StringComparison.Ordinal) >= 0)
                            {
                                ret = -2;
                                break;
                            }
                            else if (ex.Message.IndexOf("PERDISEASE", StringComparison.Ordinal) >= 0)
                            {
                                ret = -3;
                                break;
                            }
                            else if (ex.Message.IndexOf("PERWORKINFO", StringComparison.Ordinal) >= 0)
                            {
                                ret = -4;
                                break;
                            }
                            else
                            {
                                throw ex;
                            }
                        }

                        throw ex;
                    }

                    return ret;
                }
            }
        }

        /// <summary>
        /// 続柄テーブルレコードを削除する
        /// </summary>
        /// <param name="relationCd"> 続柄コード</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool DeleteRelation(string relationCd)
        {
            string sql = "";  // SQLステートメント

            // キー及び更新値の設定
            var sqlParam = new
            {
                relationcd = relationCd.Trim()
            };

            // 続柄テーブルレコードの削除
            sql = @"
                    delete relation
                    where
                        relationcd = :relationcd
                ";
            connection.Execute(sql, sqlParam);

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// 指定の条件に該当する個人テーブル・個人詳細テーブルを読み込みCSVファイルを編集する
        /// </summary>
        /// <param name="data">
        /// fileName  CSVファイル名(物理パス)
        /// sCase      抽出条件(指定期間の受診者:"csl"、郵便番号:"zip")
        /// strDate   受診年月日(自)
        /// endDate   受診年月日(至)
        /// csCd      コースコード
        /// orgCd1    団体コード1
        /// orgCd2    団体コード2
        /// strAge    受診時(自)年齢
        /// endAge    受診時(至)年齢
        /// gender    性別
        /// zipCd1    郵便番号1
        /// zipCd2    郵便番号2
        /// </param>
        /// <returns>編集したレコード件数</returns>
        public int EditCSVDatPerson(JToken data)
        {
            string sql = "";  // SQLステートメント
            string ret = "";  // 戻り値

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("strdate", Convert.ToDateTime(data["strDate"]));
            param.Add("enddate", Convert.ToDateTime(data["endDate"]));
            param.Add("cscd", Convert.ToString(data["csCd"]));
            param.Add("orgcd1", Convert.ToString(data["orgCd1"]));
            param.Add("orgcd2", Convert.ToString(data["orgCd2"]));
            param.Add("strage", Convert.ToString(data["strAge"]));
            param.Add("endage", Convert.ToString(data["endAge"]));
            param.Add("cancelflg", Convert.ToInt32(ConsultCancel.Used));
            param.Add("gender", Convert.ToInt32(data["gender"]));
            param.Add("zipcd1", Convert.ToString(data["zipCd1"]));
            param.Add("zipcd2", Convert.ToString(data["zipCd2"]));
            param.Add("delflg", Convert.ToInt32(DelFlg.Used));

            // SELECT句の編集
            sql = @"
                    select distinct
                      person.perid 個人ＩＤ
                      , person.vidflg 仮ＩＤフラグ
                      , person.lastname 姓
                      , person.firstname 名
                      , person.lastkname カナ姓
                      , person.firstkname カナ名
                      , person.birth 生年月日
                    ";

            sql += @"
                    ,decode(gender, '1', '男性', '2', '女性', null) 性別
                ";

            sql += @"
                    ,person.orgcd1 所属団体コード１
                    , person.orgcd2 所属団体コード２
                    , person.orgpostcd 所属部署コード
                    , person.supportflg 本人扶養区分
                    , person.isrno 保険者番号
                    , person.spare1 予備１
                    , person.spare2 予備２
                    , person.replicaflg 複製フラグ
                    , person.upddate 更新日時
                    , person.upduser 更新者
                ";

            sql += @"
                    ,persondetail.tel1 電話番号１市外局番
                    , persondetail.tel2 電話番号１局番
                    , persondetail.tel3 電話番号１番号
                    , persondetail.extension 内線１
                    , persondetail.subtel1 電話番号２市外局番
                    , persondetail.subtel2 電話番号２局番
                    , persondetail.subtel3 電話番号２番号
                    , persondetail.fax1 ＦＡＸ市外局番
                    , persondetail.fax2 ＦＡＸ局番
                    , persondetail.fax3 ＦＡＸ番号
                    , persondetail.phone1 携帯市外局番
                    , persondetail.phone2 携帯局番
                    , persondetail.phone3 携帯番号
                    , persondetail.email email
                ";

            sql += @"
                    ,persondetail.zipcd1 郵便番号１
                    , persondetail.zipcd2 郵便番号２
                    , persondetail.prefcd 都道府県コード
                    , persondetail.cityname 市区町村名
                    , persondetail.address1 住所１
                    , persondetail.address2 住所２
                    , persondetail.marriage 婚姻区分
                    , persondetail.isrsign 健保記号記号
                    , persondetail.isrmark 健保記号符号
                    , persondetail.heisrno 健保番号
                    , persondetail.isrdiv 保険区分
                    , persondetail.residentno 住民番号
                    , persondetail.unionno 組合番号
                    , persondetail.karte カルテ番号
                    , persondetail.empno 従業員番号
                    , persondetail.notes 特記事項
                    , persondetail.spare1 予備１
                    , persondetail.spare2 予備２
                    , persondetail.spare3 予備３
                    , persondetail.spare4 予備４
                    , persondetail.spare5 予備５
                ";

            // 抽出条件区分毎のSQL文の編集
            // 指定期間の受診者抽出
            if (Convert.ToString(data["sCase"]).Trim() == MODE_CSL)
            {

                // FROM句の編集
                sql += @"
                        from
                            consult
                            , person
                            , persondetail
                    ";

                // WHERE句の編集

                // 受診日（期間）
                sql += @"
                        where
                            consult.csldate between :strdate and :enddate
                    ";

                // コースコード指定時
                if (!string.IsNullOrEmpty((Convert.ToString(data["csCd"])).Trim()))
                {
                    sql += @"
                            and consult.cscd = :cscd
                        ";
                }

                // 団体コード指定時
                if (!string.IsNullOrEmpty(Convert.ToString(data["orgCd1"]).Trim()) || !string.IsNullOrEmpty(Convert.ToString(data["orgCd2"]).Trim()))
                {
                    sql += @"
                            and consult.orgcd1 = :orgcd1
                            and consult.orgcd2 = :orgcd2
                        ";
                }

                // 受診時年齢（範囲）指定時
                if (!string.IsNullOrEmpty(Convert.ToString(data["strAge"]).Trim()) || !string.IsNullOrEmpty(Convert.ToString(data["endAge"]).Trim()))
                {
                    // 年齢(自)省略時　受診時年齢(至)以下
                    if (string.IsNullOrEmpty(Convert.ToString(data["strAge"]).Trim()))
                    {
                        sql += @"
                                and consult.age <= :endage
                            ";
                        // 年齢(至)省略時　受診時年齢(自)以上
                    }
                    else if (string.IsNullOrEmpty(Convert.ToString(data["endAge"]).Trim()))
                    {
                        sql += @"
                                and consult.age >= :strage
                            ";
                        // 年齢指定時　受診時年齢(自)以上、受診時年齢(至)以下
                    }
                    else
                    {
                        sql += @"
                                and consult.age between :strage and :endage
                            ";
                    }
                }

                // キャンセルフラグ(「使用中」)
                sql += @"
                        and consult.cancelflg = :cancelflg
                    ";

                // 性別指定時
                if (Convert.ToInt32(data["gender"]) == Convert.ToInt32(Gender.Male)
                    || Convert.ToInt32(data["gender"]) == Convert.ToInt32(Gender.Female))
                {
                    sql += @"
                            and person.gender = :gender
                        ";
                }

                sql += @"
                        and person.delflg = :delflg
                        and consult.perid = person.perid
                        and person.perid = persondetail.perid(+)
                        order by
                            person.perid
                    ";

                // 指定郵便番号による抽出
            }
            else if (Convert.ToString(data["sCase"]).Trim() == MODE_ZIP)
            {

                // FROM句の編集
                sql += @"
                        from
                            person
                            , persondetail
                    ";

                // WHERE句の編集
                // 郵便番号1欄(必須)
                sql += @"
                        where
                            persondetail.zipcd1 = :zipcd1
                    ";

                // 郵便番号2欄指定時
                if (!string.IsNullOrEmpty(Convert.ToString(data["zipCd2"]).Trim()))
                {
                    sql += @"
                            and persondetail.zipcd2 = :zipcd2
                        ";
                }

                sql += @"
                        and person.delflg = :delflg
                        and person.perid = persondetail.perid
                        order by
                            person.perid
                    ";
            }

            // 検索条件を満たす個人および個人属性テーブルのレコードを取得
            var dataQuery = connection.Query(sql).ToList();

            // #ToDo CSVを作成する方法をどうするか
            //'ダイナセットからCSVファイルを作成
            //Set objCreateCsv = CreateObject("HainsCreateCsv.CreateCsv")
            //Ret = objCreateCsv.CreateCsvFileFromDynaset(objOraDyna, strFileName)

            // 戻り値の設定
            if (!string.IsNullOrEmpty(ret))
            {
                return 1;
            }

            // #ToDo retが空白の場合の戻り値はどうすればいいのか
            return 0;
        }

        /// <summary>
        /// 発番すべき個人ＩＤ値の取得
        /// </summary>
        /// <param name="vidFlg">仮ＩＤフラグ</param>
        /// <returns>個人ＩＤ</returns>
        private string GetPerId(int vidFlg)
        {
            string sql = "";  // SQLステートメント
            string prefix = "";  // 接頭辞
            string perId = "";  // 個人ＩＤ
            string currentMaxPerId = "";  // 現個人ＩＤの最大値
            string currentMaxPerIdNum = "";  // 現個人ＩＤの最大値における数字部
            bool success = false;  // 処理成功フラグ
            dynamic data = null;

            using (var ts = new TransactionScope())
            {
                while (true)
                {
                    // 個人ＩＤの最大値を取得するSQLステートメントの編集
                    switch (vidFlg)
                    {
                        case 0:
                            // 実ＩＤ発番時

                            // 実ＩＤで先頭１桁目が"1"以上の個人ＩＤを最大順に取得(先頭１桁目が"0"はシステム導入時の移行データであるため、干渉を防ぐ)
                            sql = string.Format(@"
                                    select
                                        /*+ INDEX_DESC(PERSON PERSON_PKEY) */ perid
                                    from
                                        person
                                    where
                                        perid >= '{0}'
                                        and vidflg = 0
                                        and rownum = 1 
                                        for update nowait
                                    ", RID_PREFIX);

                            break;
                        case 1:
                            // 仮ＩＤ発番時
                            sql = string.Format(@"
                                    select
                                        /*+ INDEX_DESC(PERSON PERSON_PKEY) */ perid
                                    from
                                        person
                                    where
                                        perid like '{0}%'
                                        and vidflg = 1
                                        and rownum = 1 
                                        for update nowait
                                    ", VID_PREFIX);

                            break;
                        default:

                            throw new Exception("仮ＩＤフラグの値が無効です。");
                    }

                    // 現仮IDの最大値を取得する(他で処理中の場合は最大10回までリトライ)
                    for (int i = 0; i < 10; i++)
                    {
                        try
                        {
                            success = true;

                            // 現仮IDの最大値を取得する
                            data = connection.Query(sql).FirstOrDefault();

                            if (success)
                            {
                                break;
                            }

                            // ちょっとだけ待つ
                            Thread.Sleep(1000);
                        }
                        catch (Exception ex)
                        {
                            // リソースビジーの場合は成功フラグをリセットして復帰
                            if (ex is OracleException && ((OracleException)ex).Number == 54)
                            {
                                success = false;
                            }
                            else
                            {
                                throw ex;
                            }
                        }
                    }

                    // 10回リトライしてもだめな場合は終了(発生しないとは思うが)
                    if (!success)
                    {
                        // エラー発生時はトランザクションをアボートに設定
                        throw new Exception("現在他業務にて個人情報を使用中のため、個人ＩＤ発番処理は行えませんでした。");
                    }

                    // 接頭辞の編集
                    prefix = (vidFlg == 0 ? RID_PREFIX : VID_PREFIX);

                    // レコードが存在しない場合は初期値を発番
                    if (data == null)
                    {
                        perId = prefix + "".PadRight(Convert.ToInt32(LengthConstants.LENGTH_PERSON_PERID) - prefix.Length, '0');
                        break;
                    }

                    // 先頭レコードの個人ＩＤ（すなわち現在の最大値）を取得
                    currentMaxPerId = Convert.ToString(data.PERID);

                    // (発生しないと思うが)桁数フル使用されていない場合は桁埋め
                    if (currentMaxPerId.Length < Convert.ToInt32(LengthConstants.LENGTH_PERSON_PERID))
                    {
                        currentMaxPerId = (currentMaxPerId + "".PadRight(Convert.ToInt32(LengthConstants.LENGTH_PERSON_PERID),'0')).Substring(0, Convert.ToInt32(LengthConstants.LENGTH_PERSON_PERID));
                    }

                    // 数字部分を取得
                    currentMaxPerIdNum = (vidFlg == 0 ? currentMaxPerId : currentMaxPerId.Substring(currentMaxPerId.Length - (Convert.ToInt32(LengthConstants.LENGTH_PERSON_PERID) - VID_PREFIX.Length)));

                    // (発生しないと思うが)
                    if (currentMaxPerIdNum.Equals(new String('9', (int)LengthConstants.LENGTH_PERSON_PERID - (vidFlg == 0 ? 0 : VID_PREFIX.Length))))
                    {
                        throw new Exception("これ以上個人ＩＤは発番できません。");
                    }

                    // (発生しないと思うが)
                    if (!Util.IsNumber(currentMaxPerIdNum))
                    {
                        throw new Exception("個人ＩＤは発番できません。");
                    }

                    // 数字部分をインクリメントしつつ新仮ＩＤを求める
                    switch (vidFlg)
                    {
                        case 0:
                            perId = (Convert.ToDouble(currentMaxPerIdNum) + 1).ToString().PadLeft(Convert.ToInt32(LengthConstants.LENGTH_PERSON_PERID), '0');
                            break;
                        case 1:
                            perId = VID_PREFIX + (Convert.ToDouble(currentMaxPerIdNum) + 1).ToString().PadLeft(Convert.ToInt32(LengthConstants.LENGTH_PERSON_PERID) - VID_PREFIX.Length, '0');
                            break;
                    }

                    break;
                }

                ts.Complete();

                // 戻り値の設定
                return perId;
            }
        }

        /// <summary>
        /// 個人テーブルにレコードを挿入する
        /// </summary>
        /// <param name="refPerId">個人ID</param>
        /// <param name="data">個人情報</param>
        /// <returns>
        /// 1    正常終了
        /// 0    同一個人ＩＤのレコードが存在
        /// -3   ユーザ情報が存在しない
        /// -4   国籍情報が存在しない
        /// -5   同伴者個人情報が存在しない
        /// </returns>
        public int InsertPerson_lukes(ref string refPerId, Person data)
        {
            string sql = "";    // SQLステートメント
            string perId = "";  // 個人ＩＤ
            int ret = 0;        // 関数戻り値

            using (var ts = new TransactionScope())
            {
                // エラーハンドラの設定
                try
                {
                    // 個人ID未指定時は発番処理を行う
                    if (string.IsNullOrEmpty(refPerId))
                    {
                        perId = GetPerId(Convert.ToInt32(data.VidFlg));
                    }
                    else
                    {
                        perId = refPerId;
                    }

                    // キー及び更新値の設定
                    var param = new Dictionary<string, object>();
                    param.Add("perid", perId);
                    param.Add("vidflg", data.VidFlg);
                    param.Add("delflg", data.DelFlg);
                    param.Add("lastname", Strings.StrConv(data.LastName, VbStrConv.Wide));
                    param.Add("firstname", Strings.StrConv(data.FirstName, VbStrConv.Wide));
                    param.Add("lastkname", Strings.StrConv(data.LastKName, VbStrConv.Wide));
                    param.Add("firstkname", Strings.StrConv(data.FirstKName, VbStrConv.Wide));
                    param.Add("romename", data.RomeName?.ToUpper());
                    param.Add("birth", DateTime.Parse(data.Birth).Date);
                    param.Add("gender", data.Gender);
                    param.Add("upduser", data.UpdUser);
                    param.Add("spare1", data.Spare1);
                    param.Add("spare2", data.Spare2);
                    param.Add("postcardaddr", data.PostCardAddr);
                    param.Add("maidenname", data.MaidenName);
                    param.Add("nationcd", data.NationCd);
                    param.Add("compperid", data.CompPerId);
                    param.Add("cslcount", data.CslCount);

                    param.Add("medrname", data.MedRName);
                    param.Add("medname", data.MedName);
                    param.Add("medbirth", (!string.IsNullOrEmpty(data.MedBirth) ? (DateTime?)DateTime.Parse(data.MedBirth).Date : null));
                    param.Add("medgender", data.MedGender);
                    param.Add("medupddate", (!string.IsNullOrEmpty(data.MedUpdDate) ? (DateTime?)DateTime.Parse(data.MedUpdDate) : null));
                    param.Add("mednationcd", data.MedNationCd);
                    param.Add("medkname", data.MedKName);

                    // 個人テーブルレコードの挿入
                    sql = @"
                            insert
                            into person(
                              perid
                              , vidflg
                              , delflg
                              , lastname
                              , firstname
                              , lastkname
                              , firstkname
                              , romename
                              , birth
                              , gender
                              , upduser
                              , spare1
                              , spare2
                              , postcardaddr
                              , maidenname
                              , nationcd
                              , compperid
                              , cslcount
                              , medrname
                              , medname
                              , medbirth
                              , medgender
                              , medupddate
                              , mednationcd
                              , medkname
                        ";

                    sql += @"
                            )
                            values (
                              :perid
                              , :vidflg
                              , :delflg
                              , :lastname
                              , :firstname
                              , :lastkname
                              , :firstkname
                              , :romename
                              , :birth
                              , :gender
                              , :upduser
                              , :spare1
                              , :spare2
                              , :postcardaddr
                              , :maidenname
                              , :nationcd
                              , :compperid
                              , :cslcount
                              , :medrname
                              , :medname
                              , :medbirth
                              , :medgender
                              , :medupddate
                              , :mednationcd
                              , :medkname
                            )
                        ";

                    connection.Execute(sql, param);

                    // 戻り値の設定
                    refPerId = perId;

                    // トランザクションをコミット
                    ts.Complete();

                    return 1;
                }
                catch (OracleException ex)
                {
                    while (true)
                    {
                        // キー重複時
                        if (ex.Number == 1)
                        {
                            if (ex.Message.IndexOf("PERSON_PKEY", StringComparison.Ordinal) >= 0)
                            {
                                ret = 0;
                            }
                            else
                            {
                                throw ex;
                            }
                        }
                        // 外部キーエラー時
                        else if (ex.Number == 2291)
                        {
                            if (ex.Message.IndexOf("PERSON_FKEY1", StringComparison.Ordinal) >= 0)
                            {
                                ret = -3;
                            }
                            else if (ex.Message.IndexOf("PERSON_FKEY2", StringComparison.Ordinal) >= 0)
                            {
                                ret = -4;
                            }
                            else if (ex.Message.IndexOf("PERSON_FKEY3", StringComparison.Ordinal) >= 0)
                            {
                                ret = -5;
                            }
                            else
                            {
                                throw ex;
                            }
                        }
                        else
                        {
                            throw ex;
                        }

                        return ret;
                    }
                }
            }
        }

        /// <summary>
        /// 検索キーが生年月日指定かをチェック
        /// </summary>
        /// <param name="buffer">検索キー</param>
        /// <returns>
        /// true   OK
        /// false  NG
        /// </returns>
        public bool IsBirth(string buffer)
        {
            string birth = "";  // 生年月日
            bool ret;  // 関数戻り値
            DateTime dateTime = new DateTime(); // 日付

            ret = false;

            // 先頭６文字が"BIRTH:"である場合は先頭部を取り除いた部分を生年月日として取得、それ以外は引数値をそのまま使用
            if (6 > buffer.Length)
            {
                return false;
            }
            else if (buffer.Substring(0, PREFIX_BIRTH.Length).ToUpper() == PREFIX_BIRTH)
            {
                birth = buffer.Substring(PREFIX_BIRTH.Length);
            }
            else
            {
                birth = buffer;
            }

            while (true)
            {
                // すでに日付認識可能ならチェック終了
                if (DateTime.TryParse(birth, out dateTime))
                {
                    ret = true;
                    break;
                }

                // 8桁でなければ何もしない
                if (birth.Length != 8)
                {
                    break;
                }

                // 半角数字チェック
                if (!int.TryParse(birth, out int wkBirth)) {
                    break;
                }

                // 以上条件を満たせば日付チェックを行い、正常なら生年月日とみなす
                ret = DateTime.TryParse(string.Format("{0:0000/00/00}", wkBirth), out DateTime wkDate);

                break;
            }
            return ret;
        }

        /// <summary>
        /// 検索キーが従業員番号指定かをチェック
        /// </summary>
        /// <param name="buffer">検索キー</param>
        /// <returns>
        /// true  分割後の要素が３個
        /// false ３個以外
        /// </returns>
        public bool IsEmpNo(string buffer)
        {
            string[] token;  // トークン

            // ハイフンで分割
            token = buffer.Split('-');

            // 分割後の要素が３個であれば従業員番号指定とみなす
            if (token.Count() == 3)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// 個人情報と医事個人情報との一致チェック
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>
        /// true   一致する
        /// false  一致しない
        /// </returns>
        private bool IsEqualToMed(string perId)
        {
            string sql = "";  // SQLステートメント

            // エラーハンドラの設定
            try
            {
                // 個人情報用ストアドパッケージの関数呼び出し
                sql = @"
                        begin :ret := personpackage.isequaltomed(:perid);
                        end;
                    ";

                using (var cmd = new OracleCommand())
                {
                    // キーおよび戻り値の設定
                    // Inputは名前と値のみ
                    cmd.Parameters.Add("perid", perId);

                    // Outputパラメータ
                    OracleParameter ret = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                    // PL/SQL文の実行
                    ExecuteNonQuery(cmd, sql);

                    // 戻り値の設定
                    if (((OracleDecimal)ret.Value).ToInt32() == 1)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// 検索キーが性別指定かをチェック
        /// </summary>
        /// <param name="buffer">検索キー</param>
        /// <returns>
        /// true   性別指定
        /// false  性別指定しない
        /// </returns>
        public bool IsGender(string buffer)
        {
            string gender = "";  // 性別

            // 先頭６文字が"GENDER:"である場合は先頭部を取り除いた部分を生年月日として取得、それ以外は引数値をそのまま使用
            if (7 > buffer.Length)
            {
                return false;

            }
            else if (buffer.Substring(0, PREFIX_GENDER.Length).ToUpper() == PREFIX_GENDER)
            {
                gender = buffer.Substring(PREFIX_GENDER.Length);
            }
            else
            {
                gender = buffer;
            }

            // 取得した値をチェック
            if (gender.ToUpper() == "M" || gender.ToUpper() == "F")
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// 検索キーが健保記号番号指定かをチェック
        /// </summary>
        /// <param name="buffer">検索キー</param>
        /// <returns>
        /// true  分割後の要素が２個
        /// false ２個以外
        /// </returns>
        public bool IsInsured(string buffer)
        {
            string[] token;  // トークン

            // ハイフンで分割
            token = buffer.Split('-');

            // 分割後の要素が２個であれば健保記号番号指定とみなす
            if (token.Count() == 2)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// 検索キーが個人ＩＤ指定かをチェック
        /// </summary>
        /// <param name="buffer">検索キー</param>
        /// <returns>
        /// true   OK
        /// false  NG
        /// </returns>
        public bool IsPerId(string buffer)
        {
            string buffer2 = "";  // 文字列バッファ
            bool ret;  // 関数戻り値

            ret = true;

            while (true)
            {
                // 先頭３文字が"ID:"であれば個人ID指定とみなす
                if (3 > buffer.Length)
                {
                    return false;
                }
                if (buffer.Substring(0, PREFIX_PERID.Length).ToUpper() == PREFIX_PERID)
                {
                    break;
                }

                // 数字チェックを行う部分文字列の取得

                // 先頭が＠の場合
                if (buffer.Substring(0, 1) == VID_PREFIX)
                {
                    buffer2 = buffer.Substring(1);
                }
                else
                {
                    buffer2 = buffer;
                }

                // 最後尾が"*"の場合
                if (buffer2.Substring(buffer2.Length - 1) == "*")
                {
                    buffer2 = buffer2.Substring(0, buffer2.Length - 1);
                }

                // 部分文字列＝最初の文字列の場合、10桁(HOPEでの桁数)以外の場合は個人IDとみなさない
                if (buffer2 == buffer && buffer.Length != LENGTH_HOPE_PERID)
                {
                    ret = false;
                }

                // すべての文字列が数字であるかをチェック
                if (!string.IsNullOrEmpty(buffer2))
                {
                    for (int i = 0; i < buffer2.Length; i++)
                    {
                        if ("0123456789".IndexOf(buffer2.Substring(i, 1)) < 0)
                        {
                            ret = false;
                            break;
                        }
                    }
                }
                break;
            }

            return ret;
        }

        /// <summary>
        /// 指定個人が仮IDであるかを判定
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>
        /// True   仮IDである
        /// False  仮IDでない、あるいはレコードが存在しない
        /// </returns>
        public bool IsVirtualId(string perId)
        {
            string sql = "";  // SQLステートメント

            int vidFlg;  // 仮IDフラグ

            // キー及び更新値の設定
            var sqlParam = new
            {
                perid = perId
            };

            // 検索条件を満たす個人テーブルのレコードを取得
            sql = @"
                    select
                      vidflg
                    from
                      person
                    where
                      perid = :perid
                    ";

            dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

            // レコードが存在する場合
            if (current != null)
            {
                // オブジェクトの参照設定
                vidFlg = Convert.ToInt32(current.VIDFLG);

                // 戻り値の設定
                if (vidFlg == 1)
                {
                    return true;
                }
            }

            return false;
        }

        /// <summary>
        /// 検索キーに全角文字が含まれるかをチェック
        /// </summary>
        /// <param name="buffer">検索キー</param>
        /// <returns>
        /// true   全角文字が含まれる
        /// false  半角文字のみ
        /// </returns>
        public bool IsWide(string buffer)
        {

            // 検索キーが半角文字のみかチェックし、その結果で戻り値を決定する
            return !(String.IsNullOrEmpty(buffer) || !(new Regex("[^\x01-\x7E\uFF65-\uFF9F]").IsMatch(buffer)));
        }

        /// <summary>
        /// 続柄テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="relationCd">続柄コード</param>
        /// <param name="relationName">続柄名</param>
        /// <returns>
        /// Insert.Normal    正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error     異常終了
        /// </returns>
        public Insert RegistRelation(string mode, string relationCd, string relationName)
        {
            string sql = "";  // SQLステートメント

            Insert ret;  // 関数戻り値
            int ret2;

            using (var transaction = BeginTransaction())
            {
                // エラーハンドラの設定
                try
                {
                    ret = Insert.Error;

                    // キー及び更新値の設定
                    var sqlParam = new
                    {
                        relationcd = relationCd.Trim(),
                        relationname = relationName.Trim()

                    };

                    while (true)
                    {
                        // 続柄テーブルレコードの更新
                        if (mode == "UPD")
                        {
                            sql = @"
                                    update relation
                                    set
                                      relationname = :relationname
                                    where
                                      relationcd = :relationcd
                                ";
                            ret2 = connection.Execute(sql);
                            if (ret2 > 0)
                            {
                                ret = Insert.Normal;
                                break;
                            }
                        }

                        // 検索条件を満たす続柄テーブルのレコードを取得
                        sql = @"
                                select
                                  relationcd
                                from
                                  relation
                                where
                                  relationcd = :relationcd
                            ";
                        dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

                        if (current != null)
                        {
                            ret = Insert.Duplicate;
                            break;
                        }

                        // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                        sql = @"
                                insert
                                into relation(relationcd, relationname)
                                values (:relationcd, :relationname)
                            ";

                        connection.Execute(sql, sqlParam);

                        ret = Insert.Normal;
                        break;
                    }

                    // これはRootトランザクションなのでCommit
                    transaction.Commit();

                    // 戻り値の設定
                    return ret;

                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();

                    // その他の戻り値設定
                    return Insert.Error;
                }
            }
        }

        /// <summary>
        /// カナ文字列置換
        /// </summary>
        /// <param name="stream">カナ名</param>
        /// <returns>置換後の文字</returns>
        private string ReplaceKanaString(string stream)
        {
            string buffer = "";  // 文字列バッファ

            buffer = stream;
            buffer = buffer.Replace("ァ", "ア");
            buffer = buffer.Replace("ィ", "イ");
            buffer = buffer.Replace("ゥ", "ウ");
            buffer = buffer.Replace("ェ", "エ");
            buffer = buffer.Replace("ォ", "オ");
            buffer = buffer.Replace("ッ", "ツ");
            buffer = buffer.Replace("ャ", "ヤ");
            buffer = buffer.Replace("ュ", "ユ");
            buffer = buffer.Replace("ョ", "ヨ");
            return buffer;
        }

        /// <summary>
        /// 指定個人ＩＤの個人情報を取得する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>個人情報
        /// lastname         姓
        /// firstname        名
        /// lastkname        カナ姓
        /// firstkname       カナ名
        /// birth            生年月日
        /// gender           性別
        /// orgcd1           所属団体コード１
        /// orgcd2           所属団体コード２
        /// orgkname         団体カナ名称
        /// orgname          団体漢字名称
        /// orgsname         団体略称
        /// orgbsdcd         事業部コード
        /// orgbsdkname      事業部カナ名称
        /// orgbsdname       事業部名称
        /// orgroomcd        室部コード
        /// orgroomname      室部名称
        /// orgroomkname     室部カナ名称
        /// orgpostcd        所属部署コード
        /// orgpostname      所属名称
        /// orgpostkname     所属カナ名称
        /// jobcd            職名コード
        /// jobname          職名
        /// dutycd           職責コード
        /// dutyname         職責
        /// qualifycd        資格コード
        /// qualifyname      資格
        /// empno            従業員番号
        /// isrsign          健保記号
        /// isrno            健保番号
        /// relationcd       続柄コード
        /// relationname     続柄
        /// branchno         枝番
        /// transferdiv      出向区分
        /// primperid        親個人ＩＤ
        /// lostdate         資格喪失日
        /// hiredate         入社年月日
        /// empdiv           従業員区分
        /// hongendiv        本現区分
        /// workmeasurediv   就業措置区分
        /// workmeasurename  就業措置区分名
        /// overtimediv      超過勤務区分
        /// nightdutyflg     夜勤者健診対象
        /// vidflg           仮ＩＤフラグ
        /// supportflg       本人扶養区分
        /// replicaflg       複製フラグ
        /// upddate          更新日時
        /// upduser          更新者
        /// username         更新者漢字氏名
        /// spare1           予備１
        /// spare2           予備２
        /// </returns>
        public dynamic SelectPerson(string perId)
        {
            string sql = "";  // SQLステートメント

            // キー値の設定
            var sqlParam = new
            {
                perid = perId.Trim()
            };

            // 検索条件を満たす個人属性テーブルのレコードを取得
            sql = @"
                    select
                      person.perid
                      , person.vidflg
                      , person.delflg
                      , person.replicaflg
                      , person.upddate
                      , person.upduser
                      , person.lastname
                      , person.firstname
                      , person.lastkname
                      , person.firstkname
                      , person.birth
                      , person.gender
                      , person.orgcd1
                      , person.orgcd2
                      , person.orgpostcd
                      , person.isrno
                      , person.spare1
                      , person.spare2
                      , person.transferdiv
                      , person.orgbsdcd
                      , person.orgroomcd
                      , person.jobcd
                      , person.dutycd
                      , person.qualifycd
                      , person.isrsign
                      , person.relationcd
                      , person.branchno
                      , person.empno
                      , person.primperid
                      , person.empdiv
                      , person.hongendiv
                      , person.workmeasurediv
                      , person.overtimediv
                      , person.nightdutyflg
                      , person.lostdate
                      , person.hiredate
                      , hainsuser.username
                      , org.orgkname
                      , org.orgname
                      , org.orgsname
                      , orgbsd.orgbsdkname
                      , orgbsd.orgbsdname
                      , orgroom.orgroomname
                      , orgroom.orgroomkname
                      , orgpost.orgpostname
                      , orgpost.orgpostkname
                      , relation.relationname
                      , job.jobname
                      , duty.dutyname
                      , qualify.qualifyname
                      , workmeasure.workmeasurename
                ";

            sql += @"
                    from
                      (
                        select
                          freecd jobcd
                          , freefield1 jobname
                        from
                          free
                      ) job
                      , (
                        select
                          freecd dutycd
                          , freefield1 dutyname
                        from
                          free
                      ) duty
                      , (
                        select
                          freecd qualifycd
                          , freefield1 qualifyname
                        from
                          free
                      ) qualify
                      , (
                        select
                          freecd workmeasurediv
                          , freefield1 workmeasurename
                        from
                          free
                      ) workmeasure
                      , relation
                      , org
                      , orgbsd
                      , orgroom
                      , orgpost
                      , hainsuser
                      , person
                ";

            sql += @"
                    where
                      person.perid = :perid
                      and person.upduser = hainsuser.userid(+)
                      and person.orgcd1 = org.orgcd1(+)
                      and person.orgcd2 = org.orgcd2(+)
                      and person.orgcd1 = orgbsd.orgcd1(+)
                      and person.orgcd2 = orgbsd.orgcd2(+)
                      and person.orgbsdcd = orgbsd.orgbsdcd(+)
                      and person.orgcd1 = orgroom.orgcd1(+)
                      and person.orgcd2 = orgroom.orgcd2(+)
                      and person.orgbsdcd = orgroom.orgbsdcd(+)
                      and person.orgroomcd = orgroom.orgroomcd(+)
                      and person.orgcd1 = orgpost.orgcd1(+)
                      and person.orgcd2 = orgpost.orgcd2(+)
                      and person.orgbsdcd = orgpost.orgbsdcd(+)
                      and person.orgroomcd = orgpost.orgroomcd(+)
                      and person.orgpostcd = orgpost.orgpostcd(+)
                      and person.relationcd = relation.relationcd(+)
                      and person.jobcd = job.jobcd(+)
                      and person.dutycd = duty.dutycd(+)
                      and person.qualifycd = qualify.qualifycd(+)
                      and person.workmeasurediv = workmeasure.workmeasurediv(+)
                ";

            // 戻り値の設定
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 指定個人ＩＤの個人情報を取得する ## 聖路加バージョン ##
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>個人情報 ## 聖路加バージョン ##
        /// lastname       姓
        /// firstname      名
        /// lastkname      カナ姓
        /// firstkname     カナ名
        /// romename       ローマ字名
        /// birth          生年月日
        /// gender         性別
        /// postcardaddr   １年目はがき宛先
        /// maidenname     旧姓
        /// nationcd       国籍コード
        /// compperid      同伴者ＩＤ
        /// complastname   同伴者姓
        /// compfirstname  同伴者名
        /// vidflg         仮ＩＤフラグ
        /// delflg         削除フラグ
        /// upddate        更新日時
        /// upduser        更新者
        /// username       更新者漢字氏名
        /// spare1         予備１
        /// spare2         予備２
        /// medrname       医事連携ローマ字名
        /// medname        医事連携漢字氏名
        /// medbirth       医事連携生年月日
        /// medgender      医事連携性別
        /// medupddate     医事連携更新日時
        /// cslcount       受診回数
        /// </returns>
        public dynamic SelectPerson_lukes(string perId)
        {
            string sql = "";  // SQLステートメント

            // キー値の設定
            var sqlParam = new
            {
                perid = perId.Trim()
            };

            // 検索条件を満たす個人属性テーブルのレコードを取得
            sql = @"
                    select
                      person.perid
                      , person.vidflg
                      , person.delflg
                      , person.upddate
                      , person.upduser
                      , person.lastname
                      , person.firstname
                      , person.lastkname
                      , person.firstkname
                      , person.birth
                      , person.romename
                      , person.gender
                      , person.postcardaddr
                      , person.maidenname
                      , person.nationcd
                      , person.compperid
                      , person.cslcount
                      , person.spare1
                      , person.spare2
                      , person.medrname
                      , person.medname
                      , person.medkname
                      , person.medbirth
                      , person.medgender
                      , person.medupddate
                      , compperson.lastname complastname
                      , compperson.firstname compfirstname
                      , hainsuser.username
                    from
                      hainsuser
                      , person compperson
                      , person
                    where
                      person.perid = :perid
                      and person.compperid = compperson.perid(+)
                      and person.upduser = hainsuser.userid(+)
                ";

            // SQL実行
            dynamic data = connection.Query(sql, sqlParam).FirstOrDefault();

            if (data != null)
            {
                if (data.MEDBIRTH != null)
                {
                    // 生年月日
                    DateTime wkMedbirth = DateTime.Parse(Convert.ToString(data.MEDBIRTH));
                    // 和暦年を取得
                    data.medbirtherayear = (object)WebHains.JapaneseCalendar.GetYear(wkMedbirth);
                    // 和暦元号(英字表記)を取得
                    data.medbirthyearshorteraname = WebHains.GetShortEraName(wkMedbirth);
                }
            }

            // 戻り値の設定
            return data;
        }

        /// <summary>
        /// 指定個人ＩＤの受診情報を取得する ## 聖路加バージョン ##
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>受診情報## 聖路加バージョン ##
        /// rsvno          最後受診予約番号
        /// percmt         個人・受診コメント有無
        /// </returns>
        public dynamic SelectPerson_note(string perId)
        {
            string sql = "";  // SQLステートメント

            // キー値の設定
            var sqlParam = new
            {
                perid = perId.Trim()
            };

            sql = @"
                    select
                      max(rsvno) rsvno
                      , decode(sum(perpub), 0, 0, 1) + decode(sum(cslpub), 0, 0, 1) percmt
                    from
                      (
                        select
                          cntall.perid perid
                          , cntall.rsvno rsvno
                          , cntall.csldate csldate
                          , (
                            select
                              count(perpubnote.pubnote)
                            from
                              perpubnote
                            where
                              cntall.perid = perpubnote.perid
                              and perpubnote.delflg is null
                          ) perpub
                          , (
                            select
                              count(cslpubnote.pubnote)
                            from
                              cslpubnote
                            where
                              cntall.rsvno = cslpubnote.rsvno
                              and cslpubnote.delflg is null
                          ) cslpub
                ";

            sql += @"
                    from
                      (
                        select
                          perid
                          , rsvno
                          , csldate
                        from
                          consult
                        where
                          consult.perid = :perid
                          and consult.cancelflg = 0
                      ) cntall) resum
                ";

            // 戻り値の設定
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 個人ＩＤをキーに個人テーブルを読み込む
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="birthYear">(Out)生年月日（年）</param>
        /// <param name="birthMonth">(Out)生年月日（月）</param>
        /// <param name="birthDay">(Out)生年月日（日）</param>
        /// <returns>個人テーブル
        /// vidflg             仮IDフラグ
        /// lastname           姓
        /// firstname          名
        /// lastkname          カナ姓
        /// firstkname         カナ名
        /// birth              生年月日
        /// gender             性別
        /// supportflg         本人扶養区分
        /// spare1             予備１
        /// spare2             予備２
        /// upddate            更新日付
        /// upduser            更新者
        /// orgcd1             所属団体コード１
        /// orgcd2             所属団体コード２
        /// orgpostcd          所属部署コード
        /// tel1               電話番号１-市外局番
        /// tel2               電話番号１-局番
        /// tel3               電話番号１-番号
        /// extension          内線
        /// subtel1            電話番号２-市外局番
        /// subtel2            電話番号２-局番
        /// subtel3            電話番号２-番号
        /// fax1               ＦＡＸ番号-市外局番
        /// fax2               ＦＡＸ番号-局番
        /// fax3               ＦＡＸ番号-番号
        /// phone1             携帯-市外局番
        /// phone2             携帯-局番
        /// phone3             携帯-番号
        /// email              e-Mail
        /// zipcd1             郵便番号１
        /// zipcd2             郵便番号２
        /// prefcd             都道府県コード
        /// cityname           市区町村名
        /// address1           住所１
        /// address2           住所２
        /// marriage           婚姻区分
        /// isrno              保険者番号
        /// isrsign            健保記号（記号）
        /// isrmark            健保記号（符号）
        /// heisrno            健保番号
        /// isrdiv             保険区分
        /// residentno         住民番号
        /// unionno            組合番号
        /// karte              カルテ番号
        /// empno              従業員番号
        /// notes              特記事項
        /// spare3             予備１（個人属性）
        /// spare4             予備２（個人属性）
        /// spare5             予備３（個人属性）
        /// spare6             予備４（個人属性）
        /// spare7             予備５（個人属性）
        /// gendername         性別（名称）
        /// prefname           都道府県名
        /// </returns>
        public dynamic SelectPerson_old(string perId, ref string birthYear, ref string birthMonth, ref string birthDay)
        {
            string sql = "";  // SQLステートメント
            DateTime birth = new DateTime(); // 日付

            if (perId == null || string.IsNullOrEmpty(perId.Trim()))
            {
                return null;
            }

            // キー及び更新値の設定
            var sqlParam = new
            {
                perid = perId.Trim(),
                delflg = DelFlg.Used
            };

            // 検索条件を満たす個人テーブルのレコードを取得
            sql = @"
                    select
                      p.vidflg
                      , p.lastname
                      , p.firstname
                      , p.lastkname
                      , p.firstkname
                      , p.birth
                      , p.gender
                      , p.supportflg
                      , p.spare1
                      , p.spare2
                      , p.upddate
                      , p.upduser
                      , p.orgcd1
                      , p.orgcd2
                      , p.orgpostcd
                      , pd.tel1
                      , pd.tel2
                      , pd.tel3
                      , pd.extension
                      , pd.subtel1
                      , pd.subtel2
                      , pd.subtel3
                      , pd.fax1
                      , pd.fax2
                      , pd.fax3
                      , pd.phone1
                      , pd.phone2
                      , pd.phone3
                      , pd.email
                      , pd.zipcd1
                      , pd.zipcd2
                      , pd.prefcd
                      , pd.cityname
                      , pd.address1
                      , pd.address2
                      , pd.marriage
                      , p.isrno
                      , pd.isrsign
                      , pd.isrmark
                      , pd.heisrno
                      , pd.isrdiv
                      , pd.residentno
                      , pd.unionno
                      , pd.karte
                      , pd.empno
                      , pd.notes
                      , pd.spare1 d_spare1
                      , pd.spare2 d_spare2
                      , pd.spare3 d_spare3
                      , pd.spare4 d_spare4
                      , pd.spare5 d_spare5
                      , decode(gender, '1', '男性', '2', '女性', null) gendername
                      , pf.prefname
                    from
                      person p
                      , persondetail pd
                      , pref pf
                ";

            sql += @"
                    where
                      p.perid = :perid
                      and p.delflg = :delflg
                      and p.perid = pd.perid(+)
                      and pd.prefcd = pf.prefcd(+)
                ";

            dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

            if (DateTime.TryParse(current.BIRTH, out birth))
            {
                birthYear = birth.Year.ToString();
                birthMonth = birth.Month.ToString();
                birthDay = birth.Day.ToString();
            }

            return current;
        }

        /// <summary>
        /// 指定個人ＩＤの個人属性情報を取得する　## 聖路加バージョン ##
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>個人属性情報## 聖路加バージョン ##
        /// marriage    婚姻区分
        /// residentno  住民番号
        /// unionno     組合番号
        /// karte       カルテ番号
        /// notes       特記事項
        /// spare1      予備１
        /// spare2      予備２
        /// spare3      予備３
        /// spare4      予備４
        /// spare5      予備５
        /// </returns>
        public dynamic SelectPersonDetail_lukes(string perId)
        {
            string sql = "";  // SQLステートメント

            // キー値の設定
            var sqlParam = new
            {
                perid = perId.Trim()
            };

            // 検索条件を満たす個人属性テーブルのレコードを取得
            sql = @"
                    select
                      persondetail.marriage
                      , persondetail.residentno
                      , persondetail.unionno
                      , persondetail.karte
                      , persondetail.notes
                      , persondetail.spare1
                      , persondetail.spare2
                      , persondetail.spare3
                      , persondetail.spare4
                      , persondetail.spare5
                      , pref.prefname
                    from
                      pref
                      , persondetail
                    where
                      persondetail.perid = :perid
                ";

            // 戻り値の設定
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 指定個人ＩＤの個人属性情報を取得する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>個人属性情報
        /// zipcd1      郵便番号１
        /// zipcd2      郵便番号２
        /// prefcd      都道府県コード
        /// prefname    都道府県名
        /// cityname    市区町村名
        /// address1    住所１
        /// address2    住所２
        /// tel1        電話番号１－市外局番
        /// tel2        電話番号１－局番
        /// tel3        電話番号１－番号
        /// extension   内線１
        /// subtel1     電話番号２－市外局番
        /// subtel2     電話番号２－局番
        /// subtel3     電話番号２－番号
        /// fax1        ＦＡＸ－市外局番
        /// fax2        ＦＡＸ－局番
        /// fax3        ＦＡＸ－番号
        /// phone1      携帯－市外局番
        /// phone2      携帯－局番
        /// phone3      携帯－番号
        /// email       e-Mail
        /// marriage    婚姻区分
        /// isrdiv      保険区分
        /// residentno  住民番号
        /// unionno     組合番号
        /// karte       カルテ番号
        /// notes       特記事項
        /// spare1      予備１
        /// spare2      予備２
        /// spare3      予備３
        /// spare4      予備４
        /// spare5      予備５
        /// </returns>
        public dynamic SelectPersonDetail(string perId)
        {
            string sql = "";  // SQLステートメント

            // キー値の設定
            var sqlParam = new
            {
                perid = perId.Trim()
            };

            // 検索条件を満たす個人属性テーブルのレコードを取得
            sql = @"
                    select
                      persondetail.tel1
                      , persondetail.tel2
                      , persondetail.tel3
                      , persondetail.extension
                      , persondetail.subtel1
                      , persondetail.subtel2
                      , persondetail.subtel3
                      , persondetail.fax1
                      , persondetail.fax2
                      , persondetail.fax3
                      , persondetail.phone1
                      , persondetail.phone2
                      , persondetail.phone3
                      , persondetail.email
                      , persondetail.zipcd1
                      , persondetail.zipcd2
                      , persondetail.prefcd
                      , persondetail.cityname
                      , persondetail.address1
                      , persondetail.address2
                      , persondetail.marriage
                      , persondetail.isrdiv
                      , persondetail.residentno
                      , persondetail.unionno
                      , persondetail.karte
                      , persondetail.notes
                      , persondetail.spare1
                      , persondetail.spare2
                      , persondetail.spare3
                      , persondetail.spare4
                      , persondetail.spare5
                      , pref.prefname
                    from
                      pref
                      , persondetail
                    where
                      persondetail.perid = :perid
                      and persondetail.prefcd = pref.prefcd(+)
                ";

            // 戻り値の設定
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 指定個人ＩＤの個人住所情報を取得する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>個人住所情報
        /// addrdiv     住所区分
        /// zipcd       郵便番号
        /// prefcd      都道府県コード
        /// prefname    都道府県名
        /// cityname    市区町村名
        /// address1    住所１
        /// address2    住所２
        /// tel1        電話番号１
        /// phone       携帯
        /// tel2        電話番号２
        /// extension   内線１
        /// fax         ＦＡＸ
        /// email       e-Mail
        /// </returns>
        public List<dynamic> SelectPersonAddr(string perId)
        {
            string sql = "";  // SQLステートメント

            // キー値の設定
            var sqlParam = new
            {
                perid = perId.Trim()
            };

            // 検索条件を満たす個人住所情報テーブルのレコードを取得
            sql = @"
                    select
                      peraddr.addrdiv
                      , peraddr.zipcd
                      , peraddr.prefcd
                      , peraddr.cityname
                      , peraddr.address1
                      , peraddr.address2
                      , peraddr.tel1
                      , peraddr.phone
                      , peraddr.tel2
                      , peraddr.extension
                      , peraddr.fax
                      , peraddr.email
                      , pref.prefname
                    from
                      pref
                      , peraddr
                    where
                      peraddr.perid = :perid
                      and peraddr.prefcd = pref.prefcd(+)
                ";

            // 戻り値の設定
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 指定団体・従業員番号の個人情報を取得する
        /// </summary>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="empNo">従業員番号</param>
        /// <returns>個人情報
        /// perid       個人ＩＤ
        /// lastname    姓
        /// firstname   名
        /// lastkname   カナ姓
        /// firstkname  カナ名
        /// birth       生年月日
        /// gender      性別
        /// </returns>
        public dynamic SelectPersonFromOrg(string orgCd1, string orgCd2, string empNo)
        {
            string sql = "";  // SQLステートメント

            // キー値の設定
            var sqlParam = new
            {
                orgcd1 = orgCd1,
                orgcd2 = orgCd2,
                empno = empNo
            };

            // 検索条件を満たす個人属性テーブルのレコードを取得
            sql = @"
                    select
                      perid
                      , lastname
                      , firstname
                      , lastkname
                      , firstkname
                      , birth
                      , gender
                    from
                      person
                    where
                      orgcd1 = :orgcd1
                      and orgcd2 = :orgcd2
                      and empno = :empno
                ";

            // 戻り値の設定
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 個人ＩＤをキーに個人テーブルを読み込む
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>個人テーブル
        /// lastname    姓
        /// firstname   名
        /// lastkname   カナ姓
        /// firstkname  カナ名
        /// birth       生年月日
        /// gender      性別
        /// gendername  性別名称
        /// age         年齢
        /// </returns>
        public dynamic SelectPersonInf(string perId)
        {
            string sql = "";  // SQLステートメント

            // キー値の設定
            var sqlParam = new
            {
                perid = perId.Trim()
            };

            // 検索条件を満たす個人テーブルのレコードを取得
            sql = @"
                    select
                      lastname
                      , firstname
                      , lastkname
                      , firstkname
                      , birth
                      , getcslage(birth) age
                      , gender
                      , decode(gender, '1', '男性', '2', '女性') gendername
                    from
                      person
                    where
                      perid = :perid
                ";

            dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();


            DateTime wkBirth = DateTime.Parse(Convert.ToString(current.BIRTH));

            // 和暦年を取得
            current.birtherayear = (object)WebHains.JapaneseCalendar.GetYear(wkBirth);
            // 和暦元号(英字表記)を取得
            current.birthyearshorteraname = WebHains.GetShortEraName(wkBirth);

            // 戻り値の設定
            return current;
        }

        /// <summary>
        /// 検索条件を満たす個人の一覧を取得する
        /// </summary>
        /// <param name="keyword">検索キーの集合</param>
        /// <param name="addrDiv">住所区分</param>
        /// <param name="startPos">開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <param name="birth">生年月日</param>
        /// <param name="gender">性別</param>
        /// <param name="romeNameMultiple">複合検索フラグ</param>
        /// <param name="delFlgUseOnly">True指定時は削除フラグが"0"(使用中)のレコードのみ検索</param>
        /// <returns>個人の一覧
        /// perid          個人ＩＤ
        /// delflg         削除フラグ
        /// lastname       姓
        /// firstname      名
        /// lastkname      カナ姓
        /// firstkname     カナ名
        /// romename       ローマ字名
        /// birth          生年月日
        /// age            年齢
        /// gender         性別
        /// zipcd          郵便番号
        /// prefname       都道府県名
        /// cityname       市区町村名
        /// address1       住所１
        /// address2       住所２
        /// tel1           電話番号１
        /// </returns>
        public List<dynamic> SelectPersonList(string keyword, int addrDiv, int startPos, int getCount, DateTime? birth = null, int gender = 0, bool romeNameMultiple = false, bool delFlgUseOnly = false)
        {
            string sql = "";  // SQLステートメント

            // 検索条件が設定されていない場合は処理を終了する
            if (string.IsNullOrEmpty(keyword) && (birth == null) && (gender == 0))
            {
                return null;
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("startpos", startPos);
            sqlParam.Add("endpos", (startPos + getCount - 1));
            sqlParam.Add("addrdiv", addrDiv);

            sql = @"
                    select
                      basedperson.perid
                      , basedperson.delflg
                      , basedperson.lastname
                      , basedperson.firstname
                      , basedperson.lastkname
                      , basedperson.firstkname
                      , basedperson.romename
                      , basedperson.birth
                      , basedperson.gender
                      , getcslage(basedperson.birth) age
                ";

            sql += @"
                    ,peraddr.zipcd
                    , peraddr.cityname
                    , peraddr.address1
                    , peraddr.address2
                    , peraddr.tel1
                    , pref.prefname
                ";

            sql += @"
                    from
                      pref
                      , peraddr
                      , (
                        select
                          rownum seq
                          , perid
                          , delflg
                          , lastname
                          , firstname
                          , lastkname
                          , firstkname
                          , romename
                          , birth
                          , gender
                ";

            sql += @"
                        from
                          (
                            select
                              perid
                              , delflg
                              , lastname
                              , firstname
                              , lastkname
                              , firstkname
                              , romename
                              , birth
                              , gender
                            from
                              person
                ";

            // ローマ字検索機能
            sql += CreateConditionForPersonList(sqlParam, keyword, birth, gender, romeNameMultiple, delFlgUseOnly);

            sql += @"
                    order by
                      romename
                      , birth
                      , lastname
                      , firstname
                      , perid)) basedperson
                    where
                      basedperson.seq between :startpos and :endpos
                      and basedperson.perid = peraddr.perid(+)
                      and :addrdiv = peraddr.addrdiv(+)
                      and peraddr.prefcd = pref.prefcd(+)
                    order by
                      basedperson.seq
                ";

            // 戻り値の設定
            return connection.Query(sql, sqlParam).Select(rec =>
            {
                DateTime wkBirth = DateTime.Parse(Convert.ToString(rec.BIRTH));
                // 和暦年を取得
                rec.birtherayear = (object)WebHains.JapaneseCalendar.GetYear(wkBirth);
                // 和暦元号(英字表記)を取得
                rec.birthyearshorteraname = WebHains.GetShortEraName(wkBirth);

                return rec;
            }).ToList();
        }

        /// <summary>
        /// 検索条件を満たす個人の件数を取得する
        /// </summary>
        /// <param name="keyword">検索キーの集合</param>
        /// <param name="birth">生年月日</param>
        /// <param name="gender">性別</param>
        /// <param name="romeNameMultiple">複合検索フラグ</param>
        /// <param name="delFlgUseOnly">True指定時は削除フラグが"0"(使用中)のレコードのみ検索</param>
        /// <returns>検索条件を満たすレコード件数</returns>
        public int SelectPersonListCount(string keyword, DateTime? birth = null, int gender = 0, bool romeNameMultiple = false, bool delFlgUseOnly = false)
        {
            string sql = "";  // SQLステートメント
            Dictionary<string, object> sqlParam = new Dictionary<string, object>();

            // 検索条件が設定されていない場合は処理を終了する
            if (string.IsNullOrEmpty(keyword) && (birth == null) && (gender == 0))
            {
                return 0;
            }

            // 検索条件を満たす個人テーブルのレコード件数を取得
            sql = @"
                    select
                      count(perid) cnt
                    from
                      person
                ";

            sql += CreateConditionForPersonList(sqlParam, keyword, birth, gender, romeNameMultiple, delFlgUseOnly);

            dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

            // 検索レコードが存在する場合は件数を戻り値として設定
            // (COUNT関数を発行しているので必ず1レコード返ってくる)
            if (current != null)
            {
                return Convert.ToInt32(current.CNT);
            }

            return 0;
        }

        /// <summary>
        /// 指定団体・事業部・室部・所属条件を満たす個人の一覧を取得する
        /// </summary>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="orgBsdCd">事業部コード</param>
        /// <param name="orgRoomCd">室部コード</param>
        /// <param name="strOrgPostCd">開始所属コード</param>
        /// <param name="endOrgPostCd">終了所属コード</param>
        /// <returns>個人の一覧
        /// perid 個人ＩＤ
        /// </returns>
        public List<dynamic> SelectPersonListFromOrg(string orgCd1, string orgCd2, string orgBsdCd, string orgRoomCd, string strOrgPostCd, string endOrgPostCd)
        {
            string sql = "";  // SQLステートメント
            string orgPostCd = "";  // 所属コード

            // 開始所属コード値が終了所属コードより大きい場合は値を交換する
            if (string.Compare(strOrgPostCd, endOrgPostCd) > 0)
            {
                orgPostCd = strOrgPostCd;
                strOrgPostCd = endOrgPostCd;
                endOrgPostCd = orgPostCd;
            }

            // キー及び更新値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("orgcd1", orgCd1);
            sqlParam.Add("orgcd2", orgCd2);
            sqlParam.Add("orgbsdcd", orgBsdCd);
            sqlParam.Add("orgroomcd", orgRoomCd);
            sqlParam.Add("strorgpostcd", strOrgPostCd);
            sqlParam.Add("endorgpostcd", endOrgPostCd);

            // 指定条件を満たす個人テーブルレコードを検索
            sql = @"
                    select
                      perid
                    from
                      person
                    where
                      orgcd1 = :orgcd1
                      and orgcd2 = :orgcd2
                ";

            // 事業部指定時は条件節に加える
            if (!string.IsNullOrEmpty(orgBsdCd))
            {
                sql += @"
                        and orgbsdcd = :orgbsdcd
                    ";
            }

            // 室部指定時は条件節に加える
            if (!string.IsNullOrEmpty(orgRoomCd))
            {
                sql += @"
                        and orgroomcd = :orgroomcd
                    ";
            }

            // 開始所属指定時は条件節に加える
            if (!string.IsNullOrEmpty(strOrgPostCd))
            {
                sql += @"
                        and orgroomcd >= :strorgroomcd
                    ";
            }

            // 終了所属指定時は条件節に加える
            if (!string.IsNullOrEmpty(endOrgPostCd))
            {
                sql += @"
                        and orgroomcd <= :endorgroomcd
                    ";
            }

            // 退職・休職者・出向者は除く
            sql += @"
                    and delflg = 0
                    and transferdiv = 0
                    order by
                      orgcd1
                      , orgcd2
                      , empno
                ";

            // 戻り値の設定
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 個人ＩＤをキーに個人テーブルを読み込む（名前のみ取得）
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>個人テーブル
        /// lastname   姓
        /// firstname  名
        /// </returns>
        public dynamic SelectPersonName(string perId)
        {
            string sql = "";  // SQLステートメント

            // 検索条件が設定されていない場合は処理を終了する
            if (Strings.Trim(perId) == "")
            {
                return null;
            }

            // キー及び更新値の設定
            var sqlParam = new
            {
                perid = perId.Trim()
            };

            // 検索条件を満たす個人テーブルのレコードを取得
            sql = @"
                    select
                      p.lastname
                      , p.firstname
                    from
                      person p
                ";

            sql += @"
                    where
                      p.perid = :perid
                ";

            // 戻り値の設定
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 続柄データを取得する
        /// </summary>
        /// <param name="strRelationCd">続柄コード</param>
        /// <returns>続柄データ
        /// relationname  続柄名
        /// </returns>
        public dynamic SelectRelation(string strRelationCd)
        {
            string sql = "";  // SQLステートメント

            // キー値の設定
            var sqlParam = new
            {
                relationcd = strRelationCd.Trim()
            };

            // 検索条件を満たす続柄テーブルのレコードを取得
            sql = @"
                    select
                      relationname
                    from
                      relation
                    where
                      relationcd = :relationcd
                ";

            // 戻り値の設定
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 続柄名称の一覧を取得する
        /// </summary>
        /// <returns>続柄名称の一覧
        /// relationcd   続柄コード
        /// relationname 続柄名称
        /// </returns>
        public List<dynamic> SelectRelationList()
        {
            string sql = "";  // SQLステートメント

            // 続柄テーブルのレコードを取得
            sql = @"
                    select
                      relationcd
                      , relationname
                    from
                      relation
                    order by
                      relationcd
                ";

            // 戻り値の設定
            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 個人情報を登録する
        /// </summary>
        /// <param name="mode">登録モード</param>
        /// <param name="refPerId">個人ID</param>
        /// <param name="data">個人情報</param>
        /// <returns>メッセージ</returns>
        public List<string> UpdateAllPersonInfo_lukes(string mode, ref string refPerId, Person data)
        {
            var messages = new List<string>();  // メッセージ
            int ret = 0;  // 関数戻り値

            using (var ts = new TransactionScope())
            {
                while (true)
                {
                    if ("insert".Equals(mode))
                    {
                        // 新規時、個人テーブル挿入処理
                        ret = InsertPerson_lukes(ref refPerId, data);
                    }
                    else if ("update".Equals(mode))
                    {
                        // 医事連携で個人情報を更新する場合はチェックを行わない
                        if (data.MedUpdDate == null)
                        {
                            // 性別と未来受診情報チェック
                            ret = CheckGenderAndConsult(refPerId, Convert.ToInt32(data.Gender));

                            if (ret <= 0)
                            {
                                switch (ret)
                                {
                                    case 0:
                                        messages.Add("この個人情報はすでに削除されています。更新できません。");
                                        break;
                                    case -1:
                                        messages.Add("本日以降（本日含む）にこの個人の受診情報が存在するため、性別の変更はできません。");
                                        break;
                                    default:
                                        messages.Add("個人情報更新時にその他のエラーが発生しました（" + ret + "）。");
                                        break;
                                }
                            }

                            if (ret <= 0)
                            {
                                break;
                            }
                        }

                        // 修正時、個人テーブル更新処理
                        ret = UpdatePerson_lukes(refPerId, data);
                    }
                    else
                    {
                        break;
                    }

                    if (0.Equals(ret))
                    {
                        if ("insert".Equals(mode))
                        {
                            messages.Add("同一個人ＩＤの個人情報がすでに存在します。");
                        }
                        else
                        {
                            messages.Add("この個人情報はすでに削除されています。更新できません。");
                        }
                    }
                    else if ((-3).Equals(ret))
                    {
                        messages.Add("ユーザ情報が存在しません。");
                    }

                    else if ((-4).Equals(ret))
                    {
                        messages.Add("国籍情報が存在しません。");
                    }

                    else if ((-3).Equals(ret))
                    {
                        messages.Add("同伴者個人情報が存在しません。");
                    }

                    if (ret <= 0)
                    {
                        break;
                    }

                    // 個人テーブルが更新され、コミットされる前の状態で照合を行う
                    // 医事連携で個人情報を更新する場合はチェックを行わない
                    if (data.MedUpdDate != null && !IsEqualToMed(refPerId))
                    {
                        messages.Add("医事情報とカナ氏名、性別、生年月日のいずれかが一致しません。");
                        break;
                    }

                    // お連れ様情報（相手先）を更新する
                    UpdateCompPerId2(refPerId, 1);

                    // 個人属性テーブル更新処理
                    UpdatePerDetail(refPerId, data);

                    // 個人住所テーブル更新処理
                    UpdatePerAddr(refPerId, data.Addresses);

                    // トランザクションをコミット
                    ts.Complete();
                    break;
                }
            }

            // 戻り値の設定
            return messages;
        }

        /// <summary>
        /// 個人IDをキーに個人属性テーブルを更新する
        /// </summary>
        /// <param name="perId">個人ID</param>
        /// <param name="data">個人情報</param>
        public void UpdatePerDetail(string perId, Person data)
        {
            string sql = "";  // SQLステートメント
            var param = new Dictionary<string, object>();
            List<string> column = new List<string>();

            using (var ts = new TransactionScope())
            {
                // キー及び更新値の設定
                param.Add("PERID", perId.Trim());

                // 検索条件を満たす個人属性テーブルのレコードを先に削除
                sql = @"
                        delete
                        from
                            persondetail
                        where
                            perid = :perid
                    ";

                connection.Execute(sql, param);

                if (data.Marriage != null)
                {
                    param.Add("marriage", data.Marriage);
                    // 列名を配列に格納
                    column.Add("marriage");
                }

                if (data.ResidentNo != null)
                {
                    param.Add("residentno", data.ResidentNo);
                    // 列名を配列に格納
                    column.Add("residentno");
                }

                if (data.UnionNo != null)
                {
                    param.Add("unionno", data.UnionNo);
                    // 列名を配列に格納
                    column.Add("unionno");
                }

                if (data.Karte != null)
                {
                    param.Add("karte", data.Karte);
                    // 列名を配列に格納
                    column.Add("karte");
                }

                if (data.Notes != null)
                {
                    param.Add("notes", data.Notes);
                    // 列名を配列に格納
                    column.Add("notes");
                }

                if (data.Spare3 != null)
                {
                    param.Add("spare1", data.Spare3);
                    // 列名を配列に格納
                    column.Add("spare1");
                }

                if (data.Spare4 != null)
                {
                    param.Add("spare2", data.Spare4);
                    // 列名を配列に格納
                    column.Add("spare2");
                }

                if (data.Spare5 != null)
                {
                    param.Add("spare3", data.Spare5);
                    // 列名を配列に格納
                    column.Add("spare3");
                }

                if (data.Spare6 != null)
                {
                    param.Add("spare4", data.Spare6);
                    // 列名を配列に格納
                    column.Add("spare4");
                }

                if (data.Spare7 != null)
                {
                    param.Add("spare5", data.Spare7);
                    // 列名を配列に格納
                    column.Add("spare5");
                }

                // 個人属性レコードの挿入
                sql = @"
                        insert
                        into persondetail(
                    ";

                if (column.Count == 0)
                {
                    sql += @"
                            perid
                        ";
                }
                else
                {
                    sql += @"
                            perid,
                        ";
                }

                for (int i = 0; i < column.Count; i++)
                {
                    if (!(i.Equals(column.Count - 1)))
                    {
                        sql += column[i] + ",";
                    }
                    else
                    {
                        sql += column[i];
                    }
                }

                sql += @"
                        )
                        values (
                    ";

                if (column.Count == 0)
                {
                    sql += @"
                            :perid
                        ";
                }
                else
                {
                    sql += @"
                            :perid,
                        ";
                }

                for (int i = 0; i < column.Count; i++)
                {
                    if (!(i.Equals(column.Count - 1)))
                    {
                        sql += ":" + column[i] + ",";
                    }
                    else
                    {
                        sql += ":" + column[i];
                    }
                }

                sql += " ) ";

                connection.Execute(sql, param);

                // トランザクションをコミット
                ts.Complete();
            }
        }

        /// <summary>
        /// 同伴者個人ＩＤの相互更新
        /// </summary>
        /// <param name="strPerId">個人ＩＤ</param>
        /// <param name="strCompPerId">同伴者個人ＩＤ</param>
        /// <returns>
        ///  1   正常終了
        ///  0   個人情報が存在しない
        ///  -1  異なる同伴者がすでに登録されている
        ///  -2  異常終了
        /// </returns>
        public int UpdateCompPerId(string strPerId, string strCompPerId)
        {
            string sql = "";  // SQLステートメント
            string updSql = "";  // SQLステートメント
            var sqlParam = new Dictionary<string, object>();
            dynamic current;
            int Ret = 0;

            // 現在の同伴者個人ＩＤを取得するSQLステートメント作成
            sql = @"
                    select
                      person.compperid
                    from
                      person
                    where
                      perid = :perid
                ";

            updSql = @"
                        update person
                        set
                          compperid = :compperid
                        where
                          perid = :perid
                    ";

            using (var transaction = BeginTransaction())
            {
                try
                {
                    for (int i = 0; i < 2; i++)
                    {
                        sqlParam = new Dictionary<string, object>();
                        // キー値の設定
                        sqlParam.Add("perid", i == 0 ? strPerId : strCompPerId);

                        // 同伴者個人ＩＤの取得
                        current = connection.Query(sql, sqlParam).FirstOrDefault();

                        // レコードが存在しなければ終了
                        if (current = null)
                        {
                            break;
                        }

                        // すでに指定された同伴者以外のＩＤが存在する場合は終了
                        if (!string.IsNullOrEmpty(Convert.ToString(current.COMPPERID)) && Convert.ToString(current.COMPPERID) != (i == 0 ? strCompPerId : strPerId))
                        {
                            Ret = -1;
                            break;
                        }

                        // 同伴者個人ＩＤの更新
                        sqlParam.Add("compperid", i == 0 ? strCompPerId : strPerId);
                        connection.Execute(updSql, sqlParam);
                    }

                    Ret = 1;

                    // トランザクション制御
                    if (Ret > 0)
                    {
                        // トランザクションをコミット
                        transaction.Commit();
                    }
                    else
                    {
                        transaction.Rollback();
                    }

                    // 戻り値の設定
                    return Ret;

                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();

                    return -2;
                }
            }
        }

        /// <summary>
        /// 同伴者個人ＩＤの相互更新２
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="mode">0:NULLクリアする、1:個人IDで更新</param>
        private void UpdateCompPerId2(string perId, int mode)
        {
            string sql = "";  // SQLステートメント
            var param = new Dictionary<string, object>();

            using (var ts = new TransactionScope())
            {
                // キー値の設定
                param.Add("perid", perId.Trim());

                if (0.Equals(mode))
                {
                    param.Add("set_compperid", "");
                }
                else
                {
                    param.Add("set_compperid", perId.Trim());
                }

                // 同伴者情報の更新
                sql = @"
                        update person
                        set
                            compperid = :set_compperid
                        where
                            perid = (
                            select
                                compperid
                            from
                                person
                            where
                                perid = :perid
                            )
                    ";

                // クリアの場合は、クリアする同伴者の同伴者IDが自分と同じ場合のみ
                if (0.Equals(mode))
                {
                    sql += @"
                            and compperid = :perid
                        ";
                }

                connection.Execute(sql, param);

                // トランザクションをコミット
                ts.Complete();
            }
        }

        /// <summary>
        /// 個人IDをキーに個人住所情報を更新する
        /// </summary>
        /// <param name="perId">個人ID</param>
        /// <param name="data">個人住所情報</param>
        public void UpdatePerAddr(string perId, Addresses[] data)
        {
            if (data == null)
            {
                return;
            }

            string sql = "";  // SQLステートメント

            // パラメーター値設定
            var paramArray = new List<Dictionary<string, object>>();

            // 個人住所情報テーブルレコードの挿入
            sql = @"
                    merge
                    into peraddr
                      using (
                        select
                          :perid perid
                          , :addrdiv addrdiv
                          , :zipcd zipcd
                          , :prefcd prefcd
                          , :cityname cityname
                          , :address1 address1
                          , :address2 address2
                          , :tel1 tel1
                          , :phone phone
                          , :tel2 tel2
                          , :extension extension
                          , :fax fax
                          , :email email
                        from
                          dual
                      ) basedperaddr
                        on (
                          peraddr.perid = basedperaddr.perid
                          and peraddr.addrdiv = basedperaddr.addrdiv
                        )
                ";

            sql += @"
                    when matched then update
                    set
                      peraddr.zipcd = basedperaddr.zipcd
                      , peraddr.prefcd = basedperaddr.prefcd
                      , peraddr.cityname = basedperaddr.cityname
                      , peraddr.address1 = basedperaddr.address1
                      , peraddr.address2 = basedperaddr.address2
                      , peraddr.tel1 = basedperaddr.tel1
                      , peraddr.phone = basedperaddr.phone
                      , peraddr.tel2 = basedperaddr.tel2
                      , peraddr.extension = basedperaddr.extension
                      , peraddr.fax = basedperaddr.fax
                      , peraddr.email = basedperaddr.email
                ";

            sql += @"
                    when not matched then
                    insert (
                      peraddr.perid
                      , peraddr.addrdiv
                      , peraddr.zipcd
                      , peraddr.prefcd
                      , peraddr.cityname
                      , peraddr.address1
                      , peraddr.address2
                      , peraddr.tel1
                      , peraddr.phone
                      , peraddr.tel2
                      , peraddr.extension
                      , peraddr.fax
                      , peraddr.email
                    )
                ";

            sql += @"
                    values (
                      basedperaddr.perid
                      , basedperaddr.addrdiv
                      , basedperaddr.zipcd
                      , basedperaddr.prefcd
                      , basedperaddr.cityname
                      , basedperaddr.address1
                      , basedperaddr.address2
                      , basedperaddr.tel1
                      , basedperaddr.phone
                      , basedperaddr.tel2
                      , basedperaddr.extension
                      , basedperaddr.fax
                      , basedperaddr.email
                    )
                ";

            using (var ts = new TransactionScope())
            {
                foreach (var rec in data)
                {
                    // キー及び更新値の設定
                    var param = new Dictionary<string, object>();
                    param.Add("perid", perId.Trim());
                    param.Add("addrdiv", rec.AddrDiv);
                    param.Add("tel1", rec.Tel1);
                    param.Add("phone", rec.Phone);
                    param.Add("tel2", rec.Tel2);
                    param.Add("extension", rec.Extension);
                    param.Add("fax", rec.Fax);
                    param.Add("email", rec.EMail);
                    param.Add("zipcd", rec.ZipCd);
                    param.Add("prefcd", rec.PrefCd);
                    param.Add("cityname", rec.CityName);
                    param.Add("address1", rec.Address1);
                    param.Add("address2", rec.Address2);

                    paramArray.Add(param);
                }
                // SQL文の実行
                connection.Execute(sql, paramArray);

                // トランザクションをコミット
                ts.Complete();
            }
        }

        /// <summary>
        /// 個人IDをキーに個人テーブルを更新する
        /// </summary>
        /// <param name="perId">個人ID</param>
        /// <param name="data">個人情報</param>
        /// <returns>
        ///  1    正常終了
        ///  0    レコードなし
        ///  -1   同一団体・従業員番号のレコードが存在
        ///  -2   同一健保・続柄・枝番のレコードが存在
        ///  -3   ユーザ情報が存在しない
        ///  -4   所属情報が存在しない
        ///  -5   続柄が存在しない
        ///  -6   親個人ＩＤが存在しない
        ///  -7   職名情報が存在しない
        ///  -8   職責情報が存在しない
        ///  -9   資格情報が存在しない
        ///  -10  就業措置区分が存在しない
        /// </returns>
        public int UpdatePerson_lukes(string perId, Person data)
        {
            string sql = "";  // SQLステートメント
            int ret = 0;      // 関数戻り値
            var param = new Dictionary<string, object>();
            List<string> column = new List<string>();

            using (var ts = new TransactionScope())
            {
                // エラーハンドラの設定
                try
                {
                    // まずはお連れ様情報をクリアする
                    UpdateCompPerId2(perId, 0);

                    // キー及び更新値の設定
                    param.Add("perid", perId);

                    if (data.VidFlg != null)
                    {
                        param.Add("vidflg", data.VidFlg);
                        column.Add("vidflg");
                    }

                    if (data.DelFlg != null)
                    {
                        param.Add("delflg", data.DelFlg);
                        column.Add("delflg");
                    }

                    if (data.UpdUser != null)
                    {
                        param.Add("upduser", data.UpdUser);
                        column.Add("upduser");
                    }

                    if (data.LastName != null)
                    {
                        param.Add("lastname", Strings.StrConv(data.LastName, VbStrConv.Wide));
                        column.Add("lastname");
                    }

                    if (data.FirstName != null)
                    {
                        param.Add("firstname", Strings.StrConv(data.FirstName, VbStrConv.Wide));
                        column.Add("firstname");
                    }

                    if (data.LastKName != null)
                    {
                        param.Add("lastkname", Strings.StrConv(data.LastKName, VbStrConv.Wide));
                        column.Add("lastkname");
                    }

                    if (data.FirstKName != null)
                    {
                        param.Add("firstkname", Strings.StrConv(data.FirstKName, VbStrConv.Wide));
                        column.Add("firstkname");
                    }

                    if (data.RomeName != null)
                    {
                        param.Add("romename", data.RomeName?.ToUpper());
                        column.Add("romename");
                    }

                    if (data.Birth != null)
                    {
                        param.Add("birth", DateTime.Parse(data.Birth).Date);
                        column.Add("birth");
                    }

                    if (data.Gender != null)
                    {
                        param.Add("gender", data.Gender);
                        column.Add("gender");
                    }

                    if (data.Spare1 != null)
                    {
                        param.Add("spare1", data.Spare1);
                        column.Add("spare1");
                    }

                    if (data.Spare2 != null)
                    {
                        param.Add("spare2", data.Spare2);
                        column.Add("spare2");
                    }

                    if (data.PostCardAddr != null)
                    {
                        param.Add("postcardaddr", data.PostCardAddr);
                        column.Add("postcardaddr");
                    }

                    if (data.MaidenName != null)
                    {
                        param.Add("maidenname", data.MaidenName);
                        column.Add("maidenname");
                    }

                    if (data.NationCd != null)
                    {
                        param.Add("nationcd", data.NationCd);
                        column.Add("nationcd");
                    }

                    if (data.CompPerId != null)
                    {
                        param.Add("compperid", data.CompPerId);
                        column.Add("compperid");
                    }

                    if (data.CslCount != null)
                    {
                        param.Add("cslcount", data.CslCount);
                        column.Add("cslcount");
                    }

                    if (data.MedRName != null)
                    {
                        param.Add("medrname", data.MedRName);
                        column.Add("medrname");
                    }

                    if (data.MedName != null)
                    {
                        param.Add("medname", data.MedName);
                        column.Add("medname");
                    }

                    if (data.MedBirth != null)
                    {
                        param.Add("medbirth", !string.IsNullOrEmpty(data.MedBirth) ? (DateTime?)DateTime.Parse(data.MedBirth).Date : null);
                        column.Add("medbirth");
                    }

                    if (data.MedGender != null)
                    {
                        param.Add("medgender", data.MedGender);
                        column.Add("medgender");
                    }

                    if (data.MedUpdDate != null)
                    {
                        param.Add("medupddate", (!string.IsNullOrEmpty(data.MedUpdDate) ? (DateTime?)DateTime.Parse(data.MedUpdDate) : null));
                        column.Add("medupddate");
                    }

                    if (data.MedNationCd != null)
                    {
                        param.Add("mednationcd", data.MedNationCd);
                        column.Add("mednationcd");
                    }

                    if (data.MedKName != null)
                    {
                        param.Add("medkname", data.MedKName);
                        column.Add("medkname");
                    }

                    sql = @"
                            update person
                            set
                              upddate = sysdate
                        ";

                    // 更新項目の追加
                    if (column.Count > 0)
                    {
                        for (int i = 0; i < column.Count; i++)
                        {
                            sql += @", " + column[i] + " = :" + column[i];
                        }
                    }

                    sql += @"
                            where
                              perid = :perid
                        ";

                    ret = connection.Execute(sql, param);

                    if (ret > 0)
                    {
                        ts.Complete();
                    }

                    return ret;
                }
                catch (OracleException ex)
                {
                    while (true)
                    {
                        // キー重複時
                        if (ex.Number == 1)
                        {
                            if (ex.Message.IndexOf("PERSON_INDEX1", StringComparison.Ordinal) >= 0)
                            {
                                ret = -1;
                            }
                            else if (ex.Message.IndexOf("PERSON_INDEX2", StringComparison.Ordinal) >= 0)
                            {
                                ret = -2;
                            }
                            else
                            {
                                throw ex;
                            }
                        }
                        // 外部キーエラー時
                        else if (ex.Number == 2291)
                        {
                            if (ex.Message.IndexOf("PERSON_FKEY1", StringComparison.Ordinal) >= 0)
                            {
                                ret = -3;
                            }
                            else if (ex.Message.IndexOf("PERSON_FKEY2", StringComparison.Ordinal) >= 0)
                            {
                                ret = -4;
                            }
                            else if (ex.Message.IndexOf("PERSON_FKEY3", StringComparison.Ordinal) >= 0)
                            {
                                ret = -5;
                            }
                            else if (ex.Message.IndexOf("PERSON_FKEY4", StringComparison.Ordinal) >= 0)
                            {
                                ret = -6;
                            }
                            else if (ex.Message.IndexOf("PERSON_FKEY5", StringComparison.Ordinal) >= 0)
                            {
                                ret = -7;
                            }
                            else if (ex.Message.IndexOf("PERSON_FKEY6", StringComparison.Ordinal) >= 0)
                            {
                                ret = -8;
                            }
                            else if (ex.Message.IndexOf("PERSON_FKEY7", StringComparison.Ordinal) >= 0)
                            {
                                ret = -9;
                            }
                            else if (ex.Message.IndexOf("PERSON_FKEY8", StringComparison.Ordinal) >= 0)
                            {
                                ret = -10;
                            }
                            else
                            {
                                throw ex;
                            }
                        }
                        else
                        {
                            throw ex;
                        }

                        return ret;
                    }
                }
            }
        }

        #region "新設メソッド"

        /// <summary>
        /// 個人情報各値の妥当性チェックを行う
        /// </summary>
        /// <param name="data">個人情報</param>
        /// <param name="perId">個人ID</param>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public IList<string> ValidateForMntPersonal(Person data, string perId = null)
        {
            const int LENGTH_PERSON_ROMENAME = 60;
            const int LENGTH_TEL = 15;

            var messagesList = new List<string>();
            string message = "";

            // ローマ字名
            message = WebHains.CheckNarrowValue("ローマ字名", Convert.ToString(data.RomeName), LENGTH_PERSON_ROMENAME);
            if (!string.IsNullOrEmpty(message))
            {
                messagesList.Add(message);
            }

            // ローマ字名
            if (!string.IsNullOrEmpty(Convert.ToString(perId)))
            {
                if (!"@".Equals(Convert.ToString(perId).Substring(0, 1)) && "".Equals(data.RomeName))
                {
                    messagesList.Add("ローマ字名を入力して下さい。");
                }
            }
            else
            {
                if (string.IsNullOrEmpty(data.RomeName))
                {
                    messagesList.Add("ローマ字名を入力して下さい。");
                }
            }

            // カナ姓
            if (string.IsNullOrEmpty(Convert.ToString(data.LastKName)))
            {
                messagesList.Add("カナ姓を入力して下さい。");
            }

            // 姓
            if (string.IsNullOrEmpty(data.LastName))
            {
                messagesList.Add("姓を入力して下さい。");
            }

            // 性別
            if (string.IsNullOrEmpty(data.Gender))
            {
                messagesList.Add("性別を入力して下さい。");
            }

            // 生年月日
            if (string.IsNullOrEmpty(data.Birth))
            {
                messagesList.Add("生年月日を入力して下さい。");
            }
            
            string strColumn = "";
            // 住所情報
            for (int i = 0; i < data.Addresses.Length; i++)
            {
                // 医事情報は表示のみなのでチェック非対象
                if (!"4".Equals(data.Addresses[i].AddrDiv))
                {
                    // エラー時に表示するための項目名設定
                    switch (Convert.ToString(data.Addresses[i].AddrDiv))
                    {
                        case "1":
                            strColumn = "（自宅）";
                            break;
                        case "2":
                            strColumn = "（勤務先）";
                            break;
                        case "3":
                            strColumn = "（その他）";
                            break;
                    }

                    // 住所
                    if (!string.IsNullOrEmpty(WebHains.CheckLength("市区町村" + strColumn, Convert.ToString(data.Addresses[i].CityName), (int)LengthConstants.LENGTH_CITYNAME)))
                    {
                        messagesList.Add(WebHains.CheckLength("市区町村" + strColumn, Convert.ToString(data.Addresses[i].CityName), (int)LengthConstants.LENGTH_CITYNAME));

                    }
                    // 住所１
                    if (!string.IsNullOrEmpty(WebHains.CheckLength("住所１" + strColumn, Convert.ToString(data.Addresses[i].Address1), (int)LengthConstants.LENGTH_ADDRESS)))
                    {
                        messagesList.Add(WebHains.CheckLength("住所１" + strColumn, Convert.ToString(data.Addresses[i].Address1), (int)LengthConstants.LENGTH_ADDRESS));

                    }
                    // 住所２
                    if (!string.IsNullOrEmpty(WebHains.CheckLength("住所２" + strColumn, Convert.ToString(data.Addresses[i].Address2), (int)LengthConstants.LENGTH_ADDRESS)))
                    {
                        messagesList.Add(WebHains.CheckLength("住所２" + strColumn, Convert.ToString(data.Addresses[i].Address2), (int)LengthConstants.LENGTH_ADDRESS));
                    }
                    // 電話番号１
                    if (!string.IsNullOrEmpty(WebHains.CheckLength("電話番号１" + strColumn, Convert.ToString(data.Addresses[i].Tel1), LENGTH_TEL)))
                    {
                        messagesList.Add(WebHains.CheckLength("電話番号１" + strColumn, Convert.ToString(data.Addresses[i].Tel1), LENGTH_TEL));
                    }
                    // 携帯番号
                    if (!string.IsNullOrEmpty(WebHains.CheckLength("携帯番号" + strColumn, Convert.ToString(data.Addresses[i].Phone), LENGTH_TEL)))
                    {
                        messagesList.Add(WebHains.CheckLength("携帯番号" + strColumn, Convert.ToString(data.Addresses[i].Phone), LENGTH_TEL));
                    }
                    // 電話番号２
                    if (!string.IsNullOrEmpty(WebHains.CheckLength("電話番号２" + strColumn, Convert.ToString(data.Addresses[i].Tel2), LENGTH_TEL)))
                    {
                        messagesList.Add(WebHains.CheckLength("電話番号２" + strColumn, Convert.ToString(data.Addresses[i].Tel2), LENGTH_TEL));
                    }
                    // 内線
                    if (!string.IsNullOrEmpty(WebHains.CheckLength("内線" + strColumn, Convert.ToString(data.Addresses[i].Extension), (int)LengthConstants.LENGTH_PERSONDETAIL_EXTENSION)))
                    {
                        messagesList.Add(WebHains.CheckLength("内線" + strColumn, Convert.ToString(data.Addresses[i].Extension), (int)LengthConstants.LENGTH_PERSONDETAIL_EXTENSION));
                    }
                    // ＦＡＸ番号
                    if (!string.IsNullOrEmpty(WebHains.CheckLength("ＦＡＸ番号" + strColumn, Convert.ToString(data.Addresses[i].Fax), LENGTH_TEL)))
                    {
                        messagesList.Add(WebHains.CheckLength("ＦＡＸ番号" + strColumn, Convert.ToString(data.Addresses[i].Fax), LENGTH_TEL));
                    }
                    // E-Mailアドレス
                    message = WebHains.CheckNarrowValue("E-Mailアドレス" + strColumn, Convert.ToString(data.Addresses[i].EMail), (int)LengthConstants.LENGTH_EMAIL);
                    if (message != null)
                    {
                        messagesList.Add(WebHains.CheckEMail("E-Mailアドレス" + strColumn, Convert.ToString(data.Addresses[i].EMail)));
                    }
                }
            }

            // 受診回数が存在しない
            message = WebHains.CheckNumeric("受診回数", Convert.ToString(data.CslCount), 3);
            if (message != null)
            {
                messagesList.Add(message);
            }

            // 住民番号
            message = WebHains.CheckNarrowValue("住民番号", Convert.ToString(data.ResidentNo), (int)LengthConstants.LENGTH_PERSONDETAIL_RESIDENTNO);
            if (message != null)
            {
                messagesList.Add(message);
            }

            // 組合番号
            message = WebHains.CheckNarrowValue("組合番号", Convert.ToString(data.UnionNo), (int)LengthConstants.LENGTH_PERSONDETAIL_UNIONNO);
            if (message != null)
            {
                messagesList.Add(message);
            }

            // カルテ番号
            message = WebHains.CheckNarrowValue("カルテ番号", Convert.ToString(data.Karte), (int)LengthConstants.LENGTH_PERSONDETAIL_KARTE);
            if (message != null)
            {
                messagesList.Add(message);
            }

            // 汎用キー
            var spareName = new List<string>();
            List<dynamic> FreeList = new List<dynamic>();
            for (int i = 0; i < 7; i++)
            {
                FreeList = freeDao.SelectFree(0, "PERSPARE" + (i + 1));
                if (FreeList[0].FREENAME != null)
                {
                    spareName.Add(FreeList[0].FREENAME);
                }
                else
                {
                    spareName.Add("汎用キー" + (i + 1));
                }
            }
            List<string> spare = new List<string>();
            spare.Add(data.Spare1);
            spare.Add(data.Spare2);
            spare.Add(data.Spare3);
            spare.Add(data.Spare4);
            spare.Add(data.Spare5);
            spare.Add(data.Spare6);
            spare.Add(data.Spare7);
            for (int i = 0; i < 7; i++)
            {
                if (!string.IsNullOrEmpty(WebHains.CheckLength(spareName[i], spare[i], i < 2 ? (int)LengthConstants.LENGTH_PERSON_SPARE : (int)LengthConstants.LENGTH_PERSONDETAIL_SPARE)))
                {
                    messagesList.Add(WebHains.CheckLength(spareName[i], spare[i], i < 2 ? (int)LengthConstants.LENGTH_PERSON_SPARE : (int)LengthConstants.LENGTH_PERSONDETAIL_SPARE));
                }
            }

            // 特記事項
            message = WebHains.CheckWideValue("特記事項", Convert.ToString(data.Notes), (int)LengthConstants.LENGTH_PERSONDETAIL_NOTES);
            if (message != null)
            {
                messagesList.Add(message + "（改行文字も含みます）");
            }

            return messagesList;
        }

        #endregion
    }
}


