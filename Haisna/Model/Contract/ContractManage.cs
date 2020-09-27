namespace Hainsi.Entity.Model.Contract
{
    /// <summary>
    /// 契約管理情報モデル
    /// </summary>
    public class ContractManage
    {
        /// <summary>
        /// 契約パターンコード
        /// </summary>
        public int CtrPtCd { get; set; }

        /// <summary>
        /// 団体コード1
        /// </summary>
        public string OrgCd1 { get; set; }

        /// <summary>
        /// 団体コード2
        /// </summary>
        public string OrgCd2 { get; set; }

        /// <summary>
        /// 参照先団体コード1
        /// </summary>
        public string RefOrgCd1 { get; set; }

        /// <summary>
        /// 参照先団体コード2
        /// </summary>
        public string RefOrgCd2 { get; set; }

    }
}
