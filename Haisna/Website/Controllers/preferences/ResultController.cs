using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.Entity.Model.Result;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 結果テーブルデータコントローラ
    /// </summary>
    [Route("api/v1/results")]
    public class ResultController : Controller
    {
        /// <summary>
        /// 契約データアクセスオブジェクト
        /// </summary>
        readonly ResultDao resultDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="resultDao">検査結果データアクセスオブジェクト</param>
        public ResultController(ResultDao resultDao)
        {
            this.resultDao = resultDao;
        }

        /// <summary>
        /// 検査結果値のバリデーションを行い、その結果を返します。
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="results">ステータス付き検査結果モデルのリスト</param>
        [HttpPost("{cslDate}/validation")]
        [ProducesResponseType(200)]
        public IActionResult CheckResult(DateTime cslDate, [FromBody] IList<ResultWithStatus> results)
        {
            // 検査結果入力チェック
            IList<string> messages = resultDao.CheckResult(cslDate, ref results);

            // 検査結果入力チェックでエラーがあった場合でも常に200(Ok)を返す
            return Ok(new { results, messages });
        }

        /// <summary>
        /// 検査結果入力チェック
        /// </summary>
        /// <param name="year" > 受診日（年）</param>
        /// <param name="month">受診日（月）</param>
        /// <param name="day">受診日（日）</param>
        /// <param name="dayIdF">当日ＩＤ </param>
        /// <param name="dayIdT">当日ＩＤ</param>
        /// <response code="200">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpGet("parameters/rslallset1")]
        public IActionResult CheckRslAllSet1Value(string year, string month, string day, string dayIdF = "0000", string dayIdT = "9999")
        {
            // 受診年月日の編集
            DateTime? cslDate = Convert.ToDateTime(year + "/" + month + "/" + day);


            // 検査結果入力チェック
            List<string> messages = resultDao.CheckRslAllSet1Value(year, month, day, out cslDate,
                ref dayIdF, ref dayIdT);

            // チェックエラー時は処理を抜ける
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            var data = new Dictionary<string, dynamic>
            {
                { "dayidf", dayIdF },
                { "dayidt", dayIdT },
                { "csldate",cslDate},
            };

            return Ok(data);
        }

        /// <summary>
        /// 条件入力チェック
        /// </summary>
        /// <param name="year" > 受診日（年）</param>
        /// <param name="month">受診日（月）</param>
        /// <param name="day">受診日（日）</param>
        /// <response code="200">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("parameters/rsllistset")]
        public IActionResult CheckRslListSetConditionValue(string year, string month, string day)
        {
            DateTime? cslDate = new DateTime();
            String dayIdF = "";

            // 条件入力チェック
            List<string> messages = resultDao.CheckRslListSetConditionValue(year, month, day, out cslDate, dayIdF);

            // チェックエラー時は処理を抜ける
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            var data = new Dictionary<string, dynamic>
            {
                { "csldate", cslDate }
            };

            return Ok(data);
        }

        /// <summary>
        /// 特定保健指導区分結果データ取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/{itemCd}/{suffix}")]
        public IActionResult GetRsl(long rsvNo, string itemCd, string suffix)
        {
            // 検査結果
            string result = resultDao.SelectRsl(rsvNo, itemCd, suffix);

            if (string.IsNullOrEmpty(result))
            {
                return NotFound();
            }

            return Ok(result);
        }

        /// <summary>
        /// 指定対象受診者・検査グループの検査項目を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="grpCd">グループ（検査項目）</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("individuals/{rsvNo}")]
        public IActionResult GetRslAllSetList(string rsvNo, string grpCd)
        {
            List<dynamic> data = resultDao.SelectRslAllSetList(rsvNo, grpCd);

            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 検索条件を満たしかつ指定開始位置、件数分のレコードを取得
        /// </summary>
        /// <param name="mode">入力対象モード</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="code">入力対象コード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}")]
        public IActionResult GetRslList(int mode, int rsvNo, string code)
        {
            // 更新可能項目数
            int updItemCount = 0;
            List<dynamic> item = resultDao.SelectRslList(mode, rsvNo, code, ref updItemCount);

            if (item == null || item.Count <= 0)
            {
                return NotFound();
            }

            var data = new Dictionary<string, dynamic>
            {
                { "item", item },
                { "upditemcount",updItemCount}
            };

            return Ok(data);
        }

        /// <summary>
        /// 指定対象受診者・検査グループの検査項目を取得する
        /// </summary>
        /// <param name="grpCd">グループ（検査項目）</param>
        /// <param name="data"></param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>

        [HttpPost("{grpCd}/listset")]
        public IActionResult GetRslListSet(string grpCd, [FromBody]JToken data)
        {
            //予約番号
            List<string> rsvNo = data["rsvno"].ToObject<List<string>>();

            //姓
            List<string> lastName = data["lastName"].ToObject<List<string>>();

            //名
            List<string> firstName = data["firstName"].ToObject<List<string>>();

            List<dynamic> items = resultDao.SelectRslListSet(rsvNo, lastName, firstName, grpCd);

            if (items == null || items.Count <= 0)
            {
                return NotFound();
            }

            return Ok(items);
        }

        /// <summary>
        /// 指定予約番号の検査結果を更新します。
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="results">検査結果</param>
        /// <param name="userId">更新ユーザID</param>
        [HttpPut("{rsvNo}")]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult UpdateResult(int rsvNo, [FromBody] IList<ResultRec> results, string userId = null)
        {
            // 更新ユーザー
            userId = userId ?? HttpContext.Session.GetString("userId");
            userId = "HAINS$";

            // IPアドレス
            string ipAddress = HttpContext.Connection.RemoteIpAddress.ToString();

            // メッセージ
            var messages = new List<string>();

            // 検査結果の更新
            Insert ret = resultDao.UpdateResult(rsvNo, ipAddress, userId, results, ref messages);

            if (ret == Insert.Error)
            {
                return BadRequest(messages);
            }

            return NoContent();
        }

        /// <summary>
        /// 指定予約番号の検査結果を更新します。
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="results">検査結果</param>
        /// <param name="userId">更新ユーザID</param>
        /// <param name="includeStopFlg">真の場合は検査中止フラグを更新に含める</param>
        /// <param name="skipNoRec">真の場合は依頼のない検査項目をスキップ</param>
        [HttpPut("{rsvNo}/addparam")]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult UpdateResultAddParam(int rsvNo, [FromBody] IList<ResultRec> results, string userId = null, bool includeStopFlg = false, bool skipNoRec = false)
        {
            // 更新ユーザー
            userId = userId ?? HttpContext.Session.GetString("userId");

            // IPアドレス
            string ipAddress = HttpContext.Connection.RemoteIpAddress.ToString();

            // メッセージ
            var messages = new List<string>();

            // 検査結果の更新
            Insert ret = resultDao.UpdateResult(rsvNo, ipAddress, userId, results, ref messages, includeStopFlg, skipNoRec);

            if (ret == Insert.Error)
            {
                return BadRequest(messages);
            }

            return NoContent();
        }

        /// <summary>
        /// 検査結果一括更新
        /// </summary>
        /// <param name="data"></param>
        /// <response code="204">成功</response>
        [HttpPut("bulk")]
        public IActionResult UpdateResultAll([FromBody] ResultRecAll data)
        {
            // 予約番号
            List<long> rsvNo = data.RsvNo;
            // 更新User
            string updUser = HttpContext.Session.GetString("userId");
            updUser = "HAINS$";

            // IPアドレス
            string ipAddress = HttpContext.Connection.RemoteIpAddress.ToString();
            // 全ての結果をクリア
            string allResultClear = data.AllResultClear;

            List<string> itemCd = new List<string>();
            List<string> suffix = new List<string>();
            List<string> result = new List<string>();

            // セットデータのチェック
            List<ResultRec> items = data.ResultItems;

            //各配列値の更新処理
            foreach (var rec in items)
            {
                itemCd.Add(rec.ItemCd);
                suffix.Add(rec.Suffix);
                result.Add(rec.Result);
            }

            resultDao.UpdateResultAll(updUser, ipAddress, allResultClear, "", rsvNo, itemCd, suffix, result);

            return NoContent();

        }

        /// <summary>
        /// 検査結果テーブルのコメントと中止フラグを更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="resultForChangeSet"></param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("{rsvNo}/commentandstopflag")]
        public IActionResult UpdateResultForChangeSet(string rsvNo, [FromBody] ResultForChangeSet resultForChangeSet)
        {
            // IPアドレス
            string ipAddress = HttpContext.Connection.RemoteIpAddress.ToString();

            // 更新User
            string updUser = HttpContext.Session.GetString("userId");
            updUser = "HAINS$";

            // 結果コメント１
            List<string> grpCd = resultForChangeSet.GrpCd;

            // 結果コメント２
            List<string> rslCmtCd2 = resultForChangeSet.RslCmtCd;

            //// セットデータのチェック
            //List<JToken> items = data["result"].ToObject<List<JToken>>();

            ////各配列値の更新処理
            //foreach (var rec in items)
            //{
            //    grpCd.Add(Convert.ToString(rec["grpcd"]));
            //    rslCmtCd2.Add(Convert.ToString(rec["rslcmtcd2"]));
            //}

            List<string> message = new List<string>();

            // 検査中止情報の更新
            Insert result = resultDao.UpdateResultForChangeSet(rsvNo, ipAddress, updUser, grpCd, rslCmtCd2, message);

            if (Insert.Error == result)
            {
                return BadRequest(message);
            }

            return NoContent();
        }

        /// <summary>
        /// 検査結果テーブルを更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="resultDetail"></param>
        /// <response code="200">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("{rsvNo}/detail")]
        public IActionResult UpdateResultForDetail(string rsvNo, [FromBody] ResultDetail resultDetail)
        {
            // IPアドレス
            string ipAddress = HttpContext.Connection.RemoteIpAddress.ToString();

            // 更新User
            string updUser = HttpContext.Session.GetString("userId");
            updUser = "HAINS$";

            // 検査項目コード
            List<string> itemCd = resultDetail.ItemCd;

            // サフィックス
            List<string> suffix = resultDetail.Suffix;

            // 検査結果
            List<string> result = resultDetail.Result;

            // 結果コメント１
            List<string> rslCmtCd1 = resultDetail.RslCmtCd1;

            // 結果コメント２
            List<string> rslCmtCd2 = resultDetail.RslCmtCd2;

            // 略文章
            List<string> shortStc = new List<string>();

            // 結果チェックエラーコード
            List<string> resultError = new List<string>();

            // 結果コメント名１
            List<string> rslCmtName1 = new List<string>();

            // 結果コメント１チェックエラーコード
            List<string> rslCmtError1 = new List<string>();

            // 結果コメント名２
            List<string> rslCmtName2 = new List<string>();

            // 結果コメント２チェックエラーコード
            List<string> rslCmtError2 = new List<string>();

            // メッセージ
            List<string> message = new List<string>();

            //// セットデータのチェック
            //List<JToken> results = data["result"].ToObject<List<JToken>>();

            ////各配列値の更新処理
            //foreach (var rec in results)
            //{
            //    itemCd.Add(Convert.ToString(rec["itemcd"]));
            //    suffix.Add(Convert.ToString(rec["suffix"]));
            //    result.Add(Convert.ToString(rec["result"]));
            //    rslCmtCd1.Add(Convert.ToString(rec["rslcmtcd1"]));
            //    rslCmtCd2.Add(Convert.ToString(rec["rslcmtcd2"]));
            //}

            Insert updateResult = resultDao.UpdateResultForDetail(rsvNo, ipAddress, updUser, ref itemCd, suffix,
                                                        ref result, ref shortStc, ref resultError, ref rslCmtCd1,
                                                        ref rslCmtName1, ref rslCmtError1, ref rslCmtCd2,
                                                        ref rslCmtName2, ref rslCmtError2, ref message);

            var items = new Dictionary<string, dynamic>
            {
                { "itemcd", itemCd },
                { "result", result },
                { "shortstc",shortStc},
                { "resulterror", resultError },
                { "rslcmtcd1", rslCmtCd1 },
                { "rslcmtname1",rslCmtName1},
                { "rslcmterror1", rslCmtError1 },
                { "rslcmtcd2", rslCmtCd2 },
                { "rslcmtname2",rslCmtName2},
                { "rslcmterror2",rslCmtError2},
                { "message",message}
            };
            if (Insert.Error == updateResult)
            {
                return BadRequest(items);
            }


            return Ok(items);
        }

        /// <summary>
        /// 検査結果テーブルを更新する(一覧入力、例外者入力用)
        /// </summary>
        /// <param name="data"></param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("list")]
        public IActionResult UpdateResultList([FromBody] ResultRecAll data)
        {
            // IPアドレス
            string ipAddress = HttpContext.Connection.RemoteIpAddress.ToString();
            
            // 更新User
            string updUser = HttpContext.Session.GetString("userId");
            updUser = "HAINS$";

            // 検査項目コード
            List<string> itemCd = new List<string>();

            // サフィックス
            List<string> suffix = new List<string>();

            // 予約番号
            List<string> rsvNo = new List<string>();

            // 検査結果
            List<string> result = new List<string>();

            // セットデータのチェック
            List<ResultRec> items = data.ResultItems;
           
            //各配列値の更新処理
            foreach (var rec in items)
            {
                itemCd.Add(rec.ItemCd);
                suffix.Add(rec.Suffix);
                rsvNo.Add(rec.RsvNo);
                result.Add(rec.Result);
            }

            // 検査結果テーブルを更新する(一覧入力、例外者入力用)
            List<string> messages = resultDao.UpdateResultList(updUser, ipAddress, rsvNo, itemCd, suffix, result);

            if (messages != null && messages.Count > 0)
            {
                return BadRequest(messages);
            }

            return NoContent();
        }

        /// <summary>
        /// 検査結果テーブルを更新する(コメント更新なし)
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="resultNoCmt"></param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("{rsvNo}/nocomment")]
        public IActionResult UpdateResultNoCmt(long rsvNo, [FromBody] ResultNoCmt resultNoCmt)
        {
            // IPアドレス
            string ipAddress = HttpContext.Connection.RemoteIpAddress.ToString();

            // 更新User
            string updUser = HttpContext.Session.GetString("userId");
            updUser = "HAINS$";

            // 検査項目コード
            List<string> itemCd = resultNoCmt.ItemCd;

            // サフィックス
            List<string> suffix = resultNoCmt.Suffix;

            // 検査結果
            List<string> result = resultNoCmt.Rslvalue;

            //// セットデータのチェック
            //List<JToken> items = data["resultitem"].ToObject<List<JToken>>();

            ////各配列値の更新処理
            //foreach (var rec in items)
            //{
            //    itemCd.Add(Convert.ToString(rec["itemcd"]));
            //    suffix.Add(Convert.ToString(rec["suffix"]));
            //    result.Add(Convert.ToString(rec["result"]));
            //}

            // メッセージ
            List<string> messages = new List<string>();

            Insert updateResult = resultDao.UpdateResultNoCmt(rsvNo, ipAddress, updUser, itemCd, suffix, result, messages);

            if (Insert.Error == updateResult)
            {
                return BadRequest(messages);
            }

            return NoContent();
        }

        /// <summary>
        /// 検査結果テーブルを更新する(コメント更新なし)
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("{rsvNo}/yudo")]
        public IActionResult UpdateYudo(long rsvNo)
        {
            // 更新User
            string updUser = HttpContext.Session.GetString("userId");
            updUser = "HAINS$";

            // メッセージ
            List<string> messages = new List<string>();

            long result = Convert.ToInt32(resultDao.UpdateYudo(rsvNo, updUser, messages));

            if (result < 0)
            {
                return BadRequest(messages);
            }

            return NoContent();
        }

        /// <summary>
        /// 指定された予約番号、検査項目コード、検索対象検査結果に該当する最も大きいサフィックスとその検査結果を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="results">検索対象検査結果</param>
        /// <response code="200">成功</response>
        [HttpGet("suffixandresult")]
        public IActionResult GetSuffixAndResult(int rsvNo, string itemCd, string[] results)
        {
            string suffix = "";
            string result = "";
            resultDao.SelectSuffixAndResult(rsvNo, itemCd, results, ref suffix, ref result);

            // サフィックスと検査結果を返す
            return Ok(new { suffix, result });
        }

        /// <summary>
        /// 検索条件を満たすグループの一覧を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="rslQue">結果問診フラグ</param>
        [HttpGet("{rsvNo}/inquiries")]
        [ProducesResponseType(404)]
        [ProducesResponseType(typeof(List<dynamic>), 200)]
        public IActionResult GetInquiryRslList(string rsvNo, RslQue rslQue)
        {
            List<dynamic> list = resultDao.SelectInquiryRslList(rsvNo, rslQue);

            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定対象受診者の検査結果を取得する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="hisCount">表示歴数</param>
        /// <param name="grpCd">グループコード</param>
        [HttpGet("/api/v1/people/{perId}/cslresults")]
        [ProducesResponseType(404)]
        [ProducesResponseType(200)]
        public IActionResult GetInqHistoryRslList(string perId, DateTime cslDate, string hisCount, string grpCd)
        {
            dynamic data = resultDao.SelectInqHistoryRslList(perId, cslDate, hisCount, grpCd);

            if (data == null)
            {
                return NotFound();
            }
            return Ok(data);
        }
    }
}
