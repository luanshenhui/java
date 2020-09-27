using Hainsi.Entity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 請求書明細CSV作成用WebAPIコントローラークラス
    /// </summary>
    //[Authorize]
    [Route("api/v1/absenceorgbills")]
    public class AbsenceOrgBillController : Controller
    {
        /// <summary>
        /// 印刷ログ情報のプリントオブジェクト
        /// </summary>
        readonly AbsenceOrgBillDao absenceOrgBillDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="absenceOrgBillDao">印刷ログ情報のプリントオブジェクト</param>
        public AbsenceOrgBillController(AbsenceOrgBillDao absenceOrgBillDao)
        {
            this.absenceOrgBillDao = absenceOrgBillDao;
        }

        /// <summary>
        /// 請求書明細CSVを作成する
        /// </summary>
        /// <param name="strCloseDate">開始締め日</param>
        /// <param name="endCloseDate">終了締め日</param>
        /// <param name="billNo">請求書番号</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <response code="200">成功</response>
        [HttpGet]
        public IActionResult GetPrintAbsenceOrgBill(DateTime strCloseDate, DateTime endCloseDate, string billNo="", string orgCd1="", string orgCd2="")
        {
            // 更新User
            string updUser = HttpContext.Session.GetString("userId");

            JObject data = new JObject
            {
                ["strclosedate"] = strCloseDate,
                ["endclosedate"] = endCloseDate,
                ["userId"] = updUser
            };

            // 帳票ドキュメントファイルの作成
            long printseq = absenceOrgBillDao.PrintAbsenceOrgBill(data, billNo, orgCd1, orgCd2);

            return Ok(printseq);
        }

        /// <summary>
        /// 引数値の妥当性チェックを行う
        /// </summary>
        /// <param name="strCloseDate">開始締め日</param>
        /// <param name="endCloseDate">終了締め日</param>
        /// <param name="billNo">請求書番号</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpGet("validation")]
        public IActionResult CheckOrgBill(string strCloseDate, string endCloseDate, string billNo)
        {
            // 入力データバリデーション
            List<string> messages = absenceOrgBillDao.ValidateOrgBill(strCloseDate, endCloseDate, billNo);
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            return NoContent();
        }
    }
}
