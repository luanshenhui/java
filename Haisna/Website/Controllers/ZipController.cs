using Hainsi.Entity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Specialized;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 郵便番号データコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/[controller]")]
    public class ZipController : Controller
    {
        /// <summary>
        /// 郵便番号データアクセスオブジェクト
        /// </summary>
        readonly ZipDao zipDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="zipDao">データアクセスオブジェクト</param>
        public ZipController(ZipDao zipDao)
        {
            this.zipDao = zipDao;
        }

        /// <summary>
        /// 一覧を取得する
        /// </summary>
        /// <param name="prefCd">都道府県コード</param>
        /// <param name="keyword">検索キーワード</param>
        /// <param name="page">ページ番号</param>
        /// <param name="limit">1ページ表示件数</param>
        /// <response code="200">成功</response>
        /// <response code="422">バリデーションエラー</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult Get(string prefCd, string keyword, string page, string limit)
        {
            var qp = new NameValueCollection
            {
                { "prefcd", prefCd },
                { "keyword", keyword },
                { "page", page },
                { "limit", limit }
            };

            // 入力データバリデーション
            IList<string> messages = zipDao.Validate(qp);
            if(messages.Count > 0)
            {
                return this.UnprocessableEntity(messages);
            }

            PartialDataSet ds = zipDao.SelectZipList(qp);

            // データ件数が0件の場合
            if (ds.Data.Count == 0)
            {
                return NotFound(ds);
            }

            return Ok(ds);
        }
    }
}
