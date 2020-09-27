using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepPerResultsモデル
    /// </summary>
    public class RepPerResults
    {
        /// <summary>
        /// 個人検査結果コレクション
        /// </summary>
        private Dictionary<string, RepPerResult> colPerResults = new Dictionary<string, RepPerResult>();

        /// <summary>
        /// キー値の節頭子
        /// </summary>
        private const string KEY_PREFIX = "K";

        /// <summary>
        /// 個人検査結果の設定
        /// </summary>
        public RepPerResult Add(
            string itemCd,
            string suffix,
            string itemRName,
            string itemEName,
            string result,
            string shortStc,
            string longStc,
            string engStc,
            DateTime? ispDate)
        {
            // 検査結果クラス
            RepPerResult repPerResult = new RepPerResult
            {
                // コレクションへの追加
                ItemCd = itemCd,
                Suffix = suffix,
                ItemRName = itemRName,
                ItemEName = itemEName,
                Result = result,
                ShortStc = shortStc,
                LongStc = longStc,
                EngStc = engStc,
                IspDate = ispDate,
            };

            // コレクションへの追加
            string key = KEY_PREFIX + itemCd + "-" + suffix;
            this.colPerResults.Add(key, repPerResult);

            return repPerResult;
        }

        /// <summary>
        /// 個人検査結果戻る
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public RepPerResult Item(string indexKey)
        {
            if (!this.colPerResults.ContainsKey(KEY_PREFIX + indexKey))
            {
                return null;
            }

            return this.colPerResults[KEY_PREFIX + indexKey];
        }

        /// <summary>
        /// 個人検査結果戻る
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public RepPerResult Item(int indexKey)
        {
            try
            {
                string[] keys = colPerResults.Keys.Cast<string>().ToArray();
                return this.colPerResults[keys[indexKey]];
            }
            catch
            {
                return null;
            }
        }

        /// <summary>
        /// 個人検査結果の削除
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public bool Remove(string indexKey)
        {
            string[] keys = colPerResults.Keys.Cast<string>().ToArray();
            return this.colPerResults.Remove(indexKey);
        }

        /// <summary>
        /// 個人検査結果の削除        
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public bool Remove(int indexKey)
        {
            string[] keys = colPerResults.Keys.Cast<string>().ToArray();
            return this.colPerResults.Remove(keys[indexKey]);
        }

        /// <summary>
        /// 個人検査結果件数
        /// </summary>
        public int Count
        {
            get
            {
                return this.colPerResults.Count;
            }
            
        }
    }
}