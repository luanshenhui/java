using ClosedXML.Excel;
using Hainsi.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;

namespace Hainsi.ReportCore
{
    public abstract class ExcelCreator : ReportCreator
    {
        /// <summary>
        /// MIMEタイプ
        /// </summary>
        public override Report.MimeType MimeType { get; } = Report.MimeType.Excel;

        /// <summary>
        /// テンプレートファイル名
        /// </summary>
        protected virtual string TemplateFileName { get; }

        /// <summary>
        /// パラメータをセットする
        /// </summary>
        /// <param name="queryParam">パラメータ</param>
        public override sealed void SetQueryParam(ParamValues queryParam)
        {
            base.SetQueryParam(queryParam);

            FileName = queryParam["fileName"];
        }

        /// <summary>
        /// Excel作成
        /// </summary>
        public sealed override void CreateContent()
        {
            //データ読み込み
            List<dynamic> data = GetData();

            //件数0処理しない
            if (data.Count == 0)
            {
                return;
            }

            // テンプレートファイルが指定されていない場合例外
            if (string.IsNullOrWhiteSpace(TemplateFileName))
            {
                throw new Exception("テンプレートファイルが指定されていません");
            }

            // Excelテンプレート保存ディレクトリ
            string excelTemplateDirectory = Path.Combine(Directory.GetCurrentDirectory(), configuration.GetSection("Reporting")["ExcelDirectory"]);

            using (XLWorkbook workbook = new XLWorkbook(Path.Combine(excelTemplateDirectory, TemplateFileName)))
            {
                // 一時ファイル名
                string tempFileName = string.Empty;

                try
                {
                    //Excelファイル作成処理
                    SetFieldValue(workbook, data);

                    // 一時ファイル名作成
                    do
                    {
                        tempFileName = Path.ChangeExtension(Path.GetTempPath() + Guid.NewGuid().ToString(), "xlsx");
                    } while (File.Exists(tempFileName));

                    // Excelファイル出力
                    workbook.SaveAs(tempFileName);
                }
                catch (Exception ex)
                {
                    if (ex is ReportLogCancelException)
                    {
                        Status = Report.Status.Canceled;
                        return;
                    }
                    throw;
                }
                finally
                {
                    // DBへアップロード元となる一時ファイルパスをセットする
                    TempFilePath = tempFileName;
                }

                //ログに書くステータスを正常にセット
                Status = Report.Status.Success;
            }
        }

        /// <summary>
        /// Excel作成対象データを取得する
        /// </summary>
        /// <returns>PDF作成対象データ</returns>
        protected abstract List<dynamic> GetData();

        /// <summary>
        /// Excelファイルを作成する
        /// </summary>
        /// <param name="workbook">エクセルファイル</param>
        /// <param name="data">Excel作成対象データ</param>
        protected abstract void SetFieldValue(XLWorkbook workbook, List<dynamic> data);
    }
}
