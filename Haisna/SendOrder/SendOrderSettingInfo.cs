using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

namespace Hainsi.SendOrder
{
    /// <summary>
    /// オーダ送信設定情報クラス
    /// </summary>
    public class SendOrderSettingInfo
    {
        /// <summary>
        /// ソケット情報クラス
        /// </summary>
        [JsonObject("socket")]
        public class SocketInfo
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
            /// IPアドレス
            /// </summary>
            [JsonProperty("ipaddress")]
            public string IpAddress { get; set; }

            /// <summary>
            /// ポート番号
            /// </summary>
            [JsonProperty("portno")]
            public int PortNo { get; set; }

            /// <summary>
            /// 送受信タイムアウト時間（単位:ミリ秒）
            /// </summary>
            [JsonProperty("timeout")]
            public int Timeout { get; set; }
        }

        /// <summary>
        /// 電文情報クラス
        /// </summary>
        [JsonObject("msg")]
        public class MsgInfo
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
            /// 電文項目
            /// </summary>
            [JsonProperty("tag")]
            public TagInfo[] Tags { get; set; }
        }

        /// <summary>
        /// 電文項目クラス
        /// </summary>
        [JsonObject("tag")]
        public class TagInfo
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
            /// 開始位置
            /// </summary>
            [JsonProperty("startpos")]
            public int StartPos { get; set; }

            /// <summary>
            /// バイト数
            /// </summary>
            [JsonProperty("length")]
            public int Length { get; set; }

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
        /// オーダ送信設定情報ファイルを読み込む
        /// </summary>
        /// <returns>オーダ送信設定情報クラス</returns>
        public static SendOrderSettingInfo ReadJsonFile()
        {
            // ファイルパスを編集する
            var fileName = Path.Combine(
                Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location),
                "SendOrderSetting.json");

            // オブジェクトを生成する
            var value = new SendOrderSettingInfo();

            // オーダ送信設定情報ファイルのJSONデータを取得する
            using (var sr = new StreamReader(fileName, Encoding.UTF8))
            {
                var data = sr.ReadToEnd();

                // ソケット情報
                var tmpSocketList = (List<SocketInfo>)JsonConvert.DeserializeObject<Dictionary<string, List<SocketInfo>>>(data)["socket"];
                foreach (var item in tmpSocketList)
                {
                    value.SocketDic.Add(item.Key, item);
                }

                // 電文情報
                var tmpMsgList = (List<MsgInfo>)JsonConvert.DeserializeObject<Dictionary<string, List<MsgInfo>>>(data)["msg"];
                foreach (var item in tmpMsgList)
                {
                    value.MsgDic.Add(item.Key, item);
                }
            }

            // オブジェクトを戻す
            return value;
        }

        /// <summary>
        /// ソケット情報
        /// </summary>
        private Dictionary<string, SocketInfo> SocketDic { get; set; } = new Dictionary<string, SocketInfo>();

        /// <summary>
        /// 電文情報
        /// </summary>
        private Dictionary<string, MsgInfo> MsgDic { get; set; } = new Dictionary<string, MsgInfo>();

        /// <summary>
        /// キーに一致するソケット情報を返す
        /// </summary>
        /// <param name="key">キー</param>
        /// <returns>ソケット情報</returns>
        public SocketInfo GetSocketInfo(string key)
        {
            if (!SocketDic.ContainsKey(key))
            {
                return null;
            }
            return SocketDic[key];
        }

        /// <summary>
        /// キーに一致する電文情報を返す
        /// </summary>
        /// <param name="key">キー</param>
        /// <returns>電文情報</returns>
        public MsgInfo GetMsgInfo(string key)
        {
            if (!MsgDic.ContainsKey(key))
            {
                return null;
            }
            return MsgDic[key];
        }
    }
}
