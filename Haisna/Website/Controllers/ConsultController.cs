using Hainsi.Entity;
using Hainsi.Entity.Model.Consultation;
using Hainsi.Entity.Model.Consult;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// Consultコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/consultations")]
    public class ConsultController : Controller
    {
        const string SORT_DAYID = "";       // 当日ＩＤ順

        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly ConsultDao consultDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="consultDao">データアクセスオブジェクト</param>
        public ConsultController(ConsultDao consultDao)
        {
            this.consultDao = consultDao;
        }

        /// <summary>
        /// 受付を取り消す
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="force"></param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpDelete("/api/v1/receptions/{rsvNo}")]
        public IActionResult CancelReceipt(int rsvNo, DateTime cslDate, bool force = false)
        {
            // 更新者
            // 本来はセッションから取得する #ToDo
            // string updUser = HttpContext.Session.GetString("userid");
            string updUser = "0";

            int ret = consultDao.CancelReceipt(rsvNo, updUser, cslDate, out string message, force);

            if (!string.IsNullOrEmpty(message))
            {
                return BadRequest(new { errors = new[] { message } });
            }

            return NoContent();
        }

        /// <summary>
        /// 一括で受付を取り消す
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="cntlNo">管理番号</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="force">true指定時は結果の有無に関わらず強制的に削除</param>
        /// <response code="200">成功</response>
        [HttpDelete("~/api/v1/receptions")]
        public IActionResult CancelReceiptAll(DateTime cslDate, int cntlNo, string csCd, bool force = false)
        {
            // 更新者
            string updUser = HttpContext.Session.GetString("userid");

            int ret = consultDao.CancelReceiptAll(updUser, cslDate, cntlNo, csCd, force);

            return Ok(ret);
        }

        /// <summary>
        /// 年度内に２回目予約を行う場合、ワーニング対応
        /// </summary>
        /// <param name="perId">個人ID</param>
        /// <param name="cslDate">保存したい受診日</param>
        /// <param name="csCd">保存したいコースコード</param>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="rsvNo">保存対象となる受診情報の予約番号</param>
        /// <param name="fRsv"></param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpGet("{perId}/{csCd}/{orgCd1}/{orgCd2}/consultationscheckresults")]
        public IActionResult CheckConsultCtr(string perId, DateTime cslDate, string csCd, string orgCd1, string orgCd2,
            int? rsvNo = null, int fRsv = 0)
        {
            string message = consultDao.CheckConsult_Ctr(perId, cslDate, csCd, orgCd1, orgCd2, rsvNo, fRsv);

            if (!string.IsNullOrEmpty(message))
            {
                return BadRequest(message);
            }

            return NoContent();
        }

        /// <summary>
        /// お連れ様情報の削除を行う
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="seq">お連れ様Seq</param>
        /// <response code="204">成功</response>
        [HttpDelete("/api/v1/friends")]
        public IActionResult DeleteFriends(DateTime cslDate, int seq)
        {
            consultDao.DeleteFriends(cslDate, seq);

            return NoContent();
        }

        /// <summary>
        /// 1件単位の受付を行う
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="mode">受付しない、1:最終番号の次IDで受付、2:欠番を検索して発番、3:ID直接指定)</param>
        /// <param name="data">
        /// cslDate 受診年月日
        /// cntlNo  管理番号
        /// dayId   当日ID(受付処理モード=3の場合のみ有効)
        /// </param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        /// <response code="404">データなし</response>
        [HttpPost("/api/v1/receptions/{rsvNo}")]
        public IActionResult Receipt(int rsvNo, int mode, [FromBody] JToken data)
        {
            DateTime cslDate = Convert.ToDateTime(data["csldate"]);
            string updUser = HttpContext.Session.GetString("userId");
            int cntlNo = Convert.ToInt32(data["cntlno"]);
            int dayId = Convert.ToInt32(data["dayid"]);
            string ipAddress = HttpContext.Connection.RemoteIpAddress.ToString();

            int ret = consultDao.Receipt(rsvNo, cslDate, updUser, mode, cntlNo, dayId, ipAddress, out string message);

            // 更新対象が存在しなければ404を返す
            if (ret == 0)
            {
                return NotFound();
            }

            if (!string.IsNullOrEmpty(message))
            {
                return BadRequest(message);
            }

            return NoContent();
        }

        /// <summary>
        /// 一括受付を行う
        /// </summary>
        /// <param name="data">
        /// </param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("~/api/v1/receptions")]
        public IActionResult ReceiptAll([FromBody] ReceiptAll data)
        {
            DateTime cslDate = data.CslDate;
            int mode = data.Mode;
            int cntlNo = data.CntlNo;
            string csCd = data.CsCd;
            string ipAddress = HttpContext.Connection.RemoteIpAddress.ToString();
            string updUser = HttpContext.Session.GetString("userId");

            int ret = consultDao.ReceiptAll(mode, cslDate, cntlNo, csCd, ipAddress, updUser);
            if (ret == -14) {
                return BadRequest("発番可能な最大番号に達しました。一括受付できません。");
            } else if (ret < 0) {
                return BadRequest("一括受付処理で異常が発生しました。（" + ret + "）");
            }

            return NoContent();
        }

        /// <summary>
        /// 指定予約番号の受診情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="cancelFlg">キャンセルフラグ</param>
        /// <param name="recordLock">レコードロックを行うか</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}", Name = "GetByRsvNo")]
        public IActionResult GetConsult(int rsvNo, int? cancelFlg = null, bool recordLock = false)
        {
            dynamic data = consultDao.SelectConsult(rsvNo, cancelFlg, recordLock);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定予約番号の受診オプション管理情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="hideKbn">指定画面の非表示項目を除く(1:予約枠画面、2:予約画面、3:受付画面、4:問診画面)</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/options")]
        public IActionResult GetConsultO(int rsvNo, int hideKbn = 0)
        {
            IList<dynamic> items = consultDao.SelectConsult_O(rsvNo, hideKbn);

            // データ件数が0件の場合
            if (items == null || items.Count <= 0)
            {
                return NotFound();
            }

            return Ok(items);
        }

        /// <summary>
        /// 受診情報テーブルから受診付属情報を読み込む
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/detail")]
        public IActionResult GetConsultDetail(int rsvNo)
        {
            dynamic data = consultDao.SelectConsultDetail(rsvNo);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 受付情報をもとに受診情報を読み込む
        /// </summary>
        /// <param name="cslDate">(受付情報の)受診日</param>
        /// <param name="cntlNo">管理番号</param>
        /// <param name="dayId">当日ID</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("/api/v1/receptions")]
        public IActionResult GetConsultFromReceipt(DateTime cslDate, int cntlNo, string dayId)
        {
            dynamic data = consultDao.SelectConsultFromReceipt(cslDate, cntlNo, dayId);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定された個人IDの受診歴一覧を取得する
        /// </summary>
        /// <param name="perId">個人ID</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="receptOnly">true指定時は受付済み受診情報のみを取得対象とする</param>
        /// <param name="firstCourseOnly">true指定時は１次健診のみを取得対象とする</param>
        /// <param name="getRowCount">取得件数(未指定時は全件)</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("/api/v1/people/{perId}/consultations")]
        public IActionResult GetConsultHistory(string perId, DateTime? cslDate = null, bool receptOnly = false,
            bool firstCourseOnly = false, int getRowCount = 0)
        {
            PartialDataSet ds = consultDao.SelectConsultHistory(perId, cslDate, receptOnly, firstCourseOnly, getRowCount);

            // データ件数が0件の場合
            if (ds.Data.Count == 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// 検索条件を満たす受診者の一覧を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="cntlNo">管理番号</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="startDayId">開始当日ID</param>
        /// <param name="endDayId">終了当日ID</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="page">開始位置</param>
        /// <param name="limit">取得件数</param>
        /// <param name="sortKey">ソート順</param>
        /// <param name="needUnReceiptConsult">未受付者取得フラグ</param>
        /// <param name="badJudgemnetOnly">異常判定所持者取得フラグ</param>
        /// <param name="notCompletedJudgemnetOnly">判定未完了者取得フラグ</param>
        /// <param name="entryStatus">結果入力状態("1":未検査未完了者のみ、"2":検査完了者のみ)</param>
        /// <param name="entriedJudgement">判定入力状態</param>
        /// <param name="rsvGrpCd">予約群コード</param>
        /// <param name="comeOnly">true時は来院者のみ取得(このときneedUnReceiptConsult値は無効)</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetConsultList(DateTime cslDate, int cntlNo, string csCd, int? startDayId = null,
            int? endDayId = null, string grpCd = null, int page = 0, int limit = 0, string sortKey = SORT_DAYID,
            bool needUnReceiptConsult = false, bool badJudgemnetOnly = false, bool notCompletedJudgemnetOnly = false,
            string entryStatus = null, bool entriedJudgement = false, int? rsvGrpCd = null, bool comeOnly = false)
        {
            // 検索条件を満たしかつ指定開始位置、件数分のレコードを取得
            int startPos = 0;
            if (page > 0)
            {
                startPos = (page - 1) * limit + 1;
            }

            PartialDataSet ds = consultDao.SelectConsultList(cslDate, cntlNo, csCd, startDayId, endDayId, grpCd,
              startPos, limit, sortKey, needUnReceiptConsult, badJudgemnetOnly, notCompletedJudgemnetOnly,
              entryStatus, entriedJudgement, rsvGrpCd, comeOnly);

            // データ件数が0件の場合
            if (ds.Data.Count == 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// 検索条件を満たす受診者の一覧を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="cntlNo">管理番号</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="startDayId">開始当日ID</param>
        /// <param name="endDayId">終了当日ID</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="startPos">開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <param name="sortKey">ソート順</param>
        /// <param name="needUnReceiptConsult">未受付者取得フラグ</param>
        /// <param name="badJudgemnetOnly">異常判定所持者取得フラグ</param>
        /// <param name="notCompletedJudgemnetOnly">判定未完了者取得フラグ</param>
        /// <param name="entryStatus">結果入力状態("1":未検査未完了者のみ、"2":検査完了者のみ)</param>
        /// <param name="entriedJudgement">判定入力状態</param>
        /// <param name="entriedJudgementM">判定入力状態(手動分)</param>
        /// <param name="rsvGrpCd">予約群コード</param>
        /// <param name="comeOnly">true時は来院者のみ取得(このときneedUnReceiptConsult値は無効)</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("progresses")]
        public IActionResult GetConsultListProgress(DateTime cslDate, int cntlNo, string csCd = null, int? startDayId = null, int? endDayId = null,
            string grpCd = null, int startPos = 0, int getCount = 0, string sortKey = SORT_DAYID, bool needUnReceiptConsult = false,
            bool badJudgemnetOnly = false, bool notCompletedJudgemnetOnly = false, string entryStatus = null,
            bool entriedJudgement = false, bool entriedJudgementM = false, int? rsvGrpCd = null, bool comeOnly = false)
        {
            PartialDataSet ds = consultDao.SelectConsultListProgress(cslDate, cntlNo, csCd, startDayId, endDayId,
                grpCd, startPos, getCount, sortKey, needUnReceiptConsult, badJudgemnetOnly, notCompletedJudgemnetOnly,
                entryStatus, entriedJudgement, entriedJudgementM, rsvGrpCd, comeOnly);

            // データ件数が0件の場合
            if (ds.Data.Count == 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// 指定予約番号、SEQの受診情報ログを取得します。
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="seq">SEQ</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/logs")]
        public IActionResult GetConsultLog(int rsvNo, int seq)
        {
            dynamic data = consultDao.SelectConsultLog(rsvNo, seq);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定条件を満たす受診情報ログを取得します。
        /// </summary>
        /// <param name="startDate">開始処理日</param>
        /// <param name="endDate">終了処理日</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="updUser">更新者</param>
        /// <param name="orderByItem">ソート項目</param>
        /// <param name="orderByMode">ソート方向</param>
        /// <param name="startPos">検索開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("logs")]
        public IActionResult GetConsultLogList(DateTime startDate, DateTime endDate,
            int rsvNo, string updUser, int orderByItem, int orderByMode, int startPos, int getCount)
        {
            // 検索条件を満たしかつ指定開始位置、件数分のレコードを取得
            startPos = (startPos - 1) * getCount + 1;
            PartialDataSet ds = consultDao.SelectConsultLogList(startDate, endDate, rsvNo, updUser, orderByItem, orderByMode, startPos, getCount);

            // データ件数が0件の場合
            if (ds.Data.Count == 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// 指定予約番号の出力情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/printstatus")]
        public IActionResult GetConsultPrintStatus(int rsvNo)
        {
            dynamic data = consultDao.SelectConsultPrintStatus(rsvNo);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 検索予約番号の前後の予約番号および当日IDを取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="sortKey">並び順</param>
        /// <param name="cntlNo">管理番号</param>
        /// <param name="needUnReceiptConsult">未受付者取得フラグ</param>
        /// <param name="badJudgemnetOnly">異常判定所持者取得フラグ</param>
        /// <param name="notCompletedJudgemnetOnly">判定未完了者取得フラグ</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="comeOnly">true時は来院者のみ取得(このときneedUnReceiptConsult値は無効)</param>
        /// <response code="200">成功</response>
        [HttpGet("{rsvNo}/neighbors")]
        public IActionResult GetCurRsvNoPrevNext(DateTime cslDate, string csCd, string sortKey, int cntlNo,
            bool needUnReceiptConsult, bool badJudgemnetOnly, bool notCompletedJudgemnetOnly, int rsvNo, bool comeOnly = false)
        {
            consultDao.SelectCurRsvNoPrevNext(cslDate, csCd, sortKey, cntlNo, needUnReceiptConsult, badJudgemnetOnly,
                notCompletedJudgemnetOnly, rsvNo, out int? prevRsvNo, out int? prevDayId, out int? nextRsvNo, out int? nextDayId, comeOnly);

            var ds = new Dictionary<string, Object>
                        {
                            { "prevrsvno", prevRsvNo },
                            { "prevdayid", prevDayId },
                            { "nextrsvno", nextRsvNo },
                            { "nextdayid", nextDayId }
                        };

            return Ok(ds);
        }

        /// <summary>
        /// 検索条件を満たす受診者の一覧を取得する
        /// </summary>
        /// <param name="key">検索キー</param>
        /// <param name="startCslDate">開始受診日</param>
        /// <param name="endCslDate">終了受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="itemCd">依頼項目コード</param>
        /// <param name="entry">結果入力状態("":指定なし、"1":未入力のみ表示、"2":入力済みのみ表示)</param>
        /// <param name="sortKey">ソートキー</param>
        /// <param name="sortType">ソート順(0:昇順、1:降順)</param>
        /// <param name="startPos">取得開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <param name="printFields">表示項目</param>
        /// <param name="rsvStat">予約状態("1":キャンセルのみ、"2":予約のみ、"3":受付のみ)</param>
        /// <param name="rptStat">来院状態("1":未来院、"2":来院済み)</param>
        /// <param name="cslDivCd">受診区分コード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("/api/v1/search")]
        public IActionResult GetDailyList(string key, DateTime? startCslDate, DateTime? endCslDate, string csCd, string orgCd1,
            string orgCd2, string grpCd, string itemCd, string entry, int sortKey, int sortType, int startPos, int getCount,
            String printFields, string rsvStat = null, string rptStat = null, string cslDivCd = null)
        {
            String[] fields = new String[0];
            if (printFields != null) fields = Newtonsoft.Json.JsonConvert.DeserializeObject<String[]>(printFields);
            PartialDataSet ds = consultDao.SelectDailyList(key, startCslDate, endCslDate, csCd, orgCd1, orgCd2, grpCd,
                itemCd, entry, fields, sortKey, sortType, startPos, getCount, rsvStat, rptStat, cslDivCd);

            // データ件数が0件の場合
            if (ds.Data == null || ds.Data.Count == 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// お連れ様情報を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("/api/v1/friends")]
        public IActionResult GetFriends(DateTime cslDate, int? rsvNo = null)
        {
            IList<dynamic> items = consultDao.SelectFriends(cslDate, rsvNo);

            // データ件数が0件の場合
            if (items == null || items.Count <= 0)
            {
                return NotFound();
            }

            return Ok(items);
        }

        /// <summary>
        /// 指定予約番号の受付情報を読む
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="recordLock">レコードロックを行うか</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("/api/v1/receptions/{rsvNo}")]
        public IActionResult GetReceipt(int rsvNo, bool recordLock = false)
        {
            dynamic data = consultDao.SelectReceipt(rsvNo, recordLock);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 検索条件を満たす受診者の個人情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/basics")]
        public IActionResult GetRslConsult(int rsvNo)
        {
            dynamic data = consultDao.SelectRslConsult(rsvNo);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 来院情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/visits")]
        public IActionResult GetWelComeInfo(int rsvNo)
        {
            dynamic data = consultDao.SelectWelComeInfo(rsvNo);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 受診時追加検査項目テーブルの更新
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="data">入力データ</param>
        [HttpPut("{rsvNo}/items")]
        [ProducesResponseType(204)]
        public IActionResult SetConsultI(int rsvNo, [FromBody] UpdateConsultationItemsModel data)
        {
            // IPアドレス
            string ipAddress = HttpContext.Connection.RemoteIpAddress.ToString();

            // 更新者
            // 本来はセッションから取得する
            //string updUser = HttpContext.Session.GetString("userId");
            string updUser = "0";

            // 検査項目コード
            string[] itemCd = data.Items?.Keys.Select(x => x.ToString()).ToArray();

            // 受診状態
            string[] consults = data.Items?.Values.Select(x => x == 1 ? "1" : "0").ToArray();

            consultDao.SetConsult_I(rsvNo, ipAddress, updUser, itemCd, consults);

            return NoContent();
        }

        /// <summary>
        /// 受診オプションテーブルレコードを更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="data">
        /// optCd         オプションコード
        /// optBranchNo   オプション枝番
        /// consults      受診要否
        /// </param>
        [HttpPut("{rsvNo}/options")]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        [ProducesResponseType(404)]
        public IActionResult UpdateConsultO(int rsvNo, int ctrPtCd, [FromBody] UpdateConsultOptionModel data)
        {
            // IPアドレス
            string ipAddress = HttpContext.Connection.RemoteIpAddress.ToString();

            // 更新者
            string updUser = HttpContext.Session.GetString("userId");
            updUser = "HAINS$";

            // 予約枠無視フラグ
            int ignoreFlg = Convert.ToInt32(HttpContext.Session.GetString("ignoreFlg"));

            // オプションコード
            string[] optCd = data.OptCd;

            // オプション枝番
            int[] optBranchNo = data.OptBranchNo;

            // 受診要否
            string[] consults = data.Consults;

            int ret = consultDao.UpdateConsult_O(rsvNo, ctrPtCd, optCd, optBranchNo, consults, ipAddress, updUser, ignoreFlg, out string message);

            // 更新対象が存在しなければ404を返す
            if (ret == 0)
            {
                return NotFound();
            }

            if (!"".Equals(message) && !"null".Equals(message))
            {
                return BadRequest(message);
            }

            return Ok();
        }

        /// <summary>
        /// はがき出力日時、一式書式出力日時を更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="data">入力データ</param>
        /// <response code="204">成功</response>
        [HttpPut("{rsvNo}/printstatus")]
        [ProducesResponseType(204)]
        public IActionResult UpdateConsultPrintStatus(int rsvNo, [FromBody] PrintStatusModel data)
        {
            consultDao.UpdateConsultPrintStatus(rsvNo, data.CardPrintDate, data.FormPrintDate);

            return NoContent();
        }

        /// <summary>
        /// お連れ様情報テーブルを更新する
        /// </summary>
        /// <param name="data">入力値</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("/api/v1/friends")]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(IList<string>), 400)]
        public IActionResult UpdateFriends([FromBody] UpdateFriendsModel data)
        {
            // メッセージ
            IList<string> messages = new List<string>();

            consultDao.UpdateFriends(data.CslDate, data.Seq, data.RsvNo, data.SameGrp1, data.SameGrp2, data.SameGrp3, ref messages, data.PerId, data.CompPerId);

            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            return NoContent();
        }

        /// <summary>
        /// 来院情報を更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="mode">処理モード(0:全て, 1:当日ID, 2:来院, 3:OCR番号, 4:ロッカーキー)</param>
        /// <param name="dayId">当日ID</param>
        /// <param name="welCome">来院(0:無処理, 1:来院状態にする, 2:来院状態を解除する)</param>
        /// <param name="ocrNo">OCR番号</param>
        /// <param name="lockerKey">ロッカーキー</param>
        /// <param name="force">強制来院取消フラグ</param>
        /// <response code="200">成功</response>
        /// <response code="400">リクエスト不正</response>
        /// <response code="404">データなし</response>
        [HttpPut("{rsvNo}/visits")]
        public IActionResult UpdateWelComeInfo(int rsvNo, int mode, int? dayId, int? welCome = null,
            string ocrNo = null, string lockerKey = null, string force = null)
        {
            // 更新者
            string updUser = HttpContext.Session.GetString("userId");
            updUser = "HAINS$";
            bool ret = consultDao.UpdateWelComeInfo(rsvNo, mode, updUser, dayId, out int? visitStatus, out string message, welCome, ocrNo, lockerKey, force);

            // 更新対象が存在しなければ404を返す
            if (!ret)
            {
                return NotFound();
            }

            if (!string.IsNullOrEmpty(message))
            {
                return BadRequest(message);
            }

            return Ok(visitStatus);
        }

        /// <summary>
        /// 受診情報を挿入する
        /// </summary>
        /// <param name="data">受診情報</param>
        [HttpPost]
        [ProducesResponseType(201)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult InsertConsult([FromBody] InsertConsultationModel data)
        {
            // バリデーション
            List<string> messages = consultDao.ValidateConsult(data);

            // エラーメッセージがあれば400を返す
            if (messages.Count > 0)
            {
                return BadRequest(new { errors = messages });
            }

            // IPアドレス
            string ipAddress = HttpContext.Request.HttpContext.Connection.RemoteIpAddress.ToString();

            // 本来はセッションから取得する
            // string updUser = HttpContext.Session.GetString("userId");
            string updUser = "0";

            int rsvNo = consultDao.InsertConsult(ipAddress, updUser, data, out string message);

            // エラーメッセージがあれば400を返す
            if (!string.IsNullOrEmpty(message))
            {
                return BadRequest(new { errors = new[] { message } });
            }

            dynamic consult = consultDao.SelectConsult(rsvNo);

            return CreatedAtRoute("GetByRsvNo", new { rsvNo }, consult);
        }

        /// <summary>
        /// 受診情報を更新する
        /// </summary>
        /// <param name="rsvNo">受診番号</param>
        /// <param name="data">受診情報</param>
        /// <returns></returns>
        [HttpPut("{rsvNo}")]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult UpdateConsult(int rsvNo, [FromBody] UpdateConsultationModel data)
        {
            // バリデーション
            List<string> messages = consultDao.ValidateConsult(data);

            // エラーメッセージがあれば400を返す
            if (messages.Count > 0)
            {
                return BadRequest(new { errors = messages });
            }

            // IPアドレス
            string ipAddress = HttpContext.Request.HttpContext.Connection.RemoteIpAddress.ToString();

            // 本来はセッションから取得する
            // string updUser = HttpContext.Session.GetString("userId");
            string updUser = "0";

            consultDao.UpdateConsult(rsvNo, ipAddress, updUser, data, out string message);

            // エラーメッセージがあれば400を返す
            if (!string.IsNullOrEmpty(message))
            {
                return BadRequest(new { errors = new[] { message } });
            }

            return NoContent();
        }

        /// <summary>
        /// 受付時の当日IDバリデーション
        /// </summary>
        /// <param name="data">入力値</param>
        [ProducesResponseType(200)]
        [ProducesResponseType(typeof(List<string>), 400)]
        [HttpPost("dayid/validation")]
        public IActionResult ValidateDayId([FromBody] RegisterDayIdModel data)
        {
            List<string> messages = consultDao.ValidateDayId(data);

            // エラーメッセージがあれば400を返す
            if (messages.Count > 0)
            {
                return BadRequest(new { errors = messages });
            }

            return Ok();
        }

        /// <summary>
        /// 受診情報挿入時のバリデーションのみ
        /// </summary>
        /// <param name="data">受診情報</param>
        [HttpPost("validation")]
        [ProducesResponseType(200)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult ValidateInsertConsult([FromBody] InsertConsultationModel data)
        {
            // バリデーション
            List<string> messages = consultDao.ValidateConsult(data);

            // エラーメッセージがあれば400を返す
            if (messages.Count > 0)
            {
                return BadRequest(new { errors = messages });
            }

            return Ok();
        }

        /// <summary>
        /// 受診情報更新時のバリデーションのみ
        /// </summary>
        /// <param name="rsvNo">受診番号</param>
        /// <param name="data">受診情報</param>
        [HttpPut("{rsvNo}/validation")]
        [ProducesResponseType(200)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult ValidateInsertConsult(int rsvNo, [FromBody] UpdateConsultationModel data)
        {
            // バリデーション
            List<string> messages = consultDao.ValidateConsult(data);

            // エラーメッセージがあれば400を返す
            if (messages.Count > 0)
            {
                return BadRequest(new { errors = messages });
            }

            return Ok();
        }

        /// <summary>
        /// 受診キャンセル処理
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="data">データ</param>
        [HttpPut("{rsvNo}/cancel")]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult CancelConsult(int rsvNo, [FromBody] CancelConsultationModel data)
        {
            // 本来はセッションから取得する
            // string updUser = HttpContext.Session.GetString("userId");
            string updUser = "0";

            consultDao.CancelConsult(rsvNo, updUser, data.CancelFlg, out string message, data.Force);

            // メッセージがある場合は400を返す
            if (!string.IsNullOrEmpty(message))
            {
                return BadRequest(new { errors = new[] { message } });
            }

            return NoContent();
        }

        /// <summary>
        /// 来院情報の入力チェック
        /// </summary>
        /// <param name="dayId">当日ID</param>
        /// <param name="ocrNo">OCR番号</param>
        /// <param name="lockerKey">ロッカーキー</param>
        /// <response code="200">成功</response>
        /// <response code="400">リクエスト不正</response>
        /// <response code="404">データなし</response>
        [HttpPut("check")]
        public IActionResult CheckWelComeInfo(int dayId, string ocrNo, string lockerKey)
        {
            String[] message = consultDao.CheckWelComeInfo(dayId, ocrNo, lockerKey);

            if (message != null)
            {
                return BadRequest(message);
            }

            return Ok();
        }

        /// <summary>
        /// 来院処理の入力チェック
        /// </summary>
        /// <param name="guidanceNo">ご案内書番号</param>
        /// <param name="ocrNo">OCR番号</param>
        /// <response code="200">成功</response>
        /// <response code="400">リクエスト不正</response>
        /// <response code="404">データなし</response>
        [HttpPut("registeredcheck")]
        public IActionResult CheckRegisteredWelComeInfo(string guidanceNo, string ocrNo)
        {
            String[] message = consultDao.CheckRegisteredWelComeInfo(guidanceNo, ocrNo);

            if (message != null)
            {
                return BadRequest(message);
            }

            return Ok();
        }

        /// <summary>
        /// 検索条件を満たす受診者の一覧を取得する(枠予約用)
        /// </summary>
        /// <param name="startRsvNo">開始予約番号</param>
        /// <param name="endRsvNo">終了予約番号</param>
        [HttpGet("range")]
        [ProducesResponseType(404)]
        [ProducesResponseType(typeof(SelectConsultListForFraRsvModel), 200)]
        public IActionResult SelectConsultListForFraRsv(int startRsvNo, int endRsvNo)
        {
            IList<dynamic> data = consultDao.SelectConsultListForFraRsv(startRsvNo, endRsvNo);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// キャンセル受診情報を復元する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ignoreFlg">予約枠無視フラグ</param>
        [ProducesResponseType(200)]
        [ProducesResponseType(typeof(String), 400)]
        [HttpPut("{rsvno}/restore")]
        public IActionResult RestoreConsult(int rsvNo, int ignoreFlg = 0)
        {
            String message = null;
            // 本来はセッションから取得する #ToDo
            // string updUser = HttpContext.Session.GetString("userid");
            String updUser = "HAINS$";
            int ret = consultDao.RestoreConsult(rsvNo, updUser, ref message, ignoreFlg);

            // データ件数が0件の場合
            if (message != null)
            {
                return BadRequest(message);
            }

            return Ok(ret);
        }
    }
}
