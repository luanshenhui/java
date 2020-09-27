using Hainsi.Entity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// セット分類コントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/setclass")]
    public class SetClassController : Controller
    {
        /// <summary>
        /// セット分類テーブルデータアクセスオブジェクト
        /// </summary>
        readonly SetClassDao setClassDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="setClassDao">セット分類テーブルデータアクセスオブジェクト</param>
        public SetClassController(SetClassDao setClassDao)
        {
            this.setClassDao = setClassDao;
        }

        /// <summary>
        /// 一覧を取得する
        /// </summary>
        /// <returns>一覧</returns>
        [HttpGet]
        public IActionResult Get()
        {
            IList<dynamic> data = setClassDao.SelectSetClassList();

            // データ件数が0件の場合
            if (data.Count == 0)
            {
                return NotFound();
            }

            return Ok(data);
        }
    }
}
