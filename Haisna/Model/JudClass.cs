namespace Hainsi.Entity.Model
{
    /// <summary>
    /// 判定分類情報モデル
    /// </summary>
    public class JudClass
    {
        /// <summary>
        /// 判定分類コード
        /// </summary>
        public string JudClassCd { get; set; }

        /// <summary>
        /// 判定分類名称
        /// </summary>
        public string JudClassName { get; set; }

        /// <summary>
        /// 統計用総合判定フラグ
        /// </summary>
        public string AllJudFlg { get; set; }

        /// <summary>
        /// 判定分類表示順
        /// </summary>
        public string ViewOrder { get; set; }

        /// <summary>
        /// 検査結果表示モード
        /// </summary>
        public string ResultDispMode { get; set; }

        /// <summary>
        /// コメント表示モード
        /// </summary>
        public string CommentOnly { get; set; }

        /// <summary>
        /// 自動判定対象外フラグ
        /// </summary>
        public string NotAutoFlg { get; set; }

        /// <summary>
        /// 通常判定対象外フラグ
        /// </summary>
        public string NotNormalFlg { get; set; }
    }
}
