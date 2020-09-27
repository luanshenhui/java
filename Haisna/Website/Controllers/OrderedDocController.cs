using Hainsi.Entity;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 送信オーダ文書情報コントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/ordereddocs")]
    public class OrderedDocController : Controller
    {
        /// <summary>
        /// 送信オーダ文書情報データアクセスオブジェクト
        /// </summary>
        readonly OrderedDocDao orderedDocDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="orderedDocDao">送信オーダ文書情報データアクセスオブジェクト</param>
        public OrderedDocController(OrderedDocDao orderedDocDao)
        {
            this.orderedDocDao = orderedDocDao;
        }

        /// <summary>
        /// 送信オーダ文書情報を取得する
        /// </summary>
        /// <param name="orderno">オーダ番号</param>
        /// <param name="orderdate">オーダ日付</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetByOrderNo(int orderno, DateTime orderdate)
        {
            // 送信オーダ文書情報を取得する
            List<dynamic> list = orderedDocDao.SelectByOrderNo(orderno, orderdate);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 送信オーダ文書情報の件数を取得する
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <param name="orderdiv">オーダ種別</param>
        /// <response code="200">成功</response>
        [HttpGet("count")]
        public IActionResult GetOrderedDocCount(int rsvno, string orderdiv)
        {
            // 送信オーダ文書情報の件数を取得する
            return Ok(orderedDocDao.SelectOrderedDocCount(rsvno, orderdiv));
        }
    }
}
