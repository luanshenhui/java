using Hainsi.Entity;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// Senderコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/sendmail")]
    public class SenderController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly SenderDao senderDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="senderDao">データアクセスオブジェクト</param>
        public SenderController(SenderDao senderDao)
        {
            this.senderDao = senderDao;
        }

        /// <summary>
        /// 予約確認メールの送信
        /// </summary>
        /// <param name="templateCd">テンプレートコード</param>
        /// <param name="data">
        /// rsvno   予約番号
        /// </param>
        /// <response code="204">成功</response>
        /// <response code="404">データなし</response>
        [HttpPost]
        public IActionResult Send(string templateCd, [FromBody] JToken data)
        {
            // ユーザID
            string userId = HttpContext.Session.GetString("userid");

            // 予約番号
            List<string> arrRsvNo = data["rsvno"].ToObject<List<string>>();

            long ret = senderDao.Send(userId, templateCd, arrRsvNo);

            if (ret == 0)
            {
                return NotFound();
            }

            return NoContent();
        }
    }
}
