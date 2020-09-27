namespace Hainsi.Entity.Model.Item
{
    /// <summary>
    /// 読み込み用依頼項目一覧モデル
    /// </summary>
    public class RequestItemList
    {
        /// <summary>
        /// 検査項目コード
        /// </summary>
        public string ItemCd { get; set; }

        /// <summary>
        /// 検査分類コード
        /// </summary>
        public string ClassCd { get; set; }

        /// <summary>
        /// 結果問診フラグ
        /// </summary>
        public string RslQue { get; set; }

        /// <summary>
        /// 依頼項目名
        /// </summary>
        public string RequestName { get; set; }

        /// <summary>
        /// 依頼項目略称
        /// </summary>
        public string RequestSName { get; set; }

        /// <summary>
        /// 進捗分類コード
        /// </summary>
        public string ProgressCd { get; set; }

        /// <summary>
        /// 未入力チェック
        /// </summary>
        public string EntryOk { get; set; }

        /// <summary>
        /// ガイド検索用文字列
        /// </summary>
        public string SearchChar { get; set; }

        /// <summary>
        /// 検査実施日分類コード
        /// </summary>
        public string OpeClassCd { get; set; }

        /// <summary>
        /// 検査分類名称
        /// </summary>
        public string ClassName { get; set; }

        /// <summary>
        /// 進捗分類名称
        /// </summary>
        public string ProgressName { get; set; }

        /// <summary>
        /// 検査実施日分類名
        /// </summary>
        public string OpeClassName { get; set; }
    }
}
