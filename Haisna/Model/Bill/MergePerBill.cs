namespace Hainsi.Entity.Model.Bill
{
    /// <summary>
    /// 挿入用個人情報モデル
    /// </summary>
    public class MergePerBill
    {
        /// <summary>
        /// 統合先請求日
        /// </summary>
        public string DmdDate { get; set; }

        /// <summary>
        /// 統合先請求書Ｓｅｑ
        /// </summary>
        public int BillSeq { get; set; }

        /// <summary>
        /// 統合先請求書枝番
        /// </summary>
        public int branchno { get; set; }

        /// <summary>
        /// 統合元請求日
        /// </summary>
        public string OldDmdDate { get; set; }

        /// <summary>
        /// 統合元請求書Ｓｅｑ
        /// </summary>
        public int OldBillSeq { get; set; }

        /// <summary>
        /// 統合元請求書枝番
        /// </summary>
        public int Oldbranchno { get; set; }
    }
}
