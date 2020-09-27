using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Reflection;
using System.ServiceProcess;
using System.Threading.Tasks;

namespace Fujitsu.Hainsi.WindowServices.Common
{
    public partial class Listener : ServiceBase
    {
        // Listerオブジェクト
        private TcpListener tcpListener = null;

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

        // 受信終了判定コールバック
        public Func<MemoryStream, bool> IsEndOfReceptionCallback = null;

        // 受信完了コールバック
        public Func<string, byte[]> ReceptionCompletedCallback = null;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        public Listener(
            string serviceName, string port, string pollingInterval,
            string socketRecieveTimeout, string socketSendTimeout)
        {
            InitializeComponent();

            // サービス名
            this.ServiceName = serviceName;
            eventLog.Source = serviceName;

            // ポート番号
            this.port = port;

            // ポーリング間隔
            this.pollingInterval = pollingInterval;

            // ソケット受信タイムアウト（単位:ミリ秒）
            if (!int.TryParse(socketRecieveTimeout,out this.socketRecieveTimeout))
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

            // 電文受信プログラム起動
            Logging.Output(Logging.LogTypeConstants.ServerStart);

            // 電文定義ファイルが存在するかチェックする
            string fileName = Path.Combine(
                Path.GetDirectoryName(Assembly.GetEntryAssembly().Location),
                Path.GetFileNameWithoutExtension(Assembly.GetEntryAssembly().Location) + ".json");
            if (!File.Exists(fileName))
            {
                string msg = "サービスの開始処理に失敗しました。\n" +
                    "電文定義ファイル\"" + fileName + "\"が存在しません。";
                Logging.Output(Logging.LogTypeConstants.Error, "Listener", "OnStart", msg.Replace("\n", ""));
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

            // ポート番号
            int tmpPortNo = 0;
            if (port == null || port.Trim().Equals(""))
            {
                string msg = "サービスの開始処理に失敗しました。\n" +
                    "ポート番号が設定されていません。";
                Logging.Output(Logging.LogTypeConstants.Error, "Listener", "OnStart", msg.Replace("\n", ""));
                CancelOnStart(msg);
                return;
            }
            else if (!int.TryParse(port.Trim(), out tmpPortNo))
            {
                string msg = "サービスの開始処理に失敗しました。\n" +
                    string.Format("ポート番号に無効な値\"{0}\"が設定されています。", port.Trim());
                Logging.Output(Logging.LogTypeConstants.Error, "Listener", "OnStart", msg.Replace("\n", ""));
                CancelOnStart(msg);
                return;
            }

            // ポーリング間隔
            double tmpPollingInterval = 0;
            if (pollingInterval == null || pollingInterval.Trim().Equals(""))
            {
                string msg = "サービスの開始処理に失敗しました。\n" +
                    "ポーリング間隔が設定されていません。";
                Logging.Output(Logging.LogTypeConstants.Error, "Listener", "OnStart", msg.Replace("\n", ""));
                CancelOnStart(msg);
                return;
            }
            else if (!double.TryParse(pollingInterval.Trim(), out tmpPollingInterval))
            {
                string msg = "サービスの開始処理に失敗しました。\n" +
                    string.Format("ポーリング間隔に無効な値\"{0}\"が設定されています。", pollingInterval.Trim());
                Logging.Output(Logging.LogTypeConstants.Error, "Listener", "OnStart", msg.Replace("\n", ""));
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
                    Logging.Output(Logging.LogTypeConstants.Error, "Listener", "OnStart", msg.Replace("\n", ""), ex);
                    CancelOnStart(msg);
                    return;
                }
            }

            try
            {
                // listenerオブジェクトの作成
                tcpListener = new TcpListener(IPAddress.IPv6Any, tmpPortNo);
                tcpListener.Server.SetSocketOption(
                    SocketOptionLevel.IPv6, SocketOptionName.IPv6Only, false);

                // リッスン開始
                tcpListener.Start();

                // クライアントからの接続待機開始
                timer.Interval = tmpPollingInterval;
                timer.Enabled = true;
            }
            catch (Exception ex)
            {
                // 開始処理に失敗した場合はサービスを終了する
                string msg = string.Format("サービスの開始処理に失敗しました。ポート番号:{0}", this.port);
                Logging.Output(Logging.LogTypeConstants.Error, "Listener", "OnStart", msg.Replace("\n", ""), ex);
                CancelOnStart(msg);
            }
        }

        protected override void OnStop()
        {
            // クライアントからの接続待機終了
            if (timer.Enabled)
            {
                timer.Enabled = false;
            }

            // リッスンの停止
            if (tcpListener != null)
            {
                tcpListener.Stop();
                tcpListener = null;
            }

            // 電文受信プログラム終了
            Logging.Output(Logging.LogTypeConstants.ServerEnd);
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

        private void AcceptTcpClient()
        {
            // 接続要求受信
            Logging.Output(Logging.LogTypeConstants.ConnectionRequest);

            // 接続要求の受け入れ
            using (TcpClient client = tcpListener.AcceptTcpClient())
            using (NetworkStream netStream = client.GetStream())
            {
                // 送受信タイムアウト時間の設定
                netStream.ReadTimeout = socketRecieveTimeout;
                netStream.WriteTimeout = socketSendTimeout;

                // 電文の受信／送信を繰り返す
                while (client.Connected)
                {
                    while (true)
                    {
                        // ソケットの状態が変わるまで待機する
                        if (client.Client.Poll(int.Parse(pollingInterval), SelectMode.SelectRead))
                        {
                            if (client.Client.Available == 0)
                            {
                                // 読み取るデータが存在しない場合
                                // クライアントから切断されたとみなして処理を終了する
                                Logging.Output(Logging.LogTypeConstants.Close);
                                return;
                            }
                            else
                            {
                                // 読み取るデータが存在する場合
                                break;
                            }
                        }
                    }

                    // 電文を受信する
                    string receiveData = Receive(netStream);
                    if (receiveData == "")
                    {
                        continue;
                    }

                    // 電文を送信する
                    Send(netStream, receiveData);
                }
            }
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
                            if (memoryStream.Length > 0)
                            {
                                Logging.Output(
                                    Logging.LogTypeConstants.Error, "Listener", "Receive",
                                    "受信タイムアウトが発生しました 受信済み電文 " + memoryStream.ToArray().Length.ToString("#,##0") + " byte：[" +
                                    memoryStream.ToArray().ConvertToString() + "]");
                            }
                            return "";
                        }

                        // データを受信できなかった場合
                        if (receiveSize == 0)
                        {
                            if (memoryStream.Length > 0)
                            {
                                Logging.Output(
                                    Logging.LogTypeConstants.Error, "Listener", "Receive",
                                    "電文を全て受信できませんでした 受信済み電文 " + memoryStream.ToArray().Length.ToString("#,##0") + " byte：[" +
                                    memoryStream.ToArray().ConvertToString() + "]");
                            }
                            return "";
                        }

                        // 受信したデータを蓄積
                        memoryStream.Write(buffer, 0, receiveSize);

                        try
                        {
                            // 受信できるデータが残っていない場合は
                            // 受診終了判定処理に進む
                            if (!ns.DataAvailable)
                            {
                                break;
                            }
                        }
                        catch
                        {
                            if (memoryStream.Length > 0)
                            {
                                Logging.Output(
                                    Logging.LogTypeConstants.Error, "Listener", "Receive",
                                    "電文を全て受信できませんでした 受信済み電文 " + memoryStream.ToArray().Length.ToString("#,##0") + " byte：[" +
                                    memoryStream.ToArray().ConvertToString() + "]");
                            }
                            return "";
                        }
                    }

                    // 電文受信
                    Logging.Output(
                        Logging.LogTypeConstants.DataArrival,
                        memoryStream.Length.ToString("#,##0") + " byte");

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
                            Logging.LogTypeConstants.Error, "Listener", "Receive", ex.Message);
                        return "";
                    }
                }

                // 受信したデータを戻す
                return memoryStream.ToArray().ConvertToString();
            }
        }

        private void Send(NetworkStream ns, string receiveData)
        {
            // 応答文字列の作成
            byte[] bytes = default(byte[]);
            if (ReceptionCompletedCallback != null)
            {
                bytes = ReceptionCompletedCallback(receiveData);
            }

            // 電文送信
            Logging.Output(
                Logging.LogTypeConstants.DataSend,
                "送信電文 "  + bytes.Length.ToString("#,##0") + " byte：[" + 
                bytes.ConvertToString() + "]");

            // データを送信する
            try
            {
                ns.Write(bytes, 0, bytes.Length);
            }
            catch (System.IO.IOException)
            {
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Listener", "Send",
                    "送信タイムアウトが発生しました");
            }
        }

        private void timer_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            // 保留中の要求が存在するならば接続要求受入タスクを開始する
            if (tcpListener.Pending())
            {
                Task task = Task.Factory.StartNew(this.AcceptTcpClient);
            }
        }
    }
}
