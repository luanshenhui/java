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
    /// ReportLogコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/reportlogs")]
    public class ReportLogController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly ReportLogDao reportLogDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="reportLogDao">データアクセスオブジェクト</param>
        public ReportLogController(ReportLogDao reportLogDao)
        {
            this.reportLogDao = reportLogDao;
        }

        /// <summary>
        /// 帳票ログデータを取得する
        /// </summary>
        /// <param name="printDate">出力日時</param>
        /// <param name="reportCd">帳票コード</param>
        /// <param name="sortOld">TRUE:古い順に表示（省略時は最新順）</param>
        /// <param name="prtStatus">ステータス</param>
        /// <returns></returns>
        [HttpGet]
        public IActionResult GetReportLog(String printDate = null, String reportCd = null, bool sortOld = false, String prtStatus = null)
        {
            string userId = HttpContext.Session.GetString("userid");  // ユーザID
            // TODO
            userId = "HAINS$";
            List<dynamic> data = reportLogDao.SelectReportLog(printDate, reportCd, sortOld, prtStatus, userId);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 印刷ログテーブルレコードの読み込み
        /// </summary>
        /// <param name="printSeq">プリントSEQ</param>
        /// <returns></returns>
        [HttpGet("{printSeq}")]
        public IActionResult GetReportLog2(long printSeq)
        {
            dynamic data = reportLogDao.SelectReportLog2(printSeq);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }
    }
}
