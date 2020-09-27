using Dapper;
using Microsoft.VisualBasic;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

#pragma warning disable CS1591

namespace Hainsi.Entity
{
    /// <summary>
    /// 一括入金処理用データアクセスオブジェクト
    /// </summary>
    public class PaymentAutoDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public PaymentAutoDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 処理モード(挿入)
        /// </summary>
        public const string MODE_INSERT = "I";

        /// <summary>
        /// 処理モード(更新)
        /// </summary>
        public const string MODE_UPDATE = "U";

        // 構造体←→文字列変換のための構造体
        public struct PERSON_INF
        {
            //#ToDo 固定文字長　どうするか
            // Buffer      As String * 256
            public string buffer;
        }

        /// <summary>
        /// 配列への要素追加
        /// </summary>
        /// <param name="array1">配列１</param>
        /// <param name="array2">配列２</param>
        /// <param name="message1">メッセージ１</param>
        /// <param name="message2">メッセージ２</param>
        public void AppendMessage(ref List<string> array1,ref List<string> array2, string message1, string message2 = "")
        {

            // 要素がなければ何もしない
            if ("".Equals(message1))
            {
                return;
            }

            array1.Add(message1.Trim());
            array2.Add(message2.Trim());

        }

        /// <summary>
        /// 日付チェック
        /// </summary>
        /// <param name="expression">文字列式</param>
        /// <param name="mode">チェックモード(0:年月日、1:年月)</param>
        /// <returns>
        /// True   日付として認識可能
        /// False  日付として認識不能
        /// </returns>
        public bool CheckDate(string expression, long mode = 0)
        {
            bool ret = false;
            string[] token;  // トークン
            string year;     // 年
            string month;    // 月
            string day;      // 日

            if ("".Equals(expression.Trim()))
            {
                return ret;
            }

            // スラッシュによる区切りが存在する場合
            if (expression.IndexOf("/", StringComparison.Ordinal) >= 0)
            {
                // スラッシュで文字列を分割
                token = expression.Split('/');

                // 年月日の場合は要素が３個以外なら、年月の場合は２個以外ならばそれぞれエラー
                if (token.Count() != (mode == 0 ? 3 : 2))
                {
                    return ret;
                }

                // 年・月・日を編集
                year = token[0];
                month = token[1];
                if (0 == mode)
                {
                    day = token[2];
                }
                else
                {
                    day = "1"; // 年月の場合における後のチェックのための暫定的処置
                }

                // 半角数字チェック
                if (!CheckNumber(year))
                {
                    return ret;
                }

                // 半角数字チェック
                if (!CheckNumber(month))
                {
                    return ret;
                }

                // 半角数字チェック
                if (!CheckNumber(day))
                {
                    return ret;
                }
            }
            else // 区切りが存在しない場合
            {
                // 年月日の場合は８桁以外なら、年月の場合６桁以外ならばそれぞれはエラー
                if (expression.Length != (mode == 0 ? 8 : 6))
                {
                    return ret;
                }

                // 半角数字チェック
                if (!CheckNumber(expression))
                {
                    return ret;
                }

                // 年・月・日を編集
                year = expression.Substring(0, 4);
                month = expression.Substring(4, 2);
                if (0 == mode)
                {
                    day = expression.Substring(expression.Length - 2);
                }
                else
                {
                    day = "1"; // 年月の場合における後のチェックのための暫定的処置
                }
            }

            // 日付チェックを行い、正常なら日付とみなす
            return Information.IsDate(year + "/" + month + "/" + day);
        }

        /// <summary>
        /// カナ文字チェック
        /// </summary>
        /// <param name="expression">文字列式</param>
        /// <returns>
        /// True   カナ文字のみで構成
        /// False  カナ文字以外の文字が存在
        /// </returns>
        public bool CheckKana(string expression)
        {
            bool ret = false;
            const string KANA_STRING = "゛゜ゝゞァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ・ーヽヾ･ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ";
            string token; // 検索文字
            string narrow;// 半角変換後の文字列

            //半角変換(漢字は半角変換できない特性を利用)
            narrow = Strings.StrConv(expression, VbStrConv.Narrow);

            // 文字列式の文字を１文字ずつ検索
            for (int i = 0; i < narrow.Length; i++)
            {
                // 検索文字の取得
                token = narrow.Substring(i, 1);
                // １文字ずつチェック
                while (true)
                {
                    // 検索文字が空白であれば何もしない
                    if ("".Equals(token.Trim()))
                    {
                        ret = true;
                        break;
                    }

                    // アスキーコードが０～２５５ならば正常
                    if (0 <= Strings.Asc(token) && Strings.Asc(token) <= 255)
                    {
                        ret = true;
                        break;
                    }

                    // ただし、先に定義したカナ文字列の中に存在すれば正常
                    if (KANA_STRING.IndexOf(token, StringComparison.Ordinal) >= 0)
                    {
                        ret = true;
                        break;
                    }

                    ret = false;
                    break;
                }
            }

            ret = true;
            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 値存在チェック
        /// </summary>
        /// <param name="expression">文字列式</param>
        /// <param name="value">取り得る値の集合</param>
        /// <returns>
        /// True   値が存在
        /// False  値が存在しない
        /// </returns>
        public bool CheckIntoValue(string expression, string[] value)
        {
            bool ret = false; // 関数戻り値

            // 配列の各要素との比較
            for (int i = 0; i < value.Length; i++)
            {
                if (expression.Trim().Equals(value[i]))
                {
                    ret = true;
                    break;
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 半角英数字チェック
        /// </summary>
        /// <param name="expression">文字列式</param>
        /// <returns>
        /// True   値が存在
        /// False  値が存在しない
        /// </returns>
        public bool CheckNarrowValue(string expression)
        {

            bool ret = false;

            expression = expression.Trim();

            // 半角英数字チェック
            for (int i = 0; i < expression.Length; i++)
            {
                string ch = expression.Substring(i, 1);
                if (Strings.Asc(ch) < 0 || Strings.Asc(ch) > 255 || (Strings.Asc(ch) >= Strings.Asc("ｦ") && Strings.Asc(ch) <= Strings.Asc("ﾟ")))
                {
                    return ret;
                }
            }

            ret = true;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 数字チェック
        /// </summary>
        /// <param name="expression">文字列式</param>
        /// <returns>
        /// True   数字として認識可能
        /// False  数字として認識不能
        /// </returns>
        public bool CheckNumber(string expression)
        {
            expression = expression.Trim();

            // 半角数字チェック
            if (Regex.IsMatch(expression, @"^[0-9]+$"))
            {
                return true;
            }

            // 戻り値の設定
            return Regex.IsMatch(expression, @"^[0-9]+$");
        }

        /// <summary>
        /// 数値チェック
        /// </summary>
        /// <param name="expression">文字列式</param>
        /// <param name="intLen">整数桁数</param>
        /// <param name="decLen">小数桁数</param>
        /// <returns>
        /// True   数値として認識可能
        /// False  数値として認識不能
        /// </returns>
        public bool CheckNumber2(string expression, long intLen = 0, long decLen = 0)
        {
            bool ret = false;

            string token;          // トークン
            long analyzeMode = 0;  // 現在の解析モード
            string integer = "";   // 整数値
            string decimalDot = "";// 小数値
            long size = 0;         // 文字列長
            int i;                 // インデックス

            if ("".Equals(expression.Trim()))
            {
                return ret;
            }

            // (フェイズ１)構文解析
            i = 0;

            while (true)
            {
                // すべて走査した場合は終了
                if (i >= expression.Length)
                {
                    break;
                }

                // １文字取得
                token = expression.Substring(i, 1);

                while (true)
                {
                    // 現解析モードごとの処理
                    if (0 == analyzeMode)
                    {
                        //モード指定なし
                        // 符号であれば整数モードへ
                        if (token.IndexOf("+-", StringComparison.Ordinal) >= 0)
                        {
                            analyzeMode = 1;
                            i = i + 1;
                            break;
                        }

                        // 数字であれば整数モードへ
                        if (token.IndexOf("0123456789", StringComparison.Ordinal) >= 0)
                        {
                            analyzeMode = 1;
                            break;
                        }

                        // 小数点であれば小数モードへ
                        if (".".Equals(token))
                        {
                            analyzeMode = 2;
                            i = i + 1;
                            break;
                        }

                        return false;

                    }
                    else if (1 == analyzeMode)
                    {
                        //整数モード
                        // 数字であれば整数値をスタック
                        if (token.IndexOf("0123456789", StringComparison.Ordinal) >= 0)
                        {
                            integer = integer + token;
                            i = i + 1;
                            break;
                        }

                        // 小数点であれば小数モードへ
                        if (".".Equals(token))
                        {
                            analyzeMode = 2;
                            i = i + 1;
                            break;
                        }

                        return false;

                    }
                    else if (2 == analyzeMode)
                    {
                        //小数モード
                        // 数字であれば小数値をスタック
                        if (token.IndexOf("0123456789", StringComparison.Ordinal) >= 0)
                        {
                            decimalDot = decimalDot + token;
                            i = i + 1;
                            break;
                        }

                        return false;

                    }
                    break;
                }
            }

            // (フェイズ２)整数桁数チェック
            if (intLen > 0 && !"".Equals(integer))
            {
                // 文字列を検索し、最初に０以外の値が現れる個所を検索することで桁数を求める
                size = integer.Length;

                for (int j = 0; j < size; j++)
                {
                    if (!"0".Equals(integer.Substring(j, 1)))
                    {
                        break;
                    }
                    size = size - 1;
                }

                // この桁数が引数指定された桁数を超えればエラー
                if (size > intLen)
                {
                    ret = false;
                    return ret;
                }
            }

            // (フェイズ３)小数桁数チェック
            if (!"".Equals(decimalDot))
            {
                // 文字列を最後から検索し、最初に０以外の値が現れる個所を検索することで桁数を求める
                size = decimalDot.Length;

                for (int j = 0; j < size; j++)
                {
                    if (!"0".Equals(decimalDot.Substring(j, 1)))
                    {
                        break;
                    }
                    size = size - 1;
                }

                // この桁数が引数指定された桁数を超えればエラー
                if (size > decLen)
                {
                    ret = false;
                    return ret;
                }

            }

            ret = true;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 日付変換
        /// </summary>
        /// <param name="expression">文字列式</param>
        /// <returns>
        /// 変換後の日付
        /// </returns>
        public string CnvDate(string expression)
        {
            string era = "";   // 元号
            string year = "";  // 年
            string month = ""; // 月
            string day = "";   // 日
            string date;       // 変換可能な日付
            string wkDate = "";

            while (true)
            {
                // 初期処理
                date = "";

                // 未指定の場合
                expression = expression.Trim();
                if ("".Equals(expression))
                {
                    return date;
                }

                // ピリオドによる区切りが存在する場合、ピリオドをスラッシュに置換してチェック
                if (expression.IndexOf(".", StringComparison.Ordinal) >= 0)
                {
                    expression = expression.Replace(".", "/");
                }

                // 素のままで日付として認識可能な場合
                if (Information.IsDate(expression))
                {
                    date = expression;
                    return date;
                }

                // それ以外
                switch (expression.Length)
                {
                    // ６桁、または８桁の場合、西暦指定かをチェック
                    case 6:
                    case 8:

                        // 半角数字チェック
                        if (!CheckNumber(expression))
                        {
                            return date;
                        }

                        // 年・月・日を編集
                        if (expression.Length == 6)
                        {
                            year = expression.Substring(0, 2);
                            month = expression.Substring(2, 2);
                            day = expression.Substring(expression.Length - 2);
                        }
                        else
                        {
                            year = expression.Substring(0, 4);
                            month = expression.Substring(4, 2);
                            day = expression.Substring(expression.Length - 2);
                        }

                        //スラッシュで連結し、日付認識可能かをチェック
                        wkDate = year + "/" + month + "/" + day;
                        if (!Information.IsDate(wkDate))
                        {
                            return date;
                        }

                        date = wkDate;
                        return date;

                    // ７桁の場合、和暦指定かをチェック
                    case 7:
                        // 先頭１文字は元号とし、それ以降が半角数字かをチェック
                        if (!CheckNumber(expression.Substring(1, 6)))
                        {
                            return date;
                        }

                        // 元号・年・月・日を編集
                        era = expression.Substring(0, 1);
                        year = expression.Substring(1, 2);
                        month = expression.Substring(3, 2);
                        day = expression.Substring(expression.Length - 2);

                        // スラッシュで連結し、日付認識可能かをチェック
                        wkDate = year + "/" + month + "/" + day;
                        if (!Information.IsDate(wkDate))
                        {
                            return date;
                        }

                        date = wkDate;
                        return date;
                }

                break;
            }

            // 戻り値の設定
            return date;
        }

        /// <summary>
        /// 指定されたファイルが使用中であるかを判定
        /// </summary>
        /// <param name="fileName">ファイル名</param>
        /// <returns>
        /// True   使用中である
        /// False  使用されていない
        /// </returns>
        public bool Locked(string fileName)
        {
            bool ret = false;// 関数戻り値

            // 排他付き読み込みモードでファイルをオープンし、排他かを判断
            FileStream fs = null;
            try
            {
                fs = new FileStream(fileName, FileMode.Open, FileAccess.Read, FileShare.None);
                ret = false;
            }
            catch
            {
                return true;
            }
            finally
            {
                if (fs != null)
                {
                    fs.Close();
                }
            }

            return ret;
        }

        /// <summary>
        /// ログテーブルレコードを挿入する
        /// </summary>
        /// <param name="transactionId">トランザクションID</param>
        /// <param name="transactionDiv">処理区分</param>
        /// <param name="informationDiv">情報区分</param>
        /// <param name="lineNo">対象処理行</param>
        /// <param name="message1">メッセージ１</param>
        /// <param name="message2">メッセージ２</param>
        /// <param name="newTransaction">独立したトランザクションとして実行するか</param>
        /// <returns>
        /// INSERT_NORMAL  正常終了
        /// INSERT_ERROR   異常終了
        /// </returns>
        public int PutHainsLog(long transactionId, string transactionDiv, string informationDiv, string lineNo, List<string> message1, List<string> message2, bool newTransaction = true)
        {
            string[] arraymessage1 = new string[1];
            string[] arraymessage2 = new string[1];
            string sql;
            
            // ログレコード挿入用のSQLステートメント作成
            if (newTransaction)
            {
                sql = @"
                        begin :ret := puthainslog(
                          :transactionid
                          , :transactiondiv
                          , :informationdiv
                          , :lineno
                          , :message1
                          , :message2
                        );
                        end;
                    ";

                using (var cmd = new OracleCommand())
                {
                    for (int i = 0; i < message1.Count(); i++)
                    {
                        // Inputは名前と値のみ
                        cmd.Parameters.Add("transactionid", transactionId);
                        cmd.Parameters.Add("transactiondiv", transactionDiv);
                        cmd.Parameters.Add("informationdiv", informationDiv);
                        cmd.Parameters.Add("lineno", lineNo);
                        cmd.Parameters.Add("message1", message1[i]);
                        cmd.Parameters.Add("message2", message2[i]);
                    }
                    // OutputはOracleDbTypeとParameterDirectionの指定が必要
                    OracleParameter ret = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                    ExecuteNonQuery(cmd, sql);

                    return ((OracleDecimal)ret.Value).ToInt32();
                }
            }
            else
            {
                sql = @"
                        insert
                        into hainslog(
                          transactionid
                          , insdate
                          , transactiondiv
                          , informationdiv
                          , statementno
                          , lineno
                          , message1
                          , message2
                        )
                        values (
                          :transactionid
                          , sysdate
                          , :transactiondiv
                          , :informationdiv
                          , hainslog_statementno_seq.nextval
                          , :lineno
                          , :message1
                          , :message2
                        )
                    ";
                // キー及び更新値の設定
                var param = new Dictionary<string, object>();
                for (int i = 0; i < message1.Count(); i++)
                {
                    param.Add("transactionid", transactionId);
                    param.Add("transactiondiv", transactionDiv);
                    param.Add("informationdiv", informationDiv);
                    param.Add("lineno", lineNo);
                    param.Add("message1", message1[i]);
                    param.Add("message2", message2[i]);
                }
                connection.Execute(sql, param);
            }
            // 戻り値の設定
            return 0;
        }

        /// <summary>
        /// ＣＳＶデータを配列化し、かつ項目名および項目長定義の配列を返す
        /// </summary>
        /// <param name="csvStream">ＣＳＶデータ</param>
        /// <param name="maxArraySize">配列の最大サイズ</param>
        /// <returns>
        /// arrColumns 配列
        /// </returns>
        public string[] SetColumnsArrayFromCsvString(string csvStream, long maxArraySize)
        {
            string[] arrColumns;

            // カンマ分離
            arrColumns = csvStream.Split(',');

            // 配列のサイズ調整
            string[] arrColumnsNew = new string[maxArraySize];

            // カラム値の検索
            for (int i = 0; i < arrColumns.Length; i++)
            {
                // 先端のダブルクォーテーションを除外
                if ("\"".Equals(arrColumns[i].Substring(0, 1)))
                {
                    arrColumnsNew[i] = arrColumns[i].Substring(arrColumns[i].Length - (arrColumns[i].Length - 1));
                }

                // 終端のダブルクォーテーションを除外
                if ("\"".Equals(arrColumns[i].Substring(arrColumns[i].Length - 1)))
                {
                    arrColumnsNew[i] = arrColumns[i].Substring(0, arrColumns[i].Length - 1);
                }

                // 値のトリミング
                arrColumnsNew[i] = arrColumns[i].Trim();
            }
            return arrColumnsNew;
        }

        /// <summary>
        /// 姓名の分割
        /// </summary>
        /// <param name="name">姓名</param>
        /// <param name="lastName">姓</param>
        /// <param name="firstName">名</param>
        /// <returns></returns>
        public void SplitName(string name, ref string lastName, ref string firstName)
        {
            int ptr; // 最初に空白が発生した位置

            // 初期処理
            lastName = "";
            firstName = "";

            name = name.Trim();
            if ("".Equals(name))
            {
                return;
            }

            // 全角変換
            name = Strings.StrConv(name, VbStrConv.Wide);

            // 全角空白を検索
            ptr = name.IndexOf("　", StringComparison.Ordinal);

            // 全角空白が存在しない場合
            if (ptr < 0)
            {
                lastName = name;
                return;
            }

            // 全角空白が存在する場合
            lastName = name.Substring(0, ptr - 1).Trim();
            firstName = name.Substring(name.Length - (name.Length - ptr)).Trim();

            return;
        }

        /// <summary>
        /// 団体コードの分割
        /// </summary>
        /// <param name="orgCd">団体コード</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <returns></returns>
        public void SplitOrgcd(string orgCd, ref string orgCd1, ref string orgCd2)
        {
            int ptr; // 最初に"-"が発生した位置

            // 初期処理
            orgCd1 = "";
            orgCd2 = "";

            orgCd = orgCd.Trim();
            if ("".Equals(orgCd))
            {
                return;
            }

            // 全角変換
            orgCd2 = Strings.StrConv(orgCd, VbStrConv.Wide);

            // 全角空白を検索
            ptr = orgCd.IndexOf("-", StringComparison.Ordinal);

            // 全角空白が存在しない場合
            if (ptr < 0)
            {
                orgCd1 = orgCd;
                return;
            }

            // 全角空白が存在する場合
            orgCd1 = orgCd.Substring(0, ptr).Trim();
            orgCd2 = orgCd.Substring(orgCd.Length - (orgCd.Length - ptr)).Trim();

            return;
        }
    }
}
