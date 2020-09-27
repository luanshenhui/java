using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using Hainsi.Entity;
using System;
using Newtonsoft.Json.Linq;
using Hainsi.Common.Constants;
using Microsoft.AspNetCore.Http;
using Hainsi.Common;
using Hainsi.Entity.Model.Bill;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 請求書データコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/bills")]
    public class DemandController : Controller
    {
        /// <summary>
        /// 請求書データアクセスオブジェクト
        /// </summary>
        readonly DemandDao demandDao;

        /// <summary>
        /// 受診金額データアクセスオブジェクト
        /// </summary>
        readonly DecideAllConsultPriceDao decideAllConsultPriceDao;


        /// <summary>
        /// 請求スデータアクセスオブジェクト
        /// </summary>
        readonly DmdAddUpDao dmdAddUpDao;


        /// <summary>
        /// 請求締めデータアクセスオブジェクト
        /// </summary>
        readonly DmdAddUpControlDao dmdAddUpControlDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="demandDao">請求書データアクセスオブジェクト</param>
        /// <param name="decideAllConsultPriceDao">データアクセスオブジェクト</param>
        /// <param name="dmdAddUpDao">データアクセスオブジェクト</param>
        /// <param name="dmdAddUpControlDao">データアクセスオブジェクト</param>
        public DemandController(DemandDao demandDao, DecideAllConsultPriceDao decideAllConsultPriceDao, DmdAddUpDao dmdAddUpDao, DmdAddUpControlDao dmdAddUpControlDao)
        {
            this.demandDao = demandDao;
            this.decideAllConsultPriceDao = decideAllConsultPriceDao;
            this.dmdAddUpDao = dmdAddUpDao;
            this.dmdAddUpControlDao = dmdAddUpControlDao;
        }

        /// <summary>
        /// 入金情報検索条件の妥当性チェックを行う
        /// </summary>
        /// <param name="strYear">開始締め日(年)</param>
        /// <param name="strMonth">開始締め日(月)</param>
        /// <param name="strDay">開始締め日(日)</param>
        /// <param name="endYear">終了締め日(年)</param>
        /// <param name="endMonth">終了締め日(月)</param>
        /// <param name="endDay">終了締め日(日)</param>
        /// <param name="billNo">請求書番号</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("validation")]
        public IActionResult CheckValueDmdPaymentSearch(int strYear, int strMonth, int strDay,
                                                        int endYear, int endMonth, int endDay, string billNo)
        {
            DateTime strDate = new DateTime();
            DateTime endDate = new DateTime();

            List<string> messages = demandDao.CheckValueDmdPaymentSearch(strYear, strMonth, strDay, ref strDate,
                                                                         endYear, endMonth, endDay, ref endDate, billNo);

            // 入力データバリデーション
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            return NoContent();

        }



        /// <summary>
        /// 種別毎の選択状況チェック
        /// </summary>
        /// <param name="paymentDiv">入金種別</param>
        /// <param name="registerNo">レジ番号</param>
        /// <param name="cash">現金</param>
        /// <param name="paymentPrice">入金額</param>
        /// <param name="cardKind">カード種別</param>
        /// <param name="creditslipNo">伝票No</param>
        /// <param name="bankCode">金融機関コード</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("paymentdivisions/validation")]
        public IActionResult CheckValuePaymentDiv(string paymentDiv, string registerNo, string cash,
                                                string paymentPrice, string cardKind, string creditslipNo, string bankCode)
        {
            List<string> messages = demandDao.ValidatePaymentDiv(paymentDiv, registerNo, cash, paymentPrice, cardKind, creditslipNo, bankCode);

            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            return NoContent();
        }

        /// <summary>
        /// 入金情報検索条件の妥当性チェックを行う
        /// </summary>
        /// <param name="closeDate">締め日</param>
        /// <param name="billSeq">請求書SEQ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <param name="seq">入金SEQ</param>
        /// <param name="paymentYear">入金日（年）</param>
        /// <param name="paymentMonth">入金日（月）</param>
        /// <param name="paymentDay">入金日</param>
        /// <param name="paymentPrice">入金額</param>
        /// <param name="paymentDiv">入金種別</param>
        /// <param name="payNote">コメント</param>
        /// <response code="200">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("payments/validation")]
        public IActionResult CheckValuePayment(DateTime closeDate, int billSeq, int branchNo, string seq,
                                               int paymentYear, int paymentMonth, int paymentDay, string paymentPrice,
                                               string paymentDiv, string payNote)
        {
            DateTime paymentDate = new DateTime();

            List<string> messages = demandDao.CheckValuePayment(closeDate, billSeq, branchNo, seq, paymentYear,
                                                                 paymentMonth, paymentDay, ref paymentDate, paymentPrice, paymentDiv, payNote);

            // 入力データバリデーション
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            return NoContent();
        }

        /// <summary>
        /// パラメタチェック（発送日）
        /// </summary>
        /// <param name="sendYear">発送日(年)</param>
        /// <param name="sendMonth">発送日(月)</param>
        /// <param name="sendDay">発送日(日)</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("dispatches/validation")]
        public IActionResult CheckValueSendCheckDay(int sendYear, int sendMonth, int sendDay)
        {
            DateTime? dispatchDate = new DateTime();

            List<string> messages = demandDao.CheckValueSendCheckDay(sendYear, sendMonth, sendDay, ref dispatchDate);

            // 入力データバリデーション
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            return NoContent();
        }

        /// <summary>
        /// 請求書一括削除する
        /// </summary>
        /// <param name="closeDate">請求締め日</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <response code="204">成功</response>
        /// <response code="404">リクエスト不正</response>
        [HttpDelete]
        public IActionResult DeleteAllBill(DateTime closeDate, string orgCd1, string orgCd2)
        {

            int ret = demandDao.DeleteAllBill(closeDate, orgCd1, orgCd2);

            if (ret < 0)
            {
                return BadRequest(ret);
            }
            // 削除対象が存在しなければ404を返す
            if (ret == 0)
            {
                return NotFound(ret);
            }

            return Ok(ret);
        }

        /// <summary>
        /// 請求書を削除する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <response code="204">成功</response>
        /// <response code="404">リクエスト不正</response>
        [HttpDelete("{billNo}")]
        public IActionResult DeleteBill(string billNo)
    {
      int ret = demandDao.DeleteBill(billNo);
      List<string> messages = new List<string>();
      switch (ret)
      {
        case 2:
          messages.Add("請求書を取消伝票にしました。");
          break;
        case 1:
          messages.Add("請求書を削除しました。");
          break;
        case 0:
          messages.Add("該当する請求書がありません。");
          break;
        case -1:
          messages.Add("請求書の削除に失敗しました。");
          break;
      }
      return Ok(messages);
    }

        /// <summary>
        /// 請求明細を更新する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="lineNo">明細No</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <response code="204">成功</response>
        [HttpDelete("{billNo}/details")]
        public IActionResult DeleteBillDetail(string billNo, string lineNo, string rsvNo, string orgCd1, string orgCd2)
        {
            bool ret = demandDao.DeleteBillDetail(billNo, lineNo, rsvNo, orgCd1, orgCd2);

            return NoContent();
        }

        /// <summary>
        /// 請求書明細の登録する
        /// </summary>
        /// <param name="BillNo">請求書番号</param>
        /// <param name="data">請求書情報</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        /// <response code="409">リクエスト不正</response>
        [HttpPost("{BillNo}/details")]
        public IActionResult InsertBillDetail(string BillNo, [FromBody] BillDetail data)
        {

            // 入力データバリデーション
            List<string> messages = demandDao.ValidateBillDetail(data);

            if ((messages != null) && (messages.Count > 0))
            {
                for (int i = 0; i < messages.Count; i++)
                {
                    if (messages[i] != null)
                    {
                         return BadRequest(messages);
                    }
                }
            }

            // 新規レコード挿入
            Insert ret = demandDao.InsertBillDetail(data);

            if (ret == Insert.Duplicate)
            {
                return StatusCode(StatusCodes.Status409Conflict);
            }

            return NoContent();

        }

        /// <summary>
        /// 請求明細を更新する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="lineNo">明細No</param>
        /// <param name="data">発送情報</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        /// <response code="404">リクエスト不正</response>
        [HttpPut("{billNo}/details/{lineNo}")]
        public IActionResult UpdateBillDetail(string billNo, int lineNo, [FromBody] BillDetail data)
        {

            // 入力データバリデーション
            List<string> messages = demandDao.ValidateBillDetail(data);

            if ((messages != null) && (messages.Count > 0))
            {
                for (int i = 0; i < messages.Count; i++)
                {
                    if (messages[i] != null)
                    {
                         return BadRequest(messages);
                    }
                }
            }

            //更新実行
            Update ret = demandDao.UpdateBillDetail(data);

            // 更新対象が存在しなければ404を返す
            if (ret == Update.Error)
            {
                return NotFound();
            }

            return NoContent();
        }

        /// <summary>
        /// 請求明細を更新する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="lineNo">明細No</param>
        /// <param name="itemNo">内訳No</param>
        /// <response code="204">成功</response>
        /// <response code="404">リクエスト不正</response>
        [HttpDelete("{billNo}/details/{lineNo}/items/{itemNo}")]
        public IActionResult DeleteBillDetailItems(string billNo, int lineNo, int itemNo)
        {
            bool ret = demandDao.DeleteBillDetail_Items(billNo, lineNo, itemNo);

            // 更新対象が存在しなければ404を返す
            if (ret == false)
            {
                return NotFound();
            }

            return NoContent();

        }

        /// <summary>
        /// 請求書明細を登録する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="lineNo">明細No</param>
        /// <param name="data">請求書情報</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("{billNo}/details/{lineNo}/items")]
        public IActionResult InsertBillDetailItems(string billNo, int lineNo, [FromBody] UpdateBillDetailItems data)
        {
            // 入力データバリデーション
            List<string> messages = demandDao.ValidateBillDetailItems(data);

            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            // 新規レコード挿入
            Insert ret = demandDao.InsertBillDetail_Items(data);

            if (ret == Insert.Duplicate)
            {
                return StatusCode(StatusCodes.Status409Conflict);
            }

            return NoContent();
        }

        /// <summary>
        /// 請求明細を更新する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="lineNo">明細No.</param>
        /// <param name="itemNo">内訳No.</param>
        /// <param name="data">請求書情報</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        /// <response code="404">リクエスト不正</response>
        [HttpPut("{billNo}/details/{lineNo}/items/{itemNo}")]
        public IActionResult UpdateBillDetailItems(string billNo, int lineNo, int itemNo, [FromBody] UpdateBillDetailItems data)
        {

            // 入力データバリデーション
            List<string> messages = demandDao.ValidateBillDetailItems(data);

            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            //更新実行
            Update ret = demandDao.UpdateBillDetail_Items(data);

            // 更新対象が存在しなければ404を返す
            if (ret == Update.Error)
            {
                return NotFound();
            }

            return NoContent();
        }

        /// <summary>
        /// 発送情報を削除する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="seq">発送SEQ</param>
        /// <response code="204">成功</response>
        [HttpDelete("{billNo}/dispatches/{seq}")]
        public IActionResult DeleteDispatch(string billNo, int seq)
        {
            bool ret = demandDao.DeleteDispatch(billNo, seq);

            return NoContent();
        }

        /// <summary>
        /// 請求書明細を登録する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="data">請求書情報 </param >
        /// <response code="204">成功</response>
        /// <response code="409">リクエスト不正</response>
        [HttpPost("{billNo}/dispatches")]
        public IActionResult InsertDispatch(string billNo, [FromBody] JToken data)
        {
            data["upduser"] = HttpContext.Session.GetString("userId");

            // 新規レコード挿入
            Insert ret = demandDao.InsertDispatch(billNo, data);

            if (ret == Insert.Duplicate)
            {
                return StatusCode(StatusCodes.Status409Conflict);
            }

            return NoContent();
        }

        /// <summary>
        /// 発送情報を更新する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="seq">SEQ</param>
        /// <param name="data">発送情報</param>
        /// <response code="204">成功</response>
        /// <response code="409">リクエスト不正</response>
        [HttpPut("{billNo}/dispatches/{seq}")]
        public IActionResult UpdateDispatch(string billNo, int seq, [FromBody] JToken data)
        {
            data["upduser"] = HttpContext.Session.GetString("userId");

            //更新実行
            bool ret = demandDao.UpdateDispatch(billNo, seq, data);

            return NoContent();
        }

        /// <summary>
        /// 入金情報を削除する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="seq">SEQ</param>
        /// <response code="204">成功</response>
        [HttpDelete("{billNo}/payments/{seq}")]
        public IActionResult DeletePayment(string billNo, int seq)
        {
            bool ret = demandDao.DeletePayment(billNo, seq);

            return NoContent();
        }

        /// <summary>
        /// 入金情報を挿入する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="data">請求書情報 </param>
        /// <response code="204">成功</response>
        /// <response code="409">リクエスト不正</response>
        [HttpPost("{billNo}/payments")]
        public IActionResult InsertPayment(string billNo, [FromBody] InsertPayment data)
        {
            	
            data.Upduser = HttpContext.Session.GetString("userId");
            data.Upduser = "HAINS$";
            // 新規レコード挿入
            Insert ret = demandDao.InsertPayment(billNo, data);
            if (ret == Insert.Duplicate)
            {
                return StatusCode(StatusCodes.Status409Conflict);
            }

            return NoContent();
        }

        /// <summary>
        /// 入金情報更新する
        /// </summary>
        /// <param name="billNo">請求書No</param>
        /// <param name="seq">SEQ</param>
        /// <param name="data">入金情報</param>
        /// <response code="204">成功</response>
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        [HttpPut("{billNo}/payments/{seq}")]
        public IActionResult UpdatePayment(string billNo, int seq, [FromBody] UpdatePayment data)
        {
            // data.Upduser = HttpContext.Session.GetString("userId");
            data.Upduser = "HAINS$";
            //更新実行
            bool ret = demandDao.UpdatePayment(billNo, seq, data);

            return NoContent();
        }

        /// <summary>
        /// 発送Seqの最大値を取得する
        /// </summary>
        /// <param name="billNo">請求書No</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{billNo}/dispatches/max")]
        public IActionResult GetDispatchSeqMax(string billNo)
        {
            dynamic data = demandDao.GetDispatchSeqMax(billNo);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 入金情報を取得する
        /// </summary>
        /// <param name="billNo">請求書No</param>
        /// <param name="seq">入金Seq</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{billNo}/payments/{seq}/price")]
        public IActionResult GetDmdPaymentPrice(string billNo, int seq)
        {
            dynamic data = demandDao.GetDmdPaymentPrice(billNo, seq);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 検索条件を満たす発送日の一覧を取得する
        /// </summary>
        /// <param name="billNo">請求書コード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{billNo}/dispatches")]
        public IActionResult GetDmdBurdenDispatch(string billNo)
        {
            List<dynamic> data = demandDao.SelectDmdBurdenDispatch(billNo);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 検索条件を満たす受診者の一覧を取得する(請求書検索)
        /// </summary>
        /// <param name="strDate">開始締め日</param>
        /// <param name="endDate">終了締め日</param>
        /// <param name="billNo">請求書コード</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="isDispatch">請求書発送状態</param>
        /// <param name="isPayment">入金状態）</param>
        /// <param name="isCancel">取消伝票表示（1:表示）</param>
        /// <param name="startPos">SELECT開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <param name="sortName">ソート項目名</param>
        /// <param name="sortType">ソート順</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetDmdBurdenList(DateTime? strDate = null, DateTime? endDate = null,
                                              string billNo = null, string orgCd1 = null, string orgCd2 = null, int? isDispatch = null,
                                              int? isPayment = null, int? isCancel = null, int? startPos = null, int? getCount = null,
                                              int? sortName = null, int? sortType = null)
        {
            List<dynamic> burdenList = new List<dynamic>();

            int allCount = demandDao.SelectDmdBurdenList("CNT", out burdenList, strDate, endDate, billNo,
                                                     orgCd1, orgCd2, isDispatch, isPayment, isCancel);
            // データ件数が0件の場合
            if (allCount == 0)
            {
                return NotFound();
            }

            int count = demandDao.SelectDmdBurdenList("", out burdenList, strDate, endDate, billNo,
                                                     orgCd1, orgCd2, isDispatch, isPayment,
                                                     isCancel, startPos, getCount, sortName, sortType);

            // データ件数が0件の場合
            if (count == 0)
            {
                return NotFound();
            }

            // 受診者情報を追加する
            var result = new Dictionary<string, dynamic>
            {
                {"allcount", allCount },
                {"burdenlist", burdenList }
            };

            return Ok(result);
        }

        /// <summary>
        /// 発送情報取得する
        /// </summary>
        /// <param name="billNo">請求書No</param>
        /// <param name="seq">SEQ</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{billNo}/dispatches/{seq}")]
        public IActionResult GetDispatch(string billNo, int seq)
        {

            string data = demandDao.SelectDispatch(billNo, seq);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 検索条件を満たす請求明細情報を取得する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="lineNo">明細No</param>
        /// <param name="page">開始位置</param>
        /// <param name="limit">取得件数</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{billNo}/details")]
        public IActionResult GetDmdBurdenBillDetail(string billNo, string lineNo, int page = 1, int limit = 0)
        {
            int startPos = (page - 1) * limit;
            PartialDataSet ds = demandDao.SelectDmdBurdenBillDetail(billNo, lineNo, startPos, limit);

            // データ件数が0件の場合
            if (ds.TotalCount == 0)
            {
                return NotFound(ds);
            }

            return Ok(ds);
        }

        /// <summary>
        /// 検索条件を満たす請求明細内訳情報を集計する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="lineNo">明細No</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{billNo}/details/{lineNo}/items/total")]
        public IActionResult GetSumDetailItems(string billNo, int? lineNo = null)
        {

            List<dynamic> data = demandDao.SelectSumDetailItems(billNo, lineNo);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 検索条件を満たす請求書情報を取得する
        /// </summary>
        /// <param name="billNo">請求書No</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{billNo}/total")]
        public IActionResult GetDmdPaymentBillSum(string billNo)
        {

            dynamic data = demandDao.SelectDmdPaymentBillSum(billNo);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 修正時は入金情報を取得する
        /// </summary>
        /// <param name="billNo">請求書No</param>
        /// <param name="seq">SEQ</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{billNo}/payments/{seq}")]
        public IActionResult GetPayment(string billNo, int seq)
        {

            dynamic data = demandDao.SelectPayment(billNo, seq);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 検索条件を満たす入金、発送件数を取得する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{billNo}/count")]
        public IActionResult GetPaymentAndDispatchCnt(string billNo)
        {

            List<dynamic> data = demandDao.SelectPaymentAndDispatchCnt(billNo);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 検索条件を満たす請求明細情報を取得する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="lineNo">明細No</param>
        /// <param name="startPos">開始位置</param>
        /// <param name="limit">取得件数</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("details")]
        public IActionResult GetDmdBurdenModifyBillDetail(string billNo, string lineNo, int? startPos = null, int? limit = null)
        {
            List<dynamic> data = demandDao.SelectDmdBurdenModifyBillDetail(billNo, lineNo, startPos, limit);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }


        /// <summary>
        /// 検索条件を満たす請求明細情報を取得する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="lineNo">明細No</param>
        /// <param name="itemNo">内訳No</param>
        /// <param name="page">開始位置</param>
        /// <param name="limit">取得件数</param>>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("details/items")]
        public IActionResult GetDmdDetailItmList(string billNo, string lineNo, string itemNo, int page = 1, int limit = 0)
        {
            int startPos = (page - 1) * limit;
            PartialDataSet ds = demandDao.SelectDmdDetailItmList(billNo, lineNo, itemNo, startPos, limit);

            // データ件数が0件の場合
            if (ds.TotalCount == 0)
            {
                return NotFound(ds);
            }

            return Ok(ds);
        }

        /// <summary>
        /// 個人毎の締め管理情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/closings")]
        public IActionResult GetPersonalCloseMngInfo(int rsvNo)
        {
            List<dynamic> data = demandDao.SelectPersonalCloseMngInfo(rsvNo);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 締め管理情報取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/prices")]
        public IActionResult GetConsultmInfo(int rsvNo)
        {
            List<dynamic> data = demandDao.SelectConsult_mInfo(rsvNo);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 個人受診金額小計を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/prices/total")]
        public IActionResult GetConsultmTotal(int rsvNo)
        {
            List<dynamic> data = demandDao.SelectConsult_mTotal(rsvNo);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 追加検査項目負担金を更新する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="data">団体請求書情報</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("{billNo}/comment")]
        public IActionResult UpdateDmdBillComment(string billNo, [FromBody] PerBillComment data)
        {

            // 入力データバリデーション
            List<string> messages = demandDao.ValidateBillComment(Convert.ToString(data.BillComment));

            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            //更新実行
            bool ret = demandDao.UpdateDmdBill_comment(billNo, Convert.ToString(data.BillComment));

            return NoContent();
        }

        /// <summary>
        /// 請求締め処理入力値の妥当性チェックを行う
        /// </summary>
        /// <param name="closeYear">締め日(年)</param>
        /// <param name="closeMonth">締め日(月)</param>
        /// <param name="closeDay">締め日(日)</param>
        /// <param name="strYear">開始受診日(年)</param>
        /// <param name="strMonth">開始受診日(月)</param>
        /// <param name="strDay">開始受診日(日)</param>
        /// <param name="endYear">終了受診日(年)</param>
        /// <param name="endMonth">終了受診日(月)</param>
        /// <param name="endDay">終了受診日(日)  </param>
        /// <response code="200">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("close/validation")]
        public IActionResult CheckValueDmdAddUp(int closeYear, int closeMonth, int closeDay, int strYear, int strMonth, int strDay, int endYear, int endMonth, int endDay)
        {
            DateTime? closeDate, strDate, endDate;

            List<string> messages = dmdAddUpDao.CheckValueDmdAddUp(closeYear, closeMonth, closeDay, strYear, strMonth, strDay, endYear, endMonth, endDay, out closeDate, out strDate, out endDate);

            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            var ds = new Dictionary<string, DateTime?>
                        {
                            { "closedate",  closeDate},
                            { "strdate", strDate },
                            { "enddate", endDate }
                        };

            return Ok(ds);
        }

        /// <summary>
        /// 請求締め処理を起動する
        /// </summary>
        /// <param name="closeDate">締め日</param>
        /// <param name="strDate">開始受診日</param>
        /// <param name="endDate">終了受診日</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="courseCd">コースコード</param>
        /// <response code="200">成功</response>
        [HttpPost("close")]
        public IActionResult ExecuteDmdAddUp(DateTime closeDate, DateTime strDate, DateTime endDate, string orgCd1, string orgCd2, string courseCd)
        {
            int ret = dmdAddUpControlDao.ExecuteDmdAddUp(closeDate, strDate, endDate, orgCd1, orgCd2, courseCd);
            if (ret < 0)
            {
                return BadRequest();
            }
            return Ok(ret);
        }

        /// <summary>
        /// 指定予約番号の負担金額情報を取得する
        /// </summary>
        /// <param name="strDate">対象受診日開始日</param>
        /// <param name="endDate">対象受診日終了日</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="forceUpdate"> 1:受診金額を強制的に再作成</param>
        /// <param name="putLog"> 0:開始終了のみ、1:エラーのみ、2:全て</param>
        /// <response code="200">成功</response>
        [HttpPut("~/api/v1/consultations/prices")]
        public IActionResult DecideAllConsultPrice(DateTime strDate, DateTime endDate, string orgCd1, string orgCd2, int forceUpdate = 0, int putLog = 0)
        {
            int ret = decideAllConsultPriceDao.DecideAllConsultPrice(strDate, endDate, orgCd1, orgCd2, forceUpdate, putLog);

            return Ok(ret);
        }

        /// <summary>
        /// 請求書を挿入する
        /// </summary>
        /// <param name="data">挿入データ
        /// closedate  締め日
        /// orgcd1     団体コード１
        /// orgcd2     団体コード２
        /// prtdate    請求書出力日
        /// taxrates   適用税率
        /// secondflg  ２次検査フラグ
        /// </param>
        /// <returns>
        /// Insert.Normal    正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error     異常終了
        /// </returns>
        [HttpPost("bill")]
        public IActionResult InsertBill([FromBody] InsertBill data)
        {
            string closeYear = "";
            string closeMonth = "";
            string closeDay = "";
            DateTime? closeDate = null;
            if(data.CloseDate != null){ 
                 closeYear = Convert.ToString(data.CloseDate).Substring(0, 4);
                 closeMonth = Convert.ToString(data.CloseDate).Substring(5, 2);
                 closeDay = Convert.ToString(data.CloseDate).Substring(8, 2);
                 closeDate = Convert.ToDateTime(data.CloseDate);
            }
            string orgCd1 = data.OrgCd1;
            string orgCd2 = data.OrgCd2;
            string taxRates = data.TaxRates;
            object prtDate = data.PrtDate;


            // 入力データバリデーション
            List<string> messages = demandDao.CheckValueDmdOrgMasterBurden(
                closeYear,
                closeMonth,
                closeDay,
                ref closeDate,
                orgCd1,
                orgCd2,
                taxRates,
                ref prtDate
                );

            if ((messages != null) && (messages.Count > 0))
            {
                for (int i = 0; i < messages.Count; i++)
                {
                    if (messages[i] != null)
                    {
                         return BadRequest(messages);
                    }
                }
            }

            // 新規レコード挿入
            string billNo = "";
            Insert ret = demandDao.InsertBill(ref billNo, data);

            if (ret == Insert.Duplicate)
            {
                return StatusCode(StatusCodes.Status409Conflict);
            }

            return Ok(billNo);

        }

        /// <summary>
        /// 適用税率を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="errFlg">エラー時の扱い（0:エラーをもう一回引き起こす, 1:エラーメッセージを返す）</param>
        /// <returns>エラー時の扱い＝１の時、エラーメッセージを返す</returns>
        [HttpGet("{cslDate}")]
        public IActionResult getNowTax(string cslDate, int errFlg = 0)
        {
            // 適用税率取得
            double nowTax = 0;
            string ret = demandDao.GetNowTax(cslDate, ref nowTax, errFlg);
            return Ok(nowTax);
        }

    }
}
