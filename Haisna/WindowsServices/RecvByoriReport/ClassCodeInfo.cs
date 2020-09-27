using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

namespace Fujitsu.Hainsi.WindowServices.RecvByoriReport
{
    /// <summary>
    /// 細胞診結果情報クラス
    /// </summary>
    public class ClassCodeInfo
    {
        /// <summary>
        /// 細胞診結果情報クラス
        /// </summary>
        [JsonObject("class")]
        public class ClassInfo
        {
            /// <summary>
            /// オーダ種別
            /// </summary>
            [JsonProperty("orderdiv")]
            public string OrderDiv { get; set; }

            /// <summary>
            /// オーダ種別名
            /// </summary>
            [JsonProperty("orderdivname")]
            public string OrderDivName { get; set; }

            /// <summary>
            /// 細胞診結果詳細情報クラス
            /// </summary>
            [JsonProperty("item")]
            public List<ClassItemInfo> ItemList { get; set; }
        }

        /// <summary>
        /// 細胞診結果詳細情報クラス
        /// </summary>
        [JsonObject("item")]
        public class ClassItemInfo
        {
            /// <summary>
            /// 対象データ
            /// </summary>
            [JsonProperty("source")]
            public string Source { get; set; }

            /// <summary>
            /// 検査結果
            /// </summary>
            [JsonProperty("result")]
            public string Result { get; set; }

            /// <summary>
            /// クラス名
            /// </summary>
            [JsonProperty("classname")]
            public string ClassName { get; set; }

            /// <summary>
            /// 順番
            /// </summary>
            [JsonProperty("seq")]
            public int Seq { get; set; }
        }

        /// <summary>
        /// 細胞診結果情報ファイルを読み込む
        /// </summary>
        /// <returns>細胞診結果情報クラス</returns>
        public static ClassCodeInfo ReadJsonFile()
        {
            // ファイルパスを編集する
            string fileName = Path.Combine(
                Path.GetDirectoryName(Assembly.GetEntryAssembly().Location),
                "RecvByoriReportClass.json");

            // オブジェクトを生成する
            ClassCodeInfo value = new ClassCodeInfo();

            // 細胞診結果情報ファイルのJSONデータを取得する
            using (StreamReader sr = new StreamReader(fileName, Encoding.UTF8))
            {
                string data = sr.ReadToEnd();
                List<ClassInfo> tmpList = (List<ClassInfo>)JsonConvert.DeserializeObject<Dictionary<string, List<ClassInfo>>>(data)["class"];

                foreach (ClassInfo item in tmpList)
                {
                    value.ClassDic.Add(item.OrderDiv, item);
                }
            }

            // オブジェクトを戻す
            return value;
        }

        /// <summary>
        /// 細胞診結果情報
        /// </summary>
        private Dictionary<string, ClassInfo> ClassDic { get; set; } = new Dictionary<string, ClassInfo>();

        /// <summary>
        /// オーダ種別に一致する細胞診結果詳細情報を返す
        /// </summary>
        /// <param name="orderDiv">オーダ種別</param>
        /// <returns>細胞診結果詳細情報</returns>
        public List<ClassItemInfo> GetItems(string orderDiv)
        {
            return ClassDic[orderDiv].ItemList;
        }

        /// <summary>
        /// オーダ種別／対象データに一致する細胞診結果詳細情報を返す
        /// </summary>
        /// <param name="orderDiv">オーダ種別</param>
        /// <param name="source">対象データ</param>
        /// <returns>細胞診結果詳細情報</returns>
        public ClassItemInfo FindItem(string orderDiv, string source)
        {
            // 対象データ内の改行コードと除去する
            source = source.Replace("\r", "").Replace("\n", "");

            // 細胞診結果詳細情報を検索する
            foreach (var item in ClassDic[orderDiv].ItemList)
            {
                if (item.Source.Trim().Equals(source.Trim()))
                {
                    return item;
                }
            }

            return null;
        }

        /// <summary>
        /// オーダ種別／対象データに一致する細胞診結果詳細情報の順番を返す
        /// </summary>
        /// <param name="orderDiv">オーダ種別</param>
        /// <param name="source">対象データ</param>
        /// <returns>細胞診結果詳細情報の順番</returns>
        public int FindItemSeq(string orderDiv, string source)
        {
            if (string.IsNullOrEmpty(source))
            {
                return 0;
            }

            // 細胞診結果詳細情報を検索する
            foreach (var item in ClassDic[orderDiv].ItemList)
            {
                if (item.Result.Trim().Equals(source.Trim()))
                {
                    return item.Seq;
                }
            }

            return 0;
        }
    }
}
