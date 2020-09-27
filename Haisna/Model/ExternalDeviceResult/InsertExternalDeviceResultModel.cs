namespace Hainsi.Entity.Model
{
    /// <summary>
    /// 検査分類情報モデル
    /// </summary>
    public class InsertExternalDeviceResultModel
    {
        /// <summary>
        /// 計測機器名
        /// </summary>
        public string Device { get; set; }

        /// <summary>
        /// 予約番号
        /// </summary>
        public int? Rsvno { get; set; }

        /// <summary>
        /// 計測器検査結果
        /// </summary>
        public string Results { get; set; }
    }
}
