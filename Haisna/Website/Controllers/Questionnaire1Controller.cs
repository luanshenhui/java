using Hainsi.Entity;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using Newtonsoft.Json.Linq;
using Hainsi.Entity.Model.Result;

namespace Website.Controllers
{
    /// <summary>
    /// Questionnaire1コントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/ocrnyuryoku1")]
    public class Questionnaire1Controller : Controller
    {
        /// <summary>
        /// Questionnaire1オブジェクト
        /// </summary>
        readonly Questionnaire1Dao questionnaire1Dao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="questionnaire1Dao">Questionnaire1オブジェクト</param>
        public Questionnaire1Controller(Questionnaire1Dao questionnaire1Dao)
        {
            this.questionnaire1Dao = questionnaire1Dao;
        }

        /// <summary>
        /// 胃内視鏡の依頼があるかチェックする
        /// 依頼がある場合は内視鏡チェックリストが保存されているかをチェックする
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
		/// <response code="400">リクエスト不正</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/gf1")]
        public IActionResult CheckGF(int rsvNo)
        {
            // 内視鏡チェックリスト
            string gFCheckList = "";

            int ret = questionnaire1Dao.CheckGF(rsvNo, ref gFCheckList);

            // 内視鏡チェックリストの状態
            if (ret < 0)
            {
                return BadRequest("内視鏡チェックリストの状態が取得できません。（予約番号 = " + rsvNo + ")");
            }

            return Ok(new { ret, gFCheckList });
        }

        /// <summary>
        /// OCR内容確認修正日時を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/orcdate1")]
        public IActionResult GetEditOcrDate(int rsvNo)
        {
            dynamic data = questionnaire1Dao.SelectEditOcrDate(rsvNo);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);

        }

        /// <summary>
        /// ＯＣＲ入力結果を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="lastDspMode">前回歴表示モード（0:すべて、1:同一コース、2:任意指定）</param>
        /// <param name="csGrp">前回歴表示モード＝0のとき、null
        ///                                     ＝1のとき、コースコード
        ///                                     ＝2のとき、コースグループコード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/ocrresults1")]
        public IActionResult GetOcrNyuryoku(int rsvNo, string grpCd, int lastDspMode, string csGrp)
        {
            //エラー数
            int errCount = 0;

            //エラーNo
            List<int> arrErrNo = new List<int>();

            //エラー状態
            List<string> arrErrState = new List<string>();

            //エラーメッセージ
            List<string> arrErrMsg = new List<string>();

            // ＯＣＲ入力結果を取得
            List<dynamic> ocrresult = questionnaire1Dao.SelectOcrNyuryoku(rsvNo, grpCd, lastDspMode, csGrp, ref errCount, ref arrErrNo, ref arrErrState, ref arrErrMsg);

            // データ件数が0件の場合
            if (ocrresult == null || ocrresult.Count <= 0)
            {
                return NotFound();
            }

            return Ok(new { ocrresult, errCount, arrErrNo, arrErrState, arrErrMsg });
        }

        /// <summary>
        /// ＯＣＲ入力結果の入力チェック
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="data">grpCd グループコード 
        ///                    lastDspMode 前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
        ///                    csGrp 前回歴表示モード＝0のとき、null
        ///                                     ＝1のとき、コースコード
        ///                                     ＝2のとき、コースグループコード 
        ///                     検査項目</param>
        /// <response code="200">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("~/api/v1/consultations/{rsvNo}/validation/ocr1")]
        public IActionResult CheckOcrNyuryoku(int rsvNo,
                                                 [FromBody] JToken data)
        {

            //エラー数
            int errCount = 0;
            //エラーNo
            List<int> arrErrNo = new List<int>();
            //エラー状態
            List<string> arrErrState = new List<string>();
            //エラーメッセージ
            List<string> arrErrMsg = new List<string>();

            List<dynamic> results = data["results"].ToObject<List<dynamic>>();
            string grpCd = data["grpCd"].ToObject<string>();
            int lastDspMode = data["lastDspMode"].ToObject<int>();
            string csGrp = data["csGrp"].ToObject<string>();

            List<string> itemCd = new List<string>();
            List<string> suffix = new List<string>();
            List<string> result = new List<string>();
            List<string> stopFlg = new List<string>();

            for (int i = 0; i < results.Count; i++)
            {
                itemCd.Add(Convert.ToString(results[i].itemcd));
                suffix.Add(Convert.ToString(results[i].suffix));
                result.Add(Convert.ToString(results[i].result));
                stopFlg.Add(Convert.ToString(results[i].stopflg));
            }

            int count = questionnaire1Dao.CheckOcrNyuryoku(rsvNo,
                                                          grpCd,
                                                          lastDspMode,
                                                          csGrp,
                                                          ref itemCd,
                                                          ref suffix,
                                                          ref result,
                                                          ref stopFlg,
                                                          ref errCount,
                                                          ref arrErrNo,
                                                          ref arrErrState,
                                                          ref arrErrMsg);

            // データ件数が0件の場合
            if (count < 0)
            {
                return BadRequest("OCR入力結果が取得できません。（予約番号 = " + rsvNo + ")");

            }

            return Ok(new { result, stopFlg, errCount, arrErrNo, arrErrState, arrErrMsg });
        }

        /// <summary>
        /// ＯＣＲ入力結果を更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="results">検査項目</param>
        /// <param name="skipNoRec">真の場合は依頼のない検査項目をスキップ(中止フラグつき更新のみ有効)</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("~/api/v1/consultations/{rsvNo}/ocrresults1")]
        public IActionResult UpdateOcrNyuryoku(int rsvNo,
                                      [FromBody] IList<ResultRec> results,
                                      bool skipNoRec = false)
        {
            //メッセージ
            List<string> message = new List<string>();

            // 更新User
            string updUser = HttpContext.Session.GetString("userId");
            updUser = "HAINS$";

            // IPアドレス
            string ipAddress = HttpContext.Connection.RemoteIpAddress.ToString();

            List<string> itemCd = new List<string>();
            List<string> suffix = new List<string>();
            List<string> result = new List<string>();
            List<string> stopFlg = new List<string>();

            for (int i = 0; i < results.Count; i++)
            {
                itemCd.Add(results[i].ItemCd);
                suffix.Add(results[i].Suffix);
                result.Add(results[i].Result);
                stopFlg.Add(results[i].StopFlg);
            }

            //更新実行
            bool ret = questionnaire1Dao.UpdateOcrNyuryoku(rsvNo,
                                                          ipAddress,
                                                          updUser,
                                                          itemCd,
                                                          suffix,
                                                          result,
                                                          null,
                                                          null,
                                                          message,
                                                          stopFlg);

            if (message != null && message.Count > 0)
            {
                return BadRequest(message);
            }

            return NoContent();
        }

        /// <summary>
        /// 該当受診者の受診日チェック
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>受診日</returns>
        /// <response code="200">成功</response>
		/// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/csldate1")]
        public IActionResult CheckCslDate(int rsvNo)
        {
            dynamic ds = questionnaire1Dao.CheckCslDate(rsvNo);

            // データ件数が0件の場合
            if (ds == null)
            {
                return NotFound();
            }

            return Ok(ds);
        }
    }
}
