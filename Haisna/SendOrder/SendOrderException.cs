using System;

namespace Hainsi.SendOrder
{
    /// <summary>
    /// オーダ送信処理例外クラス
    /// </summary>
    public class SendOrderException : Exception
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        public SendOrderException() : base() { }

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="message">エラーメッセージ</param>
        public SendOrderException(string message) : base(message) { }

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="message">エラーメッセージ</param>
        /// <param name="innerException">詳細例外クラス</param>
        public SendOrderException(string message, Exception innerException) : base(message, innerException) { }
    }
}
