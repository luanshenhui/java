using Microsoft.AspNetCore.Mvc;
using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.Entity.Model;
using Hainsi.Entity.Model.ExternalDeviceResult;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace Hainsi.Controllers
{

    /// <summary>
    /// 計測器検査結果コントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/externaldeviceresults")]
    public class ExternalDeviceResultController : Controller
    {

        /// <summary>
        /// 計測器検査結果データアクセスオブジェクト
        /// </summary>
        readonly ExternalDeviceResultDao externalDeviceResultDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="externalDeviceResultDao">計測器検査結果データアクセスオブジェクト</param>
        public ExternalDeviceResultController(ExternalDeviceResultDao externalDeviceResultDao)
        {
            this.externalDeviceResultDao = externalDeviceResultDao;
        }

        /// <summary>
        /// 計測器検査結果を登録する
        /// </summary>
        /// <param name="transId">トランザクションID</param>
        /// <param name="data">管理端末情報</param>
        [HttpPost("{transId}")]
        //[ProducesResponseType(typeof(WorkStation), 201)]
        //[ProducesResponseType(typeof(string), 409)]
        //[ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult InsertExternalDeviceResult(int transId, [FromForm]InsertExternalDeviceResultModel data)
        {
            //// バリデーション
            //List<string> messages = externalDeviceResultDao.Validate(data);
            //// バリデーションエラー時は400(Bad Request)を返す
            //if (messages.Count > 0)
            //{
            //    return BadRequest(messages);
            //}

            // IPアドレス取得
            string ipAddress = HttpContext.Connection.RemoteIpAddress.ToString();

            // 登録処理
            Insert result = externalDeviceResultDao.RegistExternalDeviceResult("INS", ipAddress, transId, data);

            // 主キーが重複していたら409(Conflict)を返す
            if (result == Insert.Duplicate)
            {
                return Conflict(new { errors = new[] { "指定されたトランザクションIDで結果は書き込まれています" } });
            }

            //// 正常に作成された場合はIPアドレスをキーに個人情報を読む
            //dynamic workStation = externalDeviceResultDao.SelectWorkStation(ipAddress);

            return CreatedAtRoute("GetByTransId", new { transId });

            // 正常時は204(No Content)を返す
            // return NoContent();


        }

        /// <summary>
        /// 新規のトランサクションIDを取得する
        /// </summary>
        [ProducesResponseType(typeof(GetTransactionIdModel), 200)]
        [ProducesResponseType(404)]
        [HttpGet("transactionid")]
        public IActionResult GetTransactionId()
        {
            dynamic data = externalDeviceResultDao.SelectTransactionId();

            // 取得できなかった場合404
            if (data == null)
            {
                NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定の計測器検査結果を取得する
        /// </summary>
        /// <param name="transId">トランザクションID</param>
        [ProducesResponseType(typeof(GetExternalDeviceResultModel), 200)]
        [ProducesResponseType(404)]
        [HttpGet("{transId}", Name = "GetByTransId")]
        public IActionResult GetExternalDeviceResult(int transId)
        {
            dynamic data = externalDeviceResultDao.SelectExternalDeviceResult(transId);

            // 取得できなかった場合404
            if (data == null)
            {
                return NotFound();
            }

            // JSONをデシリアライズする
            var results = JsonConvert.DeserializeObject(data.RESULTS);

            return Ok(new { results });
        }
    }
}
