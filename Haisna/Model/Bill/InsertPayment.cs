namespace Hainsi.Entity.Model.Bill
{
    /// <summary>
    /// 入金処理
    /// </summary>
    public class InsertPayment : UpdatePayment
    {
        /// <summary>
        /// 締め日
        /// </summary>
        public string CloseDate { get; set; }

        /// <summary>
        /// 請求書SEQ
        /// </summary>
        public long BillSeq { get; set; }

        /// <summary>
        /// 請求書枝番
        /// </summary>
        public long BranchNo { get; set; }

    }
}
