using Dapper;
using Entity.Helper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Microsoft.VisualBasic;
using Newtonsoft.Json.Linq;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Hainsi.Entity.Model.Schedule;

namespace Hainsi.Entity
{
    /// <summary>
    /// スケジュール情報データアクセスオブジェクト
    /// </summary>
    public class ScheduleDao : AbstractDao
    {
        /// <summary>
        /// 汎用情報アクセス
        /// </summary>
        readonly FreeDao freeDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        /// <param name="freeDao">汎用情報データアクセスオブジェクト</param>
        public ScheduleDao(IDbConnection connection, FreeDao freeDao) : base(connection)
        {
            this.freeDao = freeDao;
        }

        /// <summary>
        /// 予約枠を削除する際の、予約の存在チェックを行う
        /// </summary>
        /// <param name="date">チェック対象日付</param>
        /// <param name="timeFra">時間枠</param>
        /// <param name="rsvFraCd">予約枠コード</param>
        /// <param name="fraType">枠管理タイプ</param>
        /// <returns>予約が存在する場合、メッセージを返す</returns>
        private string CheckDeleteSchedule(string date, long timeFra, string rsvFraCd, long fraType)
        {
            string sql = "";    // SQLステートメント
            long count1;        // カウント
            long count2;        // カウント
            string ret;         // 戻り値
            string day;         // 日

            // 初期処理
            ret = "";
            count1 = 0;
            count2 = 0;
            day = Convert.ToString(Convert.ToDateTime(date.Trim()).Day);

            // 条件が設定されていない場合はエラー
            if (!Information.IsDate(date.Trim()))
            {
                throw new ArgumentException();
            }
            if (string.IsNullOrEmpty(rsvFraCd) || rsvFraCd.Trim().Equals(""))
            {
                throw new ArgumentException();
            }
            if (fraType != Convert.ToInt16(FraType.Cs) && fraType != Convert.ToInt16(FraType.Item))
            {
                throw new ArgumentException();
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", date.Trim());
            param.Add("timefra", timeFra);
            param.Add("rsvfracd", rsvFraCd.Trim());
            param.Add("used", ConsultCancel.Used);

            if (fraType == Convert.ToInt16(FraType.Cs))
            {
                // コース枠管理の場合

                // 検索条件を満たす受診情報のレコード件数を取得
                sql = @"
                        select
                          count(*) reccount
                        from
                          consult csl
                          , rsvfra_c rfc
                        where
                          csl.csldate = :csldate
                          and csl.timefra = :timefra
                          and csl.cancelflg = :used
                          and csl.cscd = rfc.cscd
                          and rfc.rsvfracd = :rsvfracd
                ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 検索レコードが存在する場合
                if (current != null)
                {
                    // レコード件数の取得
                    count1 = long.Parse(current.RECCOUNT);
                }

                // 検索条件を満たす団体予約人数のレコード件数を取得
                sql = @"
                        select
                          count(*) reccount
                        from
                          orgrsv ors
                          , rsvfra_c rfc
                        where
                          ors.csldate = :csldate
                          and ors.timefra = :timefra
                          and ors.cscd = rfc.cscd
                          and rfc.rsvfracd = :rsvfracd
                ";

                current = connection.Query(sql, param).FirstOrDefault();

                // 検索レコードが存在する場合
                if (current != null)
                {
                    // レコード件数の取得
                    count2 = long.Parse(current.RECCOUNT);
                }
            }
            else
            {
                // 検査項目枠管理の場合

                // 検索条件を満たす予約スケジュールの予約済み人数を取得
                // （検査項目枠管理の場合、時間枠は終日固定なので、実際は１レコードしかない）
                sql = @"
                        select
                          nvl(sum(rsvcount), 0) rsvcount
                        from
                          schedule
                        where
                          csldate = :csldate
                          and rsvfracd = :rsvfracd
                ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 検索レコードが存在する場合
                // (SUM関数を発行しているので必ず1レコード返ってくる)
                if (current != null)
                {
                    // 予約済み人数の取得
                    count1 = long.Parse(current.RSVCOUNT);
                }

                // 検索条件を満たす団体予約検査項目枠の予約済み人数を取得
                sql = @"
                        select
                          nvl(sum(rsvcount), 0) rsvcount
                        from
                          orgrsv_ifra
                        where
                          csldate = :csldate
                          and rsvfracd = :rsvfracd
                ";

                current = connection.Query(sql, param).FirstOrDefault();

                // 検索レコードが存在する場合
                // (SUM関数を発行しているので必ず1レコード返ってくる)
                if (current != null)
                {
                    // 予約済み人数の取得
                    count2 = long.Parse(current.RSVCOUNT);
                }
            }

            // 予約が存在する場合、メッセージを戻り値として設定
            if (count2 > 0)
            {
                ret = day + "日に団体予約が登録されている為、削除できません。";
            }
            else if (count1 > 0)
            {
                ret = day + "日に予約が登録されている為、削除できません。";
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 休日・祝日に対する予約の存在チェックを行う
        /// </summary>
        /// <param name="date">チェック対象日付</param>
        /// <returns>予約が存在する場合、メッセージを返す</returns>
        private dynamic CheckHolidayReserve(string date)
        {
            string sql = "";    // SQLステートメント
            long count1;        // カウント
            long count2;        // カウント
            string ret = "";    // 戻り値
            string day = "";    // 日

            // 初期処理
            count1 = 0;
            count2 = 0;

            // 条件が設定されていない場合はエラー
            if (string.IsNullOrEmpty(date) || date.Trim().Equals(""))
            {
                throw new ArgumentException();
            }
            day = Convert.ToString(Convert.ToDateTime(date.Trim()).Day);

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("date1", date.Trim());
            param.Add("used", ConsultCancel.Used);


            // 検索条件を満たす予約スケジュールのレコード件数を取得
            sql = @"
                    select
                      count(*) reccount
                    from
                      schedule
                    where
                      csldate = :date1
            ";

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // 検索レコードが存在する場合
            // (COUNT関数を発行しているので必ず1レコード返ってくる)
            if (current != null)
            {
                // レコード件数の取得
                count1 = long.Parse(Convert.ToString(current.RECCOUNT));
            }

            // 検索条件を満たす受診情報のレコード件数を取得
            sql = @"
                    select
                      count(*) reccount
                    from
                      consult
                    where
                      csldate = :date1
                      and cancelflg = :used
            ";

            current = connection.Query(sql, param).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current != null)
            {
                // レコード件数の取得
                count2 = long.Parse(Convert.ToString(current.RECCOUNT));
            }

            // 予約が存在する場合、メッセージを戻り値として設定
            if (count1 > 0 && count2 > 0)
            {
                ret = day + "日に予約枠が設定され、予約が登録されています。";
            }
            else if (count1 > 0 && count2 <= 0)
            {
                ret = day + "日に予約枠が設定されています。";
            }
            else if (count1 <= 0 && count2 > 0)
            {
                ret = day + "日に予約が登録されています。";
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 団体予約検査項目枠が必要か否か、チェックを行う
        /// </summary>
        /// <param name="date">チェック対象日付</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="rsvFraCd">予約枠コード</param>
        /// <returns>
        /// True   団体予約検査項目枠が必要;
        /// False  団体予約検査項目枠は不要
        /// </returns>
        private bool CheckOrgRsv_iFra(string date, string csCd, string orgCd1, string orgCd2, string rsvFraCd)
        {
            string sql = "";    // SQLステートメント
            bool ret;           // 戻り値

            // 初期処理
            ret = false;

            // 条件が設定されていない場合はエラー
            if (!Information.IsDate(date.Trim()))
            {
                throw new ArgumentException();
            }
            if (string.IsNullOrEmpty(csCd) || csCd.Trim().Equals(""))
            {
                throw new ArgumentException();
            }
            if (string.IsNullOrEmpty(orgCd1) || orgCd1.Trim().Equals(""))
            {
                throw new ArgumentException();
            }
            if (string.IsNullOrEmpty(orgCd2) || orgCd2.Trim().Equals(""))
            {
                throw new ArgumentException();
            }
            if (string.IsNullOrEmpty(rsvFraCd) || rsvFraCd.Trim().Equals(""))
            {
                throw new ArgumentException();
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate2", date.Trim());
            param.Add("cscd2", csCd.Trim());
            param.Add("orgcd12", orgCd1.Trim());
            param.Add("orgcd22", orgCd2.Trim());
            param.Add("rsvfracd2", rsvFraCd.Trim());

            // 検索条件を満たす団体検査項目リストビューのレコードを取得
            sql = @"
                    select distinct
                      lst.itemcd
                    from
                      orgconsultitemlist lst
                      , rsvfra_i rfi
                    where
                      to_date(:csldate2) between lst.strdate and lst.enddate
                      and lst.cscd = :cscd2
                      and lst.orgcd1 = :orgcd12
                      and lst.orgcd2 = :orgcd22
                      and lst.itemcd = rfi.itemcd
                      and rfi.rsvfracd = :rsvfracd2
                ";

            List<dynamic> current = connection.Query(sql, param).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current.Count > 0)
            {
                // 戻り値の設定
                ret = false;
            }
            return ret;
        }

        /// <summary>
        /// カレンダー表示時の入力チェック
        /// </summary>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="year">受診希望日（年）</param>
        /// <param name="month">受診希望日（月）</param>
        /// <param name="day">受診希望日（日）</param>
        /// <param name="date">表示終了日付</param>
        /// <returns>エラーメッセージの配列を返す</returns>
        public List<dynamic> CheckValueCalendar(string orgCd1, string orgCd2, string csCd, string perId, string year, string month, string day, ref dynamic date)
        {
            List<dynamic> messages = new List<dynamic>();       // エラーメッセージの集合

            // 必須入力チェック

            // 団体コード
            if (string.IsNullOrEmpty(orgCd1) || string.IsNullOrEmpty(orgCd2))
            {
                messages.Add("団体が入力されていません。");
            }

            // コースコード
            if (string.IsNullOrEmpty(csCd))
            {
                messages.Add("コースが入力されていません。");
            }

            // 個人ID
            if (string.IsNullOrEmpty(perId))
            {
                messages.Add("個人ＩＤが入力されていません。");
            }

            // 受診希望日
            string message = WebHains.CheckDate("受診希望日", year, month, day, date);
            if (string.IsNullOrEmpty(message))
            {
                messages.Add(message);
            }

            // 受診希望日は過去日付エラー
            if (!string.IsNullOrEmpty(date))
            {
                DateTime now = DateTime.Now.Date;
                DateTime ymd = DateTime.Parse(year + "-" + month + "-" + day);
                if (DateTime.Compare(ymd, now) < 0)
                {
                    messages.Add("受診希望日は過去日付エラーです。");
                }
            }

            // 戻り値の設定
            return messages;
        }

        /// <summary>
        /// 予約スケジューリング入力値の妥当性チェックを行う
        /// </summary>
        /// <param name="strDate">月始日付</param>
        /// <param name="endDate">月末日付</param>
        /// <param name="timeFra">時間枠</param>
        /// <param name="rsvFraCd">予約枠コード</param>
        /// <param name="arrEmptyCount">月始日付～月末日付の設定値（"hidden":非表示，"":未設定，"0":予約不可，"1"～"999":予約可能）</param>
        /// <returns>エラーメッセージの配列を返す</returns>
        public List<dynamic> CheckValueSchedule(string strDate, string endDate, long timeFra, string rsvFraCd, List<string> arrEmptyCount)
        {
            List<dynamic> messages = new List<dynamic>();       // エラーメッセージの集合
            bool ret;
            long count;
            string checkType = "";                              // 予約済み人数（"":レコードなし，"0"～"999":設定値）
            string clsDate = "";                                // 予約スケジューリング情報（受診日）
            List<long> localTimeFra = new List<long>();         // 予約スケジューリング情報（時間枠）
            List<dynamic> localRsvCount = new List<dynamic>();  // 予約スケジューリング情報（予約済み人数）
            long rsvCnt;                                        // 予約済み人数（カウント値）
            string message = "";                                // エラーメッセージ
            string editDate = "";                               // 日付編集用

            // 各値チェック処理

            // 月始日付
            if (!Information.IsDate(strDate.Trim()))
            {
                messages.Add("月始日付が不正です。");
            }

            // 月末日付
            if (!Information.IsDate(endDate.Trim()))
            {
                messages.Add("月末日付が不正です。");
            }

            // 設定値の配列
            if (!Information.IsDate(endDate.Trim()))
            {
                messages.Add("設定値の配列が不正です。");
            }

            // 月始／月末日付と設定値の配列の妥当性
            DateTime strDateTmp = new DateTime();
            if (!Information.IsDate(strDate.Trim()) && (!Information.IsDate(endDate.Trim())) && (arrEmptyCount != null))
            {
                strDateTmp = DateTime.Parse(strDate.Trim());
                DateTime endDateTmp = DateTime.Parse(endDate.Trim());
                TimeSpan span = endDateTmp - strDateTmp;
                if (span.Days != arrEmptyCount.Count)
                {
                    messages.Add("月始／月末日付に対する設定値の配列の数が矛盾しています。");
                }
            }

            // 指定予約枠コードの予約枠情報を取得
            ret = SelectRsvFra(rsvFraCd.Trim());
            if (ret != true)
            {
                messages.Add("予約枠コードが不正です。");
            }

            // エラーがある時、以降のチェックは不要
            if (messages.Count > 0)
            {
                return messages;
            }

            // 各値チェック処理

            // 指定期間の該当予約枠コードの予約スケジューリング情報を取得（時間枠の指定はせず、すべての時間枠を抽出）
            count = SelectSchedule(strDate.Trim(), endDate.Trim(), "", rsvFraCd.Trim());

            // チェック対象日付
            strDateTmp = DateTime.Parse(strDate.Trim());

            // １日ごとにチェック
            int j = 0;
            for (int i = 0; i < arrEmptyCount.Count; i++)
            {
                // その日の予約スケジューリングの設定を把握する
                rsvCnt = 0;
                checkType = "";
                if (j < count)
                {
                    while (DateTime.Parse(clsDate) == DateTime.Parse(strDateTmp.Year + "/" + strDateTmp.Month + "/" + (i + 1).ToString()))
                    {
                        // 該当時間枠の予約済み人数設定値
                        if (localTimeFra[j] == timeFra)
                        {

                            rsvCnt = localRsvCount[j];
                        }

                        // 時間枠管理されているか否かの判定

                        if (localTimeFra[j].Equals(Convert.ToInt16(TimeFra.Non)))
                        {

                            checkType = "0";
                        }
                        else
                        {
                            checkType = "1";
                        }

                        j = j + 1;
                        if (j >= count)
                        {
                            break;
                        }
                    }
                }

                // 終日の入力時、時間枠管理されている場合、非表示以外はエラー
                if ((timeFra.Equals(Convert.ToInt16(TimeFra.Non)) && checkType.Equals("1")) && (arrEmptyCount[i].Trim().Equals("hidden")))
                {
                    messages.Add(Convert.ToString(i + 1) + "日に時間枠管理の予約枠がすでに設定されています。終日管理できません。もう一度やり直して下さい。");
                }

                // 指定時間枠の入力時、終日管理されている場合、非表示以外はエラー
                if ((timeFra != Convert.ToInt16(TimeFra.Non) && checkType.Equals("0")) && (!arrEmptyCount[i].Trim().Equals("hidden")))
                {
                    messages.Add(Convert.ToString(i + 1) + "日に終日管理の予約枠がすでに設定されています。時間枠管理できません。もう一度やり直して下さい。");
                }

                // 非表示，未設定でない時、数値（０～９９９）以外エラー
                if (((!string.IsNullOrEmpty(arrEmptyCount[i])) && !arrEmptyCount[i].Trim().Equals("") && !arrEmptyCount[i].Trim().Equals("hidden")))
                {
                    message = WebHains.CheckNumeric((Convert.ToString(i + 1) + "日"), arrEmptyCount[i].Trim(), Convert.ToInt16(LengthConstants.LENGTH_SCHEDULE_EMPTYCOUNT));
                    if (!string.IsNullOrEmpty(message))
                    {
                        messages.Add(message);
                    }
                }

                // 保存時のチェック（数値チェックＯＫの時のみ）
                if ((!string.IsNullOrEmpty(arrEmptyCount[i]) && !arrEmptyCount[i].Trim().Equals("hidden")) && string.IsNullOrEmpty(message)) { }
                {
                    // 該当日に予約枠データが一切なく、終日以外の時間枠を登録する際、すでに予約が登録されていればエラー
                    // （予約枠データが一切ない時点で登録された予約は、時間枠が終日で登録されている）
                    if (string.IsNullOrEmpty(checkType) && !timeFra.Equals(Convert.ToInt16(TimeFra.Non)) &&
                        (!string.IsNullOrEmpty(CheckDeleteSchedule(editDate, Convert.ToInt16(TimeFra.Non), rsvFraCd.Trim(), Convert.ToInt16(FraType.Cs)))))
                    {
                        messages.Add(Convert.ToString(i + 1) + "日に終日管理の予約がすでに登録されています。時間枠管理では設定できません。");
                    }
                }

                editDate = DateTime.Parse(editDate).AddDays(1).ToString("yyyy/M/d");

            }

            // 戻り値の設定
            return messages;
        }

        /// <summary>
        /// 病院スケジューリング入力値の妥当性チェックを行う
        /// </summary>
        /// <param name="strDate">月始日付</param>
        /// <param name="endDate">月末日付</param>
        /// <param name="arrHoliday">月始日付～月末日付の設定値（0:未設定，1:休診日，2:祝日）</param>
        /// <param name="warnings"></param>
        /// <returns>エラーメッセージの配列を返す</returns>
        public List<dynamic> CheckValueSchedule_h(string strDate, string endDate, IList<int> arrHoliday, ref List<dynamic> warnings)
        {
            List<dynamic> messages = new List<dynamic>();  // エラーメッセージの集合
            List<dynamic> messages2 = new List<dynamic>(); // 警告メッセージの集合
            string holidayFlg = "";                        // 休日・祝日に対する予約の許可
            string editDate = "";                          // 日付編集用

            // 各値チェック処理

            // 月始日付
            if (!Information.IsDate(strDate.Trim()))
            {
                messages.Add("月始日付が不正です。");
            }

            // 月末日付
            if (!Information.IsDate(endDate.Trim()))
            {
                messages.Add("月末日付が不正です。");
            }

            // 設定値の配列
            if (arrHoliday == null)
            {
                messages.Add("設定値の配列が不正です。");
            }

            // 月始／月末日付と設定値の配列の妥当性
            if ((Information.IsDate(strDate.Trim())) && (Information.IsDate(endDate.Trim())) && (arrHoliday != null))
            {
                DateTime strDateTmp = new DateTime();
                strDateTmp = DateTime.Parse(strDate.Trim());
                DateTime endDateTmp = DateTime.Parse(endDate.Trim());
                TimeSpan span = endDateTmp - strDateTmp;
                if (span.Days + 1 != arrHoliday.Count)
                {
                    messages.Add("月始／月末日付に対する設定値の配列の数が矛盾しています。");
                }
            }

            // エラーがある時、以降のチェックは不要
            if (messages.Count > 0)
            {
                return messages;
            }

            // 各値チェック処理

            // 汎用テーブルから（休日・祝日に対する予約の許可）を読み込む
            List<dynamic> freeList = freeDao.SelectFree(0, "RSVHOLIDAY");
            if (freeList != null)
            {
                holidayFlg = freeList[0].FREEFIELD1;
            }

            // チェック対象日付
            editDate = strDate.Trim();

            // １日ごとにチェック
            for (int i = 0; i < arrHoliday.Count; i++)
            {
                // ＶＡＬＵＥチェック（０，１，２以外エラー）
                if (arrHoliday[i] != Convert.ToInt16(Holiday.Non) &&
                    arrHoliday[i] != Convert.ToInt16(Holiday.Cls) &&
                    arrHoliday[i] != Convert.ToInt16(Holiday.Hol))
                {
                    messages.Add(Convert.ToString(i + 1) + "日の設定値が不正です。");
                }

                // 休日・祝日に対する予約チェック
                if (arrHoliday[i] == Convert.ToInt16(Holiday.Cls) ||
                    arrHoliday[i] == Convert.ToInt16(Holiday.Hol))
                {
                    if (holidayFlg.Equals(Convert.ToString(HolidayFlg.Deny)))
                    {
                        // 休日・祝日に対する予約を許さない設定の場合
                        if (CheckHolidayReserve(editDate) != "")
                        {
                            messages.Add(CheckHolidayReserve(editDate));
                        }
                    }
                    else
                    {
                        // 休日・祝日に対する予約を許す設定の場合
                        if (CheckHolidayReserve(editDate) != "")
                        {
                            messages2.Add(CheckHolidayReserve(editDate));
                        }

                    }
                }

                // チェック対象日付を１日進める
                editDate = DateTime.Parse(editDate).AddDays(1).ToString("yyyy/M/d");
            }

            // 警告メッセージの編集
            if (messages2.Count > 0)
            {
                warnings = messages2;
            }

            // 戻り値の設定
            return messages;
        }

        /// <summary>
        /// き状況の入力チェック（Step1～Step2）
        /// </summary>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="gender">性別</param>
        /// <param name="birthYear">生年月日（年）</param>
        /// <param name="birthMonth">生年月日（月）</param>
        /// <param name="birthDay">生年月日（日）</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="year">受診希望日（年）</param>
        /// <param name="month">受診希望日（月）</param>
        /// <param name="day">受診希望日（日）</param>
        /// <param name="strTimeFra">時間枠</param>
        /// <param name="birthDate">表示開始日付</param>
        /// <param name="date">表示終了日付</param>
        /// <returns></returns>
        public List<dynamic> CheckValueSearchStep1(string orgCd1, string orgCd2, string csCd, string gender, string birthYear, string birthMonth, string birthDay,
            string perId, string year, string month, string day, string strTimeFra, ref dynamic birthDate, ref dynamic date)
        {
            List<dynamic> messages = new List<dynamic>();       // エラーメッセージの集合

            // 必須入力チェック

            // 団体コード
            if (string.IsNullOrEmpty(orgCd1) || string.IsNullOrEmpty(orgCd2))
            {
                messages.Add("団体が入力されていません。");
            }

            // コースコード
            if (string.IsNullOrEmpty(csCd))
            {
                messages.Add("コースが入力されていません。");
            }

            // 個人IDが入力されていない場合は　性別、生年月日　が入力されている
            if (string.IsNullOrEmpty(perId))
            {
                if (string.IsNullOrEmpty(gender))
                {
                    messages.Add("性別が入力されていません。");
                }

                messages.Add(WebHains.CheckDate("生年月日", birthYear, birthMonth, birthDay, birthDate, Check.Necessary));
            }

            // 受診希望日
            messages.Add(WebHains.CheckDate("受診希望日", year, month, day, date, Check.Necessary));

            // 受診希望日は過去日付エラー
            if (string.IsNullOrEmpty(date))
            {
                if (DateTime.Parse(date) < DateTime.Now.Date)
                {
                    messages.Add("受診希望日は過去日付エラーです。");
                }
            }

            // 戻り値の設定
            return messages;
        }

        /// <summary>
        /// 予約枠テーブルレコードを削除する
        /// </summary>
        /// <param name="rsvFraCd">予約枠コード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteRsvFra(string rsvFraCd)
        {
            string sql = "";        // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvfracd", rsvFraCd.Trim());

            // 予約枠テーブルレコードの削除
            sql = @"
                    delete rsvfra_p
                    where
                      rsvfracd = :rsvfracd
            ";

            connection.Execute(sql, param);

            // 戻り値の設定
            return true;

        }

        /// <summary>
        /// 予約群テーブルレコードを削除する
        /// </summary>
        /// <param name="rsvGrpCd">予約枠コード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteRsvGrp(string rsvGrpCd)
        {
            string sql = "";        // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvgrpcd", rsvGrpCd.Trim());

            // 予約枠テーブルレコードの削除
            sql = @"
                delete rsvgrp
                where
                  rsvgrpcd = :rsvgrpcd
            ";

            connection.Execute(sql, param);

            // 戻り値の設定
            return true;

        }

        /// <summary>
        /// 予約人数管理情報のコピーを行う
        /// </summary>
        /// <param name="cslDate">コピー元受診日</param>
        /// <param name="csCd">コピー元コースコード</param>
        /// <param name="rsvGrpCd"></param>
        /// <param name="strCslDate">コピー先開始受診日</param>
        /// <param name="endCslDate">コピー先終了受診日</param>
        /// <param name="weekdays">コピー先受診日範囲において対象となる曜日の配列(添字の０番目から月、火、･･･の順。各要素値がvbNullString値以外の場合に対象)</param>
        /// <param name="update">True指定時、コピー先受診日に同一キーの予約人数情報が存在する場合は上書きする</param>
        /// <returns>作成／更新レコード数</returns>
        public long CopyRsvFraMng(DateTime cslDate, string csCd, string rsvGrpCd, DateTime strCslDate, DateTime endCslDate, List<string> weekdays, bool update)
        {
            string sqlBased = "";       // SQLステートメント
            string sql = "";            // SQLステートメント
            DateTime wkCslDate;         // 受診日
            bool act;                   // コピー実施要否

            long ret = 0;

            // 開始、終了受診日の大小が逆転している場合は値を交換する
            if (strCslDate > endCslDate)
            {
                wkCslDate = strCslDate;
                strCslDate = endCslDate;
                endCslDate = wkCslDate;
            }

            // 枠コピー用基本表SQLの編集
            sqlBased = @"
                    select
                      :newcsldate csldate
                      , rsvframng.cscd
                      , rsvframng.rsvgrpcd
                      , rsvframng.maxcnt
                      , rsvframng.maxcnt_m
                      , rsvframng.maxcnt_f
                      , rsvframng.overcnt
                      , rsvframng.overcnt_m
                      , rsvframng.overcnt_f
            ";

            // webHains本体とweb予約からそれぞれ求まる、コピー先受診日の予約人数を合算(存在しない場合は０とする)
            sqlBased += @"
                      , nvl(realrsvframng.rsvcnt_m, 0) + nvl(web_rsvframng.rsvcnt_m, 0) rsvcnt_m
                      , nvl(realrsvframng.rsvcnt_f, 0) + nvl(web_rsvframng.rsvcnt_f, 0) rsvcnt_f
            ";

            // コピー先受診日のweb予約から得られる予約人数情報
            sqlBased += @"
                    from
                      (
                        select
                          web_rsvframng.csldate
                          , web_rsvframng.cscd
                          , web_rsvframng.rsvgrpcd
            ";

            // NULL値がカウントされない性質を利用し、性別による振り分けを行う
            sqlBased += @"
                          , count(
                              decode(
                                  v_web_yoyaku.sexflg
                                  , 1
                                  , v_web_yoyaku.webno
                                  , null
                              )
                            ) rsvcnt_m
                          , count(
                              decode(
                                  v_web_yoyaku.sexflg
                                  , 2
                                  , v_web_yoyaku.webno
                                  , null
                              )
                            ) rsvcnt_f
                        from
                            webreserve.v_web_yoyaku
                            , webreserve.web_rsvframng
                        where
                            web_rsvframng.csldate = :newcsldate
                            and web_rsvframng.csldate = v_web_yoyaku.jdate
                            and web_rsvframng.webno = v_web_yoyaku.webno

            ";

            // webHains本体に本登録されている情報はカウントしない
            sqlBased += @"
                            and v_web_yoyaku.ykbn != 2
                            group by
                              web_rsvframng.csldate
                              , web_rsvframng.cscd
                              , web_rsvframng.rsvgrpcd) web_rsvframng
            ";

            // コピー先受診日の受診情報から得られる予約人数情報
            sqlBased += @"
                              , (
                                  select
                                    subquery.csldate
                                    , subquery.cscd
                                    , subquery.rsvgrpcd
            ";

            // 先にUNION ALLで指定しているため、同一予約番号にて複数存在するコース、予約群に関しては重複を１つとしてカウント
            // かつNULL値がカウントされない性質を利用し、性別による振り分けを行う
            sqlBased += @"
                                    , count(
                                            distinct decode(person.gender, 1, subquery.rsvno, null)
                                      ) rsvcnt_m
                                    , count(
                                            distinct decode(person.gender, 2, subquery.rsvno, null)
                                      ) rsvcnt_f
                                  from
                                    person
            ";

            // 受診情報本体から、枠管理されるコース・予約群を取得
            sqlBased += @"
                                    , (
                                        select
                                          consult.rsvno
                                          , consult.csldate
                                          , consult.cscd
                                          , consult.rsvgrpcd
                                          , consult.perid
                                          , consult.cancelflg
                                        from
                                          consult
            ";

            // 後で重複は除きつつカウントするためここではUNION ALL指定(２回ソート処理が走るのは嫌)
            sqlBased += @"
                                        union all
            ";

            // セット情報から枠管理されるコース、予約群を取得
            sqlBased += @"
                                        select
                                          consult.rsvno
                                          , consult.csldate
                                          , rsvfra_c.cscd
                                          , consult.rsvgrpcd
                                          , consult.perid
                                          , consult.cancelflg
                                        from
                                          rsvfra_c
                                          , ctrpt_opt
                                          , consult_o
                                          , consult
                                        where
                                          consult.rsvno = consult_o.rsvno
                                          and consult_o.ctrptcd = ctrpt_opt.ctrptcd
                                          and consult_o.optcd = ctrpt_opt.optcd
                                          and consult_o.optbranchno = ctrpt_opt.optbranchno
                                          and ctrpt_opt.rsvfracd = rsvfra_c.rsvfracd
            ";

            // ここも先と同様、UNION ALL指定
            sqlBased += @"
                                        union all
            ";

            // セット情報から枠管理されるコースと、そのオープン枠予約群を取得
            sqlBased += @"
                                        select
                                          consult.rsvno
                                          , consult.csldate
                                          , rsvfra_c.cscd
                                          , opengrpcourse.rsvgrpcd
                                          , consult.perid
                                          , consult.cancelflg
                                        from
                                          rsvfra_c
                                          , rsvfra_p
                                          , ctrpt_opt
                                          , consult_o
                                          , consult
            ";

            // コピー元の予約人数管理情報を検索し、うちオープン枠予約群検索対象であるコースと、その予約群とを取得
            sqlBased += @"
                                          , (
                                                select
                                                  rsvframng.cscd
                                                  , rsvframng.rsvgrpcd
                                                from
                                                  rsvgrp
                                                  , rsvframng
                                                where
                                                  rsvframng.csldate = :csldate
                                                  and rsvframng.cscd = nvl(:cscd, rsvframng.cscd)
                                                  and rsvframng.rsvgrpcd = nvl(:rsvgrpcd, rsvframng.rsvgrpcd)
                                                  and rsvframng.rsvgrpcd = rsvgrp.rsvgrpcd
                                                  and rsvgrp.isopengrp > 0
                                           ) opengrpcourse
            ";

            sqlBased += @"
                                        where
                                          consult.rsvno = consult_o.rsvno
                                          and consult_o.ctrptcd = ctrpt_opt.ctrptcd
                                          and consult_o.optcd = ctrpt_opt.optcd
                                          and consult_o.optbranchno = ctrpt_opt.optbranchno
            ";

            // 予約枠テーブルを結合し、オープン枠予約群検索対象であるもののみ取得
            sqlBased += @"
                                          and ctrpt_opt.rsvfracd = rsvfra_p.rsvfracd
                                          and rsvfra_p.incopengrp > 0
            ";

            // オープン枠予約群検索対象である予約枠のコースを取得
            sqlBased += @"
                                          and ctrpt_opt.rsvfracd = rsvfra_c.rsvfracd
            ";

            // うち、先に取得したコピー元のオープン枠予約群検索対象コースのみを取得
            sqlBased += @"
                                          and rsvfra_c.cscd = opengrpcourse.cscd
            ";

            sqlBased += @"
                                      ) subquery
            ";

            // ここでキャンセル者は除きつつ、かつ性別ごとの件数を取得するため個人情報を結合
            sqlBased += @"
                        where
                            subquery.csldate = :newcsldate
                            and subquery.cancelflg = 0
                            and subquery.perid = person.perid
                        group by
                            subquery.csldate
                            , subquery.cscd
                            , subquery.rsvgrpcd
                      ) realrsvframng
            ";

            // コピー元の予約枠
            sqlBased += @"
                       , rsvframng
                    where
                        rsvframng.csldate = :csldate
                        and rsvframng.cscd = nvl(:cscd, rsvframng.cscd)
                        and rsvframng.rsvgrpcd = nvl(:rsvgrpcd, rsvframng.rsvgrpcd)
            ";

            // これにコピー先受診日の受診情報から得られる予約人数情報を結合(コピー先に受診情報がない場合もあり)
            sqlBased += @"
                        and rsvframng.cscd = realrsvframng.cscd(+)
                        and rsvframng.rsvgrpcd = realrsvframng.rsvgrpcd(+)
            ";

            // 更にコピー先受診日のweb予約から得られる予約人数情報を結合(コピー先にweb予約情報がない場合もあり)
            sqlBased += @"
                        and rsvframng.cscd = web_rsvframng.cscd(+)
                        and rsvframng.rsvgrpcd = web_rsvframng.rsvgrpcd(+)
            ";

            // コピー先受診日に同一コース・予約群の予約人数存在時は上書きしない場合
            if (!update)
            {
                // INSERT文作成開始
                sql += @"
                        insert
                        into rsvframng(
                          csldate
                          , cscd
                          , rsvgrpcd
                          , maxcnt
                          , maxcnt_m
                          , maxcnt_f
                          , overcnt
                          , overcnt_m
                          , overcnt_f
                          , rsvcnt_m
                          , rsvcnt_f
                        )
                ";

                // 挿入するレコードの基本表は先に作成したそれ
                sql = sql + sqlBased;

                // これに対し、すでに存在するコピー先受診日・コース・予約群の予約人数情報を除外
                sql += @"
                        and not exists (
                                          select
                                            *
                                          from
                                            rsvframng existsrsvframng
                                          where
                                            existsrsvframng.csldate = :newcsldate
                                            and existsrsvframng.cscd = rsvframng.cscd
                                            and existsrsvframng.rsvgrpcd = rsvframng.rsvgrpcd
                        )
                ";

            }
            else
            {
                // 上書きする場合

                // 先に作成した基本表をもとにMERGE文を作成
                sql += @"
                        merge
                        into rsvframng
                            using ( " + sqlBased + @" ) basedrsvframng
                            on (
                                rsvframng.csldate = basedrsvframng.csldate
                                and rsvframng.cscd = basedrsvframng.cscd
                                and rsvframng.rsvgrpcd = basedrsvframng.rsvgrpcd
                               )
                ";

                // レコード存在時は上書き
                sql += @"
                            when matched then update
                                set
                                  rsvframng.maxcnt = basedrsvframng.maxcnt
                                  , rsvframng.maxcnt_m = basedrsvframng.maxcnt_m
                                  , rsvframng.maxcnt_f = basedrsvframng.maxcnt_f
                                  , rsvframng.overcnt = basedrsvframng.overcnt
                                  , rsvframng.overcnt_m = basedrsvframng.overcnt_m
                                  , rsvframng.overcnt_f = basedrsvframng.overcnt_f
                                  , rsvframng.rsvcnt_m = basedrsvframng.rsvcnt_m
                                  , rsvframng.rsvcnt_f = basedrsvframng.rsvcnt_f
                ";

                // レコード非存在時は挿入
                sql += @"
                            when not matched then
                                insert (
                                          rsvframng.csldate
                                          , rsvframng.cscd
                                          , rsvframng.rsvgrpcd
                                          , rsvframng.maxcnt
                                          , rsvframng.maxcnt_m
                                          , rsvframng.maxcnt_f
                                          , rsvframng.overcnt
                                          , rsvframng.overcnt_m
                                          , rsvframng.overcnt_f
                                          , rsvframng.rsvcnt_m
                                          , rsvframng.rsvcnt_f
                ";

                sql += @"
                                        )
                                values (
                                            basedrsvframng.csldate
                                            , basedrsvframng.cscd
                                            , basedrsvframng.rsvgrpcd
                                            , basedrsvframng.maxcnt
                                            , basedrsvframng.maxcnt_m
                                            , basedrsvframng.maxcnt_f
                                            , basedrsvframng.overcnt
                                            , basedrsvframng.overcnt_m
                                            , basedrsvframng.overcnt_f
                                            , basedrsvframng.rsvcnt_m
                                            , basedrsvframng.rsvcnt_f
                                        )
                ";
            }

            using (var transaction = BeginTransaction())
            {
                try
                {
                    // コピー先受診日範囲の検索
                    wkCslDate = strCslDate;
                    while (!(wkCslDate > endCslDate))
                    {
                        // 受診日が範囲指定の場合はWeekday関数にて求まる曜日値に対してコピー対象であるかを判断し、単一日指定の場合は無条件で対象とする
                        if (strCslDate != endCslDate)
                        {
                            act = (weekdays[(DateAndTime.Weekday(wkCslDate) + 5) % 7] != "");
                        }
                        else
                        {
                            act = true;
                        }

                        // キー及び更新値の設定
                        var param = new Dictionary<string, object>();
                        param.Add("csldate", cslDate);
                        param.Add("cscd", !string.IsNullOrEmpty(csCd) ? csCd : null);
                        param.Add("rsvgrpcd", !string.IsNullOrEmpty(rsvGrpCd) ? rsvGrpCd : null);
                        param.Add("newcsldate", wkCslDate);

                        // ここまでの時点でコピー対象の場合
                        List<dynamic> current = new List<dynamic>();
                        if (act)
                        {
                            // 休日判定
                            current = connection.Query(" select csldate from schedule_h where csldate = :newcsldate ", param).ToList();

                            // レコードが存在する場合は休診日のため非対象とする
                            if (current.Count > 0)
                            {
                                act = false;
                            }

                        }

                        // コピー対象の場合
                        if (act)
                        {
                            ret = connection.Execute(sql, param);
                        }

                        wkCslDate = wkCslDate.AddDays(1);

                    }

                    transaction.Commit();

                    // 戻り値の設定
                    return ret;
                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();

                    return -1;
                }
            }
        }

        /// <summary>
        /// コース受診予約群テーブルレコードを削除する
        /// </summary>
        /// <param name="csCd">コースコード</param>
        /// <param name="rsvGrpCd">予約群コード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteCourseRsvGrp(string csCd, long rsvGrpCd)
        {
            string sql = "";    // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("cscd", csCd);
            param.Add("rsvgrpcd", rsvGrpCd);

            // コース受診予約群テーブルレコードの削除
            sql = @"
                    delete course_rsvgrp
                    where
                      cscd = :cscd
                      and rsvgrpcd = :rsvgrpcd
            ";

            connection.Execute(sql, param);

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// 予約空き状況の取得
        /// </summary>
        /// <param name="strCslDate">開始受診日</param>
        /// <param name="endCslDate">終了受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="timeFra">時間枠</param>
        /// <param name="birth">生年月日</param>
        /// <param name="gender">性別</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optCount">オプション数</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="emptyCount">空き人数</param>
        /// <param name="mark">マーク</param>
        /// <param name="enabled">アンカー表示の有無</param>
        /// <param name="cslCount">検索レコード数</param>
        /// <returns>
        /// エラー場合、Error Numberを返す
        /// </returns>
        public long GetEmptyCalender(string strCslDate, string endCslDate, string csCd, string ctrPtCd,
            string timeFra, string birth, string gender, List<string> optCd, long optCount,
            ref List<string> cslDate, ref List<string> emptyCount, ref List<string> mark,
            ref List<string> enabled, ref List<string> cslCount)
        {
            string sql = "";                                // SQLステートメント
            Int32 arraySize = 0;                            // 配列の要素数

            OracleParameter sqlCslDate;                     // 検索対象開始日付
            OracleParameter sqlEmptyCount;                  // 空き人数
            OracleParameter sqlCharMark;                    // マーク
            OracleParameter sqlEnabled;                     // アンカー　表示の有無
            OracleParameter sqlCslCount;                    // 検索レコード数
            OracleParameter sqlRet;                         // SQL戻り値

            List<string> msg = new List<string>();          // メッセージ

            long ret = 0;                                   // 関数戻り値

            using (var cmd = new OracleCommand())
            {

                // キー値及び更新値の設定
                cmd.Parameters.Add("strcsldate", strCslDate);
                cmd.Parameters.Add("endcsldate", endCslDate);
                cmd.Parameters.Add("cscd", csCd);
                cmd.Parameters.Add("ctrptcd", ctrPtCd);
                cmd.Parameters.Add("timefra", timeFra);
                cmd.Parameters.Add("birth", birth);
                cmd.Parameters.Add("gender", gender);
                cmd.Parameters.AddTable("optcd", optCd.ToArray(), ParameterDirection.Input, OracleDbType.Int32, (int)(optCount == 0 ? 1 : optCount), 20);
                cmd.Parameters.Add("optcount", optCount);

                sqlCslDate = cmd.Parameters.AddTable("csldate", ParameterDirection.Output, OracleDbType.Date, arraySize, 8);
                sqlEmptyCount = cmd.Parameters.AddTable("emptycount", ParameterDirection.Output, OracleDbType.Int32, arraySize, 20);
                sqlCharMark = cmd.Parameters.AddTable("charmark", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, 2);
                sqlEnabled = cmd.Parameters.AddTable("enabled", ParameterDirection.Output, OracleDbType.Int32, arraySize, 20);
                sqlCslCount = cmd.Parameters.Add("cslcount", OracleDbType.Int32, ParameterDirection.Output);
                sqlRet = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                // ストアド呼び出し
                sql = @"
                        begin :ret := schedulepackage.getemptycalender(
                          :strcsldate
                          , :endcsldate
                          , :cscd
                          , :ctrptcd
                          , :timefra
                          , :birth
                          , :gender
                          , :optcd
                          , :optcount
                          , :csldate
                          , :emptycount
                          , :charmark
                          , :enabled
                          , :cslcount
                        );
                        end;
                ";

                // SQL実行
                ExecuteNonQuery(cmd, sql);

                // 戻り値の設定(エラーに関わらず戻す値)
                cslDate = ((OracleString[])sqlCslDate.Value).Select(s => s.Value).ToList();
                emptyCount = ((OracleString[])sqlEmptyCount.Value).Select(s => s.Value).ToList();
                mark = ((OracleString[])sqlCharMark.Value).Select(s => s.Value).ToList();
                enabled = ((OracleString[])sqlEnabled.Value).Select(s => s.Value).ToList();
                cslCount = ((OracleString[])sqlCslCount.Value).Select(s => s.Value).ToList();

                ret = ((OracleDecimal)sqlRet.Value).ToInt32();
            }

            return ret;
        }

        /// <summary>
        /// すでに登録されている予約済み人数をカウントする
        /// </summary>
        /// <param name="date">処理対象日付</param>
        /// <param name="timeFra">時間枠</param>
        /// <param name="rsvFraCd">予約枠コード</param>
        /// <param name="fraType">枠管理タイプ</param>
        /// <param name="orgCount">団体カウントモード（True:団体枠もカウントする，False:受診情報のみカウント）</param>
        /// <returns>カウント数</returns>
        private long GetRsvCount(string date, long timeFra, string rsvFraCd, long fraType, bool orgCount)
        {
            string sql = "";    // SQLステートメント

            long ret = 0;       // 戻り値
            long count1 = 0;    // 受診情報の予約済み人数
            long count2 = 0;    // 団体の受診予定人数
            long count3 = 0;    // 団体の予約済み人数

            // 条件が設定されていない場合はエラー
            if (!Information.IsDate(date.Trim()))
            {
                throw new ArgumentException();
            }
            if (string.IsNullOrEmpty(rsvFraCd) || string.IsNullOrEmpty(rsvFraCd.Trim()))
            {
                throw new ArgumentException();
            }
            if ((fraType != Convert.ToInt16(FraType.Cs)) && (fraType != Convert.ToInt16(FraType.Item)))
            {
                throw new ArgumentException();
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate1", date.Trim());
            param.Add("timefra1", timeFra);
            param.Add("rsvfracd1", rsvFraCd.Trim());
            param.Add("used1", ConsultCancel.Used);

            // コース枠管理の場合
            if (fraType == Convert.ToInt16(FraType.Cs))
            {

                // 検索条件を満たす結果コメントテーブルのレコードを取得
                sql = @"
                        select
                          count(*) reccount
                        from
                          consult csl
                          , rsvfra_c rfc
                        where
                          csl.csldate = :csldate1
                          and csl.timefra = :timefra1
                          and csl.cancelflg = :used1
                          and csl.cscd = rfc.cscd
                          and rfc.rsvfracd = :rsvfracd1
                ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 検索レコードが存在する場合
                // (COUNT関数を発行しているので必ず1レコード返ってくる)
                if (current != null)
                {
                    // 受診情報の予約済み人数
                    count1 = long.Parse(current.RECCOUNT);
                }


                if (!orgCount)
                {
                    // 受診情報のみカウントするモードの場合

                    // 戻り値の設定（受診情報の予約済み人数）
                    ret = count1;
                }
                else
                {
                    // 団体枠もカウントするモードの場合

                    // 検索条件を満たす団体予約人数の受診予定人数と予約済み人数を取得
                    sql = @"
                            select
                              nvl(sum(ors.cslcount), 0) cslcount
                              , nvl(sum(ors.rsvcount), 0) rsvcount
                            from
                              orgrsv ors
                              , rsvfra_c rfc
                            where
                              ors.csldate = :csldate1
                              and ors.timefra = :timefra1
                              and ors.cscd = rfc.cscd
                              and rfc.rsvfracd = :rsvfracd1
                    ";

                    current = connection.Query(sql, param).FirstOrDefault();

                    // 検索レコードが存在する場合
                    // (SUM関数を発行しているので必ず1レコード返ってくる)
                    if (current != null)
                    {
                        // 団体の受診予定人数
                        count2 = long.Parse(current.CSLCOUNT);
                        // 団体の予約済み人数
                        count3 = long.Parse(current.RSVCOUNT);
                    }

                    // 戻り値の設定（団体の受診予定人数　＋　受診情報の予約済み人数　－　団体の予約済み人数）
                    ret = count2 + count1 - count3;
                }
            }
            else
            {
                // 検査項目枠管理の場合

                // 受診情報より該当日の予約番号を取得（時間枠は指定してはならない）
                sql = @"
                        select
                          rsvno
                        from
                          consult
                        where
                          csldate = :csldate1
                          and cancelflg = :used1
                ";

                List<dynamic> current = connection.Query(sql, param).ToList();

                // 検索レコードが存在する場合
                if (current.Count > 0)
                {
                    string sql2 = "";    // SQLステートメント

                    // 予約番号すべてについて条件を編集する
                    for (int i = 0; i < current.Count; i++)
                    {
                        // 予約番号の条件を編集
                        if (sql2.Equals(""))
                        {
                            sql2 = current[i]["rsvno"];
                        }
                        else
                        {
                            sql2 += ", " + current[i]["rsvno"];
                        }
                    }

                    // 上で求めた予約番号について、該当検査項目を含む受診情報のレコード件数を取得
                    sql = @"
                            select
                              count(distinct lst.rsvno) reccount
                            from
                              consultitemlist lst
                            where
                              lst.rsvno in (" + sql2 + @")
                              and lst.itemcd in (
                                                    select
                                                      rfi.itemcd
                                                    from
                                                      rsvfra_i rfi
                                                    where
                                                      rfi.rsvfracd = :rsvfracd1
                                                )
                    ";

                    dynamic current2 = connection.Query(sql, param).FirstOrDefault();

                    // 検索レコードが存在する場合
                    // (COUNT関数を発行しているので必ず1レコード返ってくる)
                    if (current2 != null)
                    {
                        // 受診情報の予約済み人数
                        count1 = long.Parse(current2.RECCOUNT);
                    }

                }

                // 受診情報のみカウントするモードの場合
                if (!orgCount)
                {
                    // 戻り値の設定（受診情報の予約済み人数）
                    ret = count1;
                }
                else
                {
                    // 団体枠もカウントするモードの場合

                    // 検索条件を満たす団体予約人数のレコードを取得（時間枠はサマリーする）
                    sql = @"
                            select
                              cscd
                              , orgcd1
                              , orgcd2
                              , sum(cslcount) cslcount
                            from
                              orgrsv
                            where
                              csldate = :csldate1
                            group by
                              cscd
                              , orgcd1
                              , orgcd2
                    ";
                    current = connection.Query(sql, param).ToList();

                    // 検索レコードが存在する場合
                    if (current.Count > 0)
                    {
                        // 団体予約人数１レコードごとに処理する
                        for (int i = 0; i < current.Count; i++)
                        {
                            if (CheckOrgRsv_iFra(date.Trim(), current[i]["cscd"], current[i]["orgcd1"], current[i]["orgcd2"], rsvFraCd.Trim()))
                            {
                                // 団体の受診予定人数
                                count2 = count2 + long.Parse(current[i]["cslcount"]);
                                // 団体の予約済み人数
                                count3 = count3 + GetRsvCount_iFra(date.Trim(), current[i]["cscd"], current[i]["orgcd1"], current[i]["orgcd2"]);
                            }
                        }
                    }

                    // 戻り値の設定（団体の受診予定人数＋　受診情報の予約済み人数－　団体の予約済み人数）
                    ret = count2 + count1 - count3;

                }

            }

            return ret;
        }

        /// <summary>
        /// すでに登録されている予約済み人数をカウントする（団体予約検査項目枠）
        /// </summary>
        /// <param name="date">処理対象日付</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <returns>カウント数</returns>
        private long GetRsvCount_iFra(string date, string csCd, string orgCd1, string orgCd2)
        {
            string sql = "";    // SQLステートメント

            long ret = 0;       // 戻り値

            // 条件が設定されていない場合はエラー
            if (!Information.IsDate(date.Trim()))
            {
                throw new ArgumentException();
            }
            if (string.IsNullOrEmpty(csCd) || string.IsNullOrEmpty(csCd.Trim()))
            {
                throw new ArgumentException();
            }
            if (string.IsNullOrEmpty(orgCd1) || string.IsNullOrEmpty(orgCd1.Trim()))
            {
                throw new ArgumentException();
            }
            if (string.IsNullOrEmpty(orgCd2) || string.IsNullOrEmpty(orgCd2.Trim()))
            {
                throw new ArgumentException();
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate2", date.Trim());
            param.Add("cscd2", csCd.Trim());
            param.Add("orgcd12", orgCd1.Trim());
            param.Add("orgcd22", orgCd2.Trim());
            param.Add("used2", ConsultCancel.Used);

            // 検索条件を満たす受診情報のレコード件数を取得（時間枠は指定してはならない）
            sql = @"
                    select
                      count(*) reccount
                    from
                      consult
                    where
                      csldate = :csldate2
                      and cscd = :cscd2
                      and orgcd1 = :orgcd12
                      and orgcd2 = :orgcd22
                      and cancelflg = :used2
            ";
            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // 検索レコードが存在する場合
            // (COUNT関数を発行しているので必ず1レコード返ってくる)
            if (current != null)
            {
                // 戻り値の設定
                ret = long.Parse(current.RECCOUNT);
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 予約枠レコード及び予約枠が管理する項目を登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// rsvfracd 予約枠コード
        /// rsvfraname 予約枠名称
        /// fratype 枠管理タイプ
        /// incopengrp オープン枠予約群検索
        /// itemcount 予約枠内項目数
        /// </param>
        /// <param name="itemCodes">項目コード（コースコード or 検査項目コード）</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistRsvFra_All(string mode, JToken data, List<string> itemCodes)
        {

            Insert ret = Insert.Error;

            while (true)
            {
                using (var transaction = BeginTransaction())
                {
                    try
                    {

                        // 予約枠レコード及び予約枠が管理する項目を登録
                        ret = RegistRsvFra_p(mode, data);

                        // 異常終了なら処理終了
                        if (ret != Insert.Normal)
                        {
                            break;
                        }

                        // 予約枠管理テーブルの更新
                        ret = RegistRsvFra_Item(Convert.ToInt32(data["fratype"]), Convert.ToString(data["rsvfracd"]), Convert.ToInt32(data["itemcount"]), itemCodes);

                        // 異常終了なら処理終了
                        if (ret != Insert.Normal)
                        {
                            break;
                        }

                        transaction.Commit();

                        ret = Insert.Normal;
                    }
                    catch
                    {
                        // エラー発生時はトランザクションをアボートに設定
                        transaction.Rollback();

                        ret = Insert.Error;
                    }


                }

            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 予約枠内受診項目を登録する
        /// </summary>
        /// <param name="fraType">枠管理タイプ（依頼 or 検査）</param>
        /// <param name="rsvFraCd">予約枠コード</param>
        /// <param name="itemCount">予約枠内項目数</param>
        /// <param name="itemCodes">項目コード（コースコード or 検査項目コード）</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistRsvFra_Item(int fraType, string rsvFraCd, int itemCount, List<string> itemCodes)
        {
            string sql = "";    // SQLステートメント

            Insert ret = Insert.Error;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvfracd", rsvFraCd.Trim());

            // 予約枠内項目レコードの削除（関係なくても両方削除しておく～ゴミ帽子じゃなくて防止）
            sql = @"
                    delete rsvfra_c
                    where
                      rsvfracd = :rsvfracd
            ";

            connection.Execute(sql, param);

            if (itemCount > 0)
            {
                // キー及び更新値の設定再割り当て
                var sqlParamArray = new List<dynamic>();
                for (int i = 0; i < itemCount; i++)
                {
                    sqlParamArray.Add(new
                    {
                        rsvfracd = rsvFraCd,
                        itemcode = itemCodes[i]
                    });
                }

                // 新規挿入
                if (fraType == Convert.ToInt16(FraType.Cs))
                {
                    // 枠管理タイプがコースの場合
                    sql = @"
                            insert
                            into rsvfra_c(
                                rsvfracd
                                , cscd)
                            values (
                                :rsvfracd
                                , :itemcode)
                    ";

                    connection.Execute(sql, param);
                }
            }

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 予約枠レコード及び予約枠が管理する項目を登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// rsvfracd 予約枠コード
        /// rsvfraname 予約枠名称
        /// incopengrp オープン枠予約群検索
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistRsvFra_p(string mode, JToken data)
        {
            string sql = "";                                // SQLステートメント

            Insert ret = Insert.Error;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvfracd", Convert.ToString(data["rsvfracd"]).Trim());
            param.Add("rsvfraname", Convert.ToString(data["rsvfraname"]).Trim());
            param.Add("incopengrp", Convert.ToInt64(data["incopengrp"]));

            while (true)
            {
                // 予約枠テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update rsvfra_p
                            set
                              rsvfraname = :rsvfraname
                              , incopengrp = :incopengrp
                            where
                              rsvfracd = :rsvfracd
                    ";

                    int ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす予約枠テーブルのレコードを取得
                sql = @"
                        select
                          rsvfracd
                        from
                          rsvfra_p
                        where
                          rsvfracd = :rsvfracd
                ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 存在した場合、新規挿入不可
                if (current != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 新規挿入
                sql = @"
                        insert
                        into rsvfra_p(
                            rsvfracd
                            , rsvfraname
                            , incopengrp
                        )
                        values (
                            :rsvfracd
                            , :rsvfraname
                            , :incopengrp
                        )
                ";

                connection.Execute(sql, param);

                break;
            }

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 予約群レコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// mode 登録モード("INS":挿入、"UPD":更新)
        /// rsvGrpCd 予約群コード
        /// rsvGrpName 予約群名称
        /// strTime 開始時間
        /// endTime 終了時間
        /// rptEndTime 健診受付終了時間
        /// lead 誘導対象
        /// strDayId 開始当日ID
        /// strDayId 終了当日ID
        /// rsvSetGrpCd 予約時セットグループコード
        /// isOpenGrp オープン枠予約群
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistRsvGrp(string mode, JToken data)
        {
            string sql = "";        // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvgrpcd", Convert.ToInt64(data["rsvgrpcd"]));
            param.Add("rsvgrpname", Convert.ToString(data["rsvgrpname"]));
            param.Add("strtime", Convert.ToInt64(data["strtime"]));
            param.Add("endtime", Convert.ToInt64(data["endtime"]));
            param.Add("rptendtime", Convert.ToInt64(data["rptendtime"]));
            param.Add("lead", Convert.ToInt64(data["lead"]));
            param.Add("strdayid", Convert.ToInt64(data["strdayid"]));
            param.Add("enddayid", Convert.ToInt64(data["enddayid"]));
            param.Add("rsvsetgrpcd", Convert.ToString(data["rsvsetgrpcd"]));
            param.Add("isopengrp", Convert.ToString(data["isopengrp"]));

            while (true)
            {
                // 予約枠テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update rsvgrp
                            set
                              rsvgrpname = :rsvgrpname
                              , strtime = :strtime
                              , endtime = :endtime
                              , rptendtime = :rptendtime
                              , lead = :lead
                              , strdayid = :strdayid
                              , enddayid = :enddayid
                              , rsvsetgrpcd = :rsvsetgrpcd
                              , isopengrp = :isopengrp
                            where
                              rsvgrpcd = :rsvgrpcd
                    ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす予約枠テーブルのレコードを取得
                sql = @"
                        select
                          rsvgrpcd
                        from
                          rsvgrp
                        where
                          rsvgrpcd = :rsvgrpcd
                ";
                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 存在した場合、新規挿入不可
                if (current != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                sql = @"
                        insert
                        into rsvgrp(
                          rsvgrpcd
                          , rsvgrpname
                          , strtime
                          , endtime
                          , rptendtime
                          , lead
                          , strdayid
                          , enddayid
                          , rsvsetgrpcd
                          , isopengrp
                        )
                        values (
                          :rsvgrpcd
                          , :rsvgrpname
                          , :strtime
                          , :endtime
                          , :rptendtime
                          , :lead
                          , :strdayid
                          , :enddayid
                          , :rsvsetgrpcd
                          , :isopengrp
                        )
                ";

                connection.Execute(sql, param);

                ret = Insert.Normal;
                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 予約群レコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// csCd 予約群コード
        /// rsvGrpCd 予約群コード
        /// mngGender 男女別枠管理
        /// defCnt 共通人数
        /// defCnt_m 男人数
        /// defCnt_f 女人数
        /// defCnt_sat 土曜共通人数
        /// defCnt_sat_m 土曜男人数
        /// defCnt_sat_f 土曜女人数
        /// </param>
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Duplicate 同一キーのレコード存在
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert RegistCourseRsvGrp(string mode, JToken data)
        {
            string sql = "";        // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("strcscd", Convert.ToString(data["strcscd"]));
            param.Add("lngrsvgrpcd", Convert.ToInt64(data["lngrsvgrpcd"]));
            param.Add("lngmnggender", Convert.ToInt64(data["lngmnggender"]));
            param.Add("lngdefcnt", Convert.ToInt64(data["lngdefcnt"]));
            param.Add("lngdefcnt_m", Convert.ToInt64(data["lngdefcnt_m"]));
            param.Add("lngdefcnt_f", Convert.ToInt64(data["lngdefcnt_f"]));
            param.Add("lngdefcnt_sat", Convert.ToInt64(data["lngdefcnt_sat"]));
            param.Add("lngdefcnt_sat_m", Convert.ToInt64(data["lngdefcnt_sat_m"]));
            param.Add("lngdefcnt_sat_f", Convert.ToInt64(data["lngdefcnt_sat_f"]));

            while (true)
            {
                // コース受診予約群テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update course_rsvgrp
                            set
                              mnggender = :mnggender
                              , defcnt = :defcnt
                              , defcnt_m = :defcnt_m
                              , defcnt_f = :defcnt_f
                              , defcnt_sat = :defcnt_sat
                              , defcnt_sat_m = :defcnt_sat_m
                              , defcnt_sat_f = :defcnt_sat_f
                            where
                              cscd = :cscd
                              and rsvgrpcd = :rsvgrpcd
                    ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たすコース受診予約群テーブルのレコードを取得
                sql = @"
                        select
                          rsvgrpcd
                        from
                          course_rsvgrp
                        where
                          cscd = :cscd
                          and rsvgrpcd = :rsvgrpcd
                ";
                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 存在した場合、新規挿入不可
                if (current != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 新規挿入
                sql = @"
                        insert
                        into course_rsvgrp(
                          cscd
                          , rsvgrpcd
                          , mnggender
                          , defcnt
                          , defcnt_m
                          , defcnt_f
                          , defcnt_sat
                          , defcnt_sat_m
                          , defcnt_sat_f
                        )
                        values (
                          :cscd
                          , :rsvgrpcd
                          , :mnggender
                          , :defcnt
                          , :defcnt_m
                          , :defcnt_f
                          , :defcnt_sat
                          , :defcnt_sat_m
                          , :defcnt_sat_f
                        )
                ";

                connection.Execute(sql, param);

                ret = Insert.Normal;
                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 指定受診日のコース別・団体別受診者数を取得する
        /// </summary>
        /// <param name="mode">取得モード(0:コース別、1:団体別、2:コース・団体別、3:団体・コース別)</param>
        /// <param name="cslDate">受診日</param>
        /// <returns>
        /// cscd コースコード
        /// csname コース名
        /// webcolor webカラー
        /// orgcd1 団体コード1
        /// orgcd2 団体コード2
        /// orgname 団体名称
        /// cslcount 受診者数
        /// </returns>
        public List<dynamic> SelectConsultSchedule(long mode, DateTime cslDate)
        {
            string sql = "";            // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);

            // 指定受診日のコース別・団体別受診者数を取得する
            sql = @"
                    select
                        basecount.cscd
                        , course_p.csname
                        , course_p.webcolor
                        , basecount.orgcd1
                        , basecount.orgcd2
                        , org.orgname
                        , basecount.cslcount
                    from
                        org
                        , course_p
                        , (
                        select
                            cscd
                            , orgcd1
                            , orgcd2
                            , count(rsvno) cslcount
                        from
                            consult
                        where
                            csldate = :csldate
                        group by
                            cube (cscd, orgcd1, orgcd2)
                        ) basecount
            ";

            // CUBE関数で取得したデータのうち、取得モードに応じたレコードのみを取得
            switch (mode)
            {
                case 1:
                    // 団体別
                    sql += @"
                            where
                              basecount.orgcd1 is not null
                              and basecount.orgcd2 is not null
                              and basecount.cscd is null
                    ";
                    break;
                case 2:
                case 3:
                    // コース・団体別、団体・コース別
                    sql += @"
                            where
                              basecount.orgcd1 is not null
                              and basecount.orgcd2 is not null
                              and basecount.cscd is not null
                    ";
                    break;
                default:
                    // コース別
                    sql += @"
                            where
                              basecount.orgcd1 is null
                              and basecount.orgcd2 is null
                              and basecount.cscd is not null
                    ";
                    break;
            }

            // コース・団体の結合
            sql += @"
                              and basecount.cscd = course_p.cscd(+)
                              and basecount.orgcd1 = org.orgcd1(+)
                              and basecount.orgcd2 = org.orgcd2(+)
            ";

            // ORDER BY句の指定
            switch (mode)
            {
                case 3:
                    // 団体・コース別
                    sql += @"
                            order by
                              basecount.orgcd1
                              , basecount.orgcd2
                              , basecount.cscd
                    ";
                    break;
                default:
                    // コース別、団体別、コース・団体別
                    sql += @"
                            order by
                              basecount.cscd
                              , basecount.orgcd1
                              , basecount.orgcd2
                    ";
                    break;

            }

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// コース受診予約群をもつコースのみを取得
        /// </summary>
        /// <returns>
        /// cscd コースコード
        /// csname コース名
        /// cssname コース略称
        /// </returns>
        public List<dynamic> SelectCourseListRsvGrpManaged()
        {
            string sql = "";        // SQLステートメント

            // コース受診予約群を持つコースのみを取得
            sql = @"
                    select
                      course_p.cscd
                      , course_p.csname
                      , course_p.cssname
                    from
                      course_p
                    where
                      exists (
                        select
                          course_rsvgrp.cscd
                        from
                          course_rsvgrp
                        where
                          course_rsvgrp.cscd = course_p.cscd
                      )
                    order by
                      course_p.cscd
            ";

            // 戻り値の設定
            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 指定コースの予約群を取得する
        /// </summary>
        /// <param name="csCd">コースコード</param>
        /// <param name="rsvGrpCd">予約群コード</param>
        /// <returns>
        /// mnggender 男女別枠管理
        /// defcnt 共通人数
        /// defcnt_m 男人数
        /// defcnt_f 女人数
        /// defcnt_sat 土曜共通人数
        /// defcnt_sat_m 土曜男人数
        /// defcnt_sat_f  土曜女人数
        /// </returns>
        public dynamic SelectCourseRsvGrp(string csCd, long rsvGrpCd)
        {
            string sql = "";        // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("cscd", csCd);
            param.Add("rsvgrpcd", rsvGrpCd);

            // 指定コースの予約群をコース受診予約群テーブルから取得
            sql = @"
                    select
                      course_rsvgrp.rsvgrpcd
                      , course_rsvgrp.cscd
                      , course_rsvgrp.mnggender
                      , course_rsvgrp.defcnt
                      , course_rsvgrp.defcnt_m
                      , course_rsvgrp.defcnt_f
                      , course_rsvgrp.defcnt_sat
                      , course_rsvgrp.defcnt_sat_m
                      , course_rsvgrp.defcnt_sat_f
                    from
                      course_rsvgrp
                    where
                      course_rsvgrp.cscd = :cscd
                      and course_rsvgrp.rsvgrpcd = :rsvgrpcd
            ";

            // 戻り値の設定
            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 指定コースの予約群を取得する
        /// </summary>
        /// <param name="csCd">コースコード</param>
        /// <param name="sortOrder">ソート順(0:予約群コード順、0以外:開始時間順)</param>
        /// <returns>
        /// rsvgrpcd 予約群コード
        /// rsvgrpname 予約群名称
        /// strtime 開始時間
        /// </returns>
        public List<dynamic> SelectCourseRsvGrpListSelCourse(string csCd, long sortOrder)
        {
            string sql = "";        // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("cscd", csCd);

            // 指定コースの予約群をコース受診予約群テーブルから取得
            sql = @"
                    select
                      course_rsvgrp.rsvgrpcd
                      , rsvgrp.rsvgrpname
                      , rsvgrp.strtime
                    from
                      rsvgrp
                      , course_rsvgrp
                    where
                      course_rsvgrp.cscd = :cscd
                      and course_rsvgrp.rsvgrpcd = rsvgrp.rsvgrpcd
            ";

            if (sortOrder == 0)
            {
                sql += @"
                        order by
                          course_rsvgrp.cscd
                          , course_rsvgrp.rsvgrpcd
                ";
            }
            else
            {
                sql += @"
                         order by
                          course_rsvgrp.cscd
                          , rsvgrp.strtime
                          , course_rsvgrp.rsvgrpcd
                ";
            }

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定予約枠コードの予約枠情報を取得する
        /// </summary>
        /// <param name="rsvFraCd">予約枠コード</param>
        /// <returns>
        /// rsvfraname 予約枠名称
        /// incopengrp オープン予約群検索
        /// </returns>
        public dynamic SelectRsvFra(string rsvFraCd)
        {
            string sql = "";        // SQLステートメント

            // 検索条件が設定されていない場合はエラー
            if (string.IsNullOrEmpty(rsvFraCd) || rsvFraCd.Trim().Equals(""))
            {
                throw new ArgumentException();
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvfracd", rsvFraCd);

            // 検索条件を満たす予約枠テーブルのレコードを取得
            sql = @"
                    select
                      rsvfraname
                      , incopengrp
                    from
                      rsvfra_p
                    where
                      rsvfracd = :rsvfracd
            ";

            // 戻り値の設定
            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 指定予約群コードの予約群情報を取得する
        /// </summary>
        /// <param name="rsvGrpCd">予約群コード</param>
        /// <returns>
        /// rsvgrpname 予約群名称
        /// strtime 開始時間
        /// endtime 終了時間
        /// rptendtime 健診受付終了時間
        /// lead 誘導対象
        /// strdayid 当日開始ID
        /// enddayid 当日終了ID
        /// isopengrp オープン枠予約群
        /// </returns>
        public dynamic SelectRsvGrp(string rsvGrpCd)
        {
            string sql = "";        // SQLステートメント

            // 検索条件が設定されていない場合はエラー
            if (string.IsNullOrEmpty(rsvGrpCd) || rsvGrpCd.Trim().Equals(""))
            {
                throw new ArgumentException();
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvgrpcd", rsvGrpCd);

            // 検索条件を満たす予約枠テーブルのレコードを取得
            sql = @"
                    select
                      rsvgrpname
                      , strtime
                      , endtime
                      , rptendtime
                      , lead
                      , strdayid
                      , enddayid
                      , rsvsetgrpcd
                      , isopengrp
                    from
                      rsvgrp
                    where
                      rsvgrpcd = :rsvgrpcd
            ";

            // 戻り値の設定
            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 予約枠の一覧を取得する
        /// </summary>
        /// <param name="rsvFraCd">予約枠コード</param>
        /// <param name="fraType">枠管理タイプ（0:コース、1:検査項目）</param>
        /// <returns>
        /// itemcode 項目コード（コースコード or 検査項目
        /// itemname 項目名（コース名 or 依頼項目名）
        /// cscd 枠管理対象コースコード（省略可）
        /// </returns>
        public List<dynamic> SelectRsvFraItemList(string rsvFraCd, int fraType)
        {
            string sql = "";        // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvfracd", rsvFraCd);

            // 枠タイプによりSQL変更
            if (fraType != Convert.ToInt16(FraType.Cs))
            {
                // コース枠管理の場合
                sql = @"
                        select
                          course_p.cscd itemcode
                          , course_p.csname itemname
                          , targetrsvfra_c.cscd cscd
                        from
                          course_p
                          , (
                            select
                              cscd
                            from
                              rsvfra_c
                            where
                              rsvfra_c.rsvfracd = :rsvfracd
                          ) targetrsvfra_c
                        where
                          course_p.cscd = targetrsvfra_c.cscd(+)
                        order by
                          course_p.cscd
                ";
            }
            else
            {
                // 検査項目枠管理の場合
                sql = @"
                        select
                          rsvfra_i.itemcd itemcode
                          , item_p.requestname itemname
                          , '' cscd
                        from
                          item_p
                          , rsvfra_i
                        where
                          rsvfra_i.rsvfracd = :rsvfracd
                          and rsvfra_i.itemcd = item_p.itemcd
                ";
            }

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 予約枠の一覧を取得する
        /// </summary>
        /// <returns>
        /// rsvfracd 予約枠コード
        /// rsvfraname 予約枠名称
        /// </returns>
        public List<dynamic> SelectRsvFraList()
        {
            string sql = "";        // SQLステートメント

            // 予約枠テーブルの全レコードを取得
            sql = @"
                    select
                      rsvfracd
                      , rsvfraname
                    from
                      rsvfra_p
                    order by
                      rsvfracd
            ";

            // 戻り値の設定
            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// すべての予約群を取得する
        /// </summary>
        /// <param name="sortOrder">ソート順(0:予約群コード順、0以外:開始時間順)</param>
        /// <returns>
        /// rsvgrpcd 予約群コード
        /// rsvgrpname 予約群名称
        /// strtime 開始時間
        /// endtime 終了時間
        /// rptendtime 健診受付時間
        /// </returns>
        public List<dynamic> SelectRsvGrpList(long sortOrder)
        {
            string sql = "";        // SQLステートメント

            // 予約群テーブルのすべてのレコードを取得
            sql = @"
                    select
                      rsvgrpcd
                      , rsvgrpname
                      , strtime
                      , endtime
                      , rptendtime
                    from
                      rsvgrp
            ";

            if (sortOrder == 0)
            {
                sql += @"
                        order by
                          rsvgrpcd
                ";
            }
            else
            {
                sql += @"
                        order by
                          strtime
                          , rsvgrpcd
                ";
            }

            // 戻り値の設定
            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// すべてのコース予約群を取得する
        /// </summary>
        /// <returns>
        /// rsvgrpcd 予約群コード
        /// cscd コースコード
        /// mnggender 男女別枠管理
        /// defCnt 共通人数
        /// defCnt_m 男人数
        /// defCnt_f 女人数
        /// defCnt_sat 土曜共通人数
        /// defCnt_sat_m 土曜男人数
        /// defCnt_sat_f 土曜女人数f
        /// rsvgrpname 予約群名称
        /// csname コース名
        /// </returns>
        public List<dynamic> SelectCrsRsvGrpList()
        {
            string sql = "";        // SQLステートメント

            // 予約群テーブルのすべてのレコードを取得
            sql = @"
                    select
                      course_rsvgrp.rsvgrpcd rsvgrpcd
                      , course_rsvgrp.cscd cscd
                      , course_rsvgrp.mnggender mnggender
                      , course_rsvgrp.defcnt defcnt
                      , course_rsvgrp.defcnt_m defcnt_m
                      , course_rsvgrp.defcnt_f defcnt_f
                      , course_rsvgrp.defcnt_sat defcnt_sat
                      , course_rsvgrp.defcnt_sat_m defcnt_sat_m
                      , course_rsvgrp.defcnt_sat_f defcnt_sat_f
                      , rsvgrp.rsvgrpname rsvgrpname
                      , course_p.csname csname
                    from
                      course_rsvgrp
                      , rsvgrp
                      , course_p
                    where
                      course_rsvgrp.rsvgrpcd = rsvgrp.rsvgrpcd
                      and course_rsvgrp.cscd = course_p.cscd
                    order by
                      course_rsvgrp.cscd
                      , course_rsvgrp.rsvgrpcd
            ";

            // 戻り値の設定
            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 検索条件に従って予約人数管理情報の一覧を取得する
        /// </summary>
        /// <param name="startCslDate">検索条件受診日（開始）</param>
        /// <param name="endCslDate">検索条件受診日（終了）</param>
        /// <param name="searchCsCd">検索条件コースコード</param>
        /// <param name="searchRsvGrp">検索条件予約群</param>
        /// <returns>
        /// csldate 受診日
        /// cscd コースコード
        /// csname コース名
        /// webcolor コース色
        /// rsvgrpcd 予約群コード
        /// rsvgrpname 予約群名称
        /// mnggender 男女別枠管理
        /// maxcnt 予約可能人数（共通）
        /// maxcnt_m 予約可能人数（男）
        /// maxcnt_f 予約可能人数（女）
        /// overcnt オーバ可能人数（共通）
        /// overcnt_m オーバ可能人数（男）
        /// overcnt_f オーバ可能人数（女）
        /// rsvcnt_m 予約済み人数（男）
        /// rsvcnt_f 予約済み人数（女）
        /// </returns>
        public List<dynamic> SelectRsvFraMngList(string startCslDate, string endCslDate, string searchCsCd, string searchRsvGrp)
        {
            string sql = "";        // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            if (DateTime.Parse(startCslDate) <= DateTime.Parse(endCslDate))
            {
                param.Add("scsldate", string.Format(startCslDate, "yyyy/MM/dd"));
                param.Add("ecsldate", string.Format(endCslDate, "yyyy/MM/dd"));
            }
            else
            {
                param.Add("scsldate", string.Format(endCslDate, "yyyy/MM/dd"));
                param.Add("ecsldate", string.Format(startCslDate, "yyyy/MM/dd"));
            }

            // 検索条件のレコードを取得
            sql = @"
                    select
                        rsvframng.csldate
                        , rsvframng.cscd
                        , course_p.csname
                        , course_p.webcolor
                        , rsvframng.rsvgrpcd
                        , rsvgrp.rsvgrpname
                        , course_rsvgrp.mnggender
                        , rsvframng.maxcnt
                        , rsvframng.maxcnt_m
                        , rsvframng.maxcnt_f
                        , rsvframng.overcnt
                        , rsvframng.overcnt_m
                        , rsvframng.overcnt_f
                        , rsvframng.rsvcnt_m
                        , rsvframng.rsvcnt_f
                    from
                        rsvframng
                        , course_p
                        , rsvgrp
                        , course_rsvgrp
                    where
                        rsvframng.csldate >= :scsldate
                        and rsvframng.csldate <= :ecsldate
            ";

            // コース指定あり？
            if (!string.IsNullOrEmpty(searchCsCd))
            {
                param.Add("searchCsCd", searchCsCd.Trim());
                sql += @"
                        and rsvframng.cscd = :searchCsCd
                ";
            }

            // 予約群指定あり？
            if (!string.IsNullOrEmpty(searchRsvGrp))
            {
                param.Add("searchRsvGrp", searchRsvGrp.Trim());
                sql += @"
                        and rsvframng.rsvgrpcd = :searchRsvGrp
                ";
            }

            sql += @"
                        and course_p.cscd(+) = rsvframng.cscd
                        and rsvgrp.rsvgrpcd(+) = rsvframng.rsvgrpcd
                        and course_rsvgrp.cscd = rsvframng.cscd
                        and course_rsvgrp.rsvgrpcd = rsvframng.rsvgrpcd
            ";

            sql += @"
                    order by
                      rsvframng.csldate
                      , rsvframng.cscd
                      , rsvframng.rsvgrpcd
            ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 検索条件に従って予約人数管理情報の一覧を取得する
        /// </summary>
        /// <param name="strCslDate">開始受診日</param>
        /// <param name="endCslDate">終了受診日</param>
        /// <param name="selCsCd">コースコード</param>
        /// <returns>
        /// csldate 受診日
        /// holiday 休診日
        /// rsvgrpcd 予約群コード
        /// rsvgrpname 予約群名称
        /// strtime 開始時間
        /// cscd コースコード
        /// csname コース名
        /// cssname コース略称
        /// webcolor webカラー
        /// mnggender 男女別枠管理
        /// maxcnt 予約可能人数（共通）
        /// maxcnt_m 予約可能人数（男）
        /// maxcnt_f 予約可能人数（女）
        /// overcnt オーバ可能人数（共通）
        /// overcnt_m オーバ可能人数（男）
        /// overcnt_f オーバ可能人数（女）
        /// rsvcnt_m 予約済み人数（男）
        /// rsvcnt_f 予約済み人数（女）
        /// </returns>
        public List<dynamic> SelectRsvFraMngList_Capacity(DateTime strCslDate, DateTime endCslDate, List<string> selCsCd)
        {
            string sql = "";                // SQLステートメント

            DateTime cslDate;               // 受診日
            List<DateTime> paraCslDate;     // 受診日
            Int32 arraySize;                // 配列の要素数

            bool exists = false;            // 存在フラグ

            Int32 transno = 0;              // トランザクション番号

            paraCslDate = new List<DateTime>();

            using (var transaction = BeginTransaction())
            {
                try
                {
                    // 戻り値
                    List<dynamic> retData = new List<dynamic>();

                    using (var cmd = new OracleCommand())
                    {

                        OracleParameter objTransno = cmd.Parameters.Add("transno", OracleDbType.Int32, null, ParameterDirection.InputOutput);

                        // トランザクション番号の取得
                        sql = @"
                                begin :transno := contractpackage.gettransno;
                                end;
                        ";

                        ExecuteNonQuery(cmd, sql);

                        // トランザクション番号
                        transno = ((OracleDecimal)objTransno.Value).ToInt32();
                    }
                    using (var cmd1 = new OracleCommand())
                    {

                        // 受診日の大小を比較し、逆転時は入れ替える
                        if (endCslDate < strCslDate)
                        {
                            cslDate = endCslDate;
                            endCslDate = strCslDate;
                            strCslDate = cslDate;
                        }

                        // 配列の要素数を計算
                        TimeSpan span = endCslDate - strCslDate;
                        arraySize = span.Days + 1;

                        // 引数値の値設定
                        cslDate = strCslDate;
                        while (cslDate <= endCslDate)
                        {
                            paraCslDate.Add(cslDate);
                            cslDate = cslDate.AddDays(1);
                        }
                        cmd1.Parameters.AddTable("csldate", paraCslDate.ToArray(), ParameterDirection.Input, OracleDbType.Date, arraySize, 10);
                        cmd1.Parameters.Add("transno", OracleDbType.Int32, transno, ParameterDirection.Input);

                        // 受診日一時表の作成
                        sql = @"
                                begin contractpackage.createcsldate(:transno, :csldate);
                                end;
                        ";

                        ExecuteNonQuery(cmd1, sql);

                        sql = @"
                                select
                                  baseinfo.csldate
                                  , schedule_h.holiday
                                  , baseinfo.rsvgrpcd
                                  , baseinfo.rsvgrpname
                                  , baseinfo.strtime
                                  , baseinfo.cscd
                                  , course_p.csname
                                  , course_p.cssname
                                  , course_p.webcolor
                                  , course_rsvgrp.mnggender
                                  , rsvframng.maxcnt
                                  , rsvframng.maxcnt_m
                                  , rsvframng.maxcnt_f
                                  , rsvframng.overcnt
                                  , rsvframng.overcnt_m
                                  , rsvframng.overcnt_f
                                  , rsvframng.rsvcnt_m
                                  , rsvframng.rsvcnt_f
                            ";

                        sql += @"
                                from
                                  rsvframng
                                  , course_rsvgrp
                                  , course_p
                                  , schedule_h
                                  , (
                                    select
                                      csldate_temp.csldate
                                      , rsvgrp.rsvgrpcd
                                      , rsvgrp.rsvgrpname
                                      , rsvgrp.strtime
                                      , mngcourse.cscd
                                    from
                                      rsvgrp
                                      , (
                                        select
                                          cscd
                                        from
                                          course_rsvgrp
                                        union
                                        select
                                          cscd
                                        from
                                          rsvframng
                                        where
                                          csldate between :strcsldate and :endcsldate
                                      ) mngcourse
                                      , csldate_temp
                                    where
                                      csldate_temp.transno = :transno
                                  ) baseinfo
                            ";

                        sql += @"
                                where
                                  baseinfo.csldate = schedule_h.csldate(+)
                                  and baseinfo.cscd = course_p.cscd
                                  and baseinfo.cscd = course_rsvgrp.cscd(+)
                                  and baseinfo.rsvgrpcd = course_rsvgrp.rsvgrpcd(+)
                                  and baseinfo.csldate = rsvframng.csldate(+)
                                  and baseinfo.cscd = rsvframng.cscd(+)
                                  and baseinfo.rsvgrpcd = rsvframng.rsvgrpcd(+)
                                order by
                                  baseinfo.csldate
                                  , baseinfo.rsvgrpcd
                                  , baseinfo.cscd
                            ";

                        // キー及び更新値の設定
                        var param = new Dictionary<string, object>();
                        param.Add("strcsldate", strCslDate);
                        param.Add("endcsldate", endCslDate);
                        param.Add("transno", transno);

                        List<dynamic> current = connection.Query(sql, param).ToList();

                        // 配列でコースが渡されていない場合は対象としない
                        if (selCsCd != null)
                        {
                            // 配列形式で格納する
                            for (int i = 0; i < current.Count; i++)
                            {
                                while (true)
                                {
                                    exists = false;


                                    // 現レコードのコースが引数指定されたそれに含まれるかを検索
                                    for (int j = 0; j < selCsCd.Count; j++)
                                    {
                                        if (selCsCd[j].Equals(Convert.ToString(current[i].CSCD)))
                                        {
                                            exists = true;
                                            break;
                                        }
                                    }

                                    // 含まれない場合はスキップ
                                    if (!exists)
                                    {
                                        break;
                                    }

                                    retData.Add(current[i]);

                                    break;
                                }
                            }
                        }

                    }
                    using (var cmd2 = new OracleCommand())
                    {
                        // 受診日一時表のクリア
                        sql = @"
                                begin contractpackage.clear(:transno);
                                end;
                        ";

                        cmd2.Parameters.Add("transno", OracleDbType.Int32, transno, ParameterDirection.Input);

                        ExecuteNonQuery(cmd2, sql);

                        transaction.Commit();

                    }
                    return retData;
                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();

                    return null;
                }
            }

        }

        /// <summary>
        /// 予約人数管理情報を登録する
        /// </summary>
        /// <param name="mode">モード insert:新規、update:修正</param>
        /// <param name="data">
        /// csldate 受診日
        /// cscd コースコード
        /// rsvgrpcd 予約群コード
        /// maxcnt 予約可能人数（共通）
        /// maxcnt_m 予約可能人数（男）
        /// maxcnt_f 予約可能人数（女）
        /// overcnt オーバ可能人数（共通）
        /// overcnt_m オーバ可能人数（男）
        /// overcnt_f オーバ可能人数（女）
        /// </param>
        /// <param name="messages">エラーメッセージの集合</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateRsvFraMngInfo(string mode, RsvFraMng data, ref List<dynamic> messages)
        {
            string sql = "";         // SQLステートメント
            long ret2;               // 戻り値

            // 変数として定義
            long rsvCnt_M;          // 予約済み人数（男）
            long rsvCnt_F;          // 予約済み人数（女）

            Insert ret = Insert.Error;

            // モードにより処理判断
            switch (mode)
            {
                case "insert":
                    ret2 = InsertRsvFraMng(data);
                    break;
                case "update":
                    ret2 = UpdateRsvFraMng(data);
                    break;
                default:
                    throw new ArgumentException();
            }

            switch (ret2)
            {
                case -1:
                    messages.Add("指定のコース、予約群の組み合わせは存在しません。");
                    break;
                case -2:
                    messages.Add("共通人数は入力できません。コース受診予約群マスタの設定を確認してください。");
                    break;
                case -3:
                    messages.Add("男女別人数は入力できません。コース受診予約群マスタの設定を確認してください。");
                    break;
                case -4:
                    messages.Add("入力された受診日、コース、予約群はすでに枠設定されています。");
                    break;
                default:
                    break;
            }

            if (messages == null)
            {
                // キー及び更新値の設定
                var param = new Dictionary<string, object>();
                param.Add("csldate", Convert.ToDateTime(data.CslDate));
                param.Add("cscd", Convert.ToString(data.CsCd));
                param.Add("rsvgrpcd", Convert.ToInt64(data.RsvGrpCd));

                // 予約人数を計算(存在しない場合は０)
                sql = @"
                    select
                      nvl(sum(realrsvframng.rsvcnt_m), 0) rsvcnt_m
                      , nvl(sum(realrsvframng.rsvcnt_f), 0) rsvcnt_f
                ";

                // web予約から得られる予約人数情報
                sql += @"
                    from
                      (
                        select
                          web_rsvframng.csldate
                          , web_rsvframng.cscd
                          , web_rsvframng.rsvgrpcd
                          , count(
                            decode(
                              v_web_yoyaku.sexflg
                              , 1
                              , v_web_yoyaku.webno
                              , null
                            )
                          ) rsvcnt_m
                          , count(
                            decode(
                              v_web_yoyaku.sexflg
                              , 2
                              , v_web_yoyaku.webno
                              , null
                            )
                          ) rsvcnt_f
                        from
                          webreserve.v_web_yoyaku
                          , webreserve.web_rsvframng
                        where
                          web_rsvframng.csldate = :csldate
                          and web_rsvframng.csldate = v_web_yoyaku.jdate
                          and web_rsvframng.webno = v_web_yoyaku.webno
                          and v_web_yoyaku.ykbn != 2
                        group by
                          web_rsvframng.csldate
                          , web_rsvframng.cscd
                          , web_rsvframng.rsvgrpcd
                ";

                // web予約から得られる予約人数情報と受診情報から得られる予約人数情報とをUNION ALL結合(最後にSUM関数で和をとる)
                sql += @"
                        union all
                ";

                // 受診情報から得られる予約人数情報
                sql += @"
                        select
                          subquery.csldate
                          , subquery.cscd
                          , subquery.rsvgrpcd
                ";

                // 先にUNION ALLで指定しているため、同一予約番号にて複数存在するコース、予約群に関しては重複を１つとしてカウント
                // かつNULL値がカウントされない性質を利用し、性別による振り分けを行う
                sql += @"
                          , count(
                              distinct decode(person.gender, 1, subquery.rsvno, null)
                          ) rsvcnt_m
                          , count(
                              distinct decode(person.gender, 2, subquery.rsvno, null)
                          ) rsvcnt_f
                          from
                            person
                ";

                // 受診情報本体から枠管理されるコース、予約群を取得
                sql += @"
                            , (
                                  select
                                    consult.rsvno
                                    , consult.csldate
                                    , consult.cscd
                                    , consult.rsvgrpcd
                                    , consult.perid
                                    , consult.cancelflg
                                  from
                                    consult
                ";

                // 後で重複は除きつつカウントするためここではUNION ALL指定(２回ソート処理が走るのは嫌)
                sql += @"
                                 union all
                ";

                // セット情報から枠管理されるコース、予約群を取得
                sql += @"
                                 select
                                     consult.rsvno
                                     , consult.csldate
                                     , rsvfra_c.cscd
                                     , consult.rsvgrpcd
                                     , consult.perid
                                     , consult.cancelflg
                                 from
                                     rsvfra_c
                                     , ctrpt_opt
                                     , consult_o
                                     , consult
                                 where
                                     consult.rsvno = consult_o.rsvno
                                     and consult_o.ctrptcd = ctrpt_opt.ctrptcd
                                     and consult_o.optcd = ctrpt_opt.optcd
                                     and consult_o.optbranchno = ctrpt_opt.optbranchno
                                     and ctrpt_opt.rsvfracd = rsvfra_c.rsvfracd
                ";

                // ここも先と同様、UNION ALL指定
                sql += @"
                                 union all
                ";

                // セット情報から枠管理されるコースと、そのオープン枠予約群を取得
                sql += @"
                                 select
                                   consult.rsvno
                                   , consult.csldate
                                   , rsvfra_c.cscd
                                   , rsvgrp.rsvgrpcd
                                   , consult.perid
                                   , consult.cancelflg
                                 from
                                   rsvgrp
                                   , rsvframng
                                   , rsvfra_c
                                   , rsvfra_p
                                   , ctrpt_opt
                                   , consult_o
                                   , consult
                                 where
                                   consult.rsvno = consult_o.rsvno
                                   and consult_o.ctrptcd = ctrpt_opt.ctrptcd
                                   and consult_o.optcd = ctrpt_opt.optcd
                                   and consult_o.optbranchno = ctrpt_opt.optbranchno
                ";

                // 予約枠テーブルを結合し、オープン枠予約群検索対象であるもののみ取得
                sql += @"
                                   and ctrpt_opt.rsvfracd = rsvfra_p.rsvfracd
                                   and rsvfra_p.incopengrp > 0
                ";

                // オープン枠予約群検索対象である予約枠のコースを取得
                sql += @"
                                   and ctrpt_opt.rsvfracd = rsvfra_c.rsvfracd
                ";

                // オープン枠予約群検索対象コースの、予約人数管理情報に登録されている全予約群を取得
                sql += @"
                                   and consult.csldate = rsvframng.csldate
                                   and rsvfra_c.cscd = rsvframng.cscd
                ";

                // オープン枠予約群検索対象コースの予約群のうち、オープン枠予約群のみを取得
                // (オープン枠予約群である予約人数管理レコードが存在しない場合は枠管理対象としない)
                sql += @"
                                   and rsvframng.rsvgrpcd = rsvgrp.rsvgrpcd
                                   and rsvgrp.isopengrp > 0
                              ) subquery
                ";

                // ここでキャンセル者は除きつつ､性別ごとの件数を取得するため個人情報を結合
                sql += @"
                          where
                            subquery.csldate = :csldate
                            and subquery.cancelflg =
                            and subquery.perid = person.perid
                          group by
                            subquery.csldate
                            , subquery.cscd
                            , subquery.rsvgrpcd
                ";

                // 指定コース、予約群のweb予約・受診情報の予約人数の和をとる
                sql += @"
                      ) realrsvframng
                    where
                        realrsvframng.cscd = :cscd
                        and realrsvframng.rsvgrpcd = :rsvgrpcd
                ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 検索レコードが存在する場合
                if (current != null)
                {
                    rsvCnt_M = long.Parse(current.RSVCNT_M);
                    rsvCnt_F = long.Parse(current.RSVCNT_F);
                }
                else
                {
                    rsvCnt_M = 0;
                    rsvCnt_F = 0;
                }

                // キー及び更新値の設定
                param.Add("rsvcnt_m", rsvCnt_M);
                param.Add("rsvcnt_f", rsvCnt_F);

                // 実績人数の更新
                sql = @"
                        update rsvframng
                        set
                          rsvcnt_m = :rsvcnt_m
                          , rsvcnt_f = :rsvcnt_f
                        where
                          csldate = :csldate
                          and cscd = :cscd
                          and rsvgrpcd = :rsvgrpcd
                ";
                connection.Execute(sql, param);
            }

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 予約人数管理情報を更新する
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// cscd コースコード
        /// rsvgrpcd 予約群コード
        /// maxcnt 予約可能人数（共通）
        /// maxcnt_m 予約可能人数（男）
        /// maxcnt_f 予約可能人数（女）
        /// overcnt オーバ可能人数（共通）
        /// overcnt_m オーバ可能人数（男）
        /// overcnt_f オーバ可能人数（女）
        /// </param>
        /// <returns>0:正常;-99:異常</returns>
        public long UpdateRsvFraMng(RsvFraMng data)
        {
            string sql = "";         // SQLステートメント
            long ret;               // 戻り値

            ret = -99;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Convert.ToDateTime(data.CslDate));
            param.Add("cscd", Convert.ToString(data.CsCd).Trim());
            param.Add("rsvgrpcd", Convert.ToString(data.RsvGrpCd).Trim());
            param.Add("maxcnt", Convert.ToString(data.MaxCnt).Trim());
            param.Add("maxcnt_m", Convert.ToString(data.MaxCnt_m).Trim());
            param.Add("maxcnt_f", Convert.ToString(data.MaxCnt_f).Trim());
            param.Add("overcnt", Convert.ToString(data.OverCnt).Trim());
            param.Add("overcnt_m", Convert.ToString(data.OverCnt_m).Trim());
            param.Add("overcnt_f", Convert.ToString(data.OverCnt_f).Trim());

            sql = @"
                    update rsvframng
                    set
                      rsvframng.maxcnt = :maxcnt
                      , rsvframng.maxcnt_m = :maxcnt_m
                      , rsvframng.maxcnt_f = :maxcnt_f
                      , rsvframng.overcnt = :overcnt
                      , rsvframng.overcnt_m = :overcnt_m
                      , rsvframng.overcnt_f = :overcnt_f
                    where
                      rsvframng.csldate = :csldate
                      and rsvframng.cscd = :cscd
                      and rsvframng.rsvgrpcd = :rsvgrpcd
            ";

            connection.Execute(sql, param);

            ret = 0;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 予約人数管理情報を挿入する
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// cscd コースコード
        /// rsvgrpcd 予約群コード
        /// maxcnt 予約可能人数（共通）
        /// maxcnt_m 予約可能人数（男）
        /// maxcnt_f 予約可能人数（女）
        /// overcnt オーバ可能人数（共通）
        /// overcnt_m オーバ可能人数（男）
        /// overcnt_f オーバ可能人数（女）
        /// </param>
        /// <returns>0:正常;-99:異常</returns>
        public long InsertRsvFraMng(RsvFraMng data)
        {
            string sql = "";        // SQLステートメント
            long ret;               // 戻り値
            dynamic ret2;           // 戻り値

            ret = -99;

            // コース、予約群の組み合わせの存在有無チェック
            ret2 = SelectCourseRsvGrp(Convert.ToString(data.CsCd), Convert.ToInt64(data.RsvGrpCd));
            if (ret2 == null)
            {
                ret = -1;
                return ret;
            }

            // 男女別管理する？
            if (Convert.ToInt64(ret2.MNGGENDER) == 1)
            {
                if (Convert.ToInt64(data.MaxCnt) > 0 || Convert.ToInt64(data.OverCnt) > 0)
                {
                    ret = -2;
                    return ret;
                }
            }
            else
            {
                if (Convert.ToInt64(data.MaxCnt_m) > 0 || Convert.ToInt64(data.MaxCnt_f) > 0
                    || Convert.ToInt64(data.OverCnt_m) > 0 || Convert.ToInt64(data.OverCnt_f) > 0)
                {
                    ret = -3;
                    return ret;
                }
            }

            // Insert前に存在チェック
            List<dynamic> retSelectRsvFraMng = SelectRsvFraMngList(Convert.ToString(data.CslDate), Convert.ToString(data.CslDate), Convert.ToString(data.CsCd).Trim(), Convert.ToString(data.RsvGrpCd));
            if (retSelectRsvFraMng != null && retSelectRsvFraMng.Count > 0)
            {
                ret = -4;
                return ret;
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Convert.ToDateTime(data.CslDate));
            param.Add("cscd", Convert.ToString(data.CsCd).Trim());
            param.Add("rsvgrpcd", Convert.ToString(data.RsvGrpCd).Trim());
            param.Add("maxcnt", Convert.ToString(data.MaxCnt).Trim());
            param.Add("maxcnt_m", Convert.ToString(data.MaxCnt_m).Trim());
            param.Add("maxcnt_f", Convert.ToString(data.MaxCnt_f).Trim());
            param.Add("overcnt", Convert.ToString(data.OverCnt).Trim());
            param.Add("overcnt_m", Convert.ToString(data.OverCnt_m).Trim());
            param.Add("overcnt_f", Convert.ToString(data.OverCnt_f).Trim());

            sql = @"
                    insert
                    into rsvframng(
                      csldate
                      , cscd
                      , rsvgrpcd
                      , maxcnt
                      , maxcnt_m
                      , maxcnt_f
                      , overcnt
                      , overcnt_m
                      , overcnt_f
                    )
                    values (
                      :csldate
                      , :cscd
                      , :rsvgrpcd
                      , :maxcnt
                      , :maxcnt_m
                      , :maxcnt_f
                      , :overcnt
                      , :overcnt_m
                      , :overcnt_f
                    )
                    ";

            connection.Execute(sql, param);

            ret = 0;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 予約人数管理情報を削除する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="rsvGrpCd">予約群コード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteRsvFraMng(DateTime cslDate, string csCd, int rsvGrpCd)
        {
            string sql = "";        // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            param.Add("cscd", csCd);
            param.Add("rsvgrpcd", rsvGrpCd);

            // データの削除
            sql = @"
                    delete rsvframng
                    where
                      rsvframng.csldate = :csldate
                      and rsvframng.cscd = :cscd
                      and rsvframng.rsvgrpcd = :rsvgrpcd
            ";

            connection.Execute(sql, param);

            // 戻り値の設定
            return true;

        }

        /// <summary>
        /// 指定期間の予約スケジューリング情報を取得する
        /// </summary>
        /// <param name="strDate">読み込み開始日付</param>
        /// <param name="endDate">読み込み終了日付</param>
        /// <param name="timeFra">時間枠</param>
        /// <param name="rsvFraCd">予約枠コード</param>
        /// <returns>
        /// csldate 受診日
        /// timefra 時間枠
        /// rsvfracd 予約枠コード
        /// emptycount 予約可能人数
        /// rsvcount 予約済み人数
        /// </returns>
        public dynamic SelectSchedule(string strDate, string endDate, string timeFra, string rsvFraCd)
        {
            string sql = "";                                // SQLステートメント

            // 検索条件が設定されていない場合はエラー
            if (!Information.IsDate(strDate.Trim()) || !Information.IsDate(endDate.Trim()))
            {
                throw new ArgumentException();
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("strdate", strDate.Trim());
            param.Add("enddate", endDate.Trim());
            // 時間枠指定あり
            if (!string.IsNullOrEmpty(timeFra) && !timeFra.Equals(""))
            {
                param.Add("timefra", timeFra.Trim());
            }
            // 予約枠コード指定あり
            if (!string.IsNullOrEmpty(rsvFraCd) && !rsvFraCd.Equals(""))
            {
                param.Add("rsvfracd", rsvFraCd.Trim());
            }

            // 検索条件を満たす予約スケジュールのレコードを取得
            sql = @"
                    select
                      to_char(csldate, 'yyyy/mm/dd') csldate
                      , timefra
                      , rsvfracd
                      , emptycount
                      , rsvcount
                    from
                      schedule
                    where
                      csldate >= :strdate
                      and csldate <= :enddate
            ";

            // 条件節・ソート順を追加
            if (!string.IsNullOrEmpty(timeFra) && !timeFra.Equals(""))
            {
                // 時間枠指定あり

                if (!string.IsNullOrEmpty(rsvFraCd) && !rsvFraCd.Equals(""))
                {
                    // 予約枠コード指定あり
                    sql = @"
                            and timefra = :timefra
                            and rsvfracd = :rsvfracd
                            order by
                              csldate
                    ";
                }
                else
                {
                    // 予約枠コード指定なし
                    sql = @"
                            and timefra = :timefra
                            order by
                              csldate
                              , rsvfracd
                    ";
                }
            }
            else
            {
                // 時間枠指定なし

                if (!string.IsNullOrEmpty(rsvFraCd) && !rsvFraCd.Equals(""))
                {
                    // 予約枠コード指定あり
                    sql = @"
                            and rsvfracd = :rsvfracd
                            order by
                              csldate
                              , timefra
                    ";
                }
                else
                {
                    // 予約枠コード指定なし
                    sql = @"
                            order by
                              csldate
                              , timefra
                              , rsvfracd
                    ";
                }
            }

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定期間の病院スケジューリング情報を取得する
        /// </summary>
        /// <param name="strDate">読み込み開始日付</param>
        /// <param name="endDate">読み込み終了日付</param>
        /// <returns>
        /// csldate 受診日
        /// holiday 休診日（１：休診日，２：祝日）
        /// </returns>
        public dynamic SelectSchedule_h(string strDate, string endDate)
        {
            string sql = "";                                // SQLステートメント

            // 検索条件が設定されていない場合はエラー
            if (!Information.IsDate(strDate.Trim()) || !Information.IsDate(endDate.Trim()))
            {
                throw new ArgumentException();
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("strdate", strDate.Trim());
            param.Add("enddate", endDate.Trim());

            // 検索条件を満たす病院スケジュールのレコードを取得
            sql = @"
                    select
                      csldate
                      , holiday
                    from
                      schedule_h
                    where
                      csldate >= :strdate
                      and csldate <= :enddate
                    order by
                      csldate
            ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// ひと月分の該当時間枠・該当予約枠の予約スケジューリングを一括更新する
        /// </summary>
        /// <param name="data">
        /// strdate 月始日付
        /// enddate 月末日付
        /// timefra 時間枠
        /// rsvfracd 予約枠コード
        /// </param>
        /// <param name="emptyCounts">月始日付～月末日付の設定値（"hidden":非表示，"":未設定，"0":予約不可，"1"～"999":予約可能）</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateSchedule(JToken data, List<string> emptyCounts)
        {
            string sql;             // SQLステートメント

            List<dynamic> ret2;
            string editDate;        // 日付編集用
            long rsvCount;          // 予約済み人数（カウント値）

            Insert ret = Insert.Error;

            // 引数が正しく設定されていない場合はエラー
            if (!Information.IsDate(Convert.ToString(data["strdate"]).Trim()) ||
                (!Information.IsDate(Convert.ToString(data["enddate"]).Trim())))
            {
                throw new ArgumentException();
            }
            if (emptyCounts == null)
            {
                throw new ArgumentException();
            }
            DateTime strDateTmp = DateTime.Parse(Convert.ToString(data["strdate"]).Trim());
            DateTime endDateTmp = DateTime.Parse(Convert.ToString(data["enddate"]).Trim());
            TimeSpan span = endDateTmp - strDateTmp;
            if (span.Days != emptyCounts.Count)
            {
                throw new ArgumentException();
            }

            // 指定予約枠コードの予約枠情報を取得
            ret2 = SelectRsvFra(Convert.ToString(data["rsvfracd"]));
            if (ret2.Count <= 0)
            {
                throw new ArgumentException();
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Convert.ToString(data["csldate"]).Trim());
            param.Add("timefra", Convert.ToInt64(data["timefra"]));
            param.Add("rsvfracd", Convert.ToString(data["rsvfracd"]).Trim());
            param.Add("emptycount", 0);
            param.Add("rsvcounT", 0);
            param.Add("cscd", " ");
            param.Add("orgcd1", " ");
            param.Add("orgcd2", " ");
            param.Add("orgcslcount", 0);
            param.Add("orgrsvcount", 0);

            // 処理対象日付
            editDate = Convert.ToString(data["strdate"]).Trim();

            // １日ごとに処理する
            for (int i = 0; i < emptyCounts.Count; i++)
            {
                // 削除時
                if (string.IsNullOrEmpty(emptyCounts[i].Trim()))
                {

                    // キー及び更新値の設定
                    param.Remove("csldate");
                    param.Add("csldate", editDate);

                    // 該当日・該当時間枠・該当予約枠の予約スケジューリングを削除
                    sql = @"
                            delete
                            from
                              schedule
                            where
                              csldate = :csldate
                              and timefra = :timefra
                              and rsvfracd = :rsvfracd
                    ";
                    connection.Execute(sql, param);

                    // 検査項目枠管理の場合
                    if (!Convert.ToString(data["fratype"]).Equals(FraType.Cs))
                    {
                        // 該当日・該当予約枠の団体予約検査項目枠も合わせて削除
                        sql = @"
                                delete
                                from
                                  orgrsv_ifra
                                where
                                  csldate = :csldate
                                  and rsvfracd = :rsvfracd
                        ";
                        connection.Execute(sql, param);
                    }
                }
                else
                {
                    // 保存時
                    if (Convert.ToString(emptyCounts[i]).Trim().Equals("hidden"))
                    {

                        // キー及び更新値の設定
                        param.Remove("csldate");
                        param.Add("csldate", editDate);

                        // 該当日・該当時間枠・該当予約枠の予約スケジューリングを検索（レコードロック）
                        sql = @"
                                select
                                  *
                                from
                                  schedule
                                where
                                  csldate = :csldate
                                  and timefra = :timefra
                                  and rsvfracd = :rsvfracd for update
                        ";

                        // 検索レコードが存在する場合（更新）
                        dynamic current = connection.Query(sql, param).FirstOrDefault();

                        if (current != null)
                        {
                            // 検索レコードが存在する場合（更新）

                            // キー及び更新値の設定
                            param.Add("emptycount", long.Parse(emptyCounts[i]));

                            // 該当日・該当時間枠・該当予約枠の予約スケジューリングを更新（予約可能人数）
                            sql = @"
                                    update schedule
                                    set
                                      emptycount = :emptycount
                                    where
                                      csldate = :csldate
                                      and timefra = :timefra
                                      and rsvfracd = :rsvfracd
                            ";
                            connection.Execute(sql, param);
                        }
                        else
                        {
                            // 検索レコードが存在しない場合（新規挿入）

                            //すでに登録されている予約済み人数をカウント（受診情報のみカウントするモード）
                            rsvCount = GetRsvCount(editDate, Convert.ToInt64(data["timefra"]), Convert.ToString(data["rsvfracd"]).Trim(), Convert.ToInt64(data["FraType)"]), false);

                            // キー及び更新値の設定
                            param.Add("emptycount", long.Parse(emptyCounts[i]));
                            param.Add("rsvcount", rsvCount);

                            // 該当日・該当時間枠・該当予約枠の予約スケジューリングを登録（新規挿入）
                            sql = @"
                                    insert
                                    into schedule(
                                      csldate
                                      , timefra
                                      , rsvfracd
                                      , emptycount
                                      , rsvcount
                                    )
                                    values (
                                      :csldate
                                      , :timefra
                                      , :rsvfracd
                                      , :emptycount
                                      , :rsvcount
                                    )
                            ";
                            connection.Execute(sql, param);

                            // 検査項目枠管理の場合
                            if (!Convert.ToInt64(data["fratype"]).Equals(FraType.Cs))
                            {
                                // 検索条件を満たす団体予約人数のレコードを取得（時間枠はサマリーする）
                                sql = @"
                                        select
                                          cscd
                                          , orgcd1
                                          , orgcd2
                                          , sum(cslcount) cslcount
                                        from
                                          orgrsv
                                        where
                                          csldate = :csldate
                                        group by
                                          cscd
                                          , orgcd1
                                          , orgcd2
                                ";
                                List<dynamic> current2 = connection.Query(sql, param).ToList();

                                // 検索レコードが存在する場合
                                if (current2.Count > 0)
                                {
                                    // 団体予約人数（時間枠はサマリー）１レコードごとに処理する
                                    for (int j = 0; j < current2.Count; j++)
                                    {
                                        // 団体予約検査項目枠が必要な場合
                                        bool checkorgrsvifra = CheckOrgRsv_iFra(editDate, Convert.ToString(current2[j]["cscd"]), Convert.ToString(current2[j]["orgcd1"]),
                                                                                Convert.ToString(current2[j]["orgcd2"]).Trim(), Convert.ToString(data["rsvfracd"]).Trim());
                                        if (checkorgrsvifra)
                                        {

                                            // キー及び更新値の設定
                                            param.Remove("cscd");
                                            param.Remove("orgcd1");
                                            param.Remove("orgcd2");
                                            param.Remove("orgcslcount");
                                            param.Remove("orgrsvcount");
                                            param.Add("cscd", Convert.ToString(current2[j]["cscd"]));
                                            param.Add("orgcd1", Convert.ToString(current2[j]["orgcd1"]));
                                            param.Add("orgcd2", Convert.ToString(current2[j]["orgcd2"]));
                                            param.Add("orgcslcount", Convert.ToInt64(current2[j]["orgcslcount"]));
                                            param.Add("orgrsvcount", GetRsvCount_iFra(editDate, Convert.ToString(current2[j]["cscd"]), Convert.ToString(current2[j]["orgcd1"]),
                                                                                        Convert.ToString(current2[j]["orgcd2"])));

                                            // 該当日・該当予約枠の団体予約検査項目枠を登録（新規挿入）
                                            sql = @"
                                                    insert
                                                    into orgrsv_ifra(
                                                      csldate
                                                      , cscd
                                                      , orgcd1
                                                      , orgcd2
                                                      , rsvfracd
                                                      , cslcount
                                                      , rsvcount
                                                    )
                                                    values (
                                                      :csldate
                                                      , :cscd
                                                      , :orgcd1
                                                      , :orgcd2
                                                      , :rsvfracd
                                                      , :orgcslcount
                                                      , :orgrsvcount
                                                    )
                                            ";
                                            connection.Execute(sql, param);

                                        }
                                    }
                                }
                            }
                        }
                    }

                    // 処理対象日付を１日進める
                    DateTime editDateTmp = DateTime.Parse(editDate).AddDays(1);
                    editDate = editDateTmp.ToString("yyyy/M/d");

                }

            }

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// ひと月分の病院スケジューリングを一括更新する
        /// </summary>
        /// <param name="strDate">月始日付</param>
        /// <param name="endDate">月末日付</param>
        /// <param name="holidays">月始日付～月末日付の設定値（0:未設定，1:休診日，2:祝日）</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateSchedule_h(string strDate, string endDate, IList<int> holidays)
        {
            string sql = "";            // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;
            string editDate;            // 日付編集用

            // 引数が正しく設定されていない場合はエラー
            if (!(Information.IsDate(strDate.Trim()) && Information.IsDate(endDate.Trim())))
            {
                throw new ArgumentException();
            }
            if (holidays == null || holidays.Count <= 0)
            {
                throw new ArgumentException();
            }
            DateTime strDateTmp = DateTime.Parse(strDate.Trim());
            DateTime endDateTmp = DateTime.Parse(endDate.Trim());
            TimeSpan span = endDateTmp - strDateTmp;
            if (span.Days + 1 != holidays.Count)
            {
                throw new ArgumentException();
            }

            using (var transaction = BeginTransaction())
            {
                try
                {
                    // キー及び更新値の設定
                    var param = new Dictionary<string, object>();
                    param.Add("date1", strDate.Trim());
                    param.Add("date2", endDate.Trim());
                    param.Add("holiday", 0);

                    // 該当月の病院スケジュールを全件削除
                    sql = @"
                            delete
                            from
                              schedule_h
                            where
                              csldate >= :date1
                              and csldate <= :date2
                    ";
                    ret2 = connection.Execute(sql, param);

                    // 処理対象日付
                    editDate = strDate.Trim();

                    // １日ごとに処理する
                    for (int i = 0; i < holidays.Count; i++)
                    {
                        // 休日・祝日が設定された場合
                        if (holidays[i] == Convert.ToInt16(Holiday.Cls) || holidays[i] == Convert.ToInt16(Holiday.Hol))
                        {
                            param.Remove("date1");
                            param.Remove("holiday");
                            param.Add("date1", editDate);
                            param.Add("holiday", holidays[i]);

                            // 該当日の病院スケジュールを登録
                            sql = @"
                                    insert
                                    into schedule_h(csldate, holiday)
                                    values (:date1, :holiday)
                            ";
                            connection.Execute(sql, param);

                        }

                        // 処理対象日付を１日進める
                        editDate = DateTime.Parse(editDate).AddDays(1).ToString("yyyy/M/d");
                    }

                    transaction.Commit();

                    ret = Insert.Normal;

                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();

                    ret = Insert.Error;
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// ひと月分の該当時間枠・該当予約枠の予約スケジューリングを一括更新する
        /// </summary>
        /// <param name="strCslDate">月始日付</param>
        /// <param name="endCslDate">月末日付</param>
        /// <param name="timeFra">時間枠</param>
        /// <param name="rsvFraCd">予約枠コード</param>
        /// <param name="emptyCount">月始日付～月末日付の設定値（"hidden":非表示，"":未設定，"0":予約不可，"1"～"999":予約可能）</param>
        /// <param name="message">メッセージ</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool UpdateSchedule_tk(DateTime strCslDate, DateTime endCslDate, int timeFra, string rsvFraCd, List<string> emptyCount, ref List<string> message)
        {
            string sql = "";        // SQLステートメント
            DateTime cslDate;       // 受診日
            OverRsv overRsv = 0;    // 予約枠情報（枠人数オーバー登録）

            // 指定予約枠コードの予約枠情報を取得
            dynamic data = SelectRsvFra(rsvFraCd);

            // キーおよび更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("strcsldate", strCslDate);
            param.Add("endcsldate", endCslDate);
            param.Add("timefra", timeFra);
            param.Add("rsvfracd", rsvFraCd);
            param.Add("csldate", 0);
            param.Add("emptycount", 0);

            // 指定期間、時間枠の予約枠レコードを削除
            sql = @"
                    delete schedule 
                    where
                      csldate between :strcsldate and :endcsldate 
                      and timefra = :timefra 
                      and rsvfracd = :rsvfracd
                 ";

            connection.Execute(sql, param);

            // 予約可能人数を検索
            for (int i = 0; i < emptyCount.Count; i++)
            {
                // 更新対象となる受診日を求める
                cslDate = strCslDate.AddDays(i);
                if (cslDate > endCslDate)
                {
                    break;
                }

                // 予約可能人数の設定値ごとの処理
                switch (emptyCount[i])
                {
                    case "":            // 未設定時は何もしない
                    case "hidden":      // 非表示時は何もしない

                    default:            // 上記以外

                        // 挿入SQL文の実行
                        param.Remove("emptycount");
                        param.Add("emptycount", emptyCount[i]);

                        // 該当日の病院スケジュールを登録
                        sql = @"
                                insert 
                                into schedule( 
                                  csldate
                                  , timefra
                                  , rsvfracd
                                  , emptycount
                                  , rsvcount
                                ) 
                                values ( 
                                  :csldate
                                  , :timefra
                                  , :rsvfracd
                                  , :emptycount
                                  , ( 
                                    select
                                      count(distinct rsvno) 
                                    from
                                      gettargetrsvfracd 
                                    where
                                      csldate = :csldate 
                                      and timefra = :timefra 
                                      and rsvfracd = :rsvfracd 
                                      and cancelflg = 0
                                  )
                                ) 
                             ";
                        connection.Execute(sql, param);
                        break;
                }
            }

            while (true)
            {
                // 枠を越えた人数の予約を許さない場合、以下でコミット前に本状態が発生しているかをチェックする
                if (overRsv != OverRsv.Deny)
                {
                    break;
                }

                // 予約可能人数より予約済み人数が上回るレコードを取得
                sql = @"
                        select
                          csldate
                          , rsvcount 
                        from
                          schedule 
                        where
                          csldate between :strcsldate and :endcsldate 
                          and timefra = :timefra 
                          and rsvfracd = :rsvfracd 
                          and emptycount < rsvcount 
                        order by
                          csldate
                          , timefra
                          , rsvfracd
                     ";

                List<dynamic> current = connection.Query(sql, param).ToList();

                // 検索レコードが存在しない場合は正常
                if (current == null)
                {
                    break;
                }

                List<string> messages = new List<string>();
                for (int i = 0; i < current.Count; i++)
                {
                    DateTime cslDate2 = current[i]["csldate"];
                    string rsvCount = current[i]["emptycount"];
                    messages.Add(cslDate2.Day.ToString() + "日にすでに" + rsvCount + "人の受診対象者が存在します。指定内容で設定できません。");
                }
                message = messages;
                break;
            }

            return true;
        }

        /// <summary>
        /// 計上日の取得する
        /// </summary>
        /// <param name="paymentDate">入金(返金)日付</param>
        /// <param name="closeDate">締め日</param>
        /// <returns>
        /// calcDate 計上日
        /// </returns>
        public DateTime GetCalcDate(DateTime paymentDate, DateTime closeDate)
        {
            // 計上日
            DateTime calcDate;
            // 取得する休診日・祝日の最終日
            DateTime endDate;

            // 日次締め日が入金(返金)日より過去の場合
            if (paymentDate > closeDate)
            {
                // 入金(返金)日をセット
                calcDate = paymentDate;
            }
            else
            {
                // 締め日に1日加算した日付を計上日に設定する
                calcDate = closeDate.AddDays(1);

                // 休診日・祝日の取得期間を6ヶ月にセット
                endDate = calcDate.AddMonths(6);

                // 指定期間の病院スケジューリング情報を取得する
                var ret = SelectSchedule_h(calcDate.ToString("d"), endDate.ToString("d"));

                // 締め日の次の日が休診日・祝日の場合、計上日は休診日・祝日明けの最初の営業日に設定する
                for (int i = 0, length = ret.Count; i < length; i++)
                {
                    // 計上日と休診日・祝日が同じ日の場合
                    if (calcDate == ret[i].CSLDATE)
                    {
                        calcDate = calcDate.AddDays(1);
                    }
                    else
                    {
                        break;
                    }
                }
            }

            return calcDate;
        }
    }
}