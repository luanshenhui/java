using Hainsi.Entity;
using Hainsi.Entity.Model.Judgement;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using Hainsi.Common.Constants;
using System.Linq;
using Newtonsoft.Json.Linq;
using Microsoft.AspNetCore.Http;
using System;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// Judgementコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/judgements")]
    public class JudgementController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly JudgementDao judgementDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="judgementDao">データアクセスオブジェクト</param>
        public JudgementController(JudgementDao judgementDao)
        {
            this.judgementDao = judgementDao;
        }

        /// <summary>
        /// 指定予約番号の判定入力状態を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/judgements/status/auto")]
        public IActionResult GetJudgementStatusAuto(long rsvNo)
        {
            string ret = judgementDao.SelectJudgementStatusAuto(rsvNo);

            return Ok(ret);
        }

        /// <summary>
        /// 指定予約番号の判定入力状態を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/judgements/status/manual")]
        public IActionResult GetJudgementStatusManual(long rsvNo)
        {
            string ret = judgementDao.SelectJudgementStatusManual(rsvNo);

            return Ok(ret);
        }

        /// <summary>
        /// 予約番号の判定結果情報を取得する
        /// </summary>
        /// <param name="rsvNo"></param>
        /// <returns></returns>
        [HttpGet("~/api/v1/consultations/{rsvNo}/inquiries/judgements/results")]
        [ProducesResponseType(typeof(List<GetInquiryJudRslListModel>), 200)]
        [ProducesResponseType(404)]
        public IActionResult GetInquiryJudRslList(string rsvNo)
        {
            List<dynamic> list = judgementDao.SelectInquiryJudRslList(rsvNo);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }
		
        /// <summary>
        /// 判定結果テーブルレコードを更新する
        /// </summary>
        /// <param name="data"></param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("insertjudrslwithupdate")]
        public IActionResult InsertJudRslWithUpdate([FromBody] JToken data)
        {
            // IPアドレス
            string ipAddress = HttpContext.Connection.RemoteIpAddress.ToString();

            // 更新User
            string updUser = HttpContext.Session.GetString("userId");
            updUser = "HAINS$";
            // 予約番号
            List<long> rsvNo = new List<long>();

            // 判定分類コード
            List<string> judClassCd = new List<string>();

            // 判定コード
            List<string> judCd = new List<string>();

            // 判定コメントコード
            List<string> judCmtCd = new List<string>();

            // セットデータのチェック
            List<JToken> updJudData = data["updJudData"].ToObject<List<JToken>>();

            //各配列値の更新処理
            foreach (var rec in updJudData)
            {
                rsvNo.Add(Convert.ToInt32(rec["rsvno"]));
                judClassCd.Add(Convert.ToString(rec["judclasscd"]));
                judCd.Add(Convert.ToString(rec["judcd"]));
                judCmtCd.Add(Convert.ToString(rec["judcmtcd"]));
            }
            
            // 判定結果テーブルレコードを更新する
            Insert ret = judgementDao.InsertJudRslWithUpdate(rsvNo, judClassCd, judCd, judCmtCd, updUser, "1");

            // 更新されていなければ409
            if (ret == Insert.Duplicate)
            {
                return StatusCode(StatusCodes.Status409Conflict);
            }

            return NoContent();
        }
    }
}
