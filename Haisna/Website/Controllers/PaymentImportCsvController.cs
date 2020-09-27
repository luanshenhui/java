using Microsoft.AspNetCore.Mvc;
using Hainsi.Entity;
using System.Collections.Generic;
using Microsoft.AspNetCore.Http;
using System.IO;
using System;

namespace Hainsi.Controllers
{
    /// <summary>
    /// ＣＳＶファイルから入金情報データコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/payments")]
    public class PaymentImportCsvController : Controller
    {
        /// <summary>
        /// ＣＳＶファイルから入金情報データアクセスオブジェクト
        /// </summary>
        readonly PaymentImportCsvDao paymentImportCsvDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="paymentImportCsvDao">ＣＳＶファイルから入金情報データアクセスオブジェクト</param>
        public PaymentImportCsvController(PaymentImportCsvDao paymentImportCsvDao)
        {
            this.paymentImportCsvDao = paymentImportCsvDao;
        }

        /// <summary>
        /// 入金情報の作成する
        /// </summary>
        /// <param name="file">アップロードされたデータ</param>
        /// <param name="startPos">読み込み開始位置</param>
        /// <response code="200">成功</response>
        [HttpPost("UploadFiles")]
        public IActionResult ImportCsvAsync(List<IFormFile> file, string startPos)
        {
            //読み込みレコード数
            string readCount = null;
            //作成受診情報数
            string writeCount = null;
            // ファイル名
            string fileName = "";
            // 出力ファイルの書き出し位置
            string outFilePath = "";
            // 出力ファイル名
            string outFileName = "";
            // 更新者
            string userId = "";
            // ＣＳＶファイルpath
            string filePath = "";
            long pos;
            //更新者
            // userId = HttpContext.Session.GetString("userId");
            userId = "HAINS$";

            // CSVファイル名をもとに処理結果付CSVファイル名を作成する際に追加する文字列
            string APPEND_KEYWORD = "(入金)";
            // 処理結果付CSVファイルの書き出しパス
            string TEMPFILE_PATH = "\\wwwroot\\Temp";
            var messagesList = new List<string>();

            if (file.Count > 0)
            {
                fileName = file[0].FileName;
            }

            if (fileName == "" || fileName == null)
            {
                messagesList.Add("ＣＳＶファイルを指定して下さい。");
            }

            if (startPos == null || startPos == "")
            {
                startPos = "0";
            }

            foreach (char c in startPos)
            {
                if ("0123456789".IndexOf(c.ToString()) < 0)
                {
                    messagesList.Add("読み込み開始位置は０以上の数字で指定して下さい。");
                    break;
                    
                }
            }
            if (messagesList.Count > 0)
            {
                return BadRequest(messagesList);
            }

            // パス部を除去
            if (fileName.LastIndexOf("\\") > 0)
            {
                outFileName = fileName.Substring(fileName.LastIndexOf("\\") + 1, fileName.Length - fileName.LastIndexOf("\\") - 1);
                fileName = outFileName;
            }
            else
            {
                outFileName = fileName;
            };
            // 拡張子の直前に文字列を追加
            if (outFileName.IndexOf(".") > 0)
            {
                outFileName = outFileName.Replace(".", APPEND_KEYWORD + ".");
            }
            else
            {
                outFileName = outFileName + APPEND_KEYWORD;
            };


            outFilePath = Environment.CurrentDirectory + TEMPFILE_PATH;
            outFilePath = Path.GetFullPath(outFilePath);

            pos = long.Parse(startPos);

            if (!Directory.Exists(outFilePath))
            {
                Directory.CreateDirectory(outFilePath);
            }

            foreach (IFormFile f in file)
            {
                using (FileStream fs = System.IO.File.Create(outFilePath + "\\" + fileName))
                {
                    f.CopyTo(fs);
                    fs.Flush();
                    filePath = fs.Name;
                }
            }

            paymentImportCsvDao.ImportCsv(filePath, fileName, userId, pos, outFilePath, ref outFileName, ref readCount, ref writeCount);

            // 情報を追加する
            var data = new Dictionary<string, dynamic>
            {
                {"readCount", readCount },
                {"writeCount", writeCount },
                {"startPos",startPos},
                {"outFileName",outFileName }
            };

            return Ok(data);
        }


    }
}
