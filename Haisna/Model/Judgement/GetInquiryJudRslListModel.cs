using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.Judgement
{
    /// <summary>
    /// 判定結果情報モデル
    /// </summary>
    public class GetInquiryJudRslListModel
    {
        /// <summary>
        /// 判定分類コード
        /// </summary>
        public int JudClassCd { get; set; }
        /// <summary>
        /// 判定分類名称
        /// </summary>
        public string JudClassName { get; set; }
        /// <summary>
        /// 略称
        /// </summary>
        public string JudSClassName { get; set; }
        /// <summary>
        /// 定型所見名称
        /// </summary>
        public string StdJudNote { get; set; }
        /// <summary>
        /// フリー判定コメント
        /// </summary>
        public string FreeJudCmt { get; set; }
    }
}
