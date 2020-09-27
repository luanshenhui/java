using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.Entity.Model.PerResult;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Hainsi.Controllers
{
    /// <summary>
    /// PerResultコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/perresults")]
    public class PerResultController : Controller
    {
        /// <summary>
        /// PerResultアクセスオブジェクト
        /// </summary>
        readonly PerResultDao perResultDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="perResultDao">PerResultDaoアクセスオブジェクト</param>
        public PerResultController(PerResultDao perResultDao)
        {
            this.perResultDao = perResultDao;
        }

        /// <summary>
        /// 個人検査項目情報を取得する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="getSeqMode"></param>
        /// <param name="allDataMode"></param>
        [HttpGet("~/api/v1/people/{perId}/results")]
        public IActionResult GetPerResultList(string perId, string grpCd, int? getSeqMode = 0, int? allDataMode = 0)
        {
            List<dynamic> items = null;
            if (!string.IsNullOrEmpty(grpCd))
            {
                items = perResultDao.SelectPerResultGrpList(perId, grpCd, getSeqMode, allDataMode);
            }
            else
            {
                // grpCdが空の場合
                items = perResultDao.SelectPerResultList(perId);
            }

            // データ件数が0件の場合
            if (items == null || items.Count <= 0)
            {
                return NotFound();
            }

            var data = new Dictionary<string, dynamic>
            {
                { "allcount", items.Count},
                { "perresultitem", items}
            };

            return Ok(data);
        }

        /// <summary>
        /// 個人検査結果テーブルを登録または更新する
        /// </summary>
        /// <param name="perResult">個人検査結果テーブル</param>
        [ProducesResponseType(204)]
        [HttpPost("~/api/v1/people/{perId}/results")]
        public IActionResult MergePerResult([FromBody] PerResult perResult)
        {
            // 個人検査結果テーブルを登録
            Insert ret = perResultDao.MergePerResult(perResult);

            return NoContent();
        }

        /// <summary>
        /// 個人検査結果テーブルを更新する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="data">個人検査結果
        /// itemcd     検査項目コード
        /// suffix     サフィックス
        /// result     検査結果
        /// ispdate    検査日
        /// </param>
        /// <response code="204">成功</response>
        [HttpPut("~/api/v1/people/{perId}/results")]
        public IActionResult UpdatePerResult(string perId, [FromBody] PerResult data)
        {
            //個人ＩＤ
            data.PerId = perId;

            //個人検査結果テーブルを更新
            perResultDao.UpdatePerResult(data);

            return NoContent();
        }

        /// <summary>
        /// 個人検査結果テーブルを削除する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <response code="204">成功</response>
        [HttpDelete("~/api/v1/people/{perId}/results")]
        public IActionResult DeletePerResult(string perId, string itemCd, string suffix)
        {

            String[] arrItemCd = new String[0];

            String[] arrSuffix = new String[0];

            if (itemCd != null) arrItemCd = Newtonsoft.Json.JsonConvert.DeserializeObject<String[]>(itemCd);
            if (itemCd != null) arrSuffix = Newtonsoft.Json.JsonConvert.DeserializeObject<String[]>(suffix);

            bool ret = perResultDao.DeletePerResult(perId, arrItemCd, arrSuffix);
            return NoContent();
        }
    }
}
