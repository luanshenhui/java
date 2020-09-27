namespace Hainsi.Entity.Model
{
    /// <summary>
    /// 判定コメント情報モデル
    /// </summary>
    public class JudgesComment
    {
        /// <summary>
        /// 判定コメントコード
        /// </summary>
        public string JudCmtCd { get; set; }

        /// <summary>
        /// 判定コメント文章
        /// </summary>
        public string JudCmtStc { get; set; }

        /// <summary>
        /// 判定分類コード
        /// </summary>
        public string JudClassCd { get; set; }

        /// <summary>
        /// 判定分類名称
        /// </summary>
        public string JudClassName { get; set; }

        /// <summary>
        /// 判定コード
        /// </summary>
        public string JudCd { get; set; }

        /// <summary>
        /// 判定用重み
        /// </summary>
        public string Weight { get; set; }

        /// <summary>
        /// 判定コメント英語文章
        /// </summary>
        public string JudCmtStc_E { get; set; }

        /// <summary>
        /// 認識レベル1
        /// </summary>
        public string RecogLevel1 { get; set; }

        /// <summary>
        /// 認識レベル2
        /// </summary>
        public string RecogLevel2 { get; set; }

        /// <summary>
        /// 認識レベル3
        /// </summary>
        public string RecogLevel3 { get; set; }

        /// <summary>
        /// 認識レベル4
        /// </summary>
        public string RecogLevel4 { get; set; }

        /// <summary>
        /// 認識レベル5
        /// </summary>
        public string RecogLevel5 { get; set; }

        /// <summary>
        /// 認識レベル非表示
        /// </summary>
        public string RecogHihyouji { get; set; }

        /// <summary>
        /// 出力順区分
        /// </summary>
        public string OutPriority { get; set; }
    }
}
