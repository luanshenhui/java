using System;
using System.Collections.Generic;

namespace Hainsi.Entity.Model.Schedule
{
    /// <summary>
    /// 予約人数管理情報
    /// </summary>
    public class RsvCapacity
    {
        /// <summary>
        /// 開始受診日
        /// </summary>
        public string StrDate { get; set; }
        /// <summary>
        /// 終了受診日
        /// </summary>
        public string EndDate { get; set; }
        /// <summary>
        /// コースコード
        /// </summary>
        public List<string> SelCsCd { get; set; }
    }
}
