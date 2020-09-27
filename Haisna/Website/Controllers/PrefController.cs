using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using Hainsi.Entity;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 都道府県データコントローラ
    /// </summary>
    [Route("api/v1/prefectures")]
    public class PrefController : Controller
    {
        /// <summary>
        /// 都道府県データアクセスオブジェクト
        /// </summary>
        readonly PrefDao prefDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="prefDao">都道府県データアクセスオブジェクト</param>
        public PrefController(PrefDao prefDao)
        {
            this.prefDao = prefDao;
        }

        /// <summary>
        /// 一覧を取得する
        /// </summary>
        /// <returns>一覧</returns>
        [HttpGet]
        public IActionResult Get()
        {
            var data = prefDao.SelectPrefList();

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 都道府県コードに対する都道府県名を取得する
        /// </summary>
        /// <param name="prefCd">都道府県コード</param>
        /// <returns></returns>
        [HttpGet("{prefCd}")]
        public IActionResult GetPref(string prefCd)
        {
            dynamic data = prefDao.SelectPref(prefCd);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }
    }
}
