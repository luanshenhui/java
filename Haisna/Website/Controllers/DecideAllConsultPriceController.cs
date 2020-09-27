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
    public class DecideAllConsultPriceController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly DecideAllConsultPriceDao decideAllConsultPriceDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="decideAllConsultPriceDao">データアクセスオブジェクト</param>
        public DecideAllConsultPriceController(DecideAllConsultPriceDao decideAllConsultPriceDao)
        {
            this.decideAllConsultPriceDao = decideAllConsultPriceDao;
        }

        /// <summary>
        /// 指定予約番号の負担金額情報を取得する
        /// </summary>
        /// <param name="strDate">対象受診日開始日</param>
        /// <param name="endDate">対象受診日終了日</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="forceUpdate"> 1:受診金額を強制的に再作成</param>
        /// <param name="putLog"> 0:開始終了のみ、1:エラーのみ、2:全て</param>
        /// <returns></returns>
        [HttpGet, Route("api/[controller]/decideallconsultprice")]
        public IActionResult DecideAllConsultPrice(DateTime strDate, DateTime endDate, string orgCd1, string orgCd2, int forceUpdate = 0, int putLog = 0)
        {
            int ret = decideAllConsultPriceDao.DecideAllConsultPrice(strDate, endDate, orgCd1, orgCd2, forceUpdate, putLog);

            return Ok(ret);
        }
    }
}
