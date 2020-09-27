using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// 団体グループコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/[controller]")]
    public class OrgGrpPController : Controller
    {
        /// <summary>
        /// 一覧を取得する
        /// </summary>
        /// <returns>一覧</returns>
        [HttpGet]
        public IActionResult Get(string usegrp)
        {
            var data = new List<dynamic>();
            for (int i = 0; i < 50; i++)
            {
                string grpname = "テスト団体グループ名" + i.ToString();
                if (!string.IsNullOrEmpty(usegrp))
                {
                    grpname = grpname + string.Format("(usrgrp:{0})", usegrp);
                }

                data.Add(
                    new
                    {
                        orggrpcd = (i + 1).ToString("D3"),
                        grpname
                    }
                );
            }

            var ds = new Dictionary<string, List<dynamic>>
                        {
                            { "data", data }
                        };

            // データ件数が0件の場合
            if (data.Count == 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }
    }
}
