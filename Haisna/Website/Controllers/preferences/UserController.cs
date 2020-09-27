using Hainsi.Entity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// ユーザアクセス用WebAPIコントローラークラス
    /// </summary>
    //[Authorize]
    [Route("api/[controller]")]
    public class UserController : Controller
    {
        /// <summary>
        /// ユーザデータアクセスオブジェクト
        /// </summary>
        readonly HainsUserDao hainsUserDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="hainsUserDao">ユーザデータアクセスオブジェクト</param>
        public UserController(HainsUserDao hainsUserDao)
        {
            this.hainsUserDao = hainsUserDao;
        }

        /// <summary>
        /// 一覧を取得する
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult Get()
        {
            IList<dynamic> ds = hainsUserDao.SelectUserList();

            // データ件数が0件の場合
            if (ds.Count == 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// 指定したユーザ情報を取得します。
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{userid}")]
        public IActionResult Get(string userid)
        {
            dynamic rec = hainsUserDao.SelectUserList(userid);

            // 指定ユーザー情報が存在しない場合
            if (rec == null)
            {
                return NotFound();
            }

            return Ok(rec);
        }
    }
}
