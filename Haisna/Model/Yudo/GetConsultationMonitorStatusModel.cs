using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.Yudo
{
    /// <summary>
    /// 診察状態取得モデル
    /// </summary>
    public class GetConsultationMonitorStatusModel
    {
        /// <summary>
        /// 検診状態コード
        /// </summary>
        public string Kenshin_jotai_code { get; set; }
        /// <summary>
        /// 当日ID
        /// </summary>
        public int DayId { get; set; }
        /// <summary>
        /// 部屋番号
        /// </summary>
        public string Room_Id { get; set; }
    }
}
