using Hainsi.Common;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Web.SessionState;

namespace Hainsi.Controllers
{
    /// <summary>
    /// Hainsi用共通コントローラ
    /// </summary>
    public abstract class BaseApiController : ApiController
    {
		/// <summary>
		/// セッション変数
		/// </summary>
		protected IHttpSessionState Session { get; } = SessionStateUtility.GetHttpSessionStateFromContext(HttpContext.Current);


		/// <summary>
		/// クエリパラメータ実態
		/// </summary>
		private UrlQueryReader urlQuery = null;

		/// <summary>
		/// クエリパラメータ
		/// </summary>
		protected UrlQueryReader UrlQuery { get{ return GetUrlQuery(); } }

		/// <summary>
		/// クエリパラメータをNameValueCollectionに変換する
		/// </summary>
		/// <returns>NameValueCollectionのクエリパラメータ</returns>
		private UrlQueryReader GetUrlQuery()
		{
			// クエリパラメータがセットされていなければ新規にセット
			if (urlQuery == null)
			{
				urlQuery = new UrlQueryReader(Request.GetQueryNameValuePairs());
			}

			return urlQuery;
		}

		/// <summary>
		/// バリデーションメッセージをHTTPレスポンスに変換する
		/// バリデーションメッセージがなければNullを返す
		/// </summary>
		/// <param name="messages">バリデーションメッセージ</param>
		/// <returns>HTTPレスポンス</returns>
		protected IHttpActionResult CreateBadRequest(List<string> messages)
		{
			// バリデーションメッセージがなければNULLを返す
			if (messages == null || messages.Count <= 0)
			{
				return null;
			}

			// バリデーションメッセージをHTTPレスポンスに変換する
			HttpResponseMessage message = Request.CreateResponse(HttpStatusCode.BadRequest, ErrorResponseBuilder.Build(messages));
			return ResponseMessage(message);
		}
	}
}
