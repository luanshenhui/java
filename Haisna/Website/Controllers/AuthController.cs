using Hainsi.Entity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// ログイン／認証コントローラ
    /// </summary>
    [Route("api/[controller]")]
    public class AuthController : Controller
    {
        /// <summary>
        /// ユーザーデータアクセスオブジェクト
        /// </summary>
        readonly HainsUserDao hainsUserDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="hainsUserDao">ユーザーデータアクセスオブジェクト</param>
        public AuthController(HainsUserDao hainsUserDao)
        {
            this.hainsUserDao = hainsUserDao;
        }

        /// <summary>
        /// ログイン
        /// </summary>
        /// <param name="data">ログイン情報</param>
        /// <returns>結果</returns>
        [HttpPost]
        public IActionResult Login([FromBody] JToken data)
        {
            // 入力データバリデーション
            List<string> messages = hainsUserDao.Validate(data);
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            dynamic rec = hainsUserDao.CheckIDandPassword(data);

            if (rec == null)
            {
                return Unauthorized();
            }

            string userid = Convert.ToString(data["username"]);
            // FormsAuthentication.SetAuthCookie(userid, false);

            // セッションにユーザIDセット
            HttpContext.Session.SetString("userId", userid);

            return Ok(rec);
        }

        /// <summary>
        /// ユーザ名取得
        /// （セッション読み込みテスト用）
        /// </summary>
        /// <returns>ユーザ名</returns>
        //[Authorize]
        [HttpGet]
        public IActionResult Get()
        {
            //return Ok(new Dictionary<string, string>() { { "username", HttpContext.Session.GetString("userId") } });
            return Ok(new Dictionary<string, string>() { { "username", "HAINS$" } });
        }
    }
}
