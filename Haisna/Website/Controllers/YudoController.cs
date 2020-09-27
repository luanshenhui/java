using Hainsi.Entity;
using Hainsi.Entity.Model.Yudo;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Website.Controllers
{
    /// <summary>
    /// 誘導データコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/yudo")]
    public class YudoController : Controller
    {
        readonly YudoDao yudoDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="yudoDao">誘導データアクセスオブジェクト</param>
        public YudoController(YudoDao yudoDao)
        {
            this.yudoDao = yudoDao;
        }

        /// <summary>
        /// 診察状態を取得する
        /// </summary>
        [HttpGet("consultation/monitor/status")]
        [ProducesResponseType(typeof(List<GetConsultationMonitorStatusModel>), 200)]
        [ProducesResponseType(404)]
        public IActionResult GetConsultationMonitorStatus()
        {
            List<dynamic> list = yudoDao.SelectConsultationMonitorStatus();

            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }
    }
}
