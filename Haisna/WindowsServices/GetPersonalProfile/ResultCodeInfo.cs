using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

namespace Fujitsu.Hainsi.WindowServices.GetPersonalProfile
{
    /// <summary>
    /// 結果コード情報クラス
    /// </summary>
    public class ResultCodeInfo
    {
        /// <summary>
        /// 結果コード変換情報クラス
        /// </summary>
        [JsonObject("result")]
        public class ResultConvInfo
        {
            /// <summary>
            /// 結果コード変換項目情報
            /// </summary>
            [JsonProperty("item")]
            public List<ResultConvItemInfo> ItemList { get; set; }

            /// <summary>
            /// 結果コード変換詳細情報
            /// </summary>
            [JsonProperty("conv")]
            public List<ResultConvDetailInfo> ConvList { get; set; }
        }

        /// <summary>
        /// 結果コード変換項目情報クラス
        /// </summary>
        [JsonObject("item")]
        public class ResultConvItemInfo
        {
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
            /// 説明
            /// </summary>
            [JsonProperty("description")]
            public string Description { get; set; }
        }

        /// <summary>
        /// 結果コード変換詳細情報クラス
        /// </summary>
        [JsonObject("conv")]
        public class ResultConvDetailInfo
        {
            /// <summary>
            /// 変換対象結果コード
            /// </summary>
            [JsonProperty("target")]
            public string TargetCode { get; set; }

            /// <summary>
            /// 変換後結果コード
            /// </summary>
            [JsonProperty("conv")]
            public string ConvCode { get; set; }
        }

        /// <summary>
        /// 結果コード情報ファイルを読み込む
        /// </summary>
        /// <returns>結果コード情報クラス</returns>
        public static ResultCodeInfo ReadJsonFile()
        {
            // ファイルパスを編集する
            string fileName = Path.Combine(
                Path.GetDirectoryName(Assembly.GetEntryAssembly().Location),
                "GetPersonalProfileResultCode.json");

            // オブジェクトを生成する
            ResultCodeInfo value = new ResultCodeInfo();

            // 結果コード情報ファイルのJSONデータを取得する
            using (StreamReader sr = new StreamReader(fileName, Encoding.UTF8))
            {
                string data = sr.ReadToEnd();
                value.ResultList = (List<ResultConvInfo>)JsonConvert.DeserializeObject<Dictionary<string, List<ResultConvInfo>>>(data)["result"];
            }

            // オブジェクトを戻す
            return value;
        }

        /// <summary>
        /// 結果コード情報
        /// </summary>
        private List<ResultConvInfo> ResultList { get; set; } = new List<ResultConvInfo>();

        /// <summary>
        /// 結果コードを変換する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="resultCode">変換前結果コード</param>
        /// <returns>変換後結果コード</returns>
        public string Convert(string itemCd, string suffix, string resultCode)
        {
            // 検査項目コード毎の変換情報
            ResultConvInfo itemCdConvInfo = null;

            // 全検査項目コード共通の変換情報
            ResultConvInfo otherConvInfo = null;

            // 変換情報を取得する
            foreach (ResultConvInfo item in ResultList)
            {
                foreach (ResultConvItemInfo detailItem in item.ItemList)
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
                foreach (ResultConvDetailInfo item in itemCdConvInfo.ConvList)
                {
                    if (resultCode.Trim().Equals(item.TargetCode))
                    {
                        // 変換情報に該当した場合は変換後コードを戻す
                        return item.ConvCode == null ? "" : item.ConvCode.Trim();
                    }
                }
            }

            // 全検査項目コード共通の変換情報
            if (otherConvInfo != null)
            {
                foreach (ResultConvDetailInfo item in otherConvInfo.ConvList)
                {
                    if (resultCode.Trim().Equals(item.TargetCode))
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
