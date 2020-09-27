using Hainsi.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepDisHistoryモデル
    /// </summary>
    public class RepDisHistory
    {
		/// <summary>
		/// 続柄
		/// </summary>
		public int Relation { get; set; }
		/// <summary>
		/// 病名コード
		/// </summary>
		public string DisCd { get; set; }
		/// <summary>
		/// 病名
		/// </summary>
		public string DisName { get; set; }
		/// <summary>
		/// 発病年月
		/// </summary>
		public DateTime? StrDate { get; set; }
		/// <summary>
		/// 治癒年月
		/// </summary>
		public DateTime? EndDate { get; set; }
		/// <summary>
		/// 状態
		/// </summary>
		public string Condition { get; set; }
		/// <summary>
		/// 医療機関
		/// </summary>
		public string Medical { get; set; }

        /// <summary>
        /// 発病年月の年
        /// </summary>
        public int StrYearAd
        {
            get
            {
                return StrDate == null ? 0 : Convert.ToDateTime(string.Format("{0:yyyy/M/d}", StrDate)).Year;
            }

        }

        /// <summary>
        /// 発病年月和暦年
        /// </summary>
        public int StrYearJp
        {
            get
            {
                return StrDate == null ? 0 : WebHains.JapaneseCalendar.GetYear(Convert.ToDateTime(string.Format("{0:yyyy/M/d}", StrDate)));
            }
        }

        /// <summary>
        /// 発病年月和暦元号
        /// </summary>
        public string StrYearGe
        {
            get
            {
                return StrDate == null ? "" : WebHains.GetShortEraName(Convert.ToDateTime(string.Format("{0:yyyy/M/d}", StrDate)));
            }
        }

        /// <summary>
        /// 発病年月の月
        /// </summary>
        public int StrMonth
        {
            get
            {
                return StrDate == null ? 0 : Convert.ToDateTime(string.Format("{0:yyyy/M/d}", StrDate)).Month;
            }
        }

        /// <summary>
        /// 治癒年月の年
        /// </summary>
        public int EndYearAd
        {
            get
            {
                return EndDate == null ? 0 : Convert.ToDateTime(string.Format("{0:yyyy/M/d}", EndDate)).Year;
            }

        }

        /// <summary>
        /// 治癒年月和暦年
        /// </summary>
        public int EndYearJp
        {
            get
            {
                return EndDate == null ? 0 : WebHains.JapaneseCalendar.GetYear(Convert.ToDateTime(string.Format("{0:yyyy/M/d}", EndDate)));
            }
        }

        /// <summary>
        /// 治癒年月和暦元号
        /// </summary>
        public string EndYearGe
        {
            get
            {
                return EndDate == null ? "" : WebHains.GetShortEraName(Convert.ToDateTime(string.Format("{0:yyyy/M/d}", EndDate)));
            }
        }

        /// <summary>
        /// 治癒年月の月
        /// </summary>
        public int EndMonth
        {
            get
            {
                return EndDate == null ? 0 : Convert.ToDateTime(string.Format("{0:yyyy/M/d}", EndDate)).Month;
            }
        }

    }
}