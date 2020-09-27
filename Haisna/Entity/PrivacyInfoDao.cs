using Hainsi.Common;
using System;
using System.Data;
using System.IO;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 情報漏洩対策用データアクセスオブジェクト
    /// </summary>
    public class PrivacyInfoDao : AbstractDao
    {
        private const string SEPARATESTRING = ",";
        private const string WRAPCHAR = "\"\"";
        private const string LOGFIELDNAME = "分割区分,操作日付,端末ＩＤ,機能コード,利用者ＩＤ,患者ＩＤ,依頼医利用者ＩＤ,職種コード,科コード,病棟コード,担当区分,ログデータ（固定部）,ログデータ（可変部）";      // 契約情報の特

        /// <summary>
        /// ユーザデータアクセスオブジェクト
        /// </summary>
        readonly HainsUserDao hainsUserDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        /// <param name="hainsUserDao">ユーザデータアクセスオブジェクト</param>
        public PrivacyInfoDao(IDbConnection connection, HainsUserDao hainsUserDao) : base(connection)
        {
            this.hainsUserDao = hainsUserDao;
        }

        ///// <summary>
        ///// 情報漏えい対策ログ出力
        ///// </summary>
        ///// <param name="userId">ログインID</param>
        ///// <param name="functionCode">機能コード（各ASP個別指定。聖路加指定のため追加）</param>
        ///// <param name="logMessage">ログメッセージ（各ASP個別指定。聖路加指定のため追加）</param>
        ///// <param name="httpContext">HttpContextオブジェクト</param>
        ///// <returns>
        ///// -1     異常終了
        ///// 1      正常終了
        ///// </returns>
        //public int PutPrivacyInfoLog(string userId, string functionCode, string logMessage, HttpContext httpContext)
        //{
        //    int ret = -1;

        //    // UserIDの存在チェック実施
        //    if (!CheckHainsUser(userId))
        //    {
        //        throw new Exception("指定されたユーザIDがサーバに存在しません。引数を確認してください。");
        //    }

        //    string wkQueryString = "";
        //    string wkIPAddress = "";
        //    string wkAspName = "";

        //    // （ログファイルの排他を極限までなくしたいので文字列編集を最初に処理）
        //    wkIPAddress = httpContext.Connection.RemoteIpAddress.ToString();    // IPアドレス
        //    wkAspName = httpContext.Request.Path;                               // ファイルパス
        //    wkQueryString = EditQueryString(httpContext);                       // クエリーストリング

        //    // 深夜日時代わりで出力先パスが変わるとよくないのでここで取得しておく
        //    DateTime executeDate;
        //    executeDate = DateTime.Now;

        //    // 出力先ログファイルフルパスの取得
        //    string logFileName;
        //    logFileName = GetLogFileName(executeDate);

        //    // ログファイル存在チェック
        //    if (logFileName != null)
        //    {
        //        // 存在しないなら作成（フルパス取得時に存在チェックをしないのは、ログ出力のオーバヘッドを最小限にしたいため）
        //        CreateLogFile(executeDate, logFileName);
        //    }

        //    // ログ明細行編集
        //    string logText;
        //    logText = "";
        //    logText += WRAPCHAR + "" + WRAPCHAR + SEPARATESTRING;                                      // 分割区分
        //    logText += WRAPCHAR + GetNowTime() + WRAPCHAR + SEPARATESTRING;                            // 操作日付
        //    logText += WRAPCHAR + wkIPAddress + WRAPCHAR + SEPARATESTRING;                             // 端末ID
        //    logText += WRAPCHAR + functionCode + WRAPCHAR + SEPARATESTRING;                            // 機能コード
        //    logText += WRAPCHAR + userId + WRAPCHAR + SEPARATESTRING;                                  // 利用者ID
        //    logText += WRAPCHAR + GetPerIDFromQueryString(wkQueryString) + WRAPCHAR + SEPARATESTRING;  // 患者ID
        //    logText += WRAPCHAR + "" + WRAPCHAR + SEPARATESTRING;                                      // 依頼利用者ID
        //    logText += WRAPCHAR + "" + WRAPCHAR + SEPARATESTRING;                                      // 職種コード
        //    logText += WRAPCHAR + "" + WRAPCHAR + SEPARATESTRING;                                      // 科コード
        //    logText += WRAPCHAR + "" + WRAPCHAR + SEPARATESTRING;                                      // 病棟コード
        //    logText += WRAPCHAR + "" + WRAPCHAR + SEPARATESTRING;                                      // 担当区分
        //    logText += WRAPCHAR + logMessage + WRAPCHAR + SEPARATESTRING;                              // ログデータ(固定部)
        //    logText += WRAPCHAR + wkQueryString + WRAPCHAR;                                            // ログデータ（可変部）

        //    FileStream outTempFile = null;
        //    StreamWriter outTempFileWriter = null;
        //    outTempFile = new FileStream(logFileName, FileMode.Append);
        //    outTempFileWriter = new StreamWriter(outTempFile);
        //    outTempFileWriter.WriteLine(logText);
        //    outTempFileWriter.Close();

        //    ret = 1;
        //    return ret;
        //}

        /// <summary>
        /// 処理時間編集(msec対応）
        /// </summary>
        /// <returns>処理時間</returns>
        public string GetNowTime()
        {
            return DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss.fff");
        }

        /// <summary>
        /// HainsUser妥当性チェック
        /// </summary>
        /// <param name="userID">userID ユーザID</param>
        /// <returns>true:存在、false:なし</returns>
        private bool CheckHainsUser(string userID)
        {
            // オブジェクトのインスタンス作成
            dynamic hainsUser;

            // 引数のuserIDを渡し存在チェックを返す
            hainsUser = hainsUserDao.SelectHainsUser(userID, false);

            if (hainsUser == null)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        /// <summary>
        /// 個人ID抽出
        /// </summary>
        /// <param name="queryString">クエリー文字列</param>
        /// <returns>個人ID</returns>
        private string GetPerIDFromQueryString(string queryString)
        {
            string perId = "";
            string[] arrayData = new string[] { };
            int i;
            string upper;

            // &で分割して配列に格納する
            arrayData = queryString.Split('&');

            // 配列をLoopしPerID指定されている変数を探す。
            for (i = 0; i <= arrayData.Count(); i++)
            {
                // 変数をすべて大文字に
                upper = arrayData[i].ToUpper();

                // 先頭がPERID=のものを検索。結果から値のみ抽出
                if (upper.IndexOf("PERID=") > 0)
                {
                    perId = upper.Substring(6, upper.Length - 6);
                    break;
                }
            }

            // 取得したPerIDを返す
            return perId;
        }

        ///// <summary>
        ///// クエリーストリング文字列編集
        ///// </summary>
        ///// <param name="httpContext">HttpContextオブジェクト</param>
        ///// <returns>編集済みリクエスト文字列</returns>
        //private string EditQueryString(HttpContext httpContext)
        //{
        //    string wkString = "";
        //    string editQueryString = "";

        //    // 現状POSTGETが混在状態のため、どちらもログ出力する形とする。
        //    // GET系データ取得
        //    if ("GET".Equals(httpContext.Request.Method))
        //    {
        //        wkString += "GET:";
        //        string QueryString = httpContext.Request.QueryString.Value;
        //        if (QueryString.Length > 0)
        //        {
        //            wkString += httpContext.Request.QueryString.Value.Substring(1);
        //        }
        //    }

        //    // POST系データ取得
        //    if ("POST".Equals(httpContext.Request.Method))
        //    {
        //        wkString += "POST:";
        //        foreach (var item in httpContext.Request.Form)
        //        {
        //            wkString += item.Key;     // 名称
        //            wkString += "=";
        //            wkString += item.Value;   // 値
        //            wkString += "&";
        //        }
        //    }

        //    editQueryString = wkString;
        //    return editQueryString;
        //}

        /// <summary>
        /// ログファイル名取得
        /// </summary>
        /// <param name="executeDate">実行日時</param>
        /// <returns>ログファイル名</returns>
        private string GetLogFileName(DateTime executeDate)
        {
            string rootFolder;
            string logFileName;

            // iniファイルよりLog出力のルートディレクトリ情報を取得する
            rootFolder = WebHains.ReadIniFile("PRIVACYINFO", "LOGPATH");

            // 実行年を取得しフォルダ名とする
            logFileName = rootFolder + "\\" + executeDate.Year;

            // 実行日を取得しログファイル名とする
            logFileName += "\\" + executeDate.Year.ToString() + executeDate.Month.ToString() + executeDate.Day.ToString() + ".log";

            return logFileName;
        }

        /// <summary>
        /// ログファイル作成
        /// </summary>
        /// <param name="executeDate">実行日時</param>
        /// <param name="logFileName">ログファイル名フルパス</param>
        private void CreateLogFile(DateTime executeDate, string logFileName)
        {
            // iniファイルよりLog出力のルートディレクトリ情報を取得する
            string rootFolder;
            rootFolder = WebHains.ReadIniFile("PRIVACYINFO", "LOGPATH");

            // ルート・ディレクトリの存在チェックをしてなければ作成
            if (!File.Exists(rootFolder))
            {
                File.CreateText(rootFolder);
            }

            string yearDirectory;
            yearDirectory = rootFolder + "\\" + executeDate.Year.ToString();

            // 年度ディレクトリの存在チェックをしてなければ作成
            if (!File.Exists(yearDirectory))
            {
                File.CreateText(yearDirectory);
            }

            // ログファイル先頭に書き出し開始メッセージ出力
            FileStream outTempFile = null;
            StreamWriter outTempFileWriter = null;
            outTempFile = new FileStream(logFileName, FileMode.Append);
            outTempFileWriter = new StreamWriter(outTempFile);
            outTempFileWriter.WriteLine(LOGFIELDNAME);
            outTempFileWriter.Close();
        }
    }
}