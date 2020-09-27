using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.Entity.Model.Sentence;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 文章コントローラー
    /// </summary>
    //[Authorize]
    [Route("api/v1/sentences")]
    public class SentenceController : Controller
    {
        /// <summary>
        /// 文章テーブルデータアクセスオブジェクト
        /// </summary>
        readonly SentenceDao sentenceDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="sentenceDao">文テーブルデータアクセスオブジェクト</param>
        public SentenceController(SentenceDao sentenceDao)
        {
            this.sentenceDao = sentenceDao;
        }

        /// <summary>
        /// 指定検査項目コード、項目タイプ、文章コードの文章を取得する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="itemType">項目タイプ</param>
        /// <param name="stcCd">文章コード</param>
        [ProducesResponseType(typeof(Sentence), 200)]
        [ProducesResponseType(404)]
        [HttpGet("{itemCd}/{itemType}/{stcCd}")]
        public IActionResult SelectSentence(string itemCd, ItemType itemType, string stcCd)
        {
            dynamic data = sentenceDao.SelectSentence(itemCd, itemType, stcCd);

            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定検査項目コード、サフィックス、項目タイプ、文章コードの文章を取得する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="itemType">項目タイプ</param>
        /// <param name="stcCd">文章コード</param>
        [ProducesResponseType(typeof(Sentence), 200)]
        [ProducesResponseType(404)]
        [HttpGet("{itemCd}/{suffix}/{itemType}/{stcCd}")]
        public IActionResult SelectSentence(string itemCd, string suffix, ItemType itemType, string stcCd)
        {
            dynamic data = sentenceDao.SelectSentence(itemCd, itemType, stcCd, 1, suffix);

            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 検索条件を満たす文章の一覧を取得する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="itemType">項目タイプ</param>
        /// <param name="searchCode">検索用コード</param>
        /// <param name="searchString">検索用文字列</param>
        /// <param name="stcClassCd">文章分類コード</param>
        /// <param name="selectMode">選択モード(0:全て、1:表示順番）</param>
        [HttpGet]
        [ProducesResponseType(typeof(List<SentenceList>), 200)]
        [ProducesResponseType(404)]
        public IActionResult SelectSentenceList(
            string itemCd,
            ItemType itemType,
            string searchCode = null,
            string searchString = null,
            string stcClassCd = null,
            int selectMode = 1
        )
        {
            IList<dynamic> data = sentenceDao.SelectSentenceList(itemCd, itemType, searchCode, searchString, stcClassCd, selectMode);

            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 検索条件を満たす文章分類一覧を取得する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="itemType">項目タイプ</param>
        [HttpGet("~/api/v1/sentenceclasses")]
        [ProducesResponseType(typeof(List<SentenceClass>), 200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(404)]
        public IActionResult SelectStcClassList(string itemCd, ItemType itemType)
        {
            if (string.IsNullOrEmpty(itemCd?.Trim()))
            {
                return BadRequest();
            }

            IList<dynamic> data = sentenceDao.SelectStcClassList(itemCd, itemType);

            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }
    }
}
