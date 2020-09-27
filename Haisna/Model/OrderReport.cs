using System;

namespace Hainsi.Entity.Model.OrderReport
{
    /// <summary>
    /// レポート情報モデル
    /// </summary>
    public class OrderReport
    {
        /// <summary>
        /// 予約番号
        /// </summary>
        public int RsvNo { get; set; }

        /// <summary>
        /// オーダ種別
        /// </summary>
        public string OrderDiv { get; set; }

        /// <summary>
        /// オーダ日付
        /// </summary>
        public DateTime OrderDate { get; set; }

        /// <summary>
        /// オーダ番号
        /// </summary>
        public int OrderNo { get; set; }

        /// <summary>
        /// レポートID
        /// </summary>
        public string ReportId { get; set; }

        /// <summary>
        /// レポート種別
        /// </summary>
        public string ReportDiv { get; set; }

        /// <summary>
        /// レポート種別ID
        /// </summary>
        public string ReportDivId { get; set; }

        /// <summary>
        /// 実施者
        /// </summary>
        public string ActName { get; set; }

        /// <summary>
        /// 実施者ID
        /// </summary>
        public string ActId { get; set; }

        /// <summary>
        /// 実施部署
        /// </summary>
        public string ActPostCd { get; set; }

        /// <summary>
        /// 報告者
        /// </summary>
        public string Reporter { get; set; }

        /// <summary>
        /// 報告者ID
        /// </summary>
        public string ReporterId { get; set; }

        /// <summary>
        /// 報告日時
        /// </summary>
        public DateTime ReportDate { get; set; }

        /// <summary>
        /// 報告部署
        /// </summary>
        public string ReportPostCd { get; set; }

        /// <summary>
        /// 承認者
        /// </summary>
        public string RecogName { get; set; }

        /// <summary>
        /// 承認者ID
        /// </summary>
        public string RecogId { get; set; }

        /// <summary>
        /// 承認日時
        /// </summary>
        public DateTime RecogDate { get; set; }

        /// <summary>
        /// 承認フラグ
        /// </summary>
        public string RecogStatus { get; set; }

        /// <summary>
        /// HTMLレポート本文
        /// </summary>
        public string HtmlReport { get; set; }
    }
}
