using Hainsi.Entity;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 結果コメントアクセス用WebAPIコントローラークラス
    /// </summary>
    //[Authorize]
    [Route("api/v1/resultcomments")]
    public class RslCmtController : Controller
    {
        /// <summary>
        /// 結果コメントデータアクセスオブジェクト
        /// </summary>
        readonly RslCmtDao rslCmtDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="rslCmtDao">結果コメントデータアクセスオブジェクト</param>
        public RslCmtController(RslCmtDao rslCmtDao)
        {
            this.rslCmtDao = rslCmtDao;
        }

        /// <summary>
        /// 一覧を取得する
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult Get()
        {
            List<dynamic> data = rslCmtDao.SelectRslCmtList();

            // データ件数が0件の場合
            if (data.Count == 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定した結果コメント情報を取得します。
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rslcmtCd}")]
        public IActionResult Get(string rslcmtcd)
        {
            dynamic rec = rslCmtDao.SelectRslCmt(rslcmtcd);

            // 指定結果コメント情報が存在しない場合
            if (rec == null)
            {
                return NotFound();
            }

            return Ok(rec);
        }

        /// <summary>
        /// 指定予約番号における指定汎用コード内グループの結果コメントを取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="freeCd">汎用コード</param>
        /// <response code="200">成功</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/groups/resultcomments")]
        public IActionResult GetRslCmtListForChangeSet(long rsvNo, String freeCd)
        {
            List<string> grpCd = new List<string>();
            List<string> grpName = new List<string>();
            List<string> consults = new List<string>();
            List<string> rslCmtCd = new List<string>();
            List<string> rslCmtName = new List<string>();

            long count = rslCmtDao.SelectRslCmtListForChangeSet(rsvNo, freeCd, ref grpCd, ref grpName, ref consults, ref rslCmtCd, ref rslCmtName);

            var ds = new Dictionary<string, object>
                        {
                            { "count",  count},
                            { "grpcd", grpCd },
                            { "grpname", grpName },
                            { "consults", consults },
                            { "rslcmtcd", rslCmtCd },
                            { "rslcmtname", rslCmtName }
                        };

            return Ok(ds);
        }
    }
}
