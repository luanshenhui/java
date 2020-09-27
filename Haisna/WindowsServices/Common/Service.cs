using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Sockets;
using System.Reflection;
using System.ServiceProcess;

namespace Fujitsu.Hainsi.WindowServices.Common
{
    public partial class Service : ServiceBase
    {
        /// <summary>
        /// 受信処理結果
        /// </summary>
        public enum RecieveResultConstants
        {
            Success,
            Retry,
            Error,
        }

        // サーバホスト名
        private string serverHostName = "";

        // ポート番号
        private string port = "";

        // ポーリング間隔（単位:ミリ秒）
        private string pollingInterval = "";

        // ソケット受信タイムアウト（単位:ミリ秒）
        private int socketRecieveTimeout = 0;

        // ソケット送信タイムアウト（単位:ミリ秒）
        private int socketSendTimeout = 0;

        // 開始処理コールバック
        public Action<TelegramInfo> OnStartCallback = null;

        // 送信対象データ取得処理コールバック
        public Func<dynamic> GetSourceDataCallback = null;

        // 送信電文編集処理コールバック
        public Func<dynamic, string> EditSendMessageCallback = null;

        // 受信終了判定コールバック
        public Func<MemoryStream, bool> IsEndOfReceptionCallback = null;

        // 受信完了コールバック
        public Func<dynamic, int, string, RecieveResultConstants> ReceptionCompletedCallback = null;

        // エラーログ出力コールバック
        public Action<dynamic> OutoutErrLogMsgCallback = null;

        public Service(
            string serviceName, string serverHostName, string port, string pollingInterval,
            string socketRecieveTimeout, string socketSendTimeout)
        {
            InitializeComponent();

            // サービス名
            this.ServiceName = serviceName;
            eventLog.Source = serviceName;

            // サーバホスト名
            this.serverHostName = serverHostName;

            // ポート番号
            this.port = port;

            // ポーリング間隔
            this.pollingInterval = pollingInterval;

            // ソケット受信タイムアウト（単位:ミリ秒）
            if (!int.TryParse(socketRecieveTimeout, out this.socketRecieveTimeout))
            {
                this.socketRecieveTimeout = 10000;
            }

            // ソケット送信タイムアウト（単位:ミリ秒）
            if (!int.TryParse(socketSendTimeout, out this.socketSendTimeout))
            {
                this.socketSendTimeout = 10000;
            }
        }

        protected override void OnStart(string[] args)
        {
            //// デバック実行時にVisualStudioでアタッチできるようにする
            //System.Diagnostics.Debugger.Launch();

            // 電文送信プログラム起動
            Logging.Output(Logging.LogTypeConstants.ClientStart);

            // 電文定義ファイルが存在するかチェックする
            string fileName = Path.Combine(
                Path.GetDirectoryName(Assembly.GetEntryAssembly().Location),
                Path.GetFileNameWithoutExtension(Assembly.GetEntryAssembly().Location) + ".json");
            if (!File.Exists(fileName))
            {
                string msg = "サービスの開始処理に失敗しました。\n" +
                    "電文定義ファイル\"" + fileName + "\"が存在しません。";
                Logging.Output(Logging.LogTypeConstants.Error, "Service", "OnStart", msg.Replace("\n", ""));
                CancelOnStart(msg);
                return;
            }

            TelegramInfo telegramInfo = null;
            try
            {
                // 電文定義ファイルを読み込む
                telegramInfo = TelegramInfo.ReadJsonFile(fileName);
            }
            catch (Exception ex)
            {
                string msg = "サービスの開始処理に失敗しました。\n" +
                    "電文定義ファイル\"" + fileName + "\"の取得処理でエラーが発生しました。";
                Logging.Output(Logging.LogTypeConstants.Error, "Service", "OnStart", msg.Replace("\n", ""), ex);
                msg += "\n" + ex.Message + "\n" + ex.StackTrace;
                CancelOnStart(msg);
            }

            // サーバホスト名
            if (serverHostName == null || serverHostName.Trim().Equals(""))
            {
                string msg = "サービスの開始処理に失敗しました。\n" +
                    "サーバホスト名が設定されていません。";
                Logging.Output(Logging.LogTypeConstants.Error, "Service", "OnStart", msg.Replace("\n", ""));
                CancelOnStart(msg);
                return;
            }

            // ポート番号
            int tmpPortNo = 0;
            if (port == null || port.Trim().Equals(""))
            {
                string msg = "サービスの開始処理に失敗しました。\n" +
                    "ポート番号が設定されていません。";
                Logging.Output(Logging.LogTypeConstants.Error, "Service", "OnStart", msg.Replace("\n", ""));
                CancelOnStart(msg);
                return;
            }
            else if (!int.TryParse(port.Trim(), out tmpPortNo))
            {
                string msg = "サービスの開始処理に失敗しました。\n" +
                    string.Format("ポート番号に無効な値\"{0}\"が設定されています。", port.Trim());
                Logging.Output(Logging.LogTypeConstants.Error, "Service", "OnStart", msg.Replace("\n", ""));
                CancelOnStart(msg);
                return;
            }

            // ポーリング間隔
            double tmpPollingInterval = 0;
            if (pollingInterval == null || pollingInterval.Trim().Equals(""))
            {
                string msg = "サービスの開始処理に失敗しました。\n" +
                    "ポーリング間隔が設定されていません。";
                Logging.Output(Logging.LogTypeConstants.Error, "Service", "OnStart", msg.Replace("\n", ""));
                CancelOnStart(msg);
                return;
            }
            else if (!double.TryParse(pollingInterval.Trim(), out tmpPollingInterval))
            {
                string msg = "サービスの開始処理に失敗しました。\n" +
                    string.Format("ポーリング間隔に無効な値\"{0}\"が設定されています。", pollingInterval.Trim());
                Logging.Output(Logging.LogTypeConstants.Error, "Service", "OnStart", msg.Replace("\n", ""));
                CancelOnStart(msg);
                return;
            }

            // 開始処理コールバック
            if (OnStartCallback != null)
            {
                try
                {
                    OnStartCallback(telegramInfo);
                }
                catch (Exception ex)
                {
                    string msg = "サービスの開始処理に失敗しました。\n" + ex.Message;
                    Logging.Output(Logging.LogTypeConstants.Error, "Service", "OnStart", msg.Replace("\n", ""), ex);
                    CancelOnStart(msg);
                    return;
                }
            }

            // 送信データチェック処理開始
            timer.Interval = tmpPollingInterval;
            timer.Enabled = true;
        }

        protected override void OnStop()
        {
            // 送信データチェック処理終了
            if (timer.Enabled)
            {
                timer.Enabled = false;
            }

            // 電文送信プログラム終了
            Logging.Output(Logging.LogTypeConstants.ClientEnd);
        }

        private void CancelOnStart(string message)
        {
            // イベントログへの自動ログ出力を停止する
            this.AutoLog = false;

            // イベントログにエラー内容を出力する
            eventLog.WriteEntry(message, System.Diagnostics.EventLogEntryType.Error);

            // サービスを終了する
            this.Stop();
        }

        private bool Send(NetworkStream ns, string message)
        {
            // 送信データ
            byte[] bytes = message.GetBytes();

            // 電文送信
            Logging.Output(
                Logging.LogTypeConstants.DataSend,
                "送信電文 " + bytes.Length.ToString("#,##0") + " byte：[" +
                bytes.ConvertToString() + "]");

            // データを送信する
            try
            {
                ns.Write(bytes, 0, bytes.Length);
                ns.Flush();
            }
            catch (System.IO.IOException)
            {
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Service", "Send",
                    "送信タイムアウトが発生しました");
                return false;
            }

            return true;
        }

        private string Receive(NetworkStream ns)
        {
            // 受信データを蓄積するためのMemorySreamインスタンスを作成
            using (var memoryStream = new MemoryStream())
            {
                int receiveSize = 0;
                byte[] buffer = new byte[1024];

                while (true)
                {
                    // データの一部を受信する
                    try
                    {
                        receiveSize = ns.Read(buffer, 0, buffer.Length);
                    }
                    catch (System.IO.IOException)
                    {
                        // 受信タイムアウト
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Service", "Receive",
                            "受信タイムアウトが発生しました 受信済み電文 " + memoryStream.ToArray().Length.ToString("#,##0") + " byte：[" +
                            memoryStream.ToArray().ConvertToString() + "]");
                        return "";
                    }

                    // ソケットが切断されたかをチェックする
                    if (receiveSize == 0)
                    {
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Service", "Receive",
                            "相手側システムが接続を切断しました 受信済み電文 " + memoryStream.ToArray().Length.ToString("#,##0") + " byte：[" +
                            memoryStream.ToArray().ConvertToString() + "]");
                        return "";
                    }

                    // 電文受信
                    Logging.Output(
                        Logging.LogTypeConstants.DataArrival,
                        receiveSize.ToString("#,##0") + " byte");

                    // 受信したデータを蓄積
                    memoryStream.Write(buffer, 0, receiveSize);

                    // 受信終了判定
                    try
                    {
                        if ((IsEndOfReceptionCallback == null) || (IsEndOfReceptionCallback(memoryStream)))
                        {
                            Logging.Output(
                                Logging.LogTypeConstants.DataArrival,
                                "受信電文 " + memoryStream.ToArray().Length.ToString("#,##0") + " byte：[" +
                                memoryStream.ToArray().ConvertToString() + "]");
                            break;
                        }
                    }
                    catch (Exception ex)
                    {
                        // 電文長に数値以外の値が設定されている場合
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Service", "Receive", ex.Message);
                        return "";
                    }
                }

                // 受信したデータを戻す
                return memoryStream.ToArray().ConvertToString();
            }
        }

        private void timer_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            // タイマーを一時停止する
            timer.Enabled = false;

            // 送信対象データを取得する
            dynamic sourceList = null;
            if (GetSourceDataCallback != null)
            {
                try
                {
                    sourceList = GetSourceDataCallback();
                }
                catch (Exception ex)
                {
                    // 送信対象データの取得処理でエラーが発生した場合
                    string msg = "送信対象データの取得処理でエラーが発生しました。";
                    Logging.Output(
                        Logging.LogTypeConstants.Error, "Service", "timer_Elapsed", msg, ex);
                    timer.Enabled = true;
                    return;
                }
            }

            // 送信対象データが存在しない場合は処理を終了する
            if (sourceList == null || sourceList.Count == 0)
            {
                timer.Enabled = true;
                return;
            }

            // リトライ回数
            int retryCount = 0;

            for (int i = 0; i < sourceList.Count; i++)
            {
                // 送信対象データ
                var item = sourceList[i];

                try
                {
                    // 相手側連携サーバに接続する
                    using (TcpClient client = new TcpClient(serverHostName, int.Parse(port)))
                    using (NetworkStream netStream = client.GetStream())
                    {
                        // 接続
                        Logging.Output(Logging.LogTypeConstants.Connect);

                        // 送受信タイムアウト時間の設定
                        netStream.ReadTimeout = socketRecieveTimeout;
                        netStream.WriteTimeout = socketSendTimeout;

                        // 送信電文を編集する
                        string sendData = "";
                        if (EditSendMessageCallback != null)
                        {
                            sendData = EditSendMessageCallback(item);
                        }
                        if (sendData.Equals(""))
                        {
                            // エラーログ出力
                            OutoutErrLogMsgCallback?.Invoke(item);

                            // 接続終了
                            Logging.Output(Logging.LogTypeConstants.Close);

                            continue;
                        }

                        // 電文を送信する
                        if (!Send(netStream, sendData))
                        {
                            // エラーログ出力
                            OutoutErrLogMsgCallback?.Invoke(item);

                            // 接続終了
                            Logging.Output(Logging.LogTypeConstants.Close);

                            continue;
                        }

                        // 電文を受信する
                        string receiveData = Receive(netStream);
                        if (receiveData.Equals(""))
                        {
                            // エラーログ出力
                            OutoutErrLogMsgCallback?.Invoke(item);

                            // 接続終了
                            Logging.Output(Logging.LogTypeConstants.Close);

                            continue;
                        }

                        // 電文受信完了
                        if (ReceptionCompletedCallback != null)
                        {
                            switch (ReceptionCompletedCallback(item, retryCount, receiveData))
                            {
                                case RecieveResultConstants.Success:
                                    // 処理完了
                                    retryCount = 0;
                                    break;
                                case RecieveResultConstants.Retry:
                                    // リトライの場合は同じデータをもう一度処理する
                                    i--;
                                    retryCount++;
                                    break;
                                case RecieveResultConstants.Error:
                                    // エラー
                                    OutoutErrLogMsgCallback?.Invoke(item);
                                    retryCount = 0;
                                    break;
                            }
                        }

                        // 接続終了
                        Logging.Output(Logging.LogTypeConstants.Close);
                    }
                }
                catch (Exception ex)
                {
                    // 相手側システムへの接続に失敗した場合
                    Logging.Output(
                        Logging.LogTypeConstants.Error, "Service", "timer_Elapsed",
                        "相手側システムへの接続に失敗しました。", ex);
                    OutoutErrLogMsgCallback?.Invoke(item);
                }
            }

            // タイマーを再開する
            timer.Enabled = true;
        }
    }
}
