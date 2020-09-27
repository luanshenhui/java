using Hos.CnDraw;
using Hos.CnDraw.Object;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Drawing.Printing;
using System.IO;

namespace Hainsi.SendOrder
{
    /// <summary>
    /// 病理ラベル印刷クラス
    /// </summary>
    public class ByoriLabel
    {
        /// <summary>
        /// 帳票定義ファイル名（病理ラベル）
        /// </summary>
        private static readonly string BYORILABEL_FORM_FILENAME = "ByoriLabel.rse";

        /// <summary>
        /// 病理ラベルを印刷する
        /// </summary>
        /// <param name="data">印刷対象データ</param>
        /// <param name="printerName">出力先プリンタ名</param>
        /// <param name="configuration">構成情報オブジェクト</param>
        /// <returns></returns>
        public void PrintByoriLabel(List<dynamic> data, string printerName, IConfiguration configuration)
        {
            CnDraw cnDraw = null;
            CnForm cnForm = null;
            CnPrintOutJob job = null;

            try
            {
                // 描画オブジェクトを初期化する
                cnDraw = new CnDraw();
                cnDraw.Initialize();

                // 帳票定義ファイルの格納フォルダを設定する
                cnDraw.FormPath = Path.Combine(
                    Directory.GetCurrentDirectory(),
                    configuration.GetSection("Reporting")["FormDirectory"]);

                // 帳票定義ファイルをオープンする
                try
                {
                    cnForm = cnDraw.OpenForm(BYORILABEL_FORM_FILENAME);
                }
                catch (Exception ex)
                {
                    string msg = "帳票定義ファイルのオープン処理に失敗しました。";
                    throw new SendOrderException(msg, ex);
                }

                // 出力先プリンタ名が指定されていない場合は
                // 通常使うプリンタに出力する
                var outputPrinterName = printerName;
                if (outputPrinterName.Equals(""))
                {
                    try
                    {
                        using (var pd = new PrintDocument())
                        {
                            outputPrinterName = pd.PrinterSettings.PrinterName;
                        }
                    }
                    catch { }
                }
                if (outputPrinterName.Equals(""))
                {
                    string msg = "出力先プリンタが指定されていません。";
                    throw new SendOrderException(msg);
                }

                // 指定されたプリンタが存在するかをチェックする
                var isExistPrinterName = false;
                foreach (var item in PrinterSettings.InstalledPrinters)
                {
                    if (item.ToString().ToLower().Equals(outputPrinterName.ToLower()))
                    {
                        isExistPrinterName = true;
                    }
                }
                if (!isExistPrinterName)
                {
                    string msg = string.Format(
                        "出力先プリンタ'{0}'が存在しません。", outputPrinterName);
                    throw new SendOrderException(msg);
                }

                // 直接印刷処理を開始する
                try
                {
                    job = new CnPrintOutJob(outputPrinterName);
                    job.Start(cnDraw);
                }
                catch (Exception ex)
                {
                    string msg = "病理ラベルの印刷開始処理に失敗しました。";
                    throw new SendOrderException(msg, ex);
                }

                // 帳票定義ファイルのオブジェクトを取得する
                CnObjects cnObjects = cnForm.CnObjects;
                var kansenMark = (CnDataField)cnObjects["txtItem1"];    // 感染症マーク
                var shinName = (CnDataField)cnObjects["txtItem2"];      // 診療科略称
                var byotoName = (CnDataField)cnObjects["txtItem3"];     // 病棟名略称
                var saishubi = (CnDataField)cnObjects["txtItem4"];      // 採取日
                var perId = (CnDataField)cnObjects["txtItem5"];         // 患者ID
                var name_n = (CnDataField)cnObjects["txtItem6"];        // 患者日本語氏名
                var barCode = (CnBarcodeField)cnObjects["barItem7"];    // バーコード
                var barCodeNo = (CnDataField)cnObjects["txtItem8"];     // バーコード番号
                var zoukiName = (CnDataField)cnObjects["txtItem9"];     // 臓器名
                var denshuName = (CnDataField)cnObjects["txtItem10"];   // 伝票種別略称
                var iraiKbn = (CnDataField)cnObjects["txtItem11"];      // 依頼区分
                var sHouhou = (CnDataField)cnObjects["txtItem12"];      // 採取方法
                var cnt = (CnDataField)cnObjects["txtItem14"];          // 採取個数

                // 印刷対象データを出力する
                foreach (var detail in data)
                {
                    // 容器数の分ループを回す（nullの場合は１回）
                    for (var i = 1; i <= ((detail.CONTCNT == null) ? 1 : Convert.ToInt32(detail.CONTCNT)); i++)
                    {
                        // 帳票定義ファイルへの出力内容をクリアする
                        cnForm.ClearAllFields();

                        // 感染症マーク
                        switch (Convert.ToString(detail.KANSEN_RESULT) ?? "")
                        {
                            case "3":    // ＨＢｓ
                                kansenMark.Text = "１";
                                break;
                            case "4":    // ＨＣＶ
                                kansenMark.Text = "２";
                                break;
                            case "6":    // ＴＰＨＡ
                                kansenMark.Text = "４";
                                break;
                            case "7":    // ＨＩＶ
                                kansenMark.Text = "３";
                                break;
                        }

                        // 診療科略称
                        shinName.Text = Strings.PadRightEx("く予", 6).TrimEnd();

                        // 病棟名略称
                        byotoName.Text = Strings.PadRightEx("", 6).TrimEnd();

                        // 採取日
                        saishubi.Text = 
                            Convert.ToDateTime(detail.GETHDATE).ToString("yyyy/MM/dd");

                        // 患者ID（10桁0詰めの編集を行う）
                        perId.Text = Strings.SubstringEx(
                            (Convert.ToString(detail.PERID) ?? "").Trim(), 1, 10).PadLeft(10, '0');

                        // 患者日本語氏名
                        name_n.Text = Convert.ToString(detail.NAME_N) ?? "";

                        // バーコード
                        var barcodeNoStr = 
                            string.Format("{0:D8}0010", Convert.ToInt32(detail.ORDERNO));
                        barCode.SetData(string.Format("A{0}A", barcodeNoStr));
                        barCodeNo.Text = barcodeNoStr;

                        // 臓器名（補足情報の部門名を出力する)
                        zoukiName.Text = Strings.PadRightEx(
                            Convert.ToString(detail.BUMNNAME) ?? "", 22).TrimEnd();

                        // 伝票種別略称
                        denshuName.Text = "細胞";

                        // 依頼区分
                        iraiKbn.Text = "通常";

                        // 採取方法
                        sHouhou.Text = Strings.PadRightEx(
                            Convert.ToString(detail.SHOUHOUNAME) ?? "", 14).TrimEnd();

                        // 採取個数
                        string cntStr = Convert.ToInt32(detail.CNT).ToString();
                        if (cntStr.Equals("0"))
                        {
                            cntStr = "個";
                        }
                        else
                        {
                            cntStr = Microsoft.VisualBasic.Strings.StrConv(
                                cntStr, Microsoft.VisualBasic.VbStrConv.Wide) + "個";
                        }
                        if (cntStr.Length < 3)
                        {
                            cntStr = cntStr.PadLeft(3);
                        }
                        cnt.Text = cntStr;

                        // １ページ分の出力処理を行う
                        try
                        {
                            // 帳票定義ファイルのサイズを設定する
                            job.CnPrinter.SetFormSize(cnForm);

                            // １ページ分のドキュメントを出力する
                            cnForm.PrintOut();
                        }
                        catch (Exception ex)
                        {
                            string msg = "病理ラベルのページ出力処理に失敗しました。";
                            throw new SendOrderException(msg, ex);
                        }
                    }
                }

                // 直接印刷処理を終了する
                try
                {
                    job.End();
                    job = null;
                }
                catch (Exception ex)
                {
                    string msg = "病理ラベルの印刷終了処理に失敗しました。";
                    throw new SendOrderException(msg, ex);
                }
            }
            catch (SendOrderException)
            {
                throw;
            }
            catch (Exception ex)
            {
                string msg = "病理ラベルの印刷処理に失敗しました。";
                throw new SendOrderException(msg, ex);
            }
            finally
            {
                // 印刷処理中の場合は中止する
                try
                {
                    if (job != null)
                    {
                        job.Abort();
                        job = null;
                    }
                }
                catch {}

                // 帳票定義ファイルをクローズする
                try
                {
                    if (cnForm != null)
                    {
                        cnForm.Close();
                        cnForm = null;
                    }
                }
                catch { }

                // 描画オブジェクトを破棄する
                try
                {
                    if (cnDraw != null)
                    {
                        cnDraw.Dispose();
                        cnDraw = null;
                    }
                }
                catch { }
            }
        }
    }
}
