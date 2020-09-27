using System.Text;

namespace Hainsi.SendOrder
{
    /// <summary>
    /// 文字列データ操作クラス
    /// </summary>
    public static class Strings
    {
        private static readonly Encoding enc = Encoding.GetEncoding("shift_jis");

        /// <summary>
        /// 対象文字列に対して指定バイト数に達するように、末尾に半角空白を付加する
        /// </summary>
        /// <param name="source">対象文字列</param>
        /// <param name="byteLen">編集後バイト数</param>
        public static string PadRightEx(string source, int byteLen)
        {
            var output = new StringBuilder();

            for (var i = 1; i <= source.Length; i++)
            {
                var currString = source.Substring(i - 1, 1);
                if (enc.GetByteCount(output.ToString() + currString) > byteLen)
                {
                    break;
                }
                output.Append(currString);
            }

            var spaceCount = byteLen - enc.GetByteCount(output.ToString());
            if (spaceCount > 0)
            {
                output.Append(new string(' ', spaceCount));
            }

            return output.ToString();
        }

        /// <summary>
        /// 対象文字列に対して指定バイト数に達するように、先頭に半角空白を付加する
        /// </summary>
        /// <param name="source">対象文字列</param>
        /// <param name="byteLen">編集後バイト数</param>
        public static string PadLeftEx(string source, int byteLen)
        {
            var output = new StringBuilder();

            for (var i = source.Length; i >= 1; i--)
            {
                var currString = source.Substring(i - 1, 1);
                if (enc.GetByteCount(output.ToString() + currString) > byteLen)
                {
                    break;
                }
                output.Insert(0, currString);
            }

            var spaceCount = byteLen - enc.GetByteCount(output.ToString());
            if (spaceCount > 0)
            {
                output.Insert(0, new string(' ', spaceCount));
            }

            return output.ToString();
        }

        /// <summary>
        /// 対象文字列のバイト数を取得する
        /// </summary>
        /// <param name="source">対象文字列</param>
        public static int GetByteCount(string source)
        {
            return enc.GetByteCount(source);
        }

        /// <summary>
        /// 対象文字列のバイト配列を取得する
        /// </summary>
        /// <param name="source">対象文字列</param>
        public static byte[] GetBytes(string source)
        {
            return enc.GetBytes(source);
        }

        /// <summary>
        /// 対象データを文字列に変換する
        /// </summary>
        /// <param name="source">対象データ</param>
        public static string ConvertToString(byte[] source)
        {
            return enc.GetString(source);
        }

        /// <summary>
        /// 対象文字列の開始位置から指定したバイト数分を切り出す
        /// </summary>
        /// <param name="source">対象文字列</param>
        /// <param name="index">開始位置（先頭:1）</param>
        /// <param name="byteLen">バイト数（-1の場合は指定した開始位置以降の全て）</param>
        public static string SubstringEx(string source, int index, int byteLen = -1)
        {
            // 対象文字列のバイト数を取得する
            var length = enc.GetByteCount(source);

            // 開始位置が0未満の場合
            if (index < 0)
            {
                return "";
            }

            // 開始位置がバイト数に満たない場合
                if (length < index)
            {
                return "";
            }

            // 対象文字列を切り出す
            if (byteLen >= 0)
            {
                return enc.GetString(
                    enc.GetBytes(source), index - 1,
                    System.Math.Min(byteLen, length - (index - 1)));
            }
            else
            {
                return enc.GetString(
                    enc.GetBytes(source), index - 1, length - (index - 1));
            }
        }

        /// <summary>
        /// 対象文字列の開始位置以降の部分を指定文字列で置き換える
        /// </summary>
        /// <param name="source">対象文字列</param>
        /// <param name="index">開始位置（先頭:1）</param>
        /// <param name="replaceString">置換文字列</param>
        public static string ReplaceEx(string source, int index, string replaceString)
        {
            return ((index > 1) ? SubstringEx(source, 1, index - 1) : "") +
                replaceString + SubstringEx(source, index + GetByteCount(replaceString));
        }
    }
}
