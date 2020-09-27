namespace Hainsi.Entity.Model.Result
{
    /// <summary>
    /// 検査結果情報モデル
    /// </summary>
    public class ResultRec
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
        /// 検査結果値
        /// </summary>
        public string Result { get; set; }

        /// <summary>
        /// 結果コメントコード1
        /// </summary>
        public string RslCmtCd1 { get; set; }

        /// <summary>
        /// 結果コメントコード2
        /// </summary>
        public string RslCmtCd2 { get; set; }

        /// <summary>
        /// 検査中止フラグ
        /// </summary>
        public string StopFlg { get; set; }

        /// <summary>
        /// 予約番号
        /// </summary>
        public string RsvNo { get; set; }
    }
}
