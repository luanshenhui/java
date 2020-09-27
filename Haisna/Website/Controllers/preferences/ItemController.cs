using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.Entity.Model;
using Hainsi.Entity.Model.Item;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// Itemコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/items")]
    public class ItemController : Controller
    {
        /// <summary>
        /// グループデータアクセスオブジェクト
        /// </summary>
        readonly GrpDao grpDao;

        /// <summary>
        /// アイテムデータアクセスオブジェクト
        /// </summary>
        readonly ItemDao itemDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="grpDao">グループデータアクセスオブジェクト</param>
        /// <param name="itemDao">アイテムデータアクセスオブジェクト</param>
        public ItemController(GrpDao grpDao, ItemDao itemDao)
        {
            this.grpDao = grpDao;
            this.itemDao = itemDao;
        }

        /// <summary>
        /// 依頼項目情報を取得する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("/api/v1/requestitems/{itemCd}")]
        public IActionResult GetItemP(string itemCd)
        {
            dynamic data = itemDao.SelectItem_P(itemCd);

            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 検索条件を満たす依頼項目の一覧を取得する
        /// </summary>
        /// <param name="classCd">検査分類コード</param>
        /// <param name="searchChar">ガイド検索用文字列</param>
        /// <param name="questionKey">問診結果表示有無</param>
        /// <param name="searchCode">検索用コード</param>
        /// <param name="searchString">検索用文字列</param>
        [HttpGet("/api/v1/requestitems")]
        [ProducesResponseType(typeof(List<RequestItemList>), 200)]
        [ProducesResponseType(404)]
        public IActionResult SelectItem_pList(
            string classCd = null,
            string searchChar = null,
            ItemEnabled questionKey = ItemEnabled.Disp,
            string searchCode = null,
            string searchString = null
        )
        {
            List<dynamic> data = itemDao.SelectItem_pList(classCd, searchChar, questionKey, searchCode, searchString);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 検索条件を満たす検査項目名の一覧を取得する
        /// </summary>
        /// <param name="classCd">検査分類コード</param>
        /// <param name="searchChar">ガイド検索用文字列</param>
        /// <param name="questionKey">問診結果表示有無</param>
        /// <param name="resultType">結果タイプ</param>
        /// <param name="searchCode">検索用コード</param>
        /// <param name="searchString">検索用文字列</param>
        /// <param name="cuTargetFlg">CU経年変化表示対象</param>
        [HttpGet]
        [ProducesResponseType(typeof(List<ItemList>), 200)]
        [ProducesResponseType(404)]
        public IActionResult SelectItem_cList(
            string classCd = null,
            string searchChar = null,
            ItemEnabled questionKey = ItemEnabled.Disp,
            ResultType? resultType = null,
            string searchCode = null,
            string searchString = null,
            int? cuTargetFlg = null
        )
        {
            List<dynamic> data = itemDao.SelectItem_cList(classCd, searchChar, questionKey, resultType, searchCode, searchString, cuTargetFlg);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定された検査用項目コード／サフィックスに該当する検査項目テーブルのレコードを取得する
        /// </summary>
        /// <param name="insitemcd">検査用項目コード</param>
        /// <param name="inssuffix">検査用サフィックス</param>
        /// <param name="basedate">基準日</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("/api/v1/insitems")]
        public IActionResult GetItemByInsItemCd(string insitemcd, string inssuffix, DateTime basedate)
        {
            dynamic result = itemDao.SelectItemByInsItemCd(
                insitemcd, inssuffix, basedate);

            // 該当データが存在しない場合
            if (result == null)
            {
                return NotFound();
            }

            return Ok(result);
        }

        /// <summary>
        /// すべての検査分類を取得する
        /// </summary>
        [HttpGet("/api/v1/itemclasses")]
        [ProducesResponseType(typeof(List<ItemClass>), 200)]
        [ProducesResponseType(404)]
        public IActionResult SelectItemClassList()
        {
            IList<dynamic> data = itemDao.SelectItemClassList();

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }
            return Ok(data);
        }
    }
}
