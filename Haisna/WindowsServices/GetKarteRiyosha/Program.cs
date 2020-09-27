using Fujitsu.Hainsi.WindowServices.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Fujitsu.Hainsi.WindowServices.GetKarteRiyosha
{
    static class Program
    {
        /// <summary>
        /// 取り込みファイルパス
        /// </summary>
        private static string FilePath = "";

        /// <summary>
        /// Web API のベースURL
        /// </summary>
        private static string ApiUri = "";

        /// <summary>
        /// CSV項目情報
        /// </summary>
        private static CsvFieldInfo CsvInfo = null;

        /// <summary>
        /// アプリケーションのメイン エントリ ポイントです。
        /// </summary>
        [STAThread]
        static int Main()
        {
            // ログ出力クラスを初期化する
            Logging.Initialize(Logging.DestSystemConstants.Smile);

            // Semaphoreオブジェクトを生成する
            using (var semaphore = new Semaphore(1, 1, "HainsGetKarteRiyosha", out bool createdNew))
            {
                if (!createdNew)
                {
                    // 同一プロセスが既に起動している場合は処理を中止する
                    Logging.Output(
                        Logging.LogTypeConstants.Error,
                        "カルテ利用者連携処理が起動中のため、処理を中止します。");
                    return 1;
                }

                try
                {
                    // 処理開始
                    Logging.Output(
                        Logging.LogTypeConstants.FreeOutput, "Program", "Main",
                        "カルテ利用者連携処理を開始します。");

                    // 取り込みファイルパス
                    FilePath = ConfigurationManager.AppSettings["FilePath"].Trim();
                    if (string.IsNullOrEmpty(FilePath))
                    {
                        Logging.Output(
                            Logging.LogTypeConstants.Error,
                            "取り込みファイルパスが設定されていません。");
                        return 1;
                    }

                    // Web API のベースURL
                    ApiUri = ConfigurationManager.AppSettings["ApiUri"].Trim();
                    if (string.IsNullOrEmpty(ApiUri))
                    {
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Program", "Main",
                            "Web API のベースURLが設定されていません。");
                        return 1;
                    }

                    // CSV項目情報を取得する
                    try
                    {
                        CsvInfo = CsvFieldInfo.ReadJsonFile();
                    }
                    catch (Exception ex)
                    {
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Program", "Main",
                            "CSV項目情報ファイルの取得処理でエラーが発生しました。", ex);
                        return 1;
                    }

                    // 取り込みファイルが存在するかをチェックする
                    var isExistFile = false;
                    try
                    {
                        isExistFile = File.Exists(FilePath);
                    }
                    catch (Exception ex)
                    {
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Program", "Main",
                            "取り込みファイルのチェック処理でエラーが発生しました。", ex);
                        return 1;
                    }

                    if (!isExistFile)
                    {
                        // 取込ファイルが存在しない場合
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Program", "Main",
                            string.Format("ファイル'{0}'が存在しません。", FilePath));
                        return 1;
                    }

                    // ファイルの取り込み処理を行う
                    if (!ImportCsvFile())
                    {
                        return 1;
                    }

                    // 正常終了
                    return 0;
                }
                finally
                {
                    // 処理終了
                    Logging.Output(
                        Logging.LogTypeConstants.FreeOutput, "Program", "Main",
                        "カルテ利用者連携処理を終了します。");
                }
            }
        }

        /// <summary>
        /// CSVファイル取込処理
        /// </summary>
        /// <returns>True:処理成功、False:処理失敗</returns>
        private static bool ImportCsvFile()
        {
            try
            {
                var successCount = 0;
                var errorCount = 0;

                // CSVファイルを読み込む
                using (var sr = new StreamReader(FilePath, Encoding.GetEncoding("shift_jis")))
                {
                    while (!sr.EndOfStream)
                    {
                        // １行分のデータを取得する
                        var line = sr.ReadLine();
                        if (string.IsNullOrWhiteSpace(line))
                        {
                            continue;
                        }

                        // カンマ","を区切り文字として各フィールドに分割する
                        Dictionary<string, string> fields = null;
                        try
                        {
                            fields = GetFields(line);
                        }
                        catch (Exception ex)
                        {
                            Logging.Output(
                                Logging.LogTypeConstants.Error, "Program", "ImportCsvFile",
                                string.Format("エラーのため取込処理をスキップします。[{0}]\n{1}", line, ex.Message));
                            errorCount++;
                            continue;
                        }

                        // 取得したデータをログに出力する
                        Logging.Output(
                            Logging.LogTypeConstants.FreeOutput, "Program", "ImportCsvFile",
                            string.Format("[{0}]", line));

                        // 利用者ID
                        var rysId = fields["RYS-ID"];
                        // 利用者氏名カナ
                        var rysNameK = fields["RYS-NAMEK"];
                        // 利用者氏名漢字
                        var rysNameN = fields["RYS-NAMEN"];
                        // 利用者氏名英字
                        var rysNameE = fields["RYS-NAMEE"];
                        // WindowsログインID
                        var rysWinId = fields["RYS-WINID"];

                        try
                        {
                            // WebAPIのURLを編集する
                            var url = string.Format(
                                "api/v1/users/name?userid={0}&username={1}&kname={2}&ename={3}&windowsloginid={4}",
                                Uri.EscapeDataString(rysId),
                                Uri.EscapeDataString(rysNameN),
                                Uri.EscapeDataString(rysNameK),
                                Uri.EscapeDataString(rysNameE),
                                Uri.EscapeDataString(rysWinId));

                            // 利用者情報を登録する
                            Task<dynamic> taskPutData = WebAPI.PutDataAsync<object>(ApiUri, url, null);
                            taskPutData.Wait();

                            if (taskPutData.Result != null && taskPutData.Result is string)
                            {
                                // エラー内容をログに出力する
                                Logging.Output(
                                    Logging.LogTypeConstants.Error, "Program", "ImportCsvFile",
                                    string.Format("{0}[{1}]", (string)taskPutData.Result, line));
                                errorCount++;
                                continue;
                            }

                            successCount++;
                        }
                        catch (Exception ex)
                        {
                            // エラー内容をログに出力する
                            Logging.Output(
                                Logging.LogTypeConstants.Error, "Program", "ImportCsvFile",
                                string.Format("利用者情報の登録処理に失敗しました。[{0}]", line), ex);
                            errorCount++;
                            continue;
                        }
                    }
                }

                // 処理終了
                Logging.Output(
                    Logging.LogTypeConstants.FreeOutput, "Program", "ImportCsvFile",
                    string.Format("【登録件数：{0}　エラー件数：{1}】", successCount, errorCount));
                return (errorCount == 0);
            }
            catch (Exception ex)
            {
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "ImportCsvFile",
                    "CSVファイル取込処理でエラーが発生しました。", ex);
                return false;
            }
        }

        /// <summary>
        /// フィールド値取得処理
        /// </summary>
        /// <param name="line">行データ</param>
        /// <returns>フィールド値</returns>
        private static Dictionary<string, string> GetFields(string line)
        {
            // カンマ","を区切り文字として各フィールドに分割する
            var values = line.Split(',');

            // 戻り値を初期化する
            var fields = new Dictionary<string, string>();

            var messages = new List<string>();
            foreach (CsvFieldInfo.CsvFieldItem item in CsvInfo.Items)
            {
                var fieldValue = "";

                if (item.UseFlg == 1)
                {
                    // フィールドの値を取得する
                    if (values.Length > item.Index)
                    {
                        fieldValue = values[item.Index - 1].Trim();
                    }

                    // フィールド値がダブルクォートで囲まれている場合はそれを除去する
                    if (fieldValue.StartsWith("\"") && fieldValue.EndsWith("\""))
                    {
                        fieldValue = fieldValue.Substring(1, fieldValue.Length - 2).Trim();
                    }

                    // 空白設定フラグが空白不可で、かつデータが空白の場合
                    if (item.SpaceFlg == 0 && fieldValue.Equals(""))
                    {
                        messages.Add(string.Format("{0} の値は必須ですが空白がセットされています", item.NameJa));
                        continue;
                    }

                    // 項目タイプが数値で、かつデータが数値以外の場合
                    if (item.Type == CsvFieldInfo.CsvFieldItem.DataTypeConstants.numeric &&
                        !long.TryParse(fieldValue, out long tmpLongData))
                    {
                        messages.Add(string.Format("{0} は数値ではありません : {1}", item.NameJa, fieldValue));
                        continue;
                    }

                    // 設定値が設定されている場合
                    if (item.Values != null && item.Values.Length > 0)
                    {
                        // 設定値とデータとを比較する
                        bool isMatch = false;
                        foreach (string value in item.Values)
                        {
                            if (value.Equals("SP"))
                            {
                                // 空白の場合
                                if (fieldValue.Equals(""))
                                {
                                    isMatch = true;
                                    break;
                                }
                            }
                            else
                            {
                                // その他の場合
                                if (fieldValue.ToUpper().Equals(value.ToUpper()))
                                {
                                    isMatch = true;
                                    break;
                                }
                            }
                        }

                        // 何れの設定値とも一致しなかった場合
                        if (!isMatch)
                        {
                            messages.Add(string.Format("{0} は有効文字列ではありません : {1}", item.NameJa, fieldValue));
                            continue;
                        }
                    }
                }

                fields.Add(item.NameEn, fieldValue);
            }

            if (messages.Count > 0)
            {
                throw new Exception(string.Join("\n", messages.ToArray()));
            }

            return fields;
        }
    }
}
