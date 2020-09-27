using System;

namespace Hainsi.Entity.Model.Contract
{
    /// <summary>
    /// 契約パターン情報モデル
    /// </summary>
    public class ContractPattern : ContractManage
    {

        /// <summary>
        /// 契約開始年月日
        /// </summary>
        public DateTime? StrDate { get; set; }

        /// <summary>
        /// 契約終了年月日
        /// </summary>
        public DateTime? EndDate { get; set; }

        /// <summary>
        /// 税端数区分
        /// </summary>
        public int? TaxFraction { get; set; }

        /// <summary>
        /// 年齢起算日
        /// </summary>
        public string AgeCalc { get; set; }

        /// <summary>
        /// コース名
        /// </summary>
        public string CsName { get; set; }

        /// <summary>
        /// 英語コース名
        /// </summary>
        public string CsEName { get; set; }

        /// <summary>
        /// 予約方法
        /// </summary>
        public int? CslMethod { get; set; }

        /// <summary>
        /// 限度率
        /// </summary>
        public string LimitRate { get; set; }

        /// <summary>
        /// 限度額消費税フラグ
        /// </summary>
        public int? LimitTaxFlg { get; set; }

        /// <summary>
        /// 上限金額
        /// </summary>
        public string LimitPrice { get; set; }

        /// <summary>
        /// 対象負担元SEQ
        /// </summary>
        public int? SeqOrg { get; set; }

        /// <summary>
        /// 減算した金額の負担元SEQ
        /// </summary>
        public int? SeqBdnOrg { get; set; }
    }
}
