using System;
using System.Collections.Specialized;

namespace ConnMeasuringEquipments
{
    class Utility
    {

        /// <summary>
        /// URLクエリーストリングをキーと値のペアに分割する
        /// ※ .Net Framework 4.0 Client Profile の場合 System.Web が使えないため
        /// </summary>
        /// <param name="query">クエリー文字列</param>
        /// <returns>クエリー文字列のNameValueCollection</returns>
        public static NameValueCollection ParseQueryString(string query)
        {
            var ret = new NameValueCollection();

            // &区切りで分割した数分Loop
            foreach (string pair in query.Split('&'))
            {
                // =で文字列分割
                string[] kv = pair.Split('=');

                // key名を抽出
                string key = kv.Length == 1
                  ? null : Uri.UnescapeDataString(kv[0]).Replace('+', ' ');

                // 値を抽出
                string[] values = Uri.UnescapeDataString(
                  kv.Length == 1 ? kv[0] : kv[1]).Replace('+', ' ').Split(',');

                // keyが空白でない場合、key+値のセットを配列に追加。
                foreach (string value in values)
                {
                    if (!String.IsNullOrEmpty(key))
                    {
                        // keyは小文字にしてセット（値は加工しない）
                        ret.Add(key.ToLower(), value);
                    }
                }
            }
            return ret;
        }


    }
}
