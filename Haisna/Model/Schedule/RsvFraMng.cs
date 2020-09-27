namespace Hainsi.Entity.Model.Schedule
{
    /// <summary>
    /// 特定健診コメント情報モデル
    /// </summary>
    public class RsvFraMng
    {

        /// <summary>
        /// 受診日
        /// </summary>
        public string CslDate { get; set; }

        /// <summary>
        /// コースコード
        /// </summary>
        public string CsCd { get; set; }

        /// <summary>
        /// 予約群コード
        /// </summary>
        public string RsvGrpCd { get; set; }

        /// <summary>
        /// 予約可能人数（共通）
        /// </summary>
        public int MaxCnt { get; set; }

        /// <summary>
        /// 予約可能人数（男性）
        /// </summary>
        public int MaxCnt_m { get; set; }

        /// <summary>
        /// 予約可能人数（女性）
        /// </summary>
        public int MaxCnt_f { get; set; }

        /// <summary>
        /// オーバ可能人数（共通）
        /// </summary>
        public int OverCnt { get; set; }

        /// <summary>
        /// オーバ可能人数（男性）
        /// </summary>
        public int OverCnt_m { get; set; }

        /// <summary>
        /// オーバ可能人数（女性）
        /// </summary>
        public int OverCnt_f { get; set; }
    }
}
