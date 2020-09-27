using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepItemモデル
    /// </summary>
    public class RepItem
    {

        /// <summary>
        /// コンストラクタ
        /// </summary>
        public RepItem()
        {
            this.StdValues = new RepStdValues();
            this.Histories = new RepItemHistories();
        }

        /// <summary>
        /// 検査項目コード
        /// </summary>
        public string ItemCd { get; set; }
		/// <summary>
		/// サフィックス
		/// </summary>
		public string Suffix { get; set; }
		/// <summary>
		/// 結果タイプ
		/// </summary>
		public int ResultType { get; set; }
		/// <summary>
		/// 報告書用項目名
		/// </summary>
		public string ItemRName { get; set; }
		/// <summary>
		/// 英語項目名
		/// </summary>
		public string ItemEName { get; set; }
		/// <summary>
		/// 問診文章
		/// </summary>
		public string ItemQName { get; set; }
		/// <summary>
		/// 報告書未出力フラグ
		/// </summary>
		public int NoPrintFlg { get; set; }
        /// <summary>
        /// 基準値コレクション
        /// </summary>
        public RepStdValues StdValues { get; }

        /// <summary>
        /// 検査項目履歴コレクション
        /// </summary>
        public RepItemHistories Histories { get; }

    }
}