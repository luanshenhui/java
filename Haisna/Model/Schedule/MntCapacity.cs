using System;
using System.Collections.Generic;

namespace Hainsi.Entity.Model.Schedule
{
    /// <summary>
    /// 休診日設定情報
    /// </summary>
    public class MntCapacity
    {
        /// <summary>
        /// 月始日付～月末日付の設定値
        /// </summary>
        public List<int> ArrHoliday { get; set; }
        /// <summary>
        /// 警告メッセージ
        /// </summary>
        public List<dynamic> Warnings { get; set; }
        /// <summary>
        /// 開始受診日
        /// </summary>
        public string StrDate { get; set; }
        /// <summary>
        /// 終了受診日
        /// </summary>
        public string EndDate { get; set; }
    }
}
