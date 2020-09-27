namespace Hainsi.Entity.Model.Result
{
    /// <summary>
    /// ステータス付き検査結果情報モデル
    /// </summary>
    public class ResultWithStatus : ResultRec
    {
        /// <summary>
        /// 略文章
        /// </summary>
        public string ShortStc { get; set; }

        /// <summary>
        /// 結果エラーステータス
        /// </summary>
        public string ResultError { get; set; }

        /// <summary>
        /// 結果コメント名称1
        /// </summary>
        public string RslCmtName1 { get; set; }

        /// <summary>
        /// 結果コメント1のエラーステータス
        /// </summary>
        public string RslCmtError1 { get; set; }

        /// <summary>
        /// 結果コメント名称2
        /// </summary>
        public string RslCmtName2 { get; set; }

        /// <summary>
        /// 結果コメント2のエラーステータス
        /// </summary>
        public string RslCmtError2 { get; set; }
    }
}
