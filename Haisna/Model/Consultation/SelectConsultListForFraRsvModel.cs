using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.Consultation
{
    /// <summary>
    /// 検索条件を満たす受診者の一覧モデル(枠予約用)
    /// </summary>
    public class SelectConsultListForFraRsvModel
    {
        /// <summary>
        /// 予約番号
        /// </summary>
        public int RsvNo { get; set; }
        /// <summary>
        /// 受診日
        /// </summary>
        public DateTime CslDate { get; set; }
        /// <summary>
        /// webカラー
        /// </summary>
        public string WebColor { get; set; }
        /// <summary>
        /// コース名
        /// </summary>
        public string CsName { get; set; }
        /// <summary>
        /// 個人ID
        /// </summary>
        public string PerId { get; set; }
        /// <summary>
        /// 姓
        /// </summary>
        public string LastName { get; set; }
        /// <summary>
        /// 名
        /// </summary>
        public string FirstName { get; set; }
        /// <summary>
        /// カナ姓
        /// </summary>
        public string LastKName { get; set; }
        /// <summary>
        /// カナ名
        /// </summary>
        public string FirstKName { get; set; }
        /// <summary>
        /// 性別
        /// </summary>
        public int Gender { get; set; }
        /// <summary>
        /// 生年月日
        /// </summary>
        public DateTime Birth { get; set; }
        /// <summary>
        /// 年齢
        /// </summary>
        public int Age { get; set; }
        /// <summary>
        /// 団体コード1
        /// </summary>
        public string OrgCd1 { get; set; }
        /// <summary>
        /// 団体コード2
        /// </summary>
        public string OrgCd2 { get; set; }
        /// <summary>
        /// 団体略称
        /// </summary>
        public string OrgSName { get; set; }
        /// <summary>
        /// 予約群名称
        /// </summary>
        public string RsvGrpName { get; set; }
        /// <summary>
        /// オプション名
        /// </summary>
        public string OptName { get; set; }
        /// <summary>
        /// 同伴者個人ID
        /// </summary>
        public string CompPerId { get; set; }
        /// <summary>
        /// お連れ様情報の有無
        /// </summary>
        public int HasFriends { get; set; }
    }
}
