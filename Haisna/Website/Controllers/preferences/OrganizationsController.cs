using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Http;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 団体アクセス用WebAPIコントローラークラス
    /// </summary>
    //[Authorize]
    [Route("api/v1/organizations")]
    public class OrganizationsController : Controller
    {
        /// <summary>
        /// 団体データアクセスオブジェクト
        /// </summary>
        readonly OrganizationDao organizationDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="organizationDao">団体データアクセスオブジェクト</param>
        public OrganizationsController(OrganizationDao organizationDao)
        {
            this.organizationDao = organizationDao;
        }

        /// <summary>
        /// 一覧を取得する
        /// </summary>
        /// <param name="keyword">検索キーワード</param>
        /// <param name="page">ページ番号</param>
        /// <param name="limit">ページ当たりの最大件数</param>
        /// <param name="csCd">コースコード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetOrgList(string keyword, int page = 1, int limit = 20, string csCd = null)
        {
            // 検索キーを空白で分割する
            string[] keys = Util.SplitBySpase(keyword);

            // 検索条件を満たしかつ指定開始位置、件数分のレコードを取得
            int startPos = (page - 1) * limit;
            PartialDataSet ds = organizationDao.SelectOrgList(keys, startPos, limit, csCd);

            // データ件数が0件の場合
            if (ds.TotalCount == 0)
            {
                return NotFound(ds);
            }

            return Ok(ds);
        }

        /// <summary>
        /// 指定した団体情報を取得します。
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <returns>団体情報</returns>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{orgCd1}/{orgCd2}", Name = "GetOrgById")]
        public IActionResult GetOrg(string orgCd1, string orgCd2)
        {
            // 団体情報の読み込み
            dynamic org = organizationDao.SelectOrg_Lukes(orgCd1, orgCd2);
            if (org == null)
            {
                return NotFound();
            }

            // 団体住所情報の読み込み
            IList<dynamic> orgAddr = organizationDao.SelectOrgAddrList(orgCd1, orgCd2);

            return Ok(new { org, orgAddr });
        }

        /// <summary>
        /// 団体情報更新
        /// </summary>
        /// <param name="orgCd1"></param>
        /// <param name="orgCd2"></param>
        /// <param name="data"></param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        /// <response code="422">処理できないエンティティ</response>
        [HttpPut("{orgCd1}/{orgCd2}")]
        public IActionResult Update(string orgCd1, string orgCd2, [FromBody] JToken data)
        {
            // 入力データバリデーション
            IList<string> messages = organizationDao.Validate(data);
            if ((messages != null) && (messages.Count > 0))
            {
                return this.UnprocessableEntity(messages);
            }

            // 更新実行
            Update result = organizationDao.Update(orgCd1, orgCd2, data);

            // 更新対象が存在しなければ404を返す
            if (result == Common.Constants.Update.NotFound)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 団体情報追加
        /// </summary>
        /// <param name="data"></param>
        /// <response code="201">成功</response>
        /// <response code="409">データなし</response>
        /// <response code="422">処理できないエンティティ</response>
        [HttpPost]
        public IActionResult Create([FromBody] JToken data)
        {
            // 入力データバリデーション
            IList<string> messages = organizationDao.Validate(data);
            if ((messages != null) && (messages.Count > 0))
            {
                return this.UnprocessableEntity(messages);
            }

            // 登録実行
            Insert result = organizationDao.Create(data);

            // 重複した時は409を返す
            if (result == Insert.Duplicate)
            {
                return this.Conflict("指定の団体コードは既に登録されています。");
            }

            var datalist = data.ToObject<Dictionary<string, JToken>>();

            string orgCd1 = Convert.ToString(datalist["org"]["orgcd1"]).Trim();
            string orgCd2 = Convert.ToString(datalist["org"]["orgcd2"]).Trim();

            // 201を返す
            return CreatedAtRoute("GetOrgById", new { orgCd1, orgCd2 }, datalist);
        }

        /// <summary>
        /// 団体情報削除
        /// </summary>
        /// <param name="orgCd1"></param>
        /// <param name="orgCd2"></param>
        /// <response code="204">成功</response>
        [HttpDelete("{orgCd1}/{orgCd2}")]
        public IActionResult DeleteOrg(string orgCd1, string orgCd2)
        {
            var result = organizationDao.DeleteOrg(orgCd1, orgCd2);
            return NoContent();
        }

        /// <summary>
        /// 団体コードをキーに団体住所情報テーブルを読み込む
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{orgCd1}/{orgCd2}/addresses")]
        public IActionResult GetOrgAddrList(string orgCd1, string orgCd2)
        {
            IList<dynamic> list = organizationDao.SelectOrgAddrList(orgCd1, orgCd2);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 団体コードをキーに団体テーブルを読み込む
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{orgCd1}/{orgCd2}/header")]
        public IActionResult GetOrgHeader(string orgCd1, string orgCd2)
        {
            dynamic data = organizationDao.SelectOrgHeader(orgCd1, orgCd2);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 受診者数取得（団体別）
        /// </summary>
        /// <param name="date">対象日付</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/organizations")]
        public IActionResult GetSelDateOrg(DateTime date)
        {
            IList<dynamic> list = organizationDao.SelectSelDateOrg(date);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定団体に対し、成績書オプション管理状況を取得する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{orgCd1}/{orgCd2}/reportoption")]
        public IActionResult GetOrgRptOpt(string orgCd1, string orgCd2)
        {
            // 指定団体に対し、成績書オプション管理状況を取得(印刷オプション項目）
            IList<dynamic> orgRptOptRptv = organizationDao.SelectRptOpt(orgCd1, orgCd2, "RPTV%");
            IList<dynamic> orgRptOptRptd = organizationDao.SelectRptOpt(orgCd1, orgCd2, "RPTD%");

            return Ok(new { orgRptOptRptv, orgRptOptRptd });
        }

        /// <summary>
        /// 成績書オプション管理情報更新
        /// </summary>
        /// <param name="orgCd1"></param>
        /// <param name="orgCd2"></param>
        /// <param name="data"></param>
        /// <response code="204">成功</response>
        [HttpPut("{orgCd1}/{orgCd2}/reportoption")]
        public IActionResult UpdateRptOpt(string orgCd1, string orgCd2, [FromBody] JToken data)
        {
            // 更新User
            string updUser = HttpContext.Session.GetString("userId");
            // TODO
            updUser = "000000";

            // 更新実行
            organizationDao.UpdateRptOpt(orgCd1, orgCd2, updUser, data);

            return NoContent();
        }
    }
}
