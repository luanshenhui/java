using Hainsi.Common.Constants;
using Hainsi.Entity;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// コースコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/interviews")]
    public class InterviewController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly InterviewDao interviewDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="interviewDao">データアクセスオブジェクト</param>
        public InterviewController(InterviewDao interviewDao)
        {
            this.interviewDao = interviewDao;
        }

        /// <summary>
        /// 健診が終わった後受診者の個人IDを変更した場合、変更前のIDと変更後のIDを取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/changeperid")]
        public IActionResult GetChangePerId(int rsvNo)
        {
            dynamic data = interviewDao.SelectChangePerId(rsvNo);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定された予約番号の個人ＩＤの受診歴一覧を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号（今回分）</param>
        /// <param name="receptOnly">True指定時は受付済み受診情報のみを取得対象とする</param>
        /// <param name="lastDspMode">前回歴表示モード（0:すべて、1:同一コース、2:任意指定）</param>
        /// <param name="csGrp">前回歴表示モード:0のとき、null;1のとき、コースコード;2のとき、コースグループコード</param>
        /// <param name="getRowCount">取得件数(未指定時は全件)</param>
        /// <param name="selectMode">データ取得モード（0:今回分含む、1:前回分以前）</param>
        /// <param name="dateSort">日付順(0:今回が先頭、1:今回が最後)</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/histories")]
        public IActionResult GetConsultHistory(int rsvNo, bool receptOnly = false, int lastDspMode = 0, string csGrp = null, int getRowCount = 0, int selectMode = 0, int dateSort = 0)
        {
            List<dynamic> list = interviewDao.SelectConsultHistory(rsvNo, receptOnly, lastDspMode, csGrp, getRowCount, selectMode, dateSort);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// コースグループ取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/coursegroups")]
        public IActionResult GetCsGrp(int rsvNo)
        {
            List<dynamic> list = interviewDao.SelectCsGrp(rsvNo);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 予約番号をキーに指定対象受診者の検査結果歴を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号（今回分）</param>
        /// <param name="hisCount">表示歴数</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="lastDspMode">前回歴表示モード（0:すべて、1:同一コース、2:任意指定）</param>
        /// <param name="csGrp">前回歴表示モード：0のとき、null；1のとき、コースコード；2のとき、コースグループコード</param>
        /// <param name="getSeqMode">取得順 0:グループ内表示順＋日付　1:日付＋コード＋サフィックス　2:日付＋グループ内表示順</param>
        /// <param name="selectMode">データ取得モード（0:今回分含む、1:前回分以前）</param>
        /// <param name="allDataMode">全件取得モード（0:検査結果に存在する項目を取得、1:検査結果に存在しなくても全項目取得）</param>
        /// <param name="dateSort">日付順(0:今回が先頭、1:今回が最後)</param>
        /// <param name="rslCmtName1">結果コメント名１</param>
        /// <param name="rslCmtName2">結果コメント名２</param>
        /// <param name="lowerValue">基準値（最低）</param>
        /// <param name="upperValue">基準値（最高）</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/groups/{grpCd}/results")]
        public IActionResult GetHistoryRslList(int rsvNo, string hisCount, string grpCd, int lastDspMode, string csGrp, int getSeqMode,
            int selectMode = 0, int allDataMode = 0, int dateSort = 0, bool? rslCmtName1 = null, bool? rslCmtName2 = null,
            bool? lowerValue = null, bool? upperValue = null)
        {
            List<dynamic> list = interviewDao.SelectHistoryRslList(rsvNo, hisCount, grpCd, lastDspMode, csGrp, getSeqMode, selectMode,
                allDataMode, dateSort, rslCmtName1, rslCmtName2, lowerValue, upperValue);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 予約番号をキーに指定対象受診者の検査結果歴を取得する（検査項目指定）
        /// </summary>
        /// <param name="rsvNo">予約番号（今回分）</param>
        /// <param name="hisCount">表示歴数</param>
        /// <param name="selectItemCd">検査項目コード（配列）</param>
        /// <param name="selectSuffix">サフィックス（配列）</param>
        /// <param name="lastDspMode">前回歴表示モード（0:すべて、1:同一コース、2:任意指定）</param>
        /// <param name="csGrp">前回歴表示モード：0のとき、null;1のとき、コースコード;2のとき、コースグループコード</param>
        /// <param name="getSeqMode">取得順 0:コード＋サフィックス＋日付　1:日付＋コード＋サフィックス</param>
        /// <param name="selectMode">データ取得モード（0:今回分含む、1:前回分以前）</param>
        /// <param name="allDataMode">全件取得モード（0:検査結果に存在する項目を取得、1:検査結果に存在しなくても全項目取得）</param>
        /// <param name="lowerValue">基準値（最低）</param>
        /// <param name="upperValue">基準値（最高）</param>
        /// <param name="rslCmtName1">結果コメント名１</param>
        /// <param name="rslCmtName2">結果コメント名２</param>
        /// <param name="dateSort">日付順(0:今回が先頭、1:今回が最後)</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/results")]
        public IActionResult GetHistoryRslListItem(int rsvNo, string hisCount, List<string> selectItemCd, List<string> selectSuffix,
            int lastDspMode, string csGrp, int getSeqMode, int selectMode = 0, int allDataMode = 0, bool? lowerValue = null,
            bool? upperValue = null, bool? rslCmtName1 = null, bool? rslCmtName2 = null, int dateSort = 0)
        {
            List<dynamic> list = interviewDao.SelectHistoryRslList_Item(rsvNo, hisCount, selectItemCd, selectSuffix, lastDspMode, csGrp, getSeqMode,
                selectMode, allDataMode, lowerValue, upperValue, rslCmtName1, rslCmtName2, dateSort);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 面接支援画面表示用のオプション検査名を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/options")]
        public IActionResult GetInteviewOptItem(int rsvNo)
        {
            List<dynamic> list = interviewDao.SelectInteviewOptItem(rsvNo);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// eGFR(MDRD)計算結果を履歴として取得
        /// </summary>
        /// <param name="rsvNo">検索条件：予約番号</param>
        /// <param name="hisCount">表示歴数</param>
        /// <param name="csGrp">前回歴表示モード:0のとき、null;1のとき、コースコード;2のとき、コースグループコード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/results/egfr")]
        public IActionResult GetMDRDHistory(int rsvNo, string hisCount, string csGrp)
        {
            List<dynamic> list = interviewDao.SelectMDRDHistory(rsvNo, hisCount, csGrp);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// GFR(新しい日本人の推算式)計算結果を履歴として取得
        /// </summary>
        /// <param name="rsvNo">検索条件：予約番号</param>
        /// <param name="hisCount">表示歴数</param>
        /// <param name="csGrp">前回歴表示モード:0のとき、null;1のとき、コースコード;2のとき、コースグループコード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/results/newgfr")]
        public IActionResult GetNewGFRHistory(int rsvNo, string hisCount, string csGrp)
        {
            List<dynamic> list = interviewDao.SelectNewGFRHistory(rsvNo, hisCount, csGrp);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定された予約番号のオーダ番号、送信日を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="orderDiv">オーダ種別</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/orders")]
        public IActionResult GetOrderNo(int rsvNo, string orderDiv)
        {
            dynamic data = interviewDao.SelectOrderNo(rsvNo, orderDiv);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定された予約番号の多変量解析を行いＸ座標、Ｙ座標を求める
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpGet("{rsvNo}/multivariateanalysis")]
        public IActionResult StatisticsCalc(int rsvNo)
        {
            double valueX = 0;
            double valueY = 0;
            bool ret = interviewDao.StatisticsCalc(rsvNo, ref valueX, ref valueY);

            if(ret == false)
            {
                return BadRequest();
            }

            var ds = new Dictionary<string, double>
                        {
                            { "valuex", valueX },
                            { "valuey", valueY }
                        };

            return Ok(ds);
        }

        /// <summary>
        /// 指定検索条件の入院・外来歴を取得する
        /// </summary>
        /// <param name="rsvNo">検索条件：予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/patienthistories")]
        public IActionResult GetPatientHistory(int rsvNo)
        {
            List<dynamic> list = interviewDao.SelectPatientHistory(rsvNo);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定検索条件の病歴を取得する
        /// </summary>
        /// <param name="rsvNo">検索条件：予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/diseasehistories")]
        public IActionResult GetDiseaseHistory(int rsvNo)
        {
            List<dynamic> list = interviewDao.SelectDiseaseHistory(rsvNo);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定された予約番号の総合コメントを更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="data"></param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("~/api/v1/consultations/{rsvNo}/totalcomments")]
        public IActionResult UpdateTotalJudCmt(int rsvNo, [FromBody] JToken data)
        {
            int dispMode = Convert.ToInt32(data["dispMode"]);
            List<string> seqs = data["seqs"].ToObject<List<string>>();
            List<string> judCmtCd = data["judCmtCd"].ToObject<List<string>>();
            List<string> judCmtCdStc = data["judCmtCdStc"].ToObject<List<string>>();
            string updUser = HttpContext.Session.GetString("userId");
            updUser = "HAINS$";

             Insert ret = interviewDao.UpdateTotalJudCmt(rsvNo, dispMode, seqs, judCmtCd, judCmtCdStc, updUser);

            if (ret == Insert.Error)
            {
                return BadRequest();
            }

            return NoContent();
        }

        /// <summary>
        /// 指定対象受診者の判定結果を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="hisCount">表示歴数</param>
        /// <param name="lastDspMode">前回歴表示モード</param>
        /// <param name="csGrp">
        /// 前回歴表示モード＝0のとき、null
        /// ＝1のとき、コースコード
        /// ＝2のとき、コースグループコード
        /// </param>
        /// <param name="seqMode">取得順 0:表示順＋日付　1:日付＋表示順</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/groups/results")]
        public IActionResult GelectJudHistoryRslList(int rsvNo, string hisCount, int lastDspMode, string csGrp, int seqMode)
        {
            List<dynamic> data = interviewDao.SelectJudHistoryRslList(rsvNo, hisCount, lastDspMode, csGrp, seqMode);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定された予約番号の総合コメントを取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="dispMode">表示分類（1:総合コメント、2:生活指導コメント、3:食習慣コメント、4:献立コメント）</param>
        /// <param name="hisCount">表示歴数</param>
        /// <param name="lastDspMode">前回歴表示モード（0:すべて、1:同一コース、2:任意指定）</param>
        /// <param name="csGrp">前回歴表示モード：0のとき、null;1のとき、コースコード;2のとき、コースグループコード</param>
        /// <param name="selectMode">データ取得モード（0:今回分含む、1:前回分以前）</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response> 
        [HttpGet("~/api/v1/consultations/{rsvNo}/totalcomments")]
        public IActionResult GetTotalJudCmt(int rsvNo, int dispMode, string hisCount, int lastDspMode = 0, string csGrp = null, int selectMode = 0)
        {
            List<dynamic> data = interviewDao.SelectTotalJudCmt(rsvNo, dispMode, hisCount, lastDspMode, csGrp, selectMode);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定検索条件の変更履歴を取得する。
        /// </summary>
        /// <param name="startUpdDate">検索条件：更新日（開始）</param>
        /// <param name="endUpdDate">検索条件：更新日（終了）</param>
        /// <param name="searchUpdUser">検索条件：更新者</param>
        /// <param name="searchUpdClass">検索条件：更新分類（０：すべて）</param>
        /// <param name="orderbyItem">並べ替え項目(0:更新日,1:更新者,2:分類・項目）</param>
        /// <param name="orderbyMode">並べ替え方法(0:昇順,1:降順)</param>
        /// <param name="page">取得開始位置</param>
        /// <param name="limit">１ページ表示ＭＡＸ行（０：ＭＡＸ行指定無し）</param>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// upddate 更新日時
        /// upduser 更新者
        /// updusername 更新者氏名
        /// updclass 更新分類
        /// upddiv 処理区分
        /// rsvno 予約番号
        /// rsvdate 予約日
        /// itemcd 更新項目コード
        /// suffix サフィックス
        /// itemname 更新項目名称
        /// judclasscd 判定分類コード
        /// judclassname 判定分類名称
        /// beforeresult 更新前値
        /// afterresult 更新後値
        /// </returns>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{rsvNo}/records")]
        public IActionResult GetUpdateLogList(string startUpdDate, string endUpdDate, string searchUpdUser, string searchUpdClass, int orderbyItem, int orderbyMode, int page, int limit, string rsvNo = null)
        {
            int startPos = (page - 1) * limit;
            PartialDataSet ds = interviewDao.SelectUpdateLogList(startUpdDate, endUpdDate, searchUpdUser, searchUpdClass, orderbyItem, orderbyMode, startPos, limit, rsvNo);

            // データ件数が0件の場合
            if (ds.TotalCount == 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }
    }
}
