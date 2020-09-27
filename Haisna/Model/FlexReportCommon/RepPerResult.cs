using Hainsi.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepPerResultモデル
    /// </summary>
    public class RepPerResult
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
		/// 報告書用項目名
		/// </summary>
		public string ItemRName { get; set; }
		/// <summary>
		/// 英語項目名
		/// </summary>
		public string ItemEName { get; set; }
		/// <summary>
		/// 検査結果
		/// </summary>
		public string Result { get; set; }
		/// <summary>
		/// 略文章
		/// </summary>
		public string ShortStc { get; set; }
		/// <summary>
		/// 文章
		/// </summary>
		public string LongStc { get; set; }
		/// <summary>
		/// 英語文章
		/// </summary>
		public string EngStc { get; set; }
		/// <summary>
		/// 検査年月日
		/// </summary>
		public DateTime? IspDate { get; set; }

        /// <summary>
        /// 検査年月日の年
        /// </summary>
        public int IspYearAd
        {
            get
            {
                return IspDate == null ? 0 : Convert.ToDateTime(string.Format("{0:yyyy/M/d}", IspDate)).Year;
            }

        }

        /// <summary>
        /// 検査年月日和暦年
        /// </summary>
        public int IspYearJp
        {
            get
            {
                return IspDate == null ? 0 : WebHains.JapaneseCalendar.GetYear(Convert.ToDateTime(string.Format("{0:yyyy/M/d}", IspDate)));
            }
        }

        /// <summary>
        /// 検査年月日和暦元号
        /// </summary>
        public string IspYearGe
        {
            get
            {
                return IspDate == null ? "" : WebHains.GetShortEraName(Convert.ToDateTime(string.Format("{0:yyyy/M/d}", IspDate)));
            }
        }

        /// <summary>
        /// 検査年月日の月
        /// </summary>
        public int IspMonth
        {
            get
            {
                return IspDate == null ? 0 : Convert.ToDateTime(string.Format("{0:yyyy/M/d}", IspDate)).Month;
            }
        }

        /// <summary>
        /// 検査年月日の日
        /// </summary>
        public int IspDay
        {
            get
            {
                return IspDate == null ? 0 : Convert.ToDateTime(string.Format("{0:yyyy/M/d}", IspDate)).Day;
            }
        }
    }
}