using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

namespace Fujitsu.Hainsi.WindowServices.RecvMyakuhaResult
{
    /// <summary>
    /// CSV情報クラス
    /// </summary>
    public class CodeRevInfo
    {

        /// <summary>
        /// ヘッダ情報クラス
        /// </summary>
        [JsonObject("header")]
        public class ItemHeaderInfo
        {
            /// <summary>
            /// インデックス
            /// </summary>
            [JsonProperty("index")]
            public string index { get; set; }

            /// <summary>
            /// 項目名
            /// </summary>
            [JsonProperty("name")]
            public string name { get; set; }

            /// <summary>
            /// パラメータ名
            /// </summary>
            [JsonProperty("param")]
            public string paramName { get; set; }

        }

        /// <summary>
        /// 取込対象項目情報クラス
        /// </summary>
        [JsonObject("item")]
        public class ItemDetailInfo
        {
            /// <summary>
            /// インデックス
            /// </summary>
            [JsonProperty("index")]
            public string index { get; set; }

            /// <summary>
            /// 項目名
            /// </summary>
            [JsonProperty("name")]
            public string name { get; set; }

            /// <summary>
            /// パラメータ名
            /// </summary>
            [JsonProperty("param")]
            public string paramName { get; set; }

            /// <summary>
            /// 盲目コード
            /// </summary>
            [JsonProperty("itemcd")]
            public string itemCd { get; set; }
        }

        /// <summary>
        /// 受診者情報(ヘッダ)ファイルを読み込む
        /// </summary>
        /// <returns>受診者情報クラス</returns>
        public static CodeRevInfo ReadJsonFile()
        {
            // ファイルパスを編集する
            string fileName = Path.Combine(
                Path.GetDirectoryName(Assembly.GetEntryAssembly().Location),
                "CodeRev.json");

            // オブジェクトを生成する
            CodeRevInfo value = new CodeRevInfo();

            // 受診者情報ファイルのJSONデータを取得する
            using (StreamReader sr = new StreamReader(fileName, Encoding.UTF8))
            {
                string data = sr.ReadToEnd();
                value.ItemHeaderList = (List<ItemHeaderInfo>)JsonConvert.DeserializeObject<Dictionary<string, List<ItemHeaderInfo>>>(data)["header"];
            }

            // オブジェクトを戻す
            return value;
        }

        /// <summary>
        /// 結果情報ファイルを読み込む
        /// </summary>
        /// <returns>結果情報クラス</returns>
        public static CodeRevInfo ReadJsonFileDetail()
        {
            // ファイルパスを編集する
            string fileName = Path.Combine(
                Path.GetDirectoryName(Assembly.GetEntryAssembly().Location),
                "CodeRev.json");

            // オブジェクトを生成する
            CodeRevInfo value = new CodeRevInfo();

            // 結果情報ファイルのJSONデータを取得する
            using (StreamReader sr = new StreamReader(fileName, Encoding.UTF8))
            {
                string data = sr.ReadToEnd();
                value.ItemDetailList = (List<ItemDetailInfo>)JsonConvert.DeserializeObject<Dictionary<string, List<ItemDetailInfo>>>(data)["item"];
            }

            // オブジェクトを戻す
            return value;
        }

        /// <summary>
        ///受診者情報
        /// </summary>
        private List<ItemHeaderInfo> ItemHeaderList { get; set; } = new List<ItemHeaderInfo>();
        
        /// <summary>
        ///結果情報
        /// </summary>
        public List<ItemDetailInfo> ItemDetailList { get; set; } = new List<ItemDetailInfo>();

        /// <summary>
        /// ヘッダ情報で指定したパラメータのインデックスを取得する。
        /// </summary>
        /// <param name="param">項目識別パラメータ</param>
        /// <returns>インデックス</returns>
        public string GetHeaderInfoIndex(string param)
        {

            // インデックスを取得する
            foreach (ItemHeaderInfo item in ItemHeaderList)
            {
                if (param.Trim().Equals(item.paramName))
                {
                    return item.index.Trim();
                }

            }

            // 該当しなかった場合
            return "";
        }
    }
}
