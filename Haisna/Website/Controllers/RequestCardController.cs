using Hainsi.Entity;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// PerBillコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/card")]
    public class RequestCardController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly RequestCardDao requestCardDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="requestCardDao">データアクセスオブジェクト</param>
        public RequestCardController(RequestCardDao requestCardDao)
        {
            this.requestCardDao = requestCardDao;
        }

        /// <summary>
        /// 依頼状履歴情報を取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="prtDiv">様式分類</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/history")]
        public IActionResult FolReqHistory(int rsvNo, int prtDiv, string judClassCd)
        {
            List<dynamic> data = requestCardDao.folReqHistory(rsvNo, prtDiv, judClassCd);

            return Ok(data);
        }

    }
}
