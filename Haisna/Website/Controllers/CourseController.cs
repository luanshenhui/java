using Hainsi.Entity;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// コースコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/courses")]
    public class CourseController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly CourseDao courseDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="courseDao">データアクセスオブジェクト</param>
        public CourseController(CourseDao courseDao)
        {
            this.courseDao = courseDao;
        }

        /// <summary>
        /// コースの一覧を取得する
        /// </summary>
        /// <param name="mode">取得モード（0:すべて、1:メインコース（契約可能なもの）のみ、2:サブコースのみ、3:メインコース（全て））</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetCourseList(int mode)
        {
            List<dynamic> list = courseDao.SelectCourseList(mode);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// コース情報を取得する
        /// </summary>
        /// <param name="csCd">コースコード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{csCd}")]
        public IActionResult GetCourse(string csCd)
        {
            dynamic data = courseDao.SelectCourse(csCd);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 契約適用期間に適用可能なコースカウントを取得する
        /// </summary>
        /// <param name="csCd">コースコード</param>
        /// <param name="strDate">開始日</param>
        /// <param name="endDate">終了日</param>
        /// <response code="200">成功</response>
        [HttpGet("count")]
        public IActionResult GetHistoryCount(string csCd, DateTime strDate, DateTime endDate)
        {
            int count = courseDao.GetHistoryCount(csCd, strDate, endDate);

            var ds = new Dictionary<string, object>
                        {
                            { "count",  count}
                        };

            return Ok(ds);
        }

        /// <summary>
        /// コース履歴の一覧を取得する
        /// </summary>
        /// <param name="csCd">コースコード</param>
        /// <param name="strDate">開始日</param>
        /// <param name="endDate">終了日</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{csCd}/histories")]
        public IActionResult GetCourseHistory(string csCd, DateTime? strDate, DateTime? endDate)
        {
            List<dynamic> list = courseDao.SelectCourseHistory(csCd, strDate, endDate);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 今日の受診者取得（コース別）の一覧を取得する
        /// </summary>
        /// <param name="selDate">対象日付</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/courses")]
        public IActionResult GetSelDateCourse(string selDate)
        {
            List<dynamic> list = courseDao.SelectSelDateCourse(selDate);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }
    }
}
