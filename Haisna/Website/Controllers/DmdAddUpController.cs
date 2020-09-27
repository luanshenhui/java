using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// コースコントローラ（暫定）
    /// </summary>
    [Route("api/[controller]")]
    public class DmdAddUpController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly DmdAddUpDao dmdAddUpDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="dmdAddUpDao">データアクセスオブジェクト</param>
        public DmdAddUpController(DmdAddUpDao dmdAddUpDao)
        {
            this.dmdAddUpDao = dmdAddUpDao;
        }

        /// <summary>
        /// 請求締め処理入力値の妥当性チェックを行う
        /// </summary>
        /// <param name="closeYear">締め日(年)</param>
        /// <param name="closeMonth">締め日(月)</param>
        /// <param name="closeDay">締め日(日)</param>
        /// <param name="strYear">開始受診日(年)</param>
        /// <param name="strMonth">開始受診日(月)</param>
        /// <param name="strDay">開始受診日(日)</param>
        /// <param name="endYear">終了受診日(年)</param>
        /// <param name="endMonth">終了受診日(月)</param>
        /// <param name="endDay">終了受診日(日)  </param>
        /// <returns></returns>
        [HttpGet, Route("api/[controller]/checkvaluedmdaddup")]
        public IActionResult CheckValueDmdAddUp(int closeYear, int closeMonth, int closeDay, int strYear, int strMonth, int strDay, int endYear, int endMonth, int endDay)
        {
            List<string> messages = dmdAddUpDao.CheckValueDmdAddUp(closeYear, closeMonth, closeDay, strYear, strMonth, strDay, endYear, endMonth, endDay,
                out DateTime? closeDate, out DateTime? strDate, out DateTime? endDate);

            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            var ds = new Dictionary<string, DateTime?>
                        {
                            { "closedate",  closeDate},
                            { "strdate", strDate },
                            { "enddate", endDate }
                        };

            return Ok(ds);
        }
    }
}
