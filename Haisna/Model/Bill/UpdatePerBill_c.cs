namespace Hainsi.Entity.Model.Bill
{
    /// <summary>
    /// 挿入用個人請求詳細情報モデル
    /// </summary>
    public class UpdatePerBill_c : PerBill_c
    {
        /// <summary>
        /// 請求書詳細登録用
        /// </summary>
        public string LineNameDmd { get; set; }
    }
}
