using NLog;
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;

namespace Hainsi.SendOrder
{
    /// <summary>
    /// ログ出力クラス
    /// </summary>
    public sealed class Logging
    {
        /// <summary>
        /// ログ出力タイプ
        /// </summary>
        public enum LoggingTypeConstants
        {
            /// <summary>
            /// 検体ラベル印刷オーダ送信
            /// </summary>
            PrintLabel = 0,

            /// <summary>
            /// 状態変更オーダ送信
            /// </summary>
            ChangeStatus = 1,

            /// <summary>
            /// 病理ラベル印刷
            /// </summary>
            ByoriLabel = 2,
        }

        /// <summary>
        /// ログ出力クラスのインスタンス
        /// </summary>
        private static Lazy<Logging> _lazy =
            new Lazy<Logging>(() => { return new Logging(); }, true);

        /// <summary>
        /// ログ出力オブジェクト
        /// </summary>
        private static LogFactory _logFactory = null;

        /// <summary>
        /// ログ出力コレクション
        /// </summary>
        private static Dictionary<LoggingTypeConstants, Logger> _logger = 
            new Dictionary<LoggingTypeConstants, Logger>();

        /// <summary>
        /// ログ出力クラスアクセス用プロパティ
        /// </summary>
        public static Logging Instance
        {
            get { return _lazy.Value; }
        }
        
        /// <summary>
        /// コンストラクタ
        /// </summary>
        private Logging()
        {
            // 設定ファイルのパスを編集する
            string configFileName = Path.Combine(
                Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location),
                "SendOrderNLog.config");

            // 設定ファイルが存在しない場合は処理を終了する
            if (!File.Exists(configFileName))
            {
                return;
            }

            // 設定ファイルを取得する
            try
            {
                _logFactory = LogManager.LoadConfiguration(configFileName);

                // 検体ラベル印刷オーダ送信
                _logger.Add(
                    LoggingTypeConstants.PrintLabel,
                    _logFactory.GetLogger("PrintLabel"));

                // 状態変更オーダ送信
                _logger.Add(
                    LoggingTypeConstants.ChangeStatus,
                    _logFactory.GetLogger("ChangeStatus"));

                // 病理ラベル印刷
                _logger.Add(
                    LoggingTypeConstants.ByoriLabel,
                    _logFactory.GetLogger("ByoriLabel"));
            }
            catch { }
        }

        /// <summary>
        /// 情報ログ出力
        /// </summary>
        /// <param name="loggingType">ログ出力タイプ</param>
        /// <param name="message">ログ出力内容</param>
        public void Info(LoggingTypeConstants loggingType, string message)
        {
            if (!_logger.ContainsKey(loggingType) ||
                string.IsNullOrEmpty(message))
            {
                return;
            }

            _logger[loggingType].Info(message);
        }

        /// <summary>
        /// エラーログ出力
        /// </summary>
        /// <param name="loggingType">ログ出力タイプ</param>
        /// <param name="message">ログ出力内容</param>
        public void Error(LoggingTypeConstants loggingType, string message)
        {
            if (!_logger.ContainsKey(loggingType) ||
                string.IsNullOrEmpty(message))
            {
                return;
            }

            _logger[loggingType].Error(message);
        }

        /// <summary>
        /// エラーログ出力
        /// </summary>
        /// <param name="loggingType">ログ出力タイプ</param>
        /// <param name="message">ログ出力内容</param>
        /// <param name="ex">例外情報</param>
        public void Error(LoggingTypeConstants loggingType, string message, Exception ex)
        {
            if (!_logger.ContainsKey(loggingType) ||
                string.IsNullOrEmpty(message))
            {
                return;
            }

            string log = message;
            OutputExceptionMessage(ex, ref log);

            _logger[loggingType].Error(log);
        }

        /// <summary>
        /// Exceptionエラーメッセージ出力処理
        /// </summary>
        /// <param name="ex">例外情報</param>
        /// <param name="message">エラーメッセージ</param>
        private void OutputExceptionMessage(Exception ex, ref string message)
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
