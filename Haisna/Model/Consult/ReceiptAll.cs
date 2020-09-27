using System;

namespace Hainsi.Entity.Model.Consult
{
    /// <summary>
    /// 受診歴送信ジャーナル更新モデル
    /// </summary>
    public class ReceiptAll
    {
        /// <summary>
        /// 受診年月日
        /// </summary>
        public DateTime CslDate { get; set; }

        /// <summary>
        /// 受付処理モード
        /// </summary>
        public int Mode { get; set; }

        /// <summary>
        /// 管理番号
        /// </summary>
        public int CntlNo { get; set; }

        /// <summary>
        /// コースコード
        /// </summary>
        public string CsCd { get; set; }
    }
}
