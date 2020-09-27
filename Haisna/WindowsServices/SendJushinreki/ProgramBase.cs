using Fujitsu.Hainsi.WindowServices.Common;
using Model = Hainsi.Entity.Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace Fujitsu.Hainsi.WindowServices.SendJushinreki
{
    public class ProgramBase : ManagedInstaller
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
            Else,
        }

        /// <summary>
        /// 連携処理タイプ
        /// </summary>
        public enum ExecTypeConstants
        {
            /// <summary>
            /// カルテ
            /// </summary>
            Smile,

            /// <summary>
            /// 医事
            /// </summary>
            Hope,
        }

        /// <summary>
        /// 電文情報クラス
        /// </summary>
        private static TelegramInfo TelegramInfo = null;

        /// <summary>
        /// 受信電文の電文長
        /// </summary>
        private static int RecieveByteLen = 0;

        /// <summary>
        /// 送信電文の電文長
        /// </summary>
        private static int SendByteLen = 0;

        /// <summary>
        /// 連携処理タイプ
        /// </summary>
        public static ExecTypeConstants ExecType { get; set; }

        /// <summary>
        /// 受診科コード
        /// </summary>
        private static string JushinCd = "";

        /// <summary>
        /// 部署コード
        /// </summary>
        private static string BusyoCd = "";

        /// <summary>
        /// 端末名
        /// </summary>
        private static string ComputerName = "";

        /// <summary>
        /// 利用者ID
        /// </summary>
        private static string UserId = "";

        /// <summary>
        /// 利用者氏名
        /// </summary>
        private static string UserName = "";

        /// <summary>
        /// 受診歴送信ジャーナル.送信区分（更新対象）
        /// </summary>
        private static int UpdSendDiv = -1;

        /// <summary>
        /// 受診歴送信ジャーナル.送信区分（更新後）
        /// </summary>
        private static int AftSendDiv = -1;

        /// <summary>
        /// 受診歴送信ジャーナル.送信区分（削除対象）
        /// </summary>
        private static int DelSendDiv = -1;

        /// <summary>
        /// Web API のベースURL
        /// </summary>
        private static string ApiUri = "";

        /// <summary>
        /// アプリケーションのメイン エントリ ポイントです。
        /// </summary>
        public static void Main(string[] args)
        {
            // ログ出力クラスを初期化する
            switch (ExecType)
            {
                case ExecTypeConstants.Smile:   // カルテ
                    Logging.Initialize(Logging.DestSystemConstants.Smile);
                    break;
                case ExecTypeConstants.Hope:    // 医事
                    Logging.Initialize(Logging.DestSystemConstants.Hope);
                    break;
            }

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

            // 送受信電文の電文長を計算する
            foreach (TelegramInfo.TelegramItem item in TelegramInfo.Items)
            {
                // 受信電文の項目のバイト数を加算する
                if (item.RecvUseFlg == 1)
                {
                    RecieveByteLen += item.Length;
                }

                // 送信電文の項目のバイト数を加算する
                if (item.SendUseFlg == 1)
                {
                    SendByteLen += item.Length;
                }
            }

            switch (ExecType)
            {
                case ExecTypeConstants.Smile:   // カルテ
                    // 部署コード
                    BusyoCd = ConfigurationManager.AppSettings["SendDataBusyoCd"].Trim();
                    if (string.IsNullOrEmpty(BusyoCd))
                    {
                        throw new Exception("部署コードが設定されていません。");
                    }

                    // 利用者氏名
                    UserName = ConfigurationManager.AppSettings["SendDataRiyosyaName"].Trim();
                    if (string.IsNullOrEmpty(UserName))
                    {
                        throw new Exception("利用者氏名が設定されていません。");
                    }

                    break;
                case ExecTypeConstants.Hope:    // 医事
                    // 受診科コード
                    JushinCd = ConfigurationManager.AppSettings["SendDataJushinCd"].Trim();
                    if (string.IsNullOrEmpty(JushinCd))
                    {
                        throw new Exception("受診科コードが設定されていません。");
                    }

                    break;
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

            // 受診歴送信ジャーナル.送信区分（更新対象）
            int.TryParse(ConfigurationManager.AppSettings["UpdSendDiv"].Trim(), out UpdSendDiv);

            // 受診歴送信ジャーナル.送信区分（更新後）
            int.TryParse(ConfigurationManager.AppSettings["AftSendDiv"].Trim(), out AftSendDiv);

            // 受診歴送信ジャーナル.送信区分（削除対象）
            int.TryParse(ConfigurationManager.AppSettings["DelSendDiv"].Trim(), out DelSendDiv);

            // Web API のベースURL
            ApiUri = ConfigurationManager.AppSettings["ApiUri"].Trim();
            if (string.IsNullOrEmpty(ApiUri))
            {
                throw new Exception("Web API のベースURLが設定されていません。");
            }
        }

        private static dynamic GetSourceData()
        {
            // 送信区分
            string sendDiv =
                "?senddiv=" + UpdSendDiv.ToString() +
                "&senddiv=" + DelSendDiv.ToString();

            // 送信対象データを取得する
            Task<dynamic> taskGetData = WebAPI.GetDataAsync(
                ApiUri, "api/v1/consultjournals" + sendDiv);

            // 取得した送信対象データを戻す
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
                    ApiUri, "api/v1/consultjournals/seqno");
                seqNo = (int)taskGetData.Result;
            }
            catch (Exception ex)
            {
                string msg = "連番の取得処理でエラーが発生しました。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "ProgramBase", "EditSendMessage", msg, ex);
                return "";
            }

            switch (ExecType)
            {
                case ExecTypeConstants.Smile:   // カルテ
                    // 連番
                    message.Append(seqNo.ToString("D5").PadRightEx(5));
                    // システムコード("H"固定)
                    message.Append("H".PadRightEx(1));
                    // 電文種別("JY"固定)
                    message.Append("JY".PadRightEx(2));
                    // 継続フラグ("E"固定)
                    message.Append("E".PadRightEx(1));
                    // 送信先システムコード("E"固定)
                    message.Append("E".PadRightEx(1));
                    // 発信元システムコード("K"固定)
                    message.Append("K".PadRightEx(1));
                    // 処理年月日
                    message.Append(DateTime.Now.ToString("yyyyMMdd").PadRightEx(8));
                    // 処理時刻
                    message.Append(DateTime.Now.ToString("HHmmss").PadRightEx(6));
                    // 端末名
                    message.Append(ComputerName.PadRightEx(8));
                    // 利用者番号(=利用者ID)
                    message.Append(UserId.PadRightEx(8));
                    // 処理区分
                    if (data.tskdiv == 1)       // 来院
                    {
                        message.Append("01".PadRightEx(2));
                    }
                    else if (data.tskdiv == 2)  // 来院取消
                    {
                        message.Append("03".PadRightEx(2));
                    }
                    else
                    {
                        message.Append("".PadRightEx(2));
                    }
                    // 応答種別(空白)
                    message.Append("".PadRightEx(2));
                    // 電文長("基本部" 271バイト + "0D" 1バイト = 272バイト)
                    message.Append(SendByteLen.ToString("D5").PadRightEx(5));
                    // 予備(空白)
                    message.Append("".PadRightEx(14));
                    // 患者番号
                    message.Append(((string)data.perid).PadLeft(10, '0').PadRightEx(10));
                    // 実施日
                    message.Append(((DateTime)data.comedate).ToString("yyyyMMdd").PadRightEx(8));
                    // 実施時間
                    message.Append(((DateTime)data.comedate).ToString("HHmmss").PadRightEx(6));
                    // 入外区分("1"固定)
                    message.Append("1".PadRightEx(1));
                    // 部署（診療科）
                    message.Append(BusyoCd.PadLeftEx(3));
                    // 病棟コード(空白)
                    message.Append("".PadRightEx(2));
                    // 病室コード(空白)
                    message.Append("".PadRightEx(5));
                    // 診察区分("1"固定)
                    message.Append("1".PadRightEx(1));
                    // 初再診区分
                    if (data.cslcount == 1)         // 受診回数が１回
                    {
                        // 初診
                        message.Append("1".PadRightEx(1));
                    }
                    else if (data.cslcount >= 2)     // 受診回数が２回以上
                    {
                        // 再診
                        message.Append("2".PadRightEx(1));
                    }
                    else
                    {
                        message.Append("".PadRightEx(1));
                    }
                    // 診察コメント(空白)
                    message.Append("".PadRightEx(50));
                    // 保険番号(空白)
                    message.Append("".PadRightEx(2));
                    // 保険名称(空白)
                    message.Append("".PadRightEx(42));
                    // 利用者ID
                    message.Append(UserId.PadRightEx(8));
                    // 利用者氏名
                    message.Append(UserName.PadRightEx(40));
                    // 端末名
                    message.Append(ComputerName.PadRightEx(8));
                    // 予備(空白)
                    message.Append("".PadRightEx(20));
                    // 終了コード("0D"固定)
                    message.Append("\r".PadRightEx(1));

                    break;
                case ExecTypeConstants.Hope:    // 医事
                    // 連番
                    message.Append(seqNo.ToString("D5").PadRightEx(5));
                    // システムコード("H"固定)
                    message.Append("H".PadRightEx(1));
                    // 電文種別("JR"固定)
                    message.Append("JR".PadRightEx(2));
                    // 継続フラグ("E"固定)
                    message.Append("E".PadRightEx(1));
                    // 宛先コード("H"固定)
                    message.Append("E".PadRightEx(1));
                    // 発信元コード("K"固定)
                    message.Append("K".PadRightEx(1));
                    // 処理日
                    message.Append(DateTime.Now.ToString("yyyyMMdd").PadRightEx(8));
                    // 処理時間
                    message.Append(DateTime.Now.ToString("HHmmss").PadRightEx(6));
                    // 端末名(固定 -> INIファイルから)
                    message.Append(ComputerName.PadRightEx(8));
                    // 利用者番号(=利用者ID)
                    message.Append(UserId.PadRightEx(8));
                    // 処理区分
                    if (data.tskdiv == 1)       // 来院
                    {
                        message.Append("01".PadRightEx(2));
                    }
                    else if (data.tskdiv == 2)  // 来院取消
                    {
                        message.Append("03".PadRightEx(2));
                    }
                    else
                    {
                        message.Append("".PadRightEx(2));
                    }
                    // 応答種別(空白)
                    message.Append("".PadRightEx(2));
                    // 電文長("基本部" 84バイト + "0D" 1バイト = 85バイト)
                    message.Append(SendByteLen.ToString("D5").PadRightEx(5));
                    // 空白(空白)
                    message.Append("".PadRightEx(14));
                    // 患者ID
                    message.Append(((string)data.perid).PadLeft(10, '0').PadRightEx(10));
                    // 受診科コード
                    message.Append(JushinCd.PadRightEx(2));
                    // 受診日
                    message.Append(((DateTime)data.comedate).ToString("yyyyMMdd").PadRightEx(8));
                    // 終了コード("0D"固定)
                    message.Append("\r".PadRightEx(1));

                    break;
            }

            // 送信電文の電文長をチェックする
            if (message.ToString().GetByteCount() != SendByteLen)
            {
                string msg = "作成した送信電文の電文長が不正です。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "ProgramBase", "EditSendMessage", msg);
                return "";
            }

            return message.ToString();
        }

        private static bool IsEndOfReception(MemoryStream memoryStream)
        {
            // 受信済みデータを取得する
            byte[] receivedBytes = memoryStream.ToArray();

            if (receivedBytes.Length < RecieveByteLen)
            {
                // 共通情報部分まで受信できていない場合は
                // 受信処理を継続する
                return false;
            }

            // 電文を全て受信できたため
            // 受信処理を終了する
            return true;
        }

        private static Service.RecieveResultConstants ReceptionCompleted(dynamic data, int retryCount, string receivedStream)
        {
            // 受信電文を解析する
            List<string> errorList = null;
            Dictionary<string, string> values = null;
            TelegramInfo.Parse(receivedStream, ref errorList, ref values);

            // 応答種別
            string resStatusNamne = "";
            ResponseStatus resStatus;
            switch (ExecType)
            {
                case ExecTypeConstants.Smile:   // カルテ
                    resStatusNamne = values["JUI-ANS-SBT"];
                    break;
                case ExecTypeConstants.Hope:    // 医事
                    resStatusNamne = values["SYUBETU"];
                    break;
            }
            switch (resStatusNamne)
            {
                case "OK":
                    resStatus = ResponseStatus.Ok;
                    break;
                case "N1":
                    resStatus = ResponseStatus.Retry;
                    break;
                case "N2":
                    resStatus = ResponseStatus.Skip;
                    break;
                case "N3":
                    resStatus = ResponseStatus.Down;
                    break;
                default:
                    resStatus = ResponseStatus.Else;
                    break;
            }

            // 応答種別受信
            Logging.Output(
                Logging.LogTypeConstants.ResponseReceived,
                resStatusNamne);

            // 受診歴送信ジャーナルを更新する
            if (resStatus == ResponseStatus.Ok)
            {
                // 更新データ
                Model.ConsultJnl.UpdateConsultJnl updData = new Model.ConsultJnl.UpdateConsultJnl()
                {
                    TskDate = data.tskdate,
                    RsvNo = data.rsvno,
                    UpdSendDiv = UpdSendDiv,
                    AftSendDiv = AftSendDiv,
                    DelSendDiv = DelSendDiv,
                };

                try
                {
                    // 受診歴送信ジャーナルを更新する
                    Task<dynamic> taskPutData = WebAPI.PutDataAsync<Model.ConsultJnl.UpdateConsultJnl>
                        (ApiUri, "api/v1/consultjournals/senddiv", updData);
                    taskPutData.Wait();

                    if (taskPutData.Result != null && taskPutData.Result is string)
                    {
                        string msg = string.Format(
                            "受診歴送信ジャーナルの{0}処理でエラーが発生しました。{1}",
                                (data.senddiv == DelSendDiv) ? "削除" : "更新", (string)taskPutData.Result);
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "ProgramBase", "ReceptionCompleted", msg);
                        return Service.RecieveResultConstants.Error;
                    }
                }
                catch (Exception ex)
                {
                    string msg = string.Format(
                        "受診歴送信ジャーナルの{0}処理でエラーが発生しました。",
                            (data.senddiv == DelSendDiv) ? "削除" : "更新");
                    Logging.Output(
                        Logging.LogTypeConstants.Error, "ProgramBase", "ReceptionCompleted", msg, ex);
                    return Service.RecieveResultConstants.Error;
                }
            }

            if (resStatus == ResponseStatus.Retry && retryCount == 0)
            {
                // 応答種別がリトライでかつ初回のみリトライを行う
                return Service.RecieveResultConstants.Retry;
            }
            else if (resStatus == ResponseStatus.Ok)
            {
                // 正常（成功）
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
            string msg = "";

            switch (ExecType)
            {
                case ExecTypeConstants.Smile:   // カルテ
                    msg = "電子カルテシステムへの受診歴の送信に失敗しました。";
                    break;
                case ExecTypeConstants.Hope:    // 医事
                    msg = "医事システムへの受診歴の送信に失敗しました。";
                    break;
            }
            msg += string.Format("[個人ID:{0},予約番号:{1}]", data.perid, data.rsvno);

            Logging.Output(
                Logging.LogTypeConstants.Error, "ProgramBase", "OutoutErrLogMsg", msg);
        }
    }
}
