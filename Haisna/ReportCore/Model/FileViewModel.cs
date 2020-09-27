using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.ReportCore.Model
{
    public class FileViewModel
    {
        /// <summary>ファイルデータ</summary>
        public byte[] DataFile { get; set; }
        /// <summary>MIMEタイプ</summary>
        public string MimeType { get; set; }
        /// <summary>ファイル名</summary>
        public string FileName { get; set; }
    }
}
