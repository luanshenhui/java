using System;
using System.IO.Ports;
using System.Text;
using System.Collections.Generic;
using NLog;
using System.Windows.Forms;
using System.Collections.Specialized;

namespace ConnMeasuringEquipments
{
    /// <summary>
    /// 計測器連携オブジェクトスーパークラス
    /// </summary>
    abstract class AbstractExternalDevice
    {
        // シリアルポートセッティング関連

        // ボーレート
        public int BaudRate { get; set; }
        // データビット
        public int DataBits { get; set; }
        // パリティ
        public Parity Parity { get; set; }
        // ストップビット
        public StopBits StopBits { get; set; }
        // ハンドシェイク
        public Handshake Handshake { get; set; }
        // ボーレート
        public Encoding Encoding { get; set; }

        // 制御コード関連
        public readonly byte SOH = Convert.ToByte("01");
        public readonly byte STX = Convert.ToByte("02");
        public readonly byte ETX = Convert.ToByte("03");
        public readonly byte EOT = Convert.ToByte("04");
        public readonly byte ENQ = Convert.ToByte("05");
        public readonly byte ACK = Convert.ToByte("06");
        public readonly byte CR  = Convert.ToByte("13");

        // ステータス関連

        // 現在のステータス
        public int Status { set; get; } = 0;

        // ステータス: 計測器からの応答待ち=1
        public const int WaitResponse = 1;
        // ステータス: 計測器にデータ送信=2
        public const int ResponceToDevice = 2;
        // ステータス: サーバに結果送信後、処理終了=3
        public const int SendResultToServer = 3;
        // ステータス: 計測器にACK送信後、サーバに結果送信、処理終了
        public const int AckAndSendResultToServer = 4;
        // ステータス: 計測器に属性情報送信
        public const int SendAttributeToDevice = 5;
        // ステータス: 計測器に属性情報送信後、即終了
        public const int SendAttributeToDeviceAndExit = 6;
        // ステータス: サーバに結果送信後、計測器からの応答待ち=7
        public const int SendResultToServerWaitResponse = 7;
        // ステータス: アプリケーション終了（正常終了）
        public const int ExitApplication = 99;
        // ステータス: 重大エラー発生
        public const int Error = -9;

        // ログ出力用 - NLog
        private static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();

        // デバッグモード
        public bool DebugMode { get; set; } = false;

        // 受信データ編集処理
        public abstract bool EditRecievedData(byte[] bufferData);

        // 属性データ取得
        public abstract string GetAttributeData();

        // 受信データプール領域（シリアルポートからのデータが分断されるため）
        public byte[] PooledBufferData = new byte[0];

        // 受信検査結果ディクショナリ（配列なのは聴力のように３人分の結果を一気に受信するような場合があるため）        
        public Dictionary<string, string>[] ResultDataSets;

        // 応答用送信電文
        public byte[] ResponceData;

        // 呼び出し元ロギングテキストボックス
        public TextBox logTextBox;

        // 呼び出し元フォームのロギングテキストボックス更新用デリゲート
        public delegate void Delegate_UpdateTextBox(string data);
        public Delegate_UpdateTextBox UpdateTextBox = null;

        // コレクションに分割された起動時パラメタ
        public NameValueCollection paramCollection = null;

        /// <summary>
        /// ログを出力する
        /// </summary>
        /// <param name="logLevel">ログレベル</param>
        /// <param name="message">出力メッセージ</param>
        public void Log(String logLevel, String message)
        {

            // メッセージを画面ログに出力
            logTextBox.Invoke(UpdateTextBox, "【" + logLevel.ToUpper() + "】 " + message);

            //引数のログレベルに応じてメソッドを使い分け、メッセージを出力する
            switch (logLevel) {
                case "Trace":
                    logger.Trace(message);
                    break;
                case "Debug":
                    logger.Debug(message);
                    break;
                case "Info":
                    logger.Info(message);
                    break;
                case "Warn":
                    logger.Warn(message);
                    break;
                case "Error":
                    logger.Error(message);
                    break;
                case "Fatal":
                    logger.Fatal(message);
                    break;
            }

        }

        /// <summary>
        /// デバッグモード時のログ出力
        /// </summary>
        /// <param name="Message">出力メッセージ</param>
        public void DebugLog(String Message)
        {
            // Debugモードで起動されている場合のみ、ログを出力する（必ずDebug固定）
            if (DebugMode)
            {
                Log("Debug", Message);
            }

        }

        /// <summary>
        /// 出力先ログファイル名の取得
        /// </summary>
        /// <returns>出力先ログファイル（フルパス）</returns>
        public string GetLogFileName()
        {
            // 戻り値初期化
            string fileName = null;

            // NLogのConfigを取得
            var config = LogManager.Configuration;

            // Config内からファイルフルパスを取得して返す
            foreach (var item in config.ConfiguredNamedTargets)
            {
                if (item is NLog.Targets.FileTarget)
                {
                    var standardTarget = item as NLog.Targets.FileTarget;
                    fileName = NLog.Layouts.SimpleLayout.Evaluate((standardTarget.FileName as NLog.Layouts.SimpleLayout).Text);
                    break;
                }
            }

            return fileName;

        }

    }
}
