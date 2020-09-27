namespace Hainsi.Entity.Model.Item
{
    /// <summary>
    /// 読み込み用検査項目一覧モデル
    /// </summary>
    public class ItemList
    {
        /// <summary>
        /// 検査項目コード
        /// </summary>
        public string ItemCd { get; set; }

        /// <summary>
        /// サフィックス
        /// </summary>
        public string Suffix { get; set; }

        /// <summary>
        /// 検査項目名
        /// </summary>
        public string ItemName { get; set; }

        /// <summary>
        /// 結果タイプ
        /// </summary>
        public string ResultType { get; set; }

        /// <summary>
        /// 項目タイプ
        /// </summary>
        public string ItemType { get; set; }

        /// <summary>
        /// CU経年変化表示対象
        /// </summary>
        public string CuTargetFlg { get; set; }

        /// <summary>
        /// 検査分類名称
        /// </summary>
        public string ClassName { get; set; }
    }
}
