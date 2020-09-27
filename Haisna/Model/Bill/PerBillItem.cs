using System;

namespace Hainsi.Entity.Model.Bill
{
    /// <summary>
    /// 
    /// </summary>
    public class PerBillItem : InsertPerBill_c
    {
        /// <summary>
        /// 請求書コメント
        /// </summary>
        public string BillComment { get; set; }
        /// <summary>
        /// 指定可能個人を
        /// </summary>
        public int PerCount { get; set; }
        /// <summary>
        /// セット外明細コード
        /// </summary>
        public string[] OtherLineDivCdS { get; set; }
        /// <summary>
        /// 個人id合計
        /// </summary>
        public string[] PerIdS { get; set; }
        /// <summary>
        /// アップデータ
        /// </summary>
        public string UpdUser { get; set; }
        /// <summary>
        /// 新しい請求発生日
        /// </summary>
        public DateTime NewDmdDate { get; set; }
        /// <summary>
        /// 個人id
        /// </summary>
        public string PerId { get; set; }
    }
}
