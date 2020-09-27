using System;

namespace Hainsi.Entity.Model.OrderedDoc2
{
    /// <summary>
    /// オーダ送信済文書２モデル
    /// </summary>
    public class OrderedDoc2
    {
        /// <summary>
        /// 予約番号
        /// </summary>
        public int Rsvno { get; set; }

        /// <summary>
        /// 文書種別コード
        /// </summary>
        public string DocCode { get; set; }

        /// <summary>
        /// 文書枝番
        /// </summary>
        public string DocSeq { get; set; }

        /// <summary>
        /// オーダ番号
        /// </summary>
        public int OrderNo { get; set; }

        /// <summary>
        /// 発生日時
        /// </summary>
        public DateTime CreateDate { get; set; }

        /// <summary>
        /// 版数
        /// </summary>
        public int OrderSeq { get; set; }

        /// <summary>
        /// 個人ID
        /// </summary>
        public string PerId { get; set; }

        /// <summary>
        /// 受診日
        /// </summary>
        public DateTime CslDate { get; set; }

        /// <summary>
        /// 受診時年齢
        /// </summary>
        public Single Age { get; set; }

        /// <summary>
        /// 当日ID
        /// </summary>
        public int DayId { get; set; }

        /// <summary>
        /// 送信日時
        /// </summary>
        public DateTime SendDate { get; set; }

        /// <summary>
        /// コースコード
        /// </summary>
        /// <remarks>※テーブルにはない</remarks>
        public string Cscd { get; set; }
        
    }
}
