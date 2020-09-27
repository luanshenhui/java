using Dapper;
using Entity.Helper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Microsoft.VisualBasic;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// web予約用データアクセスオブジェクト
    /// </summary>
    public class WebRsvDao : AbstractDao
    {
        private const string PREFIX_PERID = "ID:";                   // 検索時の個人ＩＤ指定
        private const string PREFIX_BIRTH = "BIRTH:";                // 検索時の生年月日指定
        private const string PREFIX_GENDER = "GENDER:";              // 検索時の性別指定

        private const string CSCSOPTION1_STOMAC_XRAY = "W001";       // 胃検査オプション(胃X線)
        private const string CSCSOPTION1_STOMAC_CAMERA = "W002";     // 胃検査オプション(胃内視鏡)

        private const string CSCSOPTION2_CHEST_XRAY = "W003";        // 胸部検査(胸部X線)
        private const string CSCSOPTION2_CHEST_CT = "W004";          // 胸部検査(胸部CT)

        private const string CSCSOPTION3_BREAST_XRAY = "W005";       // 乳房検査オプション(乳房X線)
        private const string CSCSOPTION3_BREAST_ECHO = "W006";       // 乳房検査オプション(乳房超音波)
        private const string CSCSOPTION3_BREAST_XRAY_ECHO = "W013";  // 乳房検査オプション(乳房X線＋乳房超音波)

        /// <summary>
        /// 個人情報データアクセスオブジェクト
        /// </summary>
        readonly PersonDao personDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        /// <param name="personDao">個人情報データアクセスオブジェクト</param>
        public WebRsvDao(IDbConnection connection, PersonDao personDao) : base(connection)
        {
            this.personDao = personDao;
        }

        /// <summary>
        /// 生年月日条件節の追加
        /// </summary>
        /// <param name="param">キー及び更新値</param>
        /// <param name="condition">条件節の集合</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        private void AppendCondition_Birth(ref Dictionary<string, object> param, ref string condition, string buffer, int paramNo)
        {
            string sql;        // SQLステートメント
            string paramName;  // パラメータ名
            string birth;      // 生年月日

            // 先頭６文字が"BIRTH:"である場合は先頭部を取り除いた部分を生年月日として取得、それ以外は引数値をそのまま使用
            if (buffer.Substring(0, PREFIX_BIRTH.Length).ToUpper().Equals(PREFIX_BIRTH))
            {
                birth = buffer.Substring(PREFIX_BIRTH.Length, buffer.Length - PREFIX_BIRTH.Length);
            }
            else
            {
                birth = buffer;
            }

            // すでに日付型である場合
            if (DateTime.TryParse(birth, out DateTime dt))
            {
                // そのまま適用
                birth = string.Format("{0:yyyyMMdd}", DateTime.Parse(birth));
            }
            // 日付型でない(すなわち８桁の数字列である)場合
            else
            {
                // 年がゼロの場合はシステム年を適用し、さもなくばそのまま日付型にして適用
                birth = birth.Substring(0, 4).Equals("0000") ? DateTime.Now.ToString("yyyy") + birth.Substring(birth.Length - 4, 4) : birth;
            }

            // パラメータ名の定義
            paramName = "birth" + paramNo.ToString();

            // パラメータ追加
            param.Add(paramName, int.Parse(birth));

            // 条件節の編集
            sql = "and v_web_yoyaku.birth = :" + paramName;

            // 配列に追加
            condition += sql;
        }

        /// <summary>
        /// 性別条件節の追加
        /// </summary>
        /// <param name="param">キー及び更新値</param>
        /// <param name="condition">条件節の集合</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        private void AppendCondition_Gender(ref Dictionary<string, object> param, ref string condition, string buffer, int paramNo)
        {
            string sql;        // SQLステートメント
            string paramName;  // パラメータ名
            string gender;     // 性別

            // 先頭６文字が"GENDER:"である場合は先頭部を取り除いた部分を生年月日として取得、それ以外は引数値をそのまま使用
            if (buffer.Substring(0, PREFIX_GENDER.Length).ToUpper().Equals(PREFIX_GENDER))
            {
                gender = buffer.Substring(PREFIX_GENDER.Length, buffer.Length - PREFIX_GENDER.Length).ToUpper();
            }
            else
            {
                gender = buffer.ToUpper();
            }

            // パラメータ名の定義
            paramName = "gender" + paramNo.ToString();

            // パラメータ追加
            param.Add(paramName, gender.Equals("M") ? Gender.Male : Gender.Female);

            // 条件節の編集
            sql = "and v_web_yoyaku.gender = :" + paramName;

            // 配列に追加
            condition += sql;
        }

        /// <summary>
        /// 個人ＩＤ条件節の追加
        /// </summary>
        /// <param name="param">キー及び更新値</param>
        /// <param name="condition">条件節の集合</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        private void AppendCondition_PerId(ref Dictionary<string, object> param, ref string condition, string buffer, int paramNo)
        {
            string sql;        // SQLステートメント
            string paramName;  // パラメータ名
            string perId;      // 個人ＩＤ

            // 先頭３文字が"ID:"である場合は先頭部を取り除いた部分を個人IDとして取得、それ以外は引数値をそのまま使用
            if (buffer.Substring(0, PREFIX_PERID.Length).ToUpper().Equals(PREFIX_PERID))
            {
                perId = buffer.Substring(PREFIX_PERID.Length, buffer.Length - PREFIX_PERID.Length);
            }
            else
            {
                perId = buffer;
            }

            // パラメータ追加
            paramName = "perid" + paramNo.ToString();
            param.Add(paramName, "");

            // 条件節の編集
            if (perId.Substring(perId.Length - 1, 1).Equals("*"))
            {
                // 文字列の末尾が"*"なら部分検索
                param.Add(paramName, perId.Substring(0, perId.Length - 1) + "%");
                sql = "and v_web_yoyaku.perno like :" + paramName;
            }
            else
            {
                // さもなければ直接指定
                param.Add(paramName, perId);
                sql = "and v_web_yoyaku.perno = :" + paramName;
            }

            // 配列に追加
            condition += sql;
        }

        /// <summary>
        /// 全角文字条件節の追加
        /// </summary>
        /// <param name="param">キー及び更新値</param>
        /// <param name="condition">条件節の集合</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        private void AppendCondition_Wide(ref Dictionary<string, object> param, ref string condition, string buffer, int paramNo)
        {
            string sql;        // SQLステートメント
            string paramName;  // パラメータ名

            string narrow;     // 半角変換後の文字列
            bool wideChar;     // カナ漢字チェック用変数
            int i;             // インデックス

            // カナ以外の全角文字が存在するかをチェック(カナは半角変換でき、漢字・ひらがなは半角変換できない性質を利用)
            narrow = Strings.StrConv(buffer, VbStrConv.Narrow);
            wideChar = false;
            for (i = 0; i < narrow.Length; i++)
            {
                if (Strings.Asc(narrow.Substring(i, 1)) < 0)
                {
                    wideChar = true;
                    break;
                }
            }

            // パラメータ名定義
            paramName = "fullname" + paramNo.ToString();

            // パラメータ追加
            param.Add(paramName, buffer + "%");

            // 条件節の編集
            if (wideChar)
            {
                // カナ以外の全角文字が含まれる場合
                sql = "and v_web_yoyaku.namej like :" + paramName;
            }
            else
            {
                // カナのみの場合
                sql = "and to_zenkaku(v_web_yoyaku.namea) like :" + paramName;
            }

            // 配列に追加
            condition += sql;
        }

        /// <summary>
        /// web予約一覧検索用基本SQL作成
        /// </summary>
        /// <param name="param">キー及び更新値</param>
        /// <param name="strCslDate">開始受診年月日</param>
        /// <param name="endCslDate">終了受診年月日</param>
        /// <param name="key">検索キー</param>
        /// <param name="strOpDate">開始処理年月日</param>
        /// <param name="endOpDate">終了処理年月日</param>
        /// <param name="opMode">処理モード(1:申込日で検索、2:予約処理日で検索)</param>
        /// <param name="regFlg">本登録フラグ(0:指定なし、1:未登録者、2:編集済み受診者)</param>
        /// <param name="moushiKbn">申込区分（0：すべて　1:新規　2:キャンセル）</param>
        /// <returns>SQLステートメント</returns>
        private string CreateBasedSqlForWebRsvList(ref Dictionary<string, object> param, DateTime strCslDate, DateTime endCslDate, string key, DateTime strOpDate, DateTime endOpDate, int opMode, int regFlg, int moushiKbn)
        {
            string sql;     // SQLステートメント
            DateTime date;  // 日付比較時退避用

            // 受診年月日について日付範囲順逆逆転時は値を交換
            if (strCslDate > endCslDate)
            {
                date = strCslDate;
                strCslDate = endCslDate;
                endCslDate = date;
            }

            // 処理年月日について日付範囲順逆逆転時は値を交換
            if (strOpDate > endOpDate)
            {
                date = strOpDate;
                strOpDate = endOpDate;
                endOpDate = date;
            }

            // キー及び更新値の設定
            param.Add("strcsldate", strCslDate);
            param.Add("endcsldate", endCslDate.AddDays(1));
            param.Add("stropdate", strOpDate);
            param.Add("endopdate", endOpDate.AddDays(1));
            param.Add("regflg", regFlg.ToString());

            // 基本SQLステートメントの編集開始
            sql = @"
                    select
                      *
                    from
                      webreserve.v_web_yoyaku
                    where
                      v_web_yoyaku.jdate >= :strcsldate
                      and v_web_yoyaku.jdate < :endcsldate
                 ";

            // 検索キー指定時は条件追加
            if (!key.Equals(""))
            {
                sql += CreateConditionForWebRsvList(ref param, key);
            }

            // 処理年月日指定時は条件追加
            if (strOpDate != null || endOpDate != null)
            {
                switch (opMode)
                {
                    case 1:  // 申込日で検索

                        sql += @"
                                and v_web_yoyaku.insertdate >= :stropdate
                                and v_web_yoyaku.insertdate < :endopdate
                             ";
                        break;

                    case 2:  // 予約処理日で検索

                        sql += @"
                                and v_web_yoyaku.updatedate >= :stropdate
                                and v_web_yoyaku.updatedate < :endopdate
                                and v_web_yoyaku.ykbn = 2
                             ";
                        break;
                }
            }

            // 状態指定時は条件追加
            if (regFlg > 0)
            {
                sql += " and v_web_yoyaku.ykbn = :regflg ";
            }

            // 申込区分による条件追加
            switch (moushiKbn)
            {
                case 0:
                    // 0：すべての場合：条件なし
                    break;

                case 1:
                    // 1：新規の場合：キャンセル申込日付が空のもの
                    sql += " and v_web_yoyaku.cancel_reqdt is null ";
                    break;
                case 2:
                    // 2：キャンセルの場合：キャンセル申込日付にデータがあるもの
                    sql += " and v_web_yoyaku.cancel_reqdt is not null ";
                    break;
            }

            return sql;
        }

        /// <summary>
        /// web予約一覧検索用条件節作成
        /// </summary>
        /// <param name="param">キー及び更新値</param>
        /// <param name="key">検索キー</param>
        /// <returns>条件節</returns>
        private string CreateConditionForWebRsvList(ref Dictionary<string, object> param, string key)
        {
            string[] vntKey;        // 検索キーの集合
            string condition = "";  // 条件節の集合
            string buffer;          // 文字列バッファ
            int i;                  // インデックス

            // 引数未設定時は何もしない
            if (key.Equals(""))
            {
                return null;
            }

            // 検索キー中の半角カナを全角カナに変換する
            buffer = WebHains.StrConvKanaWide(key);

            // 検索キー中の小文字を大文字に変換する
            buffer = buffer.ToUpper();

            // 全角空白を半角空白に置換する
            buffer = buffer.Replace("　", " ");

            // 2バイト以上の半角空白文字が存在しなくなるまで置換を繰り返す
            while (true)
            {
                if (buffer.IndexOf("  ", StringComparison.Ordinal) == 0)
                {
                    break;
                }
                buffer = buffer.Replace("  ", " ");
            }

            // 文字列の分割
            vntKey = buffer.Split(' ');

            // 検索キー数分の条件節を追加
            for (i = 0; i <= vntKey.Length; i++)
            {
                // 全角文字が含まれる(半角カナもここに含まれる)
                if (personDao.IsWide(vntKey[i]))
                {
                    AppendCondition_Wide(ref param, ref condition, vntKey[i], i);
                }
                // 性別
                else if (personDao.IsGender(vntKey[i]))
                {
                    AppendCondition_Gender(ref param, ref condition, vntKey[i], i);
                }
                // 個人ID
                else if (personDao.IsPerId(vntKey[i]))
                {
                    AppendCondition_PerId(ref param, ref condition, vntKey[i], i);
                }
                // 生年月日
                else if (personDao.IsBirth(vntKey[i]))
                {
                    AppendCondition_Birth(ref param, ref condition, vntKey[i], i);
                }
                // 上記以外は個人IDとして検索
                else
                {
                    AppendCondition_PerId(ref param, ref condition, vntKey[i], i);
                }
            }

            // すべての条件節をANDで連結
            return condition;
        }

        /// <summary>
        /// バインド変数値の編集
        /// </summary>
        /// <param name="code">各種コード</param>
        /// <param name="editFlg">修正区分</param>
        /// <param name="vntCode">各種コード</param>
        /// <param name="vntEditFlg">修正区分</param>
        private void EditBindArray(ref List<object> code, ref List<object> editFlg, ref object[] vntCode, ref object[] vntEditFlg)
        {
            // 編集値自体が存在しない場合は何もしない
            if (vntCode == null || vntEditFlg == null)
            {
                return;
            }

            // 編集値が配列でない場合は添字の０番目に編集
            if (!(vntCode is Array))
            {
                code[0] = vntCode;
                editFlg[0] = vntEditFlg;
                return;
            }

            // 配列数分の編集
            for (int i = 0; i <= vntCode.Length; i++)
            {
                code[i] = vntCode[i];
                editFlg[i] = vntEditFlg[i];
            }
        }

        /// <summary>
        /// 引数値の要素数を取得
        /// </summary>
        /// <param name="value">任意のVariant値</param>
        /// <returns>要素数</returns>
        private int GetElementCount(List<string> value)
        {
            int count;  // 要素数

            while (true)
            {
                // オプションコード未指定時はZERO
                if (value == null)
                {
                    count = 0;
                    return count;
                }

                // 配列形式でない場合は1
                if (!value.GetType().Name.Contains("List"))
                {
                    count = 1;
                    return count;
                }

                // 配列形式の場合は要素数とする
                count = value.Count;

                break;
            }

            return count;
        }

        /// <summary>
        /// 2文字以上の全角空白が連結している場合、存在しなくなるまで置換を繰り返す
        /// </summary>
        /// <param name="expression">文字列</param>
        /// <returns>空白オミット後の文字列</returns>
        private string OmitWideSpace(string expression)
        {
            string buffer;  // 文字列バッファ

            buffer = expression;

            // 2文字以上の全角空白が連結している場合、存在しなくなるまで置換を繰り返す
            while (true)
            {
                if (buffer.IndexOf("　　", StringComparison.Ordinal) == 0)
                {
                    break;
                }
                buffer = buffer.Replace("　　", "　");
            }

            // 戻り値の設定
            return buffer;
        }

        /// <summary>
        /// 出力順に対応するORDER BY句の取得
        /// </summary>
        /// <param name="order">出力順(1:受診日順、2:個人ID順)</param>
        /// <returns>ORDER BY句</returns>
        private string OrderByStatement(int order)
        {
            string orderBy = "";  // ORDER BY句

            // ORDER BY項目の設定
            switch (order)
            {
                case 1:  // 受診日順

                    orderBy = "order by v_web_yoyaku.jdate, v_web_yoyaku.ukaitm nulls first, v_web_yoyaku.karno nulls first";
                    break;

                case 2:  // 個人ID順

                    orderBy = "order by v_web_yoyaku.karno nulls first, v_web_yoyaku.jdate, v_web_yoyaku.ukaitm nulls first";
                    break;
            }

            // 戻り値の設定
            return orderBy;
        }

        /// <summary>
        /// web予約情報登録
        /// </summary>
        /// <param name="cslDate">受診年月日</param>
        /// <param name="webNo">webNo.</param>
        /// <param name="updUser">更新者</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="rsvGrpCd">予約群コード</param>
        /// <param name="perId">個人ID</param>
        /// <param name="lastName">姓</param>
        /// <param name="firstName">名</param>
        /// <param name="lastKName">カナ姓</param>
        /// <param name="firstKName">カナ名</param>
        /// <param name="gender">性別</param>
        /// <param name="birth">生年月日</param>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="age">受診時年齢</param>
        /// <param name="cslDivCd">受診区分コード</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="romeName">ローマ字名</param>
        /// <param name="addrDiv">住所区分</param>
        /// <param name="zipCd">郵便番号</param>
        /// <param name="prefCd">都道府県コード</param>
        /// <param name="cityName">市区町村名</param>
        /// <param name="address1">住所１</param>
        /// <param name="address2">住所２</param>
        /// <param name="tel1">電話番号1</param>
        /// <param name="phone">携帯番号</param>
        /// <param name="email">e-Mail</param>
        /// <param name="rsvStatus">予約状況</param>
        /// <param name="prtOnSave">保存時印刷</param>
        /// <param name="cardAddrDiv">確認はがき宛先</param>
        /// <param name="cardOutEng">確認はがき英文出力</param>
        /// <param name="formAddrDiv">一式書式宛先</param>
        /// <param name="formOutEng">一式書式英文出力</param>
        /// <param name="reportAddrDiv">成績書宛先</param>
        /// <param name="reportOutEng">成績書英文出力</param>
        /// <param name="volunteer">ボランティア</param>
        /// <param name="volunteerName">ボランティア名</param>
        /// <param name="collectTicket">利用券回収</param>
        /// <param name="issueCslTicket">診察券発行</param>
        /// <param name="billPrint">請求書出力</param>
        /// <param name="isrSign">保険証記号</param>
        /// <param name="isrNo">保険証番号</param>
        /// <param name="isrManNo">保険者番号</param>
        /// <param name="empNo">社員番号</param>
        /// <param name="introductor">紹介者</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <param name="ignoreFlg">強制登録フラグ</param>
        /// <param name="message">メッセージ</param>
        /// <returns>予約番号</returns>
        public int Regist(DateTime cslDate, int webNo, string updUser,
            string csCd, int rsvGrpCd, string perId, string lastName, string firstName,
            string lastKName, string firstKName, int gender, DateTime birth, string orgCd1,
            string orgCd2, string age, string cslDivCd, int ctrPtCd, string romeName,
            List<string> addrDiv, List<string> zipCd, List<string> prefCd, List<string> cityName,
            List<string> address1, List<string> address2, List<string> tel1, List<string> phone, List<string> email,
            int rsvStatus, int prtOnSave, string cardAddrDiv, int cardOutEng, string formAddrDiv,
            int formOutEng, string reportAddrDiv, int reportOutEng, string volunteer, string volunteerName,
            string collectTicket, string issueCslTicket, string billPrint, string isrSign, string isrNo,
            string isrManNo, string empNo, string introductor, List<string> optCd,
            List<string> optBranchNo, int ignoreFlg, ref List<string> message)
        {
            string sql;                      // SQLステートメント
            int arraySize;                   // バインド配列のサイズ
            int count;                       // オプション検査数

            using (var cmd = new OracleCommand())
            {
                // キー及び更新値の設定開始
                cmd.Parameters.Add("csldate", OracleDbType.Date, cslDate, ParameterDirection.Input);
                cmd.Parameters.Add("webno", OracleDbType.Int32, cslDate, ParameterDirection.Input);
                cmd.Parameters.Add("upduser", OracleDbType.NVarchar2, updUser, ParameterDirection.Input);
                cmd.Parameters.Add("cscd", OracleDbType.NVarchar2, csCd, ParameterDirection.Input);
                cmd.Parameters.Add("rsvgrpcd", OracleDbType.Int32, rsvGrpCd, ParameterDirection.Input);
                cmd.Parameters.Add("perid", OracleDbType.NVarchar2, perId, ParameterDirection.Input);
                cmd.Parameters.Add("lastname", OracleDbType.NVarchar2, lastName, ParameterDirection.Input);
                cmd.Parameters.Add("firstname", OracleDbType.NVarchar2, firstName, ParameterDirection.Input);
                cmd.Parameters.Add("lastkname", OracleDbType.NVarchar2, lastKName, ParameterDirection.Input);
                cmd.Parameters.Add("firstkname", OracleDbType.NVarchar2, firstKName, ParameterDirection.Input);
                cmd.Parameters.Add("gender", OracleDbType.Int32, gender, ParameterDirection.Input);
                cmd.Parameters.Add("birth", OracleDbType.Date, birth, ParameterDirection.Input);
                cmd.Parameters.Add("orgcd1", OracleDbType.NVarchar2, orgCd1, ParameterDirection.Input);
                cmd.Parameters.Add("orgcd2", OracleDbType.NVarchar2, orgCd2, ParameterDirection.Input);
                cmd.Parameters.Add("age", OracleDbType.Int32, age, ParameterDirection.Input);
                cmd.Parameters.Add("csldivcd", OracleDbType.NVarchar2, cslDivCd, ParameterDirection.Input);
                cmd.Parameters.Add("ctrptcd", OracleDbType.Int32, ctrPtCd, ParameterDirection.Input);
                cmd.Parameters.Add("romename", OracleDbType.NVarchar2, romeName, ParameterDirection.Input);

                // 個人住所情報のバインド配列定義
                arraySize = addrDiv.Count;
                OracleParameter objAddrDiv = cmd.Parameters.AddTable("addrdiv", addrDiv.ToArray(), ParameterDirection.Input, OracleDbType.Int32, arraySize, 0);
                OracleParameter objZipCd = cmd.Parameters.AddTable("zipcd", zipCd.ToArray(), ParameterDirection.Input, OracleDbType.NVarchar2, arraySize, 7);
                OracleParameter objPrefCd = cmd.Parameters.AddTable("prefcd", prefCd.ToArray(), ParameterDirection.Input, OracleDbType.NVarchar2, arraySize, 2);
                OracleParameter objCityName = cmd.Parameters.AddTable("cityname", cityName.ToArray(), ParameterDirection.Input, OracleDbType.NVarchar2, arraySize, (int)LengthConstants.LENGTH_CITYNAME);
                OracleParameter objAddress1 = cmd.Parameters.AddTable("address1", address1.ToArray(), ParameterDirection.Input, OracleDbType.NVarchar2, arraySize, (int)LengthConstants.LENGTH_CITYNAME);
                OracleParameter objAddress2 = cmd.Parameters.AddTable("address2", address2.ToArray(), ParameterDirection.Input, OracleDbType.NVarchar2, arraySize, (int)LengthConstants.LENGTH_CITYNAME);
                OracleParameter objTel1 = cmd.Parameters.AddTable("tel1", tel1.ToArray(), ParameterDirection.Input, OracleDbType.NVarchar2, arraySize, 15);
                OracleParameter objPhone = cmd.Parameters.AddTable("phone", phone.ToArray(), ParameterDirection.Input, OracleDbType.NVarchar2, arraySize, 15);
                OracleParameter objEMail = cmd.Parameters.AddTable("email", email.ToArray(), ParameterDirection.Input, OracleDbType.NVarchar2, arraySize, (int)LengthConstants.LENGTH_EMAIL);

                // 受診付属情報
                OracleParameter objRsvStatus = cmd.Parameters.Add("rsvstatus", OracleDbType.Int32, rsvStatus, ParameterDirection.Input);
                OracleParameter objPrtOnSave = cmd.Parameters.Add("prtonsave", OracleDbType.Int32, !cardAddrDiv.Equals("") ? "0" + cardAddrDiv : null, ParameterDirection.Input);
                OracleParameter objCardAddrDiv = cmd.Parameters.Add("cardaddrdiv", OracleDbType.Int32, !cardAddrDiv.Equals("") ? "0" + cardAddrDiv : null, ParameterDirection.Input);
                OracleParameter objCardOutEng = cmd.Parameters.Add("cardouteng", OracleDbType.Int32, cardOutEng, ParameterDirection.Input);
                OracleParameter objFormAddrDiv = cmd.Parameters.Add("formaddrdiv", OracleDbType.Int32, !formAddrDiv.Equals("") ? "0" + formAddrDiv : null, ParameterDirection.Input);
                OracleParameter objFormOutEng = cmd.Parameters.Add("formouteng", OracleDbType.Int32, formOutEng, ParameterDirection.Input);
                OracleParameter objReportAddrDiv = cmd.Parameters.Add("reportaddrdiv", OracleDbType.Int32, !reportAddrDiv.Equals("") ? "0" + reportAddrDiv : null, ParameterDirection.Input);
                OracleParameter objReportOutEng = cmd.Parameters.Add("reportouteng", OracleDbType.Int32, !reportOutEng.Equals("") ? "0" + reportOutEng : null, ParameterDirection.Input);
                OracleParameter objVolunteer = cmd.Parameters.Add("volunteer", OracleDbType.Int32, !volunteer.Equals("") ? "0" + volunteer : null, ParameterDirection.Input);
                OracleParameter objVolunteerName = cmd.Parameters.Add("volunteername", OracleDbType.NVarchar2, Strings.StrConv(volunteerName, VbStrConv.Wide), ParameterDirection.Input);
                OracleParameter objCollectTicket = cmd.Parameters.Add("collectticket", OracleDbType.Int32, !collectTicket.Equals("") ? "0" + collectTicket : null, ParameterDirection.Input);
                OracleParameter objIssueCslTicket = cmd.Parameters.Add("issuecslticket", OracleDbType.Int32, !issueCslTicket.Equals("") ? "0" + issueCslTicket : null, ParameterDirection.Input);
                OracleParameter objBillPrint = cmd.Parameters.Add("billprint", OracleDbType.Int32, !billPrint.Equals("") ? "0" + billPrint : null, ParameterDirection.Input);
                OracleParameter objIsrSign = cmd.Parameters.Add("isrsign", OracleDbType.NVarchar2, isrSign, ParameterDirection.Input);
                OracleParameter objIsrNo = cmd.Parameters.Add("isrno", OracleDbType.NVarchar2, isrNo, ParameterDirection.Input);
                OracleParameter objIsrManNo = cmd.Parameters.Add("isrmanno", OracleDbType.NVarchar2, isrManNo, ParameterDirection.Input);
                OracleParameter objEmpNo = cmd.Parameters.Add("empno", OracleDbType.NVarchar2, empNo, ParameterDirection.Input);
                OracleParameter objIntroductor = cmd.Parameters.Add("introductor", OracleDbType.NVarchar2, introductor, ParameterDirection.Input);

                // オプション数の取得
                count = GetElementCount(optCd);

                // オプション検査のバインド変数定義
                arraySize = count < 1 ? 1 : count;
                OracleParameter objOptCd = cmd.Parameters.AddTable("optcd", optCd.ToArray(), ParameterDirection.Input, OracleDbType.NVarchar2, arraySize, 4);
                OracleParameter objOptBranchNo = cmd.Parameters.AddTable("optbranchno", optBranchNo.ToArray(), ParameterDirection.Input, OracleDbType.Int32, arraySize, 2);
                OracleParameter objCount = cmd.Parameters.Add("optcount", OracleDbType.Int32, count, ParameterDirection.Input);

                // 強制登録フラグ
                OracleParameter objIgnoreFlg = cmd.Parameters.Add("ignoreflg", OracleDbType.Int32, ignoreFlg, ParameterDirection.Input);


                // 戻り値(予約番号・メッセージ)のバインド変数定義
                OracleParameter objMessage = cmd.Parameters.Add("message", OracleDbType.NVarchar2, "", ParameterDirection.Output);
                OracleParameter objRet = cmd.Parameters.Add("ret", OracleDbType.Int32, 0, ParameterDirection.Output);

                using (var transaction = BeginTransaction())
                {
                    // web予約情報登録用ストアド呼び出し
                    sql = "begin   :ret := WebReservePackage.Regist( ";

                    sql += @"
                            :csldate
                            , :webno
                            , :upduser
                            , :cscd
                            , :rsvgrpcd
                            , :perid
                            , :lastname
                            , :firstname
                            , :lastkname
                            , :firstkname
                            , :gender
                            , :birth
                            , :orgcd1
                            , :orgcd2
                            , :age
                            , :csldivcd
                            , :ctrptcd
                            , :romename
                            , :addrdiv
                            , :zipcd
                            , :prefcd
                            , :cityname
                            , :address1
                            , :address2
                            , :tel1
                            , :phone
                            , :email
                            , :rsvstatus
                            , :prtonsave
                            , :cardaddrdiv
                            , :cardouteng
                            , :formaddrdiv
                            , :formouteng
                            , :reportaddrdiv
                            , :reportouteng
                            , :volunteer
                            , :volunteername
                            , :collectticket
                            , :issuecslticket
                            , :billprint
                            , :isrsign
                            , :isrno
                            , :isrmanno
                            , :empno
                            , :introductor
                            , :optcd
                            , :optbranchno
                            , :optcount
                            , :ignoreflg
                            , :message);
                            end;
                     ";

                    // PL/SQL文の実行
                    ExecuteNonQuery(cmd, sql);

                    // 戻り値の取得
                    message = ((OracleString[])objMessage.Value).Select(s => s.Value).ToList();
                    int ret = (int)(OracleDecimal)objRet.Value;

                    // トランザクション制御
                    if (ret > 0)
                    {
                        transaction.Commit();
                    }
                    else
                    {
                        transaction.Rollback();
                    }

                    // 戻り値の設定
                    return ret;
                }
            }

        }

        /// <summary>
        /// 指定受診日、webNoのweb予約情報を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="webNo">webNo.</param>
        /// <returns>
        /// regFlg        本登録フラグ
        /// csCd          コースコード
        /// rsvGrpCd      予約群コード
        /// perId         個人ID
        /// fullName      姓名
        /// kanaName      カナ姓名
        /// lastName      (個人情報の)姓
        /// firstName     (個人情報の)名
        /// lastKName     (個人情報の)カナ姓
        /// firstKName    (個人情報の)カナ名
        /// gender        性別
        /// birth         生年月日
        /// zipNo         郵便番号
        /// address1      住所1
        /// address2      住所2
        /// address3      住所3
        /// tel           電話番号
        /// eMail         e-mail
        /// officeName    勤務先名称
        /// officeTel     勤務先電話番号
        /// orgName       契約団体名
        /// rsvDiv        申し込み区分(1:一般、2:契約団体(健康保険組合または会社等)、3:健康保険組合連合会)
        /// supportDiv    本人家族区分(1:本人(被保険者)、2:家族(被扶養者))
        /// optionStomac  胃検査(0:胃なし、1:胃X線、2:胃内視鏡)
        /// optionBreast  乳房検査(0:乳房なし、1:乳房X線、2:乳房超音波、3:乳房X線＋乳房超音波)
        /// message       メッセージ
        /// insDate       申し込み年月日
        /// updDate       予約処理年月日
        /// rsvNo         予約番号
        /// isrSign       保険書記号
        /// isrNo         保険書番号
        /// volunteer     ボランティア区分(0:利用なし、1:通訳要、2:介護要、3:通訳＆介護要、4:車椅子要)
        /// cardOutEng    確認はがき英文出力(0:なし、1:あり)
        /// formOutEng    一式英文出力(0:なし、1:あり)
        /// reportOutEng  成績書英文出力(0:なし、1:あり)
        /// optionCT      胸部検査(1:胸部X線、2:胸部CT)
        /// canDate       キャンセル年月日
        /// nation        国籍
        /// cslOptions    受診オプション
        /// </returns>
        public dynamic SelectWebRsv(DateTime cslDate, int webNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            param.Add("webno", webNo);

            // 検索条件を満たすweb予約情報テーブルのレコードを取得
            string sql = @"
                           select
                             v_web_yoyaku.ykbn regflg
                             , v_web_yoyaku.cscd
                             , csrsvgrp.rsvgrpcd
                             , v_web_yoyaku.karno perid
                             , to_zenkaku(v_web_yoyaku.namej) fullname
                             , to_zenkaku(v_web_yoyaku.namea) kananame
                             , person.lastname
                             , person.firstname
                             , person.lastkname
                             , person.firstkname
                             , v_web_yoyaku.sexflg gender
                             , v_web_yoyaku.birth
                             , v_web_yoyaku.zipno
                             , v_web_yoyaku.adrs1 address1
                             , v_web_yoyaku.adrs2 address2
                             , v_web_yoyaku.adrs3 address3
                             , v_web_yoyaku.telno tel
                             , v_web_yoyaku.email
                             , v_web_yoyaku.knmnm officename
                             , v_web_yoyaku.telno2 officetel
                             , v_web_yoyaku.grpname orgname
                             , v_web_yoyaku.mkbn rsvdiv
                             , v_web_yoyaku.hnkzkbn supportdiv
                             ,
                        ";

            // 胃検査コースオプションのフラグ変換
            sql += " decode(v_web_yoyaku.cscdoption1, '" + CSCSOPTION1_STOMAC_XRAY + "', 1, '" + CSCSOPTION1_STOMAC_CAMERA + "', 2, 0 ) optionstomac, ";

            // 胸部検査コースのフラグ変換
            sql += " decode(v_web_yoyaku.cscdoption2, '" + CSCSOPTION2_CHEST_XRAY + "', 1, '" + CSCSOPTION2_CHEST_CT + "', 2, 0 ) optionchest, ";

            // 乳房検査コースオプションのフラグ変換
            sql += " decode(v_web_yoyaku.cscdoption3, '" + CSCSOPTION3_BREAST_XRAY + "', 1, '" + CSCSOPTION3_BREAST_ECHO + "', 2, '" + CSCSOPTION3_BREAST_XRAY_ECHO + "', 3, 0 ) optionbreast, ";

            sql += @"
                    v_web_yoyaku.msg message
                    , v_web_yoyaku.insertdate insdate
                    , v_web_yoyaku.cancel_reqdt candate
                    , v_web_yoyaku.updatedate upddate
                    , web_relation.rsvno
                    , v_web_yoyaku.isrsign isrsign
                    , v_web_yoyaku.isrno isrno
                    , v_web_yoyaku.volunteer volunteer
                    , v_web_yoyaku.cardouteng cardouteng
                    , v_web_yoyaku.formouteng formouteng
                    , v_web_yoyaku.reportouteng reportouteng
                    , v_web_yoyaku.nation nation
                    , v_web_yoyaku.op_concat csloptions
                    , v_web_yoyaku.webreqno webreqno
                    from
                      (
                        select
                          course_rsvgrp.cscd
                          , course_rsvgrp.rsvgrpcd
                          , rsvgrp.strtime
                        from
                          rsvgrp
                          , course_rsvgrp
                        where
                          course_rsvgrp.rsvgrpcd = rsvgrp.rsvgrpcd
                      ) csrsvgrp
                      , web_relation
                      , person
                      , webreserve.v_web_yoyaku
                    where
                      v_web_yoyaku.jdate = :csldate
                      and v_web_yoyaku.webno = :webno
                      and v_web_yoyaku.karno = person.perid(+)
                      and v_web_yoyaku.jdate = web_relation.csldate(+)
                      and v_web_yoyaku.webno = web_relation.webno(+)
                      and v_web_yoyaku.cscd = csrsvgrp.cscd(+)
                      and v_web_yoyaku.ukaitm = csrsvgrp.strtime(+)
                  ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 指定検索条件のweb予約情報を取得する
        /// </summary>
        /// <param name="strCslDate">開始受診年月日</param>
        /// <param name="endCslDate">終了受診年月日</param>
        /// <param name="key">検索キー</param>
        /// <param name="strOpDate">開始処理年月日</param>
        /// <param name="endOpDate">終了処理年月日</param>
        /// <param name="opMode">処理モード(1:申込日で検索、2:予約処理日で検索)</param>
        /// <param name="regFlg">本登録フラグ(0:指定なし、1:未登録者、2:編集済み受診者)</param>
        /// <param name="moushiKbn">申込区分（0：すべて　1:新規　2:キャンセル）</param>
        /// <param name="order">出力順(1:受診日順、2:個人ID順)</param>
        /// <param name="startPos">取得開始位置</param>
        /// <param name="getCount">取得件数(0:全件)</param>
        /// <returns>
        /// cslDate     受診年月日
        /// webNo       webNo.
        /// startTime   受付開始時間
        /// rsvGrpName  予約群名称
        /// perId       個人ID
        /// fullName    姓名
        /// kanaName    カナ姓名
        /// lastName    (個人情報の)姓
        /// firstName   (個人情報の)名
        /// lastKName   (個人情報の)カナ姓
        /// firstKName  (個人情報の)カナ名
        /// gender      性別
        /// birth       生年月日
        /// orgName     団体名
        /// insDate     申し込み年月日
        /// canDate     キャンセル年月日
        /// updDate     予約処理年月日
        /// regFlg      本登録フラグ(1:未登録者、2:編集済み受診者)
        /// rsvNo       予約番号
        /// </returns>
        public List<dynamic> SelectWebRsvList(DateTime strCslDate, DateTime endCslDate, string key,
            DateTime strOpDate, DateTime endOpDate, int opMode, int regFlg,
            int moushiKbn, int order, int startPos = 1, int getCount = 0)
        {
            string sql = "";  // SQLステートメント
            string basedSql;  // 基本SQLステートメント
            int allCount;     // 全レコード件数

            // バインド変数の設定
            var param = new Dictionary<string, object>();
            param.Add("startpos", startPos);
            param.Add("endpos", startPos + getCount - 1);

            // 基本SQL作成
            basedSql = CreateBasedSqlForWebRsvList(ref param, strCslDate, endCslDate, key, strOpDate, endOpDate, opMode, regFlg, moushiKbn);

            while (true)
            {
                // ①全レコード件数取得
                dynamic current = connection.Query("select count(*) cnt from ( " + basedSql + " )", param).FirstOrDefault();
                allCount = current.CNT;

                // レコードが存在しない場合は終了
                if (allCount <= 0)
                {
                    break;
                }

                // SQLステートメントの編集
                sql = @"
                        select
                          webrsv.jdate csldate
                          , webrsv.webno
                          , webrsv.ukaitm starttime
                          , csrsvgrp.rsvgrpname
                          , webrsv.karno perid
                          , to_zenkaku(webrsv.namej) fullname
                          , to_zenkaku(webrsv.namea) kananame
                          , person.lastname
                          , person.firstname
                          , person.lastkname
                          , person.firstkname
                          , webrsv.sexflg gender
                          , webrsv.birth
                          , webrsv.grpname orgname
                          , trunc(webrsv.insertdate) insdate
                          , trunc(webrsv.cancel_reqdt) candate
                          , decode(webrsv.ykbn, 2, webrsv.updatedate, null) upddate
                          , webrsv.ykbn regflg
                          , web_relation.rsvno
                        from
                          web_relation
                          , person
                          , (
                            select
                              course_rsvgrp.cscd
                              , course_rsvgrp.rsvgrpcd
                              , rsvgrp.rsvgrpname
                              , rsvgrp.strtime
                            from
                              rsvgrp
                              , course_rsvgrp
                            where
                              course_rsvgrp.rsvgrpcd = rsvgrp.rsvgrpcd
                          ) csrsvgrp
                          , (
                            select
                              webrsv2.*
                            from
                              (select rownum seq, webrsv1.*
                     ";

                // 基本SQLにORDER BY句を追加
                sql += " from ( " + basedSql + " " + OrderByStatement(order) + " ) webrsv1";

                // 基本SQL＋ORDER BY句にSEQを付加
                sql += " ) webrsv2 ";

                // 開始位置、取得件数指定時は絞り込み
                if (startPos > 0 && getCount > 0)
                {
                    sql += " where seq between :startpos and :endpos ";
                }

                // 開始位置、終了位置による絞り込み
                sql += " ) webrsv ";

                sql += @"
                         where
                           webrsv.cscd = csrsvgrp.cscd(+)
                           and webrsv.ukaitm = csrsvgrp.strtime(+)
                           and webrsv.karno = person.perid(+)
                           and webrsv.jdate = web_relation.csldate(+)
                           and webrsv.webno = web_relation.webno(+)
                      ";

                // 申込区分による条件追加
                switch (moushiKbn)
                {
                    case 0:
                        // 0：すべての場合：条件なし
                        break;
                    case 1:
                        // 1：新規の場合：キャンセル申込日付が空のもの
                        sql += " and webrsv.cancel_reqdt is null ";
                        break;

                    case 2:
                        // 2：キャンセルの場合：キャンセル申込日付にデータがあるもの
                        sql += " and webrsv.cancel_reqdt is not null ";
                        break;
                }
                sql += " order by webrsv.seq ";

                break;
            }
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定検索条件のweb予約情報のうち、指定受診年月日、webNoの次レコードを取得
        /// </summary>
        /// <param name="strCslDate">開始受診年月日</param>
        /// <param name="endCslDate">終了受診年月日</param>
        /// <param name="key">検索キー</param>
        /// <param name="strOpDate">開始処理年月日</param>
        /// <param name="endOpDate">終了処理年月日</param>
        /// <param name="opMode">処理モード(1:申込日で検索、2:予約処理日で検索)</param>
        /// <param name="regFlg">本登録フラグ(0:指定なし、1:未登録者、2:編集済み受診者)</param>
        /// <param name="moushiKbn">申込区分（0：すべて　1:新規　2:キャンセル）</param>
        /// <param name="order">出力順(1:受診日順、2:個人ID順)</param>
        /// <param name="cslDate">受診年月日</param>
        /// <param name="webNo">webNo.</param>
        /// <returns>
        /// cslDate     (次レコードの)受診年月日
        /// webNo       (次レコードの)webNo.
        /// </returns>
        public dynamic SelectWebRsvNext(DateTime strCslDate, DateTime endCslDate, string key,
            DateTime strOpDate, DateTime endOpDate, int opMode, int regFlg,
            int moushiKbn, int order, DateTime cslDate, int webNo)
        {
            string sql = "";  // SQLステートメント
            string basedSql;  // 基本SQLステートメント

            var param = new Dictionary<string, object>();
            param.Add("csldate", strCslDate);
            param.Add("webno", webNo);

            // 基本SQL作成
            basedSql = CreateBasedSqlForWebRsvList(ref param, strCslDate, endCslDate, key, strOpDate, endOpDate, opMode, regFlg, moushiKbn);

            // SQLステートメントの編集
            sql = @"
                    select
                      webrsv.nextcsldate
                      , webrsv.nextwebno
                    from
                      (
                        select
                          lag(webrsv2.jdate, 1, null) over (order by webrsv2.seq desc) nextcsldate
                          , lag(webrsv2.webno, 1, null) over (order by webrsv2.seq desc) nextwebno
                          , webrsv2.jdate
                          , webrsv2.webno
                        from
                          (select rownum seq, webrsv1.*
                 ";

            // 基本SQLにORDER BY句を追加
            sql += " from ( " + basedSql + " " + OrderByStatement(order) + " ) webrsv1 ";

            // 基本SQL＋ORDER BY句にSEQを付加
            sql += " ) webrsv2 ";

            // 分析関数LAGを使用し、自レコードの次SEQ値のレコードを付加
            sql += " ) webrsv ";

            // 指定受診年月日、webNoのレコードのみを取得、但し次SEQのレコードが存在しない(最終レコード)ものは除く
            sql += @"
                    where
                      webrsv.jdate = :csldate
                      and webrsv.webno = :webno
                      and webrsv.nextcsldate is not null
                      and webrsv.nextwebno is not null
                 ";

            return connection.Query(sql, param).FirstOrDefault();
        }
    }
}