using Hainsi.Entity;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Entity.Helper
{
    /// <summary>
    /// DataSet変換クラス
    /// </summary>
    public static class DataSetConverter
    {
        /// <summary>
        /// 総レコード数のフィールド名
        /// </summary>
        const string FIELD_TOTALCOUNT = "TOTALCOUNT";

        /// <summary>
        /// 問い合わせ結果を、検索データと検索件数との組に変換します。
        /// </summary>
        /// <param name="query">問い合わせ</param>
        /// <returns>PartialDataSetクラスのインスタンス</returns>
        public static PartialDataSet<dynamic> ToPartialDataSet(IEnumerable<dynamic> query)
        {
            var data = (IEnumerable<IDictionary<string, object>>)query;

            // 検索件数の取得
            int totalCount = GetTotalCount(data);

            // 検索件数の列を削除
            IEnumerable<IDictionary<string, object>> reducedData = RemoveTotalCountField(data);

            // PartialDataSetクラスのインスタンスを作成して返す
            return new PartialDataSet<dynamic>()
            {
                TotalCount = totalCount,
                Data = reducedData
            };
        }

        /// <summary>
        /// 問い合わせ結果から検索件数の値を取得します。
        /// </summary>
        /// <param name="data">問い合わせ結果</param>
        /// <returns>PartialDataSetクラスのインスタンス</returns>
        static int GetTotalCount(IEnumerable<IDictionary<string, object>> data)
        {
            int count = data.Count();
            if (count == 0)
            {
                return count;
            }

            // 先頭レコードの検索件数フィールド値を取得（存在しない場合は問い合わせ結果レコードの数を取得）
            var rec = data?.First();
            return rec.ContainsKey(FIELD_TOTALCOUNT) ? Convert.ToInt32((decimal)rec[FIELD_TOTALCOUNT]) : count;
        }

        /// <summary>
        /// 問い合わせ結果から検索件数の列を削除します。
        /// </summary>
        /// <param name="data">問い合わせ結果</param>
        /// <returns>PartialDataSetクラスのインスタンス</returns>
        static IEnumerable<IDictionary<string, object>> RemoveTotalCountField(IEnumerable<IDictionary<string, object>> data)
        {
            // 各フィールドの列削除処理
            return data.Select((rec) =>
            {
                rec.Remove(FIELD_TOTALCOUNT);
                return rec;
            });
        }
    }
}
