using Hainsi.Common;
using System;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepHistoryモデル
    /// </summary>
    public class RepHistory
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        public RepHistory()
        {
            this.Results = new RepResults();
            this.Judgements = new RepJudgements();
        }

        /// <summary>
        /// 予約番号
        /// </summary>
        public int RsvNo { get; set; }
        /// <summary>
        /// 受診年月日
        /// </summary>
        public DateTime CslDate { get; set; }
        /// <summary>
        /// 管理番号
        /// </summary>
        public int CntlNo { get; set; }
        /// <summary>
        /// 当日ID
        /// </summary>
        public int DayId { get; set; }
        /// <summary>
        /// コースコード
        /// </summary>
        public string CsCd { get; set; }
        /// <summary>
        /// コース名
        /// </summary>
        public string CsName { get; set; }
        /// <summary>
        /// 検査結果コレクション
        /// </summary>
        public RepResults Results { get; }
        /// <summary>
        /// 判定情報コレクション
        /// </summary>
        public RepJudgements Judgements { get; }

        /// <summary>
        /// 年
        /// </summary>
        public int CslYearAd
        {
            get
            {
                return CslDate.Year;
            }
        }

        /// <summary>
        /// 受診年月日和暦年
        /// </summary>
        public int CslYearJp
        {
            get
            {
                return WebHains.JapaneseCalendar.GetYear(CslDate);
            }
        }

        /// <summary>
        /// 受診年月日和暦元号
        /// </summary>
        public string CslYearGe
        {
            get
            {
                return WebHains.GetShortEraName(CslDate);
            }
        }

        /// <summary>
        /// 受診月
        /// </summary>
        public int CslMonth
        {
            get
            {
                return CslDate.Month;
            }
        }

        /// <summary>
        /// 受診日
        /// </summary>
        public int CslDay
        {
            get
            {
                return CslDate.Day;
            }
        }

    }
}