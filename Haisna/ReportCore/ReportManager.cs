using Hainsi.Common;
using Hainsi.Entity;
using Hainsi.ReportCore.Model;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Hainsi.ReportCore
{
    public class ReportManager
    {
        const string CREATOR_CLASSNAME_PREFIX = "Creator";

        /// <summary>
        /// ユーザID
        /// </summary>
        public string UserId { get; set; }

        /// <summary>
        /// 構成情報オブジェクト
        /// </summary>
        protected IConfiguration configuration;

        /// <summary>
        /// コネクションオブジェクト
        /// </summary>
        readonly IDbConnection connection;

        /// <summary>
        /// 印刷ログデータアクセスオブジェクト
        /// </summary>
        readonly ReportLogDao reportLogDao;

        /// <summary>
        /// 印刷データアクセスオブジェクト
        /// </summary>
        readonly ReportDao reportDao;

        /// <summary>
        /// レポート作成クラス
        /// </summary>
        ReportCreator reportCreator;

        /// <summary>
        /// ROWID
        /// </summary>
        private string rowId;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="configuration">構成情報オブジェクト</param>
        /// <param name="connection">コネクションオブジェクト</param>
        /// <param name="reportDao">印刷ログデータアクセスオブジェクト</param>
        /// <param name="reportLogDao">印刷データアクセスオブジェクト</param>
        public ReportManager(IConfiguration configuration, IDbConnection connection, ReportDao reportDao, ReportLogDao reportLogDao)
        {
            this.configuration = configuration;
            this.connection = connection;
            this.reportDao = reportDao;
            this.reportLogDao = reportLogDao;
        }

        /// <summary>
        /// ファイル生成タスクを非同期でキックし新しいプリントSEQをオブジェクトを返す
        /// </summary>
        /// <param name="reportCreator">ファイルを作成するオブジェクト</param>
        /// <returns>プリントSEQのオブジェクト</returns>
        public PrintSeqViewModel Execute(ReportCreator reportCreator)
        {
            this.reportCreator = reportCreator;
            this.reportCreator.SetConfiguration(configuration);
            this.reportCreator.SetConnection(connection);
            this.reportCreator.CheckCanceled = CheckCanceled;
            this.reportCreator.ReadFormFileNames = ReadFormFileNames;

            PrintSeqViewModel printSeqViewModel;

            // バリデーションチェック
            List<string> messages = reportCreator.Validate();
            //エラーメッセージがあればメッセージを返す
            if (messages != null && messages.Count > 0)
            {
                printSeqViewModel = new PrintSeqViewModel();
                printSeqViewModel.Messages = messages;
                return printSeqViewModel;
            }

            // プリントSEQを生成する
            printSeqViewModel = new PrintSeqViewModel()
            {
                PrintSeq = reportLogDao.GetNextPrintSeq()
            };

            // レポート生成処理実行
            Make((long)printSeqViewModel.PrintSeq);

            return printSeqViewModel;
        }

        /// <summary>
        /// ファイル作成状況を返す
        /// </summary>
        /// <param name="printSeq">プリントSEQ</param>
        /// <returns></returns>
        public ProgressViewModel ReadProgressViewModel(long printSeq)
        {
            // 一度に作成状況を読み込む回数
            const int count = 3;

            var progressViewModel = new ProgressViewModel();

            int progressingCode = Report.ConvertStatusCode(Report.Status.Processing);

            for (var i = 0; i < count; i++)
            {
                if (i > 0)
                {
                    // 次の読み込みまでの待ち時間
                    Thread.Sleep(3000);
                }

                progressViewModel = ReadProgress(printSeq);

                // 進捗状況が変われば抜ける
                if (progressViewModel.Status != progressingCode)
                {
                    break;
                }
            }

            return progressViewModel;
        }

        /// <summary>
        /// ファイルデータを取得する
        /// </summary>
        /// <param name="printSeq">プリントSEQ</param>
        /// <returns></returns>
        public FileViewModel ReadFileViewModel(long printSeq)
        {
            var readFileData = reportLogDao.FindFile(printSeq);

            return new FileViewModel()
            {
                MimeType = readFileData.MIMETYPE,
                FileName = readFileData.FILENAME,
                DataFile = readFileData.DATAFILE as byte[]
            };
        }

        /// <summary>
        /// ファイルデータを取得する
        /// </summary>
        /// <param name="printSeq">プリントSEQ</param>
        /// <returns></returns>
        FileViewModel ReadFile(int printSeq)
        {
            dynamic readFileData = reportLogDao.FindFile(printSeq);

            return new FileViewModel()
            {
                MimeType = readFileData.MIMETYPE,
                FileName = readFileData.FILENAME,
                DataFile = readFileData.DATAFILE as byte[]
            };
        }

        /// <summary>
        /// 進捗状況を取得する
        /// </summary>
        /// <param name="printSeq">プリントSEQ</param>
        /// <returns>進捗データ</returns>
        ProgressViewModel ReadProgress(long printSeq)
        {
            dynamic progressData = reportLogDao.FindProgress(printSeq);

            return new ProgressViewModel()
            {
                Status = Convert.ToInt32(progressData.STATUS),
                Count = Convert.ToInt32(progressData.COUNT)
            };
        }

        /// <summary>
        /// ファイルを作成する
        /// </summary>
        /// <returns>プリントSEQ</returns>
        void Make(long printSeq)
        {
            // 印刷ログレコードの挿入
            reportLogDao.InsertReportLog(printSeq, reportCreator.ReportCd, reportCreator.ReportName, UserId);

            // 今挿入したレコードのROWID値を取得し、プライベート変数として保持
            rowId = reportLogDao.GetRowId(printSeq);

            try
            {
                // コンテンツの作成
                reportCreator.CreateContent();

                // ログ書き込み
                WriteLog();
            }
            finally
            {
                // ファイル削除
                if (!string.IsNullOrEmpty(reportCreator.TempFilePath))
                {
                    File.Delete(reportCreator.TempFilePath);
                }
            }
        }

        /// <summary>
        /// ログ書き込み処理
        /// </summary>
        void WriteLog()
        {
            byte[] dataFile = null;

            int outputCount = reportCreator.OutputCount;
            Report.Status status = reportCreator.Status;

            // 正常終了処理ならファイルをセット
            if (status == Report.Status.Success)
            {
                dataFile = ConvertFileToByte(reportCreator.TempFilePath);

                if (dataFile == null)
                {
                    status = Report.Status.Error;
                }
            }

            if ((status == Report.Status.Processing) || (status == Report.Status.Success))
            {
                outputCount = 0;
            }

            // 印刷ログレコードを更新する
            reportLogDao.UpdateReportLog(rowId, status, outputCount, dataFile, reportCreator.MimeType, reportCreator.FileName);
        }

        /// <summary>
        /// ファイルを取り込む
        /// </summary>
        /// <param name="filePath"></param>
        /// <returns></returns>
        private byte[] ConvertFileToByte(string filePath)
        {
            byte[] blobData = null;

            // ファイル読み取り
            using (var fs = new FileStream(filePath, FileMode.Open, FileAccess.Read))
            {
                // 配列長確保
                blobData = new byte[fs.Length];

                // ファイルをbyte配列に読み込み
                fs.Read(blobData, 0, (int)fs.Length);
            }

            return blobData;
        }

        /// <summary>
        /// キャンセルチェック処理
        /// </summary>
        /// <remarks>キャンセルされていればReportLogCancelExceptionをthrowする</remarks>
        protected void CheckCanceled()
        {
            // 現印刷ログレコードのキャンセル状態を得る
            dynamic result = reportLogDao.Select(rowId);

            // キャンセル状態の場合は例外を発生させる
            if (result.CANCELED == 1)
            {
                throw new ReportLogCancelException();
            }
        }

        /// <summary>
        /// 定義体のファイル名を返す
        /// </summary>
        /// <param name="reportCd">帳票コード</param>
        /// <returns>定義体ファイル名</returns>
        protected List<string> ReadFormFileNames(string reportCd)
        {
            dynamic rec = reportDao.SelectReport(reportCd);

            var formFileList = new List<string>();

            if (rec == null)
            {
                return formFileList;
            }

            AddFormFileName(formFileList, rec.FEDFILE);
            AddFormFileName(formFileList, rec.FEDFILE2);
            AddFormFileName(formFileList, rec.FEDFILE3);
            AddFormFileName(formFileList, rec.FEDFILE4);
            AddFormFileName(formFileList, rec.FEDFILE5);
            AddFormFileName(formFileList, rec.FEDFILE6);
            AddFormFileName(formFileList, rec.FEDFILE7);
            AddFormFileName(formFileList, rec.FEDFILE8);
            AddFormFileName(formFileList, rec.FEDFILE9);
            AddFormFileName(formFileList, rec.FEDFILE10);

            return formFileList;
        }

        /// <summary>
        /// 定義体ファイル名がセットされていたら定義体リストに追加する
        /// </summary>
        /// <param name="formFileList">定義体リスト</param>
        /// <param name="name">定義体ファイル名</param>
        void AddFormFileName(List<string> formFileList, object name)
        {
            if (Util.ConvertToString(name) != "")
            {
                formFileList.Add(Util.ConvertToString(name));
            }
        }

        /// <summary>
        /// 指定レポートIDに対応するレポート生成クラスを検索し、そのインスタンスを返します。
        /// </summary>
        /// <param name="reportId">レポートID</param>
        /// <returns>レポート生成クラスのインスタンス</returns>
        //[LoggingParam]
        public ReportCreator CreateInstance(string reportId)
        {
            // レポートIDとプリフィックス値より、検索すべきレポート生成クラス名を生成する
            string className = (reportId + CREATOR_CLASSNAME_PREFIX).ToLower();

            // Reportsアセンブリをロードし、レポート生成クラスを検索
            Type type = Assembly.Load("Reports")
                .GetTypes()
                .FirstOrDefault(t => t.Name.ToLower().Equals(className));

            // タイプオブジェクトが得られない場合NULLを返す
            if (type == null)
            {
                return null;
            }

            // レポート生成クラスのインスタンス作成
            dynamic obj = Activator.CreateInstance(type);

            // 帳票用のクラスでない場合NULLを返す
            if (!(obj is ReportCreator))
            {
                return null;
            }

            return (ReportCreator)obj;
        }
    }
}
