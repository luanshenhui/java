using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepResultsモデル
    /// </summary>
    public class RepResults
    {
        /// <summary>
        /// 検査結果コレクション
        /// </summary>
        private Dictionary<string, RepResult> colResults = new Dictionary<string, RepResult>();

        /// <summary>
        /// キー値の節頭子
        /// </summary>
        private const string KEY_PREFIX = "K";

        /// <summary>
        /// 検査結果の設定
        /// </summary>
        public RepResult Add(
            string itemCd,
            string suffix,
            string shortStc,
            string longStc,
            string engStc,
            string result,
            string rslCmtCd1,
            string rslCmtName1,
            string rslCmtCd2,
            string rslCmtName2,
            string stdFlg)
        {
            // 検査結果クラス
            RepResult repResult = new RepResult
            {
                // コレクションへの追加
                ItemCd = itemCd,
                Suffix = suffix,
                ShortStc = shortStc,
                LongStc = longStc,
                EngStc = engStc,
                Result = result,
                RslCmtCd1 = rslCmtCd1,
                RslCmtName1 = rslCmtName1,
                RslCmtCd2 = rslCmtCd2,
                RslCmtName2 = rslCmtName2,
                StdFlg = stdFlg
            };

            // コレクションへの追加
            string key = KEY_PREFIX + itemCd + "-" + suffix;
            this.colResults.Add(key, repResult);

            return repResult;
        }

        /// <summary>
        /// 検査結果戻る
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public RepResult Item(string indexKey)
        {
            return this.colResults[indexKey];
        }

        /// <summary>
        /// 検査結果戻る
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public RepResult Item(int indexKey)
        {
            string[] keys = colResults.Keys.Cast<string>().ToArray();
            return this.colResults[keys[indexKey]];
        }

        /// <summary>
        /// 検査結果の削除
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public bool Remove(string indexKey)
        {
            return this.colResults.Remove(indexKey);
        }

        /// <summary>
        /// 検査結果の削除        
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public bool Remove(int indexKey)
        {
            string[] keys = colResults.Keys.Cast<string>().ToArray();
            return this.colResults.Remove(keys[indexKey]);
        }

        /// <summary>
        /// 検査結果件数
        /// </summary>
        /// <returns></returns>
        public int Count
        {
            get
            {
                return this.colResults.Count;
            }
        }
    }
}