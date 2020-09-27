using Hainsi.Common.Constants;
using Hainsi.Entity;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// ユーザデータコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/users")]
    public class HainsUserController : Controller
    {
        /// <summary>
        /// ユーザデータアクセスオブジェクト
        /// </summary>
        readonly HainsUserDao hainsUserDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="hainsUserDao">ユーザデータアクセスオブジェクト</param>
        public HainsUserController(HainsUserDao hainsUserDao)
        {
            this.hainsUserDao = hainsUserDao;
        }

        /// <summary>
        /// ユーザIDとパスワードをチェックする
        /// </summary>
        /// <param name="data">入力データ</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpPost("login")]
        public IActionResult CheckIDandPassword([FromBody] JToken data)
        {
            dynamic result = hainsUserDao.CheckIDandPassword(data);

            // データ件数が0件の場合
            if (result == null)
            {
                return NotFound();
            }

            return Ok(result);
        }

        /// <summary>
        /// ユーザテーブルレコードを登録する
        /// </summary>
        /// <param name="data">ユーザ情報</param>
        /// <response code="201">成功</response>
        /// <response code="409">リクエスト不正</response>
        [HttpPost]
        public IActionResult Insert([FromBody] JToken data)
        {
            // ユーザテーブルレコードを登録
            Insert result = hainsUserDao.RegistHainsUser("INS", data);

            // 重複した時は409を返す
            if (result == Common.Constants.Insert.Duplicate)
            {
                return this.Conflict("指定のユーザＩＤは既に登録されています。");
            }

            // ユーザＩＤ
            string userId = Convert.ToString(data["userid"]);

            // ユーザテーブルレコード
            var user = data.ToObject<Dictionary<string, JToken>>();

            // 201を返す
            return CreatedAtRoute("GetByUserId", new { userId }, user);
        }

        /// <summary>
        /// ユーザテーブルレコードを更新する
        /// </summary>
        /// <param name="userId">ユーザＩＤ</param>
        /// <param name="data">ユーザ情報</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("{userId}")]
        public IActionResult Update(string userId, [FromBody] JToken data)
        {
            // ユーザＩＤ
            data["userid"] = userId;

            // ユーザテーブルレコードを更新
            Insert result = hainsUserDao.RegistHainsUser("UPD", data);

            if (result != Common.Constants.Insert.Normal)
            {
                return BadRequest("入力されたユーザＩＤは存在しません。");
            }

            return NoContent();
        }

        /// <summary>
        /// ユーザテーブルのパスワードを更新する
        /// </summary>
        /// <param name="userId">ユーザＩＤ</param>
        /// <param name="data">ユーザ情報</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("{userId}/password")]
        public IActionResult AlterPassword(string userId, [FromBody] JToken data)
        {
            // ユーザＩＤ
            data["userid"] = userId;

            // ユーザテーブルのパスワードを更新
            Insert result = hainsUserDao.RegistHainsUser("PWD", data);

            if (result != Common.Constants.Insert.Normal)
            {
                return BadRequest("入力されたユーザＩＤは存在しません。");
            }

            return NoContent();
        }


        /// <summary>
        /// ユーザ情報読み込み
        /// </summary>
        /// <param name="userid">ユーザID</param>
        /// <param name="passDecode">TRUE:デコードしてパスワードを返す</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{userid}",Name = "GetByUserId")]
        public IActionResult GetHainsUser(string userid, bool passDecode)
        {
            dynamic data = hainsUserDao.SelectHainsUser(userid, passDecode);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 氏名、カナ氏名、英字氏名を更新する（カルテ利用者連携用）
        /// </summary>
        /// <param name="userId">ユーザID</param>
        /// <param name="userName">利用者漢字氏名</param>
        /// <param name="kName">利用者カナ氏名</param>
        /// <param name="eName">利用者英字氏名</param>
        /// <param name="windowsLoginId">WindowsログインID</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("name")]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult MergeUserName(string userId, string userName, string kName, string eName, string windowsLoginId)
        {
            // 氏名、カナ氏名、英字氏名、WindowsログインIDを更新する
            int result = hainsUserDao.MergeUserName(
                userId, userName, kName, eName, windowsLoginId);

            if (result == 0)
            {
                return BadRequest(new List<string>()
                    { "利用者情報の登録処理に失敗しました。" });
            }

            // 正常時は204(No Content)を返す
            return NoContent();
        }
    }
}
