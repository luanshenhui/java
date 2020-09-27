namespace Hainsi.Entity.Model.Sentence
{
    /// <summary>
    /// 文章一覧情報モデル
    /// </summary>
    public class SentenceList
    {
        /// <summary>
        /// 検査項目コード
        /// </summary>
        public string ItemCd { get; set; }

        /// <summary>
        /// 依頼項目名
        /// </summary>
        public string RequestName { get; set; }

        /// <summary>
        /// 項目タイプ
        /// </summary>
        public string ItemType { get; set; }

        /// <summary>
        /// 文章コード
        /// </summary>
        public string StcCd { get; set; }

        /// <summary>
        /// 略文章
        /// </summary>
        public string ShortStc { get; set; }

        /// <summary>
        /// 文章
        /// </summary>
        public string LongStc { get; set; }

        /// <summary>
        /// 検査連携用変換文章
        /// </summary>
        public string InsStc { get; set; }
    }
}
