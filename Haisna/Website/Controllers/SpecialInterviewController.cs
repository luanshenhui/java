using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using Hainsi.Entity.Model.SpecialInterview;
using Microsoft.AspNetCore.Http;
using Hainsi.Entity;
using System;
using Newtonsoft.Json.Linq;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 特別インタビューテーブルデータコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/specialinterviews")]
    public class SpecialInterviewController : Controller
    {
        /// <summary>
        /// 特別インタビューテーブルデータアクセスオブジェクト
        /// </summary>
        readonly SpecialInterviewDao specialInterviewDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="specialInterviewDao">特別インタビューテーブルデータアクセスオブジェクト</param>
        public SpecialInterviewController(SpecialInterviewDao specialInterviewDao)
        {
            this.specialInterviewDao = specialInterviewDao;
        }

        /// <summary>
        /// 特定保健指導対象者チェック
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
		/// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/special")]
        public IActionResult CheckSpecialTarget(int rsvNo)
        {
            int ret = specialInterviewDao.CheckSpecialTarget(rsvNo);

            return Ok(ret);
        }

        /// <summary>
        /// 指定予約番号の契約情報の中の特定健診セット情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
		/// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/special/setclass")]
        public IActionResult GetSetClassCd(int rsvNo)
        {
            bool ret = specialInterviewDao.SelectSetClassCd(rsvNo);

            return Ok(ret);
        }

        /// <summary>
        /// 指定された予約番号の階層化コメントを取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="dispMode">表示分類（1:総合コメント、2:生活指導コメント、3:食習慣コメント、4:献立コメント、5：特定健診）</param>
        /// <response code="200">成功</response>
		/// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/special/totalcomments")]
        public IActionResult GetSpecialJudCmt(int rsvNo, int dispMode)
        {
            // 指定された予約番号の階層化コメントを取得する
            List<dynamic> items = specialInterviewDao.SelectSpecialJudCmt(rsvNo, dispMode);

            if (items == null || items.Count <= 0)
            {
                return NotFound();
            }

            return Ok(items);
        }

        /// <summary>
        /// 予約番号をもって検査結果を取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="grpcd">検査項目グループコード</param>
        /// <response code="200">成功</response>
		/// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/special/results")]
        public IActionResult GetSpecialResult(int rsvNo, string grpcd)
        {
            // 予約番号をもって検査結果を取得
            List<dynamic> items = specialInterviewDao.SelectSpecialResult(rsvNo, grpcd);

            if (items == null || items.Count <= 0)
            {
                return NotFound();
            }

            return Ok(items);
        }

        /// <summary>
        /// 予約番号をキーに指定対象受診者の検査結果を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号（今回分）</param>
        /// <response code="200">成功</response>
		/// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/special/views")]
        public IActionResult GetSpecialRslView(int rsvNo)
        {
            // 予約番号をキーに指定対象受診者の検査結果を取得する
            List<dynamic> items = specialInterviewDao.SelectSpecialRslView(rsvNo);

            if (items == null || items.Count <= 0)
            {
                return NotFound();
            }

            return Ok(items);
        }

        /// <summary>
        /// 指定された予約番号の階層化コメントを更新する
        /// </summary>
        /// <param name="data"></param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("~/api/v1/consultations/{rsvNo}/specialJudcomments")]
        public IActionResult UpdSpecialJudCmt([FromBody] SpecialJudCmtList data)
        {
            string updUser = HttpContext.Session.GetString("userId");
            // TODO 仮userIdで設定する
            updUser = "HAINS$";
            data.UpdUser = updUser;

            bool ret = specialInterviewDao.UpdateSpecialJudCmt(data);

            if (ret == false)
            {
                return BadRequest();
            }

            return NoContent();
        }

    }
}