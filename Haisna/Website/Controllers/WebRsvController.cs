using Hainsi.Entity;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// WebRsvコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/webreserves")]
    public class WebRsvController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly WebRsvDao webRsvDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="webRsvDao">データアクセスオブジェクト</param>
        public WebRsvController(WebRsvDao webRsvDao)
        {
            this.webRsvDao = webRsvDao;
        }

        /// <summary>
        /// 指定受診日、webNoのweb予約情報を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="webNo">webNo.</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{cslDate}/{webNo}")]
        public IActionResult GetWebRsv(DateTime cslDate, int webNo)
        {
            dynamic data = webRsvDao.SelectWebRsv(cslDate, webNo);

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
        /// <param name="opMode">処理モード(1:申込日で検索、2:予約処理日で検索)</param>
        /// <param name="regFlg">本登録フラグ(0:指定なし、1:未登録者、2:編集済み受診者)</param>
        /// <param name="moushiKbn">申込区分（0：すべて　1:新規　2:キャンセル）</param>
        /// <param name="order">出力順(1:受診日順、2:個人ID順)</param>
        /// <param name="startPos">取得開始位置</param>
        /// <param name="getCount">取得件数(0:全件)</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetWebRsvList(DateTime strCslDate, DateTime endCslDate, string key,
            DateTime strOpDate, DateTime endOpDate, int opMode, int regFlg,
            int moushiKbn, int order, int startPos = 1, int getCount = 0)
        {
            List<dynamic> list = webRsvDao.SelectWebRsvList(strCslDate, endCslDate, key, strOpDate, 
                endOpDate, opMode, regFlg, moushiKbn, order, startPos, getCount);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }
    }
}
