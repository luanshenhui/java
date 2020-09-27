namespace Hainsi.Entity.Model.Bill
{
    /// <summary>
    /// 個人請求詳細情報モデル
    /// </summary>
    public class PerBill_c
    {
		/// <summary>
		/// 請求日
		/// </summary>
		public string DMDDate  { get; set; }

		/// <summary>
		/// 請求書Ｓｅｑ
		/// </summary>
		public string BillSeq  { get; set; }

		/// <summary>
		/// 請求書枝番
		/// </summary>
		public string BranchNo  { get; set; }

		/// <summary>
		/// 請求明細行Ｎｏ
		/// </summary>
		public string BillLineNo  { get; set; }

		/// <summary>
		/// 金額
		/// </summary>
		public string Price  { get; set; }

		/// <summary>
		/// 調整金額
		/// </summary>
		public string EditPrice  { get; set; }

		/// <summary>
		/// 税額
		/// </summary>
		public string TaxPrice  { get; set; }

		/// <summary>
		/// 調整税額
		/// </summary>
		public string EditTax  { get; set; }

		/// <summary>
		/// 明細名称
		/// </summary>
		public string LineName  { get; set; }

		/// <summary>
		/// 予約番号
		/// </summary>
		public string RsvNo  { get; set; }

		/// <summary>
		/// 受診金額Ｓｅｑ
		/// </summary>
		public string PriceSeq  { get; set; }

		/// <summary>
		/// 消費税免除フラグ
		/// </summary>
		public string OmitTaxFlg  { get; set; }

		/// <summary>
		/// セット外明細コード（省略可）
		/// </summary>
		public string OtherLineDivCd  { get; set; }

	}
}