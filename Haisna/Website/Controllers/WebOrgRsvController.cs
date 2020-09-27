using Hainsi.Entity;
using Hainsi.Entity.Model.WebOrgRsv;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// WebOrgRsvコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/weborgreserves")]
    public class WebOrgRsvController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly WebOrgRsvDao webOrgRsvDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="webOrgRsvDao">データアクセスオブジェクト</param>
        public WebOrgRsvController(WebOrgRsvDao webOrgRsvDao)
        {
            this.webOrgRsvDao = webOrgRsvDao;
        }

        /// <summary>
        /// 指定受診日、webNoのweb予約情報を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="webNo">webNo.</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{cslDate}/{webNo}")]
        public IActionResult GetWebOrgRsv(DateTime cslDate, int webNo)
        {
            dynamic data = webOrgRsvDao.SelectWebOrgRsv(cslDate, webNo);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定検索条件のweb予約情報を取得する
        /// </summary>
        /// <param name="strCslDate">開始受診年月日</param>
        /// <param name="endCslDate">終了受診年月日</param>
        /// <param name="key">検索キー</param>
        /// <param name="strOpDate">開始処理年月日</param>
        /// <param name="endOpDate">終了処理年月日</param>
        /// <param name="orgCd1">受診団体コード1</param>
        /// <param name="orgCd2">受診団体コード2</param>
        /// <param name="opMode">処理モード(1:申込日で検索、2:予約処理日で検索)</param>
        /// <param name="regFlg">本登録フラグ(0:指定なし、1:未登録者、2:編集済み受診者)</param>
        /// <param name="moushiKbn">申込区分（0：すべて　1:新規　2:キャンセル）</param>
        /// <param name="order">出力順(1:受診日順、2:個人ID順)</param>
        /// <param name="page">取得開始位置</param>
        /// <param name="limit">取得件数(0:全件)</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetWebOrgRsvList(DateTime strCslDate, DateTime endCslDate, string key, DateTime? strOpDate, DateTime? endOpDate,
            int opMode, int regFlg, int moushiKbn, int order, string orgCd1= "", string orgCd2 = "", int page = 1, int limit = 0)
        {
            List<dynamic> data = webOrgRsvDao.SelectWebOrgRsvList(out int totalCount, strCslDate, endCslDate, key, strOpDate, endOpDate,
                orgCd1, orgCd2, opMode, regFlg, moushiKbn, order, page, limit);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(new { totalCount, data });
        }

        /// <summary>
        /// 指定検索条件のweb予約情報のうち、指定受診年月日、webNoの次レコードを取得
        /// </summary>
        /// <param name="strCslDate">開始受診年月日</param>
        /// <param name="endCslDate">終了受診年月日</param>
        /// <param name="key">検索キー</param>
        /// <param name="strOpDate">開始処理年月日</param>
        /// <param name="endOpDate">終了処理年月日</param>
        /// <param name="orgCd1">受診団体コード1</param>
        /// <param name="orgCd2">受診団体コード2</param>
        /// <param name="opMode">処理モード(1:申込日で検索、2:予約処理日で検索)</param>
        /// <param name="regFlg">本登録フラグ(0:指定なし、1:未登録者、2:編集済み受診者)</param>
        /// <param name="moushiKbn">申込区分（0：すべて　1:新規　2:キャンセル）</param>
        /// <param name="order">出力順(1:受診日順、2:個人ID順)</param>
        /// <param name="cslDate">受診年月日</param>
        /// <param name="webNo">webNo.</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{cslDate}/{webNo}/next")]
        public IActionResult GetWebOrgRsvNext(DateTime strCslDate, DateTime endCslDate, string key,
            DateTime? strOpDate, DateTime? endOpDate, string orgCd1, string orgCd2,
            int opMode, int regFlg, int moushiKbn, int order, DateTime cslDate, int webNo)
        {
            dynamic data = webOrgRsvDao.SelectWebOrgRsvNext(strCslDate, endCslDate, key, strOpDate, endOpDate,
                orgCd1, orgCd2, opMode, regFlg, moushiKbn, order, cslDate, webNo);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// web予約情報の登録する
        /// </summary>
        /// <param name="data">web予約情報</param>
        [ProducesResponseType(200)]
        [ProducesResponseType(typeof(String), 400)]
        [HttpPost]
        public IActionResult Regist([FromBody] WebOrgRsvNavi data)
        {
           String message = null ;
           int ret = webOrgRsvDao.Regist(data,ref message);

            // データ件数が0件の場合
            if (message != null)
            {
                return BadRequest(message);
            }

            return Ok(ret);
        }

        /// <summary>
        /// web予約時登録された予約番号で予約情報チェック（受付されてない保留状態の予約情報かをチェック）
        /// </summary>
        /// <param name="rsvNo">web予約時登録されているHains予約番号</param>
        /// <param name="orgCd1">受診団体コード1</param>
        /// <param name="orgCd2">受診団体コード2</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpPost("validation")]
        public IActionResult GetConsultCheck(int rsvNo, string orgCd1, string orgCd2)
        {
            dynamic data = webOrgRsvDao.SelectConsultCheck(rsvNo, orgCd1, orgCd2);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }
    }
}
