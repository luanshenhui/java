using Newtonsoft.Json;
using System.Collections.Generic;

#pragma warning disable CS1591

namespace Hainsi.Models
{
    public class BloodPressureModel : ClientDeviceApiModel
    {
        public int RsvNo { get; set; }
        public double BloodPressureH { get; set; }
        public double BloodPressureL { get; set; }
        public double Pulse { get; set; }

        /// <summary>
        /// 血圧のJSONデータを作成する
        /// </summary>
        /// <returns>血圧のJSONデータ</returns>
        public override string BuildJsonData()
        {
            // 結果データとして登録するJSON作成
            var dataValues = new List<dynamic>();
            dataValues.Add(new
            {
                rsvno = RsvNo.ToString(),
                bloodpressure_h = BloodPressureH.ToString(),
                bloodpressure_l = BloodPressureL.ToString(),
                pulse = Pulse.ToString()
            });

            return JsonConvert.SerializeObject(new { items = dataValues.ToArray() });
        }
    }
}