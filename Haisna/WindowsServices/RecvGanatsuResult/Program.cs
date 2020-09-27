using Fujitsu.Hainsi.WindowServices.Common;
using Model = Hainsi.Entity.Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace Fujitsu.Hainsi.WindowServices.RecvGanatsuResult
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
        /// 発信元コード
        /// </summary>
        private static string FromCode = "";

        /// <summary>
        /// Web API のベースURL
        /// </summary>
        private static string ApiUri = "";

        /// <summary>
        /// コード変換情報クラス
        /// </summary>
        private static CodeRevInfo ItemCode = null;

        /// <summary>
        /// アプリケーションのメイン エントリ ポイントです。
        /// </summary>
        static void Main(string[] args)
        {
            // ログ出力クラスを初期化する
            Logging.Initialize(Logging.DestSystemConstants.Lains);

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

            // 発信元コード
            FromCode = ConfigurationManager.AppSettings["SendDataWsMei"].Trim();
            if (string.IsNullOrEmpty(FromCode))
            {
                throw new Exception("送信元コードが設定されていません。");
            }

            // Web API のベースURL
            ApiUri = ConfigurationManager.AppSettings["ApiUri"].Trim();
            if (string.IsNullOrEmpty(ApiUri))
            {
                throw new Exception("Web API のベースURLが設定されていません。");
            }

            // コード変換情報を取得する
            try
            {
                ItemCode = CodeRevInfo.ReadJsonFile();
            }
            catch (Exception ex)
            {
                string msg = "コード変換情報ファイルの取得処理でエラーが発生しました。";
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

                // 電文の解析でエラーが発生した場合、応答種別に"20"を返す。
                return BuildResponse(values, ResponseStatus.Skip);
            }

            // オーダ番号と日付を基に予約番号を取得する
            long rsvNo = 0;
            try
            {
                string url = string.Format("api/v1/ordereddocs?orderno={0}&orderdate={1}",
                    values["ORDERNO"].Trim(),
                    Uri.EscapeDataString(DateTime.ParseExact(values["DATE"].Trim(), "yyyyMMdd", null).ToString("yyyy/MM/dd HH:mm:ss")));
                Task<dynamic> taskGetData = WebAPI.GetDataAsync(ApiUri, url);

                dynamic result = taskGetData.Result;
                if (result == null)
                {
                    string msg = string.Format("予約番号を取得できませんでした。オーダ番号:{0}、日付:{1}",
                        values["ORDERNO"].Trim(), values["DATE"].Trim());
                    Logging.Output(
                        Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted", msg);

                    // 予約番号の取得処理でエラーが発生した場合
                    return BuildResponse(values, ResponseStatus.Skip);
                }

                rsvNo = result[0].rsvno;
            }
            catch (Exception ex)
            {
                string msg = "予約番号の取得処理でエラーが発生しました。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted", msg, ex);

                // 予約番号の取得処理でエラーが発生した場合
                return BuildResponse(values, ResponseStatus.Skip);
            }

            // 更新用に検査結果データを編集する
            IList<Model.Result.ResultWithStatus> resultList = EditResultList(values);
            if (resultList.Count == 0)
            {
                // 更新対象データが存在しない場合
                return BuildResponse(values, ResponseStatus.Skip);
            }

            // 検査結果データを更新する
            if (UpdateResult(values, rsvNo, resultList))
            {
                // 検査結果の登録処理に成功した場合は
                // 応答種別を"OK"（正常終了）とする
                return BuildResponse(values, ResponseStatus.Ok);
            }
            else
            {
                // 予約番号の取得処理でエラーが発生した場合
                // 応答種別を"SKIP"とする
                return BuildResponse(values, ResponseStatus.Skip);
            }
 
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
                { ResponseStatus.Ok, "00" },
                { ResponseStatus.Retry, "10" },
                { ResponseStatus.Skip, "20" },
                { ResponseStatus.Down, "30" },
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
                        case "FROM-C":          // 発信元コード
                            data = FromCode;
                            break;
                        case "SEND-DATE":       // 送信日時
                            data = DateTime.Now.ToString("yyyyMMddHHmmss");
                            break;
                        case "SYORI-KBN":       // 処理区分
                            break;
                        case "SYUBETU":          // 応答種別
                            data = statusCode;
                            break;
                        case "DENBUN-LNG":      // 電文長
                            // 共通部
                            data = string.Format("{0:D7}",
                                KihonByteLen);
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
        /// 更新用に検査結果データを編集する
        /// </summary>
        /// <param name="values">受信電文データ</param>
        /// <returns>検査結果情報モデル</returns>
        static private IList<Model.Result.ResultWithStatus> EditResultList(Dictionary<string, string> values)
        {

            var resultList = new List<Model.Result.ResultWithStatus>();

            // 検査結果件数
            int resultCount = int.Parse(values["DATALEN"]);

            for (int i = 1; i <= resultCount; i++)
            {

                // 検査用項目コード／検査用サフィックス
                string insItemCd = values["IRAICD-" + i.ToString()].Trim();
                string insSuffix = values["SFX-" + i.ToString()].Trim();

                // RAYPAX電文より取り出した項目コードを変換する
                String tempCode = ItemCode.Convert(insItemCd + "|" + insSuffix);
                if (tempCode.Equals(""))
                {
                    // 変換できなかった場合は相手側のコードで更新する。
                    tempCode = insItemCd + "|" + insSuffix;
                }

                // 項目コードをCODE+SUFFIXに分解
                string itemCd;
                string suffix;
                string[] workList = tempCode.Split('|');
                switch (workList.Length)
                {
                    case 2:
                        itemCd = workList[0].Trim();
                        suffix = workList[1].Trim();
                        break;

                    default:
                        continue;
                }

                // 更新データとして退避する
                var resultRec = new Model.Result.ResultWithStatus();
                resultList.Add(resultRec);

                // 検査項目コード
                resultRec.ItemCd = itemCd;
                // サフィックス
                resultRec.Suffix = suffix;
                // 検査結果
                resultRec.Result = values["KEKKA-" + i.ToString()].Trim();

            }

            return resultList;
        }

        /// <summary>
        /// 検査結果データを更新する
        /// </summary>
        /// <param name="values">受信電文データ</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="resultList">検査結果情報モデル</param>
        static private bool UpdateResult(Dictionary<string, string> values, long rsvNo, IList<Model.Result.ResultWithStatus> resultList)
        {
            var updResultList = new List<Model.Result.ResultRec>();

            try
            {
                // 検査結果データをチェックする
                string url = string.Format("api/v1/results/validation?csldate={0}",
                    Uri.EscapeDataString(DateTime.ParseExact(values["DATE"].Trim(), "yyyyMMdd", null).ToString("yyyy/MM/dd HH:mm:ss")));
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
                string url = string.Format("api/v1/results/{0}/addparam?userid={1}&includeStopFlg=false&skipNoRec=true",
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
