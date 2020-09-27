using Hainsi.Entity;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// JudgementControlコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/judgements")]
    public class JudgementControlController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly JudgementControlDao judgementControlDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="judgementControlDao">データアクセスオブジェクト</param>
        public JudgementControlController(JudgementControlDao judgementControlDao)
        {
            this.judgementControlDao = judgementControlDao;
        }

        /// <summary>
        /// 指定された条件の計算処理を起動する
        /// </summary>
        /// <param name="data"></param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost]
        public IActionResult JudgeAutomaticallyMain([FromBody] JToken data)
        {
            string updUser = HttpContext.Session.GetString("userId");
            // TODO
            updUser = "HAINS$";

            string ipAddress = HttpContext.Connection.RemoteIpAddress.ToString();
            string cslDate = Convert.ToString(data["csldate"]);
            List<long> calcFlg = data["calcFlg"].ToObject<List<long>>();
            long dayIdFlg = Convert.ToInt64(data["dayIdFlg"]);
            string strDayId = Convert.ToString(data["strDayId"]);
            string endDayId = Convert.ToString(data["endDayId"]);
            List<string> arrDayId = data["arrDayId"].ToObject<List<string>>();
            string csCd = Convert.ToString(data["csCd"]);
            string judClassCd = Convert.ToString(data["judClassCd"]);
            long entryCheck = Convert.ToInt64(data["entryCheck"]);
            long reJudge = Convert.ToInt64(data["reJudge"]);

            bool ret = judgementControlDao.JudgeAutomaticallyMain(updUser, ipAddress, cslDate, calcFlg, dayIdFlg, strDayId, endDayId, 
                arrDayId, csCd, judClassCd, entryCheck, reJudge);

            if(ret == false)
            {
                return BadRequest();
            }

            return NoContent();
        }
    }
}
