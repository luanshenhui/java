namespace Hainsi.Entity.Model.Bill
{
    /// <summary>
    /// 挿入用個人情報モデル
    /// </summary>
    public class InsertPerBill
    {

        /// <summary>
        /// 請求日
        /// </summary>
        public string DmdDate { get; set; }

        /// <summary>
        /// 請求書Ｓｅｑ
        /// </summary>
        public int BillSeq { get; set; }

        /// <summary>
        /// 請求書枝番
        /// </summary>
        public int BranchNo { get; set; }

        /// <summary>
        /// 予約番号
        /// </summary>
        public string RsvNo { get; set; }
    }
}
