using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.Consultation
{
    /// <summary>
    /// 当日IDバリデーションモデル
    /// </summary>
    public class RegisterDayIdModel
    {
        /// <summary>
        /// 受付処理モード(0:受付処理は行わない、1:最終発番ＩＤの次番号で発番、2:欠番を検索して発番、3:p_DayId値で発番)
        /// </summary>
        public string Mode { get; set; }

        /// <summary>
        /// 当日ID
        /// </summary>
        public string DayId { get; set; }
    }
}
