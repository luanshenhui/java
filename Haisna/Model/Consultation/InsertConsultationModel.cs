using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.Consultation
{
    /// <summary>
    /// 受診情報登録モデル
    /// </summary>
    public class InsertConsultationModel
    {
        /// <summary>
        /// 基本情報
        /// </summary>
        public ConsultationBaseModel Consult { get; set; }

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
