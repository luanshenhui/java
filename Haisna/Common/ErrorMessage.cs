using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Common.ApiResponse
{
    public static class ErrorMessage
    {
        /// <summary>
        /// APIレスポンス時のエラーメッセージを整形する
        /// </summary>
        /// <param name="messages">エラーメッセージ</param>
        /// <returns>整形したエラーメッセージ</returns>
        public static string ToErrorMessage(this IList<string> messages)
        {
            return JsonConvert.SerializeObject(new
            {
                errors = messages
            });
        }

        /// <summary>
        /// APIレスポンス時のエラーメッセージを作成する
        /// </summary>
        /// <param name="message">エラーメッセージ</param>
        /// <returns>整形したエラーメッセージ</returns>
        public static string ToErrorMessage(this string message)
        {
            return new List<string> { message }.ToErrorMessage();
        }
    }
}
