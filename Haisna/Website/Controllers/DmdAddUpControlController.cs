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
    /// DmdAddUpControlコントローラ（暫定）
    /// </summary>
    [Route("api/[controller]")]
    public class DmdAddUpControlController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly DmdAddUpControlDao dmdAddUpControlDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="dmdAddUpControlDao">データアクセスオブジェクト</param>
        public DmdAddUpControlController(DmdAddUpControlDao dmdAddUpControlDao)
        {
            this.dmdAddUpControlDao = dmdAddUpControlDao;
        }

        /// <summary>
        /// 請求締め処理を起動する
        /// </summary>
        /// <param name="closeDate">締め日</param>
        /// <param name="strDate">開始受診日</param>
        /// <param name="endDate">終了受診日</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="courseCd">コースコード</param>
        /// <returns></returns>
        [HttpGet, Route("api/[controller]/executedmdaddup")]
        public IActionResult ExecuteDmdAddUp(DateTime closeDate, DateTime strDate, DateTime endDate, string orgCd1, string orgCd2, string courseCd)
        {
            int ret = dmdAddUpControlDao.ExecuteDmdAddUp(closeDate, strDate, endDate, orgCd1, orgCd2, courseCd);

            return Ok(ret);
        }
    }
}
