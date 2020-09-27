using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.Consultation
{
    /// <summary>
    /// 印刷状況モデル
    /// </summary>
    public class PrintStatusModel
    {
        /// <summary>
        /// はがき出力日時
        /// </summary>
        public DateTime? CardPrintDate { get; set; }
        /// <summary>
        /// 一式書式出力日時
        /// </summary>
        public DateTime? FormPrintDate { get; set; }
    }
}
