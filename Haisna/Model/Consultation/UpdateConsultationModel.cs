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
    public class UpdateConsultationModel
    {
        /// <summary>
        /// 基本情報
        /// </summary>
        public UpdateConsultationBaseModel Consult { get; set; }

        /// <summary>
        /// 受診付属情報
        /// </summary>
        public ConsultDetailModel ConsultDetail { get; set; }

        /// <summary>
        /// 検査セット
        /// </summary>
        public IDictionary<string, int?> ConsultOptions { get; set; }
    }
}
