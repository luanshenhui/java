namespace Hainsi.Entity.Model.Sentence
{
    /// <summary>
    /// 文章情報モデル
    /// </summary>
    public class Sentence
    {
        /// <summary>
        /// 検査項目コード
        /// </summary>
        public string ItemCd { get; set; }

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
        /// 英語文章
        /// </summary>
        public string EngStc { get; set; }

        /// <summary>
        /// 表示順番
        /// </summary>
        public string ViewOrder { get; set; }

        /// <summary>
        /// 成績書出力順番
        /// </summary>
        public string PrintOrder { get; set; }

        /// <summary>
        /// 文章分類コード
        /// </summary>
        public string StcClassCd { get; set; }

        /// <summary>
        /// イメージファイル名
        /// </summary>
        public string ImageFileName { get; set; }

        /// <summary>
        /// 問診表示ランク
        /// </summary>
        public string QuestionRank { get; set; }

        /// <summary>
        /// 未使用フラグ
        /// </summary>
        public string DelFlg { get; set; }

        /// <summary>
        /// 検査連携用変換文章
        /// </summary>
        public string InsStc { get; set; }

        /// <summary>
        /// 報告書用文章
        /// </summary>
        public string ReptStc { get; set; }
    }
}
