using Hainsi.Common;
using System.Web.Http.ExceptionHandling;

namespace Website
{
    /// <summary>
    /// 例外が発生した場合にログを出力する
    /// </summary>
    public class TraceExceptionLogger : ExceptionLogger
    {
        public override void Log(ExceptionLoggerContext context)
        {
			// メッセージ作成
			string message = ParamLogUtility.CreateLogMessage(context.ExceptionContext.Exception);
			
            Logging.Fatal(message, context.ExceptionContext.Exception);
        }
    }
}