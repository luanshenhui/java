using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Common
{
    public class Report
    {
        /// <summary>
        /// ステータス
        /// </summary>
        public enum Status
        {
            /// <summary>処理中</summary>
            Processing,
            /// <summary>正常終了</summary>
            Success,
            /// <summary>エラー終了</summary>
            Error,
            /// <summary>キャンセル</summary>
            Canceled
        }

        /// <summary>
        /// MIMEタイプ
        /// </summary>
        public enum MimeType
        {
            /// <summary>PDFファイル</summary>
            Pdf,
            /// <summary>CSVファイル</summary>
            Csv,
            /// <summary>Excelファイル</summary>
            Excel,
        }


        /// <summary>
        /// ステータスコードを定義する
        /// </summary>
        public static int ConvertStatusCode(Status status)
        {
			var statusCode = new Dictionary<Status, int>
			{
				{ Status.Processing, 0 },
				{ Status.Success, 1 },
				{ Status.Error, 2 },
				{ Status.Canceled, 3 }
			};

			return statusCode[status];
        }

        /// <summary>
        /// MIMEタイプを定義する
        /// </summary>
        public static string ConvertMimeType(MimeType mime)
        {
			var mimeType = new Dictionary<MimeType, string>
			{
				{ MimeType.Pdf, "application/pdf" },
				{ MimeType.Csv, "text/comma-separated-values" },
                { MimeType.Excel, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }
            };

			return mimeType[mime];
        }

    }
}
