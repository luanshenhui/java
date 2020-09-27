using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepItemHistoryモデル
    /// </summary>
    public class RepItemHistory
    {
        /// <summary>
        /// 開始日付
        /// </summary>
        public DateTime StrDate { get; set; }
        /// <summary>
        /// 終了日付
        /// </summary>
        public DateTime EndDate { get; set; }
		/// <summary>
		/// ユニット
		/// </summary>
		public string Unit { get; set; }

    }
}