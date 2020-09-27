namespace Hainsi.Entity.Model.Group
{
    /// <summary>
    /// 読み込み用グループ一覧モデル
    /// </summary>
    public class GroupList
    {
        /// <summary>
        /// グループ区分
        /// </summary>
        public string GrpDiv { get; set; }

        /// <summary>
        /// グループコード
        /// </summary>
        public string GrpCd { get; set; }

        /// <summary>
        /// グループ名
        /// </summary>
        public string GrpName { get; set; }

        /// <summary>
        /// 検査分類コード
        /// </summary>
        public string ClassCd { get; set; }

        /// <summary>
        /// 検査分類名称
        /// </summary>
        public string ClassName { get; set; }

        /// <summary>
        /// ガイド検索用文字列
        /// </summary>
        public string SearchChar { get; set; }

        /// <summary>
        /// システム制御用グループ
        /// </summary>
        public string SystemGrp { get; set; }

        /// <summary>
        /// 旧セットコード
        /// </summary>
        public string OldSetCd { get; set; }
    }
}
