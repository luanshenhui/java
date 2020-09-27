using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepItemsモデル
    /// </summary>
    public class RepItems
    {
        /// <summary>
        /// 検査項目コレクション
        /// </summary>
        private Dictionary<string, RepItem> colItems = new Dictionary<string, RepItem>();

        /// <summary>
        /// キー値の節頭子
        /// </summary>
        private const string KEY_PREFIX = "K";

        /// <summary>
        /// 検査結果の設定
        /// </summary>
        public RepItem Add(
            string itemCd,
            string suffix,
            int resultType,
            string itemRName,
            string itemEName,
            string itemQName,
            int noPrintFlg)
        {
            // 検査結果クラス
            RepItem repItem = new RepItem
            {
                // コレクションへの追加
                ItemCd = itemCd,
                Suffix = suffix,
                ResultType = resultType,
                ItemRName = itemRName,
                ItemEName = itemEName,
                ItemQName = itemQName,
                NoPrintFlg = noPrintFlg
            };

            // コレクションへの追加
            string key = KEY_PREFIX + itemCd + "-" + suffix;
            this.colItems.Add(key, repItem);

            return repItem;
        }

        /// <summary>
        /// 検査結果戻る
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public RepItem Item(string indexKey)
        {
            if (!this.colItems.ContainsKey(KEY_PREFIX + indexKey))
            {
                return null;
            }
            return this.colItems[KEY_PREFIX + indexKey];
        }

        /// <summary>
        /// 検査結果戻る
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public RepItem Item(int indexKey)
        {
            try
            {
                string[] keys = colItems.Keys.Cast<string>().ToArray();
                return this.colItems[keys[indexKey]];
            }
            catch
            {
                return null;
            }

        }

        /// <summary>
        /// 検査結果の削除
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public bool Remove(string indexKey)
        {
            return this.colItems.Remove(indexKey);
        }

        /// <summary>
        /// 検査結果の削除        
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public bool Remove(int indexKey)
        {
            string[] keys = colItems.Keys.Cast<string>().ToArray();
            return this.colItems.Remove(keys[indexKey]);
        }

        /// <summary>
        /// 検査結果件数
        /// </summary>
        public int Count
        {
            get
            {
                return this.colItems.Count;
            }            
        }
    }
}