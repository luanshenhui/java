using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http;

namespace ConnectKetsuatsu
{
    class QueryParamBuilder
    {
        private List<KeyValuePair<string, string>> PostData { get; set; }

        /// <summary>
        /// コンストラクタ
        /// </summary>
        public QueryParamBuilder()
        {
            PostData = new List<KeyValuePair<string, string>>();
        }

        /// <summary>
        /// POSTデータを追加する
        /// </summary>
        /// <param name="key">キー</param>
        /// <param name="value">値</param>
        /// <returns>自身を返す</returns>
        public QueryParamBuilder Add(string key, string value)
        {
            PostData.Add(new KeyValuePair<string, string>(key, value));
            return this;
        }

        /// <summary>
        /// POSTデータを作成する
        /// </summary>
        /// <returns>POSTデータ</returns>
        public FormUrlEncodedContent Build()
        {
            return new FormUrlEncodedContent(PostData);
        }
    }
}
