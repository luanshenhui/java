using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity.Model.Consultation;
using Microsoft.VisualBasic;
using Newtonsoft.Json.Linq;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;

namespace Hainsi.Entity
{
    /// <summary>
    /// 受診情報データアクセスオブジェクト
    /// </summary>
    public class ConsultDao : AbstractDao
    {
        // 表示順（受診者一覧（結果入力））
        const string SORT_DAYID = "";       // 当日ＩＤ順
        const string SORT_BRE_FILMNO = "1"; // 胸部フィルム番号順
        const string SORT_STO_FILMNO = "2"; // 胃部フィルム番号順
        const string SORT_PERID = "3";      // 個人ＩＤ順

        const string BRE_FILMNO_KEY = "BRE_FILMNO";    // 胸部フィルム番号
        const string STO_FILMNO_KEY = "STO_FILMNO";    // 胃部フィルム番号

        const string GRPCD_KEY = "GRPCD";
        const string JUDCLASSCD_KEY = "JUDCLASSCD";
        const string PROGRESSCD_KEY = "PROGRESSCD";

        // 汎用データ抽出検査項目指定モード
        const string CASE_NOTSELECT = "notselect";  // 検査結果を抽出しない
        const string CASE_ALLSELECT = "allselect";  // すべての検査結果を抽出する
        const string CASE_SELECT = "select";        // 抽出する項目を指定する

        // 汎用データ抽出指定条件記号
        const string OPTION_EQ = "1";   // ｢と同じ｣
        const string OPTION_GE = "2";   // ｢以上｣
        const string OPTION_LE = "3";   // ｢以下｣

        // 受診者一覧の表示列情報
        const int COL_DAYID = 2;                // 当日ＩＤ
        const int COL_COURSE = 4;               // コース
        const int COL_NAME = 5;                 // 氏名
        const int COL_KANANAME = 6;             // カナ氏名
        const int COL_GENDER = 7;               // 性別
        const int COL_BIRTH = 8;                // 生年月日
        const int COL_AGE = 9;                  // 受診時年齢
        const int COL_ORGSNAME = 10;            // 団体略称
        const int COL_RSVNO = 11;               // 予約番号
        const int COL_CSLDATE = 12;             // 受診日
        const int COL_RSVDATE = 13;             // 予約日
        const int COL_ADDITEM = 14;             // 追加検査
        const int COL_RPTDATE = 15;             // 受付日
        const int COL_BOTHNAME = 16;            // 個人名称
        const int COL_PERID = 17;               // 個人ＩＤ
        const int COL_CONSULTITEM = 18;         // 受診項目
        const int COL_ISRSIGN = 22;             // 健保記号
        const int COL_ISRNO = 23;               // 健保番号
        const int COL_SUBCOURSE = 32;           // サブコース
        const int COL_ENTRY = 35;               // 結果入力状態
        const int COL_RSVSTATUS = 36;           // 予約状況
        const int COL_CARDPRINTDATE = 37;       // 確認はがき出力日
        const int COL_FORMPRINTDATE = 38;       // 一式書式出力日
        const int COL_RSVGRP = 39;              // 予約群
        const int COL_HASFRIENDS = 40;          // お連れ様の有無

        const string PREFIX_RSVNO = "RSVNO:";   // 検索時の予約番号指定
        const string PREFIX_PERID = "ID:";      // 検索時の個人ＩＤ指定
        const string PREFIX_BIRTH = "BIRTH:";   // 検索時の生年月日指定
        const string PREFIX_DAYID = "DID:";     // 検索時の当日ＩＤ指定
        const string PREFIX_OCRNO = "OCR:";     // 検索時のOCR番号指定
        const string PREFIX_LOCKERKEY = "KEY:"; // 検索時のロッカー番号指定

        const string ENTRYMODE_NONE = "0";          // 受付は行わない
        const string ENTRYMODE_AUTOLATEST = "1";    // 最終発番ＩＤの次番号で発番
        const string ENTRYMODE_DEADNUMBER = "2";    // 欠番を検索して発番
        const string ENTRYMODE_MANUAL = "3";        // 指定番号で発番

        // 来院情報入力チェックを使用
        // 来院情報入力項目名
        const string PORP_NAME_DAYID = "当日ID";
        const string PORP_NAME_OCRNO = "OCR番号";
        const string PORP_NAME_LOCKERKEY = "ロッカーキー";
        // 来院確認入力項目名
        const string PORP_NAME_GUIDANCENO = "ご案内書Ｎｏ";

        // 来院情報入力桁数
        const int PORP_LEN_DAYID = 4;
        const int PORP_LEN_OCRNO = 10;
        const int PORP_LEN_LOCKERKEY = 5;
        // 来院確認入力桁数
        const int PORP_LEN_GUIDANCENO = 9;

        /// <summary>
        /// コース情報データアクセスオブジェクト
        /// </summary>
        readonly CourseDao courseDao;

        /// <summary>
        /// 判定分類情報データアクセスオブジェクト
        /// </summary>
        readonly JudClassDao judClassDao;

        /// <summary>
        /// 判定情報データアクセスオブジェクト
        /// </summary>
        readonly JudDao judDao;

        /// <summary>
        /// オーダ送信ジャーナル用データアクセスオブジェクト
        /// </summary>
        readonly OrderJnlDao orderJnlDao;

        /// <summary>
        /// 個人情報データアクセスオブジェクト
        /// </summary>
        readonly PersonDao personDao;

        /// <summary>
        /// 検査結果データアクセスオブジェクト
        /// </summary>
        readonly ResultDao resultDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        /// <param name="courseDao">コース情報データアクセスオブジェクト</param>
        /// <param name="judClassDao">判定分類情報データアクセスオブジェクト</param>
        /// <param name="judDao">判定情報データアクセスオブジェクト</param>
        /// <param name="orderJnlDao">オーダ送信ジャーナル用データアクセスオブジェクト</param>
        /// <param name="personDao">個人情報データアクセスオブジェクト</param>
        /// <param name="resultDao">検査結果データアクセスオブジェクト</param>
        public ConsultDao(
            IDbConnection connection,
            CourseDao courseDao,
            JudClassDao judClassDao,
            JudDao judDao,
            OrderJnlDao orderJnlDao,
            PersonDao personDao,
            ResultDao resultDao
        ) : base(connection)
        {
            this.courseDao = courseDao;
            this.judClassDao = judClassDao;
            this.judDao = judDao;
            this.orderJnlDao = orderJnlDao;
            this.personDao = personDao;
            this.resultDao = resultDao;
        }

        /// <summary>
        /// 生年月日条件節の追加
        /// </summary>
        /// <param name="conditions">条件節の集合</param>
        /// <param name="param">パラメーター</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        void AppendCondition_Birth(ref List<string> conditions, ref Dictionary<string, object> param, string buffer, int paramNo)
        {
            string birth; // 生年月日

            // 先頭６文字が"BIRTH:"である場合は先頭部を取り除いた部分を生年月日として取得、それ以外は引数値をそのまま使用
            if (buffer.Substring(0, PREFIX_BIRTH.Length).ToUpper().Equals(PREFIX_BIRTH))
            {
                birth = buffer.Substring(PREFIX_BIRTH.Length);
            }
            else
            {
                birth = buffer;
            }

            // すでに日付型である場合
            if (DateTime.TryParse(birth, out DateTime wkDate))
            {
                // そのまま適用
            }
            else
            {
                // 日付型でない(すなわち８桁の数字列である)場合
                // 年がゼロの場合はシステム年を適用し、さもなくばそのまま日付型にして適用
                wkDate = new DateTime(
                    birth.Substring(0, 4).Equals("0000") ? DateTime.Now.Year : int.Parse(birth.Substring(0, 4)),
                    int.Parse(birth.Substring(4, 2)),
                    int.Parse(birth.Substring(6))
                );
            }

            // パラメータ追加
            string paramName = "birth" + paramNo.ToString();
            param.Add(paramName, wkDate);

            // 条件節の編集
            string sql = "person.birth = :" + paramName;

            // 配列に追加
            conditions.Add(sql);
        }

        /// <summary>
        /// 当日ＩＤ条件節の追加
        /// </summary>
        /// <param name="conditions">条件節の集合</param>
        /// <param name="param">パラメーター</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        void AppendCondition_DayId(ref List<string> conditions, ref Dictionary<string, object> param, string buffer, int paramNo)
        {
            string dayId; // 当日ＩＤ

            // 先頭４文字が"DID:"である場合は先頭部を取り除いた部分を当日ＩＤとして取得、それ以外は引数値をそのまま使用
            if (buffer.Substring(0, PREFIX_DAYID.Length).ToUpper().Equals(PREFIX_DAYID))
            {
                dayId = buffer.Substring(PREFIX_DAYID.Length);
            }
            else
            {
                dayId = buffer;
            }

            // パラメータ追加
            string paramName = "dayid" + paramNo.ToString();
            param.Add(paramName, int.Parse(dayId));

            // 条件節の編集
            string sql = "receipt.dayid = :" + paramName;

            // 配列に追加
            conditions.Add(sql);
        }

        /// <summary>
        /// 従業員番号条件節の追加
        /// </summary>
        /// <param name="conditions">条件節の集合</param>
        /// <param name="param">パラメーター</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        void AppendCondition_EmpNo(ref List<string> conditions, ref Dictionary<string, object> param, string buffer, int paramNo)
        {
            // ハイフンで分割(事前チェック済みなので要素は必ず３個)
            string[] token = buffer.Split('-');

            string orgCd1 = "orgcd1_" + paramNo.ToString();
            string orgCd2 = "orgcd2_" + paramNo.ToString();
            string empNo = "empno" + paramNo.ToString();
            param.Add(orgCd1, token[0]);
            param.Add(orgCd2, token[1]);
            param.Add(empNo, token[2]);

            // 条件節の編集
            string sql = "(person.orgcd1 = :" + orgCd1 + " and person.orgcd2 = :" + orgCd2 + " and person.empno = :" + empNo + ")";

            // 配列に追加
            conditions.Add(sql);
        }

        /// <summary>
        /// 性別条件節の追加
        /// </summary>
        /// <param name="conditions">条件節の集合</param>
        /// <param name="param">パラメーター</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        void AppendCondition_Gender(ref List<string> conditions, ref Dictionary<string, object> param, string buffer, int paramNo)
        {
            string paramName;           // パラメータ名
            string paramName2;           // パラメータ名

            string sql;           // SQLステートメント

            // 男性指定か女性指定か？
            switch (buffer.ToUpper())
            {
                case "M":
                case "F":

                    // パラメータ追加
                    paramName = "perid" + paramNo.ToString();
                    paramName2 = "gender" + paramNo.ToString();
                    param.Add(paramName, buffer);
                    param.Add(paramName2, buffer.ToUpper().Equals("M") ? Gender.Male : Gender.Female);

                    sql = "( person.perid = :" + paramName + " || person.gender = :" + paramName2 + ")";
                    break;

                default:
                    return;

            }

            // 配列に追加
            conditions.Add(sql);
        }

        /// <summary>
        /// 健保記号番号条件節の追加
        /// </summary>
        /// <param name="conditions">条件節の集合</param>
        /// <param name="param">パラメーター</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        void AppendCondition_Insured(ref List<string> conditions, ref Dictionary<string, object> param, string buffer, int paramNo)
        {
            // ハイフンで分割(事前チェック済みなので要素は必ず２個)
            string[] token = buffer.Split('-');

            string isrSign = "isrsign" + paramNo.ToString();
            string isrNo = "isrno" + paramNo.ToString();
            param.Add(isrSign, token[0]);
            param.Add(isrNo, token[1]);

            // 条件節の編集
            string sql = "( consult.isrsign = :" + isrSign + " and consult.isrno = :" + isrNo + ")";

            // 配列に追加
            conditions.Add(sql);
        }

        /// <summary>
        /// 個人ＩＤ条件節の追加
        /// </summary>
        /// <param name="conditions">条件節の集合</param>
        /// <param name="param">パラメーター</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        void AppendCondition_PerId(ref List<string> conditions, ref Dictionary<string, object> param, string buffer, int paramNo)
        {
            string sql; // SQLステートメント
            string perId; // 個人ＩＤ

            // 先頭３文字が"ID:"である場合は先頭部を取り除いた部分を個人IDとして取得、それ以外は引数値をそのまま使用
            if (buffer.Substring(0, PREFIX_PERID.Length).ToUpper().Equals(PREFIX_PERID))
            {
                perId = buffer.Substring(PREFIX_PERID.Length);
            }
            else
            {
                perId = buffer;
            }

            // パラメータ追加
            string paramName = "perid" + paramNo.ToString();
            param.Add(paramName, "");

            if (perId.Substring(perId.Length - 1).Equals("*"))
            {
                // 文字列の末尾が"*"なら部分検索
                param[paramName] = perId.Substring(0, perId.Length - 1).Trim() + "%";
                sql = "person.perid like :" + paramName;
            }
            else
            {
                // さもなければ直接指定
                param[paramName] = perId.Trim();
                sql = "person.perid = :" + paramName;
            }

            // 配列に追加
            conditions.Add(sql);
        }

        /// <summary>
        /// OCR番号条件節の追加
        /// </summary>
        /// <param name="conditions">条件節の集合</param>
        /// <param name="param">パラメーター</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        void AppendCondition_OcrNo(ref List<string> conditions, ref Dictionary<string, object> param, string buffer, int paramNo)
        {
            string ocrNo; // OCR番号

            // 先頭４文字が"OCR:"である場合は先頭部を取り除いた部分をOCR番号として取得、それ以外は引数値をそのまま使用
            if (buffer.Substring(0, PREFIX_OCRNO.Length).ToUpper().Equals(PREFIX_OCRNO))
            {
                ocrNo = buffer.Substring(PREFIX_OCRNO.Length);
            }
            else
            {
                ocrNo = buffer;
            }

            // パラメータ追加
            string paramName = "ocrno" + paramNo.ToString();
            param.Add(paramName, ocrNo.Trim());

            // 条件節の編集
            string sql = "receipt.ocrno = :" + paramName;

            // 配列に追加
            conditions.Add(sql);
        }

        /// <summary>
        /// ロッカー番号条件節の追加
        /// </summary>
        /// <param name="conditions">条件節の集合</param>
        /// <param name="param">パラメーター</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        void AppendCondition_LockerKey(ref List<string> conditions, ref Dictionary<string, object> param, string buffer, int paramNo)
        {
            string lockerKey; // ロッカー番号

            // 先頭４文字が"KEY:"である場合は先頭部を取り除いた部分をロッカー番号として取得、それ以外は引数値をそのまま使用
            if (buffer.Substring(0, PREFIX_LOCKERKEY.Length).ToUpper().Equals(PREFIX_LOCKERKEY))
            {
                lockerKey = buffer.Substring(PREFIX_LOCKERKEY.Length);
            }
            else
            {
                lockerKey = buffer;
            }

            // パラメータ追加
            string paramName = "lockerkey" + paramNo.ToString();
            param.Add(paramName, lockerKey.Trim());

            string sql = "receipt.lockerkey = :" + paramName;

            // 配列に追加
            conditions.Add(sql);
        }

        /// <summary>
        /// ローマ字条件節の追加
        /// </summary>
        /// <param name="conditions">条件節の集合</param>
        /// <param name="param">パラメーター</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        /// <param name="romeNameMultiple">trueの場合はromeNameMultipleを行う</param>
        void AppendCondition_RomeName(ref List<string> conditions, ref Dictionary<string, object> param, string buffer, int paramNo, bool romeNameMultiple)
        {
            buffer = buffer.ToUpper();
            string buffer2 = null;

            while (true)
            {
                // 複合検索を行わない場合
                if (!romeNameMultiple)
                {
                    break;
                }

                // １つ目の空白を検索。見つからない場合は複合検索を行わない場合と同じ
                int pos = buffer.IndexOf(" ", StringComparison.Ordinal);
                if (pos < 0)
                {
                    romeNameMultiple = false;
                    break;
                }

                // １つ目の空白以降の部分文字列を取得。なければ複合検索を行わない場合と同じ
                buffer2 = buffer.Substring(buffer.Length - pos).Trim();
                if (string.IsNullOrEmpty(buffer2))
                {
                    romeNameMultiple = false;
                    break;
                }

                break;
            }

            // パラメータ追加
            string paramName = "name" + paramNo.ToString();
            param.Add(paramName, buffer + "%");

            // 複合検索を行う場合はさらにパラメータ追加
            string paramName2 = null;
            if (romeNameMultiple)
            {
                paramName2 = "partname" + paramNo.ToString();
                param.Add(paramName2, buffer2 + "%");
            }

            string sql; // SQLステートメント
            if (!romeNameMultiple)
            {
                // 複合検索を行わない場合
                // パラメータ値の完全一致検索のみ
                sql = "person.romename like :" + paramName;
            }
            else
            {
                // 複合検索を行う場合
                // パラメータ値の完全一致検索あるいは部分文字列検索
                sql = "( person.romename like :" + paramName + " || person.searchrname like :" + paramName2 + " )";
            }

            // 配列に追加
            conditions.Add(sql);
        }

        /// <summary>
        /// 予約番号条件節の追加
        /// </summary>
        /// <param name="conditions">条件節の集合</param>
        /// <param name="param">パラメーター</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        void AppendCondition_RsvNo(ref List<string> conditions, ref Dictionary<string, object> param, string buffer, int paramNo)
        {
            // パラメータ追加
            string paramName = "rsvno" + paramNo.ToString();
            param.Add(paramName, int.Parse(buffer.Substring(PREFIX_RSVNO.Length)));

            // 条件節の編集
            string sql = "consult.rsvno = :" + paramName;

            // 配列に追加
            conditions.Add(sql);
        }

        /// <summary>
        /// 全角文字条件節の追加
        /// </summary>
        /// <param name="conditions">条件節の集合</param>
        /// <param name="param">パラメーター</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        void AppendCondition_Wide(ref List<string> conditions, ref Dictionary<string, object> param, string buffer, int paramNo)
        {
            string paramName1; // パラメータ名
            string paramName2; // パラメータ名

            string sql; // SQLステートメント
            string buffer2; // 文字列バッファ

            string lastName;  // 姓
            string firstName; // 名

            // カナ以外の全角文字が存在するかをチェック(カナは半角変換でき、漢字・ひらがなは半角変換できない性質を利用)
            string narrow = Strings.StrConv(buffer, VbStrConv.Narrow);
            bool isWideChar = false;
            for (var i = 0; i < narrow.Length; i++)
            {
                if (Strings.AscW(narrow.Substring(i, 1)) < 0)
                {
                    isWideChar = true;
                    break;
                }
            }

            // 姓名で検索するか姓のみで検索するかを判定
            while (true)
            {
                // １つ目の空白を検索。見つからない場合は姓のみ。
                int pos = buffer.IndexOf(" ", StringComparison.Ordinal);
                if (pos < 0)
                {
                    lastName = buffer.Trim();
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
                lastName = buffer.Substring(0, pos - 1).Trim();
                firstName = buffer2;

                break;
            }

            // 姓のみで検索する場合
            if (string.IsNullOrEmpty(firstName))
            {
                // パラメータ追加
                paramName1 = "lastname" + paramNo.ToString();
                param.Add(paramName1, lastName + "%");

                while (true)
                {
                    // カナ以外の全角文字が含まれる場合
                    if (isWideChar)
                    {
                        sql = "( person.lastname like :" + paramName1 + " )";
                        break;
                    }

                    // 置換前後で文字列値が同一ならば通常の検索を行う
                    sql = "( person.lastkname like :" + paramName1 + " ) ";
                    break;
                }
            }
            else
            {
                // 姓名で検索する場合
                // パラメータ追加
                paramName1 = "lastname" + paramNo.ToString();
                paramName2 = "firstname" + paramNo.ToString();
                param.Add(paramName1, lastName);
                param.Add(paramName2, firstName + "%");

                while (true)
                {
                    // カナ以外の全角文字が含まれる場合
                    if (isWideChar)
                    {
                        sql = "( person.lastname = :" + paramName1 + " and person.firstname like :" + paramName2 + " )";
                        break;
                    }

                    // 置換前後で文字列値が同一ならば通常の検索を行う
                    sql = "( person.lastkname = :" + paramName1 + " and person.firstkname like :" + paramName2 + " )";
                    break;
                }
            }

            // 配列に追加
            conditions.Add(sql);
        }

        /// <summary>
        /// 受診情報をキャンセルする
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="updUser">更新者</param>
        /// <param name="cancelFlg">キャンセルフラグ</param>
        /// <param name="message">メッセージ</param>
        /// <param name="force">強制キャンセルフラグ</param>
        /// <returns>予約番号</returns>
        public int CancelConsult(int rsvNo, string updUser, int cancelFlg, out string message, bool force = false)
        {
            // キー及び更新値の設定
            var param = new OracleDynamicParameters();
            param.Add("rsvno", rsvNo, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("upduser", updUser, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("cancelflg", cancelFlg, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("cancelforce", force ? 1 : 0, OracleDbType.Decimal, ParameterDirection.Input);

            // 戻り値(予約番号・メッセージ)のバインド変数定義
            param.Add("ret", dbType: OracleDbType.Decimal, direction: ParameterDirection.ReturnValue);
            param.Add("message", dbType: OracleDbType.Varchar2, direction: ParameterDirection.Output, size: 1000);

            // 受診情報登録用ストアドパッケージの関数呼び出し
            var sql = @"
                begin
                    :ret := consultpackagelukes.cancelconsult(
                        :rsvno
                        , :upduser
                        , :cancelflg
                        , :message
                        , :cancelforce
                    );
                end;
            ";

            // PL/SQL文の実行
            connection.Execute(sql, param);

            // 戻り値の取得
            var dbMessage = param.Get<OracleString>("message");
            message = dbMessage.IsNull ? null : dbMessage.Value;

            // 戻り値の設定
            return param.Get<OracleDecimal>("ret").ToInt32();
        }

        /// <summary>
        /// 受付を取り消す
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="updUser">更新者</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="message">メッセージ</param>
        /// <param name="force">true指定時は結果の有無に関わらず強制的に削除</param>
        /// <returns>予約番号</returns>
        public int CancelReceipt(int rsvNo, string updUser, DateTime cslDate, out string message, bool force = false)
        {
            // キー及び更新値の設定
            var param = new OracleDynamicParameters();
            param.Add("rsvno", rsvNo, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("upduser", updUser, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("csldate", cslDate, OracleDbType.Date, ParameterDirection.Input);

            // 戻り値のバインド変数定義
            param.Add("ret", dbType: OracleDbType.Decimal, direction: ParameterDirection.ReturnValue);
            param.Add("message", dbType: OracleDbType.Varchar2, direction: ParameterDirection.Output, size: 1000);

            // 受診情報登録用ストアドパッケージの関数呼び出し
            var sql = @"
                begin
                    :ret := consultpackagelukes.cancelreceipt(
                        :rsvno
                        , :upduser
                        , :csldate
                        , :message
            ";

            if (force)
            {
                sql += @"
                        , 1
                ";
            }

            sql += @"
                    );
                end;
            ";

            // PL/SQL文の実行
            connection.Execute(sql, param);

            // 戻り値の取得
            var dbMessage = param.Get<OracleString>("message");
            message = dbMessage.IsNull ? null : dbMessage.Value;

            // 戻り値の設定
            return param.Get<OracleDecimal>("ret").ToInt32();
        }

        /// <summary>
        /// 一括で受付を取り消す
        /// </summary>
        /// <param name="updUser">更新者</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="cntlNo">管理番号</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="force">true指定時は結果の有無に関わらず強制的に削除</param>
        /// <returns>取り消した受付情報数</returns>
        public int CancelReceiptAll(string updUser, DateTime cslDate, int cntlNo, string csCd, bool force = false)
        {
            // キー及び更新値の設定
            var param = new OracleDynamicParameters();
            param.Add("upduser", updUser, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("csldate", cslDate, OracleDbType.Date, ParameterDirection.Input);
            param.Add("cntlno", cntlNo, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("cscd", csCd, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("cancelforce", force ? 1 : 0, OracleDbType.Decimal, ParameterDirection.Input);

            // 戻り値のバインド変数定義
            param.Add("ret", dbType: OracleDbType.Decimal, direction: ParameterDirection.ReturnValue);

            // 受診情報登録用ストアドパッケージの関数呼び出し
            var sql = @"
                begin
                    :ret := consultpackagelukes.cancelreceiptall(
                        :upduser
                        , :csldate
                        , :cntlno
                        , :cscd
                        , :cancelforce
                    );
                end;
            ";

            // PL/SQL文の実行
            connection.Execute(sql, param);

            // 戻り値の設定
            return param.Get<OracleDecimal>("ret").ToInt32();
        }

        // TODO 未使用？
        ////
        ////  機能　　 : 受診セットの登録
        ////
        ////  引数　　 : (In)     lngRsvNo        予約番号
        ////  　　　　   (In)     lngCtrPtCd      契約パターンコード
        ////  　　　　   (In)     vntOptCd        オプションコード
        ////  　　　　   (In)     vntOptBranchNo  オプション枝番
        ////  　　　　   (In)     vntConsults     受診要否
        ////  　　　　   (In)     strIpAddress    ＩＰアドレス
        ////  　　　　   (In)     strUpdUser      更新者
        ////             (In)     lngIgnoreFlg    予約枠無視フラグ
        ////  　　　　   (In)     vntGrpCd        グループコード
        ////  　　　　   (In)     vntRslCmtCd2    結果コメント２
        ////  　　　　   (Out)    vntMessage      メッセージ
        ////
        ////  戻り値　 : true   正常終了
        ////  　　　　   false  異常終了
        ////
        ////  備考　　 :
        ////
        //public bool ChangeSet(
        //int lngRsvNo,
        //int lngCtrPtCd,
        //ref string[] vntOptCd,
        //ref int[] vntOptBranchNo,
        //ref string[] vntConsults,
        //string strIpAddress,
        //string strUpdUser,
        //int lngIgnoreFlg,
        //ref object vntGrpCd,
        //ref object vntRslCmtCd2,
        //out string vntMessage
        //)
        //{
        //    vntMessage = null;

        //    bool Ret = false; // 関数戻り値

        //    while (true)
        //    {
        //        // オプションコード指定時
        //        if (vntOptCd is Array)
        //        {
        //            // 受診オプション管理レコードの更新
        //            int Ret2 = UpdateConsult_O(lngRsvNo, lngCtrPtCd, vntOptCd, vntOptBranchNo, vntConsults, strIpAddress, strUpdUser, lngIgnoreFlg, out vntMessage);
        //            if (Ret2 <= 0)
        //            {
        //                break;
        //            }
        //        }

        //        // グループコード指定時
        //        if (vntGrpCd is Array)
        //        {
        //            // 検査中止情報の更新
        //            bool Ret3 = resultDao.UpdateResultForChangeSet(lngRsvNo.ToString(), strIpAddress, strUpdUser, vntGrpCd, vntRslCmtCd2, vntMessage);
        //            if (Ret3 == false)
        //            {
        //                break;
        //            }
        //        }

        //        Ret = true;
        //        break;
        //    }

        //    // 戻り値の設定
        //    return Ret;
        //}

        /// <summary>
        /// 指定予約番号、請求分類の受診オプション管理情報有無をチェック
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="dmdLineClassCd">請求明細分類コード</param>
        /// <returns>存在する場合にtrueを返す</returns>
        public bool CheckConsult_O_Isr(int rsvNo, string dmdLineClassCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("dmdlineclasscd", dmdLineClassCd);

            // 指定予約番号、請求分類の受診オプション管理情報有無をチェック
            var sql = @"
                select
                    consult_o.rsvno
                from
                    ctrpt_opt
                    , consult_o
                where
                    consult_o.rsvno = :rsvno
                    and consult_o.ctrptcd = ctrpt_opt.ctrptcd
                    and consult_o.optcd = ctrpt_opt.optcd
                    and consult_o.optbranchno = ctrpt_opt.optbranchno
                    and (
                        ctrpt_opt.dmdlineclasscd = :dmdlineclasscd || ctrpt_opt.isrdmdlineclasscd = :dmdlineclasscd
                    )
            ";

            dynamic data = connection.Query(sql, param).FirstOrDefault();

            // レコードの有無で戻り値を決定
            return (data != null);
        }

        /// <summary>
        ///　汎用データ抽出条件の妥当性チェックを行う
        /// </summary>
        /// <param name="startYear">受診年(自)</param>
        /// <param name="startMonth">受診月(自)</param>
        /// <param name="startDay">受診日(自)</param>
        /// <param name="endYear">受診年(至)</param>
        /// <param name="endMonth">受診月(至)</param>
        /// <param name="endDay">受診日(至)</param>
        /// <param name="startAgeY">受診時年齢(年)(自)</param>
        /// <param name="startAgeM">受診時年齢(月)(自)</param>
        /// <param name="endAgeY">受診時年齢(年)(至)</param>
        /// <param name="endAgeM">受診時年齢(月)(至)</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="rslValueFrom">検査結果(FROM側)の配列</param>
        /// <param name="rslMarkFrom">検査結果(FROM側)範囲指定の配列</param>
        /// <param name="rslValueTo">検査結果(TO側)の配列</param>
        /// <param name="rslMarkTo">検査結果(TO側)範囲指定の配列</param>
        /// <param name="judClassCd">判定分類コードの配列</param>
        /// <param name="judValueFrom">判定コード(FROM側)の配列</param>
        /// <param name="judMarkFrom">判定コード(FROM側)範囲指定の配列</param>
        /// <param name="judValueTo">判定コード(TO側)の配列</param>
        /// <param name="judMarkTo">判定コード(TO側)範囲指定の配列</param>
        /// <param name="startDate">受診年月日(自)</param>
        /// <param name="endDate">受診年月日(至)</param>
        /// <param name="startAge">受診時年齢(自)</param>
        /// <param name="endAge">受診時年齢(至)</param>
        /// <param name="rslCondition">検査結果条件(結果タイプ)</param>
        /// <param name="weightFrom">判定用重み(FROM側)の配列</param>
        /// <param name="weightTo">判定用重み(TO側)の配列</param>
        /// <param name="judCondition">検査結果条件</param>
        /// <returns>エラー値がある場合、エラーメッセージのリストを返す</returns>
        public IList<string> CheckValueDatConsult(
            string startYear,
            string startMonth,
            string startDay,
            string endYear,
            string endMonth,
            string endDay,
            string startAgeY,
            string startAgeM,
            string endAgeY,
            string endAgeM,
            string[] itemCd,
            string[] suffix,
            string[] rslValueFrom,
            string[] rslMarkFrom,
            string[] rslValueTo,
            string[] rslMarkTo,
            int?[] judClassCd,
            string[] judValueFrom,
            string[] judMarkFrom,
            string[] judValueTo,
            string[] judMarkTo,
            out DateTime? startDate,
            out DateTime? endDate,
            ref string startAge,
            ref string endAge,
            out string[] rslCondition,
            out int?[] weightFrom,
            out int?[] weightTo,
            out string[] judCondition
        )
        {
            var messages = new List<string>(); // エラーメッセージの集合

            // 受診歴・個人情報部
            IList<string> wkMessages = CheckValueDatCslPer(
                startYear,
                startMonth,
                startDay,
                endYear,
                endMonth,
                endDay,
                startAgeY,
                startAgeM,
                endAgeY,
                endAgeM,
                out startDate,
                out endDate,
                ref startAge,
                ref endAge
            );

            // エラーメッセージを追記
            if (wkMessages.Count > 0)
            {
                messages.AddRange(wkMessages);
            }

            // 検査項目部
            wkMessages = CheckValueDatRsl(
                itemCd,
                suffix,
                rslValueFrom,
                rslMarkFrom,
                rslValueTo,
                rslMarkTo,
                out rslCondition
            );

            // エラーメッセージを追記
            if (wkMessages.Count > 0)
            {
                messages.AddRange(wkMessages);
            }

            // 総合判定部
            wkMessages = CheckValueDatJudRsl(
                judClassCd,
                judValueFrom,
                judMarkFrom,
                judValueTo,
                judMarkTo,
                out weightFrom,
                out weightTo,
                out judCondition
            );

            // エラーメッセージを追記
            if (wkMessages.Count > 0)
            {
                messages.AddRange(wkMessages);
            }

            // 戻り値を設定
            return messages;
        }

        /// <summary>
        /// 受診情報および個人情報の指定条件の妥当性チェックおよび日付、年齢の編集を行う
        /// </summary>
        /// <param name="startYear">受診年(自)</param>
        /// <param name="startMonth">受診月(自)</param>
        /// <param name="startDay">受診日(自)</param>
        /// <param name="endYear">受診年(至)</param>
        /// <param name="endMonth">受診月(至)</param>
        /// <param name="endDay">受診日(至)</param>
        /// <param name="startAgeY">受診時年齢(年)(自)</param>
        /// <param name="startAgeM">受診時年齢(月)(自)</param>
        /// <param name="endAgeY">受診時年齢(年)(至)</param>
        /// <param name="endAgeM">受診時年齢(月)(至)</param>
        /// <param name="startDate">受診年月日(自)</param>
        /// <param name="endDate">受診年月日(至)</param>
        /// <param name="startAge">受診時年齢(自)</param>
        /// <param name="endAge">受診時年齢(至)</param>
        /// <returns>エラー値がある場合、エラーメッセージのリストを返す</returns>
        IList<string> CheckValueDatCslPer(
            string startYear,
            string startMonth,
            string startDay,
            string endYear,
            string endMonth,
            string endDay,
            string startAgeY,
            string startAgeM,
            string endAgeY,
            string endAgeM,
            out DateTime? startDate,
            out DateTime? endDate,
            ref string startAge,
            ref string endAge
        )
        {
            const string DEFAULT_STRAGE = "0";     // 受診時年齢未指定時のデフォルト値
            const string DEFAULT_ENDAGE = "999";   // 受診時年齢未指定時のデフォルト値

            const string MSG_ERRDATE = "受診日の指定に誤りがあります。";
            const string MSG_ERRPERIOD = "期間の指定が誤っています。";
            const string MSG_ERRAGE = "年齢の範囲指定が誤っています。";

            const string STRDATE = "受診年月日(自)";
            const string ENDDATE = "受診年月日(至)";

            const string HTML_BR = "<BR>";

            var messages = new List<string>(); // エラーメッセージの集合
            string message;   // エラーメッセージ

            // 各指定値チェック処理
            // 日付の妥当性チェック
            bool isDateError = false;

            // メッセージ本文
            string errMsg = MSG_ERRDATE;

            // 年月日(自)のチェック
            string subMsg = WebHains.CheckDate(STRDATE, startYear, startMonth, startDay, out startDate, Check.Necessary);
            if (!string.IsNullOrEmpty(subMsg))
            {
                // 詳細メッセージの追加
                errMsg = errMsg + HTML_BR + "  (" + subMsg + ")";
                isDateError = true;
            }

            // 年月日(至)のチェック
            subMsg = WebHains.CheckDate(ENDDATE, endYear, endMonth, endDay, out endDate, Check.Necessary);
            if (!string.IsNullOrEmpty(subMsg))
            {
                // 詳細メッセージの追加
                errMsg = errMsg + HTML_BR + "  (" + subMsg + ")";
                isDateError = true;
            }

            // 受診年月日のチェック
            if (isDateError)
            {
                // 受診年月日のいずれかひとつでもエラーのときエラーメッセージ追加
                message = errMsg;
                messages.Add(message);
            }
            else
            {
                // 指定期間の範囲チェック
                if (startDate > endDate)
                {
                    // エラーメッセージ追加
                    message = MSG_ERRPERIOD;
                    messages.Add(message);
                }
            }

            // 受診年齢の編集
            // 受診時年齢(自)
            if (string.IsNullOrEmpty(startAgeM))
            {
                startAgeM = "0";  // 年齢(月)未選択時は"0"扱い
            }

            if (!string.IsNullOrEmpty(startAgeY))
            {
                // 受診時年齢(自)の編集
                startAge = startAgeY + "." + (int.Parse(startAgeM) < 10 ? "0" : "") + startAgeM;
            }
            else
            {
                startAge = DEFAULT_STRAGE;      // 受診時年齢(自)未選択時の扱い
            }
            // 受診時年齢(至)
            if (string.IsNullOrEmpty(endAgeM))
            {
                endAgeM = "0";  // 年齢(月)未選択時は"0"扱い
            }
            if (!string.IsNullOrEmpty(endAgeY))
            {
                // 受診時年齢(至)の編集
                endAge = endAgeY + "." + (int.Parse(endAgeM) < 10 ? "0" : "") + endAgeM;
            }
            else
            {
                endAge = DEFAULT_ENDAGE;      // 受診時年齢(至)未選択時の扱い
            }

            // 受診時年齢の範囲チェック
            if (double.Parse(startAge) > double.Parse(endAge))
            {
                // エラーメッセージ追加
                message = MSG_ERRAGE;
                messages.Add(message);
            }

            // 戻り値の編集
            return messages;
        }

        /// <summary>
        /// 汎用データ条件指定時総合判定部指定条件の妥当性チェックを行い検査結果条件(CHECKの有無)を返す
        /// </summary>
        /// <param name="judClassCd">判定分類コードの配列</param>
        /// <param name="judValueFrom">判定コード(FROM側)の配列</param>
        /// <param name="judMarkFrom">判定コード(FROM側)範囲指定の配列</param>
        /// <param name="judValueTo">判定コード(TO側)の配列</param>
        /// <param name="judMarkTo">判定コード(TO側)範囲指定の配列</param>
        /// <param name="weightFrom">判定用重み(FROM側)の配列</param>
        /// <param name="weightTo">判定用重み(TO側)の配列</param>
        /// <param name="judCondition">検査結果条件</param>
        /// <returns>エラー値がある場合、エラーメッセージのリストを返す</returns>
        IList<string> CheckValueDatJudRsl(
            int?[] judClassCd,
            string[] judValueFrom,
            string[] judMarkFrom,
            string[] judValueTo,
            string[] judMarkTo,
            out int?[] weightFrom,
            out int?[] weightTo,
            out string[] judCondition
        )
        {
            const string JUD_CHECK = "CHECK"; // 条件設定行の戻り値
            const string JUD_SKIP = "";      // 条件未設定行の戻り値

            const string MSG_TARGET = "［総合判定］";

            const string MSG_ERRNOJUDCLASS = "番目の総合判定(判定分類)を選択してください。";

            const string MSG_ERRSAMECD = "に対して複数の条件は指定できません。";
            const string MSG_ERRNOOPTION = "の値に対しての条件を指定してください。";
            const string MSG_ERRNOVALUEF = "のFROM側の値を指定してください。";
            const string MSG_ERRNOVALUET = "のTO側の値を指定してください。";
            const string MSG_ERRRANGE = "の範囲の指定に誤りがあります。";
            const string MSG_ERRRANGEB = "の範囲の指定に誤りがあります。(FROM側、TO側の記号が同じです)";
            const string MSG_ERRRANGEF = "のTO側に｢と同じ｣、｢以上｣が設定されているのでFROM側は条件指定できません。";
            const string MSG_ERRRANGET = "のFROM側に｢と同じ｣、｢以下｣が設定されているのでTO側は条件指定できません。";

            string wkJudClassName = null; // 総合判定(判定分類)名

            int?[] judWeightFrom; // 判定用重み配列(FROM側)
            int?[] judWeightTo; // 判定用重み配列(TO側)
            string[] condition; // 判定条件の有無(項目未指定時は"")配列

            var messages = new List<string>(); // エラーメッセージの集合

            string message; // エラーメッセージ

            int judCount; // 条件指定有効項目数

            int j; // インデックス

            while (true)
            {
                // 有効判定分類のカウント
                judCount = 0;
                judWeightFrom = new int?[judClassCd.Length];
                judWeightTo = new int?[judClassCd.Length];
                condition = new string[judClassCd.Length];

                for (var i = 0; i <= judClassCd.Length - 1; i++)
                {
                    // 判定結果条件指定項目のいずれかが指定されているとき
                    if (!string.IsNullOrEmpty(judValueFrom[i]) ||
                        !string.IsNullOrEmpty(judMarkFrom[i]) ||
                        !string.IsNullOrEmpty(judValueTo[i]) ||
                        !string.IsNullOrEmpty(judMarkTo[i]))
                    {
                        if (judClassCd[i] != null)
                        {
                            // 判定分類があればカウント
                            judCount = judCount + 1;
                            // 条件フラグ配列を有効にセット
                            condition[i] = JUD_CHECK;
                        }
                        else
                        {
                            // 判定分類がなければ総合判定(判定分類)未指定のエラー
                            message = MSG_TARGET + (i + 1).ToString() + MSG_ERRNOJUDCLASS;
                            messages.Add(message);
                            // 条件フラグ配列を無効にセット
                            condition[i] = JUD_SKIP;
                        }
                    }
                    else
                    {
                        // 条件フラグ配列を無効にセット
                        condition[i] = JUD_SKIP;
                    }

                    // 判定用重み配列の初期化
                    judWeightFrom[i] = null;
                    judWeightTo[i] = null;
                }

                // 有効な判定分類が無ければチェック終了
                if (judCount == 0)
                {
                    break;
                }

                // 判定分類コード、名称リスト取得
                IList<dynamic> judClasses = judClassDao.SelectJudClassList();

                // 判定コード、重みリスト取得
                IList<dynamic> judges = judDao.SelectJudList();

                // 指定された総合判定項目の妥当性チェック
                for (var i = 0; i < judClassCd.Length; i++)
                {
                    // 有効行ならチェックする
                    if (condition[i].Equals(JUD_CHECK))
                    {
                        // 総合判定名称のセット
                        j = 0;
                        while (j < judClasses.Count)
                        {
                            if (Convert.ToInt32(judClasses[j].JUDCLASSCD) == judClassCd[i])
                            {
                                // 総合判定(判定分類)名称の取得
                                wkJudClassName = judClasses[j].JUDCLASSNAME;
                                break;
                            }
                            j = j + 1;
                        }
                        // 総合判定名称重複のチェック
                        if (i > 0)
                        {
                            j = 0;
                            while (j < i)
                            {
                                if (!condition[j].Equals(JUD_SKIP) && (judClassCd[j] == judClassCd[i]))
                                {
                                    // 条件指定の重複はエラー
                                    message = MSG_TARGET + wkJudClassName + MSG_ERRSAMECD;
                                    messages.Add(message);
                                    break;
                                }
                                j = j + 1;
                            }
                        }

                        // 片側ずつ値と記号がそろっているかチェック
                        // FROM側
                        bool isAvailableFrom = false;
                        if (!string.IsNullOrEmpty(judValueFrom[i]))
                        {
                            // 値入力有り
                            if (!string.IsNullOrEmpty(judMarkFrom[i]))
                            {
                                // 値に対する判定用重みをセット
                                j = 0;
                                while (j < judges.Count)
                                {
                                    if (judges[j].JUDCD == judValueFrom[i])
                                    {
                                        judWeightFrom[i] = judges[j].WEIGHT;
                                        break;
                                    }
                                    j = j + 1;
                                }
                                // 記号指定有りならFROM側指定有効
                                isAvailableFrom = true;
                            }
                            else
                            {
                                // FROM側記号未指定はエラー
                                message = MSG_TARGET + wkJudClassName + MSG_ERRNOOPTION;
                                messages.Add(message);
                            }
                        }
                        else
                        {
                            // 値入力なし
                            if (!string.IsNullOrEmpty(judMarkFrom[i]))
                            {
                                // FROM側値未指定はエラー
                                message = MSG_TARGET + wkJudClassName + MSG_ERRNOVALUEF;
                                messages.Add(message);
                            }
                        }
                        // TO側
                        bool isAvailableTo = false;
                        if (!string.IsNullOrEmpty(judValueTo[i]))
                        {
                            // 値入力有り
                            if (!string.IsNullOrEmpty(judMarkTo[i]))
                            {
                                // 値に対する判定用重みをセット
                                j = 0;
                                while (j < judges.Count)
                                {
                                    if (Convert.ToString(judges[j].JUDCD).Equals(judValueTo[i]))
                                    {
                                        judWeightTo[i] = judges[j].WEIGHT;
                                        break;
                                    }
                                    j = j + 1;
                                }
                                // 記号指定有りならTO側指定有効
                                isAvailableTo = true;
                            }
                            else
                            {
                                // TO側記号未指定はエラー
                                message = MSG_TARGET + wkJudClassName + MSG_ERRNOOPTION;
                                messages.Add(message);
                            }
                        }
                        else
                        {
                            // 値入力なし
                            if (!string.IsNullOrEmpty(judMarkTo[i]))
                            {
                                // TO側値未指定はエラー
                                message = MSG_TARGET + wkJudClassName + MSG_ERRNOVALUET;
                                messages.Add(message);
                            }
                        }

                        // FROM、TO両方指定された場合の関連チェック
                        if (isAvailableFrom && isAvailableTo)
                        {
                            // 記号の範囲チェック
                            if (judMarkFrom[i].Equals(judMarkTo[i]))
                            {
                                // 共に同じ記号はエラー
                                message = MSG_TARGET + wkJudClassName + MSG_ERRRANGEB;
                                messages.Add(message);
                            }
                            else
                            {
                                if (judMarkFrom[i].Equals(OPTION_EQ) || judMarkFrom[i].Equals(OPTION_LE))
                                {
                                    // TO側範囲指定無効はエラー
                                    message = MSG_TARGET + wkJudClassName + MSG_ERRRANGET;
                                    messages.Add(message);
                                }
                                if (judMarkTo[i].Equals(OPTION_EQ) || judMarkTo[i].Equals(OPTION_GE))
                                {
                                    // FROM側範囲指定無効はエラー
                                    message = MSG_TARGET + wkJudClassName + MSG_ERRRANGEF;
                                    messages.Add(message);
                                }
                            }
                            // 大小チェック
                            if (judWeightFrom[i] > judWeightTo[i])
                            {
                                // FROM側がTO側より大きいときは範囲指定エラー
                                message = MSG_TARGET + wkJudClassName + MSG_ERRRANGE;
                                messages.Add(message);
                            }
                        }
                    }

                }

                break;

            }

            // 戻り値の編集
            weightFrom = judWeightFrom;
            weightTo = judWeightTo;
            judCondition = condition;

            return messages;
        }

        /// <summary>
        /// 汎用データ条件指定時検査項目部指定条件の妥当性チェックを行い検査結果条件(結果タイプ)を返す
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="rslValueFrom">検査結果(FROM側)の配列</param>
        /// <param name="rslMarkFrom">検査結果(FROM側)範囲指定の配列</param>
        /// <param name="rslValueTo">検査結果(TO側)の配列</param>
        /// <param name="rslMarkTo">検査結果(TO側)範囲指定の配列</param>
        /// <param name="rslCondition">検査結果条件(結果タイプ)</param>
        /// <returns>エラー値がある場合、エラーメッセージのリストを返す</returns>
        IList<string> CheckValueDatRsl(
            string[] itemCd,
            string[] suffix,
            string[] rslValueFrom,
            string[] rslMarkFrom,
            string[] rslValueTo,
            string[] rslMarkTo,
            out string[] rslCondition
        )
        {
            const string RSL_CHECK = "CHECK";     // 条件設定行の初期値(結果タイプに置換される)
            const string RSL_SKIP = "";          // 条件未設定行の戻り値

            const string MSG_TARGET = "［検査項目］";

            const string MSG_ERRNOITEMCD = "番目の検査項目を選択してください。";

            const string MSG_ERRSAMECD = "に対して複数の条件は指定できません。";
            const string MSG_ERRNOOPTION = "の値に対しての条件を指定してください。";
            const string MSG_ERRNOVALUEF = "のFROM側の値を指定してください。";
            const string MSG_ERRNOVALUET = "のTO側の値を指定してください。";
            const string MSG_ERRNOTNUMERIC = "の値は数値を指定してください。";
            const string MSG_ERRRANGE = "の範囲の指定に誤りがあります。";
            const string MSG_ERRRANGEB = "の範囲の指定に誤りがあります。(FROM側、TO側の記号が同じです)";
            const string MSG_ERRRANGEF = "のTO側に｢と同じ｣、｢以上｣が設定されているのでFROM側は条件指定できません。";
            const string MSG_ERRRANGET = "のFROM側に｢と同じ｣、｢以下｣が設定されているのでTO側は条件指定できません。";

            string sql;  // SQLステートメント
            string where = null; // SQLステートメント(WHERE句)

            string condItemCd; // 検査項目コード
            string condSuffix; // 検査項目サフィックス

            string wkItemName; // 検査項目名(エラー時表示用)

            var messages = new List<string>(); // エラーメッセージの集合
            string message; // エラーメッセージ

            int itemCount; // 条件指定有効項目数

            int j; // インデックス

            var condition = new string[itemCd.Length];

            while (true)
            {
                // 有効検査項目のカウントおよびWHERE句の作成
                itemCount = 0;
                bool hasCondition = false;

                for (var i = 0; i < itemCd.Length; i++)
                {
                    // 検査結果条件指定項目のいずれかが指定されているとき
                    if (!string.IsNullOrEmpty(rslValueFrom[i]) ||
                        !string.IsNullOrEmpty(rslMarkFrom[i]) ||
                        !string.IsNullOrEmpty(rslValueTo[i]) ||
                        !string.IsNullOrEmpty(rslMarkTo[i]))
                    {
                        // 検査項目があれば
                        if (!string.IsNullOrEmpty(itemCd[i]))
                        {
                            // 結果タイプ抽出用WHERE句の作成
                            // アプストロフィはOracleの単一引用符と重複するので予め置換
                            condItemCd = itemCd[i].Trim().Replace("'", "''");
                            condSuffix = suffix[i].Trim().Replace("'", "''");

                            if (!hasCondition)
                            {
                                // 1件目はWHEREから
                                where = @"
                                    where (itemcd = '" + condItemCd + "' and suffix = '" + condSuffix + @"')
                                ";
                                hasCondition = true;
                            }
                            else
                            {
                                // 2件目以降はORで追記
                                where += @"
                                    or (itemcd = '" + condItemCd + "' and suffix = '" + condSuffix + @"')
                                ";
                            }
                            itemCount = itemCount + 1;

                            // 条件フラグ配列を有効にセット
                            condition[i] = RSL_CHECK;
                        }
                        else
                        {
                            // 検査項目がなければ検査項目未指定のエラー
                            message = MSG_TARGET + (i + 1).ToString() + MSG_ERRNOITEMCD;
                            messages.Add(message);

                            // 条件フラグ配列を無効にセット
                            condition[i] = RSL_SKIP;
                        }
                    }
                    else
                    {
                        // 条件フラグ配列を無効にセット
                        condition[i] = RSL_SKIP;
                    }

                }

                // 有効な検査項目が無ければチェック終了
                if (itemCount == 0)
                {
                    break;
                }

                // SQL文の編集
                sql = @"
                    select
                        itemcd
                        , suffix
                        , itemname
                        , resulttype
                    from
                        item_c
                ";

                // WHERE句
                sql = sql + where;

                sql = sql + @"
                    order by
                        itemcd
                        , suffix
                ";

                // 検査項目コードに対する結果タイプの取得
                IList<dynamic> items = connection.Query(sql).ToList();

                // 指定された検査項目の妥当性チェック
                for (var i = 0; i < itemCd.Length; i++)
                {
                    bool isNumeric = false; // 数値フラグ(数値･計算タイプならばtrue、それ以外はfalse)

                    // 有効行ならチェックする
                    if (condition[i].Equals(RSL_CHECK))
                    {
                        // 検査項目名、結果タイプのセット
                        wkItemName = "";
                        j = 0;
                        while (j < items.Count)
                        {
                            if (Convert.ToString(items[j].ITEMCD).Equals(itemCd[i]) && Convert.ToString(items[j].SUFFIX).Equals(suffix[i]))
                            {
                                // エラーメッセージ用の検査項目名称をセット
                                wkItemName = Convert.ToString(items[j].ITEMNAME);
                                // "CHECK"から結果タイプに置き換え
                                condition[i] = Convert.ToString(items[j].RESULTTYPE);
                                // 数値タイプフラグのセット
                                if (condition[i].Equals("0") || condition[i].Equals("5"))
                                {
                                    // 数値・計算タイプ
                                    isNumeric = true;
                                }
                                else
                                {
                                    // 上記以外のタイプ
                                    isNumeric = false;
                                }
                                // サーチ終了
                                break;
                            }
                            j = j + 1;
                        }
                        // 総合判定名称重複のチェック
                        if (i > 0)
                        {
                            j = 0;
                            while (j < i)
                            {
                                if (!condition[j].Equals(RSL_SKIP) && itemCd[j].Equals(itemCd[i]) && suffix[j].Equals(suffix[i]))
                                {
                                    // 条件指定の重複はエラー
                                    message = MSG_TARGET + wkItemName + MSG_ERRSAMECD;
                                    messages.Add(message);
                                    break;
                                }
                                j = j + 1;
                            }
                        }

                        double rslValueFrom_number = 0; // FROM側検査結果値(大小比較用)
                        string rslValueFrom_string = null; // FROM側検査結果値(大小比較用)
                        double rslValueTo_number = 0; // TO側検査結果値(大小比較用)
                        string rslValueTo_string = null; // TO側検査結果値(大小比較用)

                        // 片側ずつ値と記号がそろっているかチェック
                        // FROM側
                        bool isAvailableFrom = false;
                        if (!string.IsNullOrEmpty(rslValueFrom[i]))
                        {
                            // 値入力有り
                            if (!string.IsNullOrEmpty(rslMarkFrom[i]))
                            {
                                // 記号指定有りならFROM側指定有効
                                isAvailableFrom = true;
                            }
                            else
                            {
                                // FROM側記号未指定はエラー
                                message = MSG_TARGET + wkItemName + MSG_ERRNOOPTION;
                                messages.Add(message);
                            }
                            if (isNumeric)
                            {
                                // 大小比較用値をセット
                                if (!double.TryParse(rslValueFrom[i], out rslValueFrom_number))
                                {
                                    // 数値･計算タイプに対する数値以外の入力はエラー
                                    message = MSG_TARGET + wkItemName + MSG_ERRNOTNUMERIC;
                                    messages.Add(message);
                                }
                            }
                            else
                            {
                                // 大小比較用値をセット
                                rslValueFrom_string = rslValueFrom[i].Trim();
                            }
                        }
                        else
                        {
                            // 値入力なし
                            if (!string.IsNullOrEmpty(rslMarkFrom[i]))
                            {
                                // FROM側値未指定はエラー
                                message = MSG_TARGET + wkItemName + MSG_ERRNOVALUEF;
                                messages.Add(message);
                            }
                        }
                        // TO側
                        bool isAvailableTo = false;
                        if (!string.IsNullOrEmpty(rslValueTo[i]))
                        {
                            // 値入力有り
                            if (!string.IsNullOrEmpty(rslMarkTo[i]))
                            {
                                // 記号指定有りならTO側指定有効
                                isAvailableTo = true;
                            }
                            else
                            {
                                // TO側記号未指定はエラー
                                message = MSG_TARGET + wkItemName + MSG_ERRNOOPTION;
                                messages.Add(message);
                            }
                            if (isNumeric)
                            {
                                // 大小比較用値をセット
                                if (!double.TryParse(rslValueTo[i], out rslValueTo_number))
                                {
                                    // 数値･計算タイプに対する数値以外の入力はエラー
                                    message = MSG_TARGET + wkItemName + MSG_ERRNOTNUMERIC;
                                    messages.Add(message);
                                }
                            }
                            else
                            {
                                // 大小比較用値をセット
                                rslValueTo_string = rslValueTo[i].Trim();
                            }
                        }
                        else
                        {
                            // 値入力なし
                            if (!string.IsNullOrEmpty(rslMarkTo[i]))
                            {
                                // TO側値未指定はエラー
                                message = MSG_TARGET + wkItemName + MSG_ERRNOVALUET;
                                messages.Add(message);
                            }
                        }

                        // FROM、TO両方指定された場合の関連チェック
                        if (isAvailableFrom && isAvailableTo)
                        {
                            // 記号の範囲チェック
                            if (rslMarkFrom[i].Equals(rslMarkTo[i]))
                            {
                                // 共に同じ記号はエラー
                                message = MSG_TARGET + wkItemName + MSG_ERRRANGEB;
                                messages.Add(message);
                            }
                            else
                            {
                                if (rslMarkFrom[i].Equals(OPTION_EQ) || rslMarkFrom[i].Equals(OPTION_LE))
                                {
                                    // TO側範囲指定無効はエラー
                                    message = MSG_TARGET + wkItemName + MSG_ERRRANGET;
                                    messages.Add(message);
                                }
                                if (rslMarkTo[i].Equals(OPTION_EQ) || rslMarkTo[i].Equals(OPTION_GE))
                                {
                                    // FROM側範囲指定無効はエラー
                                    message = MSG_TARGET + wkItemName + MSG_ERRRANGEF;
                                    messages.Add(message);
                                }
                            }
                            // 大小チェック
                            if (isNumeric)
                            {
                                if (rslValueFrom_number > rslValueTo_number)
                                {
                                    // FROM側がTO側より大きいときは範囲指定エラー
                                    message = MSG_TARGET + wkItemName + MSG_ERRRANGE;
                                    messages.Add(message);
                                }
                            }
                            else
                            {
                                if (string.Compare(rslValueFrom_string, rslValueTo_string) > 0)
                                {
                                    // FROM側がTO側より大きいときは範囲指定エラー
                                    message = MSG_TARGET + wkItemName + MSG_ERRRANGE;
                                    messages.Add(message);
                                }
                            }
                        }
                    }
                }

                break;
            }

            // 戻り値の編集
            rslCondition = condition;

            return messages;
        }

        /// <summary>
        /// 汎用データ抽出項目の妥当性チェックを行う
        /// </summary>
        /// <param name="chkDate">受診年月日フラグ</param>
        /// <param name="chkCsCd">コースコードフラグ</param>
        /// <param name="chkOrgCd">団体コードフラグ</param>
        /// <param name="chkAge">受診時年齢フラグ</param>
        /// <param name="chkJud">総合判定フラグ</param>
        /// <param name="chkPerId">個人IDフラグ</param>
        /// <param name="chkName">氏名フラグ</param>
        /// <param name="chkBirth">生年月日フラグ</param>
        /// <param name="chkGender">性別フラグ</param>
        /// <param name="optResult">検査項目抽出条件</param>
        /// <param name="selItemCd">検査項目コードの配列</param>
        /// <param name="chkOrgBsdCd">事業部コードフラグ</param>
        /// <param name="chkOrgRoomCd">室部コードフラグ</param>
        /// <param name="chkOrgPostCd">所属コードフラグ</param>
        /// <param name="chkEmpNo">従業員フラグ</param>
        /// <param name="chkPOrgCd">団体コードフラグ</param>
        /// <param name="chkPOrgBsdCd">事業部コードフラグ</param>
        /// <param name="chkPOrgRoomCd">室部コードフラグ</param>
        /// <param name="chkPOrgPostCd">所属コードフラグ</param>
        /// <param name="chkOverTime">超過時間フラグ</param>
        /// <returns></returns>
        public IList<string> CheckValueDatSelect(
            string chkDate,
            string chkCsCd,
            string chkOrgCd,
            string chkAge,
            string chkJud,
            string chkPerId,
            string chkName,
            string chkBirth,
            string chkGender,
            string optResult,
            ref string[] selItemCd,
            string chkOrgBsdCd,
            string chkOrgRoomCd,
            string chkOrgPostCd,
            string chkEmpNo,
            string chkPOrgCd,
            string chkPOrgBsdCd,
            string chkPOrgRoomCd,
            string chkPOrgPostCd,
            string chkOverTime
        )
        {
            const string MSG_NOITEM = "検査項目が指定されていません。";
            const string MSG_NOTSELECTED = "抽出項目がありません。";

            var messages = new List<string>(); // エラーメッセージの集合
            bool isSelectedItem; // 検査項目コード未選択判定用
            int i;     // インデックス

            // 各指定値チェック処理
            switch (optResult)
            {
                case CASE_SELECT:

                    // 検査項目指定時の検査項目未指定の判定

                    // 判定フラグ初期値
                    isSelectedItem = false;

                    // 検査項目コードが1件でも選択されていればクリア
                    i = 0;
                    while (i < selItemCd.Length)
                    {
                        if (!string.IsNullOrEmpty(selItemCd[i]))
                        {
                            isSelectedItem = true;
                            break;
                        }
                        i = i + 1;
                    }

                    if (!isSelectedItem)
                    {
                        // エラーメッセージ追加
                        messages.Add(MSG_NOITEM);
                    }

                    break;

                case CASE_NOTSELECT:

                    // 検査項目未抽出時の抽出データ未指定の判定

                    // 抽出項目が1件も選択されていなければエラーメッセージ追加
                    if (string.IsNullOrEmpty(chkDate) &&
                        string.IsNullOrEmpty(chkCsCd) &&
                        string.IsNullOrEmpty(chkOrgCd) &&
                        string.IsNullOrEmpty(chkOrgBsdCd) &&
                        string.IsNullOrEmpty(chkOrgRoomCd) &&
                        string.IsNullOrEmpty(chkOrgPostCd) &&
                        string.IsNullOrEmpty(chkAge) &&
                        string.IsNullOrEmpty(chkJud) &&
                        string.IsNullOrEmpty(chkPerId) &&
                        string.IsNullOrEmpty(chkEmpNo) &&
                        string.IsNullOrEmpty(chkPOrgCd) &&
                        string.IsNullOrEmpty(chkPOrgBsdCd) &&
                        string.IsNullOrEmpty(chkPOrgRoomCd) &&
                        string.IsNullOrEmpty(chkPOrgPostCd) &&
                        string.IsNullOrEmpty(chkOverTime) &&
                        string.IsNullOrEmpty(chkName) &&
                        string.IsNullOrEmpty(chkBirth) &&
                        string.IsNullOrEmpty(chkGender))
                    {
                        messages.Add(MSG_NOTSELECTED);
                    }

                    break;
            }

            // 戻り値の編集
            if (messages.Count > 0)
            {
                return messages;
            }

            return null;
        }

        /// <summary>
        /// 受診者一覧検索用条件節作成
        /// </summary>
        /// <param name="key">検索キー</param>
        /// <param name="existsRsvNo">検索キーに予約番号が存在するか</param>
        /// <param name="existsDayId">検索キー当日IDにが存在するか</param>
        /// <param name="existsOcrNo">検索キーにOCR番号が存在するか</param>
        /// <param name="existsLockerKey">検索キーにロッカーキーが存在するか</param>
        /// <param name="param">パラメーター</param>
        /// <returns>条件節</returns>
        string CreateConditionForDailyList(
            string key,
            out bool existsRsvNo,
            out bool existsDayId,
            out bool existsOcrNo,
            out bool existsLockerKey,
            ref Dictionary<string, object> param
        )
        {
            existsRsvNo = false;
            existsDayId = false;
            existsOcrNo = false;
            existsLockerKey = false;

            var condition = new List<string>(); // 条件節の集合

            // 引数未設定時は何もしない
            if (string.IsNullOrEmpty(key.Trim()))
            {
                return null;
            }

            // 文字列の分割
            var keys = new string[] { key };

            // 検索キー数分の条件節を追加
            for (var i = 0; i < keys.Length; i++)
            {
                // 検索キーのタイプを判別し、条件節に変換して追加

                // 全角文字が含まれる(半角カナもここに含まれる)
                if (personDao.IsWide(keys[i]))
                {
                    AppendCondition_Wide(ref condition, ref param, keys[i], i);
                    continue;
                }

                // 個人ＩＤ
                if (personDao.IsPerId(keys[i]))
                {
                    AppendCondition_PerId(ref condition, ref param, keys[i], i);
                    continue;
                }

                // 当日ＩＤ
                if (IsDayId(keys[i]))
                {
                    AppendCondition_DayId(ref condition, ref param, keys[i], i);
                    existsDayId = true;
                    continue;
                }

                // 生年月日
                if (personDao.IsBirth(keys[i]))
                {
                    AppendCondition_Birth(ref condition, ref param, keys[i], i);
                    continue;
                }

                // 予約番号
                if (IsRsvNo(keys[i]))
                {
                    AppendCondition_RsvNo(ref condition, ref param, keys[i], i);
                    existsRsvNo = true;
                    continue;
                }

                // OCR番号
                if (IsOcrNo(keys[i]))
                {
                    AppendCondition_OcrNo(ref condition, ref param, keys[i], i);
                    existsOcrNo = true;
                    continue;
                }

                // ロッカー番号
                if (IsLockerKey(keys[i]))
                {
                    AppendCondition_LockerKey(ref condition, ref param, keys[i], i);
                    existsLockerKey = true;
                    continue;
                }

                // 上記以外はローマ字として検索
                AppendCondition_RomeName(ref condition, ref param, keys[i], i, false);
            }

            // すべての条件節をANDで連結
            return string.Join(" and ", condition);
        }

        /// <summary>
        /// 受診情報を削除する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="updUser">更新者</param>
        /// <param name="message">メッセージ</param>
        /// <returns>
        /// 1: 正常終了
        /// 0: 受診情報が存在しない
        /// -3: 非キャンセル者の予約情報を削除しようとした
        /// </returns>
        public int DeleteConsult(int rsvNo, string updUser, out string message)
        {
            // キー及び更新値の設定
            var param = new OracleDynamicParameters();
            param.Add("rsvno", rsvNo, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("upduser", updUser, OracleDbType.Varchar2, ParameterDirection.Input);

            // 戻り値・メッセージ用のバインド変数定義
            param.Add("ret", dbType: OracleDbType.Decimal, direction: ParameterDirection.ReturnValue);
            param.Add("message", dbType: OracleDbType.Varchar2, direction: ParameterDirection.Output);

            // 受診情報登録用ストアドパッケージの関数呼び出し
            var sql = @"
                begin
                    :ret := consultpackagelukes.deleteconsult(
                        :rsvno
                        , :upduser
                        , :message
                    );
                end;
            ";

            // PL/SQL文の実行
            connection.Execute(sql, param);

            // 戻り値の取得
            message = param.Get<OracleString>("message").ToString();

            // 戻り値の設定
            return param.Get<OracleDecimal>("ret").ToInt32();
        }

        /// <summary>
        /// 指定の条件に該当する受診情報テーブル他を読み込みCSVファイルを編集する
        /// </summary>
        /// <param name="fileName">CSVファイル名(物理パス)</param>
        /// <param name="tempFile">作業ファイル名(物理パス)</param>
        /// <param name="chkDate">受診年月日フラグ</param>
        /// <param name="chkCsCd">コースコードフラグ</param>
        /// <param name="chkOrgCd">団体コードフラグ</param>
        /// <param name="chkAge">受診時年齢フラグ</param>
        /// <param name="chkJud">総合判定フラグ</param>
        /// <param name="chkOrgBsdCd">事業部コードフラグ</param>
        /// <param name="chkOrgRoomCd">室部コードフラグ</param>
        /// <param name="chkOrgPostCd">所属コードフラグ</param>
        /// <param name="chkPerId">個人IDフラグ</param>
        /// <param name="chkName">氏名フラグ</param>
        /// <param name="chkBirth">生年月日フラグ</param>
        /// <param name="chkGender">性別フラグ</param>
        /// <param name="chkEmpNo">従業員フラグ</param>
        /// <param name="chkPOrgCd">団体コードフラグ</param>
        /// <param name="chkPOrgBsdCd">事業部コードフラグ</param>
        /// <param name="chkPOrgRoomCd">室部コードフラグ</param>
        /// <param name="chkPOrgPostCd">所属コードフラグ</param>
        /// <param name="chkOverTime">超過時間フラグ</param>
        /// <param name="optResult">検査項目抽出条件</param>
        /// <param name="chkOption">結果コメント・正常値フラグ</param>
        /// <param name="selItemCd">検査項目コードの配列</param>
        /// <param name="selSuffix">サフィックスの配列</param>
        /// <param name="startDate">受診年月日(自)</param>
        /// <param name="endDate">受診年月日(至)</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="orgBsdCd">事業部コード</param>
        /// <param name="orgRoomCd">室部コード</param>
        /// <param name="orgPostCd1">所属コード1</param>
        /// <param name="orgPostCd2">所属コード2</param>
        /// <param name="subCsCd">サブコースコード</param>
        /// <param name="startAge">受診時(自)年齢</param>
        /// <param name="endAge">受診時(至)年齢</param>
        /// <param name="gender">性別</param>
        /// <param name="itemCd">検査項目コードの配列</param>
        /// <param name="suffix">サフィックスの配列</param>
        /// <param name="rslValueFrom">検査結果(FROM側)の配列</param>
        /// <param name="rslMarkFrom">検査結果(FROM側)範囲指定の配列</param>
        /// <param name="rslValueTo">検査結果(TO側)の配列</param>
        /// <param name="rslMarkTo">検査結果(TO側)範囲指定の配列</param>
        /// <param name="rslCondition">検査結果条件(結果タイプ)</param>
        /// <param name="judClassCd">判定分類コードの配列</param>
        /// <param name="weightFrom">判定用重み(FROM側)の配列</param>
        /// <param name="judMarkFrom">判定コード(FROM側)範囲指定の配列</param>
        /// <param name="weightTo">判定用重み(TO側)の配列</param>
        /// <param name="judMarkTo">判定コード(TO側)範囲指定の配列</param>
        /// <param name="judCondition">検査結果条件</param>
        /// <param name="judOperation">総合判定条件指定演算子(0:AND、1:OR)</param>
        /// <param name="judAll">判定抽出方法(0:すべて、1:指定判定分類のみ)</param>
        /// <returns>編集したレコード件数</returns>
        public int EditCSVDatConsult(
            string fileName,
            string tempFile,
            string chkDate,
            string chkCsCd,
            string chkOrgCd,
            string chkAge,
            string chkJud,
            string chkOrgBsdCd,
            string chkOrgRoomCd,
            string chkOrgPostCd,
            string chkPerId,
            string chkName,
            string chkBirth,
            string chkGender,
            string chkEmpNo,
            string chkPOrgCd,
            string chkPOrgBsdCd,
            string chkPOrgRoomCd,
            string chkPOrgPostCd,
            string chkOverTime,
            string optResult,
            string chkOption,
            string[] selItemCd,
            string[] selSuffix,
            DateTime startDate,
            DateTime endDate,
            string csCd,
            string orgCd1,
            string orgCd2,
            string orgBsdCd,
            string orgRoomCd,
            string orgPostCd1,
            string orgPostCd2,
            string subCsCd,
            string startAge,
            string endAge,
            Gender gender,
            string[] itemCd,
            string[] suffix,
            string[] rslValueFrom,
            string[] rslMarkFrom,
            string[] rslValueTo,
            string[] rslMarkTo,
            string[] rslCondition,
            int?[] judClassCd,
            int?[] weightFrom,
            string[] judMarkFrom,
            int?[] weightTo,
            string[] judMarkTo,
            string[] judCondition,
            int judOperation,
            int judAll
        )
        {
            const string CHK_ON = "on"; // チェック時の値
            const int JUDCLASSROW = 3; // 総合判定の1件あたりの項目数

            string line; // 出力文字列(1行)

            int dataCount; // レコード件数(CSVファイルのデータ行数)
            bool cslPerFlg; // 受診歴情報および個人情報の抽出対象有無フラグ
            int rslCount; // 検査結果で2次抽出した検査結果レコード件数
            int rsvNoCount; // 抽出対象となるRsvNoの件数
            int judRslMax; // 抽出されたRsvNoに対する総合判定の最大件数
            int rslMax; // 抽出されたRsvNoに対する検査結果の最大件数

            string lineCslPer = null; // 受診歴情報、個人情報部の出力文字列
            string lineJudRsl = null; // 総合判定部の出力文字列
            string lineRsl; // 検査項目部の出力文字列

            DateTime wkStartDate; // 超過勤務時間の出力範囲(今月から1年前まで)
            DateTime wkEndDate; // 超過勤務時間の出力範囲(今月から1年前まで)

            // 初期処理
            judRslMax = 0;
            rslMax = 0;
            dataCount = 0;

            // 受診歴情報と個人情報が指定されているとき、抽出対象有無フラグの設定
            if (chkDate.Equals(CHK_ON) ||
               chkCsCd.Equals(CHK_ON) ||
               chkOrgCd.Equals(CHK_ON) ||
               chkOrgBsdCd.Equals(CHK_ON) ||
               chkOrgRoomCd.Equals(CHK_ON) ||
               chkOrgPostCd.Equals(CHK_ON) ||
               chkAge.Equals(CHK_ON) ||
               chkPerId.Equals(CHK_ON) ||
               chkName.Equals(CHK_ON) ||
               chkBirth.Equals(CHK_ON) ||
               chkGender.Equals(CHK_ON) ||
               chkEmpNo.Equals(CHK_ON) ||
               chkPOrgCd.Equals(CHK_ON) ||
               chkPOrgBsdCd.Equals(CHK_ON) ||
               chkPOrgRoomCd.Equals(CHK_ON) ||
               chkPOrgPostCd.Equals(CHK_ON) ||
               chkOverTime.Equals(CHK_ON))
            {
                cslPerFlg = true;
            }
            else
            {
                cslPerFlg = false;
            }

            while (true)
            {
                if (optResult.Equals(CASE_ALLSELECT))
                {
                    // グループ９９９の検査項目を取得し、検査項目配列に設定
                    SelectAllRslItem(out selItemCd, out selSuffix);
                    // 検査項目指定に置き換える
                    optResult = CASE_SELECT;
                }

                // 抽出条件に一致する予約番号の抽出
                IList<int> rsvNo = SelectDatRsvNoList(startDate, endDate, csCd, subCsCd, orgCd1, orgCd2,
                                 orgBsdCd, orgRoomCd, orgPostCd1, orgPostCd2,
                                 startAge, endAge, gender, itemCd, suffix,
                                 rslCondition,
                                 judClassCd,
                                 weightFrom, judMarkFrom, weightTo, judMarkTo,
                                 judCondition,
                                 judOperation
                                );

                // 該当データが無かったとき処理終了
                if (rsvNo.Count == 0)
                {
                    break;
                }

                var rsvNo2 = new List<int>(); // 検査結果条件で絞り込まれた抽出対象となるRsvNoの配列

                // 作業ファイルオープン
                using (var sw = new StreamWriter(tempFile, false))
                {
                    // 検査結果条件による抽出予約番号の絞込み、および検査結果データ行の編集
                    rsvNoCount = 0;

                    for (var i = 0; i < rsvNo.Count; i++)
                    {
                        while (true)
                        {
                            IList<string> results = SelectDatRsl(
                                rsvNo[i],
                                optResult,
                                chkOption,
                                itemCd,
                                suffix,
                                rslValueFrom,
                                rslMarkFrom,
                                rslValueTo,
                                rslMarkTo,
                                rslCondition,
                                selItemCd,
                                selSuffix,
                                out bool rsvNoSkipFlg,
                                out rslCount
                            );

                            // 検査結果の抽出条件に合致しなければ該当予約番号の以降の処理をスキップ
                            if (rsvNoSkipFlg)
                            {
                                break;
                            }

                            // RsvNoの格納
                            rsvNo2.Add(rsvNo[i]);
                            rsvNoCount = rsvNoCount + 1;

                            // 検査結果が抽出対象となっているとき抽出データの編集処理
                            if (!optResult.Equals(CASE_NOTSELECT))
                            {
                                // 検査結果抽出データが存在するとき出力文字列を編集、無ければ空文字行をセット
                                lineRsl = results.Count > 0 ? string.Join(",", results) : "";

                                // 作業ファイルに出力
                                sw.WriteLine(lineRsl);

                                // 抽出データ件数の最大値チェック・更新
                                if (rslCount > rslMax)
                                {
                                    rslMax = rslCount;
                                }
                            }

                            break;
                        }
                    }
                }

                // 該当データが無かったとき処理終了
                if (rsvNo2.Count == 0)
                {
                    break;
                }

                // 総合判定が抽出データとして指定されているとき
                if (chkJud.Equals(CHK_ON))
                {
                    // 総合判定件数の最大値を取得
                    IList<dynamic> judClasses = judClassDao.SelectJudClassList();
                    judRslMax = judClasses.Count;
                }

                // 作業ファイルオープン
                using (var sr = new StreamReader(tempFile))
                {
                    // CSVファイルオープン
                    using (var sw = new StreamWriter(fileName, false, Encoding.GetEncoding("shift_jis")))
                    {
                        // 見出し行の編集、およびファイル出力
                        line = "";

                        // 受診歴情報および個人情報部
                        if (cslPerFlg)
                        {
                            if (chkDate.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "受診日";
                            }
                            if (chkCsCd.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "コースコード";
                            }
                            if (chkOrgCd.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "受診時団体コード";
                            }
                            if (chkOrgBsdCd.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "受診時事業部コード";
                            }
                            if (chkOrgRoomCd.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "受診時室部コード";
                            }
                            if (chkOrgPostCd.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "受診時所属コード";
                            }
                            if (chkOrgCd.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "受診時団体";
                            }
                            if (chkOrgBsdCd.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "受診時事業部";
                            }
                            if (chkOrgRoomCd.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "受診時室部";
                            }
                            if (chkOrgPostCd.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "受診時所属";
                            }
                            if (chkAge.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "受診時年齢";
                            }
                            if (chkPOrgCd.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "団体コード";
                            }
                            if (chkPOrgBsdCd.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "事業部コード";
                            }
                            if (chkPOrgRoomCd.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "室部コード";
                            }
                            if (chkPOrgPostCd.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "所属コード";
                            }
                            if (chkPOrgCd.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "団体";
                            }
                            if (chkPOrgBsdCd.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "事業部";
                            }
                            if (chkPOrgRoomCd.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "室部";
                            }
                            if (chkPOrgPostCd.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "所属";
                            }
                            if (chkEmpNo.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "従業員番号";
                            }
                            if (chkPerId.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "個人ＩＤ";
                            }
                            if (chkName.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "姓,名";
                            }
                            if (chkBirth.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "生年月日";
                            }
                            if (chkGender.Equals(CHK_ON))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + "性別";
                            }
                            if (chkOverTime.Equals(CHK_ON))
                            {
                                // 今月から過去１２ヶ月分を展開
                                wkStartDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                                wkEndDate = wkStartDate.AddMonths(1);
                                string buffer;
                                for (var i = 1; i <= 12; i++)
                                {
                                    wkEndDate = wkEndDate.AddMonths(-1);
                                    buffer = wkEndDate.ToString(" yyyy/MM");
                                    line = line + (string.IsNullOrEmpty(line) ? "" : ",") + buffer;
                                }
                            }
                        }

                        // 総合判定部
                        if (judRslMax > 0)
                        {
                            // 総合判定部の最大件数分見出し作成
                            for (var i = 1; i <= judRslMax; i++)
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") +
                                    "判定分類名称(" + i.ToString() + "),判定コード(" + i.ToString() + "),略称(" + i.ToString() + ")";
                            }
                        }

                        // 検査結果項目部
                        if (rslMax > 0)
                        {
                            // 検査結果項目部の見出し取得（検査項目名)
                            IList<string> headers = SelectHeadRsl(selItemCd, selSuffix);

                            // 検査結果項目部の最大件数分見出し作成
                            for (var i = 0; i < headers.Count; i++)
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + headers[i];
                                // 結果コメント抽出指定があれば見出し追加
                                if (chkOption.Equals(CHK_ON))
                                {
                                    line = line +
                                        ",結果コメント1(" + i.ToString() + "),結果コメント名1(" + i.ToString() + ")," +
                                        "結果コメント2(" + i.ToString() + "),結果コメント名2(" + i.ToString() + ")," +
                                        "正常値フラグ(" + i.ToString() + ")";
                                }
                            }
                        }

                        // 見出し行をファイルに出力
                        sw.WriteLine(line);

                        // データ行の編集、およびファイル出力
                        for (var i = 0; i < rsvNo2.Count; i++)
                        {
                            // 受診歴情報と個人情報が指定されているとき、受診歴情報と個人情報の抽出
                            if (cslPerFlg)
                            {
                                IList<string> cslPer = SelectDatCslPer(
                                    rsvNo2[i],
                                    chkDate,
                                    chkCsCd,
                                    chkOrgCd,
                                    chkAge,
                                    chkEmpNo,
                                    chkPerId,
                                    chkName,
                                    chkBirth,
                                    chkGender
                                );

                                // 出力文字列の編集
                                lineCslPer = string.Join(",", cslPer);
                            }

                            // 総合判定が抽出指定されているとき
                            if (chkJud.Equals(CHK_ON) && (judRslMax > 0))
                            {
                                // 総合判定情報の抽出
                                string[] judResults = SelectDatJudRsl(
                                    rsvNo2[i],
                                    judAll,
                                    judCondition,
                                    judClassCd,
                                    weightFrom,
                                    judMarkFrom,
                                    weightTo,
                                    judMarkTo
                                );

                                string[] wkJudRsl;

                                // 最大件数に配列をそろえる
                                if ((judResults == null) || (judResults.Length == 0))
                                {
                                    wkJudRsl = new string[judRslMax * JUDCLASSROW];
                                }
                                else
                                {
                                    wkJudRsl = judResults;
                                    Array.Resize(ref wkJudRsl, judRslMax * JUDCLASSROW);
                                }

                                // 出力文字列の編集
                                lineJudRsl = string.Join(",", wkJudRsl);
                            }

                            // 出力データの編集
                            line = "";
                            // 受診歴情報および個人情報
                            if (cslPerFlg)
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + lineCslPer;
                            }
                            // 総合判定
                            if (chkJud.Equals(CHK_ON) && (judRslMax > 0))
                            {
                                line = line + (string.IsNullOrEmpty(line) ? "" : ",") + lineJudRsl;
                            }
                            // 検査結果情報
                            if (!optResult.Equals(CASE_NOTSELECT))
                            {
                                // 作業ファイルから１行読み出し、検査結果情報が存在すればデータ追加
                                string buffer = sr.ReadLine();
                                if (!string.IsNullOrEmpty(buffer))
                                {
                                    line = line + (string.IsNullOrEmpty(line) ? "" : ",") + buffer;
                                }
                            }

                            // データ１行をファイルに出力
                            sw.WriteLine(line);

                            dataCount = dataCount + 1;
                        }
                    }
                }

                break;
            }

            // 作業ファイル削除
            File.Delete(tempFile);

            // 戻り値の設定
            return dataCount;
        }

        /// <summary>
        /// サブコース用取得用のSQLステートメント編集
        /// </summary>
        /// <returns>SQLステートメント</returns>
        string EditSelectSubCourseStatement()
        {
            // 指定予約番号の受診オプション管理情報をもとに受診サブコースを取得する
            // (受診情報のコースコードと同値のサブコースは除く)
            var sql = @"
                select distinct
                    ctrpt_opt.cscd
                    , course_p.webcolor
                    , course_p.csname
                from
                    course_p
                    , ctrpt_opt
                    , consult_o
                where
                    consult_o.rsvno = :rsvno
                    and consult_o.ctrptcd = ctrpt_opt.ctrptcd
                    and consult_o.optcd = ctrpt_opt.optcd
                    and consult_o.optbranchno = ctrpt_opt.optbranchno
                    and ctrpt_opt.cscd != (
                        select
                            cscd
                        from
                            consult
                        where
                            rsvno = consult_o.rsvno
                    )
                    and ctrpt_opt.cscd = course_p.cscd
            ";

            return sql;
        }

        /// <summary>
        /// 受診者一覧のORDER BY句を作成する
        /// </summary>
        /// <param name="sortKey">ソートキー</param>
        /// <param name="sortType">ソート順(0:昇順、1:降順)</param>
        /// <param name="printFields">出力項目</param>
        /// <returns>ORDER BY句</returns>
        string EditSortOrder(int sortKey, int sortType, string[] printFields)
        {
            string sql = null; // SQLステートメント

            var sortOrder = new List<int>(); // 作業用ソート順配列

            string wkSortType; // 昇順・降順の指定

            bool addName = false; // 氏名を追加したか

            // まず指定されたソートキーが先頭に来る
            sortOrder.Add(sortKey);

            // 指定されたソートキーを飛ばして出力項目を順次追加
            foreach (var wkPrintField in printFields)
            {
                if (int.TryParse(wkPrintField, out int wkSortKey))
                {
                    if (wkSortKey != sortKey)
                    {
                        sortOrder.Add(wkSortKey);
                    }
                }
            }

            // ソート順ごとのキーワード設定
            wkSortType = (sortType == 1) ? " desc" : "";

            // 各ソートキーごとに対応する列名を追加
            for (var i = 0; i < sortOrder.Count; i++)
            {
                // 各種フラグの初期化
                bool isNotNull = false;
                bool isEdit = true;

                // 列名追加処理
                switch (sortOrder[i])
                {
                    case COL_DAYID:
                        sql = sql + "dayid" + wkSortType;
                        break;

                    case COL_COURSE:
                        sql = sql + "cscd" + wkSortType;
                        break;

                    case COL_NAME:
                    case COL_KANANAME:
                    case COL_BOTHNAME:
                        if (!addName)
                        {
                            sql = sql + "lastkname" + wkSortType + ", firstname" + wkSortType;
                            isNotNull = true;
                        }
                        else
                        {
                            isEdit = false;
                        }
                        break;

                    case COL_GENDER:
                        sql = sql + "gender" + wkSortType;
                        isNotNull = true;
                        break;

                    case COL_BIRTH:
                        sql = sql + "birth" + wkSortType;
                        isNotNull = true;
                        break;

                    case COL_AGE:
                        sql = sql + "age" + wkSortType;
                        break;

                    case COL_ORGSNAME:
                        sql = sql + "orgkname" + wkSortType;
                        break;

                    case COL_RSVNO:
                        sql = sql + "rsvno" + wkSortType;
                        break;

                    case COL_CSLDATE:
                        sql = sql + "csldate" + wkSortType;
                        sql = sql + " nulls " + (sortType == 0 ? "last" : "first");
                        isNotNull = true;
                        break;

                    case COL_RSVDATE:
                        sql = sql + "rsvdate" + wkSortType;
                        break;

                    case COL_ADDITEM:
                        isEdit = false;
                        break;

                    case COL_RPTDATE:
                        isEdit = false;
                        break;

                    case COL_PERID:
                        sql = sql + "perid" + wkSortType;
                        isNotNull = true;
                        break;

                    case COL_CONSULTITEM:
                        isEdit = false;
                        break;

                    case COL_ISRSIGN:
                        sql = sql + "isrsign" + wkSortType;
                        break;

                    case COL_ISRNO:
                        sql = sql + "isrno" + wkSortType;
                        break;

                    case COL_SUBCOURSE:
                        isEdit = false;
                        break;

                    case COL_ENTRY:
                        isEdit = false;
                        break;

                    case COL_RSVSTATUS:
                        sql = sql + "rsvstatus" + wkSortType;
                        break;

                    case COL_CARDPRINTDATE:
                        sql = sql + "cardprintdate" + wkSortType;
                        break;

                    case COL_FORMPRINTDATE:
                        sql = sql + "formprintdate" + wkSortType;
                        break;

                    case COL_RSVGRP:
                        sql = sql + "rsvgrpcd" + wkSortType;
                        break;

                    case COL_HASFRIENDS:
                        isEdit = false;
                        break;

                    default:
                        isEdit = false;
                        break;

                }

                // 項目が編集された場合
                if (isEdit)
                {
                    // NULLが許される項目の場合はNULL列のソート方法を追加
                    if (!isNotNull)
                    {
                        sql = sql + " nulls " + ((sortType == 0) ? "first" : "last");
                    }

                    // カンマを連結
                    sql = sql + ",";
                }
            }

            // 何も編集されなかった場合は処理を終了する
            if (string.IsNullOrEmpty(sql))
            {
                return null;
            }

            // 最後部のカンマを取り除き、ORDER BY句の編集を完了とする
            sql = "order by " + sql.TrimEnd(',');

            // 戻り値の設定
            return sql;
        }

        /// <summary>
        /// 指定検査項目の依頼有無をチェック
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <returns>true:依頼あり、false:依頼なし</returns>
        public bool ExistsItem(int rsvNo, string itemCd)
        {
            // キー値の設定
            var param = new OracleDynamicParameters();
            param.Add("rsvno", rsvNo, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("itemcd", itemCd, OracleDbType.Varchar2, ParameterDirection.Input);

            // 戻り値のバインド変数定義
            param.Add("ret", dbType: OracleDbType.Decimal, direction: ParameterDirection.ReturnValue);

            // 受診情報登録用ストアドパッケージの関数呼び出し
            var sql = @"
                begin
                    :ret := consultpackagelukes.existsitem(
                        :rsvno
                        ,
                        :itemcd
                    );
                end;
            ";

            // PL/SQL文の実行
            connection.Execute(sql, param);

            int Ret = param.Get<OracleDecimal>("ret").ToInt32();

            // 戻り値の設定
            return (Ret > 0);
        }

        /// <summary>
        /// 指定条件を満たす受診情報の予約番号を取得
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="perId">個人ID</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="division">区分
        /// "01":受診年月日・コース・個人ＩＤをキーとする受診情報の予約番号を取得
        /// "02":受診年月日・コース・個人ＩＤをキーとする１次健診受診情報の２次健診予約番号を取得
        /// </param>
        /// <returns>予約番号</returns>
        public int? GetRsvNo(DateTime cslDate, string perId, string csCd, string division = "")
        {
            string sql;  // SQLステートメント

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            param.Add("perid", perId);
            param.Add("cscd", csCd);

            // 検索条件を満たす受診情報の予約番号を取得するSQLステートメントの作成
            string basedStmt = @"
                select
                    perid
                    , rsvno
                from
                    consult
                where
                    csldate = :csldate
                    and perid = :perid
                    and cscd = :cscd
            ";

            // 各区分ごとの処理分岐
            switch (division)
            {
                case "":
                case "01":

                    // 受診年月日・コース・個人ＩＤをキーとする受診情報の予約番号を取得する場合
                    // １次健診の場合はOCR用受診日できく
                    sql = @"
                        select
                            perid
                            , rsvno
                        from
                            consult
                        where
                            ocrcsldate = :csldate
                            and perid = :perid
                            and cscd = :cscd
                    ";

                    break;

                case "02":

                    // 受診年月日・コース・個人ＩＤをキーとする１次健診受診情報の２次健診予約番号を取得する場合
                    // 先に作成したSQLで取得される予約番号を１次健診予約番号として持つ受診情報を取得
                    sql = @"
                        select
                            rsvno
                        from
                            consult
                        where
                            (perid, firstrsvno) in (" + basedStmt + @")
                    ";

                    break;

                // それ以外はエラー
                default:
                    throw new Exception("区分の値が不正です。");

            }

            // 検索条件を満たす受診情報テーブルのレコードを取得
            dynamic data = connection.Query(sql, param).FirstOrDefault();

            // レコードが存在しない場合
            if (data == null)
            {
                return null;
            }

            // 戻り値の設定
            return int.Parse(data.RSVNO);
        }

        /// <summary>
        /// バーコード文字列から予約番号を取得する
        /// </summary>
        /// <param name="barCodeStream">バーコード文字列</param>
        /// <returns>
        /// 正の値 予約番号
        /// 0   受診情報が存在しない
        /// -1  バーコード文字列が存在しない
        /// -2  文字列が不正
        /// -3  受診年月日が日付として認識できない
        /// -4  区分の値が不正
        /// </returns>
        public int GetRsvNoFromBarCode(string barCodeStream)
        {
            string cslDate; // 受診年月日
            string csCd; // コースコード
            string division; // 区分
            string perId; // 個人ＩＤ

            int ret;     // 関数戻り値

            while (true)
            {
                // バーコード値が存在しない場合は何もしない
                if (string.IsNullOrEmpty(barCodeStream))
                {
                    ret = -1;
                    break;
                }

                // ９桁以下の場合、予約番号が指定されたとみなし、チェックを行う
                if (barCodeStream.Length <= 9)
                {
                    // 数値チェック
                    if (!int.TryParse(barCodeStream, out int wkRsvNo))
                    {
                        ret = -2;
                        break;
                    }

                    // 存在チェック
                    if (SelectConsult(wkRsvNo) == null)
                    {
                        ret = 0;
                        break;
                    }

                    // 戻り値としてセット
                    ret = wkRsvNo;
                    break;
                }

                // (バーコード値は受診年月日(8桁)＋コースコード(4桁)＋区分(2桁)＋個人ＩＤ(1桁以上)で構成。よってここでは最低15桁以上存在する必要あり。)
                if (barCodeStream.Length >= 15)
                {
                    // 受診年月日・コースコード・区分・個人ＩＤ値の取得
                    cslDate = barCodeStream.Substring(0, 8);
                    csCd = barCodeStream.Substring(8, 4);
                    division = barCodeStream.Substring(12, 2);
                    perId = barCodeStream.Substring(14);

                    // 日付形式に編集
                    cslDate = cslDate.Substring(0, 4) + "/" + cslDate.Substring(4, 2) + "/" + cslDate.Substring(6, 2);

                    // 受診年月日が日付として認識できない場合はエラー
                    if (!DateTime.TryParse(cslDate, out DateTime wkCslDate))
                    {
                        ret = -3;
                        break;
                    }

                    // 区分は"01"、"02"のみ許可
                    if (!division.Equals("01") && !division.Equals("02"))
                    {
                        ret = -4;
                        break;
                    }

                    // 指定条件を満たす受診情報の予約番号を取得
                    ret = GetRsvNo(wkCslDate, perId, csCd, division) ?? 0;
                    break;
                }

                ret = -2;
                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 受診情報テーブルレコードを挿入する
        /// </summary>
        /// <param name="ipAddress">IPアドレス</param>
        /// <param name="updUser">更新者</param>
        /// <param name="data">受診情報</param>
        /// <param name="message">メッセージ</param>
        /// <returns>予約番号</returns>
        public int InsertConsult(string ipAddress, string updUser, InsertConsultationModel data, out string message)
        {
            // キー及び更新値の設定
            var param = new OracleDynamicParameters();
            param.Add("csldate", DateTime.Parse(data.Consult.CslDate), OracleDbType.Date, ParameterDirection.Input);
            param.Add("perid", data.Consult.PerId, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("cscd", data.Consult.CsCd, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("orgcd1", data.Consult.OrgCd1, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("orgcd2", data.Consult.OrgCd2, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("rsvgrpcd", data.Consult.RsvGrpCd, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("age", data.Consult.Age, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("upduser", updUser, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("ctrptcd", data.Consult.CtrPtCd, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("firstrsvno", data.Consult.FirstRsvNo, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("csldivcd", data.Consult.CslDivCd, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("rsvstatus", data.ConsultDetail.RsvStatus, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("prtonsave", data.ConsultDetail.PrtOnSave, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("cardaddrdiv", data.ConsultDetail.CardAddrDiv, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("cardouteng", data.ConsultDetail.CardOutEng, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("formaddrdiv", data.ConsultDetail.FormAddrDiv, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("formouteng", data.ConsultDetail.FormOutEng, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("reportaddrdiv", data.ConsultDetail.ReportAddrDiv, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("reportoureng", data.ConsultDetail.ReportOurEng, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("volunteer", data.ConsultDetail.Volunteer, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("volunteername", Strings.StrConv(data.ConsultDetail.VolunteerName, VbStrConv.Wide), OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("collectticket", data.ConsultDetail.CollectTicket, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("issuecslticket", data.ConsultDetail.IssueCslTicket, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("billprint", data.ConsultDetail.BillPrint, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("isrsign", data.ConsultDetail.IsrSign, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("isrno", data.ConsultDetail.IsrNo, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("isrmanno", data.ConsultDetail.IsrManNo, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("empno", data.ConsultDetail.EmpNo, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("introductor", data.ConsultDetail.Introductor, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("mode", data.Consult.Mode, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("dayid", data.Consult.DayId, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("ignoreflg", data.Consult.IgnoreFlg, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("ipaddress", ipAddress, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("sendmaildiv", data.ConsultDetail.SendMailDiv, OracleDbType.Decimal, ParameterDirection.Input);

            // オプション検査のバインド変数定義
            // 枝番がNULLの検査項目を削除
            Dictionary<string, int> options = data.ConsultOptions?.Where(r => r.Value != null).ToDictionary(r => r.Key, r => (int)r.Value);
            string[] optCd = options?.Keys.ToArray();
            int[] optBranchNo = options?.Values.ToArray();
            param.Add("optcd", optCd.Length == 0 ? new string[] { null } : optCd, OracleDbType.Varchar2, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("optbranchno", optBranchNo.Length == 0 ? new int[] { 0 } : optBranchNo, OracleDbType.Decimal, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("optcount", optCd.Length, OracleDbType.Decimal, ParameterDirection.Input);

            // 戻り値(予約番号・メッセージ)のバインド変数定義
            param.Add("ret", dbType: OracleDbType.Decimal, direction: ParameterDirection.ReturnValue);
            param.Add("message", dbType: OracleDbType.Varchar2, direction: ParameterDirection.Output, size: 1000);

            // 受診情報登録用ストアドパッケージの関数呼び出し
            var sql = @"
                begin
                    :ret := consultpackagelukes.insertconsult(
                        :csldate
                        , :perid
                        , :cscd
                        , :orgcd1
                        , :orgcd2
                        , :rsvgrpcd
                        , :age
                        , :upduser
                        , :ctrptcd
                        , :firstrsvno
                        , :csldivcd
                        , :rsvstatus
                        , :prtonsave
                        , :cardaddrdiv
                        , :cardouteng
                        , :formaddrdiv
                        , :formouteng
                        , :reportaddrdiv
                        , :reportoureng
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
                        , :mode
                        , :dayid
                        , :message
                        , :ignoreflg
                        , :ipaddress
                        , :sendmaildiv
                    );
                end;
            ";

            // PL/SQL文の実行
            connection.Execute(sql, param);

            // 戻り値の取得
            var dbMessage = param.Get<OracleString>("message");
            message = dbMessage.IsNull ? null : dbMessage.Value;

            // 戻り値の設定
            return param.Get<OracleDecimal>("ret").ToInt32();
        }

        //
        //  機能　　 : 検索キーが当日ＩＤ指定かをチェック
        //
        //  引数　　 : (In)     buffer  検索キー
        //
        //  戻り値　 :
        //
        //  備考　　 :
        //
        bool IsDayId(string buffer)
        {
            bool Ret = true; // 関数戻り値

            while (true)
            {
                // 先頭４文字が"DID:"の場合
                if (buffer.Length >= PREFIX_DAYID.Length && buffer.Substring(0, PREFIX_DAYID.Length).ToUpper().Equals(PREFIX_DAYID))
                {
                    // 接頭子を除外
                    string buffer2 = buffer.Substring(PREFIX_DAYID.Length);
                    if (string.IsNullOrEmpty(buffer2))
                    {
                        Ret = false;
                        break;
                    }

                    // すべての文字列が数字であるかをチェック
                    if (!Regex.IsMatch(buffer2, @"^[0-9]+$"))
                    {
                        Ret = false;
                        break;
                    }

                    break;
                }

                // ４桁以外の場合は当日ＩＤ指定とみなさない
                if (buffer.Length != (int)LengthConstants.LENGTH_RECEIPT_DAYID)
                {
                    Ret = false;
                    break;
                }

                // すべての文字列が数字であるかをチェック
                if (!Regex.IsMatch(buffer, @"^[0-9]+$"))
                {
                    Ret = false;
                }

                break;
            }

            return Ret;
        }

        /// <summary>
        /// 指定予約番号の受診情報が指定受付日にて受付済みかをチェック
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="cslDate">受診日(受付日)</param>
        /// <returns>指定受付日の当日ＩＤ(未受付時はnull)</returns>
        public int? IsReceipt(int rsvNo, DateTime cslDate)
        {
            int? dayId = null; // 当日ＩＤ

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("csldate", cslDate);

            // 検索条件を満たす受付情報テーブルのレコードを取得
            var sql = @"
                select
                    dayid
                from
                    receipt
                where
                    csldate = :csldate
                    and rsvno = :rsvno
            ";

            dynamic data = connection.Query(sql, param).FirstOrDefault();

            // レコードが存在する場合
            if (data != null)
            {
                // 当日ＩＤの取得
                dayId = Convert.ToInt32(data.DAYID);
            }

            // 戻り値の設定
            return dayId;
        }

        //
        //  機能　　 : 検索キーが個人ＩＤ指定かをチェック
        //
        //  引数　　 : (In)     buffer  検索キー
        //
        //  戻り値　 :
        //
        //  備考　　 :
        //
        bool IsRsvNo(string buffer)
        {
            // 先頭６文字が"RSVNO:"でなければ予約番号指定ではない
            if (buffer.Length < PREFIX_RSVNO.Length || !buffer.Substring(0, PREFIX_RSVNO.Length).ToUpper().Equals(PREFIX_RSVNO))
            {
                return false;
            }

            // 残りの文字列が数字列でなければ予約番号指定ではない
            if (!int.TryParse(buffer.Substring(PREFIX_RSVNO.Length).Trim(), out int wkRsvNo))
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// 検索キーがOCR番号指定かをチェック
        /// </summary>
        /// <param name="buffer">検索キー</param>
        /// <returns>OCR番号指定であればtrueを返す</returns>
        bool IsOcrNo(string buffer)
        {
            // 先頭４文字が"OCR:"でなければOCR番号指定ではない
            if (buffer.Length < PREFIX_OCRNO.Length || !buffer.Substring(0, PREFIX_OCRNO.Length).ToUpper().Equals(PREFIX_OCRNO))
            {
                return false;
            }

            // 残りの文字列が数字列でなければOCR番号指定ではない
            string ocrNo = buffer.Substring(PREFIX_RSVNO.Length).Trim();
            if (string.IsNullOrEmpty(ocrNo))
            {
                return false;
            }

            if (!int.TryParse(ocrNo, out int wkOcrNo))
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// 検索キーがロッカー番号指定かをチェック
        /// </summary>
        /// <param name="buffer">検索キー</param>
        /// <returns>ロッカー番号指定であればtrueを返す</returns>
        bool IsLockerKey(string buffer)
        {
            string lockerKey;   // ロッカー番号

            // 先頭４文字が"KEY:"でなければロッカー番号指定ではない
            if (buffer.Length < PREFIX_LOCKERKEY.Length || !buffer.Substring(0, PREFIX_LOCKERKEY.Length).ToUpper().Equals(PREFIX_LOCKERKEY))
            {
                return false;
            }

            // 残りの文字列が数字列でなければロッカー番号指定ではない
            lockerKey = buffer.Substring(PREFIX_LOCKERKEY.Length).Trim();
            if (string.IsNullOrEmpty(lockerKey))
            {
                return false;
            }

            if (!int.TryParse(lockerKey, out int wkLockerKey))
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// 1件単位の受付を行う
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="cslDate">受診年月日</param>
        /// <param name="updUser">更新者</param>
        /// <param name="mode">(0:受付しない、1:最終番号の次IDで受付、2:欠番を検索して発番、3:ID直接指定)</param>
        /// <param name="cntlNo">管理番号</param>
        /// <param name="dayId">当日ID(受付処理モード=3の場合のみ有効)</param>
        /// <param name="ipAddress">IPアドレス</param>
        /// <param name="message">メッセージ</param>
        /// <returns>当日ID</returns>
        public int Receipt(int rsvNo, DateTime cslDate, string updUser, int mode, int cntlNo, int dayId, string ipAddress, out string message)
        {
            // キー及び更新値の設定
            var param = new OracleDynamicParameters();
            param.Add("rsvno", rsvNo, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("csldate", cslDate, OracleDbType.Date, ParameterDirection.Input);
            param.Add("mode", mode, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("cntlno", cntlNo, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("dayid", dayId, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("upduser", updUser, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("ipaddress", ipAddress, OracleDbType.Varchar2, ParameterDirection.Input);

            // 戻り値のバインド変数定義
            param.Add("ret", dbType: OracleDbType.Decimal, direction: ParameterDirection.ReturnValue);
            param.Add("message", dbType: OracleDbType.Varchar2, direction: ParameterDirection.Output);

            // 受診情報登録用ストアドパッケージの関数呼び出し
            var sql = @"
                begin
                    :ret := consultpackagelukes.receiptsingle(
                        :rsvno
                        , :csldate
                        , :upduser
                        , :mode
                        , :cntlno
                        , :dayid
                        , :ipaddress
                        , :message
                    );
                end;
            ";

            // PL/SQL文の実行
            connection.Execute(sql, param);

            // 戻り値の取得
            message = param.Get<OracleString>("message").ToString();

            // 戻り値の設定
            return param.Get<OracleDecimal>("ret").ToInt32();
        }

        /// <summary>
        /// 一括受付を行う
        /// </summary>
        /// <param name="mode">受付処理モード(1:最終番号の次IDで受付、2:欠番を検索して発番)</param>
        /// <param name="cslDate">受診年月日</param>
        /// <param name="cntlNo">管理番号</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="ipAddress">IPアドレス</param>
        /// <param name="updUser">更新者</param>
        /// <returns>受付処理件数</returns>
        public int ReceiptAll(int mode, DateTime cslDate, int cntlNo, string csCd, string ipAddress, string updUser)
        {
            // キー及び更新値の設定
            var param = new OracleDynamicParameters();
            param.Add("mode", mode, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("csldate", cslDate, OracleDbType.Date, ParameterDirection.Input);
            param.Add("cntlno", cntlNo, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("cscd", csCd, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("ipaddress", ipAddress, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("upduser", updUser, OracleDbType.Varchar2, ParameterDirection.Input);

            // 戻り値のバインド変数定義
            param.Add("ret", dbType: OracleDbType.Decimal, direction: ParameterDirection.ReturnValue);

            // 受診情報登録用ストアドパッケージの関数呼び出し
            var sql = @"
                begin
                    :ret := consultpackagelukes.receiptall(
                        :mode
                        , :csldate
                        , :cntlno
                        , :cscd
                        , :ipaddress
                        , :upduser
                    );
                end;
            ";

            // PL/SQL文の実行
            connection.Execute(sql, param);

            // 戻り値の設定
            return param.Get<OracleDecimal>("ret").ToInt32();
        }

        string ReplaceKanaString(ref string expression)
        {
            string buffer;   // 文字列バッファ

            buffer = expression;
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
        /// キャンセル受診情報を復元する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="updUser">更新者</param>
        /// <param name="message">メッセージ</param>
        /// <param name="ignoreFlg">予約枠無視フラグ</param>
        /// <returns>
        /// 正の値: 予約番号
        /// 0: 受診情報が存在しない
        /// -3: 受診情報がキャンセル状態でない
        /// -30: 枠溢れ
        /// </returns>
        public int RestoreConsult(int rsvNo, string updUser, ref String message, int ignoreFlg = 0)
        {
            // キー及び更新値の設定
            var param = new OracleDynamicParameters();
            param.Add("rsvno", rsvNo, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("upduser", updUser.Trim(), OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("ignoreflg", ignoreFlg, OracleDbType.Decimal, ParameterDirection.Input);

            // 戻り値・メッセージ用のバインド変数定義
            param.Add("ret", dbType: OracleDbType.Decimal, direction: ParameterDirection.ReturnValue);
            param.Add("message", dbType: OracleDbType.Varchar2, direction: ParameterDirection.Output, size:255);

            // 受診情報登録用ストアドパッケージの関数呼び出し
            var sql = @"
                begin
                    :ret := consultpackagelukes.restoreconsult(
                        :rsvno
                        , :upduser
                        , :message
                        , :ignoreflg
                    );
                end;
            ";

            // PL/SQL文の実行
            connection.Execute(sql, param);

            // 戻り値の取得
            message = param.Get<OracleString>("message").ToString();
            // 戻り値の設定
            return param.Get<OracleDecimal>("ret").ToInt32();
        }

        /// <summary>
        /// 指定予約番号の受診情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="cancelFlg">キャンセルフラグ</param>
        /// <param name="recordLock">レコードロックを行うか</param>
        /// <returns>
        /// 受診情報
        /// csldate 受診日
        /// cancelFlg キャンセルフラグ
        /// perid 個人ID
        /// cscd コースコード
        /// orgcd1 団体コード1
        /// orgcd2 団体コード2
        /// rsvdate 予約日
        /// age 受診時年齢
        /// upddate (受診情報の)更新日時
        /// upduser 更新者
        /// reportprintdate 成績書出力日
        /// firstrsvno １次健診の予約番号
        /// isrsign 受診時健保記号
        /// isrno 受診時健保番号
        /// ctrptcd 契約パターンコード
        /// orgsname 団体略称
        /// rptupddate (受付情報の)更新日時
        /// lastname 姓
        /// firstname 名
        /// lastkname カナ姓
        /// firstkname カナ名
        /// birth 生年月日
        /// gender 性別
        /// spare1 予備１(患者番号)
        /// csname コース名
        /// orgname 団体名称
        /// username 更新者名
        /// dayid 当日ID
        /// firstcsldate １次健診の受診日
        /// firstcsname １次健診のコース名
        /// csldivcd 受診区分コード
        /// rsvgrpcd 予約群コード
        /// cslcount 受診回数
        /// </returns>
        public dynamic SelectConsult(int rsvNo, int? cancelFlg = null, bool recordLock = false)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            if (cancelFlg != null)
            {
                param.Add("cancelflg", cancelFlg);
            }

            // 検索条件を満たす受診情報テーブルのレコードを取得
            var sql = @"
                select
                    consult.rsvno
                    , consult.csldate
                    , consult.cancelflg
                    , consult.perid
                    , consult.cscd
                    , consult.orgcd1
                    , consult.orgcd2
                    , consult.rsvdate
                    , to_char(consult.age, '999.99') age
                    , consult.upddate
                    , consult.upduser
                    , consult.reportprintdate
                    , consult.firstrsvno
            ";

            sql += @"
                    , consult.isrsign
                    , consult.isrno
                    , consult.ctrptcd
                    , org.orgsname
                    , receipt.upddate rptupddate
                    , person.lastname
                    , person.firstname
                    , person.lastkname
                    , person.firstkname
                    , person.birth
                    , person.gender
                    , person.spare1
            ";

            sql += @"
                    , course_p.csname
                    , org.orgname
                    , hainsuser.username
                    , receipt.dayid
                    , firstconsult.csldate firstcsldate
                    , firstcourse.csname firstcsname
                    , consult.csldivcd
                    , consult.rsvgrpcd
                    , person.cslcount
            ";

            sql += @"
                from
                    person
                    , course_p firstcourse
                    , consult firstconsult
                    , hainsuser
                    , org
                    , course_p
                    , receipt
                    , consult
                where
                    consult.rsvno = :rsvno
            ";

            // キャンセルフラグ指定時は条件節に追加
            if (cancelFlg != null)
            {
                sql += @"
                    and consult.cancelflg = :cancelflg
                ";
            }

            sql += @"
                    and consult.cscd = course_p.cscd
                    and consult.orgcd1 = org.orgcd1
                    and consult.orgcd2 = org.orgcd2
                    and consult.upduser = hainsuser.userid(+)
                    and consult.firstrsvno = firstconsult.rsvno(+)
                    and firstconsult.cscd = firstcourse.cscd(+)
                    and consult.rsvno = receipt.rsvno(+)
                    and consult.csldate = receipt.csldate(+)
            ";

            sql += @"
                    and consult.perid = person.perid
            ";

            // レコードロック指定
            if (recordLock)
            {
                sql += @"
                for update
                ";
            }

            dynamic data = connection.Query(sql, param).FirstOrDefault();

            if (data != null) {
                DateTime birth = DateTime.Parse(Convert.ToString(data.BIRTH));
                data.birtherayear = (object)WebHains.JapaneseCalendar.GetYear(birth);
                // 和暦年を取得
                data.birthyearshorteraname = WebHains.GetShortEraName(birth);
                // 和暦元号(英字表記)を取得

            }

            return data;
        }

        /// <summary>
        /// 検索条件を満たす受診者の一覧を取得する(枠予約用)
        /// </summary>
        /// <param name="startRsvNo">開始予約番号</param>
        /// <param name="endRsvNo">終了予約番号</param>
        /// <returns>
        /// 受診者一覧情報
        /// rsvno 予約番号
        /// csldate 受診日
        /// webcolor webカラー
        /// csname コース名
        /// perid 個人ID
        /// lastname 姓
        /// firstname 名
        /// lastkname カナ姓
        /// firstkname カナ名
        /// gender 性別
        /// birth 生年月日
        /// age 年齢
        /// orgcd1 団体コード1
        /// orgcd2 団体コード2
        /// orgsname 団体略称
        /// rsvgrpname 予約群名称
        /// optname オプション名
        /// compperid 同伴者個人ID
        /// hasfriends お連れ様情報の有無
        /// </returns>
        public IList<dynamic> SelectConsultListForFraRsv(int startRsvNo, int endRsvNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("strrsvno", startRsvNo);
            param.Add("endrsvno", endRsvNo);

            // 指定予約番号範囲の受診者一覧を取得
            var sql = @"
                select
                    consult.rsvno
                    , consult.csldate
                    , course_p.webcolor
                    , ctrpt.csname
                    , consult.perid
                    , person.lastname
                    , person.firstname
                    , person.lastkname
                    , person.firstkname
                    , person.gender
                    , person.birth
                    , consult.age
                    , consult.orgcd1
                    , consult.orgcd2
                    , org.orgsname
                    , rsvgrp.rsvgrpname
                    , consultpackagelukes.getoptnamelistforfrarsv(consult.rsvno) optname
                    , person.compperid
                    , (
                        select
                            case
                                when count(*) > 0 then 1
                                else 0
                            end
                        from
                            friends
                        where
                            rsvno = consult.rsvno
                    ) hasfriends
                from
                    rsvgrp
                    , org
                    , person
                    , ctrpt
                    , course_p
                    , consult
                where
                    consult.rsvno between :strrsvno and :endrsvno
                    and consult.cscd = course_p.cscd
                    and consult.ctrptcd = ctrpt.ctrptcd
                    and consult.perid = person.perid
                    and consult.orgcd1 = org.orgcd1
                    and consult.orgcd2 = org.orgcd2
                    and consult.rsvgrpcd = rsvgrp.rsvgrpcd
                order by
                    consult.rsvno
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定予約番号、SEQの受診情報ログを取得します。
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="seq">SEQ</param>
        /// <returns>
        /// 受診情報ログ
        /// upddate 処理日
        /// upduser 更新者
        /// cslinfo 予約更新情報
        /// username 更新者名
        /// </returns>
        public dynamic SelectConsultLog(int rsvNo, int seq)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("seq", seq);

            var sql = @"
                select
                    consult_log.upddate
                    , consult_log.upduser
                    , consult_log.cslinfo
                    , hainsuser.username
                from
                    hainsuser
                    , consult_log
                where
                    consult_log.rsvno = :rsvno
                    and consult_log.seq = :seq
                    and consult_log.upduser = hainsuser.userid(+)
            ";

            return connection.Query(sql, param).Select(rec =>
            {
                rec.CSLINFO = Encoding.UTF8.GetString((byte[])rec.CSLINFO);
                return rec;
            }).FirstOrDefault();
        }

        /// <summary>
        /// 指定条件を満たす受診情報ログを取得します。
        /// </summary>
        /// <param name="startDate">開始処理日</param>
        /// <param name="endDate">終了処理日</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="updUser">更新者</param>
        /// <param name="orderByItem">ソート項目</param>
        /// <param name="orderByMode">ソート方向</param>
        /// <param name="startPos">検索開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <returns>
        /// 受診情報ログ
        /// rsvno 予約番号
        /// seq SEQ
        /// upddate 処理日
        /// upduser 更新者
        /// username 更新者名
        /// cslinfo 予約更新情報
        /// </returns>
        public PartialDataSet SelectConsultLogList(
            DateTime startDate,
            DateTime endDate,
            int? rsvNo,
            string updUser,
            int orderByItem,
            int orderByMode,
            int startPos,
            int getCount
        )
        {
            string sql = null; // SQLステートメント
            int recCount = 0; // レコード数
            IList<dynamic> data = null; // 検索データ

            // 開始日より終了日が過去であれば値を交換
            if (startDate > endDate)
            {
                DateTime wkDate = startDate;
                startDate = endDate;
                endDate = wkDate;
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("strdate", startDate);
            param.Add("enddate", endDate.AddDays(1));
            param.Add("rsvno", rsvNo);
            param.Add("upduser", updUser);
            param.Add("startpos", startPos);
            param.Add("endpos", (startPos + getCount - 1));

            // 条件節の編集

            // 件数取得と実データ取得という２回分のSQL発行
            for (var phase = 0; phase <= 1; phase++)
            {
                switch (phase)
                {
                    case 0:

                        // 件数取得の場合
                        sql = @"
                            select
                                count(*) cnt
                            from
                                consult_log
                            where
                                consult_log.upddate >= :strdate
                                and consult_log.upddate < :enddate
                                and consult_log.upduser = nvl(:upduser, consult_log.upduser)
                        ";

                        if (rsvNo > 0)
                        {
                            sql += @"
                                and consult_log.rsvno = :rsvno
                            ";
                        }

                        break;

                    case 1:  // 実データ取得の場合

                        sql = @"
                            select
                                loglist.rsvno
                                , loglist.seq
                                , loglist.upddate
                                , loglist.upduser
                                , loglist.username
                                , consult_log.cslinfo
                            from
                                consult_log
                                , (
                                    select
                                        rownum rowseq
                                        , rsvno
                                        , seq
                                        , upddate
                                        , upduser
                                        , username
                                    from
                                        (
                                            select
                                                consult_log.rsvno
                                                , consult_log.seq
                                                , consult_log.upddate
                                                , consult_log.upduser
                                                , hainsuser.username
                                            from
                                                hainsuser
                                                , consult_log
                                            where
                                                consult_log.upddate >= :strdate
                                                and consult_log.upddate < :enddate
                                                and consult_log.upduser = nvl(:upduser, consult_log.upduser)
                                                and consult_log.upduser = hainsuser.userid
                        ";

                        if (rsvNo > 0)
                        {
                            sql += @"
                                                and consult_log.rsvno = :rsvno
                            ";
                        }

                        // ソート項目の設定
                        string orderByClause; // ORDER BY句
                        switch (orderByItem)
                        {
                            case 1:
                                // ユーザＩＤ、更新日、予約番号順
                                orderByClause = @"
                                    order by
                                        hainsuser.username xxx
                                        , consult_log.upddate xxx
                                        , consult_log.rsvno xxx
                                ";
                                break;
                            case 2:
                                // 予約番号、更新日、ユーザＩＤ順
                                orderByClause = @"
                                    order by
                                        consult_log.rsvno xxx,
                                        consult_log.upddate xxx,
                                        hainsuser.username xxx
                                ";
                                break;
                            default:
                                // 更新日、ユーザＩＤ、予約番号順
                                orderByClause = @"
                                    order by
                                        consult_log.upddate xxx,
                                        hainsuser.username xxx,
                                        consult_log.rsvno xxx
                                ";
                                break;
                        }

                        // ソート順の設定
                        orderByClause = orderByClause.Replace("xxx", (orderByMode == 1) ? "desc" : "asc");

                        sql += orderByClause;

                        sql += @"
                                        )
                                ) loglist
                            where
                                loglist.rsvno = consult_log.rsvno
                                and loglist.seq = consult_log.seq
                        ";

                        if ((startPos > 0) && (getCount > 0))
                        {
                            sql += @"
                                and loglist.rowseq between :startpos and :endpos
                            ";
                        }

                        sql += @"
                            order by
                                loglist.rowseq
                        ";

                        break;
                }

                data = connection.Query(sql, param).ToList();

                // 件数の取得処理
                if (phase == 0)
                {
                    recCount = Convert.ToInt32(data[0].CNT);
                    if (recCount == 0)
                    {
                        break;
                    }

                    continue;
                }

                // 実データ取得時は開始位置から取得件数分を取得
                data = data.Skip(startPos - 1).Take(getCount).ToList();
            }

            // 取得件数分のデータと全検索件数の組を返す
            return new PartialDataSet(recCount, data);
        }

        /// <summary>
        /// 指定予約番号の出力情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// 出力情報
        /// cardprintdate 確認はがき出力日時
        /// formprintdate 一式書式出力日時
        /// </returns>
        public dynamic SelectConsultPrintStatus(int rsvNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 検索条件を満たす受診情報テーブルのレコードを取得
            var sql = @"
                select
                    cardprintdate
                    , formprintdate
                from
                    consult
                where
                    rsvno = :rsvno
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// はがき出力日時、一式書式出力日時を更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="cardPrintDate">はがき出力日時</param>
        /// <param name="formPrintDate">一式書式出力日時</param>
        public void UpdateConsultPrintStatus(int rsvNo, DateTime? cardPrintDate, DateTime? formPrintDate)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("cardprintdate", cardPrintDate);
            param.Add("formprintdate", formPrintDate);

            // 出力日レコードの更新
            var sql = @"
                update consult
                set
                    cardprintdate = :cardprintdate
                    , formprintdate = :formprintdate
                where
                    rsvno = :rsvno
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 指定予約番号の受診時追加グループ情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// 受診時追加グループ情報
        /// grpcd グループコード
        /// grpname グループ名
        /// editflg 修正区分
        /// </returns>
        public IList<dynamic> SelectConsult_G(int rsvNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 指定予約番号の受診時追加グループ情報を取得する
            var sql = @"
                select
                    consult_g.grpcd
                    , consult_g.editflg
                    , grp_p.grpname
                from
                    grp_p
                    , consult_g
                where
                    consult_g.rsvno = :rsvno
                    and consult_g.grpcd = grp_p.grpcd
                order by
                    consult_g.rsvno
                    , consult_g.grpcd
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 検索条件を満たす受診者の個人情報を取得する
        /// </summary>
        /// <param name="rsvNo"></param>
        /// <param name="message">メッセージ</param>
        /// <returns>受診情報
        /// perid      個人ID
        /// csldate    受診日
        /// csname     コース名
        /// lastname   姓
        /// firstname  名
        /// lastkname  カナ姓
        /// firstkname カナ名
        /// birth      生年月日
        /// age        年齢
        /// gender     性別
        /// gendername 性別名称
        /// orgname    団体名称
        /// </returns>
        public dynamic SelectOcrConsult(string rsvNo, out string message)
        {
            // 予約番号チェック
            message = WebHains.CheckNumeric("予約番号", rsvNo, (int)LengthConstants.LENGTH_CONSULT_RSVNO, Check.Necessary);
            if (!string.IsNullOrEmpty(message))
            {
                return null;
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", Int32.Parse(rsvNo));
            param.Add("cancelflg", ConsultCancel.Used);

            // 検索条件を満たす受診者情報のレコードを取得
            var sql = @"
                select
                    cn.perid
                    , cn.csldate
                    , cp.csname
                    , p.lastname
                    , p.firstname
                    , p.lastkname
                    , p.firstkname
                    , p.birth
                    , cn.age
                    , p.gender
                    , decode(p.gender, '1', '男性', '2', '女性') gendername
                    , og.orgname
                from
                    consult cn
                    , person p
                    , course_p cp
                    , org og
                where
                    cn.rsvno = :rsvno
                    and cn.cancelflg = :cancelflg
                    and cn.perid = p.perid
                    and cn.cscd = cp.cscd
                    and cn.orgcd1 = og.orgcd1
                    and cn.orgcd2 = og.orgcd2
            ";

            dynamic data = connection.Query(sql, param).FirstOrDefault();
            if (data == null)
            {
                message = "受診者情報に存在しない受診番号です。";
                return null;
            }

            return data;
        }

        /// <summary>
        /// オーダ発行済みの受診情報一覧を取得する
        /// </summary>
        /// <param name="cslDate">受診日（検査日）</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="onlyInsItem">true:検体検査情報のみ取得、false:全て取得</param>
        /// <returns>
        /// 受診情報リスト
        /// dayid 当日ID
        /// rsvno 予約番号
        /// csldate 受診日（予約上の受診日）
        /// perid 個人ID
        /// cscd コースコード
        /// csname コース名
        /// doctytle 文書種別名
        /// orderno オーダ番号
        /// doccd 文書コード
        /// orgcd1 団体コード1
        /// orgcd2 団体コード2
        /// orgname 団体名
        /// lastname 姓
        /// firstname 名
        /// lastkname カナ姓
        /// firstkname カナ名
        /// gender 性別
        /// age 受診時年齢
        /// birth 生年月日
        /// </returns>
        public IList<dynamic> SelectOrderedConsult(DateTime cslDate, string csCd = null, bool onlyInsItem = false)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);

            // 指定日のオーダ発行済み受診情報一覧を取得
            var sql = @"
                select distinct
                    receipt.dayid
                    , receipt.rsvno
                    , consult.csldate
                    , consult.perid
                    , consult.cscd
                    , course_p.csname
                    , free.freename doctitle
                    , ordereddoc.orderno
                    , ordereddoc.doccd
                    , consult.orgcd1
                    , consult.orgcd2
                    , org.orgname
                    , person.lastname
                    , person.firstname
                    , person.lastkname
                    , person.firstkname
                    , person.gender
                    , consult.age
                    , person.birth
                from
                    org org
                    , course_p course_p
                    , person person
                    , consult consult
                    , free free
                    , ordereddoc ordereddoc
                    , receipt receipt
                where
                    receipt.csldate = :csldate
                    and ordereddoc.rsvno = receipt.rsvno
                    and consult.rsvno = receipt.rsvno
            ";

            // コースコードの指定がされている場合は、条件追加
            if (!string.IsNullOrEmpty(csCd))
            {
                sql += @"
                    and consult.cscd = :cscd
                ";

                param.Add("cscd", csCd);
            }

            // 検体検査のみの指定がされている場合は、条件追加
            if (onlyInsItem)
            {
                sql += @"
                    and free.freefield1 = '1'
                ";
            }

            sql += @"
                    and free.freecd = ordereddoc.doccd
                    and person.perid = consult.perid
                    and course_p.cscd = consult.cscd
                    and org.orgcd1 = consult.orgcd1
                    and org.orgcd2 = consult.orgcd2
                order by
                    receipt.dayid
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定予約番号の受診時追加検査項目情報を取得する
        /// </summary>
        /// <param name="rsvNo"></param>
        /// <returns>
        /// 受診時追加検査項目のリスト
        /// itemcd 検査項目コード
        /// editflg 修正区分
        /// requestname 依頼項目名
        /// </returns>
        public IList<dynamic> SelectConsult_I(int rsvNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 指定予約番号の受診時追加検査項目情報を取得する
            var sql = @"
                select
                    consult_i.itemcd
                    , consult_i.editflg
                    , item_p.requestname
                from
                    item_p
                    , consult_i
                where
                    consult_i.rsvno = :rsvno
                    and consult_i.itemcd = item_p.itemcd
                order by
                    consult_i.rsvno
                    , consult_i.itemcd
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定予約番号の受診オプション管理情報を取得する
        /// </summary>
        /// <param name="rsvNo"></param>
        /// <param name="hideKbn">指定画面の非表示項目を除く(1:予約枠画面、2:予約画面、3:受付画面、4:問診画面)</param>
        /// <returns>
        /// 受診オプション管理情報のリスト
        /// optcd オプションコード
        /// optbranchno オプション枝番
        /// optname オプション名
        /// setclasscd セット分類コード
        /// optsname オプション略称
        /// setcolor セットカラー
        /// </returns>
        public IList<dynamic> SelectConsult_O(int rsvNo, int hideKbn = 0)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 指定予約番号の受診オプション管理情報を取得する
            var sql = @"
                select
                    consult_o.optcd
                    , consult_o.optbranchno
                    , ctrpt_opt.optname
                    , ctrpt_opt.setclasscd
                    , ctrpt_opt.optsname
                    , ctrpt_opt.setcolor
                from
                    ctrpt_opt
                    , consult_o
                    , ctrpt_optgrp
                where
                    consult_o.rsvno = :rsvno
                    and consult_o.ctrptcd = ctrpt_opt.ctrptcd
                    and consult_o.optcd = ctrpt_opt.optcd
                    and consult_o.optbranchno = ctrpt_opt.optbranchno
                    and ctrpt_opt.ctrptcd = ctrpt_optgrp.ctrptcd
                    and ctrpt_opt.optcd = ctrpt_optgrp.optcd
            ";

            // 画面非表示を除く？
            if (hideKbn == 1)
            {
                // 予約枠画面
                sql += @"
                    and ctrpt_optgrp.hidersvfra is null
                ";
            }
            else if (hideKbn == 2)
            {
                // 予約画面
                sql += @"
                    and ctrpt_optgrp.hidersv is null
                ";
            }
            else if (hideKbn == 3)
            {
                // 受付画面
                sql += @"
                    and ctrpt_optgrp.hiderpt is null
                ";
            }
            else if (hideKbn == 4)
            {
                // 問診画面
                sql += @"
                    and ctrpt_optgrp.hidequestion is null
                ";
            }

            sql += @"
                order by
                    consult_o.rsvno
                    , consult_o.optcd
                    , consult_o.optbranchno
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定予約番号の受診オプション管理情報をもとに受診サブコースを取得する
        /// </summary>
        /// <param name="rsvNo"></param>
        /// <returns>サブコース名のリスト</returns>
        public IList<string> SelectConsult_O_SubCourse(int rsvNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // サブコース用取得用のSQLステートメント編集
            string sql = EditSelectSubCourseStatement();

            return connection.Query(sql, param).Select(rec => (string)rec.CSNAME).ToList();
        }

        /// <summary>
        /// 受診情報テーブルから受診付属情報を読み込む
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// 受診付属情報
        /// rsvstatus 予約状況
        /// prtonsave 保存時印刷
        /// cardaddrdiv 確認はがき宛先
        /// cardouteng 確認はがき英文出力
        /// formaddrdiv 一式書式宛先
        /// formouteng 一式書式英文出力
        /// reportaddrdiv 成績書宛先
        /// reportoureng 成績書英文出力
        /// volunteer ボランティア
        /// volunteername ボランティア名
        /// collectticket 利用券回収
        /// issuecslticket 診察券発行
        /// billprint 請求書出力
        /// isrsign 保険証記号
        /// isrno 保険証番号
        /// isrmanno 保険者番号
        /// empno 社員番号
        /// introductor 紹介者
        /// cancelflg キャンセルフラグ
        /// lastcsldate 前回受診日
        /// sendmaildiv 予約確認メール送信先
        /// sendmaildate 予約確認メール送信日時
        /// username 予約確認メール送信者名
        /// </returns>
        public dynamic SelectConsultDetail(int rsvNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 検索条件を満たす受診情報テーブルのレコードを取得
            var sql = @"
                select
                    consult.rsvstatus
                    , consult.prtonsave
                    , consult.cardaddrdiv
                    , consult.cardouteng
                    , consult.formaddrdiv
                    , consult.formouteng
                    , consult.reportaddrdiv
                    , consult.reportoureng
                    , consult.volunteer
                    , consult.volunteername
                    , consult.collectticket
                    , consult.issuecslticket
                    , consult.billprint
                    , consult.isrsign
                    , consult.isrno
                    , consult.isrmanno
                    , consult.empno
                    , consult.introductor
                    , consult.cancelflg
                    , consult.lastcsldate
                    , consult.sendmaildiv
                    , consult.sendmaildate
                    , hainsuser.username
                from
                    hainsuser
                    , consult
                where
                    consult.rsvno = :rsvno
                    and consult.sendmailuser = hainsuser.userid(+)
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// バーコードのキーをもとに受診情報を取得する
        /// </summary>
        /// <param name="cslDate">受付日（バーコード）</param>
        /// <param name="perId">個人ＩＤ（バーコード）</param>
        /// <param name="csCd">コースコード（バーコード）</param>
        /// <returns>
        /// 受診情報
        /// dayid 当日ID
        /// rsvno 予約番号
        /// csldate (受診情報の)受診日
        /// perid 個人ID
        /// cscd コースコード
        /// age 受診時年齢
        /// doctorcd 判定医師コード
        /// lastname 姓
        /// firstname名
        /// lastkname カナ姓
        /// firstknameカナ名
        /// birth 生年月日
        /// gender 性別
        /// csname コース名
        /// doctorname 判定医師名
        /// </returns>
        public dynamic SelectConsultForBarcode(DateTime cslDate, string perId, string csCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            param.Add("perid", perId);
            param.Add("cscd", csCd);

            // 検索条件を満たす受診情報テーブルのレコードを取得
            var sql = @"
                select
                    receipt.dayid
                    , receipt.rsvno
                    , consult.csldate
                    , consult.perid
                    , consult.cscd
                    , to_char(consult.age, '999.99') age
                    , consult.doctorcd
                    , person.lastname
                    , person.firstname
                    , person.lastkname
                    , person.firstkname
                    , person.birth
                    , person.gender
                    , course_p.csname
                    , hainsuser.username doctorname
            ";

            // FROM句の設定
            sql += @"
                from
                    hainsuser
                    , course_p
                    , person
                    , consult
                    , receipt
            ";

            // バーコードのキー情報を元に受診情報を取得し、その受診情報をもとに各種情報を結合
            sql += @"
                where
                    consult.csldate = :csldate
                    and consult.perid = :perid
                    and consult.cscd = :cscd
                    and receipt.rsvno = consult.rsvno
                    and consult.perid = person.perid
                    and consult.cscd = course_p.cscd
                    and consult.doctorcd = hainsuser.userid(+)
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 受付情報をもとに受診情報を取得する
        /// </summary>
        /// <param name="cslDate">(受付情報の)受診日</param>
        /// <param name="cntlNo">管理番号</param>
        /// <param name="dayId">当日ID</param>
        /// <returns>
        /// 受診情報
        /// rsvno 予約番号
        /// csldate (受診情報の)受診日
        /// perid 個人ID
        /// cscd コースコード
        /// age 受診時年齢
        /// lastname 姓
        /// firstname 名
        /// lastkname カナ姓
        /// firstkname カナ名
        /// birth 生年月日
        /// gender 性別
        /// csname コース名
        /// </returns>
        public dynamic SelectConsultFromReceipt(DateTime cslDate, int cntlNo, String dayId)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate.ToString("d"));
            param.Add("cntlno", cntlNo);
            param.Add("dayid", dayId);

            // 検索条件を満たす受診情報テーブルのレコードを取得
            var sql = @"
                select
                    receipt.rsvno
                    , consult.csldate
                    , consult.perid
                    , consult.cscd
                    , to_char(consult.age, '999.99') age
                    , person.lastname
                    , person.firstname
                    , person.lastkname
                    , person.firstkname
                    , person.birth
                    , person.gender
                    , course_p.csname
            ";

            // FROM句の設定
            sql += @"
                from
                    course_p
                    , person
                    , consult
                    , receipt
            ";

            // 受付情報を元に受診情報を取得し、その受診情報をもとに各種情報を結合
            sql += @"
                where
                    receipt.csldate = :csldate
                    and receipt.cntlno = :cntlno
                    and receipt.dayid = :dayid
                    and receipt.rsvno = consult.rsvno
                    and consult.perid = person.perid
                    and consult.cscd = course_p.cscd
            ";

            dynamic data =connection.Query(sql, param).FirstOrDefault();

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
        /// 指定された個人IDの受診歴一覧を取得する
        /// </summary>
        /// <param name="perId">個人ID</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="receptOnly">true指定時は受付済み受診情報のみを取得対象とする</param>
        /// <param name="firstCourseOnly">true指定時は１次健診のみを取得対象とする</param>
        /// <param name="getRowCount">取得件数(未指定時は全件)</param>
        /// <returns>
        /// 総レコード数と受診歴リストとの組
        /// 受診歴リスト
        /// rsvno 予約番号
        /// csldate 受診日
        /// cscd コースコード
        /// age 受診時年齢
        /// csname コース名
        /// cssname コース略称
        /// webcolor webカラー
        /// secondflg 2次健診フラグ
        /// dayid 当日ID
        /// orgsname 団体略称
        /// csldivname 受診区分名
        /// </returns>
        public PartialDataSet SelectConsultHistory(
            string perId,
            DateTime? cslDate = null,
            bool receptOnly = false,
            bool firstCourseOnly = false,
            int getRowCount = 0
        )
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("perid", perId);
            param.Add("csldate", cslDate ?? new DateTime(2200, 12, 31));
            param.Add("checkdayid", receptOnly ? 0 : -1);
            param.Add("secondflg", firstCourseOnly ? "0" : null);

            // 指定された個人ＩＤの受診歴一覧を取得する
            var sql = @"
                select
                    history.rsvno
                    , history.csldate
                    , history.cscd
                    , history.age
                    , history.csname
                    , history.cssname
                    , history.webcolor
                    , history.secondflg
                    , history.dayid
                    , org.orgsname
                    , csldiv.csldivname
                from
                    csldiv
                    , org
                    , (
                        select
                            consult.perid
                            , consult.rsvno
                            , consult.csldate
                            , consult.cscd
                            , consult.age
                            , consult.orgcd1
                            , consult.orgcd2
                            , consult.csldivcd
                            , course_p.csname
                            , course_p.cssname
                            , course_p.webcolor
                            , course_p.secondflg
                            , receipt.dayid
                            , nvl(receipt.dayid, 0) checkdayid
                        from
                            receipt
                            , course_p
                            , consult
                        where
                            consult.perid = :perid
                            and consult.cancelflg = 0
                            and consult.cscd = course_p.cscd
                            and consult.rsvno = receipt.rsvno(+)
                            and consult.csldate = receipt.csldate(+)
                    ) history
            ";

            // 条件節
            sql += @"
                where
                    history.csldate <= :csldate
                    and history.checkdayid > :checkdayid
                    and history.secondflg = nvl(:secondflg, history.secondflg)
                    and history.orgcd1 = org.orgcd1
                    and history.orgcd2 = org.orgcd2
                    and history.csldivcd = csldiv.csldivcd
            ";

            // 受診日の降順、当日ＩＤの降順、コースコードの昇順に取得
            sql += @"
                order by
                    history.perid
                    , history.csldate desc
                    , history.dayid desc nulls last
                    , history.cscd
            ";

            IList<dynamic> data = connection.Query(sql, param).ToList();

            // 取得件数分のデータと全検索件数の組を返す
            return new PartialDataSet(data.Count, getRowCount > 0 ? data.Take(getRowCount).ToList() : data.ToList());
        }

        /// <summary>
        /// 検索条件を満たす受診者の一覧を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="cntlNo">管理番号</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="startDayId">開始当日ID</param>
        /// <param name="endDayId">終了当日ID</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="startPos">開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <param name="sortKey">ソート順</param>
        /// <param name="needUnReceiptConsult">未受付者取得フラグ</param>
        /// <param name="badJudgemnetOnly">異常判定所持者取得フラグ</param>
        /// <param name="notCompletedJudgemnetOnly">判定未完了者取得フラグ</param>
        /// <param name="entryStatus">結果入力状態("1":未検査未完了者のみ、"2":検査完了者のみ)</param>
        /// <param name="entriedJudgement">判定入力状態</param>
        /// <param name="rsvGrpCd">予約群コード</param>
        /// <param name="comeOnly">true時は来院者のみ取得(このときneedUnReceiptConsult値は無効)</param>
        /// <returns>
        /// 総レコード数と受診者リストとの組
        /// 受診者リスト
        /// rsvno 予約番号
        /// dayid 当日ID
        /// perid 個人ID
        /// csldate 受診情報の受診日
        /// age 年齢
        /// webcolor webカラー
        /// csname コース名
        /// lastname 姓
        /// firstname 名
        /// lastkname カナ姓
        /// firstkname カナ名
        /// gender 性別
        /// birth 生年月日
        /// orgsname 団体略称
        /// filmno フィルム番号
        /// filmdate 撮影日
        /// spare1 予備1
        /// cssname コース略称
        /// entriedjudgement 判定入力状態
        /// volunteer ボランティア
        /// volunteername ボランティア名
        /// rsvgrpname 予約群名称
        /// </returns>
        public PartialDataSet SelectConsultList(
            DateTime cslDate,
            int cntlNo,
            string csCd,
            int? startDayId = null,
            int? endDayId = null,
            string grpCd = null,
            int startPos = 0,
            int getCount = 0,
            string sortKey = SORT_DAYID,
            bool needUnReceiptConsult = false,
            bool badJudgemnetOnly = false,
            bool notCompletedJudgemnetOnly = false,
            string entryStatus = null,
            bool entriedJudgement = false,
            int? rsvGrpCd = null,
            bool comeOnly = false
        )
        {
            const string ENTRYSTATUS_NOT_COMPLETED = "1";
            const string ENTRYSTATUS_COMPLETED = "2";

            // 異常判定の重み値を取得
            int strBadWeight = WebHains.SelectJudBadWeight();

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Convert.ToDateTime(cslDate));
            param.Add("cntlno", cntlNo);
            param.Add("cscd", csCd);

            // 開始当日ＩＤが指定されている場合
            if (startDayId != null)
            {
                param.Add("strdayid", startDayId);
            }

            // 終了当日ＩＤが指定されている場合
            if (endDayId != null)
            {
                param.Add("enddayid", endDayId);
            }

            // グループコードが指定されている場合
            if (!string.IsNullOrEmpty(grpCd))
            {
                param.Add("grpcd", grpCd.Trim());
            }

            param.Add("freecd", (SORT_DAYID.Equals(sortKey) || SORT_PERID.Equals(sortKey)) ? "" : sortKey);

            // 予約群指定時
            if (rsvGrpCd != null)
            {
                param.Add("rsvgrpcd", rsvGrpCd);
            }

            // 指定条件を満たす受診情報を取得する
            var sql = @"
                select
                    basedconsult.rsvno
                    , basedconsult.dayid
                    , basedconsult.perid
                    , basedconsult.csldate
                    , trim(to_char(basedconsult.age, '999.99')) age
                    , course_p.webcolor
                    , course_p.csname
                    , person.lastname
                    , person.firstname
                    , person.lastkname
                    , person.firstkname
                    , person.gender
                    , person.birth
                    , org.orgsname
                    , filmmng.filmno
                    , filmmng.filmdate
                    , person.spare1
                    , course_p.cssname
            ";

            if (entriedJudgement)
            {
                sql += @"
                    , checkresultpackage.checkexistsnojudgement(basedconsult.rsvno) entriedjudgement
                ";
            }
            else
            {
                sql += @"
                    , '' entriedjudgement
                ";
            }

            sql += @"
                    , basedconsult.volunteer
                    , basedconsult.volunteername
                    , rsvgrp.rsvgrpname
            ";


            // コース・個人・団体は最後に結合するため、ここで指定
            sql += @"
                from
                    rsvgrp
                    , filmmng
                    , org
                    , person
                    , course_p
            ";

            // ここからは指定された受診日で受付されている受診情報取得処理
            sql += @"
                    , (
                        select
                            receipt.rsvno
                            , receipt.dayid
                            , consult.perid
                            , consult.cscd
                            , consult.csldate
                            , consult.orgcd1
                            , consult.orgcd2
                            , consult.age
                            , consult.volunteer
                            , consult.volunteername
            ";

            // フィルム番号管理テーブルを結合するための撮影機器区分を取得
            sql += @"
                            , (
                                select
                                    nvl(freefield6, ' ')
                                from
                                    free
                                where
                                    freecd = :freecd
                            ) filmmngdiv
            ";

            sql += @"
                            , consult.rsvgrpcd
            ";

            // FROM句(フィルム番号は検査結果情報より取得する)
            sql += @"
                        from
                            consult
                            , receipt
            ";

            // まず指定条件を満たす受付情報を取得
            sql += @"
                        where
                            receipt.csldate = :csldate
                            and receipt.cntlno = :cntlno
            ";

            // 開始当日ＩＤが指定されている場合は条件節に追加
            if (startDayId != null)
            {
                sql += @"
                        and receipt.dayid >= :strdayid
                ";
            }

            // 終了当日ＩＤが指定されている場合は条件節に追加
            if (endDayId != null)
            {
                sql += @"
                        and receipt.dayid <= :enddayid
                ";
            }

            // 来院者のみ取得する場合は条件節に追加
            if (comeOnly)
            {
                sql += @"
                        and receipt.comedate is not null
                ";
            }

            // 指定条件を満たす受付情報に受診情報を結合
            sql += @"
                        and receipt.rsvno = consult.rsvno
            ";

            // コースコード指定時は条件節に追加
            if (!string.IsNullOrEmpty(csCd))
            {
                sql += @"
                        and consult.cscd = :cscd
                ";
            }

            // グループコードが指定されている場合
            if (!string.IsNullOrEmpty(grpCd))
            {
                // グループ内検査項目を受診項目として所有する受診情報のみを対象
                sql += @"
                        and (
                            exists (
                                select
                                    rsl.rsvno
                                from
                                    item_p
                                    , grp_i
                                    , rsl
                                where
                                    rsl.rsvno = receipt.rsvno
                                    and grp_i.grpcd = :grpcd
                                    and rsl.itemcd = grp_i.itemcd
                                    and rsl.suffix = grp_i.suffix
                                    and grp_i.itemcd = item_p.itemcd
                                    and item_p.rslque = " + Convert.ToInt64(RslQue.R) + @"

                            )
                ";
                
                // グループ内検査項目に問診項目が存在すれば無条件対象
                sql += @"
                            or exists (
                                select
                                    grp_i.grpcd
                                from
                                    item_p
                                    , grp_i
                                where
                                    grp_i.grpcd = :grpcd
                                    and grp_i.itemcd = item_p.itemcd
                                    and item_p.rslque = " + Convert.ToInt64(RslQue.Q) + @"
                            )
                        )
                ";
            }

            // 異常判定を持つ受診者のみを取得する場合
            if (badJudgemnetOnly)
            {
                // 現在登録されている判定情報の判定結果が異常とみなされるならば対象とする
                sql += @"
                        and exists (
                            select
                                judrsl.rsvno
                            from
                                jud
                                , judrsl
                            where
                                judrsl.rsvno = receipt.rsvno
                                and judrsl.judcd = jud.judcd
                                and jud.weight >= " + strBadWeight + @"
                        )
                ";
            }

            // 判定未完了者のみを取得する場合
            if (notCompletedJudgemnetOnly)
            {
                sql += @"
                        and checkresultpackage.checkexistsnojudgement(receipt.rsvno) > 0
                ";
            }

            // 予約群指定時
            if (rsvGrpCd != null)
            {
                sql += @"
                        and consult.rsvgrpcd = :rsvgrpcd
                ";
            }

            // 検査完了・未完了のチェック
            while (true)
            {
                // 引数未指定時は何もしない
                if (string.IsNullOrEmpty(entryStatus))
                {
                    break;
                }

                // 検査完了・未完了をチェックしない場合は何もしない
                if (!entryStatus.Equals(ENTRYSTATUS_NOT_COMPLETED) && !entryStatus.Equals(ENTRYSTATUS_COMPLETED))
                {
                    break;
                }

                sql += @"
                        and checkresultpackage.checkexistsnoresult(receipt.rsvno) = " + (entryStatus.Equals(ENTRYSTATUS_NOT_COMPLETED), "1", "0") + @"
                ";

                break;
            }

            // 以下は未受付の受診情報を抽出する処理
            while (true)
            {
                // 来院者のみ取得する場合は何もしない
                if (comeOnly)
                {
                    break;
                }

                // 未受付の受診情報を含めない場合は何もしない
                if (!needUnReceiptConsult)
                {
                    break;
                }

                // 当日ＩＤが指定されている場合は何もしない
                if ((startDayId != null) || (endDayId != null))
                {
                    break;
                }

                // 未受付であれば当然異常判定(というか判定自体)を所有しないため、抽出非対象とする
                if (badJudgemnetOnly)
                {
                    break;
                }

                // 未受付であれば判定自体を所有しないため、判定未完云々で抽出制御する必要はない
                if (notCompletedJudgemnetOnly)
                {
                    break;
                }

                // 検査完了・未完了は受付後の受診情報に対して行うチェックのため、本条件指定時は未受付の受診情報はチェックしない
                if (!string.IsNullOrEmpty(entryStatus))
                {
                    if (entryStatus.Equals(ENTRYSTATUS_NOT_COMPLETED) || entryStatus.Equals(ENTRYSTATUS_COMPLETED))
                    {
                        break;
                    }
                }

                // これより抽出する受診情報は先に抽出した受付情報とは排反(双方に含まれるデータが互いに存在しない)ため、UNION ALL結合する
                sql += @"
                    union all
                ";

                // 指定された受診日の受診情報を取得(当日ＩＤ、フィルム番号については当然存在しないのでNULLを返させる)
                sql += @"
                    select
                        consult.rsvno
                        , receipt.dayid
                        , consult.perid
                        , consult.cscd
                        , consult.csldate
                        , consult.orgcd1
                        , consult.orgcd2
                        , consult.age
                        , consult.volunteer
                        , consult.volunteername
                        , ' ' filmmngdiv
                        , consult.rsvgrpcd
                ";

                // FROM句(フィルム番号は検査結果情報より取得する)
                sql += @"
                    from
                        receipt
                        , consult
                ";

                // まず指定された受診日の非キャンセル受診情報を対象とする
                sql += @"
                    where
                        consult.csldate = :csldate
                        and consult.cancelflg = " + (int)ConsultCancel.Used+ @"
                ";

                // 未受付受診情報を抽出するため、受付情報の存在しないレコードを対象とさせる
                sql += @"
                        and consult.csldate = receipt.csldate(+)
                        and consult.rsvno = receipt.rsvno(+)
                        and receipt.dayid is null
                ";

                // コースコード指定時は条件節に追加
                if (!string.IsNullOrEmpty(csCd))
                {
                    sql += @"
                        and consult.cscd = :cscd
                    ";
                }

                // 予約群指定時
                if (rsvGrpCd != null)
                {
                    sql += @"
                        and consult.rsvgrpcd = :rsvgrpcd
                    ";
                }

                break;
            }

            // 冒頭のFROM句の括弧閉じ
            sql += @"
                    ) basedconsult
            ";

            // コース・個人・団体の各情報を結合
            sql += @"
                where
                    basedconsult.cscd = course_p.cscd
                    and basedconsult.perid = person.perid
                    and basedconsult.orgcd1 = org.orgcd1
                    and basedconsult.orgcd2 = org.orgcd2
            ";

            sql += @"
                    and basedconsult.rsvno = filmmng.rsvno(+)
                    and basedconsult.filmmngdiv = filmmng.filmmngdiv(+)
            ";

            sql += @"
                    and basedconsult.rsvgrpcd = rsvgrp.rsvgrpcd
            ";

            if (SORT_PERID.Equals(sortKey))
            {
                // ソート順の指定(個人ＩＤ順)
                sql += @"
                order by
                    basedconsult.perid
                    , basedconsult.cscd
                ";
            }
            else if (SORT_PERID.Equals(sortKey))
            {
                // ソート順の指定(当日ＩＤ順)
                sql += @"
                order by
                    basedconsult.dayid nulls last
                    , basedconsult.cscd
                    , basedconsult.orgcd1
                    , basedconsult.orgcd2
                    , basedconsult.perid
                ";
            }
            else
            {
                sql += @"
                order by
                    filmmng.filmno nulls last
                    , basedconsult.dayid nulls last
                    , basedconsult.cscd
                    , basedconsult.orgcd1
                    , basedconsult.orgcd2
                    , basedconsult.perid
                ";
            }

            IList<dynamic> data = connection.Query(sql, param).ToList();

            if (data.Count>0)
            {
                for (int i = 0; i < data.Count; i++)
                {
                    DateTime birth = DateTime.Parse(Convert.ToString(data[i].BIRTH));
                    // 和暦年を取得
                    data[i].birtherayear = (object)WebHains.JapaneseCalendar.GetYear(birth);
                    // 和暦元号(英字表記)を取得
                    data[i].birthyearshorteraname = WebHains.GetShortEraName(birth);
                }
            }
            // 開始位置から取得件数分のデータと全検索件数の組を返す
            return new PartialDataSet(data.Count, startPos > 0 ? data.Skip(startPos - 1).Take(getCount).ToList() : data.ToList());
        }

        /// <summary>
        /// 検索条件を満たす受診者の一覧を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="cntlNo">管理番号</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="startDayId">開始当日ID</param>
        /// <param name="endDayId">終了当日ID</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="startPos">開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <param name="sortKey">ソート順</param>
        /// <param name="needUnReceiptConsult">未受付者取得フラグ</param>
        /// <param name="badJudgemnetOnly">異常判定所持者取得フラグ</param>
        /// <param name="notCompletedJudgemnetOnly">判定未完了者取得フラグ</param>
        /// <param name="entryStatus">結果入力状態("1":未検査未完了者のみ、"2":検査完了者のみ)</param>
        /// <param name="entriedJudgement">判定入力状態</param>
        /// <param name="entriedJudgementM">判定入力状態(手動分)</param>
        /// <param name="rsvGrpCd">予約群コード</param>
        /// <param name="comeOnly">true時は来院者のみ取得(このときneedUnReceiptConsult値は無効)</param>
        /// <returns>
        /// 総レコード数と受診者リストとの組
        /// 受診者リスト
        /// rsvno 予約番号
        /// dayid 当日ID
        /// perid 個人ID
        /// csldate 受診情報の受診日
        /// age 年齢
        /// webcolor webカラー
        /// csname コース名
        /// lastname 姓
        /// firstname 名
        /// lastkname カナ姓
        /// firstkname カナ名
        /// gender 性別
        /// birth 生年月日
        /// orgsname 団体略称
        /// filmno フィルム番号
        /// filmdate 撮影日
        /// spare1 予備1
        /// cssname コース略称
        /// entriedjudgement 判定入力状態
        /// entriedjudgementm 判定入力状態(手動分)
        /// volunteer ボランティア
        /// volunteername ボランティア名
        /// rsvgrpname 予約群名称
        /// mensetsustate
        /// </returns>
        public PartialDataSet SelectConsultListProgress(
            DateTime cslDate,
            int cntlNo,
            string csCd = null,
            int? startDayId = null,
            int? endDayId = null,
            string grpCd = null,
            int startPos = 0,
            int getCount = 0,
            string sortKey = SORT_DAYID,
            bool needUnReceiptConsult = false,
            bool badJudgemnetOnly = false,
            bool notCompletedJudgemnetOnly = false,
            string entryStatus = null,
            bool entriedJudgement = false,
            bool entriedJudgementM = false,
            int? rsvGrpCd = null,
            bool comeOnly = false
        )
        {
            const string ENTRYSTATUS_NOT_COMPLETED = "1";
            const string ENTRYSTATUS_COMPLETED = "2";

            // 異常判定の重み値を取得
            int strBadWeight = WebHains.SelectJudBadWeight();

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            param.Add("cntlno", cntlNo);
            param.Add("cscd", csCd);

            // 開始当日ＩＤが指定されている場合
            if (startDayId != null)
            {
                param.Add("strdayid", startDayId);
            }

            // 終了当日ＩＤが指定されている場合
            if (endDayId != null)
            {
                param.Add("enddayid", endDayId);
            }

            // グループコードが指定されている場合
            if (!string.IsNullOrEmpty(grpCd))
            {
                param.Add("grpcd", grpCd.Trim());
            }

            param.Add("freecd", (sortKey.Equals(SORT_DAYID) || sortKey.Equals(SORT_PERID)) ? "" : sortKey);

            // 予約群指定時
            if (rsvGrpCd != null)
            {
                param.Add("rsvgrpcd", rsvGrpCd);
            }

            // 指定条件を満たす受診情報を取得する
            var sql = @"
                select
                    basedconsult.rsvno
                    , basedconsult.dayid
                    , basedconsult.perid
                    , basedconsult.csldate
                    , trim(to_char(basedconsult.age, '999.99')) age
                    , course_p.webcolor
                    , course_p.csname
                    , person.lastname
                    , person.firstname
                    , person.lastkname
                    , person.firstkname
                    , person.gender
                    , person.birth
                    , org.orgsname
                    , filmmng.filmno
                    , filmmng.filmdate
                    , person.spare1
                    , course_p.cssname
            ";

            if (entriedJudgement)
            {
                sql += @"
                    , checkresultpackage.checkexistsnojudgementauto(basedconsult.rsvno) entriedjudgementa
                ";
            }
            else
            {
                sql += @"
                    , ' ' entriedjudgementa
                ";
            }

            if (entriedJudgementM)
            {
                sql += @"
                    , checkresultpackage.checkexistsnojudgementmanual(basedconsult.rsvno) entriedjudgementm
                ";
            }
            else
            {
                sql += @"
                    , ' ' entriedjudgementm
                ";
            }

            sql += @"
                    , basedconsult.volunteer
                    , basedconsult.volunteername
                    , rsvgrp.rsvgrpname
                    , usp_mensetsu_state(basedconsult.rsvno) mensetsustate
            ";

            // コース・個人・団体は最後に結合するため、ここで指定
            sql += @"
                from
                    rsvgrp
                    , filmmng
                    , org
                    , person
                    , course_p
            ";

            // ここからは指定された受診日で受付されている受診情報取得処理
            sql += @"
                    , (
                        select
                            receipt.rsvno
                            , receipt.dayid
                            , consult.perid
                            , consult.cscd
                            , consult.csldate
                            , consult.orgcd1
                            , consult.orgcd2
                            , consult.age
                            , consult.volunteer
                            , consult.volunteername
            ";

            // フィルム番号管理テーブルを結合するための撮影機器区分を取得
            sql += @"
                            , (
                                select
                                    nvl(freefield6, ' ')
                                from
                                    free
                                where
                                    freecd = :freecd
                              ) filmmngdiv
            ";

            sql += @"
                            , consult.rsvgrpcd
            ";

            // FROM句(フィルム番号は検査結果情報より取得する)
            sql += @"
                        from
                            consult
                            , receipt
            ";

            // まず指定条件を満たす受付情報を取得
            sql += @"
                        where
                            receipt.csldate = :csldate
                            and receipt.cntlno = :cntlno
            ";

            // 開始当日ＩＤが指定されている場合は条件節に追加
            if (startDayId != null)
            {
                sql += @"
                        and receipt.dayid >= :strdayid
                ";
            }

            // 終了当日ＩＤが指定されている場合は条件節に追加
            if (endDayId != null)
            {
                sql += @"
                        and receipt.dayid <= :enddayid
                ";
            }

            // 来院者のみ取得する場合は条件節に追加
            if (comeOnly)
            {
                sql += @"
                        and receipt.comedate is not null
                ";
            }

            // 指定条件を満たす受付情報に受診情報を結合
            sql += @"
                        and receipt.rsvno = consult.rsvno
            ";

            // コースコード指定時は条件節に追加
            if (!string.IsNullOrEmpty(csCd))
            {
                sql += @"
                        and consult.cscd = :cscd
                ";
            }

            // グループコードが指定されている場合
            if (!string.IsNullOrEmpty(grpCd))
            {
                // グループ内検査項目を受診項目として所有する受診情報のみを対象
                sql = @"
                        and (
                            exists (
                                select
                                    rsl.rsvno
                                from
                                    item_p
                                    , grp_i
                                    , rsl
                                where
                                    rsl.rsvno = receipt.rsvno
                                    and grp_i.grpcd = :grpcd
                                    and rsl.itemcd = grp_i.itemcd
                                    and rsl.suffix = grp_i.suffix
                                    and grp_i.itemcd = item_p.itemcd
                                    and item_p.rslque = " + RslQue.R + @"
                        )
                ";

                // グループ内検査項目に問診項目が存在すれば無条件対象
                sql += @"
                            || exists (
                                select
                                    grp_i.grpcd
                                from
                                    item_p
                                    , grp_i
                                where
                                    grp_i.grpcd = :grpcd
                                    and grp_i.itemcd = item_p.itemcd
                                    and item_p.rslque = " + RslQue.Q + @"
                            )
                        )
                ";
            }

            // 異常判定を持つ受診者のみを取得する場合
            if (badJudgemnetOnly)
            {
                // 現在登録されている判定情報の判定結果が異常とみなされるならば対象とする
                sql = @"
                        and exists (
                            select
                                judrsl.rsvno
                            from
                                jud
                                , judrsl
                            where
                                judrsl.rsvno = receipt.rsvno
                                and judrsl.judcd = jud.judcd
                                and jud.weight >= " + strBadWeight + @"
                        )
                ";
            }

            // 判定未完了者のみを取得する場合
            if (notCompletedJudgemnetOnly)
            {
                sql = @"
                        and checkresultpackage.checkexistsnojudgement(receipt.rsvno) > 0
                ";
            }

            // 予約群指定時
            if (rsvGrpCd != null)
            {
                sql += @"
                        and consult.rsvgrpcd = :rsvgrpcd
                ";
            }

            // 検査完了・未完了のチェック
            while (true)
            {

                // 引数未指定時は何もしない
                if (string.IsNullOrEmpty(entryStatus))
                {
                    break;
                }

                // 検査完了・未完了をチェックしない場合は何もしない
                if (!entryStatus.Equals(ENTRYSTATUS_NOT_COMPLETED) && !entryStatus.Equals(ENTRYSTATUS_COMPLETED))
                {
                    break;
                }

                sql += @"
                        and checkresultpackage.checkexistsnoresult(receipt.rsvno) = " + (entryStatus.Equals(ENTRYSTATUS_NOT_COMPLETED) ? "1" : "0") + @"
                ";

                break;
            }

            // 以下は未受付の受診情報を抽出する処理
            while (true)
            {
                // 来院者のみ取得する場合は何もしない
                if (comeOnly)
                {
                    break;
                }

                // 未受付の受診情報を含めない場合は何もしない
                if (!needUnReceiptConsult)
                {
                    break;
                }

                // 当日ＩＤが指定されている場合は何もしない
                if ((startDayId != null) || (endDayId != null))
                {
                    break;
                }

                // 未受付であれば当然異常判定(というか判定自体)を所有しないため、抽出非対象とする
                if (badJudgemnetOnly)
                {
                    break;
                }

                // 未受付であれば判定自体を所有しないため、判定未完云々で抽出制御する必要はない
                if (notCompletedJudgemnetOnly)
                {
                    break;
                }

                // 検査完了・未完了は受付後の受診情報に対して行うチェックのため、本条件指定時は未受付の受診情報はチェックしない
                if (!string.IsNullOrEmpty(entryStatus))
                {
                    if (entryStatus.Equals(ENTRYSTATUS_NOT_COMPLETED) || entryStatus.Equals(ENTRYSTATUS_COMPLETED))
                    {
                        break;
                    }
                }

                // これより抽出する受診情報は先に抽出した受付情報とは排反(双方に含まれるデータが互いに存在しない)ため、UNION ALL結合する
                sql += @"
                    union all
                ";

                // 指定された受診日の受診情報を取得(当日ＩＤ、フィルム番号については当然存在しないのでNULLを返させる)
                sql += @"
                    select
                        consult.rsvno
                        , receipt.dayid
                        , consult.perid
                        , consult.cscd
                        , consult.csldate
                        , consult.orgcd1
                        , consult.orgcd2
                        , consult.age
                        , consult.volunteer
                        , consult.volunteername
                        , ' ' filmmngdiv
                        , consult.rsvgrpcd
                        , usp_mensetsu_state(consult.rsvno) mensetsustate
                ";

                // FROM句(フィルム番号は検査結果情報より取得する)
                sql += @"
                    from
                        receipt
                        , consult
                ";

                // まず指定された受診日の非キャンセル受診情報を対象とする
                sql += @"
                    where
                        consult.csldate = :csldate
                        and consult.cancelflg = " + ConsultCancel.Used + @"
                ";

                // 未受付受診情報を抽出するため、受付情報の存在しないレコードを対象とさせる
                sql += @"
                        and consult.csldate = receipt.csldate(+)
                        and consult.rsvno = receipt.rsvno(+)
                        and receipt.dayid is null
                ";

                // コースコード指定時は条件節に追加
                if (!string.IsNullOrEmpty(csCd.Trim()))
                {
                    sql += @"
                        and consult.cscd = :cscd
                    ";
                }

                // 予約群指定時
                if (rsvGrpCd != null)
                {
                    sql += @"
                        and consult.rsvgrpcd = :rsvgrpcd
                    ";
                }

                break;
            }

            // 冒頭のFROM句の括弧閉じ
            sql += @"
                    ) basedconsult
            ";

            // コース・個人・団体の各情報を結合
            sql += @"
                where
                    basedconsult.cscd = course_p.cscd
                    and basedconsult.perid = person.perid
                    and basedconsult.orgcd1 = org.orgcd1
                    and basedconsult.orgcd2 = org.orgcd2
            ";

            sql += @"
                    and basedconsult.rsvno = filmmng.rsvno(+)
                    and basedconsult.filmmngdiv = filmmng.filmmngdiv(+)
            ";

            sql += @"
                    and basedconsult.rsvgrpcd = rsvgrp.rsvgrpcd
            ";

            // ソート順の指定
            if (sortKey.Equals(SORT_PERID))
            {
                // ソート順の指定(個人ＩＤ順)
                sql += @"
                order by
                    basedconsult.perid
                    , basedconsult.cscd
                ";
            }
            else if (sortKey.Equals(SORT_DAYID))
            {
                // ソート順の指定(当日ＩＤ順)
                sql += @"
                order by
                    basedconsult.dayid nulls last
                    , basedconsult.cscd
                    , basedconsult.orgcd1
                    , basedconsult.orgcd2
                    , basedconsult.perid
                ";
            }
            else
            {
                sql += @"
                order by
                    filmmng.filmno nulls last
                    , basedconsult.dayid nulls last
                    , basedconsult.cscd
                    , basedconsult.orgcd1
                    , basedconsult.orgcd2
                    , basedconsult.perid
                ";
            }

            IList<dynamic> data = connection.Query(sql, param).ToList();

            // 開始位置から取得件数分のデータと全検索件数の組を返す
            return new PartialDataSet(data.Count, data.Skip(startPos - 1).Take(getCount).ToList());
        }

        /// <summary>
        /// 検索予約番号の前後の予約番号および当日IDを取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="sortKey">並び順</param>
        /// <param name="cntlNo">管理番号</param>
        /// <param name="needUnReceiptConsult">未受付者取得フラグ</param>
        /// <param name="badJudgemnetOnly">異常判定所持者取得フラグ</param>
        /// <param name="notCompletedJudgemnetOnly">判定未完了者取得フラグ</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="prevRsvNo">前受診者予約番号</param>
        /// <param name="prevDayId">前受診者当日ID</param>
        /// <param name="nextRsvNo">次受診者予約番号</param>
        /// <param name="nextDayId">次受診者当日ID</param>
        /// <param name="comeOnly">true時は来院者のみ取得(このときneedUnReceiptConsult値は無効)</param>
        public void SelectCurRsvNoPrevNext(
            DateTime cslDate,
            string csCd,
            string sortKey,
            int cntlNo,
            bool needUnReceiptConsult,
            bool badJudgemnetOnly,
            bool notCompletedJudgemnetOnly,
            int rsvNo,
            out int? prevRsvNo,
            out int? prevDayId,
            out int? nextRsvNo,
            out int? nextDayId,
            bool comeOnly = false
        )
        {
            // 初期処理
            prevRsvNo = null;
            prevDayId = null;
            nextRsvNo = null;
            nextDayId = null;

            // 受診情報一覧の取得
            PartialDataSet ds = SelectConsultList(
                cslDate,
                cntlNo,
                csCd,
                sortKey: sortKey,
                needUnReceiptConsult: needUnReceiptConsult,
                badJudgemnetOnly: badJudgemnetOnly,
                notCompletedJudgemnetOnly: notCompletedJudgemnetOnly,
                comeOnly: comeOnly
            );

            IList<IDictionary<string, object>> consults = ds.Data;

            // 受診情報を検索
            for (var i = 0; i < consults.Count; i++)
            {
                // 引数指定された予約番号と一致する場合
                if (Convert.ToInt32(consults[i]["RSVNO"]) == rsvNo)
                {
                    // 前受診者の予約番号・当日ＩＤを取得する
                    if (i > 0)
                    {
                        prevRsvNo = Convert.ToInt32(consults[i - 1]["RSVNO"]);
                        prevDayId = Convert.ToInt32(consults[i - 1]["DAYID"]);
                    }

                    // 次受診者の予約番号・当日ＩＤを取得する
                    if (i + 1 < consults.Count)
                    {
                        nextRsvNo = Convert.ToInt32(consults[i + 1]["RSVNO"]);
                        nextDayId = Convert.ToInt32(consults[i + 1]["DAYID"]);
                    }

                    break;
                }
            }
        }

        /// <summary>
        /// 指定の予約番号に対する受診情報、個人情報を抽出
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="chkDate">受診年月日フラグ</param>
        /// <param name="chkCsCd">コースコードフラグ</param>
        /// <param name="chkOrgCd">受診時団体コードフラグ</param>
        /// <param name="chkAge">受診時年齢フラグ</param>
        /// <param name="chkEmpNo">従業員番号フラグ</param>
        /// <param name="chkPerId">個人ＩＤフラグ</param>
        /// <param name="chkName">氏名フラグ</param>
        /// <param name="chkBirth">生年月日フラグ</param>
        /// <param name="chkGender">性別フラグ</param>
        /// <returns>抽出した項目のリスト</returns>
        public IList<string> SelectDatCslPer(
            int rsvNo,
            string chkDate,
            string chkCsCd,
            string chkOrgCd,
            string chkAge,
            string chkEmpNo,
            string chkPerId,
            string chkName,
            string chkBirth,
            string chkGender
        )
        {
            var data = new List<string>(); // 受診情報、および個人情報用配列

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // SQL文の編集
            var sql = @"
                select
                    to_char(consult.csldate,'yyyy/MM/dd') csldate
                    , consult.cscd
                    , consult.orgcd1
                    , consult.orgcd2
                    , consult.age
                    , consult.empno
                    , person.perid
                    , person.lastname
                    , person.firstname
                    , to_char(person.birth,'yyyy/MM/dd') birth
                    , decode(person.gender, '1', '男性', '2', '女性', null) gendername
                    , consult.orgcd1
                    , consult.orgcd2
                    , nvl(org.orgname, '') orgname
                from
                    consult
                    , person
                    , org
                where
                    consult.rsvno = :rsvno
                    and consult.perid = person.perid
                    and consult.orgcd1 = org.orgcd1(+)
                    and consult.orgcd2 = org.orgcd2(+)
                order by
                    consult.csldate
            ";

            // 検索条件を満たすレコードを取得
            dynamic rec = connection.Query(sql, param).FirstOrDefault();

            // 検索レコードが存在する場合
            if (rec != null)
            {
                // 配列形式で格納する
                // 各フラグがチェックされていれば配列に格納
                if (!string.IsNullOrEmpty(chkDate))
                {
                    data.Add(Convert.ToString(rec.CSLDATE));
                }
                if (!string.IsNullOrEmpty(chkCsCd))
                {
                    data.Add(Convert.ToString(rec.CSCD));
                }
                if (!string.IsNullOrEmpty(chkOrgCd))
                {
                    data.Add(Convert.ToString(rec.ORGCD1) + "-" + Convert.ToString(rec.ORGCD2));
                }
                if (!string.IsNullOrEmpty(chkOrgCd))
                {
                    data.Add(Convert.ToString(rec.ORGNAME));
                }
                if (!string.IsNullOrEmpty(chkAge))
                {
                    data.Add(Convert.ToString(rec.AGE));
                }
                if (!string.IsNullOrEmpty(chkEmpNo))
                {
                    data.Add(Convert.ToString(rec.EMPNO));
                }
                if (!string.IsNullOrEmpty(chkPerId))
                {
                    data.Add(Convert.ToString(rec.PERID));
                }
                if (!string.IsNullOrEmpty(chkName))
                {
                    data.Add(Convert.ToString(rec.LASTNAME));
                    data.Add(Convert.ToString(rec.FIRSTNAME));
                }
                if (!string.IsNullOrEmpty(chkBirth))
                {
                    data.Add(Convert.ToString(rec.BIRTH));
                }
                if (!string.IsNullOrEmpty(chkGender))
                {
                    data.Add(Convert.ToString(rec.GENDERNAME));
                }
            }

            // 戻り値の設定
            if (data.Count > 0)
            {
                return data;
            }

            return null;
        }

        /// <summary>
        /// 指定の予約番号に対する判定結果情報を抽出
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judAll">判定抽出方法(0:すべて、1:指定判定分類のみ)</param>
        /// <param name="judCondition">検査結果条件</param>
        /// <param name="judClassCd">判定分類コードの配列</param>
        /// <param name="weightFrom">判定用重み(FROM側)の配列</param>
        /// <param name="judMarkFrom">判定コード(FROM側)範囲指定の配列</param>
        /// <param name="weightTo">判定用重み(TO側)の配列</param>
        /// <param name="judMarkTo">判定コード(TO側)範囲指定の配列</param>
        /// <returns>抽出した項目の配列</returns>
        public string[] SelectDatJudRsl(
            int rsvNo,
            int judAll,
            string[] judCondition,
            int?[] judClassCd,
            int?[] weightFrom,
            string[] judMarkFrom,
            int?[] weightTo,
            string[] judMarkTo
        )
        {
            const int JUDCLASSROW = 3;         // 総合判定の1件あたりの出力項目数

            var judClassName = new List<string>(); // 判定分類名称のリスト
            var judCd = new List<string>(); // 判定コードのリスト
            var judSName = new List<string>(); // 判定略称のリスト

            string[] arrData = null; // 受診情報、および個人情報用配列

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // SQL文の編集
            var sql = @"
                select
                    judrsl.judclasscd
                    , judclass.judclassname
                    , jud.judcd
                    , jud.judsname
                    , jud.weight
                from
                    jud
                    , judclass
                    , judrsl
                where
                    judrsl.rsvno = :rsvno
                    and judrsl.judclasscd = judclass.judclasscd
                    and judrsl.judcd = jud.judcd(+)
                order by
                    judrsl.rsvno
                    , judrsl.judclasscd
            ";


            // 検索条件を満たすレコードを取得
            IList<dynamic> data = connection.Query(sql, param).ToList();

            // 配列形式で格納する
            int recCount = 0; // レコード数

            foreach (var rec in data)
            {
                // 抽出要否の判定
                bool findFlg = false;
                while (true)
                {
                    // すべて抽出する場合、以下の判定処理は行わない
                    if (judAll == 0)
                    {
                        findFlg = true;
                        break;
                    }

                    // 絞込条件から同一判定分類を検索
                    var pos = -1;
                    for (var i = 0; i < judCondition.Length; i++)
                    {
                        if (!string.IsNullOrEmpty(judCondition[i]) && Util.ConvertToString(judClassCd[i]).Equals(Convert.ToString(rec.JUDCLASSCD)))
                        {
                            pos = i;
                            break;
                        }
                    }

                    // 検索不能時は処理を抜ける
                    if (pos < 0)
                    {
                        break;
                    }

                    // 判定結果の範囲指定

                    // FROM側、TO側ともに指定されているとき
                    if ((weightFrom[pos] != null) && (weightTo[pos] != null))
                    {
                        // 判定が存在しない場合は処理を抜ける
                        if ((rec.JUDCD == null) || (rec.WEIGHT == null))
                        {
                            break;
                        }

                        // 判定が重み範囲を外れる場合は処理を抜ける
                        int weight = Convert.ToInt32(rec.WEIGHT);
                        if ((weight < weightFrom[pos]) || (weight > weightTo[pos]))
                        {
                            break;
                        }

                        findFlg = true;
                        break;
                    }

                    // FROM側にのみ指定されているとき
                    if ((weightFrom[pos] != null))
                    {
                        // 判定が存在しない場合は処理を抜ける
                        if ((rec.JUDCD == null) || (rec.WEIGHT == null))
                        {
                            break;
                        }

                        // 判定が重み範囲を外れる場合は処理を抜ける
                        int weight = Convert.ToInt32(rec.WEIGHT);
                        if (judMarkFrom[pos].Equals(OPTION_EQ) && (weight != weightFrom[pos]))
                        {
                            break;
                        }

                        if (judMarkFrom[pos].Equals(OPTION_GE) && (weight < weightFrom[pos]))
                        {
                            break;
                        }

                        if (judMarkFrom[pos].Equals(OPTION_LE) && (weight > weightFrom[pos]))
                        {
                            break;
                        }

                        findFlg = true;
                        break;
                    }

                    // TO側にのみ指定されているとき
                    if (weightTo[pos] != null)
                    {

                        // 判定が存在しない場合は処理を抜ける
                        if ((rec.JUDCD == null) || (rec.WEIGHT == null))
                        {
                            break;
                        }

                        // 判定が重み範囲を外れる場合は処理を抜ける
                        int weight = Convert.ToInt32(rec.WEIGHT);
                        if (judMarkTo[pos].Equals(OPTION_EQ) && (weight != weightTo[pos]))
                        {
                            break;
                        }

                        if (judMarkTo[pos].Equals(OPTION_GE) && (weight < weightTo[pos]))
                        {
                            break;
                        }

                        if (judMarkTo[pos].Equals(OPTION_LE) && (weight > weightTo[pos]))
                        {
                            break;
                        }

                    }

                    findFlg = true;
                    break;
                }

                // 抽出対象であれば
                if (findFlg)
                {
                    // データ格納
                    judClassName.Add(Convert.ToString(rec.JUDCLASSNAME));
                    judCd.Add(Convert.ToString(rec.JUDCD));
                    judSName.Add(Convert.ToString(rec.JUDSNAME));
                    recCount = recCount + 1;
                }
            }

            if (judClassName.Count > 0)
            {
                arrData = new string[recCount * JUDCLASSROW];
                int j = 0;
                for (var i = 0; i < judClassName.Count; i++)
                {
                    // 戻り値用の配列に格納する
                    arrData[j] = judClassName[i];
                    arrData[j + 1] = judCd[i];
                    arrData[j + 2] = judSName[i];
                    j = j + 3;
                }
            }

            // 戻り値の設定
            return arrData;
        }

        /// <summary>
        /// 指定の予約番号に対する検査結果情報を抽出
        /// </summary>
        /// <param name="rsvNo"></param>
        /// <param name="optResult">検査項目抽出条件</param>
        /// <param name="chkOption">結果コメント・正常値フラグ</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="rslValueFrom">検査結果(FROM側)の配列</param>
        /// <param name="rslMarkFrom">検査結果(FROM側)範囲指定の配列</param>
        /// <param name="rslValueTo">検査結果(TO側)の配列</param>
        /// <param name="rslMarkTo">検査結果(TO側)範囲指定の配列</param>
        /// <param name="rslCondition">検査結果条件(結果タイプ)</param>
        /// <param name="selItemCd">検査項目コードの配列</param>
        /// <param name="selSuffix">サフィックスの配列</param>
        /// <param name="rsvNoSkipFlg">検査結果による該当予約番号の処理スキップフラグ</param>
        /// <param name="recCount">抽出レコード件数</param>
        /// <returns>抽出した項目の配列</returns>
        public string[] SelectDatRsl(
            int rsvNo,
            string optResult,
            string chkOption,
            string[] itemCd,
            string[] suffix,
            string[] rslValueFrom,
            string[] rslMarkFrom,
            string[] rslValueTo,
            string[] rslMarkTo,
            string[] rslCondition,
            string[] selItemCd,
            string[] selSuffix,
            out bool rsvNoSkipFlg,
            out int recCount
        )
        {
            string sql;           // SQLステートメント

            var arrItemCd = new List<string>(); // 検査項目コード
            var arrSuffix = new List<string>(); // サフィックス
            var arrResult = new List<string>(); // 検査結果

            string[] arrData = null; // 受診情報、および個人情報用配列

            double rslValueFrom_double; // 検査結果条件値(FROM側)
            double rslValueTo_double; // 検査結果条件値(TO側)
            string rslValueFrom_string; // 検査結果条件値(FROM側)
            string rslValueTo_string; // 検査結果条件値(TO側)

            string wkRslMark; // 検査結果条件記号
            string wkItemCd; // 検査項目コード
            string wkSuffix; // サフィックス

            int recCount2 = 0; // レコード数（該当データ抽出時）

            int j = 0;

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // スキップフラグのリセット
            rsvNoSkipFlg = true;

            // レコード件数のリセット
            recCount = 0;

            while (true)
            {
                // 検査結果条件による予約番号の絞込み
                bool checkOk = true;

                // SQL文の編集
                sql = @"
                    select
                        itemcd
                        , suffix
                        , result
                    from
                        rsl
                    where
                        rsvno = :rsvno
                ";

                // 検索条件を満たすレコードを取得
                List<dynamic> data = connection.Query(sql, param).ToList();

                // 検索レコードが存在する場合
                if (data.Count > 0)
                {
                    // 配列形式で格納する
                    int itemCount = data.Count;
                    foreach (var rec in data)
                    {
                        // データ格納
                        arrItemCd.Add(Convert.ToString(rec.ITEMCD));
                        arrSuffix.Add(Convert.ToString(rec.SUFFIX));
                        arrResult.Add(Convert.ToString(rec.RESULT));
                    }

                    // 検査条件のチェック
                    for (var i = 0; i < rslCondition.Length; i++)
                    {
                        // 条件設定されているとき、そうでなければ次の条件候補へ処理スキップ
                        if (!string.IsNullOrEmpty(rslCondition[i]))
                        {
                            // 検査項目の存在チェック
                            j = 0;
                            bool existsItem = false;
                            while (j < arrItemCd.Count)
                            {
                                // 検査項目が存在するときフラグを立て比較処理へ
                                if ((itemCd[i].Equals(arrItemCd[j])) && (suffix[i].Equals(arrSuffix[j])))
                                {
                                    existsItem = true;
                                    break;
                                }
                                j = j + 1;
                            }

                            double rslValue_double = 0; // 検査結果値
                            string rslValue_string = null; // 検査結果値
                            bool isNumeric = false; // 数値･計算タイプフラグ

                            // 検査項目が存在し、かつ、検査項目値が存在するとき比較処理を、それ以外は抽出対象外
                            if (existsItem && !string.IsNullOrEmpty(arrResult[j]))
                            {
                                // 条件タイプおよび検査結果値のセット
                                if (rslCondition[i].Equals("0") || rslCondition[i].Equals("5"))
                                {
                                    isNumeric = true;                    // 数値・計算タイプ
                                    rslValue_double = double.Parse(arrResult[j]);
                                }
                                else
                                {
                                    isNumeric = false;                   // 上記以外のタイプ
                                    rslValue_string = arrResult[j].Trim();
                                }
                                // 検査結果の範囲指定
                                if (!string.IsNullOrEmpty(rslValueFrom[i]) && !string.IsNullOrEmpty(rslValueTo[i]))
                                {
                                    // FROM側、TO側ともに指定されているとき
                                    if (isNumeric)
                                    {
                                        rslValueFrom_double = double.Parse(rslValueFrom[i]);
                                        rslValueTo_double = double.Parse(rslValueTo[i]);
                                        if ((rslValue_double < rslValueFrom_double) || (rslValue_double > rslValueTo_double))
                                        {
                                            checkOk = false;               // 条件チェックNG
                                        }
                                    }
                                    else
                                    {
                                        rslValueFrom_string = rslValueFrom[i].Trim();
                                        rslValueTo_string = rslValueTo[i].Trim();
                                        if ((string.Compare(rslValue_string, rslValueFrom_string, StringComparison.Ordinal) < 0) || (string.Compare(rslValue_string, rslValueTo_string, StringComparison.Ordinal) > 0))
                                        {
                                            checkOk = false;               // 条件チェックNG
                                        }
                                    }
                                }
                                else
                                {
                                    double rsl_double = 0; // 検査結果条件値
                                    string rsl_string = null; // 検査結果条件値

                                    // FROM側、TO側いずれかに指定されているとき
                                    if (!string.IsNullOrEmpty(rslValueFrom[i]))
                                    {
                                        if (isNumeric)
                                        {
                                            rsl_double = double.Parse(rslValueFrom[i]);
                                        }
                                        else
                                        {
                                            rsl_string = rslValueFrom[i].Trim();
                                        }
                                        wkRslMark = rslMarkFrom[i];
                                    }
                                    else
                                    {
                                        if (isNumeric)
                                        {
                                            rsl_double = double.Parse(rslValueTo[i]);
                                        }
                                        else
                                        {
                                            rsl_string = rslValueTo[i].Trim();
                                        }
                                        wkRslMark = rslMarkTo[i];
                                    }
                                    switch (wkRslMark)
                                    {
                                        case OPTION_EQ:
                                            if (isNumeric)
                                            {
                                                if (!rslValue_double.Equals(rsl_double))
                                                {
                                                    checkOk = false;       // 条件チェックNG
                                                }
                                            }
                                            else
                                            {
                                                if (!rslValue_string.Equals(rsl_string))
                                                {
                                                    checkOk = false;       // 条件チェックNG
                                                }
                                            }
                                            break;
                                        case OPTION_GE:
                                            if (isNumeric)
                                            {
                                                if (rslValue_double < rsl_double)
                                                {
                                                    checkOk = false;       // 条件チェックNG
                                                }
                                            }
                                            else
                                            {
                                                if (string.Compare(rslValue_string, rsl_string) < 0)
                                                {
                                                    checkOk = false;       // 条件チェックNG
                                                }
                                            }
                                            break;
                                        case OPTION_LE:
                                            if (isNumeric)
                                            {
                                                if (rslValue_double > rsl_double)
                                                {
                                                    checkOk = false;       // 条件チェックNG
                                                }
                                            }
                                            else
                                            {
                                                if (string.Compare(rslValue_string, rsl_string) > 0)
                                                {
                                                    checkOk = false;       // 条件チェックNG
                                                }
                                            }
                                            break;
                                    }
                                }
                            }
                            else
                            {
                                checkOk = false;                       // 条件チェックNG
                            }
                        }
                        // 条件指定された検査項目が存在しないか、検査結果が指定条件に一致しないときチェック終了
                        if (!checkOk)
                        {
                            break;
                        }
                    }
                }

                // 検査結果条件を満たしていなければ以降の処理をスキップ
                if (!checkOk)
                {
                    break;
                }

                // 検査結果項目が抽出指定されているときデータ抽出
                if (!optResult.Equals(CASE_NOTSELECT))
                {
                    // SQL文の編集
                    sql = @"
                        select
                            itemcd
                            , suffix
                            , itemname
                            , decode(resulttype, :resulttype, shortstc, result) result
                            , resulttype
                            , decode(resulttype, :resulttype, shortstc, null) shortstc
                            , rslcmtcd1
                            , rslcmtname1
                            , rslcmtcd2
                            , rslcmtname2
                            , stdflg
                        from
                            (
                                select
                                    q.itemcd
                                    , q.suffix
                                    , q.itemname
                                    , q.result
                                    , q.resulttype
                                    , s.shortstc
                                    , q.rslcmtcd1
                                    , q.rslcmtname1
                                    , q.rslcmtcd2
                                    , q.rslcmtname2
                                    , q.stdflg
                                from
                                    (
                                        select
                                            r.itemcd
                                            , r.suffix
                                            , ic.itemname
                                            , r.result
                                            , ic.resulttype
                                            , ic.itemtype
                                            , ic.stcitemcd
                                            , r.rslcmtcd1
                                            , rc1.rslcmtname rslcmtname1
                                            , r.rslcmtcd2
                                            , rc2.rslcmtname rslcmtname2
                                            , sc.stdflg
                                        from
                                            rsl r
                                            , item_c ic
                                            , rslcmt rc1
                                            , rslcmt rc2
                                            , stdvalue_c sc
                                        where
                                            r.rsvno = :rsvno
                    ";

                    // 抽出すべき検査結果項目が指定されているとき
                    if (optResult.Equals(CASE_SELECT))
                    {
                        sql += @"
                                            and (
                        ";

                        // 配列個数分ループ
                        bool isFirstCondition = true;
                        for (var i = 0; i < selItemCd.Length; i++)
                        {
                            // 検索キーを設定
                            wkItemCd = selItemCd[i].Trim().Replace("'", "''");
                            wkSuffix = selSuffix[i].Trim().Replace("'", "''");
                            // 検査項目コードが存在するとき条件文を追加
                            if (!string.IsNullOrEmpty(selItemCd[i]) && !string.IsNullOrEmpty(selSuffix[i]))
                            {
                                if (isFirstCondition)
                                {
                                    sql += @"
                                                (r.itemcd = '" + wkItemCd + "' and r.suffix = '" + wkSuffix + @"')
                                    ";
                                    isFirstCondition = false;
                                }
                                else
                                {
                                    sql += @"
                                                or (r.itemcd = '" + wkItemCd + "' and r.suffix = '" + wkSuffix + @"')
                                    ";
                                }
                            }
                        }
                        sql += @"
                                            )
                        ";
                    }

                    sql += @"
                                            and r.itemcd = ic.itemcd
                                            and r.suffix = ic.suffix
                                            and r.rslcmtcd1 = rc1.rslcmtcd(+)
                                            and r.rslcmtcd2 = rc2.rslcmtcd(+)
                                            and r.stdvaluecd = sc.stdvaluecd(+)
                                    ) q
                                    , sentence s
                                where
                                    q.stcitemcd = s.itemcd(+)
                                    and q.itemtype  = s.itemtype(+)
                                    and q.result    = s.stccd(+)
                            )
                        order by
                            itemcd
                            , suffix
                    ";

                    // 検索条件を満たすレコードを取得
                    param.Add("resulttype", ResultType.Sentence);
                    IList<dynamic> records = connection.Query(sql, param).ToList();

                    // 検索レコードが存在する場合
                    if (records.Count > 0)
                    {
                        recCount2 = records.Count;

                        j = 0;

                        // １検査項目あたりの列数設定
                        int colCnt = 1;

                        // 結果コメント抽出オプション選択？
                        if (!string.IsNullOrEmpty(chkOption))
                        {
                            colCnt = colCnt + 5;
                        }

                        if (recCount2 > 0)
                        {
                            // 戻り値用の配列数確定
                            j = selItemCd.Length;
                            j = (j * colCnt);
                            arrData = new string[j];
                        }

                        // 取得したデータの格納
                        arrItemCd.Clear();
                        arrSuffix.Clear();
                        arrResult.Clear();
                        foreach (var rec in records)
                        {
                            arrItemCd.Add(Convert.ToString(rec.ITEMCD));
                            arrSuffix.Add(Convert.ToString(rec.SUFFIX));
                            arrResult.Add(Convert.ToString(rec.RESULT));
                        }

                        for (var i = 0; i < recCount2; i++)
                        {
                            // 検査項目の列位置を求める（列位置固定対応）
                            j = 0;
                            while (j < selItemCd.Length)
                            {
                                if (selItemCd[j].Equals(arrItemCd[i]) && selSuffix[j].Equals(arrSuffix[i]))
                                {
                                    break;
                                }
                                j++;
                            }
                            if (j < selItemCd.Length)
                            {
                                j = j * colCnt;
                                Array.Resize(ref arrData, j + 1);
                                arrData[j] = arrResult[i];

                                j = j + 1;
                                if (!string.IsNullOrEmpty(chkOption))
                                {
                                    // 結果コメント抽出オプションチェック時
                                    Array.Resize(ref arrData, j + 5);
                                    arrData[j] = Convert.ToString(records[i].RSLCMTCD1);
                                    arrData[j + 1] = Convert.ToString(records[i].RSLCMTNAME1);
                                    arrData[j + 2] = Convert.ToString(records[i].RSLCMTCD2);
                                    arrData[j + 3] = Convert.ToString(records[i].RSLCMTNAME2);
                                    arrData[j + 4] = Convert.ToString(records[i].STDFLG);
                                    j = j + 5;
                                }
                            }
                        }
                    }
                }

                // 戻り値の設定
                rsvNoSkipFlg = false;
                recCount = recCount2;
                if (j > 0)
                {
                    return arrData;
                }

                break;
            }

            return null;
        }

        /// <summary>
        /// 指定の汎用データ抽出条件に合致する予約番号、受診時年齢、性別のリストを抽出する
        /// </summary>
        /// <param name="startDate">受診年月日(自)</param>
        /// <param name="endDate">受診年月日(至)</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="subCsCd">サブコースコード</param>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="orgBsdCd">事業部コード</param>
        /// <param name="orgRoomCd">室部コード</param>
        /// <param name="orgPostCd1">所属コード1</param>
        /// <param name="orgPostCd2">所属コード2</param>
        /// <param name="startAge">受診時年齢(自)</param>
        /// <param name="endAge">受診時年齢(至)</param>
        /// <param name="gender">性別</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="rslCondition">検査結果条件(結果タイプ)</param>
        /// <param name="judClassCd">判定分類コードの配列</param>
        /// <param name="weightFrom">判定用重み(FROM側)の配列</param>
        /// <param name="judMarkFrom">判定コード(FROM側)範囲指定の配列</param>
        /// <param name="weightTo">判定用重み(TO側)の配列</param>
        /// <param name="judMarkTo">判定コード(TO側)範囲指定の配列</param>
        /// <param name="judCondition"></param>
        /// <param name="judOperation"></param>
        /// <returns>抽出した予約番号リスト</returns>
        IList<int> SelectDatRsvNoList(
            DateTime startDate,
            DateTime endDate,
            string csCd,
            string subCsCd,
            string orgCd1,
            string orgCd2,
            string orgBsdCd,
            string orgRoomCd,
            string orgPostCd1,
            string orgPostCd2,
            string startAge,
            string endAge,
            Gender gender,
            string[] itemCd,
            string[] suffix,
            string[] rslCondition,
            int?[] judClassCd,
            int?[] weightFrom,
            string[] judMarkFrom,
            int?[] weightTo,
            string[] judMarkTo,
            string[] judCondition,
            int judOperation
        )
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("strdate", startDate);
            param.Add("enddate", endDate);
            param.Add("cscd", csCd.Trim());
            param.Add("orgcd1", orgCd1.Trim());
            param.Add("orgcd2", orgCd2.Trim());
            param.Add("strage", startAge.Trim());
            param.Add("endage", endAge.Trim());
            param.Add("cancelflg", ConsultCancel.Used);
            param.Add("gender", gender);
            param.Add("delflg", DelFlg.Used);
            param.Add("subcscd", subCsCd.Trim());
            param.Add("orgbsdcd", orgBsdCd.Trim());
            param.Add("orgroomcd", orgRoomCd.Trim());
            param.Add("orgpostcd1", orgPostCd1.Trim());
            param.Add("orgpostcd2", orgPostCd2.Trim());

            // SQL文の編集
            var sql = @"
                select
                    consult.rsvno
                from
                    person
                    , consult
            ";

            // サブコースコード指定時
            if (!string.IsNullOrEmpty(subCsCd.Trim()))
            {
                sql += @"
                    , (
                        select
                            consult.rsvno
                        from
                            consult
                            , consult_o
                            , ctrpt_opt
                        where
                            consult.csldate between :strdate and :enddate
                            and consult.rsvno = consult_o.rsvno
                            and consult_o.ctrptcd = ctrpt_opt.ctrptcd
                            and consult_o.optcd = ctrpt_opt.optcd
                            and consult_o.optbranchno = ctrpt_opt.optbranchno
                            and ctrpt_opt.cscd = :subcscd
                        group by
                            consult.rsvno
                    ) consult_subcs
                ";
            }

            sql += @"
                where
                    consult.csldate >= :strdate
                    and consult.csldate <= :enddate
            ";

            // コースコード指定時
            if (!string.IsNullOrEmpty(csCd.Trim()))
            {
                sql += @"
                    and consult.cscd = :cscd
                ";
            }

            // サブコースコード指定時
            if (!string.IsNullOrEmpty(subCsCd.Trim()))
            {
                sql += @"
                    and consult.rsvno = consult_subcs.rsvno
                ";
            }

            // 団体コード指定時
            if (!string.IsNullOrEmpty(orgCd1.Trim()) || !string.IsNullOrEmpty(orgCd2.Trim()))
            {
                sql += @"
                    and consult.orgcd1 = :orgcd1
                    and consult.orgcd2 = :orgcd2
                ";
            }

            // 事業所コード指定時
            if (!string.IsNullOrEmpty(orgBsdCd.Trim()))
            {
                sql += @"
                    and consult.orgbsdcd = :orgbsdcd
                ";
            }

            // 室部コード指定時
            if (!string.IsNullOrEmpty(orgRoomCd.Trim()))
            {
                sql += @"
                    and consult.orgroomcd = :orgroomcd
                ";
            }
            // 所属コード指定時
            if (!string.IsNullOrEmpty(orgPostCd1.Trim()))
            {
                sql += @"
                    and consult.orgpostcd between :orgpostcd1 and :orgpostcd2
                ";
            }

            // 受診時年齢（範囲）
            sql += @"
                    and consult.age >= :strage
                    and consult.age <= :endage
            ";

            // キャンセルフラグ(「使用中」)
            sql += @"
                    and consult.cancelflg = :cancelflg
            ";

            // 受診情報と個人情報との結合
            sql += @"
                    and consult.perid = person.perid
            ";

            // 性別指定時
            if (gender != Gender.Both)
            {
                sql += @"
                    and person.gender = :gender
                ";
            }

            // 削除フラグ(「使用中」)
            sql += @"
                    and person.delflg = :delflg
            ";

            string operation; // 演算子
            bool hasCondition = false; // 演算子指定有無
            bool addFlg = false; // 追加フラグ

            // 総合判定条件での絞込み
            for (var i = 0; i < judCondition.Length; i++)
            {
                // 絞込条件が設定されているとき
                if (!string.IsNullOrEmpty(judCondition[i]))
                {
                    // 初めて条件を追加する場合
                    if (!hasCondition)
                    {
                        sql += "   and ( ";
                        hasCondition = true;
                    }

                    // ２つ目以降の条件に対しては演算子を指定
                    operation = "";
                    if (addFlg)
                    {
                        operation = (judOperation == 0) ? "and" : "or";
                    }

                    string paramJudClassCd = "jusclasscd" + i.ToString();
                    param.Add(paramJudClassCd, judClassCd[i]);

                    // 条件文の追加
                    sql += operation + @"
                        exists (
                            select
                                judrsl.rsvno
                            from
                                jud
                                , judrsl
                            where
                                judrsl.rsvno = consult.rsvno
                                and judrsl.judclasscd = :" + paramJudClassCd + @"
                                and judrsl.judcd = jud.judcd
                    ";

                    string paramWeightFrom = "weightfrom" + i.ToString();
                    string paramWeightTo = "weightto" + i.ToString();

                    // 判定結果の範囲指定
                    if ((weightFrom[i] != null) && (weightTo[i] != null))
                    {
                        // FROM側、TO側ともに指定されているとき
                        sql += " and jud.weight between :" + paramWeightFrom + " and :" + paramWeightTo;
                        param.Add(paramWeightFrom, weightFrom[i]);
                        param.Add(paramWeightTo, weightTo[i]);

                    }
                    else if (weightFrom[i] != null)
                    {
                        // FROM側にのみ指定されているとき
                        param.Add(paramWeightFrom, weightFrom[i]);
                        switch (judMarkFrom[i])
                        {
                            case OPTION_EQ:
                                sql += " and jud.weight  = :" + paramWeightFrom;
                                break;

                            case OPTION_GE:
                                sql += " and jud.weight >= :" + paramWeightFrom;
                                break;

                            case OPTION_LE:
                                sql += " and jud.weight <= :" + paramWeightFrom;
                                break;
                        }
                    }
                    else
                    {
                        // TO側にのみ指定されているとき
                        param.Add(paramWeightTo, weightTo[i]);
                        switch (judMarkTo[i])
                        {
                            case OPTION_EQ:
                                sql += " and jud.weight  = :" + paramWeightTo;
                                break;

                            case OPTION_GE:
                                sql += " and jud.weight >= :" + paramWeightTo;
                                break;

                            case OPTION_LE:
                                sql += " and jud.weight <= :" + paramWeightTo;
                                break;

                        }
                    }

                    sql += " ) ";

                    addFlg = true;
                }
            }

            if (hasCondition)
            {
                sql += " ) ";
            }

            // 検査結果条件での絞込み
            for (var i = 0; i < rslCondition.Length; i++)
            {
                // 絞込条件が設定されているとき
                if (!string.IsNullOrEmpty(rslCondition[i]))
                {
                    string paramItemCd = "itemcd" + i.ToString();
                    string paramSuffix = "suffix" + i.ToString();
                    param.Add(paramItemCd, itemCd[i]);
                    param.Add(paramSuffix, suffix[i]);

                    // 条件文の追加
                    sql += @"
                        and exists (
                            select
                                rsl.rsvno
                            from
                                rsl
                            where
                                rsl.rsvno = consult.rsvno
                                and rsl.itemcd = :" + paramItemCd + @"
                                and rsl.suffix = :" + paramSuffix + @"
                        )
                    ";
                }
            }

            // ORDER BY句の指定
            sql += @"
                order by
                    consult.csldate
                    , consult.cscd
                    , consult.orgcd1
                    , consult.orgcd2
                    , consult.perid
            ";

            return connection.Query(sql, param).Select(rec => (int)Convert.ToInt32(rec.RSVNO)).ToList();
        }

        /// <summary>
        /// 予約番号に合致する個人ID、受診日を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// 受診情報
        /// perid 個人ID
        /// befdate 受診日の前日
        /// csldate 受診日
        /// </returns>
        public dynamic SelectHistoryRsvNo(int rsvNo)
        {
            // 個人ＩＤが設定されていない場合はエラー
            if (rsvNo == 0)
            {
                throw new ArgumentException();
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 検索条件を満たす受診日情報を取得
            var sql = @"
                select
                    c.perid
                    , (c.csldate - 1) befdate
                    , c.csldate
                from
                    consult c
                where
                    c.rsvno = :rsvno
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 指定予約番号の受付情報を読む
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="recordLock">レコードロックを行うか</param>
        /// <returns>
        /// 受診情報
        /// dayid 当日ID
        /// upddate 更新日時
        /// comedate 来院日時
        /// comeuser 来院処理者
        /// ocrno OCR番号
        /// lockerkey ロッカーキー
        /// editocrdate OCR内容確認修正日時
        /// </returns>
        public dynamic SelectReceipt(int rsvNo, bool recordLock = false)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rptrsvno", rsvNo);

            // 受付情報の読み込み
            var sql = @"
                select
                    receipt.dayid
                    , receipt.upddate
                    , receipt.comedate
                    , receipt.comeuser
                    , receipt.ocrno
                    , receipt.lockerkey
                    , receipt.editocrdate
                from
                    receipt
                    , consult
                where
                    consult.rsvno = :rptrsvno
                    and consult.rsvno = receipt.rsvno
                    and consult.csldate = receipt.csldate
            ";

            if (recordLock)
            {
                sql += @"
                for update
                ";
            }

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 検索条件を満たす受診者の個人情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// 受診情報
        /// rsvno 予約番号
        /// perid 個人ID
        /// csldate 受診日
        /// cscd コースコード
        /// csname コース名
        /// lastname 姓
        /// firstname 名
        /// lastkname カナ姓
        /// firstkname カナ名
        /// birth 生年月日
        /// age 年齢
        /// gender 性別
        /// gendername 性別名称
        /// dayid 当日ID
        /// </returns>
        public dynamic SelectRslConsult(int rsvNo)
        {
            // 予約番号が設定されていない場合はエラー
            if (rsvNo == 0)
            {
                throw new ArgumentException();
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("cancelflg", ConsultCancel.Used);

            // 検索条件を満たす受診者情報のレコードを取得
            var sql = @"
                select
                    cn.rsvno
                    , cn.perid
                    , cn.csldate
                    , cn.cscd
                    , cp.csname
                    , p.lastname
                    , p.firstname
                    , p.lastkname
                    , p.firstkname
                    , p.birth
                    , cn.age
                    , p.gender
                    , decode(p.gender, '1', '男性', '2', '女性') gendername
                    , rc.dayid
                from
                    consult cn
                    , person p
                    , course_p cp
                    , receipt rc
                where
                    cn.rsvno = :rsvno
                    and cn.cancelflg = :cancelflg
                    and cn.perid = p.perid
                    and cn.cscd = cp.cscd
                    and cn.rsvno = rc.rsvno(+)
                    and cn.csldate = rc.csldate(+)
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 検査項目名を抽出
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <returns>検査項目名のリスト</returns>
        public IList<string> SelectHeadRsl(string[] itemCd, string[] suffix)
        {
            var itemName = new List<string>(); // 検査項目名

            // SQL文の編集
            string sql = @"
                select
                    itemcd
                    , suffix
                    , itemname
                from
                    item_c
                where
                    (
            ";

            // 配列個数分ループ
            bool conditionFlg = true;
            for (var i = 0; i < itemCd.Length; i++)
            {
                // 検索キーを設定
                string wkItemCd = itemCd[i].Trim().Replace("'", "''");
                string wkSuffix = suffix[i].Trim().Replace("'", "''");

                // 検査項目コードが存在するとき条件文を追加
                if (!string.IsNullOrEmpty(itemCd[i]) && !string.IsNullOrEmpty(suffix[i]))
                {
                    if (conditionFlg)
                    {
                        sql += @"
                        (itemcd = '" + wkItemCd + "' and suffix = '" + wkSuffix + @"')
                        ";
                        conditionFlg = false;
                    }
                    else
                    {
                        sql += @"
                        or (itemcd = '" + wkItemCd + "' and suffix = '" + wkSuffix + @"')
                        ";
                    }
                }
            }

            sql += @"
                    )
                order by
                    itemcd
                    , suffix
            ";

            // 検索条件を満たすレコードを取得
            return connection.Query(sql).Select(rec => (string)Convert.ToString(rec.ITEMNAME)).ToArray();
        }

        /// <summary>
        /// グループ"999"の検査項目を抽出
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        public void SelectAllRslItem(out string[] itemCd, out string[] suffix)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("grpcd", "999");

            // SQL文の編集
            var sql = @"
                select
                    itemcd
                    , suffix
                from
                    grp_i
                where
                    grpcd = :grpcd
                order by
                    itemcd
                    , suffix
            ";

            var data = connection.Query(sql, param);

            itemCd = data.Select(rec => (string)Convert.ToString(rec.ITEMCD)).ToArray();
            suffix = data.Select(rec => (string)Convert.ToString(rec.SUFFIX)).ToArray();
        }

        /// <summary>
        /// 受診時追加検査項目テーブルの更新
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ipAddress">IPアドレス</param>
        /// <param name="updUser">更新者</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="consults">受診状態("1":受診、"0":未受診)</param>
        public void SetConsult_I(int rsvNo, string ipAddress, string updUser, string[] itemCd, string[] consults)
        {
            // キー値の設定
            var param = new OracleDynamicParameters();
            param.Add("rsvno", rsvNo, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("ipaddress", ipAddress, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("upduser", updUser, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("itemcd", itemCd, OracleDbType.Varchar2, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("consults", consults, OracleDbType.Varchar2, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);

            // 戻り値のバインド変数定義
            param.Add("ret", dbType: OracleDbType.Decimal, direction: ParameterDirection.ReturnValue);
            param.Add("message", dbType: OracleDbType.Varchar2, direction: ParameterDirection.Output);

            // 受診時追加検査項目テーブル更新用ストアドパッケージの関数呼び出し
            var sql = @"
                begin
                    :ret := consultpackagelukes.setdeleteconsultitem(
                        :rsvno,
                        :ipaddress,
                        :upduser,
                        :itemcd,
                        :consults,
                        :message
                    );
                end;
            ";

            // PL/SQL文の実行
            connection.Execute(sql, param);

            // 戻り値の取得
            OracleString dbMessage = param.Get<OracleString>("message");
            string message = dbMessage.IsNull ? null : dbMessage.Value;
            if (!string.IsNullOrEmpty(message))
            {
                throw new Exception(message);
            }
        }

        /// <summary>
        /// 指定予約番号範囲の受診情報に対する切り捨て処理
        /// </summary>
        /// <param name="startRsvNo">開始予約番号</param>
        /// <param name="endRsvNo">終了予約番号</param>
        /// <param name="updUser">更新者</param>
        public void TruncateConsult(int startRsvNo, int endRsvNo, string updUser)
        {
            // キー値の設定
            var param = new OracleDynamicParameters();
            param.Add("strrsvno", startRsvNo, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("endrsvno", endRsvNo, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("upduser", updUser, OracleDbType.Varchar2, ParameterDirection.Input);

            // 指定予約番号範囲の受診情報に対する切り捨て処理
            var sql = @"
                begin
                    consultallpackage.truncateconsult(
                        :strrsvno
                        , :endrsvno
                        , :upduser
                    );
                end;
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 受診情報テーブルレコードを更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ipAddress">IPアドレス</param>
        /// <param name="updUser">更新者</param>
        /// <param name="data">受診情報</param>
        /// <param name="message">メッセージ</param>
        /// <returns>予約番号</returns>
        public int UpdateConsult(int rsvNo, string ipAddress, string updUser, UpdateConsultationModel data, out string message)
        {
            // キー及び更新値の設定
            var param = new OracleDynamicParameters();
            param.Add("rsvno", rsvNo, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("csldate", DateTime.Parse(data.Consult.CslDate), OracleDbType.Date, ParameterDirection.Input);
            param.Add("perid", data.Consult.PerId, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("cscd", data.Consult.CsCd, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("orgcd1", data.Consult.OrgCd1, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("orgcd2", data.Consult.OrgCd2, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("rsvgrpcd", data.Consult.RsvGrpCd, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("age", data.Consult.Age, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("upduser", updUser, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("ctrptcd", data.Consult.CtrPtCd, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("firstrsvno", data.Consult.FirstRsvNo, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("csldivcd", data.Consult.CslDivCd, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("rsvstatus", data.ConsultDetail.RsvStatus, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("prtonsave", data.ConsultDetail.PrtOnSave, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("cardaddrdiv", data.ConsultDetail.CardAddrDiv, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("cardouteng", data.ConsultDetail.CardOutEng, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("formaddrdiv", data.ConsultDetail.FormAddrDiv, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("formouteng", data.ConsultDetail.FormOutEng, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("reportaddrdiv", data.ConsultDetail.ReportAddrDiv, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("reportoureng", data.ConsultDetail.ReportOurEng, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("volunteer", data.ConsultDetail.Volunteer, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("volunteername", Strings.StrConv(data.ConsultDetail.VolunteerName, VbStrConv.Wide), OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("collectticket", data.ConsultDetail.CollectTicket, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("issuecslticket", data.ConsultDetail.IssueCslTicket, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("billprint", data.ConsultDetail.BillPrint, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("isrsign", data.ConsultDetail.IsrSign, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("isrno", data.ConsultDetail.IsrNo, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("isrmanno", data.ConsultDetail.IsrManNo, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("empno", data.ConsultDetail.EmpNo, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("introductor", data.ConsultDetail.Introductor, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("curdayid", data.Consult.CurDayId, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("mode", data.Consult.Mode, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("dayid", data.Consult.DayId, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("ignoreflg", data.Consult.IgnoreFlg, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("ipaddress", ipAddress, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("currentperid", data.Consult.CurrentPerId, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("sendmaildiv", data.ConsultDetail.SendMailDiv, OracleDbType.Decimal, ParameterDirection.Input);

            // オプション検査のバインド変数定義
            // 枝番がNULLの検査項目を削除
            Dictionary<string, int> options = data.ConsultOptions?.Where(r => r.Value != null).ToDictionary(r => r.Key, r => (int)r.Value);
            string[] optCd = options?.Keys.ToArray();
            int[] optBranchNo = options?.Values.ToArray();
            param.Add("optcd", optCd.Length == 0 ? new string[] { null } : optCd, OracleDbType.Varchar2, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("optbranchno", optBranchNo.Length == 0 ? new int[] { 0 } : optBranchNo, OracleDbType.Decimal, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("optcount", optCd.Length, OracleDbType.Decimal, ParameterDirection.Input);

            // 戻り値のバインド変数定義
            param.Add("ret", dbType: OracleDbType.Decimal, direction: ParameterDirection.ReturnValue);
            param.Add("message", dbType: OracleDbType.Varchar2, direction: ParameterDirection.Output, size: 1000);

            // 受診情報登録用ストアドパッケージの関数呼び出し
            var sql = @"
                begin
                    :ret := consultpackagelukes.updateconsult(
                        :rsvno
                        , :csldate
                        , :perid
                        , :cscd
                        , :orgcd1
                        , :orgcd2
                        , :rsvgrpcd
                        , :age
                        , :upduser
                        , :ctrptcd
                        , :firstrsvno
                        , :csldivcd
                        , :rsvstatus
                        , :prtonsave
                        , :cardaddrdiv
                        , :cardouteng
                        , :formaddrdiv
                        , :formouteng
                        , :reportaddrdiv
                        , :reportoureng
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
                        , :curdayid
                        , :optcd
                        , :optbranchno
                        , :optcount
                        , :mode
                        , :dayid
                        , :message
                        , :ignoreflg
                        , :ipaddress
                        , :currentperid
                        , :sendmaildiv
                    );
                end;
            ";

            // PL/SQL文の実行
            connection.Execute(sql, param);

            // 戻り値の取得
            var dbMessage = param.Get<OracleString>("message");
            message = dbMessage.IsNull ? null : dbMessage.Value;

            // 戻り値の設定
            return param.Get<OracleDecimal>("ret").ToInt32();
        }

        /// <summary>
        /// 受診オプションテーブルレコードを更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <param name="consults">受診要否</param>
        /// <param name="ipAddress">IPアドレス</param>
        /// <param name="updUser">更新者</param>
        /// <param name="ignoreFlg">予約枠無視フラグ</param>
        /// <param name="message">メッセージ</param>
        /// <returns>予約番号</returns>
        public int UpdateConsult_O(
            int rsvNo,
            int ctrPtCd,
            string[] optCd,
            int[] optBranchNo,
            string[] consults,
            string ipAddress,
            string updUser,
            int ignoreFlg,
            out string message
        )
        {
            // キー及び更新値の設定
            var param = new OracleDynamicParameters();
            param.Add("rsvno", rsvNo, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("ctrptcd", ctrPtCd, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("ipaddress", ipAddress, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("upduser", updUser, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("ignoreflg", ignoreFlg, OracleDbType.Decimal, ParameterDirection.Input);

            // オプション検査のバインド変数定義
            param.Add("optcd", optCd, OracleDbType.Varchar2, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("optbranchno", optBranchNo, OracleDbType.Decimal, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("consults", consults, OracleDbType.Varchar2, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);

            // 戻り値のバインド変数定義
            param.Add("ret", dbType: OracleDbType.Decimal, direction: ParameterDirection.ReturnValue);
            param.Add("message", dbType: OracleDbType.Varchar2, direction: ParameterDirection.Output);

            // 受診情報登録用ストアドパッケージの関数呼び出し
            var sql = @"
                begin
                    :ret := consultpackagelukes.updateconsult_o(
                        :rsvno,
                        :ctrptcd,
                        :optcd,
                        :optbranchno,
                        :consults,
                        :ipaddress,
                        :upduser,
                        :ignoreflg,
                        :message
                    );
                end;
            ";

            // PL/SQL文の実行
            connection.Execute(sql, param);

            // 戻り値の取得
            message = param.Get<OracleString>("message").ToString();

            // 戻り値の設定
            return param.Get<OracleDecimal>("ret").ToInt32();
        }

        /// <summary>
        /// 受診情報テーブルの事業部～所属までを、現在の個人テーブル情報で更新する
        /// </summary>
        /// <param name="userId">ユーザID</param>
        /// <param name="startDate">開始受診日</param>
        /// <param name="endDate">終了受診日</param>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="csCd">コースコード</param>
        public void UpdateConsultBsd(string userId, DateTime startDate, DateTime endDate, string orgCd1, string orgCd2, string csCd = null)
        {
            // キー値及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("userid", userId.Trim());
            param.Add("strdate", startDate);
            param.Add("enddate", endDate);
            param.Add("orgcd1", orgCd1.Trim());
            param.Add("orgcd2", orgCd2.Trim());
            if (!string.IsNullOrEmpty(csCd))
            {
                param.Add("cscd", csCd.Trim());
            }

            // 個人情報テーブルの事業部、室部、所属で更新する。
            var sql = @"
                update consult
                set
                    (
                        orgbsdcd
                        , orgroomcd
                        , orgpostcd
                        , upduser
                        , upddate
                    ) = (
                        select
                            orgbsdcd
                            , orgroomcd
                            , orgpostcd
                            , :userid
                            , sysdate
                        from
                            person
                        where
                            person.perid = consult.perid
                            and person.orgcd1 = :orgcd1
                            and person.orgcd2 = :orgcd2
                    )
                where
                    consult.csldate between :strdate and :enddate
                    and consult.orgcd1 = :orgcd1
                    and consult.orgcd2 = :orgcd2
            ";

            // コースの指定があるなら、検索条件追加
            if (!string.IsNullOrEmpty(csCd))
            {
                sql += @"
                    and consult.cscd = :cscd
                ";
            }

            // 個人テーブルの団体コードなどくどい程設定しているが、契約の不整合を最も恐れるため、団体は絶対に合致させる。
            sql += @"
                    and consult.perid in (
                        select distinct
                            consult.perid
                        from
                            person
                            , consult
                        where
                            consult.csldate between :strdate and :enddate
                            and consult.orgcd1 = :orgcd1
                            and consult.orgcd2 = :orgcd2
                            and person.perid = consult.perid
                            and person.orgcd1 = :orgcd1
                            and person.orgcd2 = :orgcd2
                    )
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 判定医コードを更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="doctorCd">判定医コード</param>
        /// <param name="userId">ログインユーザーID</param>
        public void UpdateConsultDoctor(int rsvNo, string doctorCd, string userId)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("doctorcd", doctorCd.Trim());
            param.Add("userid", userId.Trim());

            var sql = @"
                update consult
                set
                    doctorcd = :doctorcd
                    , upddate = sysdate
                    , upduser = :userid
                where
                    rsvno = :rsvno
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 成績書出力情報を更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        public void UpdateConsultReport(int rsvNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 成績書出力日を更新
            var sql = @"
                update consult
                set
                    reportprintdate = sysdate
                where
                    rsvno = :rsvno
                    and reportprintdate is null
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// お連れ様情報の妥当性チェック
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="seq">お連れ様Seq</param>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>エラー値がある場合、エラーメッセージのリストを返す</returns>
        public IList<string> CheckFriends(DateTime cslDate, int seq, int[] rsvNo)
        {
            const string MSG_TARGET = "予約番号：{0}は別のお連れ様情報に登録済みです。";

            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            param.Add("seq", seq);

            // SQL文の編集
            var sql = @"
                select
                    seq
                    , rsvno
                from
                    friends
                where
                    csldate = :csldate
                    and seq != :seq
                    and rsvno in (" + string.Join(",", rsvNo) + @")
                order by
                    rsvno
            ";

            // 重複しているお連れ様情報の取得
            return connection.Query(sql, param).Select(rec =>
            {
                return (string)String.Format(MSG_TARGET, Convert.ToInt32(rec.RSVNO));
            }).ToList();
        }

        /// <summary>
        /// お連れ様情報の削除を行う
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="seq">お連れ様Seq</param>
        public void DeleteFriends(DateTime cslDate, int seq)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            param.Add("seq", seq);

            // お連れ様情報削除
            var sql = @"
                delete friends
                where
                    csldate = :csldate
                    and seq = :seq
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// お連れ様Seqを取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <returns>SeqNo</returns>
        int GetFriendsSeq(DateTime cslDate)
        {
            int seq = 0; // お連れ様Seq

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);

            while (true)
            {
                var sql = @"
                    select
                        /*+ INDEX_DESC(FRIENDS FRIENDS_PKEY) */
                        seq
                        , gettoday.today_date
                    from
                        friends
                        , (select sysdate today_date from dual) gettoday
                    where
                        rownum = 1
                        and csldate = :csldate
                    for update nowait
                ";

                dynamic record = null;

                // 現SEQの最大値を取得する(他で処理中の場合は最大10回までリトライ)
                for (var i = 1; i <= 10; i++)
                {
                    try
                    {
                        record = connection.Query(sql, param).FirstOrDefault();
                    }
                    catch (OracleException ex)
                    {
                        // リソースビジー以外の例外はそのままthrowする
                        if (ex.Number != 54)
                        {
                            throw ex;
                        }

                        // リソースビジーの場合、最大リトライ回数に達していいる場合は例外を発生させる
                        if (i >= 10)
                        {
                            throw new Exception("現在他業務にてお連れ様情報を使用中のため、お連れ様Ｓｅｑ発番処理は行えませんでした。");
                        }
                    }

                    // ちょっとだけ待つ
                    Thread.Sleep(1000);
                }

                // レコードが存在しない場合は初期値を発番
                if (record == null)
                {
                    seq = 1;
                    break;
                }

                // 先頭レコードのＳｅｑ（すなわち現在の最大値）を取得
                int currentMaxSeq = Convert.ToInt32(record.SEQ);

                // インクリメントし新Ｓｅｑを求める
                seq = currentMaxSeq + 1;

                break;
            }

            // 戻り値の設定
            return seq;
        }

        /// <summary>
        /// 来院情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// 受診情報
        /// rsvno 予約番号
        /// cancelflg キャンセルフラグ
        /// csldate 受診日
        /// perid 個人ID
        /// cscd コースコード
        /// orgcd1 受診時団体コード1
        /// orgcd2 受診時団体コード2
        /// rsvgrpcd 予約群コード
        /// rsvdate 予約日
        /// age 受診時年齢
        /// ctrptcd 契約パターンコード
        /// isrsign 保険証記号
        /// isrno 保険証番号
        /// reportaddrdiv 成績書宛先
        /// reportoureng 成績書英文出力
        /// collectticket 利用券回収
        /// issuecslticket 診察券発行
        /// billprint 請求書出力
        /// volunteer ボランティア
        /// volunteername ボランティア名
        /// dayid 当日ID
        /// comedate 来院日時
        /// comeuser 来院処理者
        /// ocrno OCR番号
        /// lockerkey ロッカーキー
        /// birth 生年月日
        /// gender 性別
        /// lastname 姓
        /// firstname 名
        /// lastkname カナ姓
        /// firstkname カナ名
        /// romename ローマ字名
        /// nationcd 国籍コード
        /// nationname 国籍名
        /// compperid 同伴者個人ID
        /// comppername 同伴者個人名
        /// csname コース名
        /// cssname コース略称
        /// orgkname 団体カナ名称
        /// orgname 団体漢字名称
        /// orgsname 団体略称
        /// ticket 利用券
        /// insbring 保険証当日持参
        /// rsvgrpname 予約群名称
        /// rsvgrpstrtime 予約群開始時間
        /// rsvgrpendtime 予約群終了時間
        /// </returns>
        public dynamic SelectWelComeInfo(int rsvNo)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            var sql = @"
                select
                    consult.rsvno
                    , consult.cancelflg
                    , consult.csldate
                    , consult.perid
                    , consult.cscd
                    , consult.orgcd1
                    , consult.orgcd2
                    , consult.rsvgrpcd
                    , consult.rsvdate
                    , consult.age
                    , consult.ctrptcd
                    , consult.isrsign
                    , consult.isrno
                    , consult.reportaddrdiv
                    , consult.reportoureng
                    , consult.collectticket
                    , consult.issuecslticket
                    , consult.billprint
                    , consult.volunteer
                    , consult.volunteername
                    , receipt.dayid
                    , receipt.comedate
                    , receipt.comeuser
                    , receipt.ocrno
                    , receipt.lockerkey
                    , person.birth
                    , person.gender
                    , person.lastname
                    , person.firstname
                    , person.lastkname
                    , person.firstkname
                    , person.romename
                    , person.nationcd
                    , (
                        select
                            free.freefield1
                        from
                            free
                        where
                            person.nationcd = free.freecd
                    ) nationname
                    , person.compperid
                    , (
                        select
                            compper.lastname || '　' || compper.firstname
                        from
                            person compper
                        where
                            compper.perid = person.compperid
                    ) comppername
                    , course_p.csname
                    , course_p.cssname
                    , org.orgkname
                    , org.orgname
                    , org.orgsname
                    , org.ticket
                    , org.insbring
                    , rsvgrp.rsvgrpname
                    , rsvgrp.strtime rsvgrpstrtime
                    , rsvgrp.endtime rsvgrpendtime
                from
                    consult
                    , receipt
                    , person
                    , course_p
                    , org
                    , rsvgrp
                where
                    consult.rsvno = :rsvno
                    and consult.rsvno = receipt.rsvno(+)
                    and consult.perid = person.perid
                    and consult.cscd = course_p.cscd
                    and consult.orgcd1 = org.orgcd1
                    and consult.orgcd2 = org.orgcd2
                    and consult.rsvgrpcd = rsvgrp.rsvgrpcd
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
        /// 検索条件を満たす受診者の一覧を取得する
        /// </summary>
        /// <param name="key">検索キー</param>
        /// <param name="startCslDate">開始受診日</param>
        /// <param name="endCslDate">終了受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="itemCd">依頼項目コード</param>
        /// <param name="entry">結果入力状態("":指定なし、"1":未入力のみ表示、"2":入力済みのみ表示)</param>
        /// <param name="printFields">表示項目</param>
        /// <param name="sortKey">ソートキー</param>
        /// <param name="sortType">ソート順(0:昇順、1:降順)</param>
        /// <param name="startPos">取得開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <param name="rsvStat">予約状態("1":キャンセルのみ、"2":予約のみ、"3":受付のみ)</param>
        /// <param name="rptStat">来院状態("1":未来院、"2":来院済み)</param>
        /// <param name="cslDivCd">受診区分コード</param>
        /// <returns>
        /// 総レコード数と受診情報との組
        /// 受診情報
        /// rsvno 予約番号
        /// cancelflg キャンセルフラグ
        /// csldate 受診日
        /// cscd コースコード
        /// rsvdate 予約日
        /// rsvgrpcd 予約群コード
        /// age 年齢
        /// isrsign 健保記号
        /// isrno 健保番号
        /// rsvstatus 予約状況
        /// cardprintdate 確認はがき出力日
        /// formprintdate 一式書式出力日
        /// perid 個人ID
        /// lastname 姓
        /// firstname 名
        /// lastkname カナ姓
        /// firstkname カナ名
        /// name 氏名
        /// kananame カナ氏名
        /// birth 生年月日
        /// gender 性別
        /// compperid 同伴者個人ID
        /// dayid 当日ID
        /// orgsname 団体略称
        /// orgkname 団体カナ名称
        /// entry 結果入力状態(0:未入力なし、1:未入力あり)
        /// rsvgrpname 予約群名称
        /// hasfriends お連れ様の有無
        /// webcolor webカラー
        /// csname コース名
        /// additems
        ///   adddiv 追加検査区分
        ///   addname 追加検査名
        /// consultitems
        ///   itemcd 依頼項目コード
        ///   requestname 検査項目名
        /// subcourses
        ///   cscd サブコースコード
        ///   webcolor サブコースのwebカラー
        ///   csname サブコース名
        /// </returns>
        public PartialDataSet SelectDailyList(
            string key,
            DateTime? startCslDate,
            DateTime? endCslDate,
            string csCd,
            string orgCd1,
            string orgCd2,
            string grpCd,
            string itemCd,
            string entry,
            string[] printFields,
            int sortKey,
            int sortType,
            int startPos,
            int getCount,
            string rsvStat = null,
            string rptStat = null,
            string cslDivCd = null
        )
        {
            int totalCount = 0; // レコード数
            IList<IDictionary<string, object>> data = null; // 検索データ

            int? csDiv = null;   // コース区分

            bool addCourse = false;         // コースの追加要否
            bool addName = false;           // 氏名の追加要否
            bool addKanaName = false;       // カナ氏名の追加要否
            bool addGender = false;         // 性別の追加要否
            bool addBirth = false;          // 生年月日の追加要否
            bool addAge = false;            // 受診時年齢の追加要否
            bool addOrgSName = false;       // 団体略称の追加要否
            bool addRsvDate = false;        // 予約日の追加要否
            bool addAddItem = false;        // 追加検査の追加要否
            bool addConsultItem = false;    // 受診項目の追加要否
            bool addIsrSign = false;        // 健保記号の追加要否
            bool addIsrNo = false;          // 健保番号の追加要否
            bool addSubCourse = false;      // サブコースの追加要否
            bool addEntry = false;          // 結果入力状態の追加要否
            bool addRsvStatus = false;      // 予約状況の追加要否
            bool addCardPrintDate = false;  // 確認はがき出力日の追加要否
            bool addFormPrintDate = false;  // 一式書式出力日の追加要否
            bool addRsvGrp = false;         // 予約群の追加要否
            bool addHasFriends = false;     // お連れ様有無の追加要否

            // 固定の団体コードを取得
            WebHains.GetOrgCd(OrgCdKey.Person, out string perOrgCd1, out string perOrgCd2);

            // コースコード指定時はコース区分を取得
            if (!string.IsNullOrEmpty(csCd))
            {
                dynamic course = courseDao.SelectCourse(csCd);
                if (course != null)
                {
                    csDiv = Convert.ToInt32(course.CSDIV);
                }
            }

            // 取得フィールド指定状態によるフラグ設定
            foreach (var printField in printFields)
            {
                if (!int.TryParse(printField, out int wkPrintField))
                {
                    continue;
                }

                switch (wkPrintField)
                {
                    case COL_COURSE:
                        addCourse = true;
                        break;
                    case COL_NAME:
                        addName = true;
                        break;
                    case COL_KANANAME:
                        addKanaName = true;
                        break;
                    case COL_GENDER:
                        addGender = true;
                        break;
                    case COL_BIRTH:
                        addBirth = true;
                        break;
                    case COL_AGE:
                        addAge = true;
                        break;
                    case COL_ORGSNAME:
                        addOrgSName = true;
                        break;
                    case COL_RSVDATE:
                        addRsvDate = true;
                        break;
                    case COL_ADDITEM:
                        addAddItem = true;
                        break;
                    case COL_BOTHNAME:
                        addName = true;
                        addKanaName = true;
                        break;
                    case COL_CONSULTITEM:
                        addConsultItem = true;
                        break;
                    case COL_ISRSIGN:
                        addIsrSign = true;
                        break;
                    case COL_ISRNO:
                        addIsrNo = true;
                        break;
                    case COL_SUBCOURSE:
                        addSubCourse = true;
                        break;
                    case COL_ENTRY:
                        addEntry = true;
                        break;
                    case COL_RSVSTATUS:
                        addRsvStatus = true;
                        break;
                    case COL_CARDPRINTDATE:
                        addCardPrintDate = true;
                        break;
                    case COL_FORMPRINTDATE:
                        addFormPrintDate = true;
                        break;
                    case COL_RSVGRP:
                        addRsvGrp = true;
                        break;
                    case COL_HASFRIENDS:
                        addHasFriends = true;
                        break;
                }
            }

            // 受診日の設定
            while (true)
            {
                // 双方とも未指定の場合は何もしない
                if ((startCslDate == null) && (endCslDate == null))
                {
                    break;
                }

                // 一方が未指定の場合、もう一方の値と同値として扱う
                if ((startCslDate != null) && (endCslDate == null))
                {
                    endCslDate = startCslDate;
                    break;
                }

                if ((startCslDate == null) && (endCslDate != null))
                {
                    startCslDate = endCslDate;
                    break;
                }

                // 双方とも指定されている場合、大小逆転時に入れ替えを行う
                if (endCslDate < startCslDate)
                {
                    DateTime wkDate = (DateTime)startCslDate;
                    startCslDate = endCslDate;
                    endCslDate = wkDate;
                }

                break;
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("strcsldate", startCslDate);
            param.Add("endcsldate", endCslDate);
            param.Add("cscd", csCd);
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);
            param.Add("grpcd", grpCd);
            param.Add("itemcd", itemCd);
            param.Add("rsvno", 0);
            param.Add("startpos", (startPos + 1));
            param.Add("endpos", (startPos + getCount));

            param.Add("csldivcd", cslDivCd);

            // (SQLステートメント２)指定予約番号の追加検査情報を「オプション検査」「その他追加項目」「削除項目」の順に取得する
            // (列:ADDDIVの昇順でSORTされることを利用する)
            string sql2 = @"
                select
                    adddiv
                    , addname
            ";

            // オプション検査情報を「2:全員対象」「1:別途条件指定」「0:希望者のみ」の順に取得する
            sql2 += @"
                from
                    (
                        select
                            consult_o.rsvno
                            , 0 adddiv
                            , 0 addorder
                            , consult_o.optcd addcode
                            , consult_o.optbranchno addcode2
                            , ctrpt_opt.optname addname
                        from
                            ctrpt_opt
                            , consult_o
                        where
                            consult_o.ctrptcd = ctrpt_opt.ctrptcd
                            and consult_o.optcd = ctrpt_opt.optcd
                            and consult_o.optbranchno = ctrpt_opt.optbranchno
            ";

            // 追加グループ情報を取得
            // 最終的に「追加グループ」「追加検査項目」「削除グループ」「削除項目」の順に並ぶよう、ADDDIV, ADDORDERを設定
            sql2 += @"
                        union
                        select
                            consult_g.rsvno
                            , decode(consult_g.editflg, 1, 1, 2) adddiv
                            , 0 addorder
                            , consult_g.grpcd addcode
                            , 0 addcode2
                            , grp_p.grpname addname
                        from
                            grp_p
                            , consult_g
                        where
                            consult_g.grpcd = grp_p.grpcd
            ";

            // 追加検査項目情報を取得
            // 最終的に「追加グループ」「追加検査項目」「削除グループ」「削除項目」の順に並ぶよう、ADDDIV, ADDORDERを設定
            sql2 += @"
                        union
                        select
                            consult_i.rsvno
                            , decode(consult_i.editflg, 1, 1, 2) adddiv
                            , 1 addorder
                            , consult_i.itemcd addcode
                            , 0 addcode2
                            , item_p.requestname addname
                        from
                            item_p
                            , consult_i
                        where
                            consult_i.itemcd = item_p.itemcd)
                        where
                            rsvno = :rsvno
            ";

            // (SQLステートメント３)指定予約番号の受診項目を取得する
            string sql3 = @"
                select distinct
                    consultitemlist.itemcd
                    , item_p.requestname
                from
                    item_p
                    , consultitemlist
                where
                    consultitemlist.rsvno = :rsvno
                    and consultitemlist.itemcd = item_p.itemcd
            ";

            // (SQLステートメント４)サブコース用取得用のSQLステートメント編集
            string sql4 = EditSelectSubCourseStatement();

            bool existsRsvNo = false; // 検索キー内に予約番号が存在するか
            bool existsDayId = false; // 検索キー内に当日ＩＤが存在するか
            bool existsOcrNo = false; // 検索キー内にOCR番号が存在するか
            bool existsLockerKey = false; // 検索キー内にロッカー番号が存在するか
            string condition = null; // 条件節

            // 検索キーから条件節に変換
            if (!string.IsNullOrEmpty(key))
            {
                condition = CreateConditionForDailyList(key, out existsRsvNo, out existsDayId, out existsOcrNo, out existsLockerKey, ref param);

                // 条件に当日ＩＤがあり、かつ受診日未指定ならば以後システム日付のみで扱う
                if ((existsDayId || existsOcrNo || existsLockerKey) && (startCslDate == null) && (endCslDate == null))
                {
                    startCslDate = DateTime.Now.Date;
                    endCslDate = DateTime.Now.Date;
                    param["strcsldate"] = startCslDate;
                    param["endcsldate"] = endCslDate;
                }
            }

            string sql = null;

            // (SQLステートメント１)件数取得と実データ取得という２回分のSQL発行
            for (var phase = 0; phase <= 1; phase++)
            {
                switch (phase)
                {
                    case 0:

                        // 件数取得の場合
                        // 検索ベース基本表の件数をとる
                        sql = @"
                            select
                                count(*) cnt
                        ";
                        break;

                    case 1:

                        // 実データ取得の場合
                        // 指定条件を満たす受診情報を取得する
                        sql = @"
                            select
                                seqperconsult.*
                        ";

                        // コース情報が必要な場合は列を追加する
                        if (addCourse)
                        {
                            sql += @"
                                , course_p.webcolor
                                , course_p.csname
                            ";
                        }
                        else
                        {
                            sql += @"
                                , '' webcolor
                                , '' csname
                            ";
                        }

                        // SEQ付き検索ベース基本表を作成
                        sql += @"
                            from
                                (
                                    select
                                        rownum seq
                                        , perconsult.*
                        ";

                        // ソート後の検索ベース基本表を作成
                        sql += @"
                                    from
                                        (
                                            select
                                                *
                        ";

                        break;
                }

                // 検索ベースとなる基本表を作成
                sql += @"
                                            from
                                                (
                                                    select
                                                        consult.rsvno
                                                        , consult.cancelflg
                                                        , consult.csldate
                                                        , consult.cscd
                                                        , consult.rsvdate
                                                        , consult.rsvgrpcd
                                                        , consult.age
                                                        , consult.isrsign
                                                        , consult.isrno
                                                        , consult.rsvstatus
                                                        , consult.cardprintdate
                                                        , consult.formprintdate
                                                        , person.perid
                                                        , person.lastname
                                                        , person.firstname
                                                        , person.lastkname
                                                        , person.firstkname
                                                        , person.lastname||'　'||person.firstname name
                                                        , person.lastkname||'　'||person.firstkname kananame
                                                        , person.birth
                                                        , person.gender
                                                        , person.compperid
                ";

                // 受付情報、団体、事業部、室部、所属は件数取得時には必要ないため、実データ取得時のみ設定
                if (phase == 1)
                {
                    // 受付情報の列を指定
                    sql += @"
                                                        , receipt.dayid
                    ";

                    // 団体略称が必要な場合は列を指定
                    if (addOrgSName)
                    {
                        sql += @"
                                                        , org.orgsname
                                                        , org.orgkname
                        ";
                    }
                    else
                    {
                        sql += @"
                                                        , '' orgsname
                                                        , '' orgkname
                        ";
                    }

                    // 結果入力状態が必要な場合は関数を追加
                    if (addEntry)
                    {
                        sql += @"
                                                        , checkresultpackage.checkexistsnoresult(consult.rsvno) entry
                        ";
                    }
                    else
                    {
                        sql += @"
                                                        , '' entry
                        ";
                    }

                    // 予約群が必要な場合は追加
                    if (addRsvGrp)
                    {
                        sql += @"
                                                        , rsvgrp.rsvgrpname
                        ";
                    }
                    else
                    {
                        sql += @"
                                                        , '' rsvgrpname
                        ";
                    }

                    // お連れ様が必要な場合は追加
                    if (addHasFriends)
                    {
                        sql += @"
                                                        , (
                                                            select
                                                                count(*)
                                                            from
                                                                friends
                                                            where
                                                                rsvno = consult.rsvno
                                                        ) hasfriends
                        ";
                    }
                    else
                    {
                        sql += @"
                                                        ,'' hasfriends
                        ";
                    }
                }

                // 個人、受診情報テーブルは必ず必要
                sql += @"
                                                    from
                                                        receipt
                                                        , person
                                                        , consult
                ";

                // 受付情報、団体、事業部、室部、所属は件数取得時には必要ないため、実データ取得時のみ設定
                if (phase == 1)
                {
                    // 団体略称が必要な場合は団体テーブルを指定
                    if (addOrgSName)
                    {
                        sql += @"
                                                        , org
                        ";
                    }

                    // 予約群が必要な場合は予約群テーブルを指定
                    if (addRsvGrp)
                    {
                        sql += @"
                                                        , rsvgrp
                        ";
                    }

                }

                // 個人情報、受診情報を結合
                if ((startCslDate != null) || (endCslDate != null) || existsRsvNo)
                {
                    sql += @"
                                                    where
                                                        person.perid = consult.perid
                    ";
                }
                else
                {
                    sql += @"
                                                    where
                                                        person.perid = consult.perid(+)
                    ";
                }

                // 受付情報を結合する
                sql += @"
                                                        and consult.rsvno = receipt.rsvno(+)
                                                        and consult.csldate = receipt.csldate(+)
                ";

                // 受付情報、団体、事業部、室部、所属は件数取得時には必要ないため、実データ取得時のみ設定
                if (phase == 1)
                {
                    // 団体略称が必要な場合は受診情報と結合
                    if (addOrgSName)
                    {
                        sql += @"
                                                        and consult.orgcd1 = org.orgcd1(+)
                                                        and consult.orgcd2 = org.orgcd2(+)
                        ";
                    }

                    // 予約群が必要な場合は予約群テーブルと結合
                    if (addRsvGrp)
                    {
                        sql += @"
                                                        and consult.rsvgrpcd = rsvgrp.rsvgrpcd(+)
                        ";
                    }

                }

                // 開始受診日指定時は条件節に加える
                if (startCslDate != null)
                {
                    sql += @"
                                                        and consult.csldate >= :strcsldate
                    ";
                }

                // 終了受診日指定時は条件節に加える
                if (endCslDate != null)
                {
                    sql += @"
                                                        and consult.csldate <= :endcsldate
                    ";
                }

                // 検索キー指定時は条件節に加える
                if (!string.IsNullOrEmpty(condition))
                {
                    sql += @"
                                                        and " + condition + @"
                    ";
                }

                // コースコード指定時の条件節追加
                if (!string.IsNullOrEmpty(csCd))
                {
                    // コース区分による処理振り分け
                    switch (csDiv)
                    {
                        case 0:
                        case 1:

                            // 受診情報のコースとして存在可能なメインコースの場合
                            // 受診情報による絞込みを行う
                            sql += @"
                                                        and consult.cscd = :cscd
                            ";

                            break;

                        case 2:

                            // 受診情報のコースとして存在しないメインコースの場合
                            // 受診オプションのメインコースとして存在するかを検索
                            sql += @"
                                                        and exists (
                                                            select
                                                                consult_o.rsvno
                                                            from
                                                                course_p
                                                                , ctrpt_opt
                                                                , consult_o
                                                            where
                                                                consult_o.rsvno = consult.rsvno
                                                                and consult_o.ctrptcd = ctrpt_opt.ctrptcd
                                                                and consult_o.optcd = ctrpt_opt.optcd
                                                                and consult_o.optbranchno = ctrpt_opt.optbranchno
                                                                and ctrpt_opt.cscd = course_p.cscd
                                                                and course_p.maincscd = :cscd
                                                        )
                            ";

                            break;

                        case 3:

                            // サブコースの場合
                            // 指定サブコースを受診するか検索
                            sql += @"
                                                        and consultpackagelukes.existssubcourse(consult.rsvno, :cscd) = 1
                            ";

                            break;
                    }
                }

                // 団体コード指定時は条件節に加える
                if (!string.IsNullOrEmpty(orgCd1) && !string.IsNullOrEmpty(orgCd2))
                {
                    sql += @"
                                                        and consult.orgcd1 = :orgcd1
                                                        and consult.orgcd2 = :orgcd2
                    ";
                }

                // グループコード指定時は条件節に加える
                if (!string.IsNullOrEmpty(grpCd))
                {
                    sql += @"
                                                        and consultpackagelukes.existsitemingroup(consult.rsvno, :grpcd) = 1
                    ";
                }

                // 検査項目コード指定時は条件節に加える
                if (!string.IsNullOrEmpty(itemCd))
                {
                    sql += @"
                                                        and consultpackagelukes.existsitem(consult.rsvno, :itemcd) = 1
                    ";
                }

                switch (rsvStat)
                {
                    case "1":

                        // キャンセルのみ
                        sql += @"
                                                        and consult.cancelflg != " + (int)ConsultCancel.Used + @"
                        ";

                        break;

                    case "2":

                        // 予約のみ
                        sql += @"                   and consult.cancelflg = " + (int)ConsultCancel.Used + @"
                                                        and receipt.rsvno is null
                        ";

                        break;

                    case "3":

                        // 受付のみ
                        sql += @"
                                                        and receipt.rsvno is not null
                        ";

                        break;
                }

                switch (rptStat)
                {
                    case "1":

                        // 未来院
                        sql += @"                   and consult.rsvno is not null
                                                        and receipt.comedate is null
                        ";

                        break;

                    case "2":

                        // 来院済み
                        sql += @"
                                                        and receipt.comedate is not null
                        ";

                        break;
                }

                if (!string.IsNullOrEmpty(cslDivCd))
                {
                    sql += @"
                                                        and consult.csldivcd =  :csldivcd
                    ";
                }

                // 結果入力状態指定時は条件節に加える
                if (!string.IsNullOrEmpty(entry))
                {
                    sql += @"
                                                        and checkresultpackage.checkexistsnoresult(consult.rsvno) = " + (entry.Equals("1"), "1", "0") + @"
                    ";
                }

                // 検索ベース基本表の副問い合わせ終了
                sql += @"
                                                )
                ";

                // 件数取得時はここまでしか必要ないため、以降の処理は実データ取得時のみ行う
                if (phase == 1)
                {
                    // ソート順を追加
                    sql += @"
                                            " + EditSortOrder(sortKey, sortType, printFields) + @"
                    ";

                    // ソート後の検索ベース基本表を作成
                    sql += @"
                                        ) perconsult
                    ";

                    // SEQ付き検索ベース基本表の副問い合わせ終了
                    sql += @"
                                ) seqperconsult
                    ";

                    // コース情報が必要な場合はコーステーブルを指定
                    if (addCourse)
                    {
                        sql += @"
                                , course_p
                        ";
                    }

                    sql += @"
                            where
                                1 = 1
                    ";

                    // 取得開始位置が必要な場合は指定する
                    if (startPos > 0)
                    {
                        sql += @"
                                and seqperconsult.seq >= :startpos
                        ";
                    }

                    // 取得件数が必要な場合は指定する
                    if (getCount > 0)
                    {
                        sql += @"
                                and seqperconsult.seq <= :endpos
                        ";
                    }

                    // コース情報が必要な場合は結合する
                    if (addCourse)
                    {
                        sql += @"
                                and seqperconsult.cscd = course_p.cscd(+)
                        ";
                    }

                    sql += @"
                            order by seq
                    ";
                }

                // 受診情報の取得
                var query = connection.Query(sql, param);

                while (true)
                {
                    // 件数の取得処理
                    if (phase == 0)
                    {
                        try {
                            totalCount = (int)(query.FirstOrDefault().CNT);
                        }
                        catch  {
                            totalCount = 0;
                        }
                        break;
                    }

                    // リスト形式で格納する
                    data = query.Select(row =>
                    {
                        IDictionary<string, object> rec = new Dictionary<string, object>();

                        // ディクショナリへ追加
                        rec.Add("rsvno", row.RSVNO);
                        rec.Add("cancelflg", row.CANCELFLG);
                        rec.Add("csldate", row.CSLDATE);
                        rec.Add("perid", row.PERID);
                        rec.Add("dayid", (row.DAYID != null) ? Convert.ToInt32(row.DAYID).ToString("0000") : null);
                        rec.Add("compperid", row.COMPPERID);

                        // 以下はフィールド指定状態による配列追加処理

                        // 予約日
                        if (addRsvDate)
                        {
                            rec.Add("rsvdate", row.RSVDATE);
                        }

                        // 受診時年齢
                        if (addAge)
                        {
                            rec.Add("age", (row.AGE != null) ? Convert.ToDouble(row.AGE).ToString("0.00") : null);
                        }

                        // コース
                        if (addCourse)
                        {
                            rec.Add("webcolor", row.WEBCOLOR);
                            rec.Add("csname", row.CSNAME);
                        }

                        // 氏名
                        if (addName)
                        {
                            rec.Add("name", (Convert.ToString(row.LASTNAME) + "　" + Convert.ToString(row.FIRSTNAME)).Trim());
                        }

                        // カナ氏名
                        if (addKanaName)
                        {
                            rec.Add("kananame", (Convert.ToString(row.LASTKNAME) + "　" + Convert.ToString(row.FIRSTKNAME)).Trim());
                        }

                        // 生年月日
                        if (addBirth)
                        {
                            rec.Add("birth", row.BIRTH);
                        }

                        // 性別
                        if (addGender)
                        {
                            rec.Add("gender", row.GENDER);
                        }

                        // 団体略称
                        if (addOrgSName)
                        {
                            rec.Add("orgsname", row.ORGSNAME);
                        }

                        // 健保記号
                        if (addIsrSign)
                        {
                            rec.Add("isrsign", row.ISRSIGN);
                        }

                        // 健保番号
                        if (addIsrNo)
                        {
                            rec.Add("isrno", row.ISRNO);
                        }

                        // 結果入力状態
                        if (addEntry)
                        {
                            rec.Add("entry", row.ENTRY);
                        }

                        // 予約状況
                        if (addRsvStatus)
                        {
                            rec.Add("rsvstatus", row.RSVSTATUS);
                        }

                        // 確認はがき出力日
                        if (addCardPrintDate)
                        {
                            rec.Add("cardprintdate", row.CARDPRINTDATE);
                        }

                        // 一式書式出力日
                        if (addFormPrintDate)
                        {
                            rec.Add("formprintdate", row.FORMPRINTDATE);
                        }

                        // 予約群
                        if (addRsvGrp)
                        {
                            rec.Add("rsvgrpname", row.RSVGRPNAME);
                        }

                        // お連れ様有無
                        if (addHasFriends)
                        {
                            rec.Add("hasfriends", row.HASFRIENDS);
                        }

                        int.TryParse(Convert.ToString(row.RSVNO), out int wkRsvNo);

                        // 追加検査
                        if (addAddItem)
                        {
                            rec.Add("additems", (wkRsvNo != 0) ? connection.Query(sql2, new { rsvno = wkRsvNo }).ToList() : null);
                        }

                        // 受診項目
                        if (addConsultItem)
                        {
                            rec.Add("consultitems", (wkRsvNo != 0) ? connection.Query(sql3, new { rsvno = wkRsvNo }).ToList() : null);
                        }

                        // サブコース
                        if (addSubCourse)
                        {
                            rec.Add("subcourses", (wkRsvNo != 0) ? connection.Query(sql4, new { rsvno = wkRsvNo }).ToList() : null);
                        }

                        return rec;
                    }).ToList();

                    break;
                }

                // 件数取得にて０件の場合は処理を終了する
                if ((phase == 0) && (totalCount == 0))
                {
                    break;
                }

            }

            // 取得件数分のデータと全検索件数の組を返す
            return new PartialDataSet(totalCount, data);
        }

        /// <summary>
        /// お連れ様情報を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// お連れ様情報のリスト
        /// csldate 受診日
        /// seq お連れ様SEQ
        /// rsvno 予約番号
        /// samegrp1 面接同時受診1
        /// samegrp2 面接同時受診2
        /// samegrp3 面接同時受診3
        /// perid 個人ID
        /// cscd コースコード
        /// csname コース名
        /// orgcd1 団体コード1
        /// orgcd2 団体コード2
        /// orgname 団体名称
        /// orgsname 団体略称
        /// lastname 姓
        /// firstname 名
        /// lastkname カナ姓
        /// firstkname カナ名
        /// compperid 同伴者個人ID
        /// dayid 当日ｉｄ
        /// rsvgrpname 予約群名称
        /// cancelflg キャンセルフラグ
        /// rsvgrpcd 予約群コード
        /// </returns>
        public IList<dynamic> SelectFriends(DateTime cslDate, int? rsvNo = null)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            if (rsvNo != null)
            {
                param.Add("rsvno", rsvNo);
            }

            // 検索条件を満たすお連れ様情報と一致する受診者情報を取得する
            var sql = @"
                select
                    friendslist.csldate
                    , friendslist.seq
                    , friendslist.rsvno
                    , friends.samegrp1
                    , friends.samegrp2
                    , friends.samegrp3
                    , consult.perid
                    , consult.cscd
                    , course_p.csname
                    , consult.orgcd1
                    , consult.orgcd2
                    , org.orgname
                    , org.orgsname
                    , person.lastname
                    , person.firstname
                    , person.lastkname
                    , person.firstkname
                    , person.compperid
                    , receipt.dayid
                    , rsvgrp.rsvgrpname
                    , consult.cancelflg
                    , consult.rsvgrpcd
            ";

            // CONSULTがFULL SCANになるのでまず内部ビューで(アスタリスク指定で一寸手抜き)
            sql += @"
                from
                    friends
                    , (select * from consult where csldate = :csldate) consult
                    , course_p
                    , org
                    , person
                    , receipt
                    , rsvgrp
            ";

            // 予約番号を指定？
            if (rsvNo != null)
            {
                // お連れ様情報を取得する
                //    指定した予約番号がお連れ様情報になくても受診者情報は取得する(このときSEQは0となる)
                //    指定した予約番号が先頭になるようにSORTNOをつける
                sql += @"
                    , (
                        select
                            csldate
                            , max(seq) seq
                            , rsvno
                            , decode(rsvno, to_number(:rsvno), 0, 1) sortno
                        from
                            (
                                select
                                    :csldate csldate
                                    , to_number(0) seq
                                    , to_number(:rsvno) rsvno
                                from
                                    dual
                                union
                                select
                                    csldate
                                    , seq
                                    , rsvno
                                from
                                    friends
                                where
                                    csldate = :csldate
                                    and seq = (
                                        select
                                            seq
                                        from
                                            friends
                                        where
                                            csldate = :csldate
                                            and rsvno = :rsvno
                                    )
                            )
                        group by
                            csldate
                            , rsvno
                    ) friendslist
                ";
            }
            else
            {
                // お連れ様情報を取得する
                sql += @"
                    , (
                        select
                            csldate
                            , seq
                            , rsvno
                        from
                            friends
                        where
                            csldate = :csldate
                    ) friendslist
                ";
            }

            sql += @"
                where
                    friendslist.csldate = friends.csldate(+)
                    and friendslist.seq = friends.seq(+)
                    and friendslist.rsvno = friends.rsvno(+)
                    and friendslist.rsvno = consult.rsvno
                    and consult.cscd = course_p.cscd
                    and consult.orgcd1 = org.orgcd1
                    and consult.orgcd2 = org.orgcd2
                    and consult.perid = person.perid
                    and consult.rsvno = receipt.rsvno(+)
                    and consult.csldate = receipt.csldate(+)
                    and consult.rsvgrpcd = rsvgrp.rsvgrpcd
            ";

            // 予約番号を指定？
            if (rsvNo != null)
            {
                sql += @"
                order by
                    friendslist.csldate
                    , friendslist.seq
                    , friendslist.sortno
                    , friendslist.rsvno
                ";
            }
            else
            {
                sql += @"
                order by
                    friendslist.csldate
                    , friendslist.seq
                    , friendslist.rsvno
                ";
            }

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// お連れ様情報テーブルを更新する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="seq">お連れ様SEQ</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="sameGrp1">面接同時受診1</param>
        /// <param name="sameGrp2">面接同時受診2</param>
        /// <param name="sameGrp3">面接同時受診3</param>
        /// <param name="message">メッセージ</param>
        /// <param name="perId">個人ID(同伴者設定用)</param>
        /// <param name="compPerId">同伴者個人ID(同伴者設定用)</param>
        public void UpdateFriends(
            DateTime cslDate,
            int seq,
            int[] rsvNo,
            int?[] sameGrp1,
            int?[] sameGrp2,
            int?[] sameGrp3,
            ref IList<string> message,
            string[] perId = null,
            string[] compPerId = null
        )
        {
            // お連れ様情報の妥当性チェック
            message = CheckFriends(cslDate, seq, rsvNo);
            if (message.Count > 0)
            {
                return;
            }

            if (seq == 0)
            {
                // 新規登録のときはお連れ様Seq発番処理
                seq = GetFriendsSeq(cslDate);
            }
            else
            {
                // キー値の設定
                var param = new Dictionary<string, object>();
                param.Add("csldate", cslDate);
                param.Add("seq", seq);

                // 指定されたお連れ様情報を一度削除する
                var sql = @"
                    delete friends
                    where
                        csldate = :csldate
                        and seq = :seq
                ";

                connection.Execute(sql, param);
            }

            if (rsvNo.Length > 0)
            {
                // キー及び更新値の設定
                List<Dictionary<string, object>> param = new List<Dictionary<string, object>>();
                param = rsvNo.Select((value, index) =>
                    {
                        return new Dictionary<string, object>()
                        {
                            { "csldate", cslDate },
                            { "seq", seq },
                            { "rsvno", value },
                            { "samegrp1", sameGrp1[index]?.ToString() },
                            { "samegrp2", sameGrp2[index]?.ToString() },
                            { "samegrp3", sameGrp3[index]?.ToString() },
                        };
                    }).ToList();

                // お連れ様情報の更新
                var sql = @"
                    insert
                    into friends
                    values (
                        :csldate
                        , :seq
                        , :rsvno
                        , :samegrp1
                        , :samegrp2
                        , :samegrp3
                    )
                ";

                connection.Execute(sql, param);

            }

            if ((perId != null) && (perId.Length > 0))
            {
                List<Dictionary<string, object>> param = new List<Dictionary<string, object>>();
                param = perId.Select((value, index) =>
                {
                    return new Dictionary<string, object>()
                        {
                            { "perid", value },
                            { "compperid", compPerId[index] },
                        };
                }).ToList();


                // 同伴者のクリア(同伴者の付け替えがあったときのため、一旦クリアしてから更新する)
                var sql = @"
                    update person
                    set
                        compperid = ''
                    where
                        perid in (
                            select
                                perid
                            from
                                (
                                    select
                                        to_char(:perid) perid
                                    from
                                        dual
                                    union
                                    select
                                        compperid
                                    from
                                        person
                                    where
                                        perid = :perid
                                        and compperid is not null
                                )
                        )
                ";

                connection.Execute(sql, param);

                // 同伴者の更新
                sql = @"
                    update person
                    set
                        compperid = :compperid
                    where
                        perid = :perid
                ";

                connection.Execute(sql, param);
            }
        }

        /// <summary>
        /// 来院情報を更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="mode">処理モード(0:全て, 1:当日ID, 2:来院, 3:OCR番号, 4:ロッカーキー)</param>
        /// <param name="updUser">更新者</param>
        /// <param name="dayId">当日ID</param>
        /// <param name="visitStatus">来院制御ストアドのエラーコード</param>
        /// <param name="message">エラーメッセージ</param>
        /// <param name="welCome">来院(0:無処理, 1:来院状態にする, 2:来院状態を解除する)</param>
        /// <param name="ocrNo">OCR番号</param>
        /// <param name="lockerKey">ロッカーキー</param>
        /// <param name="force">強制来院取消フラグ</param>
        /// <returns>true:正常終了、false:異常終了</returns>
        public bool UpdateWelComeInfo(
            int rsvNo,
            int mode,
            string updUser,
            int? dayId,
            out int? visitStatus,
            out string message,
            int? welCome = null,
            string ocrNo = null,
            string lockerKey = null,
            string force = null
        )
        {
            string stmtSet = null;           // SQLステートメント(SET部分)

            // 初期処理
            visitStatus = null;
            message = null;

            // キー値及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("comeuser", updUser.Trim());

            // 現在の受付情報を読み、現在の来院日時を取得。かつレコードロック
            dynamic receipt = SelectReceipt(rsvNo, true);
            if (receipt == null)
            {
                throw new Exception("この受診者は受付されていません。");
            }

            DateTime? beforeComeDate = (receipt.COMEDATE != null) ? DateTime.Parse(Convert.ToString(receipt.COMEDATE)) : null;

            // 当日ID
            if ((mode == 0) || (mode == 1))
            {
                if (dayId != null)
                {
                    param.Add("dayid", dayId);
                }
            }

            // 来院
            if ((mode == 0) || (mode == 2))
            {
                switch (welCome)
                {
                    case 1:
                        // 来院状態にする
                        stmtSet += @"
                            " + (!string.IsNullOrEmpty(stmtSet) ? ", " : "") + @"comedate = sysdate
                            , comeuser = :comeuser
                        ";
                        break;
                    case 2:
                        // 来院状態を解除する
                        stmtSet += @"
                            " + (!string.IsNullOrEmpty(stmtSet) ? ", " : "") + @"comedate = null
                            , comeuser = null
                        ";
                        break;
                }
            }

            // OCR番号
            if ((mode == 0) || (mode == 3))
            {
                if (!string.IsNullOrEmpty(ocrNo))
                {
                    param.Add("ocrno", ocrNo.Trim());

                    stmtSet += @"
                        " + (!string.IsNullOrEmpty(stmtSet) ? ", " : "") + @"ocrno = :ocrno
                    ";
                }
                else
                {
                    stmtSet += @"
                        " + (!string.IsNullOrEmpty(stmtSet) ? ", " : "") + @"ocrno = null
                    ";
                }
            }

            // ロッカーキー
            if ((mode == 0) || (mode == 4))
            {
                if (!string.IsNullOrEmpty(lockerKey))
                {
                    param.Add("lockerkey", lockerKey.Trim());

                    stmtSet += @"
                        " + (!string.IsNullOrEmpty(stmtSet) ? ", " : "") + @"lockerkey = :lockerkey
                    ";
                }
                else
                {
                    stmtSet += @"
                        " + (!string.IsNullOrEmpty(stmtSet) ? ", " : "") + @"lockerkey = null
                    ";
                }
            }

            // 更新するものあり？
            if (!string.IsNullOrEmpty(stmtSet))
            {
                // 来院情報を更新する
                var sql = @"
                    update receipt
                    set" + stmtSet + @"
                    where
                        rsvno = :rsvno
                ";

                connection.Execute(sql, param);
            }

            // 処理後の受付情報を読み、来院日時を取得(この時点でレコードが消失することはない)
            receipt = SelectReceipt(rsvNo);
            DateTime? afterComeDate = (receipt.COMEDATE != null) ? DateTime.Parse(Convert.ToString(receipt.COMEDATE)) : null;

            // 処理前後で来院状態に変更があった場合はジャーナル情報等の制御を行う

            int visitMode = 0; // 来院制御モード(0:何もしない、1:来院、2:来院解除)
            DateTime? comeDate = null; // 来院日時

            // 処理前後の来院日時を比較し、制御モードを決定する
            if (beforeComeDate == null)
            {
                if (afterComeDate != null)
                {
                    visitMode = 1;
                    comeDate = afterComeDate;
                }
            }
            else
            {
                if (afterComeDate == null)
                {
                    visitMode = 2;
                    comeDate = beforeComeDate;
                }
            }

            // 処理前後で来院状態に変更があった場合はジャーナル情報等の制御を行う
            if (visitMode > 0)
            {
                // ジャーナル制御
                visitStatus = orderJnlDao.VisitControl(rsvNo, visitMode, (DateTime)comeDate, out string wkMessage, force);

                if (visitStatus <= 0)
                {
                    // メッセージを設定
                    message = wkMessage;

                    // エラー時はトランザクションをアボートに設定
                    //mobjContext.SetAbort;

                    // 戻り値の設定
                    return false;
                }
            }

            // トランザクションをコミット
            //mobjContext.SetComplete;

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// 成績書発送日更新
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="mode">0:発送日時更新、1:発送日時クリア</param>
        /// <returns>
        /// 1: 正常終了
        /// 0: 更新対象データなし
        /// -1: 更新対象データなし
        /// </returns>
        public int UpdateReportSendDate(int rsvNo, int mode)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 成績書発送日の更新
            if (mode == 1)
            {
                // 発送日クリアモード
                sql = @"
                    update consult
                    set
                        reportsenddate = ''
                    where
                        rsvno = :rsvno
                ";
            }
            else
            {
                // 発送日更新モード
                sql = @"
                    update consult
                    set
                        reportsenddate = sysdate
                    where
                        rsvno = :rsvno
                ";
            }

            int ret = connection.Execute(sql, param);

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 検索条件を満たす成績書作成情報の一覧を取得する
        /// </summary>
        /// <param name="key">検索キー</param>
        /// <param name="startCslDate">検索条件受診日（開始）</param>
        /// <param name="endCslDate">検索条件受診日（終了）</param>
        /// <param name="searchOrg1">検索条件団体コード1</param>
        /// <param name="searchOrg2">検索条件団体コード2</param>
        /// <param name="startPos">取得開始位置</param>
        /// <param name="pageMaxLine">1ページ表示最大行（0:最大行指定無し）</param>
        /// <returns>
        /// 総レコード数と成績書作成情報リストとの組
        /// 成績書作成情報のリスト
        /// rsvno 予約番号
        /// csldate 受診日
        /// perid 個人ID
        /// lastname 姓
        /// firstname 名
        /// lastkname カナ姓
        /// firstkname カナ名
        /// orgcd1 団体コード1
        /// orgcd2 団体コード2
        /// orgsname 団体略称
        /// dayid 当日ｉｄ
        /// reportsenddate 発送確認日時
        /// pubnote 成績書コメント
        /// </returns>
        public PartialDataSet SelectInqReportsInfoList(
            string key,
            DateTime? startCslDate,
            DateTime? endCslDate,
            string searchOrg1,
            string searchOrg2,
            int startPos = 1,
            int pageMaxLine = 0
        )
        {
            int totalCount; // 全件数

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("startpos", startPos);
            if (pageMaxLine > 0)
            {
                param.Add("endpos", startPos + pageMaxLine - 1);
            }

            // 検索条件を満たす成績書作成情報件数を取得
            string stmtCount = @"
                select
                    count(*) cnt
            ";

            // 検索条件を満たす成績書作成情報を取得
            string stmtData = @"
                select
                    finallistview.rsvno
                    , finallistview.csldate
                    , finallistview.perid
                    , finallistview.lastname
                    , finallistview.firstname
                    , finallistview.lastkname
                    , finallistview.firstkname
                    , finallistview.orgcd1
                    , finallistview.orgcd2
                    , finallistview.orgsname
                    , finallistview.dayid
                    , finallistview.reportsenddate
                    , finallistview.pubnote
            ";

            stmtData += @"
                from
                    (
                        select
                            rownum seq
                            , baseview.*
                        from
                            (
                                select
                                    consult.rsvno
                                    , consult.csldate
                                    , consult.perid
                                    , person.lastname
                                    , person.firstname
                                    , person.lastkname
                                    , person.firstkname
                                    , org.orgcd1
                                    , org.orgcd2
                                    , org.orgsname
                                    , receipt.dayid
                                    , consult.reportsenddate
                                    , pubnotepackage.editorgpubnote(consult.orgcd1, consult.orgcd2) pubnote
            ";

            string sql = @"
                                from
                                    consult
                                    , receipt
                                    , person
                                    , org
            ";

            // 受診日範囲指定
            if ((startCslDate != null) && (endCslDate != null))
            {
                param.Add("scsldate", startCslDate);
                param.Add("ecsldate", endCslDate);

                sql += @"
                                where
                                    consult.csldate between :scsldate and :ecsldate
                ";
            }
            else
            {
                // 受診日開始日のみ指定
                if ((startCslDate != null) && (endCslDate == null))
                {
                    param.Add("scsldate", startCslDate);

                    sql += @"
                                where
                                    consult.csldate = :scsldate
                    ";
                }
            }

            bool existsRsvNo = false;
            bool existsDayId = false;
            bool existsOcrNo = false;         // 検索キー内にOCR番号が存在するか
            bool existsLockerKey = false;    // 検索キー内にロッカー番号が存在するか

            // 検索キー 指定？
            string sql2 = null;
            if (!string.IsNullOrEmpty(key))
            {
                sql2 = CreateConditionForDailyList(key, out existsRsvNo, out existsDayId, out existsOcrNo, out existsLockerKey, ref param);

                sql += @"
                                    and " + sql2 + @"
                ";
            }

            // 団体コード指定
            if (!string.IsNullOrEmpty(searchOrg1) && !string.IsNullOrEmpty(searchOrg2))
            {
                param.Add("orgcd1", searchOrg1.Trim());
                param.Add("orgcd2", searchOrg2.Trim());

                sql += @"
                                    and consult.orgcd1 = :orgcd1
                                    and consult.orgcd2 = :orgcd2
                ";
            }

            sql += @"
                                    and consult.rsvno  = receipt.rsvno
                                    and consult.perid  = person.perid
                                    and consult.orgcd1 = org.orgcd1
                                    and consult.orgcd2 = org.orgcd2
            ";

            // 全件数取得
            stmtCount = stmtCount + sql;

            dynamic rec = connection.Query(stmtCount, param).FirstOrDefault();
            totalCount = int.Parse(rec.CNT);

            // 並べ替え
            sql += @"
                                order by
                                    consult.csldate
                                    , receipt.dayid
                            ) baseview
                    ) finallistview
            ";

            // 取得件数で絞込み
            sql += @"
                where
                    finallistview.seq >= :startpos
            ";

            if (pageMaxLine > 0)
            {
                sql += @"
                    and finallistview.seq <= :endpos
                ";
            }

            // データ取得
            stmtData = stmtData + sql;
            var data = connection.Query(stmtCount, param).ToList();

            // 戻り値の設定
            return new PartialDataSet(totalCount, data);
        }

        /// <summary>
        /// 年度内2回以上の予約をチェックする団体（対象外）の取得
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="sDate1">日付(自)</param>
        /// <param name="sDate2">日付(至)</param>
        /// <returns>データが存在する場合にtrueを返す</returns>
        bool RsvChkOrg(string orgCd1, string orgCd2, out string sDate1, out string sDate2)
        {
            sDate1 = null;
            sDate2 = null;

            bool bolRet;

            const string FREECD_RSV2ORG = "RSV2ORG%";
            const string FREECLASSCD_RS2 = "RS2";

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);
            param.Add("freecd", FREECD_RSV2ORG);
            param.Add("freeclasscd", FREECLASSCD_RS2);

            var sql = @"
                select
                    freefield1
                    , freefield2
                    , freefield3
                    , freefield4
                from
                    free
                where
                    freecd like :freecd
                    and freeclasscd = :freeclasscd
                    and freefield1 = :orgcd1
                    and freefield2 = :orgcd2
            ";

            dynamic data = connection.Query(sql, param).FirstOrDefault();

            // 検索レコードが存在する場合
            if (data != null)
            {
                if (data.FREEFIELD3 != null)
                {
                    sDate1 = Convert.ToString(data.FREEFIELD3);
                }
                if (data.FREEFIELD4 != null)
                {
                    sDate2 = Convert.ToString(data.FREEFIELD4);
                }
                bolRet = true;
            }
            else
            {
                bolRet = false;
            }

            // 戻り値の設定
            return bolRet;
        }

        /// <summary>
        /// 年度内に２回目予約を行う場合、ワーニング対応
        /// </summary>
        /// <param name="perId">個人ID</param>
        /// <param name="cslDate">保存したい受診日</param>
        /// <param name="csCd">保存したいコースコード</param>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="rsvNo">保存対象となる受診情報の予約番号</param>
        /// <param name="fRsv"></param>
        /// <returns>ワーニング対象となる受診情報存在時、メッセージを返す</returns>
        public string CheckConsult_Ctr(
            string perId,
            DateTime cslDate,
            string csCd,
            string orgCd1,
            string orgCd2,
            int? rsvNo = null,
            int fRsv = 0
        )
        {
            string message = null;

            DateTime ctrStartDate;
            DateTime ctrEndDate;
            int intNowYear;
            int intCslYear;

            if (fRsv == 1)
            {
                return null;
            }

            // 対象外団体チェック
            if (!RsvChkOrg(orgCd1, orgCd2, out string wkDate1, out string wkDate2))
            {
                return null;
            }

            if (rsvNo > 0)
            {
                // 受診情報を読み、現在の受診日を取得
                dynamic consult = SelectConsult((int)rsvNo);
                if (consult == null)
                {
                    return null;
                }

                // 受診日に変更がない場合は対象外
                if (DateTime.Parse(Convert.ToString(consult.CSLDATE)) == cslDate)
                {
                    return null;
                }
            }

            bool bolCS = false;
            string[] FF = GetFreeCd("RSV2CSCD01");
            if (FF != null)
            {
                for (var i = 0; i < FF.Length; i++)
                {
                    if (csCd.Trim().Equals(FF[i].Trim()))
                    {
                        bolCS = true;
                        break;
                    }
                }

                if (!bolCS)
                {
                    return null;
                }
            }
            else
            {
                // 基本対象コース設定
                if (!(csCd.Trim().Equals("100") || csCd.Trim().Equals("110")))
                {
                    return null;
                }

                FF = new string[] { "100", "110" };
            }

            intNowYear = DateTime.Now.Year;
            intCslYear = cslDate.Year;

            if (string.IsNullOrEmpty(wkDate1))
            {
                wkDate1 = "04/01";
            }
            if (string.IsNullOrEmpty(wkDate2))
            {
                wkDate2 = "03/31";
            }

            if (cslDate.Month > int.Parse(wkDate2.Substring(0, 2)))
            {
                wkDate1 = intCslYear.ToString() + "/" + wkDate1;
                wkDate2 = (intCslYear + 1).ToString() + "/" + wkDate2;
            }
            else
            {
                wkDate1 = (intCslYear - 1).ToString() + "/" + wkDate1;
                wkDate2 = intCslYear.ToString() + "/" + wkDate2;
            }

            ctrStartDate = DateTime.Parse(wkDate1);
            ctrEndDate = DateTime.Parse(wkDate2);

            string chkCsCd = null;
            for (var i = 0; i < FF.Length; i++)
            {
                if (!string.IsNullOrEmpty(FF[i].Trim()))
                {
                    if (!string.IsNullOrEmpty(chkCsCd))
                    {
                        chkCsCd = chkCsCd + ",";
                    }
                    chkCsCd = chkCsCd + FF[i];
                }
            }

            dynamic data = SelectConsultFromCslDate(ctrStartDate, ctrEndDate, perId, chkCsCd, (int)rsvNo);
            if (data != null)
            {
                message = DateTime.Parse(Convert.ToString(data.CSLDATE)).ToString("yyyy年M月d日") + "にこの受診者の受診情報がすでに存在します。";
            }

            return message;
        }

        /// <summary>
        /// 契約期間内に受診情報をチェックする
        /// </summary>
        /// <param name="strCslDate">開始受診日</param>
        /// <param name="endCslDate">終了受診日</param>
        /// <param name="perId">個人ID</param>
        /// <param name="chkCsCd">コースコード</param>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>条件を満たす受診情報レコード</returns>
        dynamic SelectConsultFromCslDate(DateTime strCslDate, DateTime endCslDate, string perId, string chkCsCd = null, int? rsvNo = null)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("strcsldate", strCslDate);
            param.Add("endcsldate", endCslDate);
            param.Add("perid", perId);
            param.Add("cscd", chkCsCd);
            param.Add("rsvno", rsvNo);

            var sql = @"
                select
                    a.rsvno
                    , a.csldate
                    , a.ctrptcd
                    , a.cscd
                    , a.perid
                    , a.orgcd1
                    , a.orgcd2
                from
                    consult a
                where
                    a.csldate >= :strcsldate
                    and a.csldate <= :endcsldate
                    and a.perid = :perid
                    and a.cancelflg = 0
                    and a.cscd in (" + chkCsCd + @")
            ";

            if (rsvNo != null)
            {
                sql += @"
                and a.rsvno != :rsvno
                ";
            }

            sql += @"
                order by
                    a.csldate desc
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 汎用レコードの取得
        /// </summary>
        /// <param name="pFreeCd">汎用コード</param>
        /// <returns>汎用フィールド値の配列</returns>
        string[] GetFreeCd(string pFreeCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("freecd", pFreeCd);

            var sql = @"
                select
                    freefield1
                    , freefield2
                    , freefield3
                    , freefield4
                    , freefield5
                    , freefield6
                    , freefield7
                from
                    free
                where
                    freecd = :freecd
            ";

            dynamic data = connection.Query(sql, param).FirstOrDefault();

            // 検索レコードが存在する場合
            if (data != null)
            {
                var FF = new string[]
                {
                    Convert.ToString(data.FREEFIELD1),
                    Convert.ToString(data.FREEFIELD2),
                    Convert.ToString(data.FREEFIELD3),
                    Convert.ToString(data.FREEFIELD4),
                    Convert.ToString(data.FREEFIELD5),
                    Convert.ToString(data.FREEFIELD6),
                    Convert.ToString(data.FREEFIELD7)
                };

                return FF;
            }

            return null;
        }

        /// <summary>
        /// 新規保存時の入力チェック
        /// </summary>
        /// <param name="values">入力値</param>
        /// <returns>エラーメッセージ</returns>
        public List<string> ValidateConsult(InsertConsultationModel values)
        {
            var messages = new List<string>();

            messages.AddRange(ValidateConsultBase(values.Consult));

            return messages;
        }

        /// <summary>
        /// 更新保存時の入力チェック
        /// </summary>
        /// <param name="values">入力値</param>
        /// <returns>エラーメッセージ</returns>
        public List<string> ValidateConsult(UpdateConsultationModel values)
        {
            var messages = new List<string>();

            messages.AddRange(ValidateConsultBase(values.Consult));

            return messages;
        }

        /// <summary>
        /// 新規保存時の基本情報の入力チェック
        /// </summary>
        /// <param name="values">入力値</param>
        /// <returns>エラーメッセージ</returns>
        private List<string> ValidateConsultBase(ConsultationBaseModel values)
        {
            var messages = new List<string>();

            if (string.IsNullOrEmpty(values.CslDate))
            {
                messages.Add("受診日を入力してください。");
            }
            else if (!DateTime.TryParse(values.CslDate, out DateTime tmpCslDate))
            {
                messages.Add("受診日の形式が正しくありません。");
            }

            if (string.IsNullOrEmpty(values.PerId))
            {
                messages.Add("個人を入力してください。");
            }

            if (string.IsNullOrEmpty(values.OrgCd1) || string.IsNullOrEmpty(values.OrgCd2))
            {
                messages.Add("団体を入力してください。");
            }

            if (string.IsNullOrEmpty(values.CsCd))
            {
                messages.Add("コースを入力してください。");
            }

            if (string.IsNullOrEmpty(values.RsvGrpCd))
            {
                messages.Add("予約群を入力してください。");
            }

            if (string.IsNullOrEmpty(values.CslDivCd))
            {
                messages.Add("受診区分を入力してください");
            }

            return messages;
        }

        /// <summary>
        /// 受付時の当日IDバリデーション
        /// </summary>
        /// <param name="data">入力値</param>
        /// <returns>エラーメッセージ</returns>
        public List<string> ValidateDayId(RegisterDayIdModel data)
        {
            var messages = new List<string>();

            if (data.Mode != ENTRYMODE_MANUAL)
            {
                return messages;
            }

            if (string.IsNullOrWhiteSpace(data.DayId))
            {
                messages.Add("当日IDを入力してください。");
            }
            else if (!Regex.IsMatch(data.DayId.Trim(), "^[0-9]{1,4}$"))
            {
                messages.Add("当日ＩＤは4文字以内の半角数字で入力して下さい。");
            }

            return messages;
        }

        /// <summary>
        /// 来院情報の入力チェック
        /// </summary>
        /// <param name="dayId">当日ID</param>
        /// <param name="ocrNo">OCR番号</param>
        /// <param name="lockerKey">ロッカーキー</param>
        /// <returns>true:正常終了、false:異常終了</returns>
        public String[] CheckWelComeInfo(
            int dayId,
            string ocrNo,
            string lockerKey
        )
        {
            string message;
            string[] messageList = null;

            // 値のチェック(当日ID)
            if (Convert.ToString(dayId) != null && !Convert.ToString(dayId).Trim().Equals(""))
            {
                message = WebHains.CheckNumeric(PORP_NAME_DAYID, Convert.ToString(dayId), PORP_LEN_DAYID, Check.Necessary);
                if (message != null)
                {
                    messageList = new String[] { message };
                    return messageList;
                }
            }

            // 値のチェック(OCR番号)
            if (ocrNo != null && !Convert.ToString(ocrNo).Trim().Equals(""))
            {
                message = WebHains.CheckAlphabetAndNumeric(PORP_NAME_OCRNO, Convert.ToString(ocrNo), PORP_LEN_OCRNO, Check.Necessary);
                if (message != null)
                {
                    messageList = new String[] { message };
                    return messageList;
                }
            }

            // 値のチェック(ロッカーキー)
            if (lockerKey != null && !Convert.ToString(lockerKey).Trim().Equals(""))
            {
                message = WebHains.CheckAlphabetAndNumeric(PORP_NAME_DAYID, Convert.ToString(lockerKey), PORP_LEN_DAYID, Check.Necessary);
                if (message != null)
                {
                    messageList = new String[] { message };
                    return messageList;
                }
            }
            return messageList;
        }

        /// <summary>
        /// 来院処理の入力チェック
        /// </summary>
        /// <param name="guidanceNo">ご案内書番号</param>
        /// <param name="ocrNo">OCR番号</param>
        /// <returns>true:正常終了、false:異常終了</returns>
        public String[] CheckRegisteredWelComeInfo(
            string guidanceNo,
            string ocrNo
        )
        {
            string message;
            string[] messageList = null;

            // 値のチェック(ご案内書Ｎｏ)
            message = WebHains.CheckAlphabetAndNumeric(PORP_NAME_GUIDANCENO, Convert.ToString(guidanceNo), PORP_LEN_GUIDANCENO, Check.Necessary);
            if (message != null)
            {
                messageList = new String[] { message };
                return messageList;
            }

            // 値のチェック(OCR番号)
            message = WebHains.CheckAlphabetAndNumeric(PORP_NAME_OCRNO, Convert.ToString(ocrNo), PORP_LEN_OCRNO, Check.Necessary);
            if (message != null)
            {
                messageList = new String[] { message };
                return messageList;
            }

            return messageList;
        }
    }
}
