using System;
using System.Threading.Tasks;
using Hainsi.Common;

namespace Hainsi.Common
{
    public static class TaskExtensions
    {
        /// <summary>
        /// タスクを非同期に実行し終了を待たない
        /// </summary>
        /// <param name="task">タスク</param>
        public static void FireAndForget(this Task task)
        {
            task.ContinueWith(x =>
            {
				// メッセージ作成
				//string message = ParamLogUtility.CreateLogMessage(x.Exception);

				//Logging.Fatal(message, x.Exception);
				throw x.Exception;

			}, TaskContinuationOptions.OnlyOnFaulted);
		}
    }
}