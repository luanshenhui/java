using Hainsi.Common.Constants;
using Hainsi.Entity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 2次検査請求明細アクセス用WebAPIコントローラークラス
    /// </summary>
    [Route("api/v1/billingitems")]
    public class SecondLineDivController : Controller
    {
        /// <summary>
        /// 2次検査請求明細データアクセスオブジェクト
        /// </summary>
        readonly SecondBillDao secondBillDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="secondBillDao">2次検査請求明細データアクセスオブジェクト</param>
        public SecondLineDivController(SecondBillDao secondBillDao)
        {
            this.secondBillDao = secondBillDao;
        }

        /// <summary>
        /// 一覧を取得します。
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult SelectSecondLineDiv(int page = 0, int limit = 0)
        {
            IList<dynamic> data = secondBillDao.SelectSecondLineDiv();
            if (data.Count == 0)
            {
                return NotFound(data);
            }

            if ((page <= 0) || (limit <= 0))
            {
                return Ok(data);
            }

            // TODO 暫定処理。本来はDao内部で範囲指定を行うべき。
            return Ok(new PartialDataSet(data.Count, data.Skip((page - 1) * limit).Take(limit).ToList()));
        }

        /// <summary>
        /// 指定コードのレコード取得
        /// </summary>
        /// <param name="secondLineDivCd">２次請求明細コード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{secondLineDivCd}")]
        public IActionResult Get(string secondLineDivCd)
        {
            dynamic data = secondBillDao.SelectSecondLineDivFromCode(secondLineDivCd);
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }
    }
}
