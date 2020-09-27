using Hainsi.Entity;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// SecondBillコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/secondbills")]
    public class SecondBillController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly SecondBillDao secondBillDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="secondBillDao">データアクセスオブジェクト</param>
        public SecondBillController(SecondBillDao secondBillDao)
        {
            this.secondBillDao = secondBillDao;
        }

        /// <summary>
        /// ２次請求明細を取得する。
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetSecondLineDiv()
        {
            List<dynamic> list = secondBillDao.SelectSecondLineDiv();

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }
    }
}
