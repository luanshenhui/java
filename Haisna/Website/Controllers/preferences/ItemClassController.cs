using Hainsi.Entity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Specialized;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 検査分類コントローラ
    /// </summary>
    //[Authorize]
    [Route("api/[controller]")]
    public class ItemClassController : Controller
    {
        /// <summary>
        /// 検査分類データアクセスオブジェクト
        /// </summary>
        readonly ItemClassDao itemClassDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="itemClassDao">検査分類データアクセスオブジェクト</param>
        public ItemClassController(ItemClassDao itemClassDao)
        {
            this.itemClassDao = itemClassDao;
        }

        /// <summary>
        /// 検査分類一覧を取得する
        /// </summary>
        /// <param name="keyword">検索キーワード</param>
        /// <param name="page">ページ番号</param>
        /// <param name="limit">ページ当たりの最大件数</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult Get(string keyword, string page, string limit)
        {
            PartialDataSet ds = itemClassDao.SelectItemClassList(new NameValueCollection
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
        /// 検査分類情報取得
        /// </summary>
        /// <param name="id">検査分類コード</param>
        /// <returns></returns>
        [HttpGet("{id}")]
        public IActionResult GetById(string id)
        {
            dynamic rec = itemClassDao.SelectItemClass(id);

            // 指定グループが存在しない場合
            if (rec == null)
            {
                return NotFound();
            }

            return Ok(rec);
        }
    }
}
