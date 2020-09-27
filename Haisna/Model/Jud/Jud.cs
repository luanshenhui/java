namespace Hainsi.Entity.Model.Jud
{
    /// <summary>
    /// 判定情報モデル
    /// </summary>
    public class Jud
    {
        /// <summary>
        /// 判定コード
        /// </summary>
        public string JudCd { get; set; }

        /// <summary>
        /// 報告書用判定名
        /// </summary>
        public string JudRName { get; set; }

        /// <summary>
        /// 判定用重み
        /// </summary>
        public string Weight { get; set; }

        /// <summary>
        /// 略称
        /// </summary>
        public string JudSName { get; set; }

        /// <summary>
        /// 表示色
        /// </summary>
        public string WebColor { get; set; }
    }
}
