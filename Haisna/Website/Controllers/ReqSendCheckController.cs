using Hainsi.Common.Constants;
using Hainsi.Entity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Hainsi.Controllers
{
    /// <summary>
    /// ReqSendCheckコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/consultations")]
    public class ReqSendCheckController : Controller
    {
        /// <summary>
        /// ReqSendCheckアクセスオブジェクト
        /// </summary>
        readonly ReqSendCheckDao reqSendCheckDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="reqSendCheckDao">ReqSendCheckDaoアクセスオブジェクト</param>
        public ReqSendCheckController(ReqSendCheckDao reqSendCheckDao)
        {
            this.reqSendCheckDao = reqSendCheckDao;
        }

        /// <summary>
        /// 依頼状発送確認テーブルレコードを削除する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="prtDiv">様式分類</param>
        /// <param name="seq">SEQ</param>
        /// <response code="204">成功</response>
        /// <response code="404">データなし</response>
        [HttpDelete("~/api/v1/consultations/{rsvNo}/followups/{judClassCd}/senthistories/{prtDiv}/{seq}")]
        public IActionResult DeleteReqSendDate(int rsvNo, int judClassCd, int prtDiv, int seq)
        {
            //フォローアップ情報更新処理
            bool ret = reqSendCheckDao.DeleteReqSendDate(rsvNo, judClassCd, prtDiv, seq);

            // 削除対象が存在しなければ404を返す
            if (ret == false)
            {
                return NotFound();
            }

            return NoContent();
        }

        /// <summary>
        /// 依頼状発送確認を更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="prtDiv">様式分類</param>
        /// <param name="seq">SEQ</param>
        /// <param name="prtSendDate">依頼状発送日</param>
        /// <response code="204">成功</response>
        /// <response code="404">データなし</response>
        [HttpPut("~/api/v1/consultations/{rsvNo}/followups/{judClassCd}/senthistories/{prtDiv}/{seq}")]
        public IActionResult UpdateReqSendDate(int rsvNo, int judClassCd, int prtDiv, int seq, DateTime prtSendDate)
        {
            // 更新User
            string sendUser = HttpContext.Session.GetString("userId");

            // 依頼状発送確認を更新
            Insert ret = reqSendCheckDao.UpdateReqSendDate(rsvNo, judClassCd, prtDiv, seq, sendUser, prtSendDate);

            // 更新対象が存在しなければ404を返す
            if (ret == Insert.Error)
            {
                return NotFound();
            }

            return NoContent();
        }

        /// <summary>
        /// 依頼状発送情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="prtDiv">様式分類</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/followups/{judClassCd}/senthistories")]
        public IActionResult GetAllSendDate(int rsvNo, int judClassCd, int prtDiv)
        {
            List<dynamic> items = reqSendCheckDao.SelectAll_SendDate(rsvNo, judClassCd, prtDiv);

            // データ件数が0件の場合
            if (items == null || items.Count <= 0)
            {
                return NotFound();
            }

            var data = new Dictionary<string, dynamic>
            {
                { "senditems", items},
                { "count", items.Count}
            };

            return Ok(data);
        }
    }
}
