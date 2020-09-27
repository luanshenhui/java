namespace Hainsi.Entity.Model.Contract
{

    /// <summary>
    /// 契約パターン負担金額情報モデル
    /// </summary>
    public class ContractPrice
    {
        /// <summary>
        /// SEQ
        /// </summary>
        public int Seq { get; set; }

        /// <summary>
        /// 消費税
        /// </summary>
        public string Tax { get; set; }

        /// <summary>
        /// 負担金額
        /// </summary>
        public string Price { get; set; }

        /// <summary>
        /// 団体種別
        /// </summary>
        public string OrgDiv { get; set; }

        /// <summary>
        /// 請求書出力名
        /// </summary>
        public string BillPrintName { get; set; }

        /// <summary>
        /// 請求書英語出力名
        /// </summary>
        public string BillPrintEName { get; set; }

    }
}
