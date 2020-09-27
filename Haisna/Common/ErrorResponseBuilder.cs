using System.Collections.Generic;


namespace Hainsi.Common
{
    public class ErrorResponseBuilder
    {
        /// <summary>
        /// エラー情報を作成する
        /// </summary>
        /// <param name="message">エラーメッセージ</param>
        /// <param name="code">エラーコード</param>
        /// <returns>エラー情報</returns>
        public static Dictionary<string, List<Dictionary<string, string>>> Build(string message, string code = null)
        {
            return new ErrorResponseBuilder(message, code).Build();
        }

        /// <summary>
        /// エラー情報を作成する
        /// </summary>
        /// <param name="messages">エラーメッセージリスト</param>
        /// <returns>エラー情報</returns>
        public static Dictionary<string, List<Dictionary<string, string>>> Build(List<string> messages)
        {
            var builder = new  ErrorResponseBuilder();

            foreach (var message in messages)
            {
                builder.Add(message);
            }

            return builder.Build();
        }

        /// <summary>
        /// エラー情報
        /// </summary>
        private List<Dictionary<string, string>> Errors { get; set; }

        /// <summary>
        /// コンストラクタ
        /// </summary>
        public ErrorResponseBuilder()
        {
            Errors = new List<Dictionary<string, string>>();
        }

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="message">エラーメッセージ</param>
        /// <param name="code">エラーコード</param>
        public ErrorResponseBuilder(string message, string code = null)
        {
            Errors = new List<Dictionary<string, string>>();
            Add(message, code);
        }

        /// <summary>
        /// エラー情報を追加する
        /// </summary>
        /// <param name="message">エラーメッセージ</param>
        /// <param name="code">エラーコード</param>
        /// <returns></returns>
        public ErrorResponseBuilder Add(string message, string code = null)
        {
            Errors.Add(new Dictionary<string, string> { { "code", code }, { "message", message } });
            return this;
        }

        /// <summary>
        /// エラー情報をビルドする
        /// </summary>
        /// <returns>エラー情報</returns>
        public Dictionary<string,List<Dictionary<string,string>>> Build()
        {
            return new Dictionary<string, List<Dictionary<string, string>>> { { "errors", Errors } };
        }
    }
}
