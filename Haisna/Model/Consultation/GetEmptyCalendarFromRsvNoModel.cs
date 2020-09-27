using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.Consultation
{
    /// <summary>
    /// 指定年月の予約空き状況取得モデル(予約番号指定)
    /// </summary>
    public class GetEmptyCalendarFromRsvNoModel
    {
        /// <summary>
        /// 検索モード
        /// </summary>
        public string Mode { get; set; }
        /// <summary>
        /// 年
        /// </summary>
        public long CslYear { get; set; }
        /// <summary>
        /// 月
        /// </summary>
        public long CslMonth { get; set; }
        /// <summary>
        /// 予約番号
        /// </summary>
        public List<dynamic> RsvNo { get; set; }
        /// <summary>
        /// 予約群コード
        /// </summary>
        public List<dynamic> RsvGrpCd { get; set; }
    }
}
