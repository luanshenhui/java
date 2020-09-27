using Hainsi.Entity;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// FailSafeコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/failsafe")]
    public class FailSafeController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly FailSafeDao failSafeDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="failSafeDao">データアクセスオブジェクト</param>
        public FailSafeController(FailSafeDao failSafeDao)
        {
            this.failSafeDao = failSafeDao;
        }

        /// <summary>
        /// 受診情報の読み込み
        /// </summary>
        /// <param name="strCslDate">開始受診日</param>
        /// <param name="endCslDate">終了受診日</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/failsafe")]
        public IActionResult GetConsult(DateTime strCslDate, DateTime? endCslDate = null)
        {
            List<dynamic> list = failSafeDao.SelectConsult(strCslDate, endCslDate);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }
    }
}
