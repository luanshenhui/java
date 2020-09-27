using System;
using System.Collections.Generic;

namespace Hainsi.Entity.Model.Schedule
{
    /// <summary>
    /// 予約枠のコピー情報
    /// </summary>
    public class CopyRsvFraMng
    {
        /// <summary>
        /// コピー元受診日
        /// </summary>
        public string CslDate { get; set; }
        /// <summary>
        /// コースコード
        /// </summary>
        public string CsCd { get; set; }
        /// <summary>
        /// 予約群コード
        /// </summary>
        public string RsvGrpCd { get; set; }
        /// <summary>
        /// コピー先開始受診日
        /// </summary>
        public string StrCslDate { get; set; }
        /// <summary>
        /// コピー先終了受診日
        /// </summary>
        public string EndCslDate { get; set; }
        /// <summary>
        /// 曜日フラグ
        /// </summary>
        public List<string> WeekDays { get; set; }
        /// <summary>
        /// 上書きフラグ
        /// </summary>
        public bool Update { get; set; }
    }
}
