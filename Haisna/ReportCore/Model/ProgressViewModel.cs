using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.ReportCore.Model
{
    /// <summary>
    /// 進捗状況のAPI用モデル
    /// </summary>
    public class ProgressViewModel
    {
        /// <summary>ステータス</summary>
        public int Status { get; set; }
        /// <summary>カウント</summary>
        public int Count { get; set; }
    }
}
