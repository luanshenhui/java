namespace Hainsi.Entity.Model.Bill
{
    /// <summary>
    /// 挿入用個人情報モデル
    /// </summary>
    public class UpdatePerBill
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
        /// 請求明細行Ｎｏ
        /// </summary>
        public int BilllineNo { get; set; }

        /// <summary>
        /// 金額
        /// </summary>
        public int Price { get; set; }

        /// <summary>
        /// 調整金額
        /// </summary>
        public int EditPrice { get; set; }


        /// <summary>
        /// 税額
        /// </summary>
        public int TaxPrice { get; set; }

        /// <summary>
        /// 調整税額
        /// </summary>
        public int EditTax { get; set; }

        /// <summary>
        /// 明細名称
        /// </summary>
        public string LineName { get; set; }

        /// <summary>
        /// 予約番号
        /// </summary>
        public int RsvNo { get; set; }

        /// <summary>
        /// 受診金額Ｓｅｑ
        /// </summary>
        public int PriceSeq { get; set; }

        /// <summary>
        /// 消費税免除フラグ
        /// </summary>
        public int OmittaxFlg { get; set; }

        /// <summary>
        /// セット外明細コード
        /// </summary>
        public string OtherLineDivcd { get; set; }
    }
}
