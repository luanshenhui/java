using Hainsi.Entity;
using Hainsi.Entity.Model;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 判定分類アクセス用WebAPIコントローラークラス
    /// </summary>
    //[Authorize]
    [Route("api/v1/judclasses")]
    public class JudClassController : Controller
    {
        /// <summary>
        /// 判定分類データアクセスオブジェクト
        /// </summary>
        readonly JudClassDao judClassDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="judClassDao">判定分類データアクセスオブジェクト</param>
        public JudClassController(JudClassDao judClassDao)
        {
            this.judClassDao = judClassDao;
        }

        /// <summary>
        /// 判定分類の一覧を取得する
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetJudClassList()
        {
            List<dynamic> list = judClassDao.SelectJudClassList();

            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定判定分類コードの判定分類情報を取得します。
        /// </summary>
        /// <param name="judClassCd">判定分類コード</param>
        [HttpGet("{judClassCd}")]
        [ProducesResponseType(typeof(JudClass), 200)]
        [ProducesResponseType(404)]
        public IActionResult GetJudClass(int judClassCd)
        {
            dynamic data = judClassDao.SelectJudClass(judClassCd);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }
    }
}
