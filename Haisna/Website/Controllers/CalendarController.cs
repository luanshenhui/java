using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.Entity.Model.Consultation;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// Calendarコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/calendars")]
    public class CalendarController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly CalendarDao calendarDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="calendarDao">データアクセスオブジェクト</param>
        public CalendarController(CalendarDao calendarDao)
        {
            this.calendarDao = calendarDao;
        }

        /// <summary>
        /// 指定年月の予約空き状況取得
        /// </summary>
        /// <param name="mode">検索モード</param>
        /// <param name="cslYear">年</param>
        /// <param name="cslMonth">月</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="manCnt">人数</param>
        /// <param name="gender">性別</param>
        /// <param name="birth">生年月日</param>
        /// <param name="age">受診時年齢</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="cslDivCd">受診区分コード</param>
        /// <param name="rsvGrpCd">予約群コード</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <response code="200">成功</response>
        /// <response code="409">重複</response>
        [HttpPost("monthly")]
        public IActionResult GetEmptyCalendar(String mode, long cslYear, long cslMonth, List<dynamic> perId, List<dynamic> manCnt,
            List<dynamic> gender, List<dynamic> birth, List<dynamic> age, List<dynamic> csCd, List<dynamic> cslDivCd, 
            List<dynamic> rsvGrpCd, List<dynamic> ctrPtCd, List<dynamic> optCd, List<dynamic> optBranchNo)
        {
            // 受診日
            List<DateTime> cslDate = new List<DateTime>();
            // 休診日
            List<decimal> holiday = new List<decimal>();
            // 状態
            List<string> status = new List<string>();

            Insert ret = calendarDao.GetEmptyCalendar(mode, cslYear, cslMonth, perId, manCnt, gender, birth, age, csCd,
                cslDivCd, rsvGrpCd, ctrPtCd, optCd, optBranchNo, ref cslDate, ref holiday, ref status);

            // 重複した時は409を返す
            if (ret == Insert.Duplicate)
            {
                return StatusCode(StatusCodes.Status409Conflict);
            }

            var ds = new Dictionary<string, object>
                        {
                            { "csldate", cslDate },
                            { "holiday", holiday },
                            { "status", status }
                        };

            return Ok(ds);
        }

        /// <summary>
        /// 指定年月の予約空き状況取得(予約番号指定)
        /// </summary>
        /// <param name="data">入力値</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpPost("monthly/alterable")]
        [ProducesResponseType(typeof(Dictionary<string, object>), 200)]
        [ProducesResponseType(404)]
        public IActionResult GetEmptyCalendarFromRsvNo([FromBody] GetEmptyCalendarFromRsvNoModel data)
        {
            // 受診日
            List<DateTime> cslDate = new List<DateTime>();
            // 休診日
            List<decimal?> holiday = new List<decimal?>();
            // 状態
            List<string> status = new List<string>();

            long Ret = calendarDao.GetEmptyCalendarFromRsvNo(data.Mode, data.CslYear, data.CslMonth, data.RsvNo, data.RsvGrpCd, ref cslDate, ref holiday, ref status);

            // データ件数が0件の場合
            if (Ret <= 0)
            {
                return NotFound();
            }

            var ds = new Dictionary<string, object>
                        {
                            { "csldate", cslDate },
                            { "holiday", holiday },
                            { "status", status }
                        };

            return Ok(ds);
        }

        /// <summary>
        /// 指定年月の予約空き状況取得
        /// </summary>
        /// <param name="mode">検索モード</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="manCnt">人数</param>
        /// <param name="gender">性別</param>
        /// <param name="birth">生年月日</param>
        /// <param name="age">受診時年齢</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="cslDivCd">受診区分コード</param>
        /// <param name="rsvGrpCd">予約群コード</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <response code="200">成功</response>
        [HttpPost]
        public IActionResult GetEmptyStatus(String mode, List<dynamic> cslDate, List<dynamic> perId, List<dynamic> manCnt,
            List<dynamic> gender, List<dynamic> birth, List<dynamic> age, List<dynamic> csCd, List<dynamic> cslDivCd,
            List<dynamic> rsvGrpCd, List<dynamic> ctrPtCd, List<dynamic> optCd, List<dynamic> optBranchNo)
        {
            // 休診日
            List<decimal> holiday = new List<decimal>();
            // 状態
            List<string> status = new List<string>();
            // 各検索条件に対して検索された予約群のコレクション
            List<decimal> findRsvGrpCd = new List<decimal>();

            calendarDao.GetEmptyStatus(mode, cslDate, perId, manCnt, gender, birth, age, csCd,
                cslDivCd, rsvGrpCd, ctrPtCd, optCd, optBranchNo, ref holiday, ref status, ref findRsvGrpCd);

            var ds = new Dictionary<string, object>
                        {
                            { "holiday", holiday },
                            { "status", status },
                            { "findrsvgrpcd", findRsvGrpCd }
                        };

            return Ok(ds);
        }
    }
}
