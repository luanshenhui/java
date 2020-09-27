using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

namespace Fujitsu.Hainsi.WindowServices.SendKarteOrder
{

    /// <summary>
    /// データ変換クラス
    /// </summary>
    class ConvDataInfo
    {

        /// <summary>
        /// 変換情報ディクショナリ
        /// </summary>
        private Dictionary<string, ConvInfo> ConvDic { get; set; } = new Dictionary<string, ConvInfo>();

        /// <summary>
        /// 変換情報クラス
        /// </summary>
        [JsonObject("conv")]
        public class ConvInfo
        {
            /// <summary>
            /// 変換区分
            /// </summary>
            /// <remarks>ZAIRYO：材料変換, SHOUHOU：採取方法</remarks>
            [JsonProperty("kbn")]
            public string Kbn { get; set; }

            /// <summary>
            /// 変換区分名称
            /// </summary>
            [JsonProperty("kbnName")]
            public string KbnName { get; set; }

            /// <summary>
            /// 変換詳細情報クラス
            /// </summary>
            [JsonProperty("convdetail")]
            public List<ConvInfoDetail> ConvList { get; set; }

        }

        /// <summary>
        /// 変換詳細情報クラス
        /// </summary>
        [JsonObject("convdetail")]
        public class ConvInfoDetail
        {
            /// <summary>
            /// 変換元コード
            /// </summary>
            /// <remarks>材料：ZAICD(材料)、SAISYUCD(採取部位)、HOSOKUCD(補足)を"-"で結合。　採取方法：採取方法コード</remarks>
            [JsonProperty("befCode")]
            public string BefCode { get; set; }

            /// <summary>
            /// 変換コード
            /// </summary>
            [JsonProperty("convCode")]
            public string ConvCode { get; set; }

            /// <summary>
            /// 変換名称
            /// </summary>
            [JsonProperty("convName")]
            public string ConvName { get; set; }
        }

        /// <summary>
        /// 変換ファイルを読み込む
        /// </summary>
        /// <returns>変換情報クラス</returns>
        public static ConvDataInfo ReadJsonFile()
        {
            // ファイルパスを編集する
            string fileName = Path.Combine(
                Path.GetDirectoryName(Assembly.GetEntryAssembly().Location),
                "SendKarteOrderConv.json");

            // オブジェクトを生成する
            ConvDataInfo value = new ConvDataInfo();

            // 変換情報ファイルのJSONデータを取得する
            using (StreamReader sr = new StreamReader(fileName, Encoding.UTF8))
            {
                string data = sr.ReadToEnd();
                List<ConvInfo> tmpList 
                    = (List<ConvInfo>)JsonConvert.DeserializeObject<Dictionary<string, List<ConvInfo>>>(data)["conv"];

                foreach (ConvInfo item in tmpList)
                {
                    value.ConvDic.Add(item.Kbn, item);
                }
            }

            // オブジェクトを戻す
            return value;
        }

        /// <summary>
        /// 変換情報の取得
        /// </summary>
        /// <param name="kbn">変換区分</param>
        /// <param name="key">変換元コード</param>
        /// <returns></returns>
        public ConvInfoDetail GetItem(string kbn, string key)
        {
            // 詳細情報を検索して値を戻す
            foreach (var item in ConvDic[kbn].ConvList)
            {
                if (item.BefCode.Trim().Equals(key.Trim()))
                {
                    return item;
                }
            }
            return null;
        }

    }
}
