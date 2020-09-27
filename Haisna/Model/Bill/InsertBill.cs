
namespace Hainsi.Entity.Model.Bill
{
    /// <summary>
    /// 挿入用個人情報モデル
    /// </summary>
    public class InsertBill
    {
        /// <summary>
        /// 締め日
        /// </summary>
        public string CloseDate { get; set; }

        /// <summary>
        /// 団体コード１
        /// </summary>
        public string OrgCd1 { get; set; }

        /// <summary>
        /// 団体コード２
        /// </summary>
        public string OrgCd2 { get; set; }

        /// <summary>
        /// 請求書出力日
        /// </summary>
        public string PrtDate { get; set; }

        /// <summary>
        /// 適用税率
        /// </summary>
        public string TaxRates { get; set; }

        /// <summary>
        /// ２次検査フラグ
        /// </summary>
        public string SecondFlg { get; set; }
    }
}
