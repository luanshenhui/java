using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepJudgementモデル
    /// </summary>
    public class RepJudgement
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        public RepJudgement()
        {
            this.StdJudgements = new RepStdJudgements();
        }

        /// <summary>
        /// JudClassCd
        /// </summary>
        public int JudClassCd { get; set; }
		/// <summary>
		/// JudClassName
		/// </summary>
		public string JudClassName { get; set; }
		/// <summary>
		/// JudCd
		/// </summary>
		public string JudCd { get; set; }
		/// <summary>
		/// JudRName
		/// </summary>
		public string JudRName { get; set; }
		/// <summary>
		/// GovMngJud
		/// </summary>
		public string GovMngJud { get; set; }
		/// <summary>
		/// GovMngJudName
		/// </summary>
		public string GovMngJudName { get; set; }
		/// <summary>
		/// DoctorName
		/// </summary>
		public string DoctorName { get; set; }
        /// <summary>
        /// FreeJudCmt
        /// </summary>
        public string FreeJudCmt { get; set; }
		/// <summary>
		/// GuidanceStc
		/// </summary>
		public string GuidanceStc { get; set; }
        /// <summary>
        /// 定型所見コレクション
        /// </summary>
        public RepStdJudgements StdJudgements { get; }

    }
}