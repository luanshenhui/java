using System;
using System.Text;
using System.Text.RegularExpressions;
using Microsoft.VisualBasic;

namespace Hainsi.Common
{
    public class Util
    {
        /// <summary>
        /// 値を文字列に変換する、変換できない値であれば空欄を返す
        /// </summary>
        /// <param name="obj">変換前の値</param>
        /// <returns>返還後の文字列</returns>
        /// <remarks>CoReportsのフィールドにNullをセットするとエラーになるため当メソッド作成</remarks>
        public static string ConvertToString(dynamic obj)
        {
            return Convert.ToString(obj) ?? "";
        }

		/// <summary>
		/// 値をSJISのバイト列に変換する
		/// </summary>
		/// <param name="value">値</param>
		/// <returns>文字列をSJIS変換したバイト列</returns>
		public static byte[] ConvertToBytes(dynamic value)
		{
			// 文字列に変換
			string str = ConvertToString(value);

			// エンコードタイプをSJISにセット
			Encoding enc = Encoding.GetEncoding("Shift_JIS");

			// エンコードしたバイト列を返す
			return enc.GetBytes(str);
		}

        /// <summary>
        /// 文字列がすべて半角数字かどうかをチェックする
        /// </summary>
        /// <param name="value">文字列</param>
        /// <returns>結果</returns>
        public static bool IsNumber(string value)
        {
            return Regex.IsMatch(value, @"^[0-9]+$");
        }

        /// <summary>
        /// 文字列がすべて半角英数かどうかをチェックする
        /// </summary>
        /// <param name="value">文字列</param>
        /// <returns>結果</returns>
        public static bool IsAlphanumeric(string value)
        {
            return Regex.IsMatch(value, @"^[a-zA-Z0-9]+$");
        }

        /// <summary>
        /// 文字列がすべて半角文字かどうかをチェックする
        /// </summary>
        /// <param name="value">文字列</param>
        /// <returns>結果</returns>
        public static bool IsHalfword(string value)
        {
            return Regex.IsMatch(value, @"^[\x20-\x7F]+$");
        }

        /// <summary>
        /// 文字列変換し、半角全角スペースで区切った配列を返す
        /// </summary>
        /// <param name="value">文字列</param>
        /// <returns>スペースで区切った配列</returns>
        public static string[] SplitBySpase(object value)
        {
            return ConvertToString(value).Split(new string[] { " ", "　" }, StringSplitOptions.RemoveEmptyEntries);
        }

        /// <summary>
        /// 半角カナを全角カナに変換する
        /// </summary>
        /// <param name="expression">変換前の文字列</param>
        /// <returns>変換後の文字列</returns>
        public static string StrConvKanaWide(string expression)
        {
            string kanaString = ""; // 半角カナ文字列バッファ
            string convertedString = ""; // 変換後の文字列

            // 文字列検索開始
            foreach (var c in expression)
            {
                // 取得文字のASCIIコードを判定
                if (Strings.Asc(c) >= Strings.Asc("ｦ") && Strings.Asc(c) <= Strings.Asc("ﾟ"))
                {
                    // 半角カナ文字が連続している場合はカナ文字列として連結する
                    kanaString += c;
                }
                else
                {
                    // 半角カナ文字以外が現れたら
                    // カナ文字列バッファに値が存在する場合はバッファ内容を全角変換し、変換後文字列に連結する
                    if (kanaString.Length > 0)
                    {
                        convertedString += Strings.StrConv(kanaString, VbStrConv.Wide);
                        kanaString = "";
                    }

                    // 半角カナ以外の文字は単純に変換後の文字列に連結する
                    convertedString += c;
                }
            }

            // 全ての文字検索終了後、カナ文字列バッファに値が存在する場合はバッファ内容を全角変換し、変換後文字列に連結する
            if (kanaString.Length > 0)
            {
                convertedString += Strings.StrConv(kanaString, VbStrConv.Wide);
            }

            return convertedString;
        }
    }
}
