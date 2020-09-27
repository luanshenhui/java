using Hainsi.Entity;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using Hainsi.Common.Constants;
using Hainsi.Entity.Model.Bbs;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// 掲示板コントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/bbs")]
    public class BbsController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly BbsDao bbsDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="bbsDao">データアクセスオブジェクト</param>
        public BbsController(BbsDao bbsDao)
        {
            this.bbsDao = bbsDao;
        }

        /// <summary>
        /// 掲示板テーブルの取り消し
        /// </summary>
        /// <param name="bbsKey">キー</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpDelete("{bbsKey}")]
        public IActionResult DeleteBbs(string bbsKey)
        {
            bbsDao.DeleteBbs(bbsKey);
            return NoContent();                
        }

        /// <summary>
        /// 今日のコメントを取得する
        /// </summary>
        /// <param name="today">今日の日付</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetAllBbs(string today)
        {
            List<dynamic> data = bbsDao.SelectAllBbs(today);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound(data);
            }

            return Ok(data);
        }

        /// <summary>
        /// コメントの登録
        /// </summary>
        /// <param name="data"></param>
        /// <response code="204">成功</response>
        [HttpPost]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 422)]
        public IActionResult Create([FromBody] Bbs data)
        {

            // 入力データバリデーション
            IList<string> messages = bbsDao.CheckValue(
                data.StrDate,
                data.EndDate,
                data.Handle,
                data.Title,
                data.Message);
            if ((messages != null) && (messages.Count > 0))
            {
                return this.UnprocessableEntity(messages);
            }

            // 更新ユーザー
            data.UpdUser = HttpContext.Session.GetString("userId");

            // 登録実行
            bbsDao.InsertBbs(data);

            // 201を返す
            return NoContent();
        }
    }
}
