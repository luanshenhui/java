using System;
using System.ServiceProcess;
using Microsoft.VisualBasic.FileIO;
using System.Runtime.InteropServices;

namespace Fujitsu.Hainsi.WindowServices.Common
{
    public partial class GetFile : ServiceBase
    {
        // フォルダ監視オブジェクト
        private System.IO.FileSystemWatcher watcher = null;

        // 共有フォルダパス
        private string shareFolder = "";

        // ユーザID
        private string userId = "";

        // パスワード
        private string password = "";

        // ネットワークフォルダ対象フラグ
        private string networkFolder = "";

        // バックアップフォルダOK
        private string backupFolderOK = "";

        // バックアップフォルダNG
        private string backupFolderNG = "";

        // フィルタ
        private string filter = "";

        // 開始処理コールバック
        public Action OnStartCallback = null;

        // ファイル取得コールバック
        public Func<string, bool> FileCreateCallbak = null;

        //接続切断するWin32 API を宣言
        [DllImport("mpr.dll", EntryPoint = "WNetCancelConnection2", CharSet = System.Runtime.InteropServices.CharSet.Unicode)]
        private static extern int WNetCancelConnection2(string lpName, Int32 dwFlags, bool fForce);

        //認証情報を使って接続するWin32 API宣言
        [DllImport("mpr.dll", EntryPoint = "WNetAddConnection2", CharSet = System.Runtime.InteropServices.CharSet.Unicode)]
        private static extern int WNetAddConnection2(ref NETRESOURCE lpNetResource, string lpPassword, string lpUsername, Int32 dwFlags);

        //WNetAddConnection2に渡す接続の詳細情報の構造体
        [StructLayout(LayoutKind.Sequential)]
        internal struct NETRESOURCE
        {
            public int dwScope;//列挙の範囲
            public int dwType;//リソースタイプ
            public int dwDisplayType;//表示オブジェクト
            public int dwUsage;//リソースの使用方法
            [MarshalAs(UnmanagedType.LPWStr)]
            public string lpLocalName;//ローカルデバイス名。使わないならNULL。
            [MarshalAs(UnmanagedType.LPWStr)]
            public string lpRemoteName;//リモートネットワーク名。使わないならNULL
            [MarshalAs(UnmanagedType.LPWStr)]
            public string lpComment;//ネットワーク内の提供者に提供された文字列
            [MarshalAs(UnmanagedType.LPWStr)]
            public string lpProvider;//リソースを所有しているプロバイダ名
        }

        /// <summary>
        /// コンストラクタ
        /// </summary>
        public GetFile(
            string serviceName, string shareFolder, string userId, string password,
            string networkFolder, string backupFolderOK, string backupFolderNG, string filter)
        {
            InitializeComponent();

            // サービス名
            this.ServiceName = serviceName;
            eventLog.Source = serviceName;

            // 共有フォルダパス
            this.shareFolder = shareFolder;

            // ユーザID
            this.userId = userId;

            // パスワード
            this.password = password;

            // ネットワークフォルダ対象フラグ
            this.networkFolder = networkFolder;

            // バックアップフォルダOK
            this.backupFolderOK = backupFolderOK;

            // バックアップフォルダNG
            this.backupFolderNG = backupFolderNG;

            // フィルタ
            this.filter = filter;
            
        }

        protected override void OnStart(string[] args)
        {
            // デバック実行時にVisualStudioでアタッチできるようにする
            //System.Diagnostics.Debugger.Launch();

            // 電文受信プログラム起動
            Logging.Output(Logging.LogTypeConstants.ServerStart);

            // 開始処理コールバック
            if (OnStartCallback != null)
            {
                try
                {
                    OnStartCallback();
                }
                catch (Exception ex)
                {
                    string msg = "サービスの開始処理に失敗しました。\n" + ex.Message;
                    Logging.Output(Logging.LogTypeConstants.Error, "GetFile", "OnStart", msg.Replace("\n", ""), ex);
                    CancelOnStart(msg);
                    return;
                }
            }

            try
            {

                // ネットワークフォルダの場合、接続処理を行う。
                if (networkFolder.Equals("1"))
                {
                    // 接続情報を設定  
                    NETRESOURCE netResource = new NETRESOURCE();
                    netResource.dwScope = 0;
                    netResource.dwType = 1;
                    netResource.dwDisplayType = 0;
                    netResource.dwUsage = 0;
                    netResource.lpLocalName = "";
                    netResource.lpRemoteName = shareFolder;
                    netResource.lpProvider = "";

                    int ret = 0;

                    //既に接続してる場合があるので一旦切断する
                    ret = WNetCancelConnection2(shareFolder, 0, true);

                    //共有フォルダに認証情報を使って接続
                    ret = WNetAddConnection2(ref netResource, password, userId, 0);

                }

                watcher = new System.IO.FileSystemWatcher();
                //監視するディレクトリを指定
                watcher.Path = moldFilePath(@shareFolder);
                //監視する拡張子を設定、すべて監視するときは""にする
                watcher.Filter = filter;
                //ファイル名とディレクトリ名と最終書き込む日時の変更を監視
                watcher.NotifyFilter =
                    System.IO.NotifyFilters.FileName
                    | System.IO.NotifyFilters.DirectoryName
                    | System.IO.NotifyFilters.LastWrite;
                //サブディレクトリは監視しない
                watcher.IncludeSubdirectories = false;

                //イベントハンドラの追加
                watcher.Created += new System.IO.FileSystemEventHandler(watcher_Changed);

                //監視を開始する
                watcher.EnableRaisingEvents = true;

            }
            catch (Exception ex)
            {
                // 開始処理に失敗した場合はサービスを終了する
                string msg = string.Format("サービスの開始処理に失敗しました。");
                Logging.Output(Logging.LogTypeConstants.Error, "GetFile", "OnStart", msg.Replace("\n", ""), ex);
                CancelOnStart(msg);
            }
        }

        private void watcher_Changed(System.Object source,System.IO.FileSystemEventArgs e)
        {
            try
            {
                switch (e.ChangeType)
                {
                    case System.IO.WatcherChangeTypes.Created:

                        System.Threading.Thread.Sleep(300);

                        // 作成
                        if (FileCreateCallbak(e.FullPath))
                        {
                            // 終了処理
                            // ファイルをバックアップフォルダ(OK)に移動
                            System.Threading.Thread.Sleep(200);
                            FileSystem.MoveFile(e.FullPath, moldFilePath(@backupFolderOK) + e.Name, true);
                        }
                        else
                        {
                            // 終了処理
                            // ファイルをバックアップフォルダ(NG)に移動
                            System.Threading.Thread.Sleep(200);
                            FileSystem.MoveFile(e.FullPath, moldFilePath(@backupFolderNG) + e.Name, true);
                        }
                        break;
                }
            }
            catch (Exception ex)
            {
                // ファイルのコピーに失敗した場合
                string msg = string.Format("バックアップへのコピーにに失敗しました。");
                Logging.Output(Logging.LogTypeConstants.Error, "GetFile", "watcher_Changed", msg.Replace("\n", ""), ex);
            }
        }


        protected override void OnStop()
        {
            //監視を終了
            watcher.EnableRaisingEvents = false;
            watcher.Dispose();
            watcher = null;

            // 電文受信プログラム終了
            Logging.Output(Logging.LogTypeConstants.ServerEnd);
        }

        private void CancelOnStart(string message)
        {
            // イベントログへの自動ログ出力を停止する
            this.AutoLog = false;

            // イベントログにエラー内容を出力する
            eventLog.WriteEntry(message, System.Diagnostics.EventLogEntryType.Error);

            // サービスを終了する
            this.Stop();
        }

        private string moldFilePath(string path)
        {
            // ファイルパスの末尾に"\"がなければ付加する。
            string returnPath;
            string checkString = path.Substring(path.Length - 1);

            if( checkString == @"\")
            {
                returnPath = path;
            }
            else
            {
                returnPath = path + @"\";
            }

            return returnPath;
        }
    }
}
