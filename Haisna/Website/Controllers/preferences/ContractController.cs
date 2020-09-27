using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.Entity.Model.Contract;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// Contractコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/contracts")]
    public class ContractController : Controller
    {
        /// <summary>
        /// 契約データアクセスオブジェクト
        /// </summary>
        readonly ContractDao constractDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="contractDao">契約データアクセスオブジェクト</param>
        public ContractController(ContractDao contractDao)
        {
            this.constractDao = contractDao;
        }

        /// <summary>
        /// 指定期間において、指定団体・コースの契約情報が存在するかをチェックする
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="strDate">契約開始日</param>
        /// <param name="endDate">契約終了日</param>
        /// <response code="204">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/organizations/{orgCd1}/{orgCd2}/contracts/periods/existence")]
        public IActionResult CheckContractPeriod(string orgCd1, string orgCd2, string csCd, int ctrPtCd, DateTime strDate, DateTime? endDate = null)
        {
            bool ret = constractDao.CheckContractPeriod(orgCd1, orgCd2, csCd, ctrPtCd, strDate, endDate);

            if (ret)
            {
                return NotFound();
            }

            return NoContent();
        }

        /// <summary>
        /// 指定団体の全契約情報(コース・参照先団体・契約期間)をコース昇順、契約期間降順に取得する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="strDate">契約開始日</param>
        /// <param name="endDate">契約終了日</param>
        /// <param name="isFirstCourse">true指定時は１次健診コースのみ取得</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/organizations/{orgCd1}/{orgCd2}/contracts")]
        public IActionResult GetAllCtrMng(string orgCd1, string orgCd2, string csCd, DateTime? strDate = null, DateTime? endDate = null, bool isFirstCourse = false)
        {
            List<dynamic> list = constractDao.SelectAllCtrMng(orgCd1, orgCd2, csCd, strDate, endDate, isFirstCourse);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定団体・コース・契約パターンにおける契約管理情報を取得する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/organizations/{orgCd1}/{orgCd2}/contracts/{ctrPtCd}")]
        public IActionResult GetCtrMng(string orgCd1, string orgCd2, int ctrPtCd)
        {
            dynamic data = constractDao.SelectCtrMng(orgCd1, orgCd2, ctrPtCd);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 契約期間付きの契約管理情報を取得する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="csCd">コースコード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/organizations/{orgCd1}/{orgCd2}/contracts/periods")]
        public IActionResult GetCtrMngWithPeriod(string orgCd1, string orgCd2, string csCd)
        {
            List<dynamic> list = constractDao.SelectCtrMngWithPeriod(orgCd1, orgCd2, csCd);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定団体、コース、日付において有効な全ての受診区分を取得する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="strDate">開始日付</param>
        /// <param name="endDate">終了日付</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/organizations/{orgCd1}/{orgCd2}/consultdivisions")]
        public IActionResult GetAllCslDiv(string orgCd1, string orgCd2, string csCd, DateTime? strDate = null, DateTime? endDate = null)
        {
            List<dynamic> list = constractDao.SelectAllCslDiv(orgCd1, orgCd2, csCd, strDate, endDate);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定契約パターンの契約期間および年齢起算日を取得する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{ctrPtCd}")]
        public IActionResult GetCtrPt(int ctrPtCd)
        {
            dynamic data = constractDao.SelectCtrPt(ctrPtCd);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定契約パターンおよびオプションコードのオプション検査情報を取得する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{ctrPtCd}/options/{optCd}/{optBranchNo}")]
        [ProducesResponseType(404)]
        [ProducesResponseType(typeof(ContractOptionModel), 200)]
        public IActionResult GetCtrPtOpt(int ctrPtCd, string optCd, int optBranchNo)
        {
            dynamic data = constractDao.SelectCtrPtOpt(ctrPtCd, optCd, optBranchNo);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定条件にて受診する際のオプション検査とそのデフォルト受診状態を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="cslDivCd">受診区分コード</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="perId">個人ID</param>
        /// <param name="gender">性別</param>
        /// <param name="birth">生年月日</param>
        /// <param name="age">受診時年齢</param>
        /// <param name="exceptNoMatch">性別、受診区分、年齢条件に合致しないセットを取得対象とするか</param>
        /// <param name="includeTax">金額に消費税を含むか</param>
        /// <param name="mode">
        /// 0:個人ID指定時、引数指定された性別・生年月日・年齢を無視し、個人情報から取得
        /// 個人ID未指定ならば引数指定された性別・生年月日・年齢を使用
        /// 1:個人IDの指定に関わらず、引数指定された性別・生年月日・年齢を使用
        /// </param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{ctrPtCd}/options/status")]
        public IActionResult GetCtrPtOptFromConsult(DateTime cslDate, string cslDivCd, int ctrPtCd, string perId = null, int? gender = null,
            DateTime? birth = null, string age = null, bool exceptNoMatch = false, bool includeTax = false, int mode = 0)
        {
            List<dynamic> list = constractDao.SelectCtrPtOptFromConsult(cslDate, cslDivCd,
                ctrPtCd, perId, gender, birth, age, exceptNoMatch, includeTax, mode);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定予約番号の受診情報に対し、指定契約パターン・オプションにおける検査項目の受診状態を取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/items")]
        [ProducesResponseType(404)]
        [ProducesResponseType(typeof(List<ContractOptionItemModel>), 200)]
        public IActionResult GetCtrPtOptItem(int rsvNo, int ctrPtCd, string optCd, int optBranchNo)
        {
            List<dynamic> list = constractDao.SelectCtrPtOptItem(rsvNo, ctrPtCd, optCd, optBranchNo);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定契約パターンの全オプション検査を取得する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{ctrPtCd}/options")]
        public IActionResult GetCtrPtOptList(int ctrPtCd)
        {
            List<dynamic> list = constractDao.SelectCtrPtOptList(ctrPtCd);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定契約パターンにおける指定オプション区分の全負担情報を取得する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="setClassCd">セット分類コード</param>
        /// <param name="cslDivCd">受診区分コード</param>
        /// <param name="gender">受診可能性別</param>
        /// <param name="strAge">受診開始年齢</param>
        /// <param name="endAge">受診終了年齢</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{ctrPtCd}/priceoptions")]
        public IActionResult GetCtrPtPriceOptAll(int ctrPtCd, string csCd, string setClassCd, string cslDivCd, Gender gender, decimal? strAge = null, decimal? endAge = null)
        {
            List<dynamic> list = constractDao.SelectCtrPtPriceOptAll(ctrPtCd, csCd, setClassCd, cslDivCd, gender, strAge, endAge);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定契約パターンの負担元および負担金額情報を取得する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{ctrPtCd}/price")]
        public IActionResult GetCtrPtOrgPrice(int ctrPtCd, string optCd = null, int? optBranchNo = null)
        {
            IList<dynamic> data = constractDao.SelectCtrPtOrgPrice(ctrPtCd, optCd, optBranchNo);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }
        /// <summary>
        /// 契約パターンテーブルレコードを更新する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="data">契約パターン情報</param>
        [ProducesResponseType(204)]
        [HttpPut("{ctrPtCd}")]
        public IActionResult UpdateCtrPt(int ctrPtCd, [FromBody] ContractPattern data)
        {
            // 契約期間の更新
            constractDao.UpdateCtrPt(ctrPtCd, data);

            return NoContent();
        }

        /// <summary>
        /// 指定契約パターン、オプションの受診対象年齢条件を読み込む
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{ctrPtCd}/age")]
        public IActionResult GetCtrPtOptAge(int ctrPtCd, string optCd, int optBranchNo)
        {
            List<dynamic> data = constractDao.SelectCtrPtOptAge(ctrPtCd, optCd, optBranchNo);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定契約パターン・オプションにおけるグループを取得する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{ctrPtCd}/grp")]
        public IActionResult GetCtrPtGrp(int ctrPtCd, string optCd, int optBranchNo)
        {
            List<dynamic> data = constractDao.SelectCtrPtGrp(ctrPtCd, optCd, optBranchNo);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定契約パターン・オプションにおける検査項目を取得する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{ctrPtCd}/item")]
        public IActionResult GetCtrPtItem(int ctrPtCd, string optCd, int optBranchNo)
        {
            List<dynamic> data = constractDao.SelectCtrPtItem(ctrPtCd, optCd, optBranchNo);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 参照先団体の契約情報が参照元団体から参照可能かをチェックし、その状態を返す
        /// </summary>
        /// <param name="orgCd1">参照元団体コード1</param>
        /// <param name="orgCd2">参照元団体コード2</param>
        /// <param name="refOrgCd1">参照先団体コード1</param>
        /// <param name="refOrgCd2">参照先団体コード2</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/organizations/{refOrgCd1}/{refOrgCd2}/contracts/{ctrPtCd}/references")]
        public IActionResult GetCtrMngRefer(string orgCd1, string orgCd2, string refOrgCd1, string refOrgCd2, string csCd = null, int? ctrPtCd = null)
        {
            List<dynamic> data = constractDao.SelectCtrMngRefer(orgCd1, orgCd2, refOrgCd1, refOrgCd2, csCd, ctrPtCd);

            // データ件数が0件の場合
            if (data == null || data.Count <= 0)
            {
                return NotFound();
            }

            return Ok(data);
        }
    }
}
