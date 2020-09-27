namespace Hainsi.Entity.Model.Follow
{
    /// <summary>
    /// 受診者・検査項目情報モデル
    /// </summary>
    public class FollowResult
    {
        /// <summary>
        /// 予約番号
        /// </summary>
        public int RsvNo { get; set; }

        /// <summary>
        /// 判定分類コード
        /// </summary>
        public int JudClassCd { get; set; }

        /// <summary>
        /// 二次検査実施区分
        /// </summary>
        public string SecEquipDiv { get; set; }

        /// <summary>
        /// 判定コード（フォロー登録時判定結果）
        /// </summary>
        public string JudCd { get; set; }
    }
}
