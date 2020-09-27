using Hainsi.Entity;
using Hainsi.Entity.Model.OrderReport;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// レポート情報コントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/orderreports")]
    public class OrderReportController : Controller
    {
        /// <summary>
        /// レポート情報データアクセスオブジェクト
        /// </summary>
        readonly OrderReportDao orderReport;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="orderReport">レポート情報データアクセスオブジェクト</param>
        public OrderReportController(OrderReportDao orderReport)
        {
            this.orderReport = orderReport;
        }

        /// <summary>
        /// レポート情報を登録する
        /// </summary>
        /// <param name="data">レポート情報モデル</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult Register([FromBody] OrderReport data)
        {
            // レポート情報を登録する
            int ret = orderReport.Register(data);

            if (ret == 0)
            {
                return BadRequest(new List<string>()
                    { "指定された予約番号、オーダ番号のレコードが存在しないため、レポート情報の登録処理に失敗しました。" });
            }

            // 正常時は204(No Content)を返す
            return NoContent();
        }
    }
}
