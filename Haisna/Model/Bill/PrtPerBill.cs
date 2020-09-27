using System;

namespace Hainsi.Entity.Model.Bill
{
    /// <summary>
    /// 領収書・請求書印刷表示
    /// </summary>
    public class PrtPerBill
    {
        /// <summary>
        /// 請求日 配列
        /// </summary>
        public string[] DmddateArray { get; set; }

        /// <summary>
        /// 請求書Ｓｅｑ 配列
        /// </summary>
        public string[] BillseqArray { get; set; }

        /// <summary>
        /// 請求書枝番 配列
        /// </summary>
        public string[] BranchnoArray { get; set; }

        /// <summary>
        /// 請求宛先 配列
        /// </summary>
        public string[] BillNameArray { get; set; }

        /// <summary>
        /// 敬称 配列
        /// </summary>
        public string[] KeishouArray { get; set; }

        /// <summary>
        /// 印刷対象
        /// </summary>
        public string PrtKbn { get; set; }

        /// <summary>
        /// 動作モード
        /// </summary>
        public string Act { get; set; }
    }
}
