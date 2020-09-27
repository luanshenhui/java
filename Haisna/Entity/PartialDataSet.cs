using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// ある検索における、検索データの一部分と全検索件数との組とを管理します。
    /// </summary>
    public class PartialDataSet
    {
        /// <summary>
        /// 全検索件数を取得します。
        /// </summary>
        public decimal TotalCount { get; } = 0;

        /// <summary>
        /// 検索データを取得します。
        /// </summary>
        public IList<IDictionary<string, object>> Data { get; }

        /// <summary>
        /// 検索データを元に新しいPartialDataSetクラスのインスタンスを作成します。
        /// </summary>
        /// <param name="totalCount">全検索件数</param>
        /// <param name="query">Queryオブジェクト</param>
        public PartialDataSet(decimal totalCount = 0, IEnumerable<IDictionary<string, object>> query = null)
        {
            TotalCount = totalCount;
            Data = query?.ToList();
        }

        /// <summary>
        /// 検索データを元に新しいPartialDataSetクラスのインスタンスを作成します。検索データに全検索件数列が存在する場合はその値をTotalCountプロパティの値として設定します。
        /// </summary>
        /// <param name="query">Queryオブジェクト</param>
        public PartialDataSet(IEnumerable<IDictionary<string, object>> query)
        {
            // 取得レコードと件数をセット
            Data = query.ToList();
            TotalCount = Data.Count;

            // データが存在し、レコードセット内に"TOTALCOUNT"という列があればその値を件数としてセットする
            if ((TotalCount > 0) && Data.First().ContainsKey("TOTALCOUNT"))
            {
                TotalCount = Convert.ToDecimal(Data.First()["TOTALCOUNT"]);
            }
        }

        /// <summary>
        /// 検索データを元に新しいPartialDataSetクラスのインスタンスを作成します。
        /// </summary>
        /// <param name="totalCount">全検索件数</param>
        /// <param name="query">Queryオブジェクト</param>
        public PartialDataSet(decimal totalCount = 0, IEnumerable<dynamic> query = null) : this(totalCount, query?.Select(x => (IDictionary<string, object>) x))
        {
        }

        /// <summary>
        /// 検索データを元に新しいPartialDataSetクラスのインスタンスを作成します。検索データに全検索件数列が存在する場合はその値をTotalCountプロパティの値として設定します。
        /// </summary>
        /// <param name="query">Queryオブジェクト</param>
        public PartialDataSet(IEnumerable<dynamic> query) : this(query?.Select(x => (IDictionary<string, object>) x))
        {
        }
    }

    /// <summary>
    /// ある検索における、検索データの一部分と全検索件数との組とを管理します。
    /// </summary>
    public class PartialDataSet<T>
    {
        /// <summary>
        /// 総レコード数
        /// </summary>
        public int TotalCount { get; set; }

        /// <summary>
        /// 検索データ
        /// </summary>
        public IEnumerable<T> Data { get; set; }
    }
}
