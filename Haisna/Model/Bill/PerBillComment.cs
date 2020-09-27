using System;

namespace Hainsi.Entity.Model.Bill
{
    /// <summary>
    /// 請求書Ｎｏ更新モデル
    /// </summary>
    public class PerBillComment
    {
        /// <summary>
        /// 請求書コメント
        /// </summary>
        public string BillComment { get; set; }
        /// <summary>
        /// 請求発生日
        /// </summary>
        public DateTime DmdDate { get; set; }
        /// <summary>
        /// 請求書Seq
        /// </summary>
        public int BillSeq { get; set; }
        /// <summary>
        /// 請求書枝番
        /// </summary>
        public int BranchNo { get; set; }
        /// <summary>
        /// 予約番号
        /// </summary>
        public int RsvNo { get; set; }

    }
}
