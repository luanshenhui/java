using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

namespace Fujitsu.Hainsi.WindowServices.RecvGanatsuResult
{
    /// <summary>
    /// 変換コード情報クラス
    /// </summary>
    public class CodeRevInfo
    {
        /// <summary>
        /// コード変換情報クラス
        /// </summary>
        [JsonObject("itemconv")]
        public class ItemConvInfo
        {
            /// <summary>
            /// コード変換詳細情報
            /// </summary>
            [JsonProperty("conv")]
            public List<ItemConvDetailInfo> ConvList { get; set; }
        }

        /// <summary>
        /// コード変換詳細情報クラス
        /// </summary>
        [JsonObject("conv")]
        public class ItemConvDetailInfo
        {
            /// <summary>
            /// 変換対象コード
            /// </summary>
            [JsonProperty("rItemCode")]
            public string TargetCode { get; set; }

            /// <summary>
            /// 変換後コード
            /// </summary>
            [JsonProperty("hainsItemCode")]
            public string ConvCode { get; set; }

        }

        /// <summary>
        /// コード変換情報ファイルを読み込む
        /// </summary>
        /// <returns>コード変換情報クラス</returns>
        public static CodeRevInfo ReadJsonFile()
        {
            // ファイルパスを編集する
            string fileName = Path.Combine(
                Path.GetDirectoryName(Assembly.GetEntryAssembly().Location),
                "CodeRev.json");

            // オブジェクトを生成する
            CodeRevInfo value = new CodeRevInfo();

            // コード変換情報ファイルのJSONデータを取得する
            using (StreamReader sr = new StreamReader(fileName, Encoding.UTF8))
            {
                string data = sr.ReadToEnd();
                value.ItemConvList = (List<ItemConvInfo>)JsonConvert.DeserializeObject<Dictionary<string, List<ItemConvInfo>>>(data)["itemconv"];
            }

            // オブジェクトを戻す
            return value;
        }

        /// <summary>
        ///コード変換情報
        /// </summary>
        private List<ItemConvInfo> ItemConvList { get; set; } = new List<ItemConvInfo>();

        /// <summary>
        /// 項目コードを変換する
        /// </summary>
        /// <param name="itemCd">変換前検査項目コード</param>
        /// <returns>変換後項目コード</returns>
        public string Convert(string itemCd)
        {

            // 変換情報を取得する
            foreach (ItemConvInfo item in ItemConvList)
            {
                foreach (ItemConvDetailInfo detailItem in item.ConvList)
                {

                    if (itemCd.Trim().Equals(detailItem.TargetCode))
                    {
                        return detailItem.ConvCode.Trim();
                    }

                }

            }

            // 変換情報に該当しなかった場合
            return "";
        }
    }
}
