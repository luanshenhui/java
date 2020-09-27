using Fujitsu.Hainsi.WindowServices.Common;
using Model = Hainsi.Entity.Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.ServiceProcess;
using System.Threading.Tasks;

namespace Fujitsu.Hainsi.WindowServices.RecvMyakuhaResult
{
    public class Program : ManagedInstaller
    {
        /// <summary>
        /// 更新者
        /// </summary>
        private static string UpdUser = "";

        /// <summary>
        /// Web API のベースURL
        /// </summary>
        private static string ApiUri = "";

        /// <summary>
        /// 受診者情報クラス
        /// </summary>
        private static CodeRevInfo HeaderInfo = null;

        /// <summary>
        /// 結果情報クラス
        /// </summary>
        private static CodeRevInfo DetailInfo = null;

        /// <summary>
        /// アプリケーションのメイン エントリ ポイントです。
        /// </summary>
        static void Main(string[] args)
        {
            // ログ出力クラスを初期化する
            Logging.Initialize(Logging.DestSystemConstants.Lains);

            // サービス名
            string serviceName = ConfigurationManager.AppSettings["ServiceName"].Trim();

            // 引数が存在する場合は
            // サービスのインストール／アンインストールを行う
            if (args.Length >= 1)
            {
                Install(serviceName, args);
                return;
            }

            // 共有フォルダパス
            string shareFolder = ConfigurationManager.AppSettings["ShareFolder"];

            // ユーザID
            string userID = ConfigurationManager.AppSettings["UserID"];

            // パスワード
            string password = ConfigurationManager.AppSettings["Password"];

            // ネットワークフォルダ対象フラグ
            string networkFolder = ConfigurationManager.AppSettings["networkFolder"];

            // バックアップフォルダ
            string backupFolderOK = ConfigurationManager.AppSettings["BackupFolderOK"];

            // バックアップフォルダ
            string backupFolderNG = ConfigurationManager.AppSettings["BackupFolderNG"];

            // フィルタ
            string filter = ConfigurationManager.AppSettings["Filter"];

            // サービスを開始する
            ServiceBase.Run(new GetFile(
                serviceName, shareFolder, userID, password, networkFolder, backupFolderOK, backupFolderNG, filter)
            {
                OnStartCallback = OnStart,
                FileCreateCallbak = ReadFile,
            });
        }

        /// <summary>
        /// 開始処理コールバック
        /// </summary>
        private static void OnStart()
        {

            // 更新者
            UpdUser = ConfigurationManager.AppSettings["UpdUser"].Trim();
            if (string.IsNullOrEmpty(UpdUser))
            {
                throw new Exception("更新者が設定されていません。");
            }

            // Web API のベースURL
            ApiUri = ConfigurationManager.AppSettings["ApiUri"].Trim();
            if (string.IsNullOrEmpty(ApiUri))
            {
                throw new Exception("Web API のベースURLが設定されていません。");
            }

            // 受診者情報を取得する
            try
            {
                HeaderInfo = CodeRevInfo.ReadJsonFile();
            }
            catch (Exception ex)
            {
                string msg = "受診者情報ファイルの取得処理でエラーが発生しました。";
                throw new Exception(msg, ex);
            }

            // 結果情報を取得する
            try
            {
                DetailInfo = CodeRevInfo.ReadJsonFileDetail();
            }
            catch (Exception ex)
            {
                string msg = "結果情報ファイルの取得処理でエラーが発生しました。";
                throw new Exception(msg, ex);
            }
        }

        /// <summary>
        /// ファイル読み込み処理
        /// </summary>
        static private bool ReadFile(string path)
        {

            // 取得したcsvファイルを配列に格納
            var valueList = new List<string>();

            // csvファイルを開く
            // 読み込み完了までループする。(ファイル書き込み途中の場合エラーとなるため。)
            int i = 0;
            while (true)
            {
                try
                {
                    using (var sr = new System.IO.StreamReader(path))
                    {
                        // ストリームの末尾まで繰り返す
                        while (!sr.EndOfStream)
                        {
                            // ファイルから一行読み込む
                            var line = sr.ReadLine();
                            // 読み込んだ一行をカンマ毎に分けて配列に格納する
                            var values = line.Split(',');
                            // 出力する
                            foreach (var value in values)
                            {
                                valueList.Add(value);
                            }
                        }
                        break;
                    }
                }
                catch (System.Exception ex)
                {
                    // ループが20回(10秒)を超えたらエラーとする。
                    if (i == 20)
                    {
                        string msg = "ファイルの読み取りでエラーが発生しました。";
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Program", "ReadFile", msg, ex);
                        return false;
                    }
                    i += 1;
                }
                System.Threading.Thread.Sleep(500);
            }

            // オーダ番号と日付を基に予約番号を取得する
            string orderNo = "";
            string cslDate ="";

            try
            {
                //オーダ番号の取得
                int orderIndex = int.Parse(HeaderInfo.GetHeaderInfoIndex("orderid"));
                orderNo = valueList[orderIndex - 1].Trim();
                //日付の取得
                int dateIndex = int.Parse(HeaderInfo.GetHeaderInfoIndex("orderdatetime"));
                cslDate = DateTime.Parse(valueList[dateIndex - 1]).ToString("yyyyMMdd").Trim();
            }
            catch (Exception ex)
            {
                string msg = "予約番号の取得処理でエラーが発生しました。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted", msg, ex);

                // 予約番号の取得処理でエラーが発生した場合
                return false;
            }

            long rsvNo = 0;
            try
            {
                string url = string.Format("api/v1/ordereddocs?orderno={0}&orderdate={1}",
                    orderNo,
                    Uri.EscapeDataString(DateTime.ParseExact(cslDate, "yyyyMMdd", null).ToString("yyyy/MM/dd HH:mm:ss")));
                Task<dynamic> taskGetData = WebAPI.GetDataAsync(ApiUri, url);

                dynamic result = taskGetData.Result;
                if (result == null)
                {
                    string msg = string.Format("予約番号を取得できませんでした。オーダ番号:{0}、日付:{1}",
                        orderNo, cslDate);
                    Logging.Output(
                        Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted", msg);

                    // 予約番号の取得処理でエラーが発生した場合
                    return false;
                }

                rsvNo = result[0].rsvno;
            }
            catch (Exception ex)
            {
                string msg = "予約番号の取得処理でエラーが発生しました。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted", msg, ex);
                
                // 予約番号の取得処理でエラーが発生した場合
                return false;
            }

            // 更新用に検査結果データを編集する
            IList<Model.Result.ResultWithStatus> resultList = EditResultList(valueList);
            if (resultList.Count == 0)
            {
                // 更新対象データが存在しない場合
                return false;
            }

            // 検査結果データを更新する
            if (UpdateResult(cslDate, rsvNo, resultList))
            {
                // 検査結果の登録処理に成功した場合
                return true;
            }
            else
            {
                // 予約番号の取得処理でエラーが発生した場合
                return false;
            }
        }

        /// <summary>
        /// 更新用に検査結果データを編集する
        /// </summary>
        /// <param name="values">受信電文データ</param>
        /// <returns>検査結果情報モデル</returns>
        static private IList<Model.Result.ResultWithStatus> EditResultList(List<string> values)
        {

            var resultList = new List<Model.Result.ResultWithStatus>();

            // 設定ファイルに設定されている項目を
            try
            {
                foreach (var rec in DetailInfo.ItemDetailList)
                {
                    // インデックスの取得
                    int index = int.Parse(rec.index);
                    // 検査項目の取得
                    string itemCd;
                    string suffix;
                    string[] workList = rec.itemCd.Split('|');
                    switch (workList.Length)
                    {
                        case 2:
                            itemCd = workList[0].Trim();
                            suffix = workList[1].Trim();
                            break;

                        default:
                            string msg = "App.Configの検査項目が正しく設定されていません。 index:" + index.ToString();
                            Logging.Output(
                                Logging.LogTypeConstants.Error, "Program", "EditResultList", msg);
                            continue;
                    }
                    // 検査結果の取得
                    string result = values[index - 1].Trim();

                    //// 検査結果が空の場合は何もしない
                    //if (string.IsNullOrEmpty(result))
                    //{
                    //    continue;
                    //}

                    // 更新データとして退避する
                    var resultRec = new Model.Result.ResultWithStatus();
                    resultList.Add(resultRec);

                    // 検査項目コード
                    resultRec.ItemCd = itemCd;
                    // サフィックス
                    resultRec.Suffix = suffix;
                    // 検査結果
                    resultRec.Result = result;
                }
            }
            catch (System.Exception ex)
            {
                string msg = "検査結果データ編集でエラーが発生しました。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "EditResultList", msg, ex);

            }

            return resultList;
        }

        /// <summary>
        /// 検査結果データを更新する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="resultList">検査結果情報モデル</param>
        static private bool UpdateResult(string calDate, long rsvNo, IList<Model.Result.ResultWithStatus> resultList)
        {
            var updResultList = new List<Model.Result.ResultRec>();

            try
            {
                // 検査結果データをチェックする
                string url = string.Format("api/v1/results/validation?csldate={0}",
                    Uri.EscapeDataString(DateTime.ParseExact(calDate, "yyyyMMdd", null).ToString("yyyy/MM/dd HH:mm:ss")));
                Task<dynamic> taskPostData = 
                    WebAPI.PostDataAsync<IList<Model.Result.ResultWithStatus>>(ApiUri, url, resultList);
                taskPostData.Wait();

                if (taskPostData.Result != null)
                {
                    // チェック処理結果を取得する
                    dynamic results = taskPostData.Result.results;
                    dynamic messages = taskPostData.Result.messages;

                    // 1件以上エラーがある場合はエラーメッセージをログに出力する
                    if (messages != null && messages.Count > 0)
                    {
                        foreach (string message in messages)
                        {
                            Logging.Output(
                                Logging.LogTypeConstants.Error, "Program", 
                                "UpdateResult - CheckResult", message);
                        }
                    }

                    // 検査結果データを更新用に退避する
                    foreach (dynamic result in results)
                    {
                        // チェック処理結果を取得する
                        var resultRec = new Model.Result.ResultWithStatus()
                        {
                            ItemCd = Convert.ToString(result.itemcd),
                            Suffix = Convert.ToString(result.suffix),
                            Result = Convert.ToString(result.result),
                            RslCmtCd1 = Convert.ToString(result.rslcmtcd1),
                            RslCmtCd2 = Convert.ToString(result.rslcmtcd2),
                            StopFlg = Convert.ToString(result.stopflg),
                            ShortStc = Convert.ToString(result.shortstc),
                            ResultError = Convert.ToString(result.resulterror),
                            RslCmtName1 = Convert.ToString(result.rslcmtname1),
                            RslCmtError1 = Convert.ToString(result.rslcmterror1),
                            RslCmtName2 = Convert.ToString(result.rslcmtname2),
                            RslCmtError2 = Convert.ToString(result.rslcmterror2),
                        };

                        if (!resultRec.ResultError.Equals("") ||
                            !resultRec.RslCmtError1.Equals("") ||
                            !resultRec.RslCmtError2.Equals(""))
                        {
                            // エラーが発生している検査項目をログに出力する
                            string msg = string.Format("[{0}]-[{1}] [{2}] [{3}] [{4}]",
                                resultRec.ItemCd, resultRec.Suffix, 
                                resultRec.Result, resultRec.RslCmtCd1, resultRec.RslCmtCd2);
                            Logging.Output(
                                Logging.LogTypeConstants.Error, "Program", "UpdateResult - CheckResult", msg);
                            continue;
                        }

                        // エラーが発生していない検査項目のみを更新の対象とする
                        updResultList.Add(resultRec);
                    }
                }
            }
            catch (Exception ex)
            {
                string msg = "検査結果のチェック処理でエラーが発生しました。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "UpdateResult", msg, ex);
                return false;
            }

            // 更新対象データが0件の場合は更新処理を行わない
            if (updResultList.Count == 0)
            {
                return true;
            }

            try
            {
                // 検査結果データを更新する
                string url = string.Format("api/v1/results/{0}/addparam?userid={1}&includeStopFlg=false&skipNoRec=true",
                    rsvNo, Uri.EscapeDataString(UpdUser));
                Task<dynamic> taskPutData = 
                    WebAPI.PutDataAsync<IList<Model.Result.ResultRec>>(ApiUri, url, updResultList);
                taskPutData.Wait();

                if (taskPutData.Result != null && taskPutData.Result is string)
                {
                    // エラー内容をログに出力する
                    Logging.Output(
                        Logging.LogTypeConstants.Error, "Program", "UpdateResult",
                        "検査結果の更新処理でエラーが発生しました。" + (string)taskPutData.Result);
                    return false;
                }
            }
            catch (Exception ex)
            {
                string msg = "検査結果の更新処理でエラーが発生しました。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "UpdateResult", msg, ex);
                return false;
            }

            return true;
        }
    }
}
