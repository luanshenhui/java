using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepItemHistoriesモデル
    /// </summary>
    public class RepItemHistories
    {
        /// <summary>
        /// 検査項目履歴コレクション
        /// </summary>
        private Dictionary<string, RepItemHistory> colItemHistories = new Dictionary<string, RepItemHistory>();

        /// <summary>
        /// キー値の節頭子
        /// </summary>
        private const string KEY_PREFIX = "K";

        /// <summary>
        ///  検査項目単位の設定
        /// </summary>
        public RepItemHistory Add(
            int itemHNo,
            DateTime strDate,
            DateTime endDate,
            string unit)
        {
            // 検査項目単位クラス
            RepItemHistory repItemHistory = new RepItemHistory
            {
                // コレクションへの追加
                StrDate = strDate,
                EndDate = endDate,
                Unit = unit
            };

            // コレクションへの追加
            string key = KEY_PREFIX + itemHNo.ToString();
            this.colItemHistories.Add(key, repItemHistory);

            return repItemHistory;
        }

        /// <summary>
        ///  検査項目単位戻る
        /// </summary>
        /// <param name="indexKey">キー値</param>
        /// <returns></returns>
        public RepItemHistory Item(string indexKey)
        {
            if (!this.colItemHistories.ContainsKey(KEY_PREFIX + indexKey))
            {
                return null;
            }
            return this.colItemHistories[KEY_PREFIX + indexKey];
        }

        /// <summary>
        ///  検査項目単位戻る
        /// </summary>
        /// <param name="indexKey">キー値</param>
        /// <returns></returns>
        public RepItemHistory Item(int indexKey)
        {
            try
            {
                string[] keys = colItemHistories.Keys.Cast<string>().ToArray();
                return this.colItemHistories[keys[indexKey]];
            }
            catch
            {
                return null;
            }
        }

        /// <summary>
        ///  検査項目単位戻る
        /// </summary>
        /// <param name="indexKey">キー値(日付)</param>
        /// <returns></returns>
        public RepItemHistory Item(DateTime indexKey)
        {
            string[] keys = colItemHistories.Keys.Cast<string>().ToArray();
            foreach (string key in keys)
            {
                if (indexKey >= colItemHistories[key].StrDate && indexKey <= colItemHistories[key].EndDate)
                {
                    return colItemHistories[key];
                }
            }

            return null;
        }

        /// <summary>
        ///  検査項目単位の削除
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public bool Remove(string indexKey)
        {
            return this.colItemHistories.Remove(indexKey);
        }

        /// <summary>
        ///  検査項目単位の削除        
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public bool Remove(int indexKey)
        {
            string[] keys = colItemHistories.Keys.Cast<string>().ToArray();
            return this.colItemHistories.Remove(keys[indexKey]);
        }

        /// <summary>
        ///  検査項目単位件数
        /// </summary>
        /// <returns></returns>
        public int Count
        {
            get
            {
                return this.colItemHistories.Count;
            }
        }
    }
}