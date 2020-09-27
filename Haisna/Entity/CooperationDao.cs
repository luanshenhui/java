using Dapper;
using Hainsi.Common.Constants;
using Microsoft.VisualBasic;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

#pragma warning disable CS1591

namespace Hainsi.Entity
{
    public class CooperationDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public CooperationDao(IDbConnection connection) : base(connection)
        {
        }

        public const string MODE_INSERT = "I";      // 処理モード(挿入)
        public const string MODE_UPDATE = "U";      // 処理モード(更新)
        public const string RELATIONCD_SELF = "0";  //本人用続柄コード
        public const long BRANCHNO_SELF = 0;        //本人用枝番

        // 個人情報レコード
        public struct PERSON_INF
        {
            public long delFlg;          //削除フラグ
            public long transferDiv;     //出向区分
            public string lastName;      //姓
            public string firstName;     //名
            public string lastKName;     //カナ姓
            public string firstKName;    //カナ名
            public DateTime birth;       //生年月日
            public long gender;          //性別
            public string orgBsdCd;      //事業部コード
            public string orgBsdName;    //事業部名称
            public string orgRoomCd;     //室部コード
            public string orgRoomName;   //室部名称
            public string orgPostCd;     //所属コード
            public string orgPostName;   //所属名称
            public string jobCd;         //職名コード
            public string jobName;       //職名s
            public string dutyCd;        //職責コード
            public string dutyName;      //職責名称
            public string qualifyCd;     //資格コード
            public string qualifyName;   //資格名称
            public string isrSign;       //健保記号
            public string isrNo;         //健保番号
            public string relationCd;    //続柄コード
            public long branchNo;        //枝番
            public string empNo;         //従業員番号
            public DateTime hireDate;    //入社年月日
            public string empDiv;        //従業員区分
            public string empName;       //従業員区分名称
            public string hongenDiv;     //本現区分
            public string tel1;          //電話番号１
            public string tel2;          //電話番号２
            public string tel3;          //電話番号３
            public string zipCd1;        //郵便番号１
            public string zipCd2;        //郵便番号２
            public string address1;      //住所１
            public string address2;      //住所２
            public DateTime cslDate;     //受診希望日
        };

        /// <summary>
        /// 配列への要素追加
        /// </summary>
        /// <param name="array1">配列１</param>
        /// <param name="array2">配列２</param>
        /// <param name="message1">メッセージ１</param>
        /// <param name="message2">メッセージ２</param>
        public void AppendMessage(List<string> array1, List<string> array2, string message1, string message2 = "")
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
        /// true   日付として認識可能
        /// false  日付として認識不能
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
        /// true   カナ文字のみで構成
        /// false  カナ文字以外の文字が存在
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
        /// true   値が存在
        /// false  値が存在しない
        /// </returns>
        public bool CheckIntoValue(string expression, List<string> value)
        {
            bool ret = false; // 関数戻り値

            // 配列の各要素との比較
            for (int i = 0; i < value.Count; i++)
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
        /// true   値が存在
        /// false  値が存在しない
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
        /// true   数字として認識可能
        /// false  数字として認識不能
        /// </returns>
        public bool CheckNumber(string expression)
        {
            // 半角数字チェック
            return Regex.IsMatch(expression, @"^[0-9]+$");
        }

        /// <summary>
        /// 数値チェック
        /// </summary>
        /// <param name="expression">文字列式</param>
        /// <param name="intLen">整数桁数</param>
        /// <param name="decLen">小数桁数</param>
        /// <returns>
        /// true   数値として認識可能
        /// false  数値として認識不能
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
        /// 健保記号、健保番号の比較
        /// </summary>
        /// <param name="person">個人情報レコード</param>
        /// <param name="isrSign">健保記号</param>
        /// <param name="isrNo">健保番号</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="lastName">姓</param>
        /// <param name="firstName">名</param>
        /// <param name="message1">メッセージ１</param>
        /// <param name="message2">メッセージ２</param>
        public void CompareIsr(PERSON_INF person, string isrSign, string isrNo, string perId, string lastName, string firstName, ref List<string> message1, ref List<string> message2)
        {
            string buffer;    // 文字列バッファ
            string message;   // メッセージ

            buffer = "従業員番号=" + person.empNo + "、氏名=" + (lastName + "　" + firstName).Trim() + "（" + perId + "）";

            // 健保記号の比較
            if (!"".Equals(isrSign) && !person.isrSign.Equals(isrSign))
            {
                message = buffer + "、健保記号=" + (!"".Equals(person.isrSign) ? person.isrSign : "なし") + "、現在の健保記号=" + (!"".Equals(isrSign) ? isrSign : "なし");

                AppendMessage(message1, message2, "現在の個人情報と健保記号が異なります。", message);
            }

            // 健保番号の比較
            if (!"".Equals(isrNo) && !person.isrNo.Equals(isrNo))
            {
                message = buffer + "、健保番号=" + (!"".Equals(person.isrNo) ? person.isrNo : "なし") + "、現在の健保番号=" + (!"".Equals(isrNo) ? isrNo : "なし");

                AppendMessage(message1, message2, "現在の個人情報と健保番号が異なります。", message);
            }
        }

        /// <summary>
        /// 氏名の比較
        /// </summary>
        /// <param name="person">個人情報レコード</param>
        /// <param name="lastName">姓</param>
        /// <param name="firstName">名</param>
        /// <param name="lastKName">カナ姓</param>
        /// <param name="firstKName">カナ名</param>
        /// <param name="message1">メッセージ１</param>
        /// <param name="message2">メッセージ２</param>
        public void CompareName(PERSON_INF person, string lastName, string firstName, string lastKName, string firstKName, ref List<string> message1, ref List<string> message2)
        {
            string checkLastKName;         // カナ姓
            string checkFirstKName;        // カナ名
            string originLastKName;        // 現在のカナ姓
            string originFirstKName;       // 現在のカナ名
            string message;                // メッセージ

            checkLastKName = person.lastName;
            checkLastKName = checkLastKName.Replace("ァ", "ア");
            checkLastKName = checkLastKName.Replace("ィ", "イ");
            checkLastKName = checkLastKName.Replace("ゥ", "ウ");
            checkLastKName = checkLastKName.Replace("ェ", "エ");
            checkLastKName = checkLastKName.Replace("ォ", "オ");
            checkLastKName = checkLastKName.Replace("ッ", "ツ");
            checkLastKName = checkLastKName.Replace("ャ", "ヤ");
            checkLastKName = checkLastKName.Replace("ュ", "ユ");
            checkLastKName = checkLastKName.Replace("ョ", "ヨ");

            checkFirstKName = person.firstName;
            checkFirstKName = checkFirstKName.Replace("ァ", "ア");
            checkFirstKName = checkFirstKName.Replace("ィ", "イ");
            checkFirstKName = checkFirstKName.Replace("ゥ", "ウ");
            checkFirstKName = checkFirstKName.Replace("ェ", "エ");
            checkFirstKName = checkFirstKName.Replace("ォ", "オ");
            checkFirstKName = checkFirstKName.Replace("ッ", "ツ");
            checkFirstKName = checkFirstKName.Replace("ャ", "ヤ");
            checkFirstKName = checkFirstKName.Replace("ュ", "ユ");
            checkFirstKName = checkFirstKName.Replace("ョ", "ヨ");

            originLastKName = person.lastName;
            originLastKName = originLastKName.Replace("ァ", "ア");
            originLastKName = originLastKName.Replace("ィ", "イ");
            originLastKName = originLastKName.Replace("ゥ", "ウ");
            originLastKName = originLastKName.Replace("ェ", "エ");
            originLastKName = originLastKName.Replace("ォ", "オ");
            originLastKName = originLastKName.Replace("ッ", "ツ");
            originLastKName = originLastKName.Replace("ャ", "ヤ");
            originLastKName = originLastKName.Replace("ュ", "ユ");
            originLastKName = originLastKName.Replace("ョ", "ヨ");

            originFirstKName = person.firstName;
            originFirstKName = originFirstKName.Replace("ァ", "ア");
            originFirstKName = originFirstKName.Replace("ィ", "イ");
            originFirstKName = originFirstKName.Replace("ゥ", "ウ");
            originFirstKName = originFirstKName.Replace("ェ", "エ");
            originFirstKName = originFirstKName.Replace("ォ", "オ");
            originFirstKName = originFirstKName.Replace("ッ", "ツ");
            originFirstKName = originFirstKName.Replace("ャ", "ヤ");
            originFirstKName = originFirstKName.Replace("ュ", "ユ");
            originFirstKName = originFirstKName.Replace("ョ", "ヨ");

            // 姓名の比較
            if (originLastKName != checkLastKName || originFirstKName != checkFirstKName)
            {
                message = "氏名=" + (person.lastName + "　" + person.firstName).Trim();
                message = message + "、現在の氏名=" + (lastName + "　" + firstName).Trim();
                AppendMessage(message1, message2, "現在の個人情報と氏名が異なります。氏名は更新されます。", message);
            }

            checkLastKName = person.lastKName;
            checkLastKName = checkLastKName.Replace("ァ", "ア");
            checkLastKName = checkLastKName.Replace("ィ", "イ");
            checkLastKName = checkLastKName.Replace("ゥ", "ウ");
            checkLastKName = checkLastKName.Replace("ェ", "エ");
            checkLastKName = checkLastKName.Replace("ォ", "オ");
            checkLastKName = checkLastKName.Replace("ッ", "ツ");
            checkLastKName = checkLastKName.Replace("ャ", "ヤ");
            checkLastKName = checkLastKName.Replace("ュ", "ユ");
            checkLastKName = checkLastKName.Replace("ョ", "ヨ");

            checkFirstKName = person.firstKName;
            checkFirstKName = checkFirstKName.Replace("ァ", "ア");
            checkFirstKName = checkFirstKName.Replace("ィ", "イ");
            checkFirstKName = checkFirstKName.Replace("ゥ", "ウ");
            checkFirstKName = checkFirstKName.Replace("ェ", "エ");
            checkFirstKName = checkFirstKName.Replace("ォ", "オ");
            checkFirstKName = checkFirstKName.Replace("ッ", "ツ");
            checkFirstKName = checkFirstKName.Replace("ャ", "ヤ");
            checkFirstKName = checkFirstKName.Replace("ュ", "ユ");
            checkFirstKName = checkFirstKName.Replace("ョ", "ヨ");

            originLastKName = person.lastKName;
            originLastKName = originLastKName.Replace("ァ", "ア");
            originLastKName = originLastKName.Replace("ィ", "イ");
            originLastKName = originLastKName.Replace("ゥ", "ウ");
            originLastKName = originLastKName.Replace("ェ", "エ");
            originLastKName = originLastKName.Replace("ォ", "オ");
            originLastKName = originLastKName.Replace("ッ", "ツ");
            originLastKName = originLastKName.Replace("ャ", "ヤ");
            originLastKName = originLastKName.Replace("ュ", "ユ");
            originLastKName = originLastKName.Replace("ョ", "ヨ");

            originFirstKName = person.firstKName;
            originFirstKName = originFirstKName.Replace("ァ", "ア");
            originFirstKName = originFirstKName.Replace("ィ", "イ");
            originFirstKName = originFirstKName.Replace("ゥ", "ウ");
            originFirstKName = originFirstKName.Replace("ェ", "エ");
            originFirstKName = originFirstKName.Replace("ォ", "オ");
            originFirstKName = originFirstKName.Replace("ッ", "ツ");
            originFirstKName = originFirstKName.Replace("ャ", "ヤ");
            originFirstKName = originFirstKName.Replace("ュ", "ユ");
            originFirstKName = originFirstKName.Replace("ョ", "ヨ");

            // カナ姓名の比較
            if (originLastKName != checkLastKName || originFirstKName != checkFirstKName)
            {
                message = "カナ氏名=" + (person.lastKName + "　" + person.firstKName).Trim();
                message = message + "、現在のカナ氏名=" + (lastKName + "　" + firstKName).Trim();
                AppendMessage(message1, message2, "現在の個人情報とカナ氏名が異なります。カナ氏名は更新されます。", message);
            }
        }

        /// <summary>
        /// 生年月日、性別の比較
        /// </summary>
        /// <param name="person">個人情報レコード</param>
        /// <param name="birth">生年月日</param>
        /// <param name="gender">性別</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="lastName">姓</param>
        /// <param name="firstName">名</param>
        /// <param name="message1">メッセージ１</param>
        /// <param name="message2">メッセージ２</param>
        public void ComparePerson(PERSON_INF person, DateTime birth, long gender, string perId, string lastName, string firstName, ref List<string> message1, ref List<string> message2)
        {
            string buffer;    // 文字列バッファ
            string message;   // メッセージ

            buffer = "氏名=" + (lastName + "　" + firstName).Trim() + "（" + perId + "）";

            // 生年月日の比較
            if (birth != person.birth)
            {
                message = buffer + "、生年月日=" + string.Format(Convert.ToString(person.birth), "ge.m.d") + "、現在の生年月日=" + string.Format(Convert.ToString(birth));
                AppendMessage(message1, message2, "現在の個人情報と生年月日が異なります。", message);
            }

            // 性別の比較
            if (gender != person.gender)
            {
                message = buffer + "、性別=" + (person.gender == 1 ? "男性" : "女性") + "、現在の性別=" + (gender == 1 ? "男性" : "女性");
                AppendMessage(message1, message2, "現在の個人情報と性別が異なります。", message);
            }
        }

        /// <summary>
        /// 個人情報更新時のメッセージを編集する
        /// </summary>
        /// <param name="called">呼び元(0:人事情報から、1:健保本人から)</param>
        /// <param name="mode">処理モード</param>
        /// <param name="status">状態</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="person">個人情報レコード</param>
        /// <param name="userId">ユーザＩＤ</param>
        /// <param name="message1">メッセージ１</param>
        /// <param name="message2">メッセージ２</param>
        public void EditMessage(long called, string mode, long status, string perId, PERSON_INF person, string userId, ref string message1, ref string message2)
        {
            string message = ""; // メッセージ

            // 初期処理
            message1 = "";
            message2 = "";

            // メッセージ基本部分の編集
            switch (called)
            {
                case 0:

                    message = "従業員番号=" + person.isrNo;
                    break;

                case 1:

                    message = "健保記号=" + person.isrSign + "、健保番号=" + person.isrNo;
                    break;

            }

            message = message + "、氏名=" + (person.lastName + "　" + person.firstName);

            // 状態ごとのメッセージ編集
            // 正常時
            if (status > 0)
            {
                message1 = "個人情報が" + (mode == MODE_INSERT ? "作成" : "更新") + "されました。";
                message2 = message + "（" + perId + "）";
            }
            // 個人ＩＤ重複時
            else if (status == 0)
            {
                // 挿入時は必ず個人ＩＤを発番するので本処理は絶対発生しない。よって更新時のメッセージのみ記す。
                if (mode == MODE_UPDATE)
                {
                    message1 = "この個人情報はすでに削除されています。更新できません。";
                    message2 = message;
                }
            }
            // 団体情報重複時
            else if (status == -1)
            {
                message1 = "この個人情報はすでに削除されています。更新できません。";
                message2 = message;

            }
            // 健保情報重複時
            else if (status == -2)
            {
                message1 = "同一健保、続柄、枝番の個人情報がすでに存在します。";
                message2 = message;

                if (called == 0)
                {
                    message2 = message2 + "、健保記号=" + person.isrSign;
                    message2 = message2 + "、健保番号=" + person.isrNo;
                }

                message2 = message2 + "、続柄=" + person.relationCd;
                message2 = message2 + "、枝番=" + person.branchNo;
            }
            // ユーザ情報非存在時
            else if (status == -3)
            {
                message1 = "ユーザＩＤが存在しません。";
                message2 = "ユーザＩＤ=" + userId;
            }
            // 所属情報非存在時
            else if (status == -4)
            {
                message1 = "所属情報が存在しません。";
                message2 = message;
                message2 = message2 + "、事業部コード=" + (!"".Equals(person.orgBsdCd) ? person.orgBsdCd : "なし");
                message2 = message2 + "、室部コード=" + (!"".Equals(person.orgRoomCd) ? person.orgRoomCd : "なし");
                message2 = message2 + "、所属コード==" + (!"".Equals(person.orgPostCd) ? person.orgPostCd : "なし");
            }
            // 続柄非存在時
            else if (status == -5)
            {
                message1 = "続柄が存在しません。";
                message2 = message + "、続柄=" + person.relationCd;
            }
            // 職名非存在時
            else if (status == -7)
            {
                message1 = "職名情報が存在しません。";
                message2 = message + "、職名コード=" + person.jobCd;
            }
            // 職責非存在時
            else if (status == -8)
            {
                message1 = "職責情報が存在しません。";
                message2 = message + "、職責コード=" + person.dutyCd;
            }
            // 資格非存在時
            else if (status == -9)
            {
                message1 = "資格情報が存在しません。";
                message2 = message + "、資格コード=" + person.qualifyCd;
            }
            // ここで親個人ＩＤは更新しないので本処理は発生しない 或は ここでは就業措置区分は更新しないので本処理は発生しない
            else if (status == -6 || status == -10)
            {
            }
            else
            {
                message1 = "個人情報の更新処理でその他エラーが発生しました。";
                message2 = message + "、エラーコード=" + status;
            }
        }

        /// <summary>
        /// 個人情報レコード構造体の初期化
        /// </summary>
        /// <param name="person">個人情報レコード構造体</param>
        public void Initialize(PERSON_INF person)
        {
            person.delFlg = 0;
            person.transferDiv = 0;
            person.lastName = "";
            person.firstName = "";
            person.lastKName = "";
            person.firstKName = "";
            person.birth = Convert.ToDateTime(0);
            person.gender = 0;
            person.orgBsdCd = "";
            person.orgBsdName = "";
            person.orgRoomCd = "";
            person.orgRoomName = "";
            person.orgPostCd = "";
            person.orgPostName = "";
            person.jobCd = "";
            person.jobName = "";
            person.dutyCd = "";
            person.dutyName = "";
            person.qualifyCd = "";
            person.qualifyName = "";
            person.isrSign = "";
            person.isrNo = "";
            person.relationCd = "";
            person.branchNo = 0;
            person.empNo = "";
            person.hireDate = Convert.ToDateTime(0);
            person.empDiv = "";
            person.empName = "";
            person.hongenDiv = "";
            person.tel1 = "";
            person.tel2 = "";
            person.tel3 = "";
            person.zipCd1 = "";
            person.zipCd2 = "";
            person.address1 = "";
            person.address2 = "";
            person.cslDate = Convert.ToDateTime(0);
        }

        /// <summary>
        /// 指定されたファイルが使用中であるかを判定
        /// </summary>
        /// <param name="fileName">ファイル名</param>
        /// <returns>
        /// true   使用中である
        /// false  使用されていない
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
        /// Insert.Normal  正常終了
        /// Insert.Error   異常終了
        /// </returns>
        public Insert PutHainsLog(long transactionId,
                                  string transactionDiv,
                                  string informationDiv,
                                  string lineNo,
                                  List<string> message1,
                                  List<string> message2,
                                  bool newTransaction = true)
        {
            Insert ret = Insert.Error;
            List<string> arraymessage1 = message1;  // メッセージ１
            List<string> arraymessage2 = message2;  // メッセージ２
            string sql;                             // SQLステートメント

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
                    // Inputは名前と値のみ
                    cmd.Parameters.Add("transactionid", transactionId);
                    cmd.Parameters.Add("transactiondiv", transactionDiv);
                    cmd.Parameters.Add("informationdiv", informationDiv);
                    cmd.Parameters.Add("lineno", lineNo);
                    cmd.Parameters.Add("message1", "");
                    cmd.Parameters.Add("message2", "");

                    // Outputパラメータ
                    cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                    // 各配列値の挿入処理
                    for (int i = 0; i < arraymessage1.Count; i++)
                    {
                        // 配列値の編集
                        // #ToDo LeftB について　どうするか？  objMessage1.MinimumSize = 150  => PadRight
                        //objMessage1.Value = CStr(StrConv(LeftB(StrConv(vntArrMessage1(i), vbFromUnicode), 150), vbUnicode))
                        //objMessage2.Value = CStr(StrConv(LeftB(StrConv(vntArrMessage2(i), vbFromUnicode), 150), vbUnicode))

                        ExecuteNonQuery(cmd, sql);
                    }
                }
            }
            else
            {
                // キー及び更新値の設定
                var param = new Dictionary<string, object>();
                param.Add("transactionid", transactionId);
                param.Add("transactiondiv", transactionDiv);
                param.Add("informationdiv", informationDiv);
                param.Add("lineno", lineNo);
                param.Add("message1", "");
                param.Add("message2", "");
                param.Add("ret", "");

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

                // 各配列値の挿入処理
                for (int i = 0; i < arraymessage1.Count; i++)
                {
                    // 配列値の編集
                    // #ToDo LeftB について　どうするか？  objMessage1.MinimumSize = 150  => PadRight
                    //objMessage1.Value = CStr(StrConv(LeftB(StrConv(vntArrMessage1(i), vbFromUnicode), 150), vbUnicode))
                    //objMessage2.Value = CStr(StrConv(LeftB(StrConv(vntArrMessage2(i), vbFromUnicode), 150), vbUnicode))

                    connection.Execute(sql, param);

                }
            }

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// ＣＳＶデータを配列化し、かつ項目名および項目長定義の配列を返す
        /// </summary>
        /// <param name="csvStream">ＣＳＶデータ</param>
        /// <param name="maxArraySize">配列の最大サイズ</param>
        /// <returns>
        /// arrColumns 配列
        /// </returns>
        public List<string> SetColumnsArrayFromCsvString(string csvStream, long maxArraySize)
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
            return arrColumnsNew.ToList();
        }

        /// <summary>
        /// 姓名の分割
        /// </summary>
        /// <param name="name">姓名</param>
        /// <param name="lastName">姓</param>
        /// <param name="firstName">名</param>
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
            lastName = name.Substring(0, ptr).Trim();
            firstName = name.Substring(name.Length - (name.Length - ptr)).Trim();

            return;
        }
    }
}

