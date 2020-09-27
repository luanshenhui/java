using System.Linq;
using System.Collections.Generic;
using System;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepHistoriesモデル
    /// </summary>
    public class RepHistories
    {
        /// <summary>
        /// 受診履歴コレクション
        /// </summary>
        private Dictionary<string, RepHistory> colHistories = new Dictionary<string, RepHistory>();

        /// <summary>
        /// キー値の節頭子
        /// </summary>
        private const string KEY_PREFIX = "K";

        /// <summary>
        /// 受診履歴設定
        /// </summary>
        public RepHistory Add(
                int rsvNo,
                DateTime cslDate,
                int cntlNo,
                int dayId,
                string csCd,
                string csName)
        {
            // 受診履歴クラス
            RepHistory repHistory = new RepHistory
            {
                RsvNo = rsvNo,
                CslDate = cslDate,
                CntlNo = cntlNo,
                DayId = dayId,
                CsCd = csCd,
                CsName = csName
            };

            // コレクションへの追加
            string key = KEY_PREFIX + rsvNo.ToString();
            this.colHistories.Add(key, repHistory);

            return repHistory;
        }

        /// <summary>
        /// 受診履歴戻る
        /// </summary>
        /// <param name="indexKey">キー値</param>
        /// <returns></returns>
        public RepHistory Item(string indexKey)
        {
            if (!this.colHistories.ContainsKey(KEY_PREFIX + indexKey))
            {
                return null;
            }
            return this.colHistories[KEY_PREFIX + indexKey];
        }

        /// <summary>
        /// 受診履歴戻る
        /// </summary>
        /// <param name="indexKey">キー値</param>
        /// <returns></returns>
        public RepHistory Item(int indexKey)
        {
            try
            {
                string[] keys = colHistories.Keys.Cast<string>().ToArray();
                return this.colHistories[keys[indexKey]];
            }
            catch
            {
                return null;
            }
        }

        /// <summary>
        /// 受診履歴の削除
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public bool Remove(string indexKey)
        {
            return this.colHistories.Remove(indexKey);
        }

        /// <summary>
        /// 受診履歴の削除        
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public bool Remove(int indexKey)
        {
            string[] keys = colHistories.Keys.Cast<string>().ToArray();
            return this.colHistories.Remove(keys[indexKey]);
        }

        /// <summary>
        /// 受診履歴件数
        /// </summary>
        /// <returns></returns>
        public int Count
        {
            get
            {
                return this.colHistories.Count;
            }
        }
    }
}