using System;
using log4net;

namespace Hainsi.Common
{
	/// <summary>
	/// ロギングクラス
	/// （log4netを包含）
	/// </summary>
	static public class Logging
	{
		private static ILog Log { get; } = LogManager.GetLogger(typeof(Logging));

		/// <summary>
		/// デバッグログ
		/// </summary>
		/// <param name="message">メッセージ</param>
		public static void Debug(object message)
		{
			Log.Debug(message);
		}

		/// <summary>
		/// デバッグログ
		/// </summary>
		/// <param name="message">メッセージ</param>
		/// <param name="exception">例外</param>
		public static void Debug(object message, Exception exception)
		{
			Log.Debug(message, exception);
		}

		/// <summary>
		/// サーバ情報
		/// </summary>
		/// <param name="message">メッセージ</param>
		public static void Info(object message)
		{
			Log.Info(message);
		}

		/// <summary>
		/// サーバ情報
		/// </summary>
		/// <param name="message">メッセージ</param>
		/// <param name="exception">例外</param>
		public static void Info(object message, Exception exception)
		{
			Log.Info(message, exception);
		}

		/// <summary>
		/// 警告
		/// </summary>
		/// <param name="message">メッセージ</param>
		public static void Warn(object message)
		{
			Log.Warn(message);
		}

		/// <summary>
		/// 警告
		/// </summary>
		/// <param name="message">メッセージ</param>
		/// <param name="exception">例外</param>
		public static void Warn(object message, Exception exception)
		{
			Log.Warn(message, exception);
		}

		/// <summary>
		/// エラー
		/// </summary>
		/// <param name="message">メッセージ</param>
		public static void Error(object message)
		{
			Log.Error(message);
		}

		/// <summary>
		/// エラー
		/// </summary>
		/// <param name="message">メッセージ</param>
		/// <param name="exception">例外</param>
		public static void Error(object message, Exception exception)
		{
			Log.Error(message, exception);
		}

		/// <summary>
		/// 致命的エラー
		/// </summary>
		/// <param name="message">メッセージ</param>
		public static void Fatal(object message)
		{
			Log.Fatal(message);
		}

		/// <summary>
		/// 致命的エラー
		/// </summary>
		/// <param name="message">メッセージ</param>
		/// <param name="exception">例外</param>
		public static void Fatal(object message, Exception exception)
		{
			Log.Fatal(message, exception);
		}
	}
}
