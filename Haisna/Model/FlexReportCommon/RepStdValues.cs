using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepStdValuesモデル
    /// </summary>
    public class RepStdValues
    {
        /// <summary>
        /// 基準値コレクション
        /// </summary>
        private IList<RepStdValue> colStdValues = new List<RepStdValue>();

        /// <summary>
        /// 基準値コレクションの設定
        /// </summary>
        public RepStdValue Add(
            DateTime strDate,
            DateTime endDate,
            string csCd,
            int gender,
            string strAge,
            string endAge,
            string lowerValue,
            string upperValue)
        {
            // 基準値コレクションクラス
            RepStdValue repStdValue = new RepStdValue
            {
                // コレクションへの追加
                StrDate = strDate,
                EndDate = endDate,
                CsCd = csCd,
                Gender = gender,
                StrAge = strAge,
                EndAge = endAge,
                LowerValue = lowerValue,
                UpperValue = upperValue
            };

            // コレクションへの追加
            this.colStdValues.Add(repStdValue);

            return repStdValue;
        }

        /// <summary>
        /// 基準値コレクション戻る
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public RepStdValue Item(int indexKey)
        {
            return this.colStdValues[indexKey];
        }

        /// <summary>
        /// 基準値コレクションの削除        
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public void Remove(int indexKey)
        {
            this.colStdValues.RemoveAt(indexKey);
        }

        /// <summary>
        /// 基準値コレクション件数
        /// </summary>
        /// <returns></returns>
        public int Count
        {
            get
            {
                return this.colStdValues.Count;
            }
        }
    }
}