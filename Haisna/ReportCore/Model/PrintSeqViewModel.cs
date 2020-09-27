using System.Collections.Generic;

namespace Hainsi.ReportCore.Model
{
    /// <summary>
    /// 帳票作成開始APIの戻り値のモデル
    /// </summary>
    public class PrintSeqViewModel
    {
        /// <summary>エラーメッセージ</summary>
        public List<string> Messages { get; set; }
        /// <summary>プリントSEQ</summary>
        public long? PrintSeq { get; set; }
    }
}
