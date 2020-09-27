using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepResultsモデル
    /// </summary>
    public class RepDisHistories
    {
        /// <summary>
        /// 既往歴家族歴コレクション
        /// </summary>
        private IList<RepDisHistory> colDisHistories = new List<RepDisHistory>();

        /// <summary>
        /// 既往歴家族歴の設定
        /// </summary>
        public RepDisHistory Add(
            int relation,
            string disCd,
            string disName,
            DateTime strDate,
            DateTime endDate,
            string condition,
            string medical)
        {
            //既往歴家族歴クラス
            RepDisHistory repDisHistory = new RepDisHistory
            {
                // コレクションへの追加
                Relation = relation,
                DisCd = disCd,
                DisName = disName,
                StrDate = strDate,
                EndDate = endDate,
                Condition = condition,
                Medical = medical,
            };

            // コレクションへの追加
            this.colDisHistories.Add(repDisHistory);

            return repDisHistory;
        }

        /// <summary>
        /// 既往歴家族歴戻る
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public RepDisHistory Item(int indexKey)
        {
            return this.colDisHistories[indexKey];
        }

        /// <summary>
        /// 既往歴家族歴の削除        
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public void Remove(int indexKey)
        {
            this.colDisHistories.RemoveAt(indexKey);
        }

        /// <summary>
        /// 既往歴家族歴件数
        /// </summary>
        /// <returns></returns>
        public int Count
        {
            get
            {
                return this.colDisHistories.Count;
            }
        }
    }
}