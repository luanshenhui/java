using Dapper;
using Entity.Helper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity.Model.WebOrgRsv;
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
    /// web団体予約用データアクセスオブジェクト
    /// </summary>
    public class WebOrgRsvDao : AbstractDao
    {
        private const string PREFIX_PERID = "ID:";                   // 検索時の個人ＩＤ指定
        private const string PREFIX_BIRTH = "BIRTH:";                // 検索時の生年月日指定
        private const string PREFIX_GENDER = "GENDER:";              // 検索時の性別指定

        private const string CSCSOPTION1_STOMAC_XRAY = "W001";       // 胃検査オプション(胃X線)
        private const string CSCSOPTION1_STOMAC_CAMERA = "W002";     // 胃検査オプション(胃内視鏡)

        private const string CSCSOPTION3_BREAST_XRAY = "W005";       // 乳房検査オプション(乳房X線)
        private const string CSCSOPTION3_BREAST_ECHO = "W006";       // 乳房検査オプション(乳房超音波)
        private const string CSCSOPTION3_BREAST_XRAY_ECHO = "W013";  // 乳房検査オプション(乳房X線＋乳房超音波)

        /// <summary>
        /// 個人情報データアクセスオブジェクト
        /// </summary>
        readonly PersonDao personDao;

        /// <summary>
        /// 受診情報データアクセスオブジェクト
        /// </summary>
        readonly ConsultDao consultDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        /// <param name="personDao">個人情報データアクセスオブジェクト</param>
        /// <param name="consultDao">受診情報データアクセスオブジェクト</param>
        public WebOrgRsvDao(IDbConnection connection, PersonDao personDao, ConsultDao consultDao) : base(connection)
        {
            this.personDao = personDao;
            this.consultDao = consultDao;
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
            if (buffer.Length > PREFIX_BIRTH.Length && buffer.Substring(0, PREFIX_BIRTH.Length).ToUpper().Equals(PREFIX_BIRTH))
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
            sql = " and v_web_yoyaku_dantai.birth = :" + paramName;

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
            if (buffer.Length > PREFIX_GENDER.Length && buffer.Substring(0, PREFIX_GENDER.Length).ToUpper().Equals(PREFIX_GENDER))
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
            sql = " and v_web_yoyaku_dantai.gender = :" + paramName;

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
            if (buffer.Length > PREFIX_PERID.Length && buffer.Substring(0, PREFIX_PERID.Length).ToUpper().Equals(PREFIX_PERID))
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
                sql = " and v_web_yoyaku_dantai.perno like :" + paramName;
            }
            else
            {
                // さもなければ直接指定
                param.Add(paramName, perId);
                sql = " and v_web_yoyaku_dantai.perno = :" + paramName;
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
                sql = " and v_web_yoyaku_dantai.namej like :" + paramName;
            }
            else
            {
                // カナのみの場合
                sql = " and to_zenkaku(v_web_yoyaku_dantai.namea) like :" + paramName;
            }

            // 配列に追加
            condition += sql;
        }

        /// <summary>
        /// web予約一覧(団体向け)検索用基本SQL作成
        /// </summary>
        /// <param name="param">キー及び更新値</param>
        /// <param name="strCslDate">開始受診年月日</param>
        /// <param name="endCslDate">終了受診年月日</param>
        /// <param name="key">検索キー</param>
        /// <param name="strOpDate">開始処理年月日</param>
        /// <param name="endOpDate">終了処理年月日</param>
        /// <param name="orgCd1">受診団体コード1</param>
        /// <param name="orgCd2">受診団体コード2</param>
        /// <param name="opMode">処理モード(1:申込日で検索、2:予約処理日で検索)</param>
        /// <param name="regFlg">本登録フラグ(0:指定なし、1:未登録者、2:編集済み受診者)</param>
        /// <param name="moushiKbn">申込区分（0：すべて　1:新規　2:キャンセル）</param>
        /// <returns>SQLステートメント</returns>
        private string CreateBasedSqlForWebOrgRsvList(ref Dictionary<string, object> param, DateTime strCslDate, DateTime endCslDate, string key, DateTime? strOpDate, DateTime? endOpDate, string orgCd1, string orgCd2, int opMode, int regFlg, int moushiKbn)
        {
            string sql;     // SQLステートメント
            DateTime? wkOpDate;  // 日付比較時退避用
            DateTime wkCslDate;  // 日付比較時退避用

            // 受診年月日について日付範囲順逆逆転時は値を交換
            if (strCslDate > endCslDate)
            {
                wkCslDate = strCslDate;
                strCslDate = endCslDate;
                endCslDate = wkCslDate;
            }

            // 処理年月日について日付範囲順逆逆転時は値を交換
            if (strOpDate > endOpDate)
            {
                wkOpDate = strOpDate;
                strOpDate = endOpDate;
                endOpDate = wkOpDate;
            }

            // キー及び更新値の設定
            param.Add("strcsldate", strCslDate);
            param.Add("endcsldate", endCslDate.AddDays(1));
            param.Add("stropdate", strOpDate);
            if (endOpDate != null) {
                param.Add("endopdate", Convert.ToDateTime(endOpDate).AddDays(1));
            }
            param.Add("regflg", regFlg.ToString());
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);

            // 基本SQLステートメントの編集開始
            sql = @"
                    select
                      *
                    from
                      webreserve.v_web_yoyaku_dantai
                    where
                      v_web_yoyaku_dantai.csldate >= :strcsldate
                      and v_web_yoyaku_dantai.csldate < :endcsldate
                 ";

            // 団体指定時は条件追加
            if (!"".Equals(orgCd1) && !"".Equals(orgCd2))
            {
                sql += @"
                        and v_web_yoyaku_dantai.orgcd1 = :orgcd1
                        and v_web_yoyaku_dantai.orgcd2 = :orgcd2
                     ";
            }

            // 検索キー指定時は条件追加
            if (key != null && !"".Equals(key))
            {
                sql += CreateConditionForWebOrgRsvList(ref param, key);
            }

            // 処理年月日指定時は条件追加
            if (strOpDate != null || endOpDate != null)
            {
                switch (opMode)
                {
                    case 1:  // 申込日で検索

                        sql += @"
                                and v_web_yoyaku_dantai.insertdate >= :stropdate
                                and v_web_yoyaku_dantai.insertdate < :endopdate
                             ";
                        break;

                    case 2:  // 予約処理日で検索

                        sql += @"
                                and v_web_yoyaku_dantai.updatedate >= :stropdate
                                and v_web_yoyaku_dantai.updatedate < :endopdate
                                and v_web_yoyaku_dantai.ykbn = 2
                             ";
                        break;
                }
            }

            // 状態指定時は条件追加
            if (regFlg > 0)
            {
                sql += " and v_web_yoyaku_dantai.ykbn = :regflg ";
            }

            // 申込区分による条件追加
            switch (moushiKbn)
            {
                case 0:
                    // 0：すべての場合：条件なし
                    break;

                case 1:
                    // 1：新規の場合：キャンセル申込日付が空のもの
                    sql += " and v_web_yoyaku_dantai.cancel_reqdt is null ";
                    break;
                case 2:
                    // 2：キャンセルの場合：キャンセル申込日付にデータがあるもの
                    sql += " and v_web_yoyaku_dantai.cancel_reqdt is not null ";
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
        private string CreateConditionForWebOrgRsvList(ref Dictionary<string, object> param, string key)
        {
            string[] vntKey;        // 検索キーの集合
            string condition = "";  // 条件節の集合
            string buffer;          // 文字列バッファ
            int i;                  // インデックス

            // 引数未設定時は何もしない
            if (string.IsNullOrEmpty(key))
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
                if (buffer.IndexOf("  ") < 0)
                {
                    break;
                }
                buffer = buffer.Replace("  ", " ");
            }

            // 文字列の分割
            vntKey = buffer.Split(' ');

            // 検索キー数分の条件節を追加
            for (i = 0; i < vntKey.Length; i++)
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
                    break;
                }

                // 配列形式でない場合は1
                if (!value.GetType().Name.Contains("List"))
                {
                    count = 1;
                    break;
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

                    orderBy = "order by v_web_yoyaku_dantai.csldate, v_web_yoyaku_dantai.rsvtime nulls first, v_web_yoyaku_dantai.perno nulls first";
                    break;

                case 2:  // 個人ID順

                    orderBy = "order by v_web_yoyaku_dantai.perno nulls first, v_web_yoyaku_dantai.csldate, v_web_yoyaku_dantai.rsvtime nulls first";
                    break;
            }

            // 戻り値の設定
            return orderBy;
        }

        /// <summary>
        /// web予約情報登録
        /// </summary>
        /// <param name="data">web予約情報</param>
        /// <param name="message">メッセージ</param>
        /// <returns>予約番号</returns>
        public int Regist(WebOrgRsvNavi data, ref String message)
        {
            string sql;                      // SQLステートメント
            int arraySize;                   // バインド配列のサイズ
            int count;                       // オプション検査数

            using (var cmd = new OracleCommand())
            {
                // キー及び更新値の設定開始
                cmd.Parameters.Add("csldate", OracleDbType.Date, data.CslDate, ParameterDirection.Input);
                cmd.Parameters.Add("webno", OracleDbType.Int32, data.WebNo, ParameterDirection.Input);
                cmd.Parameters.Add("upduser", OracleDbType.Varchar2, data.UpdUser, ParameterDirection.Input);
                cmd.Parameters.Add("cscd", OracleDbType.Varchar2, data.CsCd, ParameterDirection.Input);
                cmd.Parameters.Add("rsvgrpcd", OracleDbType.Int32, data.RsvGrpCd, ParameterDirection.Input);
                cmd.Parameters.Add("perid", OracleDbType.Varchar2, data.PerId, ParameterDirection.Input);
                cmd.Parameters.Add("lastname", OracleDbType.Varchar2, data.LastName, ParameterDirection.Input);
                cmd.Parameters.Add("firstname", OracleDbType.Varchar2, data.FirstName, ParameterDirection.Input);
                cmd.Parameters.Add("lastkname", OracleDbType.Varchar2, data.LastKName, ParameterDirection.Input);
                cmd.Parameters.Add("firstkname", OracleDbType.Varchar2, data.FirstKName, ParameterDirection.Input);
                cmd.Parameters.Add("gender", OracleDbType.Int32, data.Gender, ParameterDirection.Input);
                cmd.Parameters.Add("birth", OracleDbType.Date, data.Birth, ParameterDirection.Input);
                cmd.Parameters.Add("orgcd1", OracleDbType.Varchar2, data.OrgCd1, ParameterDirection.Input);
                cmd.Parameters.Add("orgcd2", OracleDbType.Varchar2, data.OrgCd2, ParameterDirection.Input);
                cmd.Parameters.Add("age", OracleDbType.Int32, data.Age, ParameterDirection.Input);
                cmd.Parameters.Add("csldivcd", OracleDbType.Varchar2, data.CslDivCd, ParameterDirection.Input);
                cmd.Parameters.Add("ctrptcd", OracleDbType.Int32, data.CtrPtCd, ParameterDirection.Input);
                cmd.Parameters.Add("romename", OracleDbType.Varchar2, data.RomeName, ParameterDirection.Input);
                cmd.Parameters.Add("nationcd", OracleDbType.Varchar2, data.NationCd, ParameterDirection.Input);

                // 個人住所情報のバインド配列定義
                arraySize = data.AddrDiv.Length;
                OracleParameter objAddrDiv = cmd.Parameters.AddTable("addrdiv", data.AddrDiv, ParameterDirection.Input, OracleDbType.Int32, arraySize, 1);
                OracleParameter objZipCd = cmd.Parameters.AddTable("zipcd", data.ZipCd, ParameterDirection.Input, OracleDbType.Varchar2, arraySize, 7);
                OracleParameter objPrefCd = cmd.Parameters.AddTable("prefcd", data.PrefCd, ParameterDirection.Input, OracleDbType.Varchar2, arraySize, 2);
                OracleParameter objCityName = cmd.Parameters.AddTable("cityname", data.CityName, ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_CITYNAME);
                OracleParameter objAddress1 = cmd.Parameters.AddTable("address1", data.Address1, ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_CITYNAME);
                OracleParameter objAddress2 = cmd.Parameters.AddTable("address2", data.Address2, ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_CITYNAME);
                OracleParameter objTel1 = cmd.Parameters.AddTable("tel1", data.Tel1, ParameterDirection.Input, OracleDbType.Varchar2, arraySize, 15);
                OracleParameter objPhone = cmd.Parameters.AddTable("phone", data.Phone, ParameterDirection.Input, OracleDbType.Varchar2, arraySize, 15);
                OracleParameter objEMail = cmd.Parameters.AddTable("email", data.Email, ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_EMAIL);

                // 受診付属情報
                OracleParameter objRsvStatus = cmd.Parameters.Add("rsvstatus", OracleDbType.Int32, data.RsvStatus, ParameterDirection.Input);
                OracleParameter objPrtOnSave = cmd.Parameters.Add("prtonsave", OracleDbType.Int32, data.PrtOnSave, ParameterDirection.Input);
                OracleParameter objCardAddrDiv = cmd.Parameters.Add("cardaddrdiv", OracleDbType.Int32, data.CardAddrDiv, ParameterDirection.Input);

                OracleParameter objCardOutEng = cmd.Parameters.Add("cardouteng", OracleDbType.Int32, data.CardOutEng, ParameterDirection.Input);
                OracleParameter objFormAddrDiv = cmd.Parameters.Add("formaddrdiv", OracleDbType.Int32, data.FormAddrDiv, ParameterDirection.Input);
                OracleParameter objFormOutEng = cmd.Parameters.Add("formouteng", OracleDbType.Int32, data.FormOutEng, ParameterDirection.Input);
                OracleParameter objReportAddrDiv = cmd.Parameters.Add("reportaddrdiv", OracleDbType.Int32, data.ReportAddrDiv, ParameterDirection.Input);
                OracleParameter objReportOutEng = cmd.Parameters.Add("reportouteng", OracleDbType.Int32, data.ReportOutEng, ParameterDirection.Input);
                OracleParameter objVolunteer = cmd.Parameters.Add("volunteer", OracleDbType.Int32, data.Volunteer, ParameterDirection.Input);
                OracleParameter objVolunteerName = cmd.Parameters.Add("volunteername", OracleDbType.NVarchar2, data.VolunteerName, ParameterDirection.Input);
                OracleParameter objCollectTicket = cmd.Parameters.Add("collectticket", OracleDbType.Int32, data.CollectTicket, ParameterDirection.Input);
                OracleParameter objIssuecslTicket = cmd.Parameters.Add("issuecslticket", OracleDbType.Int32, data.IssueCslTicket, ParameterDirection.Input);
                OracleParameter objBillPrint = cmd.Parameters.Add("billprint", OracleDbType.Int32, data.BillPrint, ParameterDirection.Input);
                OracleParameter objIsrSign = cmd.Parameters.Add("isrsign", OracleDbType.NVarchar2, data.IsrSign, ParameterDirection.Input);
                OracleParameter objIsrNo = cmd.Parameters.Add("isrno", OracleDbType.NVarchar2, data.IsrNo, ParameterDirection.Input);
                OracleParameter objIsrManNo = cmd.Parameters.Add("isrmanno", OracleDbType.NVarchar2, data.IsrManNo, ParameterDirection.Input);
                OracleParameter objEmpNo = cmd.Parameters.Add("empno", OracleDbType.NVarchar2, data.EmpNo, ParameterDirection.Input);
                OracleParameter objIntroductor = cmd.Parameters.Add("introductor", OracleDbType.NVarchar2, data.Introductor, ParameterDirection.Input);

                // オプション数の取得
                count = data.OptCd.Split(',').Length;

                // オプション検査のバインド変数定義
                arraySize = count < 1 ? 1 : count;

                var optCd = data.OptCd.Split(','); 
                var optBranchNo = data.OptBranchNo.Split(',');

                String[] arrOptCd = new String[optCd.Length];
                int[] arrOptBranchNo = new int[optBranchNo.Length];

                for (var i=0;i< optCd.Length;i++) {
                    arrOptCd[i]=optCd[i].ToString();
                }

                for (var i = 0; i < optBranchNo.Length; i++)
                {
                    arrOptBranchNo[i] = Convert.ToInt32(optBranchNo[i]);
                }

                OracleParameter objOptCd = cmd.Parameters.AddTable("optcd", arrOptCd, ParameterDirection.Input, OracleDbType.Varchar2, arraySize, 4);
                OracleParameter objOptBranchNo = cmd.Parameters.AddTable("optbranchno", arrOptBranchNo, ParameterDirection.Input, OracleDbType.Int32, arraySize, 2);
                OracleParameter objCount = cmd.Parameters.Add("optcount", OracleDbType.Int32, count, ParameterDirection.Input);

                // 強制登録フラグ
                 OracleParameter objIgnoreFlg = cmd.Parameters.Add("ignoreflg", OracleDbType.Int32, data.IgnoreFlg, ParameterDirection.Input);

                // 戻り値(予約番号・メッセージ)のバインド変数定義
                OracleParameter objMessage =
                cmd.Parameters.Add("message", OracleDbType.Varchar2, 1000,"" ,ParameterDirection.Output);
                //cmd.Parameters.Add("message", dbType: OracleDbType.Varchar2, direction: ParameterDirection.Output, 1000);
                OracleParameter objRet = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                using (var transaction = BeginTransaction())
                {
                    // web予約情報登録用ストアド呼び出し
                    sql = @"
                            begin   :ret := weborgreservepackage.regist( 
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
                            , :nationcd
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
                    int ret = (int)(OracleDecimal)objRet.Value;

                    // トランザクション制御
                    if (ret > 0)
                    {
                        transaction.Commit();
                    }
                    else
                    {
                        message = (String)(OracleString)objMessage.Value;
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
        /// romaName      ローマ字姓名
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
        /// orgCd1        契約団体コード1
        /// orgCd2        契約団体コード2
        /// orgName       契約団体名
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
        /// cRsvNo        キャンセル対象予約番号
        /// nation        国籍
        /// cslOptions    受診オプション
        /// </returns>
        public dynamic SelectWebOrgRsv(DateTime cslDate, int webNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            param.Add("webno", webNo);

            // 検索条件を満たすweb予約情報テーブルのレコードを取得
            string sql = @"
                            select
                              v_web_yoyaku_dantai.ykbn regflg
                              , v_web_yoyaku_dantai.cscd
                              , decode(
                                v_web_yoyaku_dantai.cscd
                                , '105'
                                , '20'
                                , csrsvgrp.rsvgrpcd
                              ) rsvgrpcd
                              , v_web_yoyaku_dantai.perno perid
                              , to_zenkaku(v_web_yoyaku_dantai.namej) fullname
                              , to_zenkaku(v_web_yoyaku_dantai.namea) kananame
                              , v_web_yoyaku_dantai.romaname romaname
                              , person.lastname
                              , person.firstname
                              , person.lastkname
                              , person.firstkname
                              , v_web_yoyaku_dantai.gender gender
                              , v_web_yoyaku_dantai.birth
                              , v_web_yoyaku_dantai.zipno
                              , v_web_yoyaku_dantai.adrs1 address1
                              , v_web_yoyaku_dantai.adrs2 address2
                              , v_web_yoyaku_dantai.adrs3 address3
                              , v_web_yoyaku_dantai.telno tel
                              , v_web_yoyaku_dantai.email email
                              , v_web_yoyaku_dantai.knmnm officename
                              , v_web_yoyaku_dantai.telno2 officetel
                              , v_web_yoyaku_dantai.orgcd1 orgcd1
                              , v_web_yoyaku_dantai.orgcd2 orgcd2
                              , org.orgname orgname
                              , v_web_yoyaku_dantai.hnkzkbn supportdiv
                              ,
                        ";

            // 胃検査コースオプションのフラグ変換
            sql += " decode(v_web_yoyaku_dantai.cscdoption1, '" + CSCSOPTION1_STOMAC_XRAY + "', 1,  '" + CSCSOPTION1_STOMAC_CAMERA + "', 2, 0 ) optionstomac, ";

            // 乳房検査コースオプションのフラグ変換
            sql += " decode(v_web_yoyaku_dantai.cscdoption3, '" + CSCSOPTION3_BREAST_XRAY + "', 1, '" + CSCSOPTION3_BREAST_ECHO + "', 2, '" + CSCSOPTION3_BREAST_XRAY_ECHO + "', 3, 0 ) optionbreast, ";

            sql += @"
                    v_web_yoyaku_dantai.msg message
                    , v_web_yoyaku_dantai.insertdate insdate
                    , v_web_yoyaku_dantai.cancel_reqdt candate
                    , v_web_yoyaku_dantai.updatedate upddate
                    , web_relation.rsvno
                    , v_web_yoyaku_dantai.isrsign
                    , v_web_yoyaku_dantai.isrno
                    , v_web_yoyaku_dantai.volunteer
                    , v_web_yoyaku_dantai.cardouteng
                    , v_web_yoyaku_dantai.formouteng
                    , v_web_yoyaku_dantai.reportouteng
                    , v_web_yoyaku_dantai.rsvno crsvno
                    , v_web_yoyaku_dantai.nation nation
                    , v_web_yoyaku_dantai.op_concat csloptions
                    , v_web_yoyaku_dantai.webreqno webreqno
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
                      , org
                      , webreserve.v_web_yoyaku_dantai
                    where
                      v_web_yoyaku_dantai.csldate = :csldate
                      and v_web_yoyaku_dantai.webno = :webno
                      and v_web_yoyaku_dantai.perno = person.perid(+)
                      and v_web_yoyaku_dantai.orgcd1 = org.orgcd1(+)
                      and v_web_yoyaku_dantai.orgcd2 = org.orgcd2(+)
                      and v_web_yoyaku_dantai.csldate = web_relation.csldate(+)
                      and v_web_yoyaku_dantai.webno = web_relation.webno(+)
                      and v_web_yoyaku_dantai.cscd = csrsvgrp.cscd(+)
                      and v_web_yoyaku_dantai.rsvtime = csrsvgrp.strtime(+)
                  ";
            dynamic data = connection.Query(sql, param).FirstOrDefault();
            if (data != null)
            {
                DateTime birth = DateTime.Parse(Convert.ToString(data.BIRTH));
                // 和暦年を取得
                data.birtherayear = (object)WebHains.JapaneseCalendar.GetYear(birth);
                // 和暦元号(英字表記)を取得
                data.birthyearshorteraname = WebHains.GetShortEraName(birth);

            }
            return data;
        }

        /// <summary>
        /// 指定検索条件のweb予約情報を取得する
        /// </summary>
        /// <param name="totalCount">total件数</param>
        /// <param name="strCslDate">開始受診年月日</param>
        /// <param name="endCslDate">終了受診年月日</param>
        /// <param name="key">検索キー</param>
        /// <param name="strOpDate">開始処理年月日</param>
        /// <param name="endOpDate">終了処理年月日</param>
        /// <param name="orgCd1">受診団体コード1</param>
        /// <param name="orgCd2">受診団体コード2</param>
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
        /// orgCd1      団体コード1
        /// orgCd2      団体コード2
        /// orgName     団体名
        /// insDate     申し込み年月日
        /// canDate     キャンセル年月日
        /// updDate     予約処理年月日
        /// regFlg      本登録フラグ(1:未登録者、2:編集済み受診者)
        /// rsvNo       予約番号
        /// </returns>
        public List<dynamic> SelectWebOrgRsvList(out int totalCount, DateTime strCslDate, DateTime endCslDate, string key,
            DateTime? strOpDate, DateTime? endOpDate, string orgCd1, string orgCd2,
            int opMode, int regFlg, int moushiKbn, int order, int startPos = 1, int getCount = 0)
        {
            string sql = "";  // SQLステートメント
            string basedSql;  // 基本SQLステートメント
            int allCount;     // 全レコード件数

            // バインド変数の設定
            var param = new Dictionary<string, object>();
            param.Add("startpos", startPos);
            param.Add("endpos", startPos + getCount - 1);

            // 基本SQL作成
            basedSql = CreateBasedSqlForWebOrgRsvList(ref param, strCslDate, endCslDate, key, strOpDate, endOpDate, orgCd1, orgCd2, opMode, regFlg, moushiKbn);

            while (true)
            {
                // ①全レコード件数取得
                dynamic current = connection.Query("select count(*) cnt from ( " + basedSql + " )", param).FirstOrDefault();
                allCount = Convert.ToInt32(current.CNT);

                totalCount = allCount;

                // レコードが存在しない場合は終了
                if (allCount <= 0)
                {
                    break;
                }

                // SQLステートメントの編集
                sql = @"
                        select
                          webrsv.csldate csldate
                          , webrsv.webno
                          , webrsv.rsvtime starttime
                          , decode(
                            webrsv.cscd
                            , '105'
                            , '職員健診（ドック）'
                            , csrsvgrp.rsvgrpname
                          ) rsvgrpname
                          , webrsv.perno perid
                          , to_zenkaku(webrsv.namej) fullname
                          , to_zenkaku(webrsv.namea) kananame
                          , person.lastname
                          , person.firstname
                          , person.lastkname
                          , person.firstkname
                          , webrsv.gender gender
                          , webrsv.birth
                          , org.orgsname orgname
                          , trunc(webrsv.insertdate) insdate
                          , trunc(webrsv.cancel_reqdt) candate
                          , decode(webrsv.ykbn, 2, webrsv.updatedate, null) upddate
                          , webrsv.ykbn regflg
                          , web_relation.rsvno
                        from
                          web_relation
                          , person
                          , org
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
                          and webrsv.rsvtime = csrsvgrp.strtime(+)
                          and webrsv.perno = person.perid(+)
                          and webrsv.orgcd1 = org.orgcd1(+)
                          and webrsv.orgcd2 = org.orgcd2(+)
                          and webrsv.csldate = web_relation.csldate(+)
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

            if (sql.Equals(""))
            {
                return null;
            }
            else
            {
                return connection.Query(sql, param).Select(rec =>
                {
                    DateTime wkBirth = DateTime.Parse(Convert.ToString(rec.BIRTH));
                    // 和暦年を取得
                    rec.birtherayear = (object)WebHains.JapaneseCalendar.GetYear(wkBirth);
                    // 和暦元号(英字表記)を取得
                    rec.birthyearshorteraname = WebHains.GetShortEraName(wkBirth);

                    dynamic consult = null;
                    if (rec.CANDATE != null && rec.RSVNO != null && !rec.REGFLG.Equals("1"))
                    {
                        consult = consultDao.SelectConsult(rec.rsvno);
                    }

                    string strEditDisp = "";

                    if (rec.REGFLG.Equals("1"))
                    {
                        strEditDisp = "未編集";
                    }
                    else
                    {
                        if (rec.CANDATE != null)
                        {
                            if (consult == null || consult.CANCELFLG == null || consult.CANCELFLG == 0)
                            {
                                if (rec.RSVNO == null)
                                {
                                    strEditDisp = "編集済み";
                                }
                                else
                                {
                                    strEditDisp = "削除済み";
                                }
                            }
                            else
                            {
                                strEditDisp = "取消済み";
                            }

                        }
                        else
                        {
                            strEditDisp = "編集済み";
                        }
                    }

                    rec.editDisp = strEditDisp;

                    // 氏名については、個人ID存在時は個人情報から、さもなくばweb予約情報から取得
                    string name = "";
                    if (rec.PERID != null)
                    {
                        name = (rec.LASTNAME + "　" + rec.FIRSTNAME).Trim();
                    }

                    if (name.Equals(""))
                    {
                        name = rec.FULLNAME;
                    }
                    rec.name = name;

                    return rec;
                }).ToList();
            }
        }

        /// <summary>
        /// 指定検索条件のweb予約情報のうち、指定受診年月日、webNoの次レコードを取得
        /// </summary>
        /// <param name="strCslDate">開始受診年月日</param>
        /// <param name="endCslDate">終了受診年月日</param>
        /// <param name="key">検索キー</param>
        /// <param name="strOpDate">開始処理年月日</param>
        /// <param name="endOpDate">終了処理年月日</param>
        /// <param name="orgCd1">受診団体コード1</param>
        /// <param name="orgCd2">受診団体コード2</param>
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
        public dynamic SelectWebOrgRsvNext(DateTime strCslDate, DateTime endCslDate, string key,
            DateTime? strOpDate, DateTime? endOpDate, string orgCd1, string orgCd2,
            int opMode, int regFlg, int moushiKbn, int order, DateTime cslDate, int webNo)
        {
            string sql = "";  // SQLステートメント
            string basedSql;  // 基本SQLステートメント

            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            param.Add("webno", webNo);

            // 基本SQL作成
            basedSql = CreateBasedSqlForWebOrgRsvList(ref param, strCslDate, endCslDate, key, strOpDate, endOpDate, orgCd1, orgCd2, opMode, regFlg, moushiKbn);

            // SQLステートメントの編集
            sql = @"
                    select
                      webrsv.nextcsldate
                      , webrsv.nextwebno
                    from
                      (
                        select
                          lag(webrsv2.csldate, 1, null) over (order by webrsv2.seq desc) nextcsldate
                          , lag(webrsv2.webno, 1, null) over (order by webrsv2.seq desc) nextwebno
                          , webrsv2.csldate
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
                      webrsv.csldate = :csldate
                      and webrsv.webno = :webno
                      and webrsv.nextcsldate is not null
                      and webrsv.nextwebno is not null
                 ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// web予約時登録された予約番号で予約情報チェック（受付されてない保留状態の予約情報かをチェック）
        /// </summary>
        /// <param name="rsvNo">web予約時登録されているHains予約番号</param>
        /// <param name="orgCd1">受診団体コード1</param>
        /// <param name="orgCd2">受診団体コード2</param>
        /// <returns>
        /// cslDate     (次レコードの)受診年月日
        /// rsvNo       予約番号
        /// perId       個人ID
        /// perName     受診者氏名
        /// </returns>
        public dynamic SelectConsultCheck(int rsvNo, string orgCd1, string orgCd2)
        {
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);

            // SQLステートメントの編集
            string sql = @"
                           select
                             consult.csldate csldate
                             , consult.rsvno rsvno
                             , consult.perid perid
                             , person.lastname || '　' || person.firstname pername
                           from
                             consult
                             , person
                           where
                             consult.rsvno = :rsvno
                             and consult.cancelflg = 0
                             and consult.rsvstatus = 1
                             and consult.orgcd1 = :orgcd1
                             and consult.orgcd2 = :orgcd2
                             and consult.perid = person.perid
                        ";

            return connection.Query(sql, param).FirstOrDefault();
        }
    }
}