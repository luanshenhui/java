using Hainsi.Entity;
using Hainsi.Entity.Model.Bill;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using Hainsi.Common;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// PerBillコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/perbills")]
    public class PerBillController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly PerBillDao perBillDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="perBillDao">データアクセスオブジェクト</param>
        public PerBillController(PerBillDao perBillDao)
        {
            this.perBillDao = perBillDao;
        }

        /// <summary>
        /// 個人請求書一覧を取得する
        /// </summary>
        /// <param name="sortKind">ソート種別</param>
        /// <param name="sortMode">ソートモード</param>
        /// <param name="paymentflg">1:未収のみ 0:全て</param>
        /// <param name="delDisp">1:取消伝票除く 0:全て</param>
        /// <param name="key">検索キー(空白で分割後のキー）</param>
        /// <param name="startDmdDate">検索条件請求日（開始）</param>
        /// <param name="endDmdDate">検索条件請求日（終了）</param>
        /// <param name="orgCd1">検索条件団体コード１</param>
        /// <param name="orgCd2">検索条件団体コード２</param>
        /// <param name="perId">検索条件個人ＩＤ</param>
        /// <param name="dmdDate">検索条件請求日</param>
        /// <param name="billSeq">検索条件請求書Ｓｅｑ</param>
        /// <param name="branchNo">検索条件請求書枝番</param>
        /// <param name="page">取得開始位置</param>
        /// <param name="pageMaxLine">１ページ表示ＭＡＸ行（０：ＭＡＸ行指定無し）</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetListPerBill(string[] key, int sortKind, int sortMode, int paymentflg, int delDisp, string startDmdDate, string endDmdDate
           , string branchNo, int pageMaxLine, string dmdDate, string billSeq, string orgCd1, string orgCd2, string perId, int page = 1)
        {
            string message = null;
            if (!(dmdDate == null && billSeq == null && branchNo == null))
            {
                if (dmdDate != null && dmdDate.Length <= 8)
                {
                    message = WebHains.CheckNumeric("請求書No", dmdDate, 14);
                    if (message == null && dmdDate.Length < 8 && dmdDate.Length > 0)
                    {
                        message = string.Format("{0}は{1}文字以内の半角数字で入力して下さい。", "請求書No", 14);
                    }
                    if (message == null && dmdDate.Length == 8)
                    {
                        dmdDate = dmdDate.Substring(0, 4) + "/" + dmdDate.Substring(4, 2) + "/" + dmdDate.Substring(6, 2);
                    }
                }
                if (message == null && billSeq != null && billSeq.Length <= 5)
                {
                    message = WebHains.CheckNumeric("請求書No", billSeq, 14);
                    if (message == null && billSeq.Length < 5 && billSeq.Length > 0)
                    {
                        message = string.Format("{0}は{1}文字以内の半角数字で入力して下さい。", "請求書No", 14);
                    }
                }
                if (message == null && branchNo != null && branchNo.Length <= 1)
                {
                    message = WebHains.CheckNumeric("請求書No", branchNo, 14);
                }
                else
                {
                    if (message == null && branchNo == null)
                    {
                        message = string.Format("{0}は{1}文字以内の半角数字で入力して下さい。", "請求書No", 14);
                    }
                }
            }
            
            if (message != null)
            {
                var messagesList = new List<string>
                {
                    message
                };
                return BadRequest(messagesList);
            }

            int startPos = (page - 1) * pageMaxLine;
            string buffer = "";
            if (key.Length > 0 && key[0] != null)
            {
                // 全角空白を半角空白に置換する
                buffer = key[0].Trim().Replace("　", " ");

                // 2バイト以上の半角空白文字が存在しなくなるまで置換を繰り返す
                do
                {
                    buffer = buffer.Replace("  ", " ");
                }
                while (buffer.IndexOf("  ") > -1);
                key = buffer.Split(' ');
            }

            PartialDataSet data = perBillDao.SelectListPerBill(sortKind, sortMode, paymentflg, delDisp, key, startDmdDate, endDmdDate,
                orgCd1, orgCd2, perId, dmdDate, billSeq, branchNo, startPos, pageMaxLine);

            // データ件数が0件の場合
            if (data == null || data.TotalCount == 0)
            {
                return NotFound();
            }
            return Ok(data);
        }

        /// <summary>
        /// 請求書新規作成処理
        /// </summary>
        /// <param name="data">個人請求書情報</param>
        /// <response code="201">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost]
        public IActionResult CreatePerBillPerson([FromBody] PerBillPerson data)
        {
            // 請求書コメントの妥当性チェックを行う
            List<string> messages = perBillDao.ValidateForCreatePerBill(data);
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            data.UpdUser = HttpContext.Session.GetString("userid");
            data.UpdUser = "HAINS$";

            // 新規レコード挿入
            int re_BillSeq = 0;
            int re_BranchNo = 0;
            bool ret = perBillDao.CreatePerBill_PERSON("insert", data, ref re_BillSeq, ref re_BranchNo);
            if (!ret)
            {
                return BadRequest();
            }
            // 受診者情報を追加する
            var result = new Dictionary<string, dynamic>
            {
                {"dmdDate", data.NewDmdDate.Year+"-"+data.NewDmdDate.Month+"-"+data.NewDmdDate.Day},
                {"billSeq", re_BillSeq },
                {"branchNo", re_BranchNo }
            };

            return Ok(result);
        }

        /// <summary>
        /// 請求書修正処理
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書Ｓｅｑ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <param name="data">個人請求書情報</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("{dmdDate}/{billSeq}/{branchNo}")]
        public IActionResult UpdatePerBillPerson(DateTime dmdDate, int billSeq, int branchNo, [FromBody] PerBillPerson data)
        {
            // 請求書コメントの妥当性チェックを行う
            List<string> messages = perBillDao.ValidateForCreatePerBill(data);
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            data.DMDDate = dmdDate.ToString();
            data.BillSeq = Convert.ToString(billSeq);
            data.BranchNo = Convert.ToString(branchNo);

            data.UpdUser = HttpContext.Session.GetString("userid");
            data.UpdUser = "HAINS$";

            // レコード更新
            int re_BillSeq = 0;
            int re_BranchNo = 0;
            bool ret = perBillDao.CreatePerBill_PERSON("update", data, ref re_BillSeq, ref re_BranchNo);
            if (!ret)
            {
                return BadRequest();
            }
            return NoContent();
        }

        /// <summary>
        /// 請求書の取り消し
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書Ｓｅｑ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpDelete("{dmdDate}/{billSeq}/{branchNo}")]
        public IActionResult DeletePerBill(DateTime dmdDate, int billSeq, int branchNo)
        {

            // bool ret = perBillDao.DeletePerBill(dmdDate, billSeq, branchNo, HttpContext.Session.GetString("userid"));
            bool ret = perBillDao.DeletePerBill(dmdDate, billSeq, branchNo, "HAINS$");

            if (!ret)
            {
                return BadRequest();
            }

            return NoContent();
        }

        /// <summary>
        /// 削除処理
        /// </summary>
        /// <param name="paymentDate">入金日</param>
        /// <param name="paymentSeq">入金Ｓｅｑ</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpDelete("{billSeq}/perpayments")]
        public IActionResult DeletePerPayment(DateTime paymentDate, int paymentSeq)
        {
            bool ret = perBillDao.DeletePerPayment(paymentDate, paymentSeq);

            if (!ret)
            {
                return BadRequest();
            }

            return NoContent();
        }

        /// <summary>
        /// 個人請求明細情報の登録
        /// </summary>
        /// <param name="data">個人請求明細情報</param>
        [HttpPost("details")]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult InsertPerBillc([FromBody] InsertPerBill_c data)
        {
            // 請求書コメントの妥当性チェックを行う
            List<string> messages = perBillDao.ValidateForOtherIncomeInfo(data);
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            if (data.BillCount == 0 || data.BillCount == 1)
            {
                // 個人請求書管理個人情報作成？
                if (data.Mode == "person")
                {
                    return NoContent();
                }
                // 受診確定金額情報、個人請求明細情報の登録
                bool ret = perBillDao.InsertPerBill_c(data);

                if (ret == false)
                {
                    // 保存に失敗した場合
                    messages.Add("セット外請求明細の追加に失敗しました。");
                    return BadRequest(messages);
                }

                return NoContent();
            }
            else
            {
                return NoContent();
            }
        }

        /// <summary>
        /// 個人入金情報テーブルにレコードを挿入する
        /// </summary>
        /// <param name="mode">1:入金　2:返金</param>
        /// <param name="data">個人入金情報</param>
        /// <response code="201">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("~/api/v1/perpayments")]
        [ProducesResponseType(201)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult InsertPerPayment(int mode, [FromBody] PerBillIncome data)
        {
            List<string> messages = perBillDao.Validate(data);
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            DateTime re_PaymentDate = new DateTime();
            int re_PaymentSeq = 0;

            //data.UpdUser = HttpContext.Session.GetString("userId");
            data.UpdUser = "HAINS$";
            messages = perBillDao.InsertPerPayment(mode, data, ref re_PaymentDate, ref re_PaymentSeq);

            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            List<dynamic> list = perBillDao.SelectPerPayment(re_PaymentDate, re_PaymentSeq);
            return CreatedAtRoute("GetPerPayment", new { paymentDate = data.DmdDateArray[0], paymentSeq = re_PaymentSeq }, list);
        }

        /// <summary>
        /// 更新処理
        /// </summary>
        /// <param name="mode">1:入金　2:返金</param>
        /// <param name="data">個人入金情報</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("~/api/v1/perpayments")]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult UpdatePerPayment(int mode, [FromBody] PerBillIncome data)
        {
            List<string> messages = perBillDao.Validate(data);

            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            //data.UpdUser = HttpContext.Session.GetString("userId");
            data.UpdUser = "HAINS$";
            messages = perBillDao.UpdatePerPayment(mode, data);

            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            return NoContent();
        }

        /// <summary>
        /// 請求書統合を行う
        /// </summary>
        /// <param name="data">請求書統合情報</param>
        /// <response code="204">成功</response>
        [HttpPost("merge")]
        public IActionResult MergePerBill([FromBody] MergePerBill data)
        {
            bool ret = perBillDao.MergePerBill(data);

            if (!ret)
            {
                return BadRequest();
            }

            return NoContent();
        }

        /// <summary>
        /// 予約番号をキーに個人受診情報の消費税を一括免除する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="204">成功</response>
        /// <response code="404">データなし</response>
        [HttpPut("~/api/v1/consultaions/{rsvNo}/tax/exempt")]
        public IActionResult OmitTaxSet(int rsvNo)
        {
            bool ret = perBillDao.OmitTaxSet(rsvNo);

            if (ret == false)
            {
                return NotFound();
            }

            return NoContent();
        }

        /// <summary>
        /// 入金Ｎｏから請求書Ｎｏと名前を取得する
        /// </summary>
        /// <param name="paymentDate">入金日</param>
        /// <param name="paymentSeq">入金Ｓｅｑ</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{paymentDate}/{paymentSeq}")]
        public IActionResult GetBillNoPayment(DateTime paymentDate, int paymentSeq)
        {
            List<dynamic> data = perBillDao.SelectBillNo_Payment(paymentDate, paymentSeq);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 同伴者請求書取得
        /// </summary>
        /// <param name="data">
        /// incsldate 受診日
        /// inrsvno   予約番号
        /// </param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpPost("friends")]
        public IActionResult GetFriendsPerBill([FromBody] JToken data)
        {
            List<dynamic> list = perBillDao.SelectFriendsPerBill(data);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// セット外請求明細を取得する
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/otherlineitems")]
        public IActionResult GetOtherLineDiv()
        {
            List<dynamic> list = perBillDao.SelectOtherLineDiv();

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 予約番号から個人請求書管理情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/perbills")]
        public IActionResult GetPerBill(int rsvNo)
        {
            List<dynamic> list = perBillDao.SelectPerBill(rsvNo);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 個人請求管理情報の取得
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書Ｓｅｑ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{dmdDate}/{billSeq}/{branchNo}")]
        public IActionResult GetPerBillBillNo(DateTime dmdDate, int billSeq, int branchNo)
        {
            List<dynamic> list = perBillDao.SelectPerBill_BillNo(dmdDate, billSeq, branchNo);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 請求書Ｎｏから個人請求明細情報を取得する
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書Ｓｅｑ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{dmdDate}/{billSeq}/{branchNo}/details")]
        public IActionResult GetPerBillc(string dmdDate, int billSeq, int branchNo)
        {
            List<dynamic> list = perBillDao.SelectPerBill_c(dmdDate, billSeq, branchNo);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 請求書Ｎｏから予約番号を取得しそれぞれの受信情報を取得する
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書Ｓｅｑ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{dmdDate}/{billSeq}/{branchNo}/consultations")]
        public IActionResult GetPerBillcsl(string dmdDate, int billSeq, int branchNo)
        {
            List<dynamic> list = perBillDao.SelectPerBill_csl(dmdDate, billSeq, branchNo);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 請求書Ｎｏから個人IDを取得しそれぞれの個人情報を取得する
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書Ｓｅｑ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{dmdDate}/{billSeq}/{branchNo}/people", Name = "GetPerBillPerson")]
        public IActionResult GetPerBillperson(string dmdDate, int billSeq, int branchNo)
        {
            List<dynamic> list = perBillDao.SelectPerBill_person(dmdDate, billSeq, branchNo);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 個人請求明細情報の取得
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書Ｓｅｑ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{dmdDate}/{billSeq}/{branchNo}/people/details")]
        public IActionResult GetPerBillPersonc(string dmdDate, int billSeq, int branchNo)
        {
            List<dynamic> list = perBillDao.SelectPerBill_Person_c(dmdDate, billSeq, branchNo);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 入金情報の取得
        /// </summary>
        /// <param name="paymentDate">入金日</param>
        /// <param name="paymentSeq">入金Ｓｅｑ</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/perpayments/{paymentDate}/{paymentSeq}", Name = "GetPerPayment")]
        public IActionResult GetPerPayment(DateTime paymentDate, int paymentSeq)
        {
            List<dynamic> list = perBillDao.SelectPerPayment(paymentDate, paymentSeq);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 受診確定金額情報、個人請求明細情報の登録
        /// </summary>
        /// <param name="data">個人請求書情報</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("fields")]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult UpdatePerBill([FromBody] PrtPerBill data)
        {
            List<string> messages = perBillDao.ValidateForPrtPerBill(data);
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            DateTime? printdate = null;
            if (data.Act.Equals("saveprt"))
            {
                if(data.PrtKbn.Equals("1"))
                {
                    printdate = DateTime.Now;
                }
            }

            for (int i = 0, len = data.DmddateArray.Length; i < len; i++)
            {
                bool result = perBillDao.UpdatePerBill(Convert.ToDateTime(data.DmddateArray[i]), Convert.ToInt32(data.BillseqArray[i]), Convert.ToInt32(data.BranchnoArray[i]),
                    data.BillNameArray[i], data.KeishouArray[i], printdate);

                if(!result)
                {
                    string dmddateFormat = Convert.ToDateTime(data.DmddateArray[i]).ToString("yyyyMMdd");
                    string billseq = "0000" + data.BillseqArray[i];
                    messages.Add("保存に失敗しました ( " + dmddateFormat + billseq.Substring(billseq.Length - 5) + data.BranchnoArray[i] + " )");
                    return BadRequest(messages);
                }
            }

            return NoContent();
        }

        /// <summary>
        /// 受診確定金額情報、個人請求明細情報の登録
        /// </summary>
        /// <param name="data">個人請求書情報</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("{dmdDate}/{billSeq}/{branchNo}/detail")]
        public IActionResult UpdatePerBillc([FromBody] UpdatePerBill_c data)
        {
            List<string> messages = perBillDao.ValidateForEditPerBillLine1(data);
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            bool result = perBillDao.UpdatePerBill_c(data);

            if (result == false)
            {
                // 保存に失敗した場合
                messages.Add("セット外請求明細の更新に失敗しました。");
                return BadRequest(messages);
            }

            return NoContent();
        }

        /// <summary>
        /// 請求書Ｎｏをキーに請求書コメントを更新する
        /// </summary>
        /// <param name="data">個人請求書情報</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("{dmdDate}/{billSeq}/{branchNo}/commnet")]
        public IActionResult UpdatePerBillcoment([FromBody] PerBillComment data)
        {
            List<string> messages = perBillDao.ValidateForPerBillComment(data);
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            bool result = perBillDao.UpdatePerBill_coment(data);
            if (!result)
            {
                var messagesList = new List<string> {
                    "請求書コメントの保存に失敗しました"
                };
                return BadRequest(messagesList);
            }

            return NoContent();
        }

        /// <summary>
        /// 名前を取得する
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書Ｓｅｑ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <response code="200">成功</response>
        [HttpGet("{dmdDate}/{billSeq}/{branchNo}/name")]
        public IActionResult GetName(string dmdDate, int billSeq, int branchNo)
        {
            List<dynamic> list = perBillDao.SelectPerBill_csl(dmdDate, billSeq, branchNo);

            if (list == null || list.Count <= 0)
            {
                list = perBillDao.SelectPerBill_person(dmdDate, billSeq, branchNo);
            }

            return Ok(list);
        }

        /// <summary>
        /// 受診情報から個人請求書を作成する
        /// </summary>
        /// <param name="data">個人請求書情報</param>
        /// <response code="201">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("csl")]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult CreatePerBillCSL([FromBody] CreatePerBill data)
        {
			// TODO
            data.UpdUser = HttpContext.Session.GetString("userId");
            data.UpdUser = "HAINS$";
            bool ret = perBillDao.CreatePerBill_CSL(data);

            if (!ret)
            {
                return BadRequest();
            }

            return NoContent();
        }

        /// <summary>
        /// セット外請求明細の削除を行う
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="priceSeq">受診金額Ｓｅｑ</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpDelete("{rsvNo}/{priceSeq}/detail")]
        public IActionResult DeletePerBillc(int rsvNo, int priceSeq)
        {
            bool ret = perBillDao.DeletePerBill_c(rsvNo, priceSeq);

            List<string> message = new List<string>();
            if (!ret)
            {
                message.Add("セット外請求明細の削除に失敗しました。");
                return BadRequest(message);
            }

            return NoContent();
        }
    }
}
