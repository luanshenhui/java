using Hainsi.Common;
using Hos.CnDraw;
using Hos.CnDraw.Constants;
using Hos.CnDraw.Document;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;

namespace Hainsi.ReportCore
{
    public abstract class PdfCreator : ReportCreator
    {
        /// <summary>
        /// MIMEタイプ
        /// </summary>
        public override Report.MimeType MimeType { get; } = Report.MimeType.Pdf;

        /// <summary>印刷ジョブ（PDF作成）</summary>
        private CnFileOutJob JobPdf { get; set; }

        /// <summary>印刷ジョブ（直接印刷）</summary>
        private CnPrintOutJob JobPrinter { get; set; }

        /// <summary>
        /// 直接印刷フラグ（true:プリンタに対して直接印刷を行う）
        /// </summary>
        private bool DirectPrint { get; set; }

        /// <summary>
        /// プリンタ名（直接印刷の場合にプリンタ名を設定）
        /// </summary>
        private string PrinterName { get; set; }

        /// <summary>
        /// パラメータをセットする
        /// </summary>
        /// <param name="queryParam">パラメータ</param>
        public override sealed void SetQueryParam(ParamValues queryParam)
        {
            base.SetQueryParam(queryParam);

            // プリンタ名
            PrinterName = queryParam["printerName"];
        }

        /// <summary>
        /// PDF作成
        /// </summary>
        public sealed override void CreateContent()
        {
            if (string.IsNullOrEmpty(ReportCd))
            {
                throw new Exception("帳票コードがセットされていません。");
            }

            //データ読み込み
            List<dynamic> data = GetData();

            //件数0処理しない
            if (data.Count == 0)
            {
                return;
            }

            //直接印刷有無をチェック
            if (! string.IsNullOrEmpty(PrinterName.Trim()))
            {
                //プリンタ名の設定がある場合は印刷フラグを立てる
                //（プリンタ名はパラメタか、SetPrinterを呼び出して設定する）
                DirectPrint = true;
            }

            using (CnDraw cnDraw = Initialize())
            {
                //定義体ファイル名
                List<string> formFileNames = this.ReadFormFileNames(ReportCd);

                if (formFileNames.Count <= 0)
                {
                    throw new Exception(string.Format("指定帳票コードの定義体がありません。(帳票コード:{0})", ReportCd));
                }

                // 定義体をオープン
                foreach (var formFileName in formFileNames)
                {
                    cnDraw.OpenForm(formFileName);
                }

                // オープンしたフォームファイルコレクション
                CnForms cnForms = cnDraw.CnForms;

                try
                {
                    //開始
                    JobPdf = StartJob(cnDraw);

                    // 直接印刷の場合
                    if (DirectPrint)
                    {
                        // 開始
                        JobPrinter = StartJobPrinter(cnDraw, PrinterName);
                    }

                    try
                    {
                        //PDF作成処理
                        SetFieldValue(cnForms, data);

                        //ログに書くファイルのパスをセット
                        TempFilePath = JobPdf.DocumentFileName;

                        //終了
                        JobPdf.End();

                        // 直接印刷の場合
                        if (DirectPrint)
                        {
                            // 終了
                            JobPrinter.End();
                        }
                    }
                    catch (Exception ex)
                    {
                        // 取消
                        JobPdf.Abort();

                        // 直接印刷の場合
                        if (DirectPrint)
                        {
                            // 取消
                            JobPrinter.Abort();
                        }

                        if (ex is ReportLogCancelException)
                        {
                            Status = Report.Status.Canceled;
                            return;
                        }
                        else
                        {
                            throw;
                        }
                    }
                }
                finally
                {
                    // すべての定義体をクローズ
                    // クローズするたびにcnFormsからその定義体が削除されるためリストの最後からクローズする
                    for (var i = (int)cnForms.Count - 1; i >= 0; i--)
                    {
                        cnForms[i].Close();
                    }
                }

                //ログに書くステータスを正常にセット
                Status = Report.Status.Success;
            }
        }

        /// <summary>
        /// 初期化
        /// </summary>
        /// <returns>初期化した描画ライブラリ</returns>
        protected CnDraw Initialize()
        {
            var cnDraw = new CnDraw();
            cnDraw.Initialize();

            // 出力先フォルダ
            cnDraw.DocumentPath = Path.GetTempPath();

            // 定義体フォルダ
            cnDraw.FormPath = Path.Combine(Directory.GetCurrentDirectory(), configuration.GetSection("Reporting")["FormDirectory"]);

            return cnDraw;
        }

        /// <summary>
        /// PDF作成ジョブ開始
        /// </summary>
        /// <param name="cnDraw">描画クラス</param>
        /// <returns>開始したジョブ</returns>
        protected CnFileOutJob StartJob(CnDraw cnDraw)
        {
            var job = new CnFileOutJob(ConFileType.Pdf);

            job.Start(cnDraw);

            return job;
        }

        /// <summary>
        /// 直接印刷ジョブ開始
        /// </summary>
        /// <param name="cnDraw">描画クラス</param>
        /// <param name="printerName">出力先プリンタ名</param>
        /// <returns>開始したジョブ</returns>
        protected CnPrintOutJob StartJobPrinter(CnDraw cnDraw, string printerName)
        {
            var job = new CnPrintOutJob(printerName);

            job.Start(cnDraw);

            return job;
        }

        /// <summary>
        /// プリンタ名設定
        /// </summary>
        /// <param name="printername">プリンタ名</param>
        protected void SetPrinter(string printername)
        {
            PrinterName = printername;
        }

        /// <summary>
        /// 改ページ処理
        /// </summary>
        /// <param name="cnForm">フォームデータ</param>
        protected void PrintOut(CnForm cnForm)
        {
            //フォームファイルのサイズ設定
            JobPdf.CnPrinter.SetFormSize(cnForm);

            // 直接印刷の場合
            if (DirectPrint)
            {
                // フォームファイルのサイズ設定
                JobPrinter.CnPrinter.SetFormSize(cnForm);
            }

            // ドキュメントの出力
            cnForm.PrintOut();

            // 入力内容クリア
            cnForm.ClearAllFields();

            // ページカウントアップ
            OutputCount++;
        }

        /// <summary>
        /// PDF作成対象データを取得する
        /// </summary>
        /// <returns>PDF作成対象データ</returns>
        protected abstract List<dynamic> GetData();

        /// <summary>
        /// PDFを作成する
        /// </summary>
        /// <param name="cnForms">フォームデータコレクション</param>
        /// <param name="data">PDF作成対象データ</param>
        protected abstract void SetFieldValue(CnForms cnForms, List<dynamic> data);
    }
}
