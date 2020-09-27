using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

namespace Hainsi.SendOrder
{
    /// <summary>
    /// 病理ラベル印刷設定情報クラス
    /// </summary>
    public class ByoriLabelSettingInfo
    {
        /// <summary>
        /// 病理ラベル情報クラス
        /// </summary>
        [JsonObject("byorilabel")]
        public class ByoriLabelInfo
        {
            /// <summary>
            /// キー
            /// </summary>
            [JsonProperty("key")]
            public string Key { get; set; }

            /// <summary>
            /// 説明
            /// </summary>
            [JsonProperty("description")]
            public string Description { get; set; }

            /// <summary>
            /// 出力先プリンタ名
            /// </summary>
            [JsonProperty("printer")]
            public PrinterInfo[] Printers { get; set; }
        }

        /// <summary>
        /// プリンタ情報クラス
        /// </summary>
        [JsonObject("printer")]
        public class PrinterInfo
        {
            /// <summary>
            /// 部屋ID
            /// </summary>
            [JsonProperty("roomid")]
            public string RoomId { get; set; }

            /// <summary>
            /// 説明
            /// </summary>
            [JsonProperty("description")]
            public string Description { get; set; }

            /// <summary>
            /// 出力先プリンタ名
            /// </summary>
            [JsonProperty("printername")]
            public string PrinterName { get; set; }
        }

        /// <summary>
        /// 病理ラベル印刷設定情報ファイルを読み込む
        /// </summary>
        /// <returns>病理ラベル印刷設定情報クラス</returns>
        public static ByoriLabelSettingInfo ReadJsonFile()
        {
            // ファイルパスを編集する
            var fileName = Path.Combine(
                Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location),
                "ByoriLabelSetting.json");

            // オブジェクトを生成する
            var value = new ByoriLabelSettingInfo();

            // 病理ラベル印刷設定情報ファイルのJSONデータを取得する
            using (var sr = new StreamReader(fileName, Encoding.UTF8))
            {
                var data = sr.ReadToEnd();

                // 病理ラベル情報
                var tmpByoriLabelList = (List<ByoriLabelInfo>)JsonConvert.DeserializeObject<Dictionary<string, List<ByoriLabelInfo>>>(data)["byorilabel"];
                foreach (var item in tmpByoriLabelList)
                {
                    if (item.Key.Equals("KAKUTAN"))
                    {
                        // 病理ラベル（喀痰）
                        value.KakutanInfo = item;
                    }
                    else if (item.Key.Equals("FUJINKA"))
                    {
                        // 病理ラベル（婦人科）
                        value.FujinkaInfo = item;
                    }
                }
            }

            // オブジェクトを戻す
            return value;
        }

        /// <summary>
        /// 病理ラベル（喀痰）
        /// </summary>
        private ByoriLabelInfo KakutanInfo { get; set; } = null;

        /// <summary>
        /// 病理ラベル（婦人科）
        /// </summary>
        private ByoriLabelInfo FujinkaInfo { get; set; } = null;

        /// <summary>
        /// 喀痰検査について部屋IDに一致するプリンタ名を返す
        /// </summary>
        /// <param name="roomId">部屋ID</param>
        /// <returns>プリンタ名</returns>
        public string GetPrinterNameForKakutan(string roomId)
        {
            return GetPrinterNameMain(roomId, KakutanInfo);
        }

        /// <summary>
        /// 婦人科検査について部屋IDに一致するプリンタ名を返す
        /// </summary>
        /// <param name="roomId">部屋ID</param>
        /// <returns>プリンタ名</returns>
        public string GetPrinterNameForFujinka(string roomId)
        {
            return GetPrinterNameMain(roomId, FujinkaInfo);
        }

        /// <summary>
        /// 部屋IDに一致するプリンタ名を返す
        /// </summary>
        /// <param name="roomId">部屋ID</param>
        /// <param name="info">病理ラベル情報</param>
        /// <returns>プリンタ名</returns>
        private string GetPrinterNameMain(string roomId, ByoriLabelInfo info)
        {
            if (info == null ||
                info.Printers == null ||
                info.Printers.Length == 0)
            {
                return "";
            }

            string printerName = "";
            string defaultPrinterName = "";
            foreach (var item in info.Printers)
            {
                if (item.RoomId.Trim().Equals(roomId))
                {
                    // 一致する部屋IDのプリンタ名が見つかった場合
                    printerName = item.PrinterName.Trim();
                }
                else if (item.RoomId.Trim().Equals("XXX"))
                {
                    // デフォルト設定のプリンタ名
                    defaultPrinterName = item.PrinterName.Trim();
                }
            }

            return (!printerName.Equals("")) ? printerName : defaultPrinterName;
        }
    }
}
