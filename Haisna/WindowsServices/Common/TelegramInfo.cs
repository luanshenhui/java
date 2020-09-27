using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace Fujitsu.Hainsi.WindowServices.Common
{
    /// <summary>
    /// 電文情報クラス
    /// </summary>
    public class TelegramInfo
    {
        /// <summary>
        /// 電文繰り返し情報クラス
        /// </summary>
        [JsonObject("loop")]
        public class TelegramLoop
        {
            /// <summary>
            /// 繰り返しタイプ
            /// </summary>
            public enum LoopTypeConstants
            {
                /// <summary>
                /// 回数直接指定
                /// </summary>
                count = 1,

                /// <summary>
                /// 他項目で回数を指定
                /// </summary>
                index = 2,
            }

            /// <summary>
            /// 繰り返し開始位置
            /// </summary>
            [JsonProperty("startindex")]
            public int StartIndex { get; set; }

            /// <summary>
            /// 繰り返し終了位置
            /// </summary>
            [JsonProperty("endindex")]
            public int EndIndex { get; set; }

            /// <summary>
            /// 繰り返し回数種別
            /// </summary>
            [JsonProperty("type")]
            public LoopTypeConstants LoopType { get; set; }

            /// <summary>
            /// 繰り返し回数／繰り返し回数の項目位置
            /// </summary>
            [JsonProperty("detail")]
            public int Detail { get; set; }
        }

        /// <summary>
        /// 電文項目クラス
        /// </summary>
        [JsonObject("item")]
        public class TelegramItem
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
            /// 電文項目タイプ
            /// </summary>
            public enum TelegTypeConstants
            {
                /// <summary>
                /// 共通部
                /// </summary>
                common = 1,

                /// <summary>
                /// 情報部
                /// </summary>
                detail = 2,
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
            /// データタイプ
            /// </summary>
            [JsonProperty("type")]
            public DataTypeConstants Type { get; set; }

            /// <summary>
            /// 受信電文使用フラグ
            /// </summary>
            [JsonProperty("recvuseflg")]
            public int RecvUseFlg { get; set; }

            /// <summary>
            /// 送信電文使用フラグ（ソケットクライアントの場合のみ有効）
            /// </summary>
            [JsonProperty("senduseflg")]
            public int SendUseFlg { get; set; }

            /// <summary>
            /// 空白設定フラグ
            /// </summary>
            [JsonProperty("spaceflg")]
            public int SpaceFlg { get; set; }

            /// <summary>
            /// 電文項目タイプ（ソケットサーバの場合のみ有効）
            /// </summary>
            [JsonProperty("telegtype")]
            public TelegTypeConstants TelegType { get; set; }

            /// <summary>
            /// 設定値
            /// </summary>
            [JsonProperty("values")]
            public string[] Values { get; set; }

            /// <summary>
            /// 自分のオブジェクトのクローンを作成する
            /// </summary>
            /// <returns></returns>
            public TelegramItem Clone()
            {
                TelegramItem value = new TelegramItem();

                value.Index = Index;
                value.NameJa = NameJa;
                value.NameEn = NameEn;
                value.StartPos = StartPos;
                value.Length = Length;
                value.Type = Type;
                value.RecvUseFlg = RecvUseFlg;
                value.SendUseFlg = SendUseFlg;
                value.SpaceFlg = SpaceFlg;
                value.TelegType = TelegType;
                value.Values = Values;

                return value;
            }
        }

        /// <summary>
        /// 電文定義ファイルを読み込む
        /// </summary>
        /// <param name="fileName">JSONファイルのフルパス</param>
        /// <returns>電文情報クラス</returns>
        public static TelegramInfo ReadJsonFile(string fileName)
        {
            // オブジェクトを生成する
            TelegramInfo value = new TelegramInfo();

            // 電文定義ファイルのJSONデータを取得する
            using (StreamReader sr = new StreamReader(fileName, Encoding.UTF8))
            {
                string data = sr.ReadToEnd();
                value.Loops = (List<TelegramLoop>)JsonConvert.DeserializeObject<Dictionary<string, List<TelegramLoop>>>(data)["loop"];
                value.Items = (List<TelegramItem>)JsonConvert.DeserializeObject<Dictionary<string, List<TelegramItem>>>(data)["item"];
            }

            // オブジェクトを戻す
            return value;
        }

        /// <summary>
        /// 電文項目を検索する
        /// </summary>
        /// <param name="items">対象データ</param>
        /// <param name="nameEn">データ項目名</param>
        /// <returns>電文項目</returns>
        public static TelegramItem FindItem(List<TelegramItem> items,string nameEn)
        {
            foreach (TelegramItem item in items)
            {
                if (item.NameEn.Equals(nameEn))
                {
                    return item;
                }
            }
            return null;
        }

        /// <summary>
        /// 電文繰り返し情報定義
        /// </summary>
        public List<TelegramLoop> Loops { get; set; } = new List<TelegramLoop>();

        /// <summary>
        /// 電文項目定義
        /// </summary>
        public List<TelegramItem> Items { get; set; } = new List<TelegramItem>();

        /// <summary>
        /// 電文項目定義（繰り返し項目展開済み）
        /// </summary>
        public List<TelegramItem> ExpandItems { get; set; } = new List<TelegramItem>();

        /// <summary>
        /// 電文データを解析する
        /// </summary>
        /// <param name="source">電文データ</param>
        /// <param name="errorList">エラーメッセージ</param>
        /// <param name="values">解析済みデータ</param>
        /// <returns></returns>
        public void Parse(string source, ref List<string> errorList, ref Dictionary<string, string> values)
        {
            // 初期化する
            errorList = new List<string>();
            values = new Dictionary<string, string>();

            // 電文項目定義をコピーする
            ExpandItems = new List<TelegramItem>();
            for (int i = 0; i < Items.Count; i++)
            {
                ExpandItems.Add(Items[i].Clone());
            }

            // 繰り返し項目を展開する
            for (int i = 0; i < Loops.Count; i++)
            {
                int loopCount = 0;
                if (Loops[i].LoopType == TelegramLoop.LoopTypeConstants.count)
                {
                    // 回数直接指定
                    loopCount = Loops[i].Detail;
                }
                else
                {
                    // 他項目で回数を指定
                    foreach (TelegramItem item in ExpandItems)
                    {
                        if (item.Index == Loops[i].Detail)
                        {
                            int.TryParse(
                                source.SubstringEx(item.StartPos - 1, item.Length),
                                out loopCount);
                            break;
                        }
                    }
                }

                // 繰り返しを行う場合
                if (loopCount > 1)
                {
                    List<TelegramItem> tmpItems = new List<TelegramItem>();
                    int insertIndex = 0;
                    int offsetStartPos = 0;
                    for (int j = 0; j < Items.Count; j++)
                    {
                        if (Loops[i].StartIndex > ExpandItems[j].Index)
                        {
                            // ループ対象項目を挿入する位置を退避する
                            insertIndex = j + 1;
                        }
                        else if (Loops[i].StartIndex <= ExpandItems[j].Index && Loops[i].EndIndex >= ExpandItems[j].Index)
                        {
                            // ループ対象項目を退避する
                            tmpItems.Add(ExpandItems[j].Clone());
                            // ループ対象項目のバイト数を加算する
                            offsetStartPos += ExpandItems[j].Length;
                            // ループ対象項目を挿入する位置を退避する
                            insertIndex = j + 1;
                        }
                        else
                        {
                            // ループ対象項目の分、ループ対象項目より後の項目について
                            // 開始位置を後ろに移動する
                            ExpandItems[j].StartPos += (loopCount - 1) * offsetStartPos;
                        }
                    }

                    // ループ対象項目を挿入する
                    // （１つ目は既に定義済みのため２から処理を行う）
                    for (int j = 2; j <= loopCount; j++)
                    {
                        foreach (TelegramItem item in tmpItems)
                        {
                            // ループ対象項目を挿入する
                            ExpandItems.Insert(insertIndex, item.Clone());

                            // 項目名、データ項目名について、
                            // 末尾の１文字を除去して、ループ件数を付加する
                            ExpandItems[insertIndex].NameEn =
                                ExpandItems[insertIndex].NameEn.Substring(
                                    0, ExpandItems[insertIndex].NameEn.Length - 1) + j.ToString();
                            ExpandItems[insertIndex].NameJa =
                                ExpandItems[insertIndex].NameJa.Substring(
                                    0, ExpandItems[insertIndex].NameJa.Length - 1) +
                                Microsoft.VisualBasic.Strings.StrConv(j.ToString(), Microsoft.VisualBasic.VbStrConv.Wide);

                            // ループ対象項目の分、開始位置を後ろに移動する
                            ExpandItems[insertIndex].StartPos += (j - 1) * offsetStartPos;

                            // 挿入位置を１つ後ろに移す
                            insertIndex += 1;
                        }
                    }
                }
            }

            // 繰り返し項目のため電文項目が増えている場合は
            // インデックスを振り直す
            if (Items.Count != ExpandItems.Count)
            {
                for (int i = 0; i < ExpandItems.Count; i++)
                {
                    ExpandItems[i].Index = i + 1;
                }
            }

            // 電文データを解析する
            foreach (TelegramItem item in ExpandItems)
            {
                // 使用しない項目の場合
                if (item.RecvUseFlg == 0)
                {
                    values.Add(item.NameEn, "");
                    continue;
                }

                // 電文からデータを切り出す
                string data = source.SubstringEx(item.StartPos - 1, item.Length);

                // 空白設定フラグが空白不可で、かつデータが空白の場合
                if (item.SpaceFlg == 0 && data.Trim().Equals(""))
                {
                    errorList.Add(string.Format("{0} の値は必須ですが空白がセットされています", item.NameJa));
                    values.Add(item.NameEn, data);
                    continue;
                }

                // 項目タイプが数値で、かつデータが数値以外の場合
                if (item.Type == TelegramItem.DataTypeConstants.numeric && 
                    !long.TryParse(data.Trim(), out long tmpLongData))
                {
                    errorList.Add(string.Format("{0} は数値ではありません : {1}", item.NameJa, data.Trim()));
                    values.Add(item.NameEn, data);
                    continue;
                }

                // 設定値が設定されている場合
                if (item.Values != null && item.Values.Length > 0)
                {
                    // 設定値とデータとを比較する
                    bool isMatch = false;
                    foreach (string value in item.Values)
                    {
                        if (value.Equals("SP"))
                        {
                            // 空白の場合
                            if (data.Trim().Equals("") && data.Equals(new string(' ',item.Length)))
                            {
                                isMatch = true;
                                break;
                            }
                        }
                        else
                        {
                            // その他の場合
                            if (data.ToUpper().Equals(value.ToUpper()))
                            {
                                isMatch = true;
                                break;
                            }
                        }
                    }

                    // 何れの設定値とも一致しなかった場合
                    if (!isMatch)
                    {
                        errorList.Add(string.Format("{0} は有効文字列ではありません : {1}", item.NameJa, data.Trim()));
                        values.Add(item.NameEn, data);
                        continue;
                    }
                }

                // エラー無し
                values.Add(item.NameEn, data);
            }
        }
    }
}
