using Hainsi.Common.Constants;
using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;

namespace Hainsi.Common
{
    public static class WebHains
    {
        /// <summary>
        /// 個人受診用の団体コード1
        /// </summary>
        public const string ORGCD1_PERSON = "XXXXX";

        /// <summary>
        /// 個人受診用の団体コード2
        /// </summary>
        public const string ORGCD2_PERSON = "XXXXX";

        /// <summary>
        /// web予約用の団体コード1
        /// </summary>
        public const string ORGCD1_WEB = "WWWWW";

        /// <summary>
        /// web予約用の団体コード2
        /// </summary>
        public const string ORGCD2_WEB = "WWWWW";

        /// <summary>
        /// 日本語カレンダークラスのインスタンスを取得します。
        /// </summary>
        static public Calendar JapaneseCalendar { get; }

        /// <summary>
        /// 日本語カルチャー情報のインスタンスを取得します。
        /// </summary>
        static public CultureInfo JapaneseCulture { get; }

        /// <summary>
        /// コンストラクター
        /// </summary>
        static WebHains()
        {
            // 日本語カレンダークラスのインスタンス作成
            JapaneseCalendar = new JapaneseCalendar();

            // 日本語カルチャー情報の設定
            JapaneseCulture = new CultureInfo("ja-JP");
            JapaneseCulture.DateTimeFormat.Calendar = JapaneseCalendar;
        }

        /// <summary>
        /// 半角英数字チェック
        /// </summary>
        /// <param name="itemName">項目名</param>
        /// <param name="expression">文字列式</param>
        /// <param name="length">桁数</param>
        /// <param name="necessary">必須かどうか</param>
        /// <returns>エラーメッセージ(エラーが無い場合はnull)</returns>
        public static string CheckAlphabetAndNumeric(string itemName, string expression, int length, Check necessary = Check.None)
        {
            expression = null == expression ? expression : expression.Trim();

            string message = null;  // メッセージ

            while (true)
            {
                // 未入力チェック
                if (string.IsNullOrEmpty(expression))
                {
                    // 必須の場合のみメッセージを返す
                    if (necessary.Equals(Check.Necessary))
                    {
                        message = string.Format("{0}を入力して下さい。", itemName);
                    }

                    break;
                }

                // 桁数チェック
                if (expression.Length > length)
                {
                    message = string.Format("{0}は{1}文字以内の半角英数字で入力して下さい。", itemName, length);
                    break;
                }


                // 半角英数字チェック
                if (!Regex.IsMatch(expression, "^[0-9A-Za-z]+$"))
                {
                    message = string.Format("{0}は{1}文字以内の半角英数字で入力して下さい。", itemName, length);
                    break;
                }

                break;
            }

            return message;
        }

#pragma warning disable RECS0154

        /// <summary>
        /// 権限チェック
        /// </summary>
        /// <param name="businessCd">業務コード</param>
        /// <param name="url">チェック対象ページのURL</param>
        /// <param name="authority">権限</param>
        /// <param name="message">権限がない場合のメッセージ</param>
        /// <returns>true:権限あり、False:権限なし</returns>
        /// <remarks>
        /// (1) 今回は権限値のみをチェックし、更新の可否のみをチェックする。
        /// (2) URL文字列に関しては将来的拡張機能のために用意。今回は未使用。
        /// </remarks>
        public static bool CheckAuthority(BusinessCd businessCd, string url, Authority authority, out string message)
        {
            message = null;

            bool ret = true;

            while (true)
            {
                // 更新権限を持つ場合は処理を終了する
                if (authority.Equals(Authority.Full))
                {
                    break;
                }

                // 権限がない場合のメッセージ作成
                switch (businessCd)
                {
                    case BusinessCd.Maintenance:
                        message = "テーブルメンテナンス";
                        break;

                    case BusinessCd.Reserve:
                        message = "予約";
                        break;

                    case BusinessCd.Result:
                        message = "結果入力";
                        break;

                    case BusinessCd.Judgement:
                        message = "判定入力";
                        break;


                    case BusinessCd.Print:
                        message = "印刷・データ抽出";
                        break;

                    case BusinessCd.Demand:
                        message = "請求";
                        break;
                }

                message = string.Format("{0}業務を行う権限がありません。", message);

                ret = false;
                break;
            }

            return ret;
        }

#pragma warning restore RECS0154

        /// <summary>
        /// 日付の妥当性チェックを行う
        /// </summary>
        /// <param name="itemName">項目名</param>
        /// <param name="year">年</param>
        /// <param name="month">月</param>
        /// <param name="day">日</param>
        /// <param name="date">妥当な日付の場合、日付をDateTimeオブジェクトで返す</param>
        /// <param name="necessary">必要かどうか</param>
        /// <returns>エラーメッセージ(エラーが無い場合はnull)</returns>
        public static string CheckDate(string itemName, string year, string month, string day, out DateTime? date, Check necessary = Check.None)
        {
            date = null;

            year = year.Trim();
            month = month.Trim();
            day = day.Trim();

            string message = null; // メッセージ

            while (true)
            {
                // 未入力チェック
                if (string.IsNullOrEmpty(year) || string.IsNullOrEmpty(month) || string.IsNullOrEmpty(day))
                {
                    // 必須指定の場合のみメッセージを返す
                    if (necessary.Equals(Check.Necessary))
                    {
                        message = string.Format("{0}を入力して下さい。", itemName);
                    }

                    break;
                }

                // 日付型でなかった場合
                if (!DateTime.TryParse(year + "/" + month + "/" + day, out DateTime wkDate))
                {
                    message = string.Format("{0}の入力形式が正しくありません。", itemName);
                    break;
                }

                date = wkDate;
                break;
            }

            return message;
        }

        /// <summary>
        /// E-Mail形式チェック
        /// </summary>
        /// <param name="itemName">項目名</param>
        /// <param name="expression">文字列式</param>
        /// <returns>エラーメッセージ(エラーが無い場合はnull)</returns>
        /// <remarks>
        /// 以下の条件でチェックを行う
        /// (1)"@"がただ1つ存在
        /// (2)"@"の前後に文字列が存在
        /// (3)"@"の後の文字列に最低1つの"."が存在
        /// </remarks>
        public static string CheckEMail(string itemName, string expression)
        {
            expression = null == expression ? expression : expression.Trim();

            if (string.IsNullOrEmpty(expression))
            {
                return null;
            }

            while (true)
            {
                // (1-1)"@"の存在チェック
                int pos = expression.IndexOf("@", StringComparison.Ordinal);
                if (pos < 0)
                {
                    break;
                }

                // (1-2)"@"がもう1つ存在すれば不可
                if (expression.IndexOf("@", pos, StringComparison.Ordinal) >= 0)
                {
                    break;
                }

                // (2)"@"は先頭でも最後部でも不可
                if (expression.StartsWith("@", StringComparison.Ordinal) || expression.EndsWith("@", StringComparison.Ordinal))
                {
                    break;
                }

                // (3)"@"の後に"."が存在
                if (expression.IndexOf(".", pos, StringComparison.Ordinal) < 0)
                {
                    break;
                }

                return null;
            }

            return string.Format("{0}の形式が正しくありません。", itemName);
        }

        /// <summary>
        /// カナ文字チェック
        /// </summary>
        /// <param name="expression">文字列式</param>
        /// <returns>true:カナ文字のみで構成、false:カナ文字以外の文字が存在</returns>
        public static bool CheckKana(string expression)
        {
            if (string.IsNullOrEmpty(expression))
            {
                return true;
            }

            // すべての文字が半角・全角空白、全角カナ、半角カナのいずれかにマッチすればカナ文字であるとみなす
            return Regex.IsMatch(expression, @"^[\p{Z}\p{IsKatakana}\uFF61-\uFF9F]+$");
        }

        /// <summary>
        /// 文字列長チェック
        /// </summary>
        /// <param name="itemName">項目名</param>
        /// <param name="expression">文字列式</param>
        /// <param name="length">桁数</param>
        /// <param name="necessary">必須かどうか</param>
        /// <returns>エラーメッセージ(エラーが無い場合はnull)</returns>
        /// <remarks>Shift-JISエンコーディングされた状態で文字列長チェックを行う</remarks>
        public static string CheckLength(string itemName, string expression, int length, Check necessary = Check.None)
        {
            expression = null == expression ? expression : expression.Trim();

            string message = null;

            while (true)
            {
                // 未入力チェック
                if (string.IsNullOrEmpty(expression))
                {
                    // 必須の場合のみメッセージを返す
                    if (necessary.Equals(Check.Necessary))
                    {
                        message = string.Format("{0}を入力して下さい。", itemName);
                    }

                    break;
                }

                // 文字列長チェック
                if (LenB(expression) > length)
                {
                    message = string.Format("{0}の入力内容が長すぎます。", itemName);
                }

                break;
            }

            return message;
        }

        /// <summary>
        /// 半角チェック
        /// </summary>
        /// <param name="itemName">項目名</param>
        /// <param name="expression">文字列式</param>
        /// <param name="length">桁数</param>
        /// <param name="necessary">必須かどうか</param>
        /// <returns>エラーメッセージ(エラーが無い場合はnull)</returns>
        /// <remarks>半角カナは許さない</remarks>
        public static string CheckNarrowValue(string itemName, string expression, int length, Check necessary = Check.None)
        {
            expression = null == expression ? expression : expression.Trim();

            string message = null;

            while (true)
            {
                // 未入力チェック
                if (string.IsNullOrEmpty(expression))
                {
                    // 必須の場合のみメッセージを返す
                    if (necessary.Equals(Check.Necessary))
                    {
                        message = string.Format("{0}を入力して下さい。", itemName);
                    }

                    break;
                }

                // 文字列長チェック
                if (LenB(expression) > length)
                {
                    message = string.Format("{0}は{1}文字以内の半角文字で入力して下さい。", itemName, length);
                    break;
                }

                // すべての文字が半角カナを除く半角文字にマッチするかを判定
                if (!Regex.IsMatch(expression, @"^[\x20-\x7E]+$"))
                {
                    message = string.Format("{0}は{1}文字以内の半角文字で入力して下さい。", itemName, length);
                    break;
                }

                break;
            }

            return message;
        }

        /// <summary>
        /// 半角数字チェック
        /// </summary>
        /// <param name="itemName">項目名</param>
        /// <param name="expression">文字列式</param>
        /// <param name="length">桁数</param>
        /// <param name="necessary">必須かどうか</param>
        /// <returns>エラーメッセージ(エラーが無い場合はnull)</returns>
        public static string CheckNumeric(string itemName, string expression, int length, Check necessary = Check.None)
        {
            expression = null == expression ? expression : expression.Trim();

            string message = null;

            while (true)
            {
                // 未入力チェック
                if (string.IsNullOrEmpty(expression))
                {
                    // 必須の場合のみメッセージを返す
                    if (necessary.Equals(Check.Necessary))
                    {
                        message = string.Format("{0}を入力して下さい。", itemName);
                    }

                    break;
                }

                // 文字列長チェック
                if (LenB(expression) > length)
                {
                    message = string.Format("{0}は{1}文字以内の半角数字で入力して下さい。", itemName, length);
                    break;
                }

                // すべての文字が半角数字にマッチするかを判定
                if (!Regex.IsMatch(expression, "^[0-9]+$"))
                {
                    message = string.Format("{0}は{1}文字以内の半角数字で入力して下さい。", itemName, length);
                    break;
                }

                break;
            }

            return message;
        }

        /// <summary>
        /// 半角数字・符号チェック
        /// </summary>
        /// <param name="itemName">項目名</param>
        /// <param name="expression">文字列式</param>
        /// <param name="length">桁数</param>
        /// <param name="necessary">必須かどうか</param>
        /// <returns>エラーメッセージ(エラーが無い場合はnull)</returns>
        public static string CheckNumericSign(string itemName, string expression, int length, Check necessary = Check.None)
        {
            expression = null == expression ? expression : expression.Trim();

            string message = null;

            while (true)
            {
                // 未入力チェック
                if (string.IsNullOrEmpty(expression))
                {
                    // 必須の場合のみメッセージを返す
                    if (necessary.Equals(Check.Necessary))
                    {
                        message = string.Format("{0}を入力して下さい。", itemName);
                    }

                    break;
                }

                // 文字列長チェック
                if (LenB(expression) > length)
                {
                    message = string.Format("{0}は{1}文字以内の半角数字で入力して下さい。", itemName, length);
                    break;
                }

                // すべての文字が半角数字にマッチするかを判定
                if (!Regex.IsMatch(expression, @"^[0-9\-]+$"))
                {
                    message = string.Format("{0}は{1}文字以内の半角数字で入力して下さい。", itemName, length);
                    break;
                }

                break;
            }

            return message;
        }

        /// <summary>
        /// 全角チェック
        /// </summary>
        /// <param name="itemName">項目名</param>
        /// <param name="expression">文字列式</param>
        /// <param name="length">桁数</param>
        /// <param name="necessary">必須かどうか</param>
        /// <returns>エラーメッセージ(エラーが無い場合はnull)</returns>
        public static string CheckWideValue(string itemName, string expression, int length, Check necessary = Check.None)
        {
            expression = null == expression ? expression : expression.Trim();

            string message = null;

            while (true)
            {
                // 未入力チェック
                if (string.IsNullOrEmpty(expression))
                {
                    // 必須の場合のみメッセージを返す
                    if (necessary.Equals(Check.Necessary))
                    {
                        message = string.Format("{0}を入力して下さい。", itemName);
                    }

                    break;
                }

                // 文字列長チェック
                if (LenB(expression) > length)
                {
                    message = string.Format("{0}は{1}文字以内の全角文字で入力して下さい。", itemName, length / 2);
                    break;
                }

                // すべての文字が全角文字にマッチするかを判定
                // (1バイト文字でない、かつ半角カナでないという正規表現で判定)
                if (!Regex.IsMatch(expression, @"^[^\x01-\x7E\xA1-\xDF]+$"))
                {
                    message = string.Format("{0}は{1}文字以内の全角文字で入力して下さい。", itemName, length / 2);
                    break;
                }

                break;
            }

            return message;
        }

#pragma warning disable RECS0154

        ///
        ///  機能　　 : 初期化ファイルから、指定されたセクション・キーにて定義された値を読み込む
        ///
        ///  引数　　 : (In)     strSectionName  セクション名
        ///　  　　　 : (In)     strKeyName      キー名
        ///
        ///  戻り値　 : 指定セクション・キーの定義値
        ///
        ///  備考　　 :
        ///
        public static string ReadIniFile(string sectionName, string keyName)
        {
            // #TODO 実装予定なし。呼び元ごとに別の実装処理を考える必要あり。
            throw new NotImplementedException();
        }

#pragma warning restore RECS0154

        /// <summary>
        /// カナ文字の半角全角変換
        /// </summary>
        /// <param name="expression">文字列式</param>
        /// <returns>変換後の文字列</returns>
        public static string StrConvKanaWide(string expression)
        {
            if (string.IsNullOrEmpty(expression))
            {
                return expression;
            }

            // 半角カナ文字のみを全角変換
            return Regex.Replace(expression, @"[\uFF61-\uFF9F]+", match =>
            {
                return Strings.StrConv(match.Groups[0].Value, VbStrConv.Wide);
            });
        }

#pragma warning disable RECS0154

        ///
        ///  機能　　 : 外部キーによる整合性違反のキー番号チェック
        ///
        ///  引数　　 : (In)     strErrText            エラー内容（LastServerErrText）
        ///
        ///  戻り値　 : 整合性違反エラー値がある場合、キー識別番号を返す
        ///  　　　　   整合性違反エラー値がない場合、trueを返す
        ///
        ///  備考　　 : LastServerErrが2291の時Callする
        ///
        public static AlertFKey CheckFkeyErr(string errText)
        {
            // TODO 実装予定なし。Diseaseクラスでしか使われていないため、同クラスで個別に実装。
            throw new NotImplementedException();
        }

#pragma warning restore RECS0154

        ///
        ///  機能　　 : 結果問診フラグ名称取得
        ///
        ///  引数　　 : (In)   strRslque           結果問診フラグ
        ///
        ///  戻り値　 : 結果問診フラグ名称
        ///
        ///  備考　　 :
        ///
        public static string SelectRslqueName(string rslque)
        {
            // #TODO 実装予定なし。汎用テーブルからの取得処理に変更する。
            switch (rslque)
            {
                case "0":
                    return "検査結果";
                case "1":
                    return "問診結果";
                default:
                    return null;
            }
        }

        ///
        ///  機能　　 : 項目タイプ名称取得
        ///
        ///  引数　　 : (In)   strItemType         項目タイプ
        ///
        ///  戻り値　 : 項目タイプ名称
        ///
        ///  備考　　 :
        ///
        public static string SelectItemTypeName(string itemType)
        {
            // #TODO 汎用テーブルからの取得処理に変更。
            switch (itemType)
            {
                case "0":
                    return "標準";
                case "1":
                    return "部位";
                case "2":
                    return "所見";
                case "3":
                    return "処置";
                default:
                    return null;
            }
        }

        ///
        ///  機能　　 : 結果タイプ名称取得
        ///
        ///  引数　　 : (In)   strResultType       結果タイプ
        ///
        ///  戻り値　 : 結果タイプ名称
        ///
        ///  備考　　 :
        ///
        public static string SelectResultTypeName(string resultType)
        {
            // #TODO 汎用テーブルからの取得処理に変更
            switch (resultType)
            {
                case "0":
                    return "数値";
                case "1":
                    return "定性１";
                case "2":
                    return "定性２";
                case "3":
                    return "フリー";
                case "4":
                    return "文章";
                case "5":
                    return "計算";
                case "6":
                    return "日付";
                default:
                    return null;
            }
        }

        ///
        ///  機能　　 : 基準値フラグ－表示色取得
        ///
        ///  引数　　 : (In)   vntKeyName          キー名称
        ///  　　　　   (Out)  vntColor            表示色
        ///
        ///  戻り値　 : なし
        ///
        ///  備考　　 :
        ///
        public static void SelectStdFlgColor(string keyName, ref string color)
        {
            // #TODO 汎用テーブルからの取得処理に変更
            switch (keyName)
            {
                case "H_COLOR":
                    color = "#ff0000";
                    break;
                case "U_COLOR":
                    color = "#ff4500";
                    break;
                case "D_COLOR":
                    color = "#00ffff";
                    break;
                case "L_COLOR":
                    color = "#0000ff";
                    break;
                case "*_COLOR":
                    color = "#ff0000";
                    break;
                case "@_COLOR":
                    color = "#800080";
                    break;
            }
        }

        ///
        ///  機能　　 : 時間枠名称取得
        ///
        ///  引数　　 : (In)   lngTimeFra          時間枠
        ///
        ///  戻り値　 : 時間枠名称
        ///
        ///  備考　　 :
        ///
        public static string SelectTimeFraName(int timeFra)
        {
            // #TODO 汎用テーブルからの取得処理に変更
            switch (timeFra)
            {
                case 0:
                    return "終日";
                default:
                    return null;
            }
        }

        ///
        ///  機能　　 : 固定の団体コードの取得
        ///
        ///  引数　　 : (In)   strKey          検索キー
        ///  　　　　 : (Out)  vntOrgCd1       団体コード１
        ///  　　　　 : (Out)  vntOrgCd2       団体コード２
        ///
        ///  戻り値　 : なし
        ///
        ///  備考　　 :
        ///
        public static void GetOrgCd(OrgCdKey key, out string orgCd1, out string orgCd2)
        {
            // 初期値設定
            orgCd1 = null;
            orgCd2 = null;

            // 指定された検索キーにより、固定の団体コードを返す
            switch (key)
            {
                case OrgCdKey.Person:
                    // 個人受診
                    orgCd1 = ORGCD1_PERSON;
                    orgCd2 = ORGCD2_PERSON;
                    break;
                case OrgCdKey.Web:
                    // ウェブ予約
                    orgCd1 = ORGCD1_WEB;
                    orgCd2 = ORGCD2_WEB;
                    break;
            }
        }

        ///
        ///  機能　　 : 「判定が悪い人」の重み取得
        ///
        ///  引数　　 : なし
        ///
        ///  戻り値　 : 値
        ///
        ///  備考　　 :
        ///
        public static int SelectJudBadWeight()
        {
            // #TODO 汎用テーブルからの取得処理に変更
            return 3;
        }

        /// <summary>
        /// 全角カナの小さい文字を大きい文字に置換
        /// </summary>
        /// <param name="stream">被変換文字列</param>
        /// <returns>変換後の文字列</returns>
        public static string ReplaceKanaString(string stream)
        {
            return stream
                .Replace("ァ", "ア")
                .Replace("ィ", "イ")
                .Replace("ゥ", "ウ")
                .Replace("ェ", "エ")
                .Replace("ォ", "オ")
                .Replace("ッ", "ツ")
                .Replace("ャ", "ヤ")
                .Replace("ュ", "ユ")
                .Replace("ョ", "ヨ");
        }

        /// <summary>
        /// 半角数字チェック（符号付き）
        /// </summary>
        /// <param name="itemName">項目名</param>
        /// <param name="expression">文字列式</param>
        /// <param name="length">桁数</param>
        /// <param name="necessary">必須かどうか</param>
        /// <returns>エラーメッセージ(エラーが無い場合はnull)</returns>
        public static string CheckNumericWithSign(string itemName, string expression, int length, Check necessary = Check.None)
        {
            expression = null == expression ? expression : expression.Trim();

            string message = null;

            while (true)
            {
                // 未入力チェック
                if (string.IsNullOrEmpty(expression))
                {
                    // 必須の場合のみメッセージを返す
                    if (necessary.Equals(Check.Necessary))
                    {
                        message = string.Format("{0}を入力して下さい。", itemName);
                    }

                    break;
                }

                // 半角数字・マイナス符号以外の文字が現れたらチェックを中止する
                if (!Regex.IsMatch(expression, @"^[0-9\-]+$"))
                {
                    message = string.Format("{0}は{1}桁以内の半角数字（小数なし）で入力して下さい。", itemName, length);
                    break;
                }

                // 数値チェック
                if (!long.TryParse(expression, out long longValue))
                {
                    message = string.Format("{0}は{1}桁以内の半角数字（小数なし）で入力して下さい。", itemName, length);
                    break;
                }

                // 桁数チェック
                if (Math.Abs(longValue).ToString().Length > length)
                {
                    message = string.Format("{0}は{1}桁以内の半角数字（小数なし）で入力して下さい。", itemName, length);
                    break;
                }

                break;
            }

            return message;
        }

        ///
        ///  機能　　 : 請求締め処理ログ出力先フォルダ取得
        ///
        ///  引数　　 : なし
        ///
        ///  戻り値　 : 請求締め処理ログ出力先フォルダ
        ///
        ///  備考　　 :
        ///
        public static string SelectDmdAddUpLogPath()
        {
            // TODO 実装予定なし。別の取得処理へ変更、または廃止。
            throw new NotImplementedException();
        }

        /// <summary>
        /// 半角数字チェック（小数点あり）
        /// </summary>
        /// <param name="itemName">項目名</param>
        /// <param name="expression">文字列式</param>
        /// <param name="length">桁数（全体）</param>
        /// <param name="decPointLength">桁数（小数部）</param>
        /// <param name="necessary">必須かどうか</param>
        /// <returns>エラーメッセージ(エラーが無い場合はnull)</returns>
        public static string CheckNumericDecimalPoint(string itemName, string expression, int length, int decPointLength, Check necessary = Check.None)
        {
            expression = null == expression ? expression : expression.Trim();

            string message = null;

            while (true)
            {
                // 未入力チェック
                if (string.IsNullOrEmpty(expression))
                {
                    // 必須の場合のみメッセージを返す
                    if (necessary.Equals(Check.Necessary))
                    {
                        message = string.Format("{0}を入力して下さい。", itemName);
                    }

                    break;
                }

                // 桁数チェック
                if (expression.Length > length + 1)
                {
                    message = string.Format("{0}は整数{1}桁、小数{2}桁以内の半角数字で入力して下さい。", itemName, length - decPointLength, decPointLength);
                    break;
                }

                // 半角数字・小数点以外の文字が現れたらチェックを中止する
                if (!Regex.IsMatch(expression, @"^[0-9\.]+$"))
                {
                    message = string.Format("{0}は整数{1}桁、小数{2}桁以内の半角数字で入力して下さい。", itemName, length - decPointLength, decPointLength);
                    break;
                }

                // 小数点数チェック
                // (小数点が2つ以上存在すればエラーとする)
                if (expression.Length - expression.Replace(".", "").Length >= 2)
                {
                    message = string.Format("{0}は小数点を１つまでの整数{1}桁、小数{2}桁以内の半角数字で入力して下さい。", itemName, length - decPointLength, decPointLength);
                    break;
                }

                // 整数部と小数部に分解
                string[] wkExpression = expression.Split('.');

                // 整数部桁数チェック
                if (wkExpression[0].Trim().Length > length - decPointLength)
                {
                    message = string.Format("{0}は整数{1}桁、小数{2}桁以内の半角数字で入力して下さい。", itemName, length - decPointLength, decPointLength);
                    break;
                }

                // 小数部桁数チェック
                if ((wkExpression.Length > 1) && (wkExpression[1].Trim().Length > decPointLength))
                {
                    message = string.Format("{0}は整数{1}桁、小数{2}桁以内の半角数字で入力して下さい。", itemName, length - decPointLength, decPointLength);
                    break;
                }

                break;
            }

            return message;
        }

        ///
        ///  機能　　 : 結果入力・前回値コース選択取得
        ///
        ///  引数　　 : なし
        ///
        ///  戻り値　 : コース選択
        ///
        ///  備考　　 :
        ///
        public static int SelectRslCourseFlg()
        {
            // #TODO
            return 0;
        }

        ///
        ///  機能　　 : 結果入力・前回値２次検査コース選択取得
        ///
        ///  引数　　 : なし
        ///
        ///  戻り値　 : ２次検査コース選択
        ///
        ///  備考　　 :
        ///
        public static int SelectRslSecondFlg()
        {
            // #TODO
            return 0;
        }

        /// <summary>
        /// 履歴日付の重複チェック
        /// </summary>
        /// <param name="itemCount">履歴数</param>
        /// <param name="strDate">開始日付</param>
        /// <param name="endDate">終了日付</param>
        /// <returns>true:重複なし、false:重複あり</returns>
        public static bool CheckHistoryDuplicate(int itemCount, DateTime[] strDate, DateTime[] endDate)
        {
            // 履歴管理数が複数存在しないなら処理終了
            if (itemCount < 2)
            {
                return true;
            }

            // 履歴項目数分Loop
            for (var i = 0; i < itemCount; i++)
            {
                // 現在位置＋１から検索
                for (var j = i + 1; j < itemCount; j++)
                {
                    // 開始日付の重複チェック
                    if ((strDate[i] >= strDate[j]) && (strDate[i] <= endDate[j]))
                    {
                        return false;
                    }

                    // 終了日付の重複チェック
                    if ((endDate[i] >= strDate[j]) && (endDate[i] <= endDate[j]))
                    {
                        return false;
                    }
                }
            }

            return true;
        }

        /// <summary>
        /// 和暦年の配列を取得します。
        /// </summary>
        /// <param name="startYear">開始西暦年</param>
        /// <param name="endYear">終了西暦年</param>
        /// <param name="years">西暦年の配列</param>
        /// <param name="eraCodes">元号(コード表記)の配列</param>
        /// <param name="eraNames">元号(日本語表記)の配列</param>
        /// <returns>配列の要素数</returns>
        public static int GetEraYearArray(int startYear, int endYear, out int[] years, out string[] eraCodes, out string[] eraNames)
        {
            var arrYear = new List<int>(); // 西暦年
            var arrEraCode = new List<string>(); // 元号(コード表記)
            var arrEraName = new List<string>(); // 元号(日本語表記)

            // 初期処理
            years = null;
            eraCodes = null;
            eraNames = null;

            // 西暦年の検索
            for (var y = startYear; y <= endYear; y++)
            {
                // 現編集年の元旦を定義
                var wkDate = new DateTime(y, 1, 1);

                // サポート可能年未満であればスキップ
                if (wkDate.Year < JapaneseCalendar.MinSupportedDateTime.Year)
                {
                    continue;
                }

                // サポート可能な日付未満であれば下限値を採用
                if (wkDate < JapaneseCalendar.MinSupportedDateTime)
                {
                    wkDate = JapaneseCalendar.MinSupportedDateTime;
                }

                // 現編集年月日時点での元号を求める
                string eraCodeOfStartDay = GetShortEraName(wkDate) + EraDateFormat(wkDate, "%y");
                string eraNameOfStartDay = EraDateFormat(wkDate, "gyy");

                // コレクションに追加
                arrYear.Add(y);
                arrEraCode.Add(eraCodeOfStartDay);
                arrEraName.Add(eraNameOfStartDay);

                // 現編集年の大晦日時点での元号を求める
                wkDate = new DateTime(y, 12, 31);
                string eraCodeOfEndDay = GetShortEraName(wkDate) + EraDateFormat(wkDate, "%y");
                string eraNameOfEndDay = EraDateFormat(wkDate, "gyy");

                // 以下は同一西暦年にて元号が変わる場合の対応

                // 大晦日時点での元号が元旦時点のそれと異なる場合
                if (eraNameOfEndDay != eraNameOfStartDay)
                {
                    // コレクションに追加
                    arrYear.Add(y);
                    arrEraCode.Add(eraCodeOfEndDay);
                    arrEraName.Add(eraNameOfEndDay);
                }
            }

            // 戻り値の設定
            years = arrYear.ToArray();
            eraCodes = arrEraCode.ToArray();
            eraNames = arrEraName.ToArray();

            return arrYear.Count;
        }

        /// <summary>
        /// 指定した日付の元号を短縮形で表記した値で返します。
        /// </summary>
        /// <param name="d">日付</param>
        /// <returns>短縮形で表記された元号値</returns>
        /// <remarks></remarks>
        public static string GetShortEraName(DateTime d)
        {
            // 指定日付の元号インデックス値を取得
            int eraIndex = JapaneseCalendar.GetEra(d);

            string ret = "";

            // アルファベットを検索し、対応する元号インデックスが先のインデックス値と同一であればその値を返す
            for (var i = Strings.Asc("A"); i <= Strings.Asc("Z"); i++)
            {
                string eraName = Strings.Chr(i).ToString();
                if (JapaneseCulture.DateTimeFormat.GetEra(eraName) == eraIndex)
                {
                    ret = eraName;
                    break;
                }
            }

            return ret;
        }

        /// <summary>
        /// 指定した日付を日本語カルチャーでフォーマットした値を返します。
        /// </summary>
        /// <param name="d">日付</param>
        /// <param name="format">書式</param>
        /// <returns>フォーマット後の日付</returns>
        /// <remarks></remarks>
        public static string EraDateFormat(DateTime d, string format)
        {
            return d.ToString(format, JapaneseCulture);
        }

        /// <summary>
        /// 指定した文字列の、Shift-JIS形式でのバイト数を返します。
        /// </summary>
        /// <param name="expression">文字列</param>
        /// <returns>Shift-JIS形式でのバイト数</returns>
        public static int LenB(string expression)
        {
            return !string.IsNullOrEmpty(expression) ? Encoding.GetEncoding(932).GetBytes(expression).Length : 0;
        }
    }
}
