namespace Hainsi.Entity.Model.Bill
{
    /// <summary>
    /// 挿入用個人請求詳細情報モデル
    /// </summary>
    public class InsertPerBill_c : PerBill_c
    {
        /// <summary>
        /// 請求書詳細登録用
        /// </summary>
        public string LineNameDmd { get; set; }

        /// <summary>
        /// モード
        /// </summary>
        public string Mode { get; set; }

        /// <summary>
        /// 未入金請求書数
        /// </summary>
        public int BillCount { get; set; }

    }
}
