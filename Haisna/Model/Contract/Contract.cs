using System;

namespace Hainsi.Entity.Model.Contract
{

    /// <summary>
    /// 契約パターン・負担元・年齢区分情報モデル
    /// </summary>
    public class Contract: ContractPattern
    {

        /// <summary>
        /// コースコード
        /// </summary>
        public string CsCd { get; set; }

        /// <summary>
        /// 契約負担元情報
        /// </summary>
        public ContractBurdens[] Burdens { get; set; }

        /// <summary>
        /// 年齢区分
        /// </summary>
        public ContractAges[] Ages { get; set; }

    }
}
