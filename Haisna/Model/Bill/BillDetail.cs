
namespace Hainsi.Entity.Model.Bill
{
    /// <summary>
    /// 挿入用個人情報モデル
    /// </summary>
    public class BillDetail
    {
        /// <summary>
        /// 受診日
        /// </summary>
        public string CslDate { get; set; }

        /// <summary>
        /// 当日ID
        /// </summary>
        public string DayId { get; set; }

        /// <summary>
        /// 予約番号
        /// </summary>
        public string RsvNo { get; set; }

        /// <summary>
        /// 名称
        /// </summary>
        public string DetailName { get; set; }

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

        /// <summary>
        /// 請求書番号
        /// </summary>
        public string BillNo { get; set; }

        /// <summary>
        /// 明細No
        /// </summary>
        public string LineNo { get; set; }

        /// <summary>
        /// 年
        /// </summary>
        public string StrYear { get; set; }

        /// <summary>
        /// 月
        /// </summary>
        public string StrMonth { get; set; }

        /// <summary>
        /// 日
        /// </summary>
        public string StrDay { get; set; }

        /// <summary>
        /// 個人ID
        /// </summary>
        public string PerId { get; set; }
    }
}
