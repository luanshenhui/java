using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.Consultation
{
    /// <summary>
    /// 受診情報更新モデル
    /// </summary>
    public class UpdateConsultationBaseModel : ConsultationBaseModel
    {
        /// <summary>
        /// 現在の当日ID
        /// </summary>
        public string CurDayId { get; set; }

        /// <summary>
        /// 読み込み直後の個人ID
        /// </summary>
        public string CurrentPerId { get; set; }
    }
}
