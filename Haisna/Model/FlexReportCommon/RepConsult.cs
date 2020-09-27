using Hainsi.Common;
using System;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepConsultモデル
    /// </summary>
    public class RepConsult
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        public RepConsult()
        {
            this.Histories = new RepHistories();
            this.Results = new RepResults();
            this.Judgements = new RepJudgements();
            this.PerResults = new RepPerResults();
            this.DisHistories = new RepDisHistories();
            this.FmlHistories = new RepDisHistories();
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
        public string CntlNo { get; set; }
        /// <summary>
        /// 当日ID
        /// </summary>
        public string DayId { get; set; }
        /// <summary>
        /// 個人ID
        /// </summary>
        public string PerId { get; set; }
        /// <summary>
        /// 姓
        /// </summary>
        public string LastName { get; set; }
        /// <summary>
        /// 名
        /// </summary>
        public string FirstName { get; set; }
        /// <summary>
        /// カナ姓
        /// </summary>
        public string LastKName { get; set; }
        /// <summary>
        /// カナ名
        /// </summary>
        public string FirstKName { get; set; }
        /// <summary>
        /// ローマ字名
        /// </summary>
        public string RomeName { get; set; }
        /// <summary>
        /// 生年月日
        /// </summary>
        public DateTime Birth { get; set; }
        /// <summary>
        /// 性別
        /// </summary>
        public int Gender { get; set; }
        /// <summary>
        /// 都道府県名
        /// </summary>
        public string PrefName { get; set; }
        /// <summary>
        /// 郵便番号１
        /// </summary>
        public string ZipCd1 { get; set; }
        /// <summary>
        /// 郵便番号２
        /// </summary>
        public string ZipCd2 { get; set; }
        /// <summary>
        /// 市区町村名
        /// </summary>
        public string CityName { get; set; }
        /// <summary>
        /// 住所１
        /// </summary>
        public string Address1 { get; set; }
        /// <summary>
        /// 住所２
        /// </summary>
        public string Address2 { get; set; }
        /// <summary>
        /// 保険者番号
        /// </summary>
        public string IsrNo { get; set; }
        /// <summary>
        /// 健保記号（記号）
        /// </summary>
        public string IsrSign { get; set; }
        /// <summary>
        /// 健保記号（符号）
        /// </summary>
        public string IsrMark { get; set; }
        /// <summary>
        /// 健保番号
        /// </summary>
        public string HeIsrNo { get; set; }
        /// <summary>
        /// 保険区分
        /// </summary>
        public string IsrDiv { get; set; }
        /// <summary>
        /// 住民番号
        /// </summary>
        public string ResidentNo { get; set; }
        /// <summary>
        /// 組合番号
        /// </summary>
        public string UnionNo { get; set; }
        /// <summary>
        /// カルテ番号
        /// </summary>
        public string Karte { get; set; }
        /// <summary>
        /// 従業員番号
        /// </summary>
        public string EmpNo { get; set; }
        /// <summary>
        /// コースコード
        /// </summary>
        public string CsCd { get; set; }
        /// <summary>
        /// コース名
        /// </summary>
        public string CsName { get; set; }
        /// <summary>
        /// 団体コード１
        /// </summary>
        public string OrgCd1 { get; set; }
        /// <summary>
        /// 団体コード２
        /// </summary>
        public string OrgCd2 { get; set; }
        /// <summary>
        /// 団体カナ名称
        /// </summary>
        public string OrgKName { get; set; }
        /// <summary>
        /// 団体漢字名称
        /// </summary>
        public string OrgName { get; set; }
        /// <summary>
        /// 団体略称
        /// </summary>
        public string OrgSName { get; set; }
        /// <summary>
        /// 時間枠
        /// </summary>
        public string TimeFra { get; set; }
        /// <summary>
        /// 予約日
        /// </summary>
        public DateTime RsvDate { get; set; }
        /// <summary>
        /// 受診時年齢（年齢）
        /// </summary>
        public int Age { get; set; }
        /// <summary>
        /// 受診時年齢（月齢）
        /// </summary>
        public int AgeMonth { get; set; }
        /// <summary>
        /// 判定医コード
        /// </summary>
        public string DoctorCd { get; set; }
        /// <summary>
        /// 判定医
        /// </summary>
        public string DoctorName { get; set; }
        /// <summary>
        /// フリー区分
        /// </summary>
        public string FreeDiv { get; set; }
        /// <summary>
        /// 成績書出力日
        /// </summary>
        public DateTime? ReportPrintDate { get; set; }
        /// <summary>
        /// 成績書版数
        /// </summary>
        public int ReportVersion { get; set; }
        /// <summary>
        /// 承認番号
        /// </summary>
        public string RecogNo { get; set; }
        /// <summary>
        /// 政府管掌受付番号
        /// </summary>
        public string GovNo { get; set; }
        /// <summary>
        /// １次健診の予約番号
        /// </summary>
        public int FirstRsvNo { get; set; }
        /// <summary>
        /// 政府管掌フラグ
        /// </summary>
        public string GovMng { get; set; }
        /// <summary>
        /// 政府管掌一次二次区分
        /// </summary>
        public string GovMng12Div { get; set; }
        /// <summary>
        /// 政府管掌健診区分
        /// </summary>
        public string GovMngDiv { get; set; }
        /// <summary>
        /// 政府管掌社保区分
        /// </summary>
        public string GovMngShaho { get; set; }
        /// <summary>
        /// 受診回数
        /// </summary>
        public int CslCount { get; set; }
        /// <summary>
        /// 仮IDフラグ
        /// </summary>
        public int VidFlg { get; set; }
        /// <summary>
        /// 事業部コード
        /// </summary>
        public string OrgBsdCd { get; set; }
        /// <summary>
        /// 事業部カナ名称
        /// </summary>
        public string OrgBsdKName { get; set; }
        /// <summary>
        /// 事業部名称
        /// </summary>
        public string OrgBsdName { get; set; }
        /// <summary>
        /// 室部コード
        /// </summary>
        public string OrgRoomCd { get; set; }
        /// <summary>
        /// 室部カナ名称
        /// </summary>
        public string OrgRoomKName { get; set; }
        /// <summary>
        /// 室部名称
        /// </summary>
        public string OrgRoomName { get; set; }
        /// <summary>
        /// 所属コード
        /// </summary>
        public string OrgPostCd { get; set; }
        /// <summary>
        /// 所属カナ名称
        /// </summary>
        public string OrgPostKName { get; set; }
        /// <summary>
        /// 所属名称
        /// </summary>
        public string OrgPostName { get; set; }
        /// <summary>
        /// 職名コード
        /// </summary>
        public string JobCd { get; set; }
        /// <summary>
        /// 職名
        /// </summary>
        public string JobName { get; set; }
        /// <summary>
        /// 職責コード
        /// </summary>
        public string DutyCd { get; set; }
        /// <summary>
        /// 職責
        /// </summary>
        public string DutyName { get; set; }
        /// <summary>
        /// 資格コード
        /// </summary>
        public string QualifyCd { get; set; }
        /// <summary>
        /// 資格
        /// </summary>
        public string QualifyName { get; set; }
        /// <summary>
        /// 本現区分
        /// </summary>
        public string HongenDiv { get; set; }
        /// <summary>
        /// 深夜業従事
        /// </summary>
        public string NightDutyFlg { get; set; }
        /// <summary>
        /// 入社日
        /// </summary>
        public string HireDate { get; set; }
        /// <summary>
        /// 受診履歴コレクション
        /// </summary>
        public RepHistories Histories { get; }
        /// <summary>
        /// 検査結果コレクション
        /// </summary>
        public RepResults Results { get; }
        /// <summary>
        /// 判定結果コレクション
        /// </summary>
        public RepJudgements Judgements { get; }
        /// <summary>
        /// 個人検査結果コレクション
        /// </summary>
        public RepPerResults PerResults { get; }
        /// <summary>
        /// 既往歴コレクション
        /// </summary>
        public RepDisHistories DisHistories { get; }
        /// <summary>
        /// 家族歴コレクション
        /// </summary>
        public RepDisHistories FmlHistories { get; }

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

        /// <summary>
        /// 生年月日の年
        /// </summary>
        public int BirthYearAd
        {
            get
            {
                return Birth.Year;
            }
        }

        /// <summary>
        /// 生年月日の和暦年
        /// </summary>
        public int BirthYearJp
        {
            get
            {
                return WebHains.JapaneseCalendar.GetYear(Birth);
            }
        }

        /// <summary>
        /// 生年月日の和暦元号
        /// </summary>
        public string BirthYearGe
        {
            get
            {
                return WebHains.GetShortEraName(Birth);
            }
        }

        /// <summary>
        /// 生年月日の月
        /// </summary>
        public int BirthMonth
        {
            get
            {
                return Birth.Month;
            }
        }

        /// <summary>
        /// 生年月日の日
        /// </summary>
        public int BirthDay
        {
            get
            {
                return Birth.Day;
            }
        }

        /// <summary>
        /// 姓名
        /// </summary>
        public string Name
        {
            get
            {
                return (LastName + "　" + FirstName).Trim();
            }
        }

        /// <summary>
        /// カナ姓名
        /// </summary>
        public string KName
        {
            get
            {
                return (LastKName + "　" + FirstKName).Trim();
            }
        }


    }
}