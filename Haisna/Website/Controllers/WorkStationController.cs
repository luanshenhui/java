using Microsoft.AspNetCore.Mvc;
using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.Entity.Model.WorkStation;
using System.Collections.Generic;
using System;
using Microsoft.AspNetCore.Http.Features;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 端末管理データコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/workstations")]
    public class WorkStationController : Controller
    {
        /// <summary>
        /// 端末管理データアクセスオブジェクト
        /// </summary>
        readonly WorkStationDao workStationDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="workStationDao">端末管理データアクセスオブジェクト</param>
        public WorkStationController(WorkStationDao workStationDao)
        {
            this.workStationDao = workStationDao;
        }

        /// <summary>
        /// 端末情報を読み込む
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("me")]
        public IActionResult GetWorkStation()
        {
            string ipAddress = HttpContext.Features.Get<IHttpConnectionFeature>()?.RemoteIpAddress?.ToString();

            dynamic data = workStationDao.SelectWorkStation(ipAddress);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 管理端末一覧を取得する
        /// </summary>
        /// <returns>管理端末一覧</returns>
        [HttpGet]
        [ProducesResponseType(typeof(List<SelectWorkStation>), 200)]
        [ProducesResponseType(404)]
        public IActionResult GetWorkStationList()
        {
            List<dynamic> data = workStationDao.SelectWorkStationList();

            if (data == null || data.Count == 0)
            {
                return NotFound();
            }

            return Ok(new PartialDataSet(data));
        }

        /// <summary>
        /// 指定した管理端末情報を取得する
        /// </summary>
        /// <param name="ipAddress">IPアドレス</param>
        /// <returns>管理端末情報</returns>
        [HttpGet("{ipAddress}", Name = "GetByIpAddress")]
        [ProducesResponseType(typeof(WorkStation), 200)]
        [ProducesResponseType(404)]
        public IActionResult GetWorkStation(string ipAddress)
        {
            dynamic data = workStationDao.SelectWorkStation(ipAddress);

            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 管理端末情報を登録する
        /// </summary>
        /// <param name="data">管理端末情報</param>
        [HttpPost]
        [ProducesResponseType(typeof(WorkStation), 201)]
        [ProducesResponseType(typeof(string), 409)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult InsertWorkStation([FromBody] RegisterWorkStation data)
        {
            // バリデーション
            List<string> messages = workStationDao.ValidateForMntWorkStation(data);
            // バリデーションエラー時は400(Bad Request)を返す
            if (messages.Count > 0)
            {
                return BadRequest(messages);
            }

            string ipAddress = data.IpAddress;

            // 登録処理
            Insert result = workStationDao.RegistWorkStation("INS", data);

            // 主キーが重複していたら409(Conflict)を返す
            if (result == Insert.Duplicate)
            {
                return Conflict(new { errors = new[] { "指定のIPアドレスは既に登録されています。" } });
            }

            // 正常に作成された場合はIPアドレスをキーに個人情報を読む
            dynamic workStation = workStationDao.SelectWorkStation(ipAddress);

            return CreatedAtRoute("GetByIpAddress", new { ipAddress }, workStation);
        }

        /// <summary>
        /// 指定IPアドレスの端末情報を更新する
        /// </summary>
        /// <param name="ipAddress">IPアドレス</param>
        /// <param name="data">管理端末情報</param>
        [HttpPut("{ipAddress}")]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult UpdateWorkStation(string ipAddress, [FromBody] RegisterWorkStation data)
        {
            // バリデーション
            List<string> messages = workStationDao.ValidateForMntWorkStation(data);
            // バリデーションエラー時は400(Bad Request)を返す
            if (messages.Count > 0)
            {
                return BadRequest(messages);
            }

            // 管理端末情報を更新する
            Insert result = workStationDao.RegistWorkStation("UPD", data);

            // 正常時は204(No Content)を返す
            return NoContent();
        }

        /// <summary>
        /// 指定IPアドレスの端末情報を削除する
        /// </summary>
        /// <param name="ipAddress">IPアドレス</param>
        [HttpDelete("{ipAddress}")]
        [ProducesResponseType(204)]
        public IActionResult DeleteWorkStation(string ipAddress)
        {
            // 管理端末情報を削除する
            workStationDao.DeleteWorkStation(ipAddress);

            // 正常時は204(No Content)を返す
            return NoContent();
        }

        /// <summary>
        ///  端末通過情報の取得
        /// </summary>
        /// <param name="clsDate">受診日</param>
        /// <param name="cntlNo">管理番号</param>
        /// <param name="dayId">当日ＩＤ</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{cntlNo}/passedinfomations")]
        public IActionResult GetPassedInfo(DateTime clsDate, int cntlNo, int dayId)
        {
            string ipAddress = HttpContext.Connection.RemoteIpAddress.ToString();

            List<dynamic> data = workStationDao.SelectPassedInfo(clsDate, cntlNo, dayId, ipAddress);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

    }
}
