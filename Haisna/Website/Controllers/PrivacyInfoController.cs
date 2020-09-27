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
    /// #ToDo
    /// PrivacyInfoコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/privacy")]
    public class PrivacyInfoController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly PrivacyInfoDao privacyInfoDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="privacyInfoDao">データアクセスオブジェクト</param>
        public PrivacyInfoController(PrivacyInfoDao privacyInfoDao)
        {
            this.privacyInfoDao = privacyInfoDao;
        }

        /// <summary>
        /// 情報漏えい対策ログ出力
        /// </summary>
        /// <param name="functionCode">機能コード（各ASP個別指定。聖路加指定のため追加）</param>
        /// <param name="logMessage">ログメッセージ（各ASP個別指定。聖路加指定のため追加）</param>
        /// <returns></returns>
        [HttpPut("{functionCode}")]
        public IActionResult PutPrivacyInfoLog(string functionCode, string logMessage)
        {
            string userId = HttpContext.Session.GetString("userid");

            // ToDo Daoに実現していない
            //int ret = privacyInfoDao.PutPrivacyInfoLog(userId, functionCode, logMessage, HttpContext);

            // データ件数が0件の場合
            //if (ret == -1)
            //{
            //    return NotFound();
            //}

            return Ok();
        }
    }
}
