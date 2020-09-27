using Hainsi.Entity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using Hainsi.Entity.Model.Contract;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 契約情報用WebAPIコントローラークラス
    /// </summary>
    //[Authorize]
    [Route("api/v1/contracts")]
    public class ContractControlController : Controller
    {
        /// <summary>
        /// 契約情報の参照オブジェクト
        /// </summary>
        readonly ContractControlDao contractControlDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="contractControlDao">契約情報の参照オブジェクト</param>
        public ContractControlController(ContractControlDao contractControlDao)
        {
            this.contractControlDao = contractControlDao;
        }

        /// <summary>
        /// 参照中契約情報のコピー処理
        /// </summary>
        /// <param name="data">
        /// orgCd1 団体コード1
        /// orgCd2 団体コード2
        /// refOrgCd1 参照先団体コード1
        /// refOrgCd2 参照先団体コード2
        /// ctrPtCd 契約パターンコード
        /// </param>
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(String), 400)]
        [HttpPost("copy")]
        public IActionResult CopyReferredContract([FromBody] ContractManage data)
        {
            int ret = contractControlDao.CopyReferredContract(data.OrgCd1, data.OrgCd2, data.RefOrgCd1, data.RefOrgCd2, data.CtrPtCd);

            // 契約期間内に受診情報が存在
            if (ret == 1)
            {
                return this.BadRequest("契約団体自身が負担元として存在する契約情報のコピーはできません。");
            }

            // 正常時は204(No Content)を返す
            return NoContent();
        }

        /// <summary>
        /// 契約情報の参照を解除する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpDelete("~/api/v1/organizations/{orgCd1}/{orgCd2}/contracts/{ctrPtCd}")]
        public IActionResult Release(string orgCd1, string orgCd2, int ctrPtCd)
        {
            int ret = contractControlDao.Release(orgCd1, orgCd2, ctrPtCd);

            // 契約期間内に受診情報が存在
            if (ret == 1)
            {
                return this.BadRequest("この契約情報を参照している受診情報が存在します。削除できません。");
            }

            // 正常時は204(No Content)を返す
            return NoContent();
        }

        /// <summary>
        /// 契約情報を分割する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="data">二次実施日</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("~/api/v1/organizations/{orgCd1}/{orgCd2}/contracts/{ctrPtCd}/split")]
        public IActionResult Split(string orgCd1, string orgCd2, int ctrPtCd, [FromBody] ContractSplit data)
        {
            // 契約期間の更新
            int ret = contractControlDao.Split(orgCd1, orgCd2, ctrPtCd, data.SplitDate);


            switch (ret)
            {
                case 0:
                    return NoContent();
                case 1:
                    return BadRequest("この契約情報は分割できません。");
                case 2:
                    return BadRequest("分割日は必ず契約期間内の日付で指定して下さい。");
                case 3:
                    return BadRequest("分割日以降に受付済み受診情報が存在します。分割できません。");
                default:
                    return BadRequest();
            }

        }

        /// <summary>
        /// 契約期間を更新する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="data">
        /// csCd コースコード
        /// strYear 契約開始日（年）
        /// strMonth 契約開始日（月）
        /// strDay 契約開始日（日）
        /// endYear 契約終了日（年）
        /// endMonth 契約終了日（月）
        /// endDay 契約終了日（日）
        /// </param>
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(String), 400)]
        [HttpPut("~/api/v1/organizations/{orgCd1}/{orgCd2}/contracts/{ctrPtCd}/periods")]
        public IActionResult UpdatePeriod(string orgCd1, string orgCd2, int ctrPtCd, [FromBody] Contract data)
        {
            // 契約期間の更新
            int ret = contractControlDao.UpdatePeriod(orgCd1, orgCd2, data.CsCd, ctrPtCd, data.StrDate, data.EndDate);

            switch (ret)
            {
                case 0:
                    return NoContent();
                case 1:
                    return BadRequest("指定された契約期間に適用可能なコース履歴が存在しません。");
                case 2:
                    return BadRequest("すでに登録済みの契約情報と契約期間が重複します。");
                case 3:
                    return BadRequest("契約期間の変更により、この契約情報の参照ができなくなる受診情報が発生します。変更できません。");
                default:
                    return BadRequest();
            }
        }

        /// <summary>
        /// 新しい契約情報を作成する
        /// </summary>
        /// <param name="data">契約情報</param>
        [ProducesResponseType(204)]
        [HttpPost]
        public IActionResult InsertContract([FromBody] Contract data)
        {
            contractControlDao.InsertContract(data);

            return NoContent();
        }

        /// <summary>
        /// 契約情報の更新（負担元情報・負担金額情報）をする
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="data">契約情報</param>
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<String>), 400)]
        [HttpPut("~/api/v1/organizations/{orgCd1}/{orgCd2}/contracts/{ctrPtCd}")]
        public IActionResult UpdateContract(string orgCd1, string orgCd2, int ctrPtCd, [FromBody] Contract data)
        {
            int ret = contractControlDao.UpdateContract(orgCd1, orgCd2, ctrPtCd, data, out string[] refOrgName);

            var messages = new List<string>();
            switch (ret)
            {
                case 0:
                    break;
                case 1:
                    messages.Add("セット料金負担を行う団体は削除できません。");
                    break;
                case 2:
                    messages.Add("削除項目負担を行う団体の負担金額は必ず指定する必要があります。");
                    break;
                case 3:
                    foreach (string orgName in refOrgName)
                    {
                        messages.Add("負担元「" + orgName + "」は現在この契約情報を参照しています。登録できません。");
                    }
                    break;
                case 4:
                    messages.Add("受診情報で参照されている負担元を削除しようとしました。削除できません。");
                    break;
                case 5:
                    messages.Add("限度額負担の設定が行われている負担元は削除できません。");
                    break;
                default:
                    messages.Add("その他のエラーが発生しました。");
                    break;
            }

            if (messages.Count > 0)
            {
                return BadRequest(messages);
            }

            return NoContent();
        }

        /// <summary>
        /// 契約情報の削除処理する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpDelete("~/api/v1/organizations/{orgCd1}/{orgCd2}/contracts/{ctrPtCd}/contract")]
        public IActionResult DeleteContract(string orgCd1, string orgCd2, int ctrPtCd)
        {
            // 契約期間の更新
            int ret = contractControlDao.DeleteContract(orgCd1, orgCd2, ctrPtCd);

            switch (ret)
            {
                case 0:
                    return NoContent();
                case 1:
                    return BadRequest("この契約情報は他団体から参照されています。削除できません。");
                case 2:
                    return BadRequest("この契約情報を参照している受診情報が存在します。削除できません。");
                default:
                    return BadRequest();
            }

        }

        /// <summary>
        /// 限度額情報を更新する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="data">限度額情報</param>
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(String), 400)]
        [HttpPut("~/api/v1/organizations/{orgCd1}/{orgCd2}/contracts/{ctrPtCd}/price")]
        public IActionResult UpdateLimitPrice(string orgCd1, string orgCd2, int ctrPtCd, [FromBody] Contract data)
        {
            int ret = contractControlDao.UpdateLimitPrice(orgCd1, orgCd2, ctrPtCd, data);

            if (ret != 0)
            {
                return BadRequest("この契約情報の負担元情報は変更されています。更新できません。");
            }

            return NoContent();
        }

        /// <summary>
        /// 限度額の設定を入力チェックする
        /// </summary>
        /// <param name="data">限度額情報</param>
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(IList<String>), 400)]
        [HttpPost("price/validation")]
        public IActionResult CheckLimitPriceValue([FromBody] Contract data)
        {
            List<string> messages = contractControlDao.CheckLimitPriceValue(data);

            if (messages != null && messages.Count > 0)
            {
                return BadRequest(messages);
            }

            return NoContent();
        }

        /// <summary>
        /// オプションの削除処理
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpDelete("~/api/v1/organizations/{orgCd1}/{orgCd2}/contracts/{ctrPtCd}/{optCd}/{optBranchNo}/option")]
        public IActionResult DeleteOption(string orgCd1, string orgCd2, int ctrPtCd, string optCd, int optBranchNo)
        {
            int ret = contractControlDao.DeleteOption(orgCd1, orgCd2, ctrPtCd, optCd, optBranchNo);

            switch (ret)
            {
                case 0:
                    return NoContent();
                case 1:
                    return BadRequest("このセットを参照している受診情報が存在します。削除できません。");
                case 2:
                    return BadRequest("このセットを参照している受診情報が存在します。削除できません。");
                case 3:
                    return BadRequest("このwebオプション検査は削除できません。");
                default:
                    return BadRequest();
            }
        }

        /// <summary>
        /// 契約情報の参照処理
        /// </summary>
        /// <param name="data">参照先団体情報</param>
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(String), 400)]
        [HttpPost("~/api/v1/organizations/{refOrgCd1}/{refOrgCd2}/contracts/{ctrPtCd}/references")]
        public IActionResult Refer([FromBody] ContractManage data)
        {
            int ret = contractControlDao.Refer(data.OrgCd1, data.OrgCd2, data.RefOrgCd1, data.RefOrgCd2, data.CtrPtCd);

            switch (ret)
            {
                case 0:
                    return NoContent();
                case 1:
                    return BadRequest("参照先団体が契約団体自身の契約を参照しています。");
                case 2:
                    return BadRequest("この契約情報はすでに契約団体自身から参照されています。");
                case 3:
                    return BadRequest("契約団体の現契約情報と契約期間が重複するため、参照することはできません。");
                case 4:
                    return BadRequest("契約団体自身が負担元として存在する契約情報の参照はできません。");
                default:
                    return BadRequest();
            }
        }

        /// <summary>
        /// 契約情報のコピー処理
        /// </summary>
        /// <param name="data">コピー先団体情報</param>
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(String), 400)]
        [HttpPost("~/api/v1/organizations/{refOrgCd1}/{refOrgCd2}/contracts/{ctrPtCd}/copy")]
        public IActionResult Copy([FromBody] ContractPattern data)
        {
            int ret = contractControlDao.Copy(data.OrgCd1, data.OrgCd2, data.RefOrgCd1, data.RefOrgCd2, data.CtrPtCd, data.StrDate, data.EndDate);

            switch (ret)
            {
                case 0:
                    return NoContent();
                case 1:
                    return BadRequest("すでに登録済みの契約情報と契約期間が重複するため、コピーできません。");
                case 2:
                    return BadRequest("契約団体自身が負担元として存在する契約情報のコピーはできません。");
                default:
                    return BadRequest();
            }
        }

        /// <summary>
        /// 追加オプションの書き込み処理
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="data">契約オプション情報</param>
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        [HttpPost("~/api/v1/organizations/{orgCd1}/{orgCd2}/contracts/{ctrPtCd}/options")]
        public IActionResult InsertAddOption(int ctrPtCd, string orgCd1, string orgCd2, [FromBody] ContractOptions data)
        {
            // 検査セットの登録入力チェック
            IList<string> messages = contractControlDao.CheckSetValue(data);
            if(messages.Count>0)
            {
                return BadRequest(messages);
            }

            // 追加オプションの書き込み
            int ret = contractControlDao.SetAddOption("INS", ctrPtCd, orgCd1, orgCd2, data.Option.OptCd, Convert.ToInt32(data.Option.OptBranchNo), data);

            switch (ret)
            {
                case 0:
                    return NoContent();
                case 1:
                    return BadRequest(new string[] { "この契約情報の負担元情報は変更されています。更新できません。" });
                case 2:
                    return BadRequest(new string[] { "調整金額が設定されてある負担元の負担金額には必ず値を入力する必要があります。" });
                case 3:
                    return BadRequest(new string[] { "同一セットコード、枝番の検査がすでに存在します。" });
                default:
                    return BadRequest();
            }
        }

        /// <summary>
        /// 追加オプションの書き込み処理
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <param name="data">契約オプション情報</param>
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>) , 400)]
        [HttpPut("~/api/v1/organizations/{orgCd1}/{orgCd2}/contracts/{ctrPtCd}/options/{optCd}/{optBranchNo}")]
        public IActionResult UpdateAddOption(int ctrPtCd, string orgCd1, string orgCd2, string optCd, int optBranchNo, [FromBody] ContractOptions data)
        {
            data.Option.OptCd = optCd;
            data.Option.OptBranchNo = Convert.ToString(optBranchNo);

            // 検査セットの登録入力チェック
            IList<string> messages = contractControlDao.CheckSetValue(data);
            if (messages.Count > 0)
            {
                return BadRequest(messages);
            }

            // 追加オプションの書き込み
            int ret = contractControlDao.SetAddOption("UPD", ctrPtCd, orgCd1, orgCd2, optCd, optBranchNo, data);

            switch (ret)
            {
                case 0:
                    return NoContent();
                case 1:
                    return BadRequest(new string[] { "この契約情報の負担元情報は変更されています。更新できません。" });
                case 2:
                    return BadRequest(new string[] { "調整金額が設定されてある負担元の負担金額には必ず値を入力する必要があります。" });
                case 3:
                    return BadRequest(new string[] { "同一セットコード、枝番の検査がすでに存在します。" });
                default:
                    return BadRequest();
            }
        }
    }
}
