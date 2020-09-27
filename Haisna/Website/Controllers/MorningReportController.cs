using Hainsi.Entity;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 朝レポートコントローラークラス
    /// </summary>
    //[Authorize]
    [Route("api/v1/morningreports")]
    public class MorningReportController : Controller
    {
        /// <summary>
        /// 朝レポートデータアクセスオブジェクト
        /// </summary>
        readonly MorningReportDao morningReportDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="morningReportDao">朝レポートデータアクセスオブジェクト</param>
        public MorningReportController(MorningReportDao morningReportDao)
        {
            this.morningReportDao = morningReportDao;
        }

        /// <summary>
        /// 時間帯別受診者情報を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="needUnReceipt">未受付者取得フラグ</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/reservationgroups")]
        public IActionResult GetRsvFraDaily(string cslDate, string csCd = "", bool needUnReceipt = false)
        {
            List<dynamic> data = morningReportDao.SelectRsvFraDaily(cslDate, csCd, needUnReceipt);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// トラブル情報を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="pubNoteDivCd">受診情報ノート分類コード</param>
        /// <param name="dispKbn">表示対象</param>
        /// <param name="needUnReceipt">未受付者取得フラグ</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/pubnotes")]
        public IActionResult GetPubNoteDaily(DateTime cslDate, string csCd,  string pubNoteDivCd, int dispKbn, bool needUnReceipt = false)
        {
            // 更新User
            string updUser = HttpContext.Session.GetString("userId");
            updUser = "HAINS$";

            List<dynamic> data = morningReportDao.SelectPubNoteDaily(cslDate, csCd, updUser, pubNoteDivCd, dispKbn, needUnReceipt);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }


        /// <summary>
        /// セット別受診者情報を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="needUnReceipt">未受付者取得フラグ</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/setgroups")]
        public IActionResult GetSetCountDaily(DateTime cslDate, string csCd = "", bool needUnReceipt = false)
        {

            List<dynamic> data = morningReportDao.SelectSetCountDaily(cslDate, csCd, needUnReceipt);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 同姓受診者情報を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="needUnReceipt">未受付者取得フラグ</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/samesurnames")]
        public IActionResult GetSameNameDaily(DateTime cslDate, string csCd = "", bool needUnReceipt = false)
        {

            List<dynamic> data = morningReportDao.SelectSameNameDaily(cslDate, csCd, needUnReceipt);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 同伴者（お連れ様）受診者情報を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="needUnReceipt">未受付者取得フラグ</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response> 
        [HttpGet("~/api/v1/consultations/friends")]
        public IActionResult GetFriendsDaily(DateTime cslDate, string csCd = "", bool needUnReceipt = false)
        {
            List<dynamic> data = morningReportDao.SelectFriendsDaily(cslDate, csCd, needUnReceipt);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);

        }

    }
}
