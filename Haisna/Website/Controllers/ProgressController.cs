using Hainsi.Entity;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 進捗管理用分類アクセス用WebAPIコントローラークラス
    /// </summary>
    //[Authorize]
    [Route("api/v1/progresses")]
    public class ProgressController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly ProgressDao progressDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="progressDao">進捗管理用分類データアクセスオブジェクト</param>
        public ProgressController(ProgressDao progressDao)
        {
            this.progressDao = progressDao;
        }

        /// <summary>
        /// 進捗分類コードに対する進捗分類名を取得する
        /// </summary>
        /// <param name="progressCd">進捗分類コード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{progressCd}")]
        public IActionResult GetProgress(string progressCd)
        {
            dynamic data = progressDao.SelectProgress(progressCd);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 進捗分類の一覧を取得する
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetProgressList()
        {
            List<dynamic> data = progressDao.SelectProgressList();

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定予約番号の検査結果に対し、進捗分類ごとの入力状態を取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/progresses")]
        public IActionResult GetProgressRsl(int rsvNo)
        {
            IList<dynamic> data = progressDao.SelectProgressRsl(rsvNo);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }
    }
}
