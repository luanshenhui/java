using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using Hainsi.Entity;
using System;
using Newtonsoft.Json.Linq;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 精度管理データコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/accuracies")]
    public class MngAccuracyController : Controller
    {
        /// <summary>
        /// 精度管理データアクセスオブジェクト
        /// </summary>
        readonly MngAccuracyDao mngAccuracyDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="mngAccuracyDao">精度管理データアクセスオブジェクト</param>
        public MngAccuracyController(MngAccuracyDao mngAccuracyDao)
        {
            this.mngAccuracyDao = mngAccuracyDao;
        }

        /// <summary>
        /// 検索条件に従い成績書情報一覧を抽出する
        /// </summary>
        /// <param name="strCslDate"> 検索条件受診日（開始）</param>
        /// <param name="border"> 境界</param>
        /// <param name="genderMode"> 表示対象性別：1:男、2:女、3:男女別、4:男女マージ</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/accuracies")]
        public IActionResult GetMngAccuracy(string strCslDate, string border, int genderMode)
        {

            // 入力データバリデーション
            List<string> messages = mngAccuracyDao.Validate(border);

            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            List<dynamic> list = mngAccuracyDao.SelectMngAccuracy(strCslDate, genderMode);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }
            return Ok(list);
        }
    }
}
