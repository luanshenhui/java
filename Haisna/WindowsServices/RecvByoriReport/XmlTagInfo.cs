using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

namespace Fujitsu.Hainsi.WindowServices.RecvByoriReport
{
    /// <summary>
    /// XMLタグ情報クラス
    /// </summary>
    public class XmlTagInfo
    {
        /// <summary>
        /// XMLタグ情報クラス
        /// </summary>
        [JsonObject("xmltag")]
        public class XmlInfo
        {
            /// <summary>
            /// タグ
            /// </summary>
            [JsonProperty("tag")]
            public string Tag { get; set; }

            /// <summary>
            /// タグ名
            /// </summary>
            [JsonProperty("tagname")]
            public string TagName { get; set; }

            /// <summary>
            /// XMLタグ詳細情報クラス
            /// </summary>
            [JsonProperty("item")]
            public List<XmlItemInfo> ItemList { get; set; }
        }

        /// <summary>
        /// XMLタグ詳細情報クラス
        /// </summary>
        [JsonObject("item")]
        public class XmlItemInfo
        {
            /// <summary>
            /// 属性名
            /// </summary>
            [JsonProperty("attrname")]
            public string AttrName { get; set; }

            /// <summary>
            /// 検査項目コード
            /// </summary>
            [JsonProperty("itemcd")]
            public string ItemCd { get; set; }

            /// <summary>
            /// サフィックス
            /// </summary>
            [JsonProperty("suffix")]
            public string Suffix { get; set; }

            /// <summary>
            /// コード変換フラグ
            /// </summary>
            [JsonProperty("codeconvflg")]
            public int CodeConvFlg { get; set; }
        }

        /// <summary>
        /// XMLタグ情報ファイルを読み込む
        /// </summary>
        /// <returns>XMLタグ情報クラス</returns>
        public static XmlTagInfo ReadJsonFile()
        {
            // ファイルパスを編集する
            string fileName = Path.Combine(
                Path.GetDirectoryName(Assembly.GetEntryAssembly().Location),
                "RecvByoriReportXmlTag.json");

            // オブジェクトを生成する
            XmlTagInfo value = new XmlTagInfo();

            // XMLタグ情報ファイルのJSONデータを取得する
            using (StreamReader sr = new StreamReader(fileName, Encoding.UTF8))
            {
                string data = sr.ReadToEnd();
                List<XmlInfo> tmpList = (List<XmlInfo>)JsonConvert.DeserializeObject<Dictionary<string, List<XmlInfo>>>(data)["xmltag"];

                foreach (XmlInfo item in tmpList)
                {
                    value.XmlTagDic.Add(item.Tag, item);
                }
            }

            // オブジェクトを戻す
            return value;
        }

        /// <summary>
        /// XMLタグ情報
        /// </summary>
        private Dictionary<string, XmlInfo> XmlTagDic { get; set; } = new Dictionary<string, XmlInfo>();

        /// <summary>
        /// タグに一致するXMLタグ詳細情報を返す
        /// </summary>
        /// <param name="tag">タグ</param>
        /// <returns>XMLタグ詳細情報</returns>
        public List<XmlItemInfo> GetItems(string tag)
        {
            return XmlTagDic[tag].ItemList;
        }
    }
}
