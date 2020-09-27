using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

namespace Fujitsu.Hainsi.WindowServices.GetKarteRiyosha
{
    /// <summary>
    /// CSV項目情報クラス
    /// </summary>
    public class CsvFieldInfo
    {
        /// <summary>
        /// CSV項目クラス
        /// </summary>
        [JsonObject("item")]
        public class CsvFieldItem
        {
            /// <summary>
            /// データタイプ
            /// </summary>
            public enum DataTypeConstants
            {
                /// <summary>
                /// 文字列
                /// </summary>
                @string = 1,

                /// <summary>
                /// 数値
                /// </summary>
                numeric = 2,
            }

            /// <summary>
            /// インデックス
            /// </summary>
            [JsonProperty("index")]
            public int Index { get; set; }

            /// <summary>
            /// 項目名
            /// </summary>
            [JsonProperty("nameja")]
            public string NameJa { get; set; }

            /// <summary>
            /// データ項目名
            /// </summary>
            [JsonProperty("nameen")]
            public string NameEn { get; set; }

            /// <summary>
            /// データタイプ
            /// </summary>
            [JsonProperty("type")]
            public DataTypeConstants Type { get; set; }

            /// <summary>
            /// 使用フラグ
            /// </summary>
            [JsonProperty("useflg")]
            public int UseFlg { get; set; }

            /// <summary>
            /// 空白設定フラグ
            /// </summary>
            [JsonProperty("spaceflg")]
            public int SpaceFlg { get; set; }

            /// <summary>
            /// 設定値
            /// </summary>
            [JsonProperty("values")]
            public string[] Values { get; set; }
        }

        /// <summary>
        /// CSV項目ファイルを読み込む
        /// </summary>
        /// <returns>CSV項目クラス</returns>
        public static CsvFieldInfo ReadJsonFile()
        {
            // ファイルパスを編集する
            string fileName = Path.Combine(
                Path.GetDirectoryName(Assembly.GetEntryAssembly().Location),
                "GetKarteRiyosha.json");

            // オブジェクトを生成する
            var value = new CsvFieldInfo();

            // CSV項目クラスのJSONデータを取得する
            using (StreamReader sr = new StreamReader(fileName, Encoding.UTF8))
            {
                string data = sr.ReadToEnd();
                value.Items = (List<CsvFieldItem>)JsonConvert.DeserializeObject<Dictionary<string, List<CsvFieldItem>>>(data)["item"];
            }

            // オブジェクトを戻す
            return value;
        }

        /// <summary>
        /// CSV項目定義
        /// </summary>
        public List<CsvFieldItem> Items { get; set; } = new List<CsvFieldItem>();
    }
}
