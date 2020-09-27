using Hainsi.Entity;
using Hainsi.Entity.Model.Free;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Collections.Specialized;

using Newtonsoft.Json.Linq;
using System;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 汎用テーブルデータコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/frees")]
    public class FreeController : Controller
    {
        /// <summary>
        /// 汎用データアクセスオブジェクト
        /// </summary>
        readonly FreeDao freeDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="freeDao">汎用データアクセスオブジェクト</param>
        public FreeController(FreeDao freeDao)
        {
            this.freeDao = freeDao;
        }

        /// <summary>
        /// 受診日時点の年齢計算
        /// </summary>
        /// <param name="birth">生年月日</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="bsDate">起算日</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/calculate/age")]
        public IActionResult CalcAge(DateTime birth, DateTime? cslDate = null, String bsDate = null)
        {
            string age = freeDao.CalcAge(birth, cslDate, bsDate);

            // データ件数が0件の場合
            if (string.IsNullOrEmpty(age))
            {
                return NotFound();
            }

            return Ok(age);
        }

        /// <summary>
        /// 検索条件を満たす汎用テーブルの一覧を取得する
        /// </summary>
        /// <param name="freeCd ">検索キーの集合</param>
        /// <response code="200">成功</response>
        [HttpGet("count")]
        public IActionResult GdeSelectFreeCount(string freeCd)
        {
            int ret = freeDao.GdeSelectFreeCount(freeCd);

            return Ok(ret);
        }

        /// <summary>
        /// 汎用テーブル読み込み
        /// </summary>
        /// <param name="mode">検索モード(0:一意検索、1:前方一致検索、2:全件)</param>
        /// <param name="freeCd ">汎用コード(検索キー値)</param>
        /// <param name="locking">レコードロック実施有無</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetFree(int mode, string freeCd, bool locking = false)
        {
            List<dynamic> data = freeDao.SelectFree(mode, freeCd, locking);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 汎用テーブル読み込み
        /// </summary>
        /// <param name="mode">検索モード(0:一意検索、1:前方一致検索、2:全件)</param>
        /// <param name="freeClassCd">汎用コード(検索キー値)</param>
        /// <param name="locking">レコードロック実施有無</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("classed")]
        public IActionResult GetFreeByClassCd(int mode, string freeClassCd, bool locking = false)
        {
            List<dynamic> data = freeDao.SelectFreeByClassCd(mode, freeClassCd, locking);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 汎用テーブル読み込み
        /// </summary>
        /// <param name="mode">検索モード(0:一意検索、1:前方一致検索、2:全件)</param>
        /// <param name="freeCd ">汎用コード(検索キー値)</param>
        /// <param name="freeDate ">受診日</param>
        /// <param name="locking">レコードロック実施有無</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("date")]
        public IActionResult GetFreeDate(int mode, string freeCd, DateTime? freeDate = null, bool locking = false)
        {
            List<dynamic> data = freeDao.SelectFreeDate(mode, freeCd, freeDate, locking);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 汎用テーブルレコード更新
        /// </summary>
        /// <param name="freeCd">汎用コード</param>
        /// <param name="data">汎用情報</param>
        /// <response code="204">成功</response>
        [HttpPut("{freeCd}")]
        public IActionResult UpdateFree(string freeCd, [FromBody] UpdateFree data)
        {
            bool result = freeDao.UpdateFree(freeCd, data);

            return NoContent();
        }

    }
}
