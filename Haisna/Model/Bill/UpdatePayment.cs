namespace Hainsi.Entity.Model.Bill
{    /// <summary>
     /// 入金処理
     /// </summary>
    public class UpdatePayment
    {
        /// <summary>
        /// レジ番号
        /// </summary>
        public string Registerno { get; set; }
        /// <summary>
        /// 入金日
        /// </summary>
        public string PaymentDate { get; set; }
        /// <summary>
        /// 現金
        /// </summary>
        public string Cash { get; set; }
        /// <summary>
        /// 入金額
        /// </summary>
        public string PaymentPrice { get; set; }
        /// <summary>
        /// 入金種別
        /// </summary>
        public int PaymentDiv { get; set; }
        /// <summary>
        /// カード種別
        /// </summary>
        public string CardKind { get; set; }
        /// <summary>
        /// 伝票No.
        /// </summary>
        public string Creditslipno { get; set; }
        /// <summary>
        /// 金融機関
        /// </summary>
        public string BankCode { get; set; }
        /// <summary>
        /// 入金コメント
        /// </summary>
        public string PayNote { get; set; }
        /// <summary>
        /// 更新者
        /// </summary>
        public string Upduser { get; set; }
    }
}
