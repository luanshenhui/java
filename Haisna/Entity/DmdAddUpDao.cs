using Hainsi.Common;
using Hainsi.Common.Constants;
using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.Data;

namespace Hainsi.Entity
{
    /// <summary>
    /// 請求締め処理用データアクセスオブジェクト
    /// </summary>
    public class DmdAddUpDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public DmdAddUpDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 請求締め処理入力値の妥当性チェックを行う
        /// </summary>
        /// <param name="closeYear">締め日(年)</param>
        /// <param name="closeMonth">締め日(月)</param>
        /// <param name="closeDay">締め日(日)</param>
        /// <param name="strYear">開始受診日(年)</param>
        /// <param name="strMonth">開始受診日(月)</param>
        /// <param name="strDay">開始受診日(日)</param>
        /// <param name="endYear">終了受診日(年)</param>
        /// <param name="endMonth">終了受診日(月)</param>
        /// <param name="endDay">終了受診日(日)  </param>
        /// <param name="closeDate">締め日</param>
        /// <param name="strDate">開始受診日</param>
        /// <param name="endDate">終了受診日(日)  </param>
        /// <retruns>
        /// エラー値がある場合、エラーメッセージの配列を返す
        /// </retruns>
        public List<string> CheckValueDmdAddUp
        (
          int closeYear,
          int closeMonth,
          int closeDay,
          int strYear,
          int strMonth,
          int strDay,
          int endYear,
          int endMonth,
          int endDay,
          out DateTime? closeDate,
          out DateTime? strDate,
          out DateTime? endDate
        )
        {
            List<string> errMessage = new List<string>(); // エラーメッセージ
            DateTime? workDate = null;
            string strDateFinish = "";
            string endDateFinish = "";

            // 各値チェック処理
            while (true)
            {

                // 締め日
                if (WebHains.CheckDate("締め日", Convert.ToString(closeYear), Convert.ToString(closeMonth), Convert.ToString(closeDay), out closeDate, Check.Necessary) != null)
                {
                    errMessage.Add(WebHains.CheckDate("締め日", Convert.ToString(closeYear), Convert.ToString(closeMonth), Convert.ToString(closeDay), out closeDate, Check.Necessary));
                }
                // 開始受診日
                if (WebHains.CheckDate("開始受診日", Convert.ToString(strYear), Convert.ToString(strMonth), Convert.ToString(strDay), out strDate, Check.Necessary) != null)
                {
                    errMessage.Add(WebHains.CheckDate("開始受診日", Convert.ToString(strYear), Convert.ToString(strMonth), Convert.ToString(strDay), out strDate, Check.Necessary));
                }
                // 終了受診日
                if (WebHains.CheckDate("終了受診日", Convert.ToString(endYear), Convert.ToString(endMonth), Convert.ToString(endDay), out endDate, Check.Necessary) != null)
                {
                    errMessage.Add(WebHains.CheckDate("終了受診日", Convert.ToString(endYear), Convert.ToString(endMonth), Convert.ToString(endDay), out endDate, Check.Necessary));
                }
                // 開始受診日・終了受診日の大小
                strDateFinish = Convert.ToString(strYear) + "/" + Convert.ToString(strMonth) + "/" + Convert.ToString(strDay);
                endDateFinish = Convert.ToString(endYear) + "/" + Convert.ToString(endMonth) + "/" + Convert.ToString(endDay);
                if (Information.IsDate(strDateFinish) && Information.IsDate(endDateFinish))
                {
                    if (Convert.ToDateTime(endDateFinish).CompareTo(Convert.ToDateTime(strDateFinish)) < 0)
                    {
                        // 大小逆なら入れ替えてあげればいいじゃん
                        workDate = endDate;
                        endDate = strDate;
                        strDate = workDate;
                    }
                }
                break;
            }

            // 戻り値の編集
            return errMessage;
        }
    }
}