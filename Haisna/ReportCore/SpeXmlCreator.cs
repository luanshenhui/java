using Hainsi.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Text;
using System.Xml;

namespace Hainsi.ReportCore
{
    public abstract class SpeXmlCreator : ReportCreator
    {
        /// <summary>
        /// MIMEタイプ
        /// </summary>
        public override Report.MimeType MimeType { get; } = Report.MimeType.Csv;

        /// <summary>
        /// 一時フォルダ名
        /// </summary>
        private string TempFolder { get; set; }

        /// <summary>
        /// XSDフォルダ格納場所
        /// </summary>
        public string XSDFolder { get; set; }

        /// <summary>
        /// ログ内容
        /// </summary>
        public List<string> logTextInfo { get; set; }

        /// <summary>
        /// 変換パターン
        /// </summary>
        public string convPtn { get; set; }

        /// <summary>
        /// シーケンス番号
        /// </summary>
        private string SeqNo { get; set; }

        /// <summary>
        /// パラメータをセットする
        /// </summary>
        /// <param name="queryParam">パラメータ</param>
        public override sealed void SetQueryParam(ParamValues queryParam)
        {
            base.SetQueryParam(queryParam);

            FileName = queryParam["fileName"];
            SeqNo = queryParam["seq"];
            convPtn = queryParam["spitem"];
        }

        /// <summary>
        /// 一時フォルダ名
        /// </summary>
        private const string TempFolderName = "SpeXmlTemp";

        /// <summary>
        /// CSVファイルを作成する
        /// </summary>
        /// <returns>印刷ログ書き込みクラス</returns>
        public override sealed void CreateContent()
        {
            // ファイルシーケンス
            int fileSeq = 0;

            // データ読み込み
            List<dynamic> data = GetData();

            // 件数0なら処理しない
            if (data.Count == 0)
            {
                return;
            }

            // XML実施区分・種別取得
            IDictionary<string, object> xmlDivInfo = GetXmlDiv();

            if (xmlDivInfo == null)
            {
                // 実施区分・健診種別情報なし
                throw new Exception("実施区分・健診種別情報が取得できませんでした。");
            }

            // 送付元機関取得
            IDictionary<string, object> sendOrgNo = GetOrgInfo(true);

            if (sendOrgNo == null)
            {
                // 送付元機関情報なし
                throw new Exception("送付元機関情報が取得できませんでした。");
            }

            // 一時フォルダ作成
            TempFolder = Path.GetTempPath() + TempFolderName;
            if (System.IO.Directory.Exists(TempFolder))
            {
                DeleteFolder(TempFolder);
            }
            Directory.CreateDirectory(TempFolder);

            // 圧縮ファイル名
            string zipName = "";
            try
            {
                int dataCnt = 0;
                int fileCnt = 0;
                string tmpOrg = "";
                string rootFolder = "";

                foreach (IDictionary<string, object> row in data)
                {
                    dataCnt += 1;

                    // 予約番号の取得
                    int rsvno = 0;
                    int.TryParse(Util.ConvertToString(row["RSVNO"]), out rsvno);
                    if (rsvno == 0)
                    {
                        continue;
                    }
                                        
                    string outDate = Util.ConvertToString(row["OUTDATE"]);
                    string xmlDiv = Util.ConvertToString(xmlDivInfo["XMLDIV"]);
                    string xmlKind = Util.ConvertToString(xmlDivInfo["XMLKIND"]);

                    xmlDiv = (xmlDiv == "4") ? "4" : "1";

                    // 出力フォルダ作成
                    string orgno = Util.ConvertToString(sendOrgNo["FREEFIELD1"]);
                    string isrorgno = Util.ConvertToString(row["ISRORGNO"]);
                    orgno = orgno.PadLeft(10, '0');
                    isrorgno = isrorgno.PadLeft(8, '0');

                    if (tmpOrg != orgno + isrorgno)
                    {
                        rootFolder = MakeRootFolder(orgno, isrorgno, outDate, "4");
                        fileSeq = 0;
                    }
                    tmpOrg = orgno + isrorgno;

                    // ファイルシーケンスカウント
                    fileSeq += 1;

                    if (string.IsNullOrEmpty(rootFolder))
                    {
                        continue;
                    }
                    if (!System.IO.Directory.Exists(rootFolder))
                    {
                        Directory.CreateDirectory(rootFolder);
                    }

                    // バージョン識別区分を取得
                    string verdiv = GetJLAC10VerDiv(rsvno);

                    if (string.IsNullOrEmpty(verdiv))
                    {
                        // バージョン識別区分なし
                        throw new Exception("JLAC10のバージョン情報の取得に失敗しました。");
                    }

                    // 検査情報
                    var xmlDocument = new XmlDocument();
                    if (CreateXMLData(xmlDocument, row, xmlDivInfo, verdiv))
                    {
                        // データフォルダ作成
                        string DataFolder = EditPath(rootFolder) + "DATA";
                        if (!System.IO.Directory.Exists(DataFolder))
                        {
                            Directory.CreateDirectory(DataFolder);
                        }
                        xmlDocument.Save(CreateXMLFile(DataFolder, orgno, fileSeq));
                        fileCnt += 1;
                    }

                    // 基本ヘッダ出力処理
                    // 送付先機関番号・保険者番号が変わるか、最後の受診者なら基本ヘッダを出力
                    bool outputHeader = false;
                    if (data.Count == dataCnt)
                    {
                        outputHeader = true;
                    }
                    else if (data.Count > dataCnt)
                    {
                        string tmporgno = Util.ConvertToString(sendOrgNo["FREEFIELD1"]);
                        string tmpisrorgno = Util.ConvertToString(data[dataCnt].ISRORGNO);

                        if (tmpOrg != tmporgno + tmpisrorgno)
                        {
                            outputHeader = true;
                        }
                    }

                    if (outputHeader)
                    {
                        // スキーマファイルをコピー
                        string originFolder = XSDFolder;
                        string copyToFolder = EditPath(rootFolder) + "XSD";
                        CopySchema(originFolder, copyToFolder);

                        // 基本ヘッダ出力処理（交換用基本情報ファイル:ix08）
                        // 総ファイル数"を出力するため、検査情報より後の出力とする
                        var indexDocument = new XmlDocument();

                        CreateXML_Index(indexDocument, xmlKind, xmlDiv, outDate, orgno, isrorgno, Util.ConvertToString(fileCnt));

                        string indexFile = EditPath(rootFolder) + "ix08_V08.xml";
                        indexDocument.Save(indexFile);

                        // 集計出力処理（集計情報ファイル:su08）
                        var summaryDocument = new XmlDocument();

                        CreateXML_Summary(summaryDocument, xmlDiv, 0, 0, 0, 0);

                        string SummaryFile = EditPath(rootFolder) + "su08_V08.xml";
                        summaryDocument.Save(SummaryFile);

                        // ログ出力
                        string logFile = rootFolder + @".csv";
                        var sw = new StreamWriter(logFile, false, Encoding.GetEncoding("Shift_JIS"));

                        try
                        {
                            foreach (string logRec in logTextInfo)
                            {
                                sw.WriteLine(logRec);
                            }
                        }
                        catch (Exception ex)
                        {
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
                        finally
                        {
                            sw.Close();
                            sw.Dispose();
                        }

                        // 出力フォルダを圧縮
                        zipName = rootFolder + ".zip";
                        ZipFile.CreateFromDirectory(rootFolder, zipName);

                        // 圧縮元フォルダ削除
                        DeleteFolder(rootFolder);
                    }
                }

                // 一時フォルダを圧縮
                zipName = TempFolder + ".zip";

                // 圧縮フォルダが存在している場合は削除
                File.Delete(zipName);

                ZipFile.CreateFromDirectory(TempFolder, zipName);
            }
            catch (Exception ex)
            {
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
            finally
            {
                // DBへアップロード元となる一時ファイルパスをセットする
                TempFilePath = zipName;

                // 一時フォルダ削除
                DeleteFolder(TempFolder);
            }

            // ステータスを正常にセット
            Status = Report.Status.Success;
        }

        /// <summary>
        /// 出力フォルダ取得
        /// </summary>
        /// <param name="ogrNo">送付先事業所コード</param>
        /// <param name="isrorgNo">保険者番号</param>
        /// <param name="outDate">出力日</param>
        /// <param name="xmlDiv">XML実施区分</param>
        /// <returns>出力先フォルダ</returns>
        protected string MakeRootFolder(string orgNo, string isrOrgNo, string outDate, string xmlDiv)
        {
            // 作成するフォルダ名を生成
            // 出力フォルダ
            string folder = EditPath(TempFolder);

            // ルートフォルダ命名規則に則ってファイル名を生成
            // 提出元機関番号を追加
            folder += orgNo + "_";

            // 保険者番号
            folder += isrOrgNo + "_";

            // 提出年月日を追加
            folder += outDate;

            // シーケンスを追加
            folder += SeqNo.PadLeft(1,'0') + "_";

            // 実施区分コードを追加
            folder += xmlDiv;

            if (System.IO.Directory.Exists(folder))
            {
                throw new Exception("シーケンス番号(" + SeqNo + ")はすでに使用されています。");
            }

            return folder;
        }

        /// <summary>
        /// スキーマファイルコピー
        /// </summary>
        /// <param name="originPath">コピー元</param>
        /// <param name="copyToPath">コピー先</param>
        protected void CopySchema(string originPath, string copyToPath)
        {
            string folder = EditPath(copyToPath);

            // コピー先がない場合は作成する
            if (!System.IO.Directory.Exists(copyToPath))
            {
                System.IO.Directory.CreateDirectory(copyToPath);                
            }

            // コピー元のファイルをコピー
            string[] files = System.IO.Directory.GetFiles(originPath);
            foreach (string fileRec in files)
            {
                System.IO.File.Copy(fileRec, folder + System.IO.Path.GetFileName(fileRec));
            }

            // コピー元のフォルダをコピー
            string[] floderes = System.IO.Directory.GetDirectories(originPath);
            foreach (string folderRec in floderes)
            {
                CopySchema(folderRec, EditPath(copyToPath) + System.IO.Path.GetFileName(folderRec));
            }
        }

        /// <summary>
        /// XMLファイル作成
        /// </summary>
        /// <param name="path">XMLデータファイル格納先</param>
        /// <param name="orgNo">送付元コード</param>
        /// <param name="fileSeq">ファイルシーケンス</param>
        protected string CreateXMLFile(string path, string orgNo, int fileSeq)
        {
            string fileName = EditPath(path);
            if (string.IsNullOrEmpty(fileName))
            {
                throw new Exception("データフォルダが見つかりません。");
            }
            fileName += "h";
            fileName += orgNo;
            fileName += DateTime.Today.ToString("yyyyMMdd");
            fileName += SeqNo.PadLeft(1,'0');
            fileName += "1";
            fileName += string.Format("{0:000000}", fileSeq);
            fileName += ".xml";

            return fileName;
        }

        /// <summary>
        /// 一時フォルダ削除
        /// </summary>
        /// <param name="delFolder">削除フォルダ</param>
        protected void DeleteFolder(string delFolder)
        {
            string folder = EditPath(delFolder);

            // 削除対象が存在しない場合は何もしない
            if (!System.IO.Directory.Exists(folder))
            {
                return;
            }

            // 対象フォルダ内の全ファイルを削除
            string[] files = System.IO.Directory.GetFiles(folder);
            foreach (string fileRec in files)
            {
                System.IO.File.Delete(fileRec);
            }

            // フォルダ内のフォルダ削除
            string[] floderes = System.IO.Directory.GetDirectories(delFolder);
            foreach (string folderRec in floderes)
            {
                DeleteFolder(folderRec);
            }

            System.IO.Directory.Delete(folder);
        }

        /// <summary>
        /// パス編集
        /// </summary>
        /// <param name="path">パス</param>
        /// <returns>編集パス</returns>
        protected string EditPath(string path)
        {
            string editPath = path;
            if (!editPath.EndsWith(@"\"))
            {
                // 末尾が\でなければ付ける
                editPath += @"\";
            }

            return editPath;
        }

        /// <summary>
        /// XMLの作成元となるデータを取得
        /// </summary>
        /// <returns>XMLデータソース</returns>
        protected abstract List<dynamic> GetData();

        /// <summary>
        /// 機関情報取得
        /// </summary>
        /// <param name="sendOrgflg">送付元機関フラグ</param>
        /// <returns>機関情報番号</returns>
        protected abstract dynamic GetOrgInfo(bool sendOrgflg);

        /// <summary>
        /// JLAC10バージョン識別区分取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>JLAC10バージョン識別区分</returns>
        protected abstract string GetJLAC10VerDiv(int rsvNo);

        /// <summary>
        /// XML実施区分・種別情報取得
        /// </summary>
        /// <returns>XML実施区分・種別情報</returns>
        protected abstract dynamic GetXmlDiv();

        /// <summary>
        /// XML結果データ作成
        /// </summary>
        /// <param name="document">XMLドキュメント</param>
        /// <param name="data">対象データ</param>
        /// <param name="xmlDivInfo">実施区分・種別情報</param>
        /// <param name="verDiv">JLAC10バージョン識別区分</param>
        /// <returns>ドキュメント作成有無</returns>
        protected abstract bool CreateXMLData(XmlDocument document, IDictionary<string, object> data, IDictionary<string, object> xmlDivInfo, string verDiv);

        /// <summary>
        /// XMLインデックスデータ作成
        /// </summary>
        /// <param name="document">XMLドキュメント</param>
        /// <param name="xmlKind">健診種別</param>
        /// <param name="xmlDiv">実施区分</param>
        /// <param name="outDate">出力日</param>
        /// <param name="orgSrc">送付元機関</param>
        /// <param name="dstOrgNo">送付先機関</param>
        /// <param name="fileCnt">ファイル数</param>
        protected abstract void CreateXML_Index(XmlDocument document, string xmlKind, string xmlDiv, string outDate, string orgSrc, string dstOrgNo, string fileCnt);

        /// <summary>
        /// XML集計情報データ作成
        /// </summary>
        /// <param name="document">XMLドキュメント</param>
        /// <param name="xmlDiv">実施区分</param>
        /// <param name="patientCnt">受診者数</param>
        /// <param name="totalPayment">窓口支払金額総計</param>
        /// <param name="totalClaim">請求金額総計</param>
        /// <param name="totalOther">他検診負担金額総計</param>
        protected abstract void CreateXML_Summary(XmlDocument document, string xmlDiv, int patientCnt, int totalPayment, int totalClaim, int totalOther);
    }
}
