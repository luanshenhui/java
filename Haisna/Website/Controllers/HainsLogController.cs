using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using Hainsi.Entity;
using System;

namespace Hainsi.Controllers
{
    /// <summary>
    /// ログアデータコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/hainslogs")]
    public class HainsLogController : Controller
    {
        /// <summary>
        /// ログアデータアクセスオブジェクト
        /// </summary>
        readonly HainsLogDao hainsLogDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="hainsLogDao">ログアデータアクセスオブジェクト</param>
        public HainsLogController(HainsLogDao hainsLogDao)
        {
            this.hainsLogDao = hainsLogDao;
        }

        /// <summary>
        /// 印刷ログ情報取得する
        /// </summary>
        /// <param name="startPos">SELECT開始位置</param>
        /// <param name="limit">取得件数</param>
        /// <param name="transactionDiv">表示処理区分</param>
        /// <param name="informationDiv">表示情報区分</param>
        /// <param name="transactionID">処理ID</param>
        /// <param name="message">検索文字列</param>
        /// <param name="orderByOld">表示順</param>
        /// <param name="insDate">処理日時</param>
        /// <response code="200">成功</response>
		/// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetHainsLog(int? startPos = null, int? limit = null, string transactionDiv = null,
                                         string informationDiv = null, string transactionID = null, string message = null, 
                                         string orderByOld = null, DateTime? insDate = null)
        {
            List<dynamic> data = hainsLogDao.SelectHainsLog("CNT", startPos, limit, transactionDiv, informationDiv, transactionID, message, orderByOld, insDate);

            // データ件数が0件の場合
            if (Convert.ToInt32(data[0].RECORDCOUNT) == 0)
            {
                return NotFound();
            }
            var count = Convert.ToInt32(data[0].RECORDCOUNT);
            List<dynamic> result = hainsLogDao.SelectHainsLog("SRC", startPos, limit, transactionDiv, informationDiv, transactionID, message, orderByOld, insDate);

            // データ件数が0件の場合
            if (result == null || result.Count <= 0)
            {
                return NotFound();
            }

            // 締め日情報を追加する
            var rec = new Dictionary<string, dynamic>
            {
                {"recordcount", count},
                {"loglist", result }
            };

            return Ok(rec);
        }
    }
}
