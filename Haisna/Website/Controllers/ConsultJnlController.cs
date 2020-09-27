using Hainsi.Entity;
using Hainsi.Entity.Model.ConsultJnl;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 受診歴送信ジャーナルコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/consultjournals")]
    public class ConsultJnlController : Controller
    {
        /// <summary>
        /// 受診歴送信ジャーナルデータアクセスオブジェクト
        /// </summary>
        readonly ConsultJnlDao consultJnlDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="consultJnlDao">受診歴送信ジャーナルデータアクセスオブジェクト</param>
        public ConsultJnlController(ConsultJnlDao consultJnlDao)
        {
            this.consultJnlDao = consultJnlDao;
        }

        /// <summary>
        /// カルテ／医事に送信する受診歴送信ジャーナルを取得する
        /// </summary>
        /// <param name="senddiv">送信区分</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetSendData(int[] senddiv)
        {
            // カルテ／医事に送信する受診歴送信ジャーナルを取得する
            List<dynamic> list = consultJnlDao.SelectSendData(senddiv);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 送信電文の連番を取得する
        /// </summary>
        /// <response code="200">成功</response>
        [HttpGet("seqno")]
        public IActionResult GetSeqNo()
        {
            // 送信電文の連番を取得する
            return Ok(consultJnlDao.SelectSeqNo());
        }

        /// <summary>
        /// 受診歴送信ジャーナルの送信区分を更新する
        /// </summary>
        /// <param name="data">更新対象データ</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("senddiv")]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult UpdateSendDiv([FromBody] UpdateConsultJnl data)
        {
            // 受診歴送信ジャーナルの送信区分を更新する
            int ret = consultJnlDao.UpdateSendDiv(data);

            if (ret == 0)
            {
                return BadRequest(new List<string>()
                    { "指定された処理日時、予約番号のレコードが存在しないため、受診歴送信ジャーナルの更新処理に失敗しました。" });
            }

            // 正常時は204(No Content)を返す
            return NoContent();
        }
    }
}
