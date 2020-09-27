namespace Hainsi.Entity.Model.Bill
{
    /// <summary>
    /// 挿入用個人情報モデル
    /// </summary>
    public class CreatePerBill
    {
        /// <summary>
        /// MAX枚数
        /// </summary>
        public string SelectNo { get; set; }

        /// <summary>
        /// 請求日
        /// </summary>
        public string DmdDate { get; set; }

        /// <summary>
        /// 予約番号
        /// </summary>
        public string RsvNo { get; set; }

        /// <summary>
        /// 作成ページ（配列）
        /// </summary>
        public string[] Page { get; set; }

        /// <summary>
        /// 受診金額Ｓｅｑ（配列）
        /// </summary>
        public string[] AllPriceSeq { get; set; }

        /// <summary>
        /// 更新者ＩＤ
        /// </summary>
        public string UpdUser { get; set; }
    }
}
