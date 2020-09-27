using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.Entity.Model.Schedule;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 予約枠アクセス用WebAPIコントローラークラス
    /// </summary>
    [Route("api/v1/schedules")]
    public class ScheduleController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly ScheduleDao scheduleDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="scheduleDao">データアクセスオブジェクト</param>
        public ScheduleController(ScheduleDao scheduleDao)
        {
            this.scheduleDao = scheduleDao;
        }

        /// <summary>
        /// 予約人数管理情報を削除する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="rsvGrpCd">予約群コード</param>
        /// <response code="204">成功</response>
        [HttpDelete("{cslDate}/{csCd}/{rsvGrpCd}")]
        public IActionResult DeleteRsvFraMng(DateTime cslDate, string csCd, int rsvGrpCd)
        {
            scheduleDao.DeleteRsvFraMng(cslDate, csCd, rsvGrpCd);
            return NoContent();
        }

        /// <summary>
        /// コース受診予約群をもつコースのみを取得
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/courses/managedreservationgroup")]
        public IActionResult GetCourseListRsvGrpManaged()
        {
            List<dynamic> list = scheduleDao.SelectCourseListRsvGrpManaged();

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定コースの予約群を取得する
        /// </summary>
        /// <param name="csCd">コースコード</param>
        /// <param name="sortOrder">ソート順(0:予約群コード順、0以外:開始時間順)</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{csCd}/reservationgroups")]
        public IActionResult GetCourseRsvGrpListSelCourse(string csCd, long sortOrder)
        {
            List<dynamic> list = scheduleDao.SelectCourseRsvGrpListSelCourse(csCd, sortOrder);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定予約枠コードの予約枠情報を取得する
        /// </summary>
        /// <param name="rsvFraCd">予約枠コード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/reservationframes/{rsvFraCd}")]
        public IActionResult GetRsvFra(string rsvFraCd)
        {
            List<dynamic> list = scheduleDao.SelectRsvFra(rsvFraCd);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 検索条件に従って予約人数管理情報の一覧を取得する
        /// </summary>
        /// <param name="startCslDate">検索条件受診日（開始）</param>
        /// <param name="endCslDate">検索条件受診日（終了）</param>
        /// <param name="csCd">検索条件コースコード</param>
        /// <param name="rsvGrpCd">検索条件予約群</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetRsvFraMngList(string startCslDate, string endCslDate, string csCd, string rsvGrpCd)
        {
            List<dynamic> list = scheduleDao.SelectRsvFraMngList(startCslDate, endCslDate, csCd, rsvGrpCd);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 検索条件に従って予約人数管理情報の一覧を取得する
        /// </summary>
        /// <param name="data">
        /// selCsCd     コースコード
        /// strCslDate  開始受診日
        /// endCslDate  終了受診日
        /// </param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpPost("capacity")]
        [ProducesResponseType(typeof(List<dynamic>), 200)]
        [ProducesResponseType(404)]

        public IActionResult GetRsvFraMngListCapacity([FromBody] RsvCapacity data)
        {
            List<dynamic> list = scheduleDao.SelectRsvFraMngList_Capacity(Convert.ToDateTime(data.StrDate), Convert.ToDateTime(data.EndDate), data.SelCsCd);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// すべての予約群を取得する
        /// </summary>
        /// <param name="sortOrder">ソート順(0:予約群コード順、0以外:開始時間順)</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/reservationgroups")]
        public IActionResult GetRsvGrpList(long sortOrder)
        {
            List<dynamic> list = scheduleDao.SelectRsvGrpList(sortOrder);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定期間の病院スケジューリング情報を取得する
        /// </summary>
        /// <param name="strDate">読み込み開始日付</param>
        /// <param name="endDate">読み込み終了日付</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/hospitalschedules")]
        public IActionResult GetScheduleh(string strDate, string endDate)
        {
            dynamic data = scheduleDao.SelectSchedule_h(strDate, endDate);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 予約人数管理情報を登録する
        /// </summary>
        /// <param name="data">
        /// csldate   受診日
        /// cscd      コースコード
        /// rsvgrpcd  予約群コード
        /// maxcnt    予約可能人数（共通）
        /// maxcnt_m  予約可能人数（男）
        /// maxcnt_f  予約可能人数（女）
        /// overcnt   オーバ可能人数（共通）
        /// overcnt_m オーバ可能人数（男）
        /// overcnt_f オーバ可能人数（女）
        /// </param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("bulk")]
        public IActionResult Insert([FromBody] RsvFraMng data)
        {
            // エラーメッセージの集合
            List<dynamic> messages = new List<dynamic>();

            Insert ret = scheduleDao.UpdateRsvFraMngInfo("insert", data, ref messages);

            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            return NoContent();
        }

        /// <summary>
        /// 予約人数管理情報を更新する
        /// </summary>
        /// <param name="data">
        /// csldate   受診日
        /// cscd      コースコード
        /// rsvgrpcd  予約群コード
        /// maxcnt    予約可能人数（共通）
        /// maxcnt_m  予約可能人数（男）
        /// maxcnt_f  予約可能人数（女）
        /// overcnt   オーバ可能人数（共通）
        /// overcnt_m オーバ可能人数（男）
        /// overcnt_f オーバ可能人数（女）
        /// </param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("bulk")]
        public IActionResult Update([FromBody] RsvFraMng data)
        {
            // エラーメッセージの集合
            List<dynamic> messages = new List<dynamic>();

            Insert ret = scheduleDao.UpdateRsvFraMngInfo("update", data, ref messages);

            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            return NoContent();
        }

        /// <summary>
        /// ひと月分の病院スケジューリングを一括更新する
        /// </summary>
        /// <param name="data">
        /// arrHoliday 月始日付～月末日付の設定値（0:未設定，1:休診日，2:祝日）
        /// warnings   警告メッセージ
        /// holidays   月始日付～月末日付の設定値
        /// </param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        /// <response code="409">重複</response>
        [HttpPut("~/api/v1/hospitalschedules")]
        public IActionResult UpdateScheduleh([FromBody] MntCapacity data)
        {
            // 月始日付～月末日付の設定値（0:未設定，1:休診日，2:祝日）
            List<int> arrHoliday = data.ArrHoliday;

            // 警告メッセージ
            List<dynamic> warnings = data.Warnings;
            
            // 開始受診日
            string strDate = data.StrDate;

            // 終了受診日
            string endDate = data.EndDate;

            // 病院スケジューリング入力値の妥当性チェックを行う
            List<dynamic> messages = scheduleDao.CheckValueSchedule_h(strDate, endDate, arrHoliday, ref warnings);

            var items = new Dictionary<string, List<dynamic>>
            {
                { "warnings",warnings},
                { "messages",messages}
            };
            if ((messages != null && messages.Count > 0) || (warnings != null && warnings.Count > 0))
            {
                return BadRequest(items);
            }

            // 月始日付～月末日付の設定値
            Insert ret = scheduleDao.UpdateSchedule_h(strDate, endDate, arrHoliday);

            if (ret == Common.Constants.Insert.Error)
            {
                return StatusCode(StatusCodes.Status409Conflict);
            }

            return NoContent();
        }

        /// <summary>
        /// 予約人数管理情報のコピーを行う
        /// </summary>
        /// <param name="data">
        /// </param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("~/api/v1/copyrsvframng")]
        public IActionResult RegisterCopyRsvFraMng([FromBody] CopyRsvFraMng data)
        {
            // コピー元受診日
            DateTime cslDate = Convert.ToDateTime(data.CslDate);
            // コースコード
            string csCd = data.CsCd;
            // 予約群コード
            string rsvGrpCd = data.RsvGrpCd;
            // コピー先開始受診日
            DateTime strCslDate = Convert.ToDateTime(data.StrCslDate);
            // コピー先終了受診日
            DateTime endCslDate = Convert.ToDateTime(data.EndCslDate);
            // 曜日フラグ
            List<string> weekdays = data.WeekDays;
            // 上書きフラグ
            bool update = data.Update;
            // 予約人数管理情報のコピー処理
            long ret = scheduleDao.CopyRsvFraMng(cslDate, csCd, rsvGrpCd, strCslDate, endCslDate, weekdays, update);

            if (ret == -1)
            {
                return BadRequest("予約枠は作成されませんでした。");
            }

            return Ok(ret);
        }

        /// <summary>
        /// 予約枠の一覧を取得する
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/reservations")]
        public IActionResult GetRsvFraList()
        {
            List<dynamic> list = scheduleDao.SelectRsvFraList();

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 計上日の取得する
        /// </summary>
        /// <param name="paymentDate">入金(返金)日付</param>
        /// <param name="closeDate">締め日</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("getCalcDate")]
        public IActionResult GetCalcDate(DateTime paymentDate, DateTime closeDate)
        {
            DateTime calcDate = scheduleDao.GetCalcDate(paymentDate, closeDate);

            // データ件数が0件の場合
            if (calcDate == null)
            {
                return NotFound();
            }

            return Ok(calcDate);
        }
    }
}
