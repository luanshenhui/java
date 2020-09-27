namespace Hainsi.Entity.Model.Bill
{
    /// <summary>
    /// 請求明細内訳を更新する
    /// </summary>
    public class UpdateBillDetailItems
    {
        /// <summary>
        /// 請求書番号
        /// </summary>
        public string BillNo { get; set; }

        /// <summary>
        /// 明細No
        /// </summary>
        public string LineNo { get; set; }

        /// <summary>
        /// 内訳No
        /// </summary>
        public string ItemNo { get; set; }

        /// <summary>
        /// ２次請求明細コード
        /// </summary>
        public string SecondLineDivCd { get; set; }

        /// <summary>
        /// 金額
        /// </summary>
        public string Price { get; set; }

        /// <summary>
        /// 調整金額
        /// </summary>
        public string EditPrice { get; set; }

        /// <summary>
        /// 税額
        /// </summary>
        public string TaxPrice { get; set; }

        /// <summary>
        /// 調整税額
        /// </summary>
        public string EditTax { get; set; }
    }
}
