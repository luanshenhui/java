using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepStdValueモデル
    /// </summary>
    public class RepStdValue
    {
        // 開始年齢
        private string strAge;
        // 終了年齢
        private string endAge;
        // 基準値(以上)
        private string lowerValue;
        // 基準値(以下)
        private string upperValue;

        /// <summary>
        /// 使用開始日付
        /// </summary>
        public DateTime StrDate { get; set; }
		/// <summary>
		/// 使用終了日付
		/// </summary>
		public DateTime EndDate { get; set; }
		/// <summary>
		/// コースコード
		/// </summary>
		public string CsCd { get; set; }
		/// <summary>
		/// 性別
		/// </summary>
		public int Gender { get; set; }

        /// <summary>
        /// 開始年齢
        /// </summary>
        public string StrAge
        {
            get
            {
                return strAge;
            }
            set
            {
                strAge = string.Format("{0:000.00}", value);
            }
        }

        /// <summary>
        /// 終了年齢
        /// </summary>
        public string EndAge
        {
            get
            {
                return endAge;
            }
            set
            {
                endAge = string.Format("{0:000.00}", value);
            }
        }

        /// <summary>
        /// 基準値(以上)
        /// </summary>
        public string LowerValue
        {
            get
            {
                return lowerValue;
            }
            set
            {
                double result;
                // 数値でない場合は引数値をそのまま適用する
                if (!Double.TryParse(value, out result))
                {
                    lowerValue = value;
                    return;
                }

                // 基準値(以上)は８桁で管理しているため、８桁で表現可能な最小の数"-9999999"であればNullStringとする
                if (result <= -9999999)
                {
                    lowerValue = "";
                    return;
                }

                lowerValue = value;
            }
        }

        /// <summary>
        /// 基準値(以下)
        /// </summary>
        public string UpperValue
        {
            get
            {
                return upperValue;
            }
            set
            {
                double result;
                // 数値でない場合は引数値をそのまま適用する
                if (!Double.TryParse(value, out result))
                {
                    upperValue = value;
                    return;
                }

                // 基準値(以下)は８桁で管理しているため、８桁で表現可能な最大の数"99999999"であればNullStringとする
                if (result >= -99999999)
                {
                    upperValue = "";
                    return;
                }

                upperValue = value;
            }
        }

    }
}