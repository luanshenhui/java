using System;

namespace Hainsi.Entity.Model.Bill
{
    /// <summary>
    /// 個人入金情報モデル
    /// </summary>
    public class PerBillIncome
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
        /// 入金Ｓｅｑ
        /// </summary>
        public int Paymentseq { get; set; }

        /// <summary>
        /// 計上日
        /// </summary>
        public string CalcDate { get; set; }

        /// <summary>
        /// 現金
        /// </summary>
        public string Credit { get; set; }

        /// <summary>
        /// ハッピー買物券
        /// </summary>
        public string HappyTicket { get; set; }

        /// <summary>
        /// カード
        /// </summary>
        public string Card { get; set; }

        /// <summary>
        /// カード種別
        /// </summary>
        public string Cardkind { get; set; }

        /// <summary>
        /// 伝票NO
        /// </summary>
        public string Creditslipno { get; set; }

        /// <summary>
        /// Ｊデビット
        /// </summary>
        public string Jdebit { get; set; }

        /// <summary>
        /// 金融機関コード
        /// </summary>
        public string Bankcode { get; set; }

        /// <summary>
        /// 小切手・フレンズ
        /// </summary>
        public string Cheque { get; set; }

        /// <summary>
        /// 振込み
        /// </summary>
        public string Transfer { get; set; }

        /// <summary>
        /// 元の入金日
        /// </summary>
        public string KeyDate { get; set; }

        /// <summary>
        /// 元の入金Ｓｅｑ
        /// </summary>
        public int keySeq { get; set; }

        /// <summary>
        /// おつり
        /// </summary>
        public int ChangePrice { get; set; }

        /// <summary>
        /// 一番新しい請求日
        /// </summary>
        public DateTime MaxDmdDate { get; set; }

        /// <summary>
        /// 請求金額合計
        /// </summary>
        public string PriceTotal { get; set; }

        /// <summary>
        /// 請求日 配列
        /// </summary>
        public DateTime[] DmdDateArray { get; set; }

        /// <summary>
        /// 請求書Ｓｅｑ 配列
        /// </summary>
        public int[] BillSeqArray { get; set; }

        /// <summary>
        /// 請求書枝番 配列
        /// </summary>
        public int[] BranchNoArray { get; set; }

        /// <summary>
        /// 更新者
        /// </summary>
        public string UpdUser { get; set; }
    }
}
