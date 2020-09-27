using System;

namespace Hainsi.Entity.Model.Contract
{

    /// <summary>
    /// 契約パターンオプション情報モデル
    /// </summary>
    public class ContractOptions
    {
        /// <summary>
        /// 契約パターンオプション
        /// </summary>
        public ContractOption Option { get; set; }

        /// <summary>
        /// 契約負担元情報
        /// </summary>
        public ContractBurdens[] Burdens { get; set; }

        /// <summary>
        /// 年齢区分
        /// </summary>
        public ContractAges[] OptAges { get; set; }

        /// <summary>
        /// 契約パターン負担金額
        /// </summary>
        public ContractPrice[] OrgPrices { get; set; }

        /// <summary>
        /// グループ
        /// </summary>
        public string[] GroupCds { get; set; }

        /// <summary>
        /// 検査項目
        /// </summary>
        public string[] ItemCds { get; set; }
    }
}
