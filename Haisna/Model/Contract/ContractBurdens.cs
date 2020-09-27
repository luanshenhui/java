namespace Hainsi.Entity.Model.Contract
{
    /// <summary>
    /// 契約負担元情報モデル
    /// </summary>
    public class ContractBurdens : ContractManage
    {
        /// <summary>
        /// SEQ
        /// </summary>
        public int Seq { get; set; }

        /// <summary>
        /// 適用元区分
        /// </summary>
        public int Apdiv { get; set; }

        /// <summary>
        /// 消費税負担フラグ
        /// </summary>
        public int TaxFlg { get; set; }

        /// <summary>
        /// 契約外項目負担フラグ
        /// </summary>
        public int Noctr { get; set; }
        
        /// <summary>
        /// 契約外項目端数負担フラグ
        /// </summary>
        public int Fraction { get; set; }

        /// <summary>
        /// 負担金額
        /// </summary>
        public int Price { get; set; }
    }
}
