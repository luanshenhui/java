using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConnectKetsuatsu
{
    /// <summary>
    /// 血圧のデータモデル
    /// </summary>
    class BloodPressureModel
    {
        public int RsvNo { get; set; }
        public string PostClass { get; set; }
        public double BloodPressureH { get; set; }
        public double BloodPressureL { get; set; }
        public double Pulse { get; set; }
    }
}
