using Fujitsu.Hainsi.WindowServices.Common;
using Model = Hainsi.Entity.Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace Fujitsu.Hainsi.WindowServices.RecvByoriReport
{
    public class Program : ManagedInstaller
    {
        /// <summary>
        /// 応答種別
        /// </summary>
        private enum ResponseStatus
        {
            Ok,
            Retry,
            Skip,
            Down,
        }

        /// <summary>
        /// 電文情報クラス
        /// </summary>
        private static TelegramInfo TelegramInfo = null;

        /// <summary>
        /// 共通情報部分の電文長
        /// </summary>
        private static int KihonByteLen = 0;

        /// <summary>
        /// 更新者
        /// </summary>
        private static string UpdUser = "";

        /// <summary>
        /// Web API のベースURL
        /// </summary>
        private static string ApiUri = "";

        /// <summary>
        /// XMLタグ情報クラス
        /// </summary>
        private static XmlTagInfo XmlTag = null;

        /// <summary>
        /// 細胞診結果情報クラス
        /// </summary>
        private static ClassCodeInfo ClassCode = null;

        /// <summary>
        /// オーダ種別（喀痰）
        /// </summary>
        private const string ORDERDIV_KAKUTAN = "ORDDIV000004";

        /// <summary>
        /// オーダ種別（婦人科）
        /// </summary>
        private const string ORDERDIV_FUJINKA = "ORDDIV000005";

        /// <summary>
        /// HTMLデータ内のXML部分の開始タグ
        /// </summary>
        private const string XML_BEGINTAG = "<XML_SECONDARY_USE>";

        /// <summary>
        /// HTMLデータ内のXML部分の終了タグ
        /// </summary>
        private const string XML_ENDTAG = "</XML_SECONDARY_USE>";

        /// <summary>
        /// アプリケーションのメイン エントリ ポイントです。
        /// </summary>
        static void Main(string[] args)
        {
            // ログ出力クラスを初期化する
            Logging.Initialize(Logging.DestSystemConstants.Byori);

            // サービス名
            string serviceName = ConfigurationManager.AppSettings["ServiceName"].Trim();

            // 引数が存在する場合は
            // サービスのインストール／アンインストールを行う
            if (args.Length >= 1)
            {
                Install(serviceName, args);
                return;
            }

            // ポート番号
            string port = ConfigurationManager.AppSettings["ServerPort"];

            // ポーリング間隔
            string pollingInterval = ConfigurationManager.AppSettings["PollingInterval"];

            // ソケット受信タイムアウト
            string socketRecieveTimeout = ConfigurationManager.AppSettings["SocketRecieveTimeout"];

            // ソケット送信タイムアウト
            string socketSendTimeout = ConfigurationManager.AppSettings["SocketSendTimeout"];

            // サービスを開始する
            ServiceBase.Run(new Listener(
                serviceName, port, pollingInterval, socketRecieveTimeout, socketSendTimeout)
            {
                OnStartCallback = OnStart,
                IsEndOfReceptionCallback = IsEndOfReception,
                ReceptionCompletedCallback = ReceptionCompleted,
            });
        }

        /// <summary>
        /// 開始処理コールバック
        /// </summary>
        /// <param name="telegramInfo">電文情報クラス</param>
        private static void OnStart(TelegramInfo telegramInfo)
        {
            // 電文情報クラスを取得する
            TelegramInfo = telegramInfo;

            // 共通情報部分の電文長を計算する
            foreach (TelegramInfo.TelegramItem item in TelegramInfo.Items)
            {
                // 共通情報部分の項目のバイト数を加算する
                if (item.TelegType == TelegramInfo.TelegramItem.TelegTypeConstants.common)
                {
                    KihonByteLen += item.Length;
                }
            }

            // 更新者
            UpdUser = ConfigurationManager.AppSettings["UpdUser"].Trim();
            if (string.IsNullOrEmpty(UpdUser))
            {
                throw new Exception("更新者が設定されていません。");
            }

            // Web API のベースURL
            ApiUri = ConfigurationManager.AppSettings["ApiUri"].Trim();
            if (string.IsNullOrEmpty(ApiUri))
            {
                throw new Exception("Web API のベースURLが設定されていません。");
            }

            // XMLタグ情報を取得する
            try
            {
                XmlTag = XmlTagInfo.ReadJsonFile();
            }
            catch (Exception ex)
            {
                string msg = "XMLタグ情報ファイルの取得処理でエラーが発生しました。";
                throw new Exception(msg, ex);
            }

            // 細胞診結果情報を取得する
            try
            {
                ClassCode = ClassCodeInfo.ReadJsonFile();
            }
            catch (Exception ex)
            {
                string msg = "細胞診結果情報ファイルの取得処理でエラーが発生しました。";
                throw new Exception(msg, ex);
            }
        }

        /// <summary>
        /// 受信終了判定コールバック
        /// </summary>
        /// <param name="memoryStream">受信電文</param>
        /// <returns>True:受信処理完了、False:受信処理継続</returns>
        private static bool IsEndOfReception(MemoryStream memoryStream)
        {
            // 受信済みデータを取得する
            byte[] receivedBytes = memoryStream.ToArray();

            if (receivedBytes.Length < KihonByteLen)
            {
                // 共通情報部分まで受信できていない場合は
                // 受信処理を継続する
                return false;
            }

            // 電文長のデータを取得する
            TelegramInfo.TelegramItem item = 
                TelegramInfo.FindItem(TelegramInfo.Items, "DENBUN-LNG");
            string tempLength = receivedBytes.ConvertToString(item.StartPos - 1, item.Length);
            int length = 0;
            if (!int.TryParse(tempLength, out length))
            {
                // 電文長を数値に変換できない場合は
                // 受信処理を中止する
                throw new Exception(
                    "電文長に数値以外の値が設定されています 電文長：[" + tempLength + "]" +
                    " 受信済み電文：[" + receivedBytes.ConvertToString() + "]");
            }

            if (receivedBytes.Length < length)
            {
                // 受信済みデータのサイズが電文長に満たない場合は
                // 受信処理を継続する
                return false;
            }

            // 電文を全て受信できたため
            // 受信処理を終了する
            return true;
        }

        /// <summary>
        /// 受信完了コールバック
        /// </summary>
        /// <param name="receivedStream">受信電文</param>
        /// <returns>送信電文</returns>
        private static byte[] ReceptionCompleted(string receivedStream)
        {
            // 受信電文を解析する
            List<string> errorList = null;
            Dictionary<string, string> values = null;
            TelegramInfo.Parse(receivedStream, ref errorList, ref values);

            // １件以上エラーが存在する場合
            if (errorList.Count > 0)
            {
                Logging.Output(
                    Logging.LogTypeConstants.DataError,
                    string.Join("／", errorList.ToArray()));

                // 電文の解析でエラーが発生した場合
                // 応答種別を"N2"（スキップ）とする
                return BuildResponse(values, ResponseStatus.Skip);
            }

            // オーダ番号と日付を基に予約番号、オーダ種別を取得する
            int orderNo = 0;
            DateTime orderDate;
            int rsvNo = 0;
            string orderDiv = "";
            try
            {
                orderNo = int.Parse(values["RPIF-NEW-ODR-NO"].Trim());
                orderDate = DateTime.ParseExact(values["RPIF-NEW-CRT-DATE"].Trim().Substring(0, 8), "yyyyMMdd", null);

                string url = string.Format("api/v1/ordereddocs?orderno={0}&orderdate={1}",
                    orderNo, Uri.EscapeDataString(orderDate.ToString("yyyy/MM/dd HH:mm:ss")));
                Task<dynamic> taskGetData = WebAPI.GetDataAsync(ApiUri, url);

                dynamic result = taskGetData.Result;
                if (result == null)
                {
                    string msg = string.Format("予約番号を取得できませんでした。オーダ番号:{0}、日付:{1}",
                        orderNo, orderDate.ToString("yyyy/MM/dd"));
                    Logging.Output(
                        Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted", msg);

                    // 予約番号の取得処理でエラーが発生した場合
                    // 応答種別を"N2"（スキップ）とする
                    return BuildResponse(values, ResponseStatus.Skip);
                }

                rsvNo = result[0].rsvno;
                orderDiv = result[0].orderdiv;
            }
            catch (Exception ex)
            {
                string msg = "予約番号の取得処理でエラーが発生しました。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted", msg, ex);

                // 予約番号の取得処理でエラーが発生した場合
                // 応答種別を"N2"（スキップ）とする
                return BuildResponse(values, ResponseStatus.Skip);
            }

            // オーダ種別をチェックする
            switch (orderDiv)
            {
                case ORDERDIV_KAKUTAN:  // 喀痰
                case ORDERDIV_FUJINKA:  // 婦人科
                    break;
                default:                // その他
                    string msg = string.Format("オーダ種別が無効:[{0}]", orderDiv);
                    Logging.Output(
                        Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted", msg);

                    // 喀痰、婦人科以外のオーダ種別の場合は
                    // 応答種別を"OK"（正常終了）とする
                    return BuildResponse(values, ResponseStatus.Ok);
            }

            // XMLデータを取得する
            XmlDocument xml = null;
            try
            {
                xml = GetXmlDoc(values["HTML"].Trim());
            }
            catch (Exception ex)
            {
                string msg = "XMLデータの取得処理でエラーが発生しました。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted", msg, ex);

                // XMLデータの取得処理でエラーが発生した場合
                // 応答種別を"N2"（スキップ）とする
                return BuildResponse(values, ResponseStatus.Skip);
            }

            // 婦人科の場合
            if (orderDiv.Equals(ORDERDIV_FUJINKA))
            {
                // レポート情報を登録する
                if (!UpdateReport(values, rsvNo, orderDiv, orderNo, orderDate, xml))
                {
                    // レポート情報の登録処理でエラーが発生した場合
                    // 応答種別を"N2"（スキップ）とする
                    return BuildResponse(values, ResponseStatus.Skip);
                }
            }

            // 更新用に検査結果データを編集する
            List<Model.Result.ResultWithStatus> resultList = null;
            if (xml != null && !EditResultList(values, rsvNo, orderDiv, orderDate, xml, ref resultList))
            {
                // 検査結果データの編集処理でエラーが発生した場合
                // 応答種別を"N2"（スキップ）とする
                return BuildResponse(values, ResponseStatus.Skip);
            }

            // 検査結果データを更新する
            if (resultList != null && resultList.Count > 0 && !UpdateResult(values, rsvNo, orderDate, resultList))
            {
                // 検査結果データの更新処理でエラーが発生した場合
                // 応答種別を"N2"（スキップ）とする
                return BuildResponse(values, ResponseStatus.Skip);
            }

            // 病理データの登録処理に成功した場合は
            // 応答種別を"OK"（正常終了）とする
            return BuildResponse(values, ResponseStatus.Ok);
        }

        /// <summary>
        /// 応答電文を作成する
        /// </summary>
        /// <param name="values">受信電文データ</param>
        /// <param name="status">処理ステータス</param>
        /// <returns>応答電文</returns>
        private static byte[] BuildResponse(Dictionary<string, string> values, ResponseStatus status)
        {
            var sendData = new StringBuilder();

            // 応答種別を変換する
            var statusCodes = new Dictionary<ResponseStatus, string>()
            {
                { ResponseStatus.Ok, "OK" },
                { ResponseStatus.Retry, "N1" },
                { ResponseStatus.Skip, "N2" },
                { ResponseStatus.Down, "N3" },
            };
            string statusCode =
                statusCodes.ContainsKey(status) ? statusCodes[status] : "";

            for (int i = 0; i < TelegramInfo.ExpandItems.Count; i++)
            {
                if (TelegramInfo.ExpandItems[i].TelegType == TelegramInfo.TelegramItem.TelegTypeConstants.common)
                {
                    string data = "";
                    switch (TelegramInfo.ExpandItems[i].NameEn)
                    {
                        case "SYUBETU":         // 応答種別
                            data = statusCode;
                            break;
                        case "DENBUN-LNG":      // 電文長
                            // 共通部
                            data = string.Format("{0:D6}", KihonByteLen);
                            break;
                        default:                // その他
                            data = values[TelegramInfo.ExpandItems[i].NameEn];
                            break;
                    }

                    if (TelegramInfo.ExpandItems[i].Type == TelegramInfo.TelegramItem.DataTypeConstants.numeric)
                    {
                        // 数値の場合は右詰め
                        data = data.PadLeftEx(TelegramInfo.ExpandItems[i].Length);
                    }
                    else
                    {
                        // 文字列の場合は左詰め
                        data = data.PadRightEx(TelegramInfo.ExpandItems[i].Length);
                    }

                    sendData.Append(data);
                }
            }

            // 応答種別送信
            Logging.Output(
                Logging.LogTypeConstants.RetrunResponse,
                statusCode);

            return sendData.ToString().GetBytes();
        }

        /// <summary>
        /// HTMLデータ内のXMLデータ部分をXmlDocumentオブジェクトとして返す
        /// </summary>
        /// <param name="html">HTMLデータ</param>
        /// <returns>XmlDocumentオブジェクト</returns>
        static private XmlDocument GetXmlDoc(string html)
        {
            if (html.Equals(""))
            {
                return null;
            }

            // HTMLデータ内の改行コードを除去する
            html = html.Replace("\r", "").Replace("\n", "");

            // 検索対象のタグの位置を取得する
            int beginPos = html.IndexOf(XML_BEGINTAG);
            int endPos = html.IndexOf(XML_ENDTAG);

            // 検索対象のタグが存在しない場合、
            // または終了タグが開始タグよりも前に存在する場合は
            // 処理を終了する
            if (beginPos < 0 || endPos < 0 || endPos < beginPos)
            {
                return null;
            }

            // XMLデータ部分を切り出す
            string xml =
                @"<?xml version=""1.0"" encoding=""shift_jis""?>" +
                html.Substring(beginPos, endPos - beginPos + XML_ENDTAG.Length);

            // XMLデータを基にXmlDocumentオブジェクトを作成する
            var doc = new XmlDocument();
            doc.LoadXml(xml);

            return doc;
        }

        /// <summary>
        /// レポート情報を登録する
        /// </summary>
        /// <param name="values">受信電文データ</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="orderDiv">オーダ種別</param>
        /// <param name="orderNo">オーダ番号</param>
        /// <param name="orderDate">オーダ日付</param>
        /// <param name="xml">XMLデータ</param>
        /// <returns>True:処理成功、False:処理失敗</returns>
        static private bool UpdateReport(Dictionary<string, string> values, int rsvNo, string orderDiv, int orderNo, DateTime orderDate, XmlDocument xml)
        {
            // XMLデータ内の検査種別を取得する
            string reportDiv = "";
            if (xml != null)
            {
                XmlNode node = xml.SelectSingleNode("//item[@attr='検査種別']");
                if (node != null && node.ChildNodes.Count > 0 && node.ChildNodes[0].InnerText != null)
                {
                    reportDiv = node.ChildNodes[0].InnerText.Trim();
                }
            }

            // 登録するレポート情報のデータをまとめる
            var data = new Model.OrderReport.OrderReport()
            {
                RsvNo = rsvNo,
                OrderDiv = orderDiv,
                OrderDate = orderDate,
                OrderNo = orderNo,
                ReportId = "",
                ReportDiv = reportDiv,
                ReportDivId = "",
                ActName = values["RPIF-NEW-JI-UNAME"].Trim(),
                ActId = values["RPIF-NEW-JI-ID"].Trim(),
                ActPostCd = values["RPIF-NEW-JI-DEP"].Trim(),
                Reporter = values["RPIF-NEW-RE-UNAME"].Trim(),
                ReporterId = values["RPIF-NEW-RE-ID"].Trim(),
                ReportDate = DateTime.ParseExact(values["RPIF-NEW-RE-DATE"].Trim(), "yyyyMMddHHmmss", null),
                ReportPostCd = values["RPIF-NEW-RE-DEP"].Trim(),
                RecogName = values["RPIF-NEW-CHK-UNAME"].Trim(),
                RecogId = values["RPIF-NEW-CHK-ID"].Trim(),
                RecogDate = DateTime.ParseExact(values["RPIF-NEW-CHK-DATE"].Trim(), "yyyyMMddHHmmss", null),
                RecogStatus = values["RPIF-NEW-CHK-FLG"].Trim(),
                HtmlReport = values["HTML"].Trim(),
            };

            try
            {
                // レポート情報を更新する
                Task<dynamic> taskPostData = WebAPI.PostDataAsync
                    <Model.OrderReport.OrderReport>(ApiUri, "api/v1/orderreports", data);
                taskPostData.Wait();

                if (taskPostData.Result != null && taskPostData.Result is string)
                {
                    // エラー内容をログに出力する
                    Logging.Output(
                        Logging.LogTypeConstants.Error, "Program", "UpdateReport",
                        "レポート情報の登録処理でエラーが発生しました。" + (string)taskPostData.Result);
                    return false;
                }
            }
            catch (Exception ex)
            {
                string msg = "レポート情報の登録処理でエラーが発生しました。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "UpdateReport", msg, ex);
                return false;
            }

            return true;
        }

        /// <summary>
        /// 更新用に検査結果データを編集する
        /// </summary>
        /// <param name="values">受信電文データ</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="orderDiv">オーダ種別</param>
        /// <param name="orderDate">オーダ日付</param>
        /// <param name="xml">XMLデータ</param>
        /// <param name="resultList">検査結果情報モデル</param>
        /// <returns>True:処理成功、False:処理失敗</returns>
        static private bool EditResultList(Dictionary<string, string> values, int rsvNo, string orderDiv, DateTime orderDate, XmlDocument xml, ref List<Model.Result.ResultWithStatus> resultList)
        {
            // 戻り値を初期化する
            resultList = new List<Model.Result.ResultWithStatus>();

            // XMLデータが取得できていない場合は処理を行わない
            if (xml == null)
            {
                return true;
            }

            // XMLタグ詳細情報を取得する
            List<XmlTagInfo.XmlItemInfo> xmlTagItems = XmlTag.GetItems(orderDiv);
            if (xmlTagItems == null)
            {
                return true;
            }

            // 婦人科の場合
            int fujinkaOrderCount = 0;
            bool fujinkaReplace = false;
            if (orderDiv.Equals(ORDERDIV_FUJINKA))
            {
                // 婦人科のオーダ件数を取得する
                try
                {
                    string url = string.Format("api/v1/ordereddocs/count?rsvno={0}&orderdiv={1}",
                        rsvNo, orderDiv);
                    Task<dynamic> taskGetData = WebAPI.GetDataAsync(ApiUri, url);
                    fujinkaOrderCount = (int)taskGetData.Result;
                }
                catch (Exception ex)
                {
                    string msg = "オーダ件数の取得処理でエラーが発生しました。";
                    Logging.Output(
                        Logging.LogTypeConstants.Error, "Program", "EditResultList", msg, ex);
                    return false;
                }

                // 婦人科の複数のオーダが存在して、
                // かつクラス分類の入替が必要なパターンに一致するかをチェックする
                if (fujinkaOrderCount > 1)
                {
                    // XMLタグ詳細情報を基にXMLデータ内の結果データを取得する
                    foreach (XmlTagInfo.XmlItemInfo xmlTagItem in xmlTagItems)
                    {
                        // クラス分類（コード変換フラグ=1）の場合のみ処理の対象とする
                        if (xmlTagItem.CodeConvFlg != 1)
                        {
                            continue;
                        }

                        // 結果データを取得する
                        XmlNode node = xml.SelectSingleNode(
                            string.Format("//item[@attr='{0}']", xmlTagItem.AttrName));
                        string result = "";
                        if (node != null && node.ChildNodes.Count > 0 && !string.IsNullOrEmpty(node.ChildNodes[0].InnerText))
                        {
                            result = node.ChildNodes[0].InnerText.Trim();
                        }

                        // コード変換を行う
                        ClassCodeInfo.ClassItemInfo classItem =
                            ClassCode.FindItem(orderDiv, result.CutLeft(400).TrimEnd());

                        // 検索対象検査結果に該当する最も大きいサフィックスとその検査結果を取得する
                        int maxSuffixResultSeq = 0;
                        try
                        {
                            string url = string.Format("api/v1/results/suffixandresult?rsvno={0}&itemcd={1}",
                                rsvNo, xmlTagItem.ItemCd.Trim());
                            foreach (ClassCodeInfo.ClassItemInfo item in ClassCode.GetItems(orderDiv))
                            {
                                url += string.Format("&results={0}", item.Result.Trim());
                            }
                            Task<dynamic> taskGetData = WebAPI.GetDataAsync(ApiUri, url);
                            taskGetData.Wait();

                            // 取得した検査結果の順番を検索する
                            maxSuffixResultSeq = ClassCode.FindItemSeq(orderDiv, Convert.ToString(taskGetData.Result.result));
                        }
                        catch (Exception ex)
                        {
                            string msg = "サフィックスと検査結果の取得処理でエラーが発生しました。";
                            Logging.Output(
                                Logging.LogTypeConstants.Error, "Program", "EditResultList", msg, ex);
                            return false;
                        }

                        // クラス分類の入替が必要なパターンの場合
                        if (xmlTagItem.AttrName.Equals("第１判定") &&
                            ((classItem == null && maxSuffixResultSeq > 0) ||
                             maxSuffixResultSeq > classItem.Seq))
                        {
                            fujinkaReplace = true;
                            break;
                        }
                    }
                }
            }

            // XMLタグ詳細情報を基にXMLデータ内の結果データを取得する
            foreach (XmlTagInfo.XmlItemInfo xmlTagItem in xmlTagItems)
            {
                // 結果データを取得する
                XmlNode node = xml.SelectSingleNode(
                    string.Format("//item[@attr='{0}']", xmlTagItem.AttrName));
                if (node == null || node.ChildNodes.Count == 0 || string.IsNullOrEmpty(node.ChildNodes[0].InnerText))
                {
                    continue;
                }

                // 検査項目コード、サフィックス、検査結果を退避する
                string itemCd = xmlTagItem.ItemCd.Trim();
                string suffix = xmlTagItem.Suffix.Trim();
                string result = node.ChildNodes[0].InnerText.Trim();
                int resultSeq = 0;
                if (xmlTagItem.CodeConvFlg == 1)
                {
                    // コード変換を行う場合
                    ClassCodeInfo.ClassItemInfo classItem = 
                        ClassCode.FindItem(orderDiv, result.CutLeft(400).TrimEnd());
                    if (classItem != null)
                    {
                        result = classItem.Result.Trim();
                        resultSeq = classItem.Seq;
                    }
                    else
                    {
                        result = "";
                    }
                }

                // 婦人科の場合
                if (orderDiv.Equals(ORDERDIV_FUJINKA))
                {
                    string maxSuffixResult = "";
                    int maxSuffixResultSeq = 0;
                    if (xmlTagItem.CodeConvFlg == 1)
                    {
                        // 検索対象検査結果に該当する最も大きいサフィックスとその検査結果を取得する
                        try
                        {
                            string url = string.Format("api/v1/results/suffixandresult?rsvno={0}&itemcd={1}",
                                rsvNo, itemCd);
                            foreach (ClassCodeInfo.ClassItemInfo item in ClassCode.GetItems(orderDiv))
                            {
                                url += string.Format("&results={0}", item.Result.Trim());
                            }
                            Task<dynamic> taskGetData = WebAPI.GetDataAsync(ApiUri, url);
                            taskGetData.Wait();

                            // サフィックスを調整する
                            suffix = ((string)taskGetData.Result.suffix ?? "").Trim();

                            // 検査結果を取得する
                            maxSuffixResult = ((string)taskGetData.Result.result ?? "").TrimEnd();

                            // 取得した検査結果の順番を検索する
                            maxSuffixResultSeq = ClassCode.FindItemSeq(orderDiv, maxSuffixResult);
                        }
                        catch (Exception ex)
                        {
                            string msg = "サフィックスと検査結果の取得処理でエラーが発生しました。";
                            Logging.Output(
                                Logging.LogTypeConstants.Error, "Program", "EditResultList", msg, ex);
                            return false;
                        }
                    }

                    // // 婦人科の複数のオーダが存在する場合
                    if (fujinkaOrderCount > 1)
                    {
                        // 取得した検査結果の順位の方が大きい場合（悪い結果の場合）、その検査結果で更新する
                        if (xmlTagItem.CodeConvFlg == 1 && maxSuffixResultSeq > resultSeq)
                        {
                            result = maxSuffixResult;
                        }

                        // クラス分類の入替を行う場合
                        if (fujinkaReplace)
                        {
                            switch (itemCd)
                            {
                                case "46510":   // 婦人科細胞診所見文１
                                case "46520":   // 婦人科細胞診所見文２
                                case "46530":   // 婦人科細胞診所見文３
                                case "46610":   // 婦人科細胞診診断文１
                                case "46620":   // 婦人科細胞診診断文２
                                case "46630":   // 婦人科細胞診診断文３
                                case "27050":   // ベセスダ分類１～３
                                    // クラス分類に今回の検査結果を反映させない場合、
                                    // 所見、診断、ベセスダ分類も同様に現在格納されている検査結果で更新する
                                    try
                                    {
                                        string url = string.Format("api/v1/results/{0}/{1}/{2}",
                                            rsvNo, itemCd, suffix);
                                        Task<dynamic> taskGetData = WebAPI.GetDataAsync(ApiUri, url);
                                        taskGetData.Wait();

                                        // 取得した検査結果を更新する
                                        result = ((string)taskGetData.Result ?? "").TrimEnd();
                                    }
                                    catch (Exception ex)
                                    {
                                        string msg = "検査結果の取得処理でエラーが発生しました。";
                                        Logging.Output(
                                            Logging.LogTypeConstants.Error, "Program", "EditResultList", msg, ex);
                                        return false;
                                    }

                                    break;
                            }
                        }
                    }
                }

                // 予約にコードが存在しないため、2010/12/31以前について所見と診断を取得しない
                if (DateTime.Now.ToString("yyyyMMdd").CompareTo("20110101") >= 0 &&
                    orderDate.ToString("yyyyMMdd").CompareTo("20101231") <= 0)
                {
                    switch (itemCd)
                    {
                        case "46510":   // 婦人科細胞診所見文１
                        case "46520":   // 婦人科細胞診所見文２
                        case "46530":   // 婦人科細胞診所見文３
                        case "46610":   // 婦人科細胞診診断文１
                        case "46620":   // 婦人科細胞診診断文２
                        case "46630":   // 婦人科細胞診診断文３
                        case "27050":   // ベセスダ分類１～３
                            // 取り込まない
                            result = "";
                            break;
                    }
                }

                // 更新する検査結果を退避する
                if (!itemCd.Equals("") && !suffix.Equals("") && !result.Equals(""))
                {
                    resultList.Add(new Model.Result.ResultWithStatus()
                    {
                        ItemCd = itemCd,
                        Suffix = suffix,
                        Result = result.CutLeft(400).TrimEnd(),
                        RslCmtCd1 = "",
                        RslCmtCd2 = "",
                        StopFlg = ""
                    });
                }
            }

            return true;
        }

        /// <summary>
        /// 検査結果データを更新する
        /// </summary>
        /// <param name="values">受信電文データ</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="orderDate">オーダ日付</param>
        /// <param name="resultList">検査結果情報モデル</param>
        /// <returns>True:処理成功、False:処理失敗</returns>
        static private bool UpdateResult(Dictionary<string, string> values, int rsvNo, DateTime orderDate, IList<Model.Result.ResultWithStatus> resultList)
        {
            var updResultList = new List<Model.Result.ResultRec>();

            try
            {
                // 検査結果データをチェックする
                string url = string.Format("api/v1/results/validation?csldate={0}",
                    Uri.EscapeDataString(orderDate.ToString("yyyy/MM/dd HH:mm:ss")));
                Task<dynamic> taskPostData =
                    WebAPI.PostDataAsync<IList<Model.Result.ResultWithStatus>>(ApiUri, url, resultList);
                taskPostData.Wait();

                if (taskPostData.Result != null)
                {
                    // チェック処理結果を取得する
                    dynamic results = taskPostData.Result.results;
                    dynamic messages = taskPostData.Result.messages;

                    // 1件以上エラーがある場合はエラーメッセージをログに出力する
                    if (messages != null && messages.Count > 0)
                    {
                        foreach (string message in messages)
                        {
                            Logging.Output(
                                Logging.LogTypeConstants.Error, "Program",
                                "UpdateResult - CheckResult", message);
                        }
                    }

                    // 検査結果データを更新用に退避する
                    foreach (dynamic result in results)
                    {
                        // チェック処理結果を取得する
                        var resultRec = new Model.Result.ResultWithStatus()
                        {
                            ItemCd = Convert.ToString(result.itemcd),
                            Suffix = Convert.ToString(result.suffix),
                            Result = Convert.ToString(result.result),
                            RslCmtCd1 = Convert.ToString(result.rslcmtcd1),
                            RslCmtCd2 = Convert.ToString(result.rslcmtcd2),
                            StopFlg = Convert.ToString(result.stopflg),
                            ShortStc = Convert.ToString(result.shortstc),
                            ResultError = Convert.ToString(result.resulterror),
                            RslCmtName1 = Convert.ToString(result.rslcmtname1),
                            RslCmtError1 = Convert.ToString(result.rslcmterror1),
                            RslCmtName2 = Convert.ToString(result.rslcmtname2),
                            RslCmtError2 = Convert.ToString(result.rslcmterror2),
                        };

                        if (!resultRec.ResultError.Equals("") ||
                            !resultRec.RslCmtError1.Equals("") ||
                            !resultRec.RslCmtError2.Equals(""))
                        {
                            // エラーが発生している検査項目をログに出力する
                            string msg = string.Format("[{0}]-[{1}] [{2}] [{3}] [{4}]",
                                resultRec.ItemCd, resultRec.Suffix,
                                resultRec.Result, resultRec.RslCmtCd1, resultRec.RslCmtCd2);
                            Logging.Output(
                                Logging.LogTypeConstants.Error, "Program", "UpdateResult - CheckResult", msg);
                            continue;
                        }

                        // エラーが発生していない検査項目のみを更新の対象とする
                        updResultList.Add(resultRec);
                    }
                }
            }
            catch (Exception ex)
            {
                string msg = "検査結果のチェック処理でエラーが発生しました。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "UpdateResult", msg, ex);
                return false;
            }

            // 更新対象データが0件の場合は更新処理を行わない
            if (updResultList.Count == 0)
            {
                return true;
            }

            try
            {
                // 検査結果データを更新する
                string url = string.Format("api/v1/results/{0}?userid={1}",
                    rsvNo, Uri.EscapeDataString(UpdUser));
                Task<dynamic> taskPutData =
                    WebAPI.PutDataAsync<IList<Model.Result.ResultRec>>(ApiUri, url, updResultList);
                taskPutData.Wait();

                if (taskPutData.Result != null && taskPutData.Result is string)
                {
                    // エラー内容をログに出力する
                    Logging.Output(
                        Logging.LogTypeConstants.Error, "Program", "UpdateResult",
                        "検査結果の更新処理でエラーが発生しました。" + (string)taskPutData.Result);
                    return false;
                }
            }
            catch (Exception ex)
            {
                string msg = "検査結果の更新処理でエラーが発生しました。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "UpdateResult", msg, ex);
                return false;
            }

            return true;
        }
    }
}
