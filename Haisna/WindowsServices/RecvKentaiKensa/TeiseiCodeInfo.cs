using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

namespace Fujitsu.Hainsi.WindowServices.RecvKentaiKensa
{
    /// <summary>
    /// 定性コード情報クラス
    /// </summary>
    public class TeiseiCodeInfo
    {
        /// <summary>
        /// 定性コード変換情報クラス
        /// </summary>
        [JsonObject("teisei")]
        public class TeiseiConvInfo
        {
            /// <summary>
            /// 定性コード変換項目情報
            /// </summary>
            [JsonProperty("item")]
            public List<TeiseiConvItemInfo> ItemList { get; set; }

            /// <summary>
            /// 定性コード変換詳細情報
            /// </summary>
            [JsonProperty("conv")]
            public List<TeiseiConvDetailInfo> ConvList { get; set; }
        }

        /// <summary>
        /// 定性コード変換項目情報クラス
        /// </summary>
        [JsonObject("item")]
        public class TeiseiConvItemInfo
        {
            /// <summary>
            /// 検査項目コード
            /// </summary>
            [JsonProperty("itemcd")]
            public string ItemCd { get; set; }

            /// <summary>
            /// 説明
            /// </summary>
            [JsonProperty("description")]
            public string Description { get; set; }
        }

        /// <summary>
        /// 定性コード変換詳細情報クラス
        /// </summary>
        [JsonObject("conv")]
        public class TeiseiConvDetailInfo
        {
            /// <summary>
            /// 変換対象定性コード
            /// </summary>
            [JsonProperty("target")]
            public string TargetCode { get; set; }

            /// <summary>
            /// 変換後定性コード
            /// </summary>
            [JsonProperty("conv")]
            public string ConvCode { get; set; }
        }

        /// <summary>
        /// 定性コード情報ファイルを読み込む
        /// </summary>
        /// <returns>定性コード情報クラス</returns>
        public static TeiseiCodeInfo ReadJsonFile()
        {
            // ファイルパスを編集する
            string fileName = Path.Combine(
                Path.GetDirectoryName(Assembly.GetEntryAssembly().Location),
                "TeiseiCode.json");

            // オブジェクトを生成する
            TeiseiCodeInfo value = new TeiseiCodeInfo();

            // 定性コード情報ファイルのJSONデータを取得する
            using (StreamReader sr = new StreamReader(fileName, Encoding.UTF8))
            {
                string data = sr.ReadToEnd();
                value.TeiseiList = (List<TeiseiConvInfo>)JsonConvert.DeserializeObject<Dictionary<string, List<TeiseiConvInfo>>>(data)["teisei"];
            }

            // オブジェクトを戻す
            return value;
        }

        /// <summary>
        /// 定性コード情報
        /// </summary>
        private List<TeiseiConvInfo> TeiseiList { get; set; } = new List<TeiseiConvInfo>();

        /// <summary>
        /// 定性コードを変換する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="teiseiCode">変換前定性コード</param>
        /// <returns>変換後定性コード</returns>
        public string Convert(string itemCd, string targetTeiseiCode)
        {
            // 検査項目コード毎の変換情報
            TeiseiConvInfo itemCdConvInfo = null;

            // 全検査項目コード共通の変換情報
            TeiseiConvInfo otherConvInfo = null;

            // 変換情報を取得する
            foreach (TeiseiConvInfo item in TeiseiList)
            {
                foreach (TeiseiConvItemInfo detailItem in item.ItemList)
                {
                    // 検査項目コード毎の変換情報
                    if (itemCdConvInfo == null && itemCd.Equals(detailItem.ItemCd))
                    {
                        itemCdConvInfo = item;
                    }

                    // 全検査項目コード共通の変換情報
                    if (otherConvInfo == null && string.IsNullOrEmpty(detailItem.ItemCd))
                    {
                        otherConvInfo = item;
                    }

                    // 両方の変換情報が見つかった場合は処理を終了する
                    if (itemCdConvInfo != null && otherConvInfo != null)
                    {
                        break;
                    }
                }

                // 両方の変換情報が見つかった場合は処理を終了する
                if (itemCdConvInfo != null && otherConvInfo != null)
                {
                    break;
                }
            }

            // 検査項目コード毎の変換情報
            if (itemCdConvInfo != null)
            {
                foreach (TeiseiConvDetailInfo item in itemCdConvInfo.ConvList)
                {
                    if (targetTeiseiCode.Trim().Equals(item.TargetCode))
                    {
                        // 変換情報に該当した場合は変換後コードを戻す
                        return item.ConvCode == null ? "" : item.ConvCode.Trim();
                    }
                }
            }

            // 全検査項目コード共通の変換情報
            if (otherConvInfo != null)
            {
                foreach (TeiseiConvDetailInfo item in otherConvInfo.ConvList)
                {
                    if (targetTeiseiCode.Trim().Equals(item.TargetCode))
                    {
                        // 変換情報に該当した場合は変換後コードを戻す
                        return item.ConvCode == null ? "" : item.ConvCode.Trim();
                    }
                }
            }

            // 変換情報に該当しなかった場合
            return "";
        }
    }
}
