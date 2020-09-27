namespace Hainsi.Entity.Model.SpecialInterview
{
    /// <summary>
    /// 特定健診コメント更新情報モデル
    /// </summary>
    public class SpecialJudCmtList
    {
        /// <summary>
        /// 予約番号
        /// </summary>
        public string Rsvno { get; set; }

        /// <summary>
        ///  階層化コメント(表示分類)
        /// </summary>
        public string Dispmode { get; set; }

        /// <summary>
        /// 更新ユーザ
        /// </summary>
        public string UpdUser { get; set; }

        /// <summary>
        /// 変更の特定健診コメント情報
        /// </summary>
        public SpecialJudCmt[] SpecialJudCmt { get; set; }
    }
}
