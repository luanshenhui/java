using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.Entity.Model.Group;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;

namespace Hainsi.Controllers
{
    /// <summary>
    /// グループコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/groups")]
    public class GroupController : Controller
    {
        /// <summary>
        /// グループデータアクセスオブジェクト
        /// </summary>
        readonly GrpDao grpDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="grpDao">グループデータアクセスオブジェクト</param>
        public GroupController(GrpDao grpDao)
        {
            this.grpDao = grpDao;
        }

        /// <summary>
        /// グループ一覧を取得する
        /// </summary>
        /// <param name="keyword">検索キーワード</param>
        /// <param name="page">ページ番号</param>
        /// <param name="limit">ページ当たりの最大件数</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult Get(string keyword, string page, string limit)
        {
            PartialDataSet ds = grpDao.SelectGrp_p(new NameValueCollection
            {
                { "keyword", keyword },
                { "page", page },
                { "limit", limit }
            });

            // データ件数が0件の場合
            if (ds.Data.Count == 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// グループ情報取得
        /// </summary>
        /// <param name="id">グループコード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{id}", Name = "GetGroupById")]
        public IActionResult GetById(string id)
        {
            // グループレコードの読み込み
            dynamic group = grpDao.SelectGrp_P(id);
            if (group == null)
            {
                return NotFound();
            }

            // グループ内検査項目の読み込み
            List<dynamic> item = grpDao.SelectGrp_I_ItemList_AddCaption(id);

            return Ok(new { group, item });
        }

        /// <summary>
        /// 新規登録
        /// </summary>
        /// <param name="data">グループ情報</param>
        /// <response code="201">成功</response>
        /// <response code="400">リクエスト不正</response>
        /// <response code="409">リクエスト不正</response>
        [HttpPost]
        public IActionResult Create([FromBody] JToken data)
        {
            // 入力データバリデーション
            List<string> messages = grpDao.Validate(data);
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(new { errors = messages });
            }

            // 新規レコード挿入
            Insert ret = grpDao.RegistGrp_All("INS", data);
            if (ret == Insert.Duplicate)
            {
                return StatusCode(StatusCodes.Status409Conflict);
            }

            return CreatedAtRoute("GetGroupById", new { id = data["grpcd"] }, data);
        }

        /// <summary>
        /// 更新処理
        /// </summary>
        /// <param name="id">グループコード</param>
        /// <param name="data">グループ情報</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        /// <response code="409">リクエスト不正</response>
        [HttpPut("{id}")]
        public IActionResult Update(string id, [FromBody]JToken data)
        {
            // グループコードはURLで指定されたものを使う
            data["grpcd"] = id;

            // 入力データバリデーション
            List<string> messages = grpDao.Validate(data);
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(new { errors = messages });
            }

            Insert ret = grpDao.RegistGrp_All("UPD", data);

            // 更新されていなければ409
            if (ret == Insert.Duplicate)
            {
                return StatusCode(StatusCodes.Status409Conflict);
            }

            return NoContent();
        }

        /// <summary>
        /// 削除処理
        /// </summary>
        /// <param name="id">グループコード</param>
        /// <response code="204">成功</response>
        [HttpDelete("{id}")]
        public IActionResult Delete(string id)
        {
            bool ret = grpDao.DeleteGrp_p(id);

            //削除対象がなければ404
            if (!ret)
            {
                return NotFound();
            }

            return NoContent();
        }

        /// <summary>
        /// #ToDo 結果グループドロップダウン用（暫定）
        /// </summary>
        /// <returns></returns>
        [HttpGet, Route("api/[controller]/result")]
        public IActionResult GetDropDown()
        {
            var data = grpDao.SelectGrp_IList_GrpDiv(GrpDiv.I, omitSystemGrp: true);
            var ds = new PartialDataSet(data);

            if (ds.TotalCount == 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// グループ内の全検査項目および初期値を取得する
        /// </summary>
        /// <param name="grpCd">グループコード</param>
        /// <param name="cslDate">受診日</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{grpCd}/itemsandresults")]
        public IActionResult GetGrpIItemDefResultList(string grpCd, DateTime cslDate)
        {
            // 結果初期値を設定する
            List<dynamic> items = grpDao.SelectGrp_I_ItemDefResultList(grpCd, cslDate);

            // データ件数が0件の場合
            if (items == null || items.Count <= 0)
            {
                return NotFound();

            }
            return Ok(items);
        }

        /// <summary>
        /// グループ内の全検査項目を取得する（検査項目）
        /// </summary>
        /// <param name="grpCd">グループコード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{grpCd}/items")]
        public IActionResult GetGrpIItemList(string grpCd)
        {
            // 検査項目読み込み
            List<dynamic> items = grpDao.SelectGrp_I_ItemList(grpCd);

            // データ件数が0件の場合
            if (items == null || items.Count <= 0)
            {
                return NotFound();

            }
            return Ok(items);

        }

        /// <summary>
        /// 検索条件を満たすグループの一覧を取得する
        /// </summary>
        /// <param name="grpDiv">検索グループ区分</param>
        /// <param name="classCd">検査分類コード</param>
        /// <param name="searchChar">ガイド検索用文字列</param>
        /// <param name="noDataFound">true:検査項目なしでも索引する</param>
        /// <param name="omitSystemGrp">true:システムで使用するグループは除外する</param>
        /// <param name="page">ページ番号</param>
        /// <param name="limit">ページ当たりの行数</param>
        [HttpGet("~/api/v1/groupdivisions/{grpDiv}/groups")]
        [ProducesResponseType(typeof(List<GroupList>), 200)]
        [ProducesResponseType(404)]
        public IActionResult GetGrpIListGrpDiv(GrpDiv grpDiv, string classCd = null, string searchChar = null, bool noDataFound = false, bool omitSystemGrp = true, int page = 0, int limit = 20)
        {
            List<dynamic> items = grpDao.SelectGrp_IList_GrpDiv(grpDiv, classCd, searchChar, noDataFound, omitSystemGrp);

            // データ件数が0件の場合
            if (items == null || items.Count <= 0)
            {
                return NotFound();
            }

            // 本ページネーションは暫定処理
            // 本来はSQLでページネーションするようにしなければならない #ToDO
            if (page == 0)
            {
                return Ok(items);
            }

            return Ok(new {
                totalCount = items.Count,
                data = items.Skip((page - 1) * limit).Take(limit)
            });
        }

        /// <summary>
        /// 検索条件を満たすグループの基本情報を取得する
        /// </summary>
        /// <param name="grpCd">グループコード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{grpCd}")]
        public IActionResult GetGrpP(string grpCd)
        {
            dynamic items = grpDao.SelectGrp_P(grpCd);

            // データ件数が0件の場合
            if (items == null)
            {
                return NotFound();

            }
            return Ok(items);
        }
    }
}
