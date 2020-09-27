namespace Hainsi.Entity.Model.OrderedItem2
{
    /// <summary>
    /// オーダ送信済項目モデル
    /// </summary>
    public class OrderedItem2
    {
        /// <summary>
        /// 予約番号
        /// </summary>
        public int Rsvno { get; set; }

        /// <summary>
        /// 文書種別コード
        /// </summary>
        public string DocCode { get; set; }

        /// <summary>
        /// 文書枝番
        /// </summary>
        public string DocSeq { get; set; }

        /// <summary>
        /// 検査項目コード
        /// </summary>
        public string ItemCd { get; set; }

        /// <summary>
        /// サフィックス
        /// </summary>
        public string Suffix { get; set; }
        
    }
}
