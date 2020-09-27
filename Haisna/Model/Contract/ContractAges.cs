namespace Hainsi.Entity.Model.Contract
{

    /// <summary>
    /// 契約年齢情報モデル
    /// </summary>
    public class ContractAges
    {
        /// <summary>
        /// Seq
        /// </summary>
        public int Seq { get; set; }
        /// <summary>
        /// 開始年齢
        /// </summary>
        public double? StrAge { get; set; }

        /// <summary>
        /// 適終了年齢
        /// </summary>
        public double? EndAge { get; set; }

        /// <summary>
        /// 年齢区分
        /// </summary>
        public string Agediv { get; set; }

    }
}
