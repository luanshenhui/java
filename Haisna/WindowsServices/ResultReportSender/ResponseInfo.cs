using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Fujitsu.Hainsi.WindowServices.ResultReportSender
{
    public class ResponseInfo
    {
        public int RsvNo { get; set; }
        public string Html { get; set; }
        public MessageMaker.MakeMode Mode { get; set; }
        public int PerId { get; set; }
        public int OrderNo { get; set; }
        public int DocSeq { get; set; }
        public string DocDate { get; set; }
        public int Count { get; set; }
    }
}
