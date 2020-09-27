namespace Hainsi.Entity.Model.Consultation
{
    /// <summary>
    /// 受診オプションテーブルレコードを更新
    /// </summary>
    public class UpdateConsultOptionModel
    {
        /// <summary>
        /// オプションコード
        /// </summary>
        public string[] OptCd { get; set; }

        /// <summary>
        /// オプション枝番
        /// </summary>
        public int[] OptBranchNo { get; set; }

        /// <summary>
        /// 受診要否
        /// </summary>
        public string[] Consults { get; set; }

    }
}