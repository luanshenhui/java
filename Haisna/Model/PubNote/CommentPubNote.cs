using System;

namespace Hainsi.Entity.Model.PubNote
{
    /// <summary>
    /// コメント情報モデル
    /// </summary>
    public class CommentPubNote
    {
        /// <summary>
        /// SEQ
        /// </summary>
        public int? Seq { get; set; }

        /// <summary>
        /// 検索情報（1:受診情報、2:個人、3:団体、4:契約）
        /// </summary>
        public int SelInfo { get; set; }

        /// <summary>
        /// 予約番号
        /// </summary>
        public int RsvNo { get; set; }

        /// <summary>
        /// 個人ＩＤ
        /// </summary>
        public string PerId { get; set; }

        /// <summary>
        /// 団体コード１
        /// </summary>
        public string OrgCd1 { get; set; }

        /// <summary>
        /// 団体コード２
        /// </summary>
        public string OrgCd2 { get; set; }

        /// <summary>
        /// 契約パターンコード
        /// </summary>
        public string CtrPtCd { get; set; }

        /// <summary>
        /// 受診情報ノート分類コード
        /// </summary>
        public string PubNoteDivCd { get; set; }

        /// <summary>
        /// 表示対象
        /// </summary>
        public int DispKbn { get; set; }

        /// <summary>
        /// 太字区分
        /// </summary>
        public int BoldFlg { get; set; }

        /// <summary>
        /// ノート
        /// </summary>
        public string PubNote { get; set; }

        /// <summary>
        /// 表示色
        /// </summary>
        public string DispColor { get; set; }

        /// <summary>
        /// 登録者
        /// </summary>
        public string UpdUser { get; set; }
        
    }
}
