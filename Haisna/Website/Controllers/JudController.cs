using Hainsi.Entity;
using Hainsi.Entity.Model.Jud;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// Judコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/judcodes")]
    public class JudController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly JudDao judDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="judDao">データアクセスオブジェクト</param>
        public JudController(JudDao judDao)
        {
            this.judDao = judDao;
        }

        /// <summary>
        /// 判定の一覧を取得する
        /// </summary>
        [HttpGet]
        [ProducesResponseType(typeof(List<Jud>), 200)]
        [ProducesResponseType(404)]
        public IActionResult GetJudList()
        {
            List<dynamic> list = judDao.SelectJudList();

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }
    }
}
