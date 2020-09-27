using Hainsi.Entity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// Templateコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/templates")]
    public class TemplateController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly TemplateDao templateDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="templateDao">データアクセスオブジェクト</param>
        public TemplateController(TemplateDao templateDao)
        {
            this.templateDao = templateDao;
        }

        /// <summary>
        /// メールテンプレートの一覧を取得する
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public IActionResult GetMailTemplateList()
        {
            List<dynamic> data = templateDao.SelectMailTemplateList();

            // データ件数が0件の場合
            if (data == null || data.Count <=0)
            {
                return NotFound();
            }

            return Ok(data);
        }
    }
}
