using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.Consultation
{
    /// <summary>
    /// 一括受診日変更モデル
    /// </summary>
    public class ChangeDateModel
    {
        /// <summary>
        /// 検索モード
        /// </summary>
        public string Mode { get; set; }
        /// <summary>
        /// 予約枠無視フラグ
        /// </summary>
        public int IgnoreFlg { get; set; }
        /// <summary>
        /// 受診日
        /// </summary>
        public DateTime CslDate { get; set; }
        /// <summary>
        /// 予約番号
        /// </summary>
        public int[] RsvNo { get; set; }
        /// <summary>
        /// 予約群コード
        /// </summary>
        public int?[] RsvGrpCd { get; set; }
    }
}
