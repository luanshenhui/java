using Hainsi.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace Hainsi.ReportCore
{
    public abstract class CsvCreator : ReportCreator
    {
        /// <summary>
        /// MIMEタイプ
        /// </summary>
        public override Report.MimeType MimeType { get; } = Report.MimeType.Csv;

        /// <summary>
        /// CSVの各カラムに引用符の有無
        /// </summary>
        private bool AddQuotes { get; set; }

        /// <summary>
        /// CSVのヘッダの有無
        /// </summary>
        private bool NoHeader { get; set; }

        /// <summary>
        /// パラメータをセットする
        /// </summary>
        /// <param name="queryParam">パラメータ</param>
        public override sealed void SetQueryParam(ParamValues queryParam)
        {
            base.SetQueryParam(queryParam);

            FileName = queryParam["fileName"];
            AddQuotes = queryParam["addQuotes"] == "1";
            NoHeader = queryParam["noHeader"] == "1";
        }

        /// <summary>
        /// CSVファイルを作成する
        /// </summary>
        /// <returns>印刷ログ書き込みクラス</returns>
        public override sealed void CreateContent()
        {
            // データ読み込み
            List<dynamic> data = GetData();

            // 件数0なら処理しない
            if (data.Count == 0)
            {
                return;
            }

            // 一時ファイル作成
            string tempFileName = Path.GetTempFileName();
            var sw = new StreamWriter(tempFileName, false, Encoding.GetEncoding("Shift_JIS"));

            try
            {
                // CSV作成
                bool isFirst = true;
                foreach (IDictionary<string, object> row in data)
                {
                    // 1行目にカラム名をセット
                    if (!NoHeader && isFirst)
                    {
                        sw.WriteLine(convertCsv(row.Keys, AddQuotes));
                        isFirst = false;
                    }

                    //キャンセルの確認
                    CheckCanceled();

                    // データをセット
                    sw.WriteLine(convertCsv(row.Values, AddQuotes));
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

                // DBへアップロード元となる一時ファイルパスをセットする
                TempFilePath = tempFileName;
            }

            // ステータスを正常にセット
            Status = Report.Status.Success;
        }

        /// <summary>
        /// コレクションをCSVの文字列に変換する
        /// 引用符が
        /// </summary>
        /// <param name="collection">コレクション</param>
        /// <param name="addQuotes">引用符の有無</param>
        /// <returns>CSV文字列</returns>
        private string convertCsv(IEnumerable<dynamic> collection, bool addQuotes)
        {
            var fields = new List<string>();

            foreach (dynamic field in collection)
            {
                if (addQuotes)
                {
                    fields.Add(string.Concat("\"", Util.ConvertToString(field).Replace("\"", "\"\""), "\""));
                }
                else
                {
                    fields.Add(Util.ConvertToString(field));
                }
            }
            return string.Join(",", fields);
        }

        /// <summary>
        /// CSVの作成元となるデータを取得
        /// </summary>
        /// <returns>CSVデータソース</returns>
        protected abstract List<dynamic> GetData();
    }
}
