using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.Consultation
{
    /// <summary>
    /// 受診情報
    /// </summary>
    public class ConsultationBaseModel
    {
        /// <summary>
        /// 受診日
        /// </summary>
        public string CslDate { get; set; }

        /// <summary>
        /// 個人ID
        /// </summary>
        public string PerId { get; set; }

        /// <summary>
        /// コースコード
        /// </summary>
        public string CsCd { get; set; }

        /// <summary>
        /// 受診時団体コード1
        /// </summary>
        public string OrgCd1 { get; set; }

        /// <summary>
        /// 受診時団体コード2
        /// </summary>
        public string OrgCd2 { get; set; }

        /// <summary>
        /// 予約群コード
        /// </summary>
        public string RsvGrpCd { get; set; }

        /// <summary>
        /// 受診時年齢
        /// </summary>
        public string Age { get; set; }

        /// <summary>
        /// 契約パターンコード
        /// </summary>
        public string CtrPtCd { get; set; }

        /// <summary>
        /// 一次健診の予約番号
        /// </summary>
        public string FirstRsvNo { get; set; }

        /// <summary>
        /// 受診区分コード
        /// </summary>
        public string CslDivCd { get; set; }

        /// <summary>
        /// 受付処理モード(0:受付処理は行わない、1:最終発番ＩＤの次番号で発番、2:欠番を検索して発番、3:p_DayId値で発番)
        /// </summary>
        public string Mode { get; set; }

        /// <summary>
        /// 当日ID
        /// </summary>
        public string DayId { get; set; }

        /// <summary>
        /// 予約枠無視フラグ
        /// </summary>
        public string IgnoreFlg { get; set; }
    }
}
