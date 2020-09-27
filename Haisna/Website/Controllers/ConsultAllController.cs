using Hainsi.Entity;
using Hainsi.Entity.Model.Consultation;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// ConsultAllコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/consultations")]
    public class ConsultAllController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly ConsultAllDao consultAllDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="consultAllDao">データアクセスオブジェクト</param>
        public ConsultAllController(ConsultAllDao consultAllDao)
        {
            this.consultAllDao = consultAllDao;
        }

        /// <summary>
        /// 一括受診日変更
        /// </summary>
        /// <param name="data">入力値</param>
        [HttpPut("dates")]
        [ProducesResponseType(204)]
        [ProducesResponseType(404)]
        [ProducesResponseType(typeof(Dictionary<string, Array>), 400)]
        public IActionResult ChangeDate([FromBody] ChangeDateModel data)
        {
            // string userId = HttpContext.Session.GetString("userid");  // ユーザID
            // 本来はセッションから取得する #ToDo
            string userId = "0";

            int ret = consultAllDao.ChangeDate(data.Mode, userId, data.IgnoreFlg, data.CslDate, data.RsvNo, data.RsvGrpCd, out string message);

            if (!string.IsNullOrEmpty(message))
            {
                return BadRequest(new { errors = new[] { message } });
            }

            return NoContent();
        }

        /// <summary>
        /// 予約枠検索からの予約
        /// </summary>
        /// <param name="mode">検索モード</param>
        /// <param name="ignoreFlg">予約枠無視フラグ</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="data">
        /// perId        個人ＩＤ
        /// manCnt       人数
        /// gender       性別
        /// birth        生年月日
        /// age          受診時年齢
        /// romeName     ローマ字名
        /// orgCd1       団体コード１
        /// orgCd2       団体コード２
        /// cslDivCd     受診区分コード
        /// csCd         コースコード
        /// rsvGrpCd     予約群コード
        /// ctrPtCd      契約パターンコード
        /// rsvNo        継承すべき受診情報の予約番号
        /// optCd        オプションコード
        /// optBranchNo  オプション枝番
        /// </param>
        /// <response code="200">成功</response>
        /// <response code="400">リクエスト不正</response>
        /// <response code="404">データなし</response>
        [HttpPost("bulk")]
        public IActionResult ReserveFromFrameReserve(string mode, int ignoreFlg, DateTime cslDate, [FromBody] JToken data)
        {
            // ユーザID
            string userId = HttpContext.Session.GetString("userid");
            // 個人ＩＤ
            string[] perId = data["perid"].ToObject<List<string>>().ToArray();
            // 人数
            int?[] manCnt = data["mancnt"].ToObject<List<int?>>().ToArray();
            // 性別
            int?[] gender = data["gender"].ToObject<List<int?>>().ToArray();
            // 生年月日
            DateTime?[] birth = data["birth"].ToObject<List<DateTime?>>().ToArray();
            // 受診時年齢
            int?[] age = data["age"].ToObject<List<int?>>().ToArray();
            // ローマ字名
            string[] romeName = data["romename"].ToObject<List<string>>().ToArray();
            // 団体コード１
            string[] orgCd1 = data["orgcd1"].ToObject<List<string>>().ToArray();
            // 団体コード２
            string[] orgCd2 = data["orgcd2"].ToObject<List<string>>().ToArray();
            // コースコード
            string[] csCd = data["cscd"].ToObject<List<string>>().ToArray();
            // 受診区分コード
            string[] cslDivCd = data["csldivcd"].ToObject<List<string>>().ToArray();
            // 予約群コード
            int?[] rsvGrpCd = data["rsvgrpcd"].ToObject<List<int?>>().ToArray();
            // 契約パターンコード
            int[] ctrPtCd = data["ctrptcd"].ToObject<List<int>>().ToArray();
            // 継承すべき受診情報の予約番号
            int?[] rsvNo = data["rsvno"].ToObject<List<int?>>().ToArray();
            // オプションコード
            string[] optCd = data["optcd"].ToObject<List<string>>().ToArray();
            // オプション枝番
            string[] optBranchNo = data["optbranchno"].ToObject<List<string>>().ToArray();

            int ret = consultAllDao.ReserveFromFrameReserve(mode, userId, ignoreFlg, cslDate, perId,
                manCnt, gender, birth, age, romeName, orgCd1, orgCd2, csCd, cslDivCd, rsvGrpCd,
                ctrPtCd, rsvNo, optCd, optBranchNo, out int? strRsvNo, out int? endRsvNo, out string message);

            if (!string.IsNullOrEmpty(message))
            {
                return BadRequest(message);
            }

            // データ件数が0件の場合
            if (ret == 0)
            {
                return NotFound();
            }

            var ds = new Dictionary<string, Object>
                        {
                            { "strrsvno", strRsvNo },
                            { "endrsvno", endRsvNo }
                        };

            return Ok(ds);
        }
    }
}
