using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Hainsi.Common.ApiResponse;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// エラーレスポンス情報作成用ヘルパークラス
    /// </summary>
    public static class ErrorResponse
    {
        /// <summary>
        /// 重複登録時のエラーレスポンスを作成する
        /// </summary>
        /// <param name="controller">このメソッドを呼び出しているControllerクラス</param>
        /// <param name="message">エラーメッセージ</param>
        /// <returns>エラーレスポンス</returns>
        public static ObjectResult Conflict(this Controller controller, string message)
        {
            return controller.StatusCode(StatusCodes.Status409Conflict, message.ToErrorMessage());
        }

        /// <summary>
        /// バリデーションエラー時のエラーレスポンスを作成する
        /// </summary>
        /// <param name="controller">このメソッドを呼び出しているControllerクラス</param>
        /// <param name="messages">エラーメッセージ</param>
        /// <returns>エラーレスポンス</returns>
        public static ObjectResult UnprocessableEntity(this Controller controller, IList<string> messages)
        {
            return controller.StatusCode(StatusCodes.Status422UnprocessableEntity, messages.ToErrorMessage());
        }
    }
}
