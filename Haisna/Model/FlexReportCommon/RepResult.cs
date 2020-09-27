using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepResultモデル
    /// </summary>
    public class RepResult
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
		/// 検査結果
		/// </summary>
		public string Result { get; set; }
		/// <summary>
		/// 結果コメントコード1
		/// </summary>
		public string RslCmtCd1 { get; set; }
		/// <summary>
		/// 結果コメント名1
		/// </summary>
		public string RslCmtName1 { get; set; }
		/// <summary>
		/// 結果コメントコード2
		/// </summary>
		public string RslCmtCd2 { get; set; }
		/// <summary>
		/// 結果コメント名2
		/// </summary>
		public string RslCmtName2 { get; set; }
		/// <summary>
		/// 基準値フラグ
		/// </summary>
		public string StdFlg { get; set; }

    }
}