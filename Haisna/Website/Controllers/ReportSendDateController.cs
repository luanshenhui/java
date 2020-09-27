using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.Entity.Model.Report;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Hainsi.Controllers
{
    /// <summary>
    /// ReportSendDateコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/consultations")]
    public class ReportSendDateController : Controller
    {
        /// <summary>
        /// ReportSendDateアクセスオブジェクト
        /// </summary>
        readonly ReportSendDateDao reportSendDateDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="reportSendDateDao">ReportSendDateDaoアクセスオブジェクト</param>
        public ReportSendDateController(ReportSendDateDao reportSendDateDao)
        {
            this.reportSendDateDao = reportSendDateDao;
        }

        /// <summary>
        /// 予約番号を指定して最新の成績書出力情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/senthistories/last")]
        public IActionResult GetConsultReptSendLast(string rsvNo)
        {
            List<dynamic> ds = reportSendDateDao.SelectConsult_ReptSendLast(rsvNo);

            // データ件数が0件の場合
            if (ds == null || ds.Count <= 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// 検索条件を満たす成績書作成情報の一覧を取得する
        /// </summary>
        /// <param name="perId">検索キー</param>
        /// <param name="strCslDate">受診日（開始）</param>
        /// <param name="endCslDate">受診日（終了）</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="orgGrpCd">団体グループコード</param>
        /// <param name="sendMode">発送状態（0:全て、1:発送済み、2:未発送）</param>
        /// <param name="startPos">取得開始位置</param>
        /// <param name="limit">１ページ表示ＭＡＸ行（０：ＭＡＸ行指定無し）</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("senthistories")]
        public IActionResult GetReportSendDateList(string perId,
                                                    DateTime strCslDate,
                                                    DateTime endCslDate,
                                                    string csCd,
                                                    string orgCd1,
                                                    string orgCd2,
                                                    string orgGrpCd,
                                                    int sendMode,
                                                    int startPos = 1,
                                                    int limit = 0)
        {
            int count = 0;
            List<dynamic> item = reportSendDateDao.SelectReportSendDateList(ref count,
                                                                            "CNT",
                                                                            perId,
                                                                            strCslDate,
                                                                            endCslDate,
                                                                            csCd,
                                                                            orgCd1,
                                                                            orgCd2,
                                                                            orgGrpCd,
                                                                            sendMode,
                                                                            startPos,
                                                                            limit);

            List<dynamic> reportItem = new List<dynamic>();

            // データ件数が0件の場合
            if (count > 0)
            {
                reportItem = reportSendDateDao.SelectReportSendDateList(ref count,
                                                                        "",
                                                                        perId,
                                                                        strCslDate,
                                                                        endCslDate,
                                                                        csCd,
                                                                        orgCd1,
                                                                        orgCd2,
                                                                        orgGrpCd,
                                                                        sendMode,
                                                                        startPos,
                                                                        limit);
            }

            var data = new Dictionary<string, dynamic>
            {
                { "count", count},
                { "reportitem", reportItem}
            };

            return Ok(data);
        }

        /// <summary>
        /// 成績書発送確認を登録する
        /// </summary>
        /// <param name="data">成績書発送情報
        /// rsvno       予約番号
        /// chargeuser  発送担当ユーザ
        /// senddate    成績書発送日
        /// </param>
        /// <response code="204">成功</response>
        [HttpPost("{rsvNo}")]
        public IActionResult Insert([FromBody] UserInfo data)
        {
            data.USERID = HttpContext.Session.GetString("userId");
            // TODO
            data.USERID = "HAINS$";
            Insert ret = reportSendDateDao.UpdateReportSendDate("INS", data);

            return NoContent();
        }

        /// <summary>
        /// 成績書発送確認を更新する
        /// </summary>
        /// <param name="data">成績書発送情報
        /// rsvno       予約番号
        /// chargeuser  発送担当ユーザ
        /// senddate    成績書発送日
        /// </param>
        /// <response code="204">成功</response>
        [HttpPut("{rsvNo}/senthistories")]
        public IActionResult Update([FromBody] UserInfo data)
        {
            data.USERID = HttpContext.Session.GetString("userId");
            // TODO
            data.USERID = "HAINS$";
            Insert ret = reportSendDateDao.UpdateReportSendDate("UPD", data);

            return NoContent();
        }

        /// <summary>
        /// 成績書発送確認テーブルレコードを削除する("MAX")
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="204">成功</response>
        [HttpDelete("{rsvNo}/senthistories/before")]
        public IActionResult DeleteConsultReptSendBefore(int rsvNo)
        {
            IList<DateListDetail> data = new List<DateListDetail>();
            DateListDetail dateList = new DateListDetail();
            dateList.Rsvno = rsvNo;
            data.Add(dateList);

            //成績書発送確認テーブルレコード削除
            bool ret = reportSendDateDao.DeleteConsult_ReptSend("MAX", data);

            return NoContent();
        }

        /// <summary>
        /// 成績書発送確認テーブルレコードを削除する("SEL")
        /// </summary>
        /// <param name="data">成績書発送情報
        /// rsvNo   予約番号
        /// seq     SEQ
        /// </param>
        /// <response code="204">成功</response>
        [HttpDelete("senthistories/sel")]
        public IActionResult DeleteConsultReptSend([FromBody] IList<DateListDetail> data)
        {
            //成績書発送確認テーブルレコード削除
            bool ret = reportSendDateDao.DeleteConsult_ReptSend("SEL", data);

            return NoContent();
        }
    }
}
