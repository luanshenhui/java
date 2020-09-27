using Hainsi.Entity;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 個人プロファイル取得ジャーナルコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/personjournals")]
    public class PersonJnlController : Controller
    {
        /// <summary>
        /// 個人プロファイル取得ジャーナルデータアクセスオブジェクト
        /// </summary>
        readonly PersonJnlDao personJnlDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="personJnlDao">個人プロファイル取得ジャーナルデータアクセスオブジェクト</param>
        public PersonJnlController(PersonJnlDao personJnlDao)
        {
            this.personJnlDao = personJnlDao;
        }

        /// <summary>
        /// 個人プロファイル取得ジャーナルを取得する
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetData()
        {
            // 個人プロファイル取得ジャーナルを取得する
            List<dynamic> list = personJnlDao.SelectData();

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
            return Ok(personJnlDao.SelectSeqNo());
        }

        /// <summary>
        /// 個人プロファイル取得ジャーナルのレコードを削除する
        /// </summary>
        /// <param name="tskDate">処理日時</param>
        /// <param name="perId">個人ID</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpDelete]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult DeleteData(DateTime tskDate, string perId)
        {
            // 個人プロファイル取得ジャーナルのレコードを削除する
            int ret = personJnlDao.DeleteData(tskDate, perId);

            if (ret == 0)
            {
                return BadRequest(new List<string>()
                    { "指定された処理日時、個人IDのレコードが存在しないため、個人プロファイル取得ジャーナルの削除処理に失敗しました。" });
            }

            // 正常時は204(No Content)を返す
            return NoContent();
        }
    }
}
