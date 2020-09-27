using System.Text;

namespace Fujitsu.Hainsi.WindowServices.Common
{
    public static class Strings
    {
        private static readonly Encoding enc = Encoding.GetEncoding("shift_jis");

        /// <summary>
        /// 対象文字列に対して指定バイト数に達するように、末尾に半角空白を付加する。
        /// </summary>
        /// <param name="input">対象文字列</param>
        /// <param name="byteLen">編集後バイト数</param>
        public static string PadRightEx(this string input, int byteLen)
        {
            StringBuilder output = new StringBuilder();

            for (int i = 1; i <= input.Length; i++)
            {
                string currString = input.Substring(i - 1, 1);
                if (enc.GetByteCount(output.ToString() + currString) > byteLen)
                {
                    break;
                }
                output.Append(currString);
            }

            int spaceCount = byteLen - enc.GetByteCount(output.ToString());
            if (spaceCount > 0)
            {
                output.Append(new string(' ', spaceCount));
            }

            return output.ToString();
        }

        /// <summary>
        /// 対象文字列に対して指定バイト数に達するように、先頭に半角空白を付加する。
        /// </summary>
        /// <param name="input">対象文字列</param>
        /// <param name="byteLen">編集後バイト数</param>
        public static string PadLeftEx(this string input, int byteLen)
        {
            StringBuilder output = new StringBuilder();

            for (int i = input.Length; i >= 1; i--)
            {
                string currString = input.Substring(i - 1, 1);
                if (enc.GetByteCount(output.ToString() + currString) > byteLen)
                {
                    break;
                }
                output.Insert(0, currString);
            }

            int spaceCount = byteLen - enc.GetByteCount(output.ToString());
            if (spaceCount > 0)
            {
                output.Insert(0, new string(' ', spaceCount));
            }

            return output.ToString();
        }

        /// <summary>
        /// 対象文字列のバイト数を取得する。
        /// </summary>
        /// <param name="input">対象文字列</param>
        /// <param name="byteLen">バイト数</param>
        public static int GetByteCount(this string input)
        {
            return enc.GetByteCount(input);
        }

        /// <summary>
        /// 対象文字列のバイト配列を取得する。
        /// </summary>
        /// <param name="input">対象文字列</param>
        /// <param name="byteLen">バイト数</param>
        public static byte[] GetBytes(this string input)
        {
            return enc.GetBytes(input);
        }

        /// <summary>
        /// 対象データを文字列に変換する。
        /// </summary>
        /// <param name="input">対象データ</param>
        public static string ConvertToString(this byte[] input)
        {
            return enc.GetString(input);
        }

        /// <summary>
        /// 対象データの指定した部分を文字列に変換する。
        /// </summary>
        /// <param name="input">対象データ</param>
        /// <param name="index">開始位置</param>
        /// <param name="count">バイト数</param>
        public static string ConvertToString(this byte[] input, int index, int count)
        {
            return enc.GetString(input, index, count);
        }

        /// <summary>
        /// 対象文字列の先頭から指定したバイト数分を切り出す。
        /// </summary>
        /// <param name="input">対象文字列</param>
        /// <param name="byteLen">バイト数</param>
        public static string CutLeft(this string input, int byteLen)
        {
            StringBuilder output = new StringBuilder();

            for (int i = 1; i <= input.Length; i++)
            {
                string currString = input.Substring(i - 1, 1);
                if (enc.GetByteCount(output.ToString() + currString) > byteLen)
                {
                    break;
                }
                output.Append(currString);
            }

            return output.ToString();
        }

        /// <summary>
        /// 対象文字列の開始位置から指定したバイト数分を切り出す。
        /// </summary>
        /// <param name="input">対象文字列</param>
        /// <param name="index">開始位置(先頭:1)</param>
        /// <param name="byteLen">バイト数</param>
        public static string SubstringEx(this string input, int index, int byteLen)
        {
            // 対象文字列のバイト数を取得する
            int length = enc.GetByteCount(input);

            // 開始位置がバイト数に満たない場合
            if (length < index)
            {
                return "";
            }

            // 対象文字列を切り出す
            return enc.GetString(
                enc.GetBytes(input), index, 
                System.Math.Min(byteLen, length - index));
        }
    }
}
