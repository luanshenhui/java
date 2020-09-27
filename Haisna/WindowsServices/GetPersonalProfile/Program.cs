using Fujitsu.Hainsi.WindowServices.Common;
using Model = Hainsi.Entity.Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace Fujitsu.Hainsi.WindowServices.GetPersonalProfile
{
    public class Program : ManagedInstaller
    {
        /// <summary>
        /// 応答種別
        /// </summary>
        private enum ResponseStatus
        {
            Ok,
            Ng,
            Retry,
            Skip,
            Down,
            NotFound,
            Else,
        }

        /// <summary>
        /// 電文情報クラス
        /// </summary>
        private static TelegramInfo TelegramInfo = null;

        /// <summary>
        /// 送信電文の電文長
        /// </summary>
        private static int SendByteLen = 0;

        /// <summary>
        /// 端末名
        /// </summary>
        private static string ComputerName = "";

        /// <summary>
        /// 利用者ID
        /// </summary>
        private static string UserId = "";

        /// <summary>
        /// Web API のベースURL
        /// </summary>
        private static string ApiUri = "";

        /// <summary>
        /// 結果コード情報クラス
        /// </summary>
        private static ResultCodeInfo ResultCode = null;

        /// <summary>
        /// アプリケーションのメイン エントリ ポイントです。
        /// </summary>
        public static void Main(string[] args)
        {
            // ログ出力クラスを初期化する
            Logging.Initialize(Logging.DestSystemConstants.Smile);

            // サービス名
            string serviceName = ConfigurationManager.AppSettings["ServiceName"].Trim();

            // 引数が存在する場合は
            // サービスのインストール／アンインストールを行う
            if (args.Length >= 1)
            {
                Install(serviceName, args);
                return;
            }

            // ホスト名
            string hostName = ConfigurationManager.AppSettings["ServerHostName"];

            // ポート番号
            string port = ConfigurationManager.AppSettings["ServerPort"];

            // ポーリング間隔
            string pollingInterval = ConfigurationManager.AppSettings["PollingInterval"];

            // ソケット受信タイムアウト
            string socketRecieveTimeout = ConfigurationManager.AppSettings["SocketRecieveTimeout"];

            // ソケット送信タイムアウト
            string socketSendTimeout = ConfigurationManager.AppSettings["SocketSendTimeout"];

            // サービスを開始する
            ServiceBase.Run(new Service(
                serviceName, hostName, port, pollingInterval, socketRecieveTimeout, socketSendTimeout)
            {
                OnStartCallback = OnStart,
                GetSourceDataCallback = GetSourceData,
                EditSendMessageCallback = EditSendMessage,
                IsEndOfReceptionCallback = IsEndOfReception,
                ReceptionCompletedCallback = ReceptionCompleted,
                OutoutErrLogMsgCallback = OutoutErrLogMsg,
            });
        }

        private static void OnStart(TelegramInfo telegramInfo)
        {
            // 電文情報クラスを取得する
            TelegramInfo = telegramInfo;

            // 送信電文の電文長を計算する
            foreach (TelegramInfo.TelegramItem item in TelegramInfo.Items)
            {
                // 送信電文の項目のバイト数を加算する
                if (item.SendUseFlg == 1)
                {
                    SendByteLen += item.Length;
                }
            }

            // 端末名
            ComputerName = ConfigurationManager.AppSettings["SendDataWsMei"].Trim();
            if (string.IsNullOrEmpty(ComputerName))
            {
                throw new Exception("端末名が設定されていません。");
            }

            // 利用者ID
            UserId = ConfigurationManager.AppSettings["SendDataRiyosyaId"].Trim();
            if (string.IsNullOrEmpty(UserId))
            {
                throw new Exception("利用者IDが設定されていません。");
            }

            // Web API のベースURL
            ApiUri = ConfigurationManager.AppSettings["ApiUri"].Trim();
            if (string.IsNullOrEmpty(ApiUri))
            {
                throw new Exception("Web API のベースURLが設定されていません。");
            }

            // 結果コード情報を取得する
            try
            {
                ResultCode = ResultCodeInfo.ReadJsonFile();
            }
            catch (Exception ex)
            {
                string msg = "結果コード情報ファイルの取得処理でエラーが発生しました。";
                throw new Exception(msg, ex);
            }
        }

        private static dynamic GetSourceData()
        {
            // 処理対象データを取得する
            Task<dynamic> taskGetData = WebAPI.GetDataAsync(
                ApiUri, "api/v1/personjournals");

            // 取得した処理対象データを戻す
            return taskGetData.Result;
        }

        private static string EditSendMessage(dynamic data)
        {
            StringBuilder message = new StringBuilder();

            // 連番を取得する
            int seqNo = 0;
            try
            {
                Task<dynamic> taskGetData = WebAPI.GetDataAsync(
                    ApiUri, "api/v1/personjournals/seqno");
                seqNo = (int)taskGetData.Result;
            }
            catch (Exception ex)
            {
                string msg = "連番の取得処理でエラーが発生しました。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "EditSendMessage", msg, ex);
                return "";
            }

            // 連番
            message.Append(seqNo.ToString("D5").PadRightEx(5));
            // システムコード("H"固定)
            message.Append("H".PadRightEx(1));
            // 電文種別("ME"固定)
            message.Append("ME".PadRightEx(2));
            // レコード継続指示("E"固定)
            message.Append("E".PadRightEx(1));
            // 送信先システムコード("O"固定)
            message.Append("O".PadRightEx(1));
            // 発信元システムコード("A"固定)
            message.Append("A".PadRightEx(1));
            // 処理年月日
            message.Append(DateTime.Now.ToString("yyyyMMdd").PadRightEx(8));
            // 処理時刻
            message.Append(DateTime.Now.ToString("HHmmss").PadRightEx(6));
            // 端末名
            message.Append(ComputerName.PadRightEx(8));
            // 利用者番号(=利用者ID)
            message.Append(UserId.PadRightEx(8));
            // 処理区分("01"固定)
            message.Append("01".PadRightEx(2));
            // 応答種別(空白)
            message.Append("".PadRightEx(2));
            // 電文長
            message.Append(SendByteLen.ToString("D5").PadRightEx(5));
            // 予備(空白)
            message.Append("".PadRightEx(14));
            // 検索区分("1"固定)
            message.Append("1".PadRightEx(1));
            // 患者番号
            message.Append(((string)data.perid).PadLeft(10, '0').PadRightEx(10));
            // 問い合せ日("00000000"固定)
            message.Append("00000000".PadRightEx(8));
            // 問い合せ時間("000000"固定)
            message.Append("000000".PadRightEx(6));
            // 病棟コード(空白)
            message.Append("".PadRightEx(3));
            // 終了コード("0D"固定)
            message.Append("\r".PadRightEx(1));

            // 送信電文の電文長をチェックする
            if (message.ToString().GetByteCount() != SendByteLen)
            {
                string msg = "作成した送信電文の電文長が不正です。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "EditSendMessage", msg);
                return "";
            }

            return message.ToString();
        }

        private static bool IsEndOfReception(MemoryStream memoryStream)
        {
            // 受信済みデータを取得する
            byte[] receivedBytes = memoryStream.ToArray();

            // 電文長の項目定義を取得する
            TelegramInfo.TelegramItem item =
                TelegramInfo.FindItem(TelegramInfo.Items, "DENBUN-LNG");

            if (receivedBytes.Length < (item.StartPos + item.Length - 1))
            {
                // 電文長の部分まで受信できていない場合は
                // 受信処理を継続する
                return false;
            }

            // 電文長のデータを取得する
            string tempLength = receivedBytes.ConvertToString(item.StartPos - 1, item.Length);
            if (!int.TryParse(tempLength, out int length))
            {
                // 電文長を数値に変換できない場合は受信処理を中止する
                throw new Exception(
                    "電文長に数値以外の値が設定されています 電文長：[" + tempLength + "]" +
                    " 受信済み電文：[" + receivedBytes.ConvertToString() + "]");
            }

            if (receivedBytes.Length < length)
            {
                // 受信済みデータのサイズが電文長に満たない場合は受信処理を継続する
                return false;
            }

            // 電文を全て受信できたため受信処理を終了する
            return true;
        }

        private static Service.RecieveResultConstants ReceptionCompleted(dynamic data, int retryCount, string receivedStream)
        {
            // 受信電文を解析する
            List<string> errorList = null;
            Dictionary<string, string> values = null;
            TelegramInfo.Parse(receivedStream, ref errorList, ref values);

            // 応答種別
            string resStatusNamne = values["SYUBETU"];
            ResponseStatus resStatus;
            switch (resStatusNamne)
            {
                case "OK":      // 正常
                    resStatus = ResponseStatus.Ok;
                    break;
                case "NG":      // 接続異常
                    resStatus = ResponseStatus.Ng;
                    break;
                case "N1":      // リトライ
                    resStatus = ResponseStatus.Retry;
                    break;
                case "N2":      // スキップ
                    resStatus = ResponseStatus.Skip;
                    break;
                case "N3":      // ダウン
                    resStatus = ResponseStatus.Down;
                    break;
                case "N4":      // データなし
                    resStatus = ResponseStatus.NotFound;
                    break;
                default:
                    resStatus = ResponseStatus.Else;
                    break;
            }

            // 応答種別受信
            Logging.Output(
                Logging.LogTypeConstants.ResponseReceived,
                resStatusNamne);

            // 取得した個人プロファイルを更新する
            if (resStatus == ResponseStatus.Ok)
            {
                // 個人プロファイルの取込項目設定情報を取得する
                dynamic freeList = null;
                try
                {
                    // URLを編集する
                    string getUri =
                        string.Format("api/v1/frees/classed?mode={0}&freeClassCd={1}",
                            Uri.EscapeDataString("0"), Uri.EscapeDataString("PFL"));

                    // 汎用テーブルを読み込む
                    Task<dynamic> taskGetData = WebAPI.GetDataAsync(ApiUri, getUri);
                    taskGetData.Wait();

                    if (taskGetData.Result != null && taskGetData.Result is string)
                    {
                        string msg = string.Format(
                            "汎用テーブルの読込処理でエラーが発生しました。{0}",
                                (string)taskGetData.Result);
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted", msg);
                        return Service.RecieveResultConstants.Error;
                    }

                    freeList = taskGetData.Result;
                }
                catch (Exception ex)
                {
                    string msg = "汎用テーブルの読込処理でエラーが発生しました。";
                    Logging.Output(
                        Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted", msg, ex);
                    return Service.RecieveResultConstants.Error;
                }

                // 患者番号（先頭部分の0を取り除く）
                int.TryParse(values["RESV-ID"].Trim(), out int tmpPerId);
                string perId = tmpPerId.ToString();

                int index = 0;
                var resultList = new List<dynamic>();
                while (true)
                {
                    // 次のデータに処理を移す
                    index++;

                    // 個人プロファイルのデータが存在しない場合は処理を終了する
                    if (!values.ContainsKey(string.Format("PROF-ATTR-{0}", index)))
                    {
                        break;
                    }

                    // 属性、項目コード、値、更新日を取得する
                    var profAttr = values[string.Format("PROF-ATTR-{0}", index)].Trim();
                    var profItemCd = values[string.Format("PROF-ITEMCD-{0}", index)].Trim();
                    var profValue = values[string.Format("PROF-VALUE-{0}", index)].Trim();
                    var profDate = values[string.Format("PROF-DATE-{0}", index)].Trim();

                    // 個人プロファイルの属性、項目コード、値の何れかが空白の場合は
                    // 次のデータに処理を移す
                    if (profAttr.Equals("") ||
                        profItemCd.Equals("") ||
                        profValue.Equals(""))
                    {
                        continue;
                    }

                    // 汎用テーブルの取込項目設定情報より
                    // 検査項目コード／サフィックスを取得する
                    var itemCd = "";
                    var suffix = "";
                    for (int i = 0; i < freeList.Count; i++)
                    {
                        if (freeList[i].freefield1 != null &&
                            freeList[i].freefield2 != null &&
                            freeList[i].freefield3 != null &&
                            freeList[i].freefield4 != null &&
                            Convert.ToString(freeList[i].freefield1).Trim().Equals(profAttr) &&
                            Convert.ToString(freeList[i].freefield2).Trim().Equals(profItemCd))
                        {
                            itemCd = Convert.ToString(freeList[i].freefield3).Trim();
                            suffix = Convert.ToString(freeList[i].freefield4).Trim();
                            break;
                        }
                    }

                    // 検査項目コード／サフィックスが取得できなかった場合は
                    // 更新対象外とみなして次のデータに処理を移す
                    if (itemCd.Equals("") ||
                        suffix.Equals(""))
                    {
                        continue;
                    }

                    // 検査結果のコードを変換する
                    var result = ResultCode.Convert(itemCd, suffix, profValue);
                    if (result.Equals(""))
                    {
                        // 変換できなかった場合は
                        // 変換前の値をそのまま更新する
                        result = profValue;
                    }

                    // 検査結果のコードの8バイトに収める
                    result = result.CutLeft(8).Trim();

                    // 検査日
                    var ispDate = "";
                    if (DateTime.TryParseExact(
                            profDate, "yyyyMMddHHmmss", 
                            System.Globalization.CultureInfo.InvariantCulture, 
                            System.Globalization.DateTimeStyles.None, out DateTime tempDt))
                    {
                        // 日時に変換できた場合はその値を検査日として更新する
                        ispDate = tempDt.ToString("yyyy/MM/dd HH:mm:ss");
                    }

                    // 更新するデータを退避する
                    resultList.Add(new
                    {
                        itemcd = itemCd,
                        suffix,
                        upddiv = 0,
                        result,
                        ispdate = ispDate,
                    });

                    // 更新するデータをログに出力する
                    string msg = string.Format(
                        "個人プロファイル [{0}] [{1}-{2}] [{3}] [{4}]",
                        perId, itemCd, suffix, result, ispDate);
                    Logging.Output(
                        Logging.LogTypeConstants.FreeOutput, msg);
                }

                // 更新対象データが存在する場合
                if (resultList.Count >= 0)
                {
                    try
                    {
                        // 更新対象データを準備する
                        var postData = new Model.PerResult.PerResult()
                        {
                            PerId = perId,
                            PerResultItem = new Model.PerResult.PerResultItem[resultList.Count],
                        };
                        for (int i = 0; i < resultList.Count; i++)
                        {
                            postData.PerResultItem[i] = new Model.PerResult.PerResultItem()
                            {
                                ItemCd = resultList[i].itemcd,
                                Suffix = resultList[i].suffix,
                                UpdDiv = resultList[i].upddiv.ToString(),
                                Result = resultList[i].result,
                                IspDate = resultList[i].ispdate,
                            };
                        }

                        // URLを編集する
                        string postUri =
                            string.Format("api/v1/people/{0}/results", Uri.EscapeDataString(perId));

                        // 個人プロファイルを更新する
                        Task<dynamic> taskPostData = WebAPI.PostDataAsync
                            <Model.PerResult.PerResult>(ApiUri, postUri, postData);
                        taskPostData.Wait();

                        if (taskPostData.Result != null && taskPostData.Result is string)
                        {
                            // エラー内容をログに出力する
                            Logging.Output(
                                Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted",
                                "個人プロファイルの登録処理でエラーが発生しました。" + (string)taskPostData.Result);
                            return Service.RecieveResultConstants.Error;
                        }
                    }
                    catch (Exception ex)
                    {
                        string msg = "個人プロファイルの登録処理でエラーが発生しました。";
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted", msg, ex);
                        return Service.RecieveResultConstants.Error;
                    }
                }
            }

            // 個人プロファイル取得ジャーナルを削除する
            if (resStatus == ResponseStatus.Ok ||
                resStatus == ResponseStatus.NotFound)
            {
                try
                {
                    // URLを編集する
                    string deleteUri =
                        string.Format("api/v1/personjournals?tskdate={0}&perid={1}",
                            Uri.EscapeDataString(Convert.ToDateTime(data.tskdate).ToString("yyyy/MM/dd HH:mm:ss")), 
                            Uri.EscapeDataString(Convert.ToString(data.perid)));

                    // 個人プロファイル取得ジャーナルを削除する
                    Task <dynamic> taskDeleteData = WebAPI.DeleteDataAsync(ApiUri, deleteUri);
                    taskDeleteData.Wait();

                    if (taskDeleteData.Result != null && taskDeleteData.Result is string)
                    {
                        string msg = string.Format(
                            "個人プロファイル取得ジャーナルの削除処理でエラーが発生しました。{0}",
                                (string)taskDeleteData.Result);
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted", msg);
                        return Service.RecieveResultConstants.Error;
                    }
                }
                catch (Exception ex)
                {
                    string msg = "個人プロファイル取得ジャーナルの削除処理でエラーが発生しました。";
                    Logging.Output(
                        Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted", msg, ex);
                    return Service.RecieveResultConstants.Error;
                }
            }

            if (resStatus == ResponseStatus.Retry && retryCount == 0)
            {
                // 応答種別がリトライでかつ初回のみリトライを行う
                return Service.RecieveResultConstants.Retry;
            }
            else if (resStatus == ResponseStatus.Ok ||
                     resStatus == ResponseStatus.NotFound)
            {
                // 正常（成功、データなし）
                return Service.RecieveResultConstants.Success;
            }
            else
            {
                // その他（エラー）
                return Service.RecieveResultConstants.Error;
            }
        }

        private static void OutoutErrLogMsg(dynamic data)
        {
            string msg = string.Format(
                "電子カルテシステムからの個人プロファイルの受信に失敗しました。[個人ID:{0}]", 
                    data.perid);
            Logging.Output(
                Logging.LogTypeConstants.Error, "Program", "OutoutErrLogMsg", msg);
        }
    }
}
