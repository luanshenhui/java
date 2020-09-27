using NLog;
using System;

namespace Fujitsu.Hainsi.WindowServices.Common
{
    /// <summary>
    /// ログ出力クラス
    /// </summary>
    public sealed class Logging
    {
        private static Logger _logger = LogManager.GetCurrentClassLogger();
        private static string _destSystemName = "";

        private const string HainsSvr = "HAINSSVR";

        /// <summary>
        /// 相手側システム
        /// </summary>
        public enum DestSystemConstants
        {
            Smile = 0,                  // SMILE
            Hope = 1,                   // HOPE
            Lains = 2,                  // LAINS
            Byori = 3,                  // 病理
        }

        /// <summary>
        /// ログ内容
        /// </summary>
        public enum LogTypeConstants
        {
            Connect = 0,                // 接続
            ConnectionRequest = 1,      // 接続要求受信
            DataArrival = 2,            // 電文受信
            DataSend = 3,               // 電文送信
            Close = 4,                  // 接続終了
            RetrunResponse = 5,         // 応答種別送信
            ResponseReceived = 6,       // 応答種別受信
            Error = 7,                  // エラーメッセージ
            ServerStart = 8,            // 電文受信プログラム起動
            ServerEnd = 9,              // 電文受信プログラム終了
            ClientStart = 10,           // 電文送信プログラム起動
            ClientEnd = 11,             // 電文送信プログラム終了
            DataFormated = 12,          // 電文解析終了
            DataError = 13,             // 電文エラー
            SocketError = 14,           // ソケットエラー
            DataSendComplete = 15,      // データ送信完了
            ExecuteCanceled = 16,       // 通信処理キャンセル
            FreeOutput = 17             // 自由項目(好みのログを出力する)
        }

        /// <summary>
        /// ロギングクラス初期化
        /// </summary>
        /// <param name="destSystemType">相手側システム</param>
        public static void Initialize(DestSystemConstants destSystemType)
        {
             switch (destSystemType)
            {
                case DestSystemConstants.Smile:
                    _destSystemName = "SMILE";
                    break;
                case DestSystemConstants.Hope:
                    _destSystemName = "HOPE";
                    break;
                case DestSystemConstants.Lains:
                    _destSystemName = "LAINS";
                    break;
                case DestSystemConstants.Byori:
                    _destSystemName = "病理";
                    break;
            }
        }

        /// <summary>
        /// ログ出力
        /// </summary>
        /// <param name="logType">ログ内容</param>
        public static void Output(LogTypeConstants logType)
        {
            Output(logType, "", "", "", null);
        }

        /// <summary>
        /// ログ出力
        /// </summary>
        /// <param name="logType">ログ内容</param>
        /// <param name="outputContents">詳細内容</param>
        public static void Output(LogTypeConstants logType, string outputContents)
        {
            Output(logType, "", "", outputContents, null);
        }

        /// <summary>
        /// ログ出力
        /// </summary>
        /// <param name="logType">ログ内容</param>
        /// <param name="moduleName">モジュール名</param>
        /// <param name="procedureName">プロシージャ名</param>
        /// <param name="outputContents">詳細内容</param>
        public static void Output(
            LogTypeConstants logType, string moduleName, string procedureName,
            string outputContents)
        {
            Output(logType, moduleName, procedureName, outputContents, null);
        }

        /// <summary>
        /// ログ出力
        /// </summary>
        /// <param name="logType">ログ内容</param>
        /// <param name="moduleName">モジュール名</param>
        /// <param name="procedureName">プロシージャ名</param>
        /// <param name="outputContents">詳細内容</param>
        /// <param name="ex">例外情報</param>
        public static void Output(
            LogTypeConstants logType, string moduleName, string procedureName,
            string outputContents, Exception ex)
        {
            if (logType == LogTypeConstants.Error ||
                logType == LogTypeConstants.SocketError)
            {
                // 異常系ログの場合
                string log = "";

                if (!moduleName.Equals("") && !procedureName.Equals(""))
                {
                    log = "エラー M:" + moduleName +
                        " -> " + " P:" + procedureName +
                        " -> " + outputContents;
                }
                else
                {
                    log = outputContents;
                }

                if (ex != null)
                {
                    OutputExceptionMessage(ex, ref log);
                }

                // エラー内容をログに出力する
                Error(log);
            }
            else
            {
                // 正常系ログの場合
                string log = "";

                switch (logType)
                {
                    case LogTypeConstants.Connect:              // 接続
                        log = "接続 [" + HainsSvr + "] <========> [" + _destSystemName + "]";
                        break;
                    case LogTypeConstants.ConnectionRequest:    // 接続要求受信
                        log = "接続要求受信 -> 接続 [" + HainsSvr + "] <========= [" + _destSystemName + "]";
                        break;
                    case LogTypeConstants.DataArrival:          // 電文受信
                        log = "電文受信 [" + HainsSvr + "] <--------- [" + _destSystemName + "]";
                        if (!outputContents.Equals(""))
                        {
                            log += " " + outputContents;
                        }
                        break;
                    case LogTypeConstants.DataSend:             // 電文送信
                        log = "電文送信 [" + HainsSvr + "] ---------> [" + _destSystemName + "]";
                        if (!outputContents.Equals(""))
                        {
                            log += " " + outputContents;
                        }
                        break;
                    case LogTypeConstants.Close:                // 接続終了
                        log = "接続終了 [" + HainsSvr + "] ====><==== [" + _destSystemName + "]";
                        break;
                    case LogTypeConstants.RetrunResponse:       // 応答種別送信
                        log = "応答電文送信 [" + HainsSvr + "] ---------> [" + _destSystemName + "] " + 
                            "応答種別：" + outputContents;
                        break;
                    case LogTypeConstants.ResponseReceived:     // 応答種別受信
                        log = "応答電文受信 [" + HainsSvr + "] <--------- [" + _destSystemName + "] " + 
                            "応答種別：" + outputContents;
                        break;
                    case LogTypeConstants.ServerStart:          // 電文受信プログラム起動
                        log = "電文受信プログラムを起動します ID：" +
                            System.IO.Path.GetFileName(System.Reflection.Assembly.GetEntryAssembly().Location);
                        break;
                    case LogTypeConstants.ServerEnd:            // 電文受信プログラム終了
                        log = "電文受信プログラムを終了します ID：" +
                            System.IO.Path.GetFileName(System.Reflection.Assembly.GetEntryAssembly().Location);
                        break;
                    case LogTypeConstants.ClientStart:          // 電文送信プログラム起動
                        log = "電文送信プログラムを起動します ID：" +
                            System.IO.Path.GetFileName(System.Reflection.Assembly.GetEntryAssembly().Location);
                        break;
                    case LogTypeConstants.ClientEnd:            // 電文送信プログラム終了
                        log = "電文送信プログラムを終了します ID：" +
                            System.IO.Path.GetFileName(System.Reflection.Assembly.GetEntryAssembly().Location);
                        break;
                    case LogTypeConstants.DataFormated:         // 電文解析終了
                        log = "電文解析終了 -> 基本部：" + outputContents;
                        break;
                    case LogTypeConstants.DataError:            // 電文エラー終了
                        log = "電文エラー ：" + outputContents;
                        break;
                    case LogTypeConstants.DataSendComplete:     // 電文送信完了
                        log = "電文送信完了 ：" + outputContents;
                        break;
                    case LogTypeConstants.ExecuteCanceled:      // 通信処理キャンセル
                        log = "通信処理キャンセル ：ユーザーにより電文送受信処理がキャンセルされました";
                        break;
                    case LogTypeConstants.FreeOutput:           // 自由項目
                        log = "通知 M:" + moduleName + " -> " + " P:" + procedureName + " -> " + outputContents;
                        break;
                }

                if (ex != null)
                {
                    OutputExceptionMessage(ex, ref log);
                }

                // 処理状況をログに出力する
                Info(log);
            }
        }

        /// <summary>
        /// 情報ログ
        /// </summary>
        /// <param name="message">メッセージ</param>
        private static void Info(object message)
        {
            _logger.Info(message);
        }

        /// <summary>
        /// エラーログ
        /// </summary>
        /// <param name="message">メッセージ</param>
        private static void Error(string message)
        {
            _logger.Error(message);
        }

        /// <summary>
        /// Exceptionエラーメッセージ出力処理
        /// </summary>
        /// <param name="ex">例外</param>
        /// <param name="message">エラーメッセージ</param>
        private static void OutputExceptionMessage(Exception ex, ref string message)
        {
            if (ex == null)
            {
                return;
            }

            if (ex is AggregateException)
            {
                foreach (Exception childEx in ((AggregateException)ex).InnerExceptions)
                {
                    OutputExceptionMessage(childEx, ref message);
                }
            }
            else if (ex.InnerException != null)
            {
                OutputExceptionMessage(ex.InnerException, ref message);
            }
            else
            {
                message += "\n" + ex.Message;
                message += (ex.StackTrace == null) ? "" : "\n" + ex.StackTrace;
            }
        }
    }
}
