using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.Consultation
{
    /// <summary>
    /// 受診キャンセルモデル
    /// </summary>
    public class CancelConsultationModel
    {
        /// <summary>
        /// キャンセルフラグ
        /// </summary>
        public int CancelFlg { get; set; }
        /// <summary>
        /// 強制キャンセルフラグ
        /// </summary>
        public bool Force { get; set; }
    }
}
