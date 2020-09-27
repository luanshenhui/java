using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Hainsi.Entity;
using Microsoft.AspNetCore.Mvc;


namespace Hainsi.Controllers
{
    /// <summary>
    /// OrgGrpコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/organizationgroup")]
    public class OrgGrpController : Controller
    {
        /// <summary>
        /// OrgGrpアクセスオブジェクト
        /// </summary>
        readonly OrgGrpDao orgGrpDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="orgGrpDao">OrgGrpDaoアクセスオブジェクト</param>
        public OrgGrpController(OrgGrpDao orgGrpDao)
        {
            this.orgGrpDao = orgGrpDao;
        }

        /// <summary>
        /// 団体グループの一覧を団体グループコードの昇順で取得する
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("p")]
        public IActionResult GetOrgGrp_PList()
        {
            List<dynamic> ds = orgGrpDao.SelectOrgGrp_PList();

            // データ件数が0件の場合
            if (ds == null || ds.Count <= 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }

    }
}