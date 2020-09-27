using Entity.Helper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// カレンダー情報データアクセスオブジェクト
    /// </summary>
    public class CalendarDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public CalendarDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 指定年月の予約空き状況取得
        /// </summary>
        /// <param name="mode">検索モード</param>
        /// <param name="cslYear">年</param>
        /// <param name="cslMonth">月</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="manCnt">人数</param>
        /// <param name="gender">性別</param>
        /// <param name="birth">生年月日</param>
        /// <param name="age">受診時年齢</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="cslDivCd">受診区分コード</param>
        /// <param name="rsvGrpCd">予約群コード</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="holiday">休診日</param>
        /// <param name="status">状態</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert GetEmptyCalendar(String mode, long cslYear, long cslMonth, List<dynamic> perId, List<dynamic> manCnt, List<dynamic> gender, List<dynamic> birth, List<dynamic> age, List<dynamic> csCd,
            List<dynamic> cslDivCd, List<dynamic> rsvGrpCd, List<dynamic> ctrPtCd, List<dynamic> optCd, List<dynamic> optBranchNo,
            ref List<DateTime> cslDate, ref List<decimal> holiday, ref List<string> status)
        {
            string sql = "";                                        // SQLステートメント

            Int32 inArraySize = 0;                                  //配列のサイズ
            List<string> localManCnt = new List<string>();          // 人数
            List<string> localGender = new List<string>();          // 性別
            List<string> localBirth = new List<string>();           // 生年月日
            List<string> localAge = new List<string>();             // 受診時年齢
            List<string> localRsvGrpCd = new List<string>();        // 予約群コード

            Int32 outArraySize = 0;                                 //配列のサイズ
            Insert ret = Insert.Error;

            // 戻り値の仮の配列として個人ＩＤの配列サイズを指定
            inArraySize = perId.Count;
            for (int i = 0; i < inArraySize; i++)
            {

                if (!string.IsNullOrEmpty(Util.ConvertToString(manCnt[i])))
                {
                    localManCnt.Add(long.Parse("0" + Util.ConvertToString(manCnt[i])));
                }
                else
                {
                    localManCnt.Add(null);
                }
                if (!string.IsNullOrEmpty(Util.ConvertToString(gender[i])))
                {
                    localGender.Add(long.Parse("0" + Util.ConvertToString(gender[i])));
                }
                else
                {
                    localGender.Add(null);
                }
                if (!string.IsNullOrEmpty(Util.ConvertToString(birth[i])))
                {
                    localBirth.Add(long.Parse("0" + Util.ConvertToString(birth[i])));
                }
                else
                {
                    localBirth.Add(null);
                }
                if (!string.IsNullOrEmpty(Util.ConvertToString(age[i])))
                {
                    localAge.Add(long.Parse("0" + Util.ConvertToString(age[i])));
                }
                else
                {
                    localAge.Add(null);
                }
                if (!string.IsNullOrEmpty(Util.ConvertToString(rsvGrpCd[i])))
                {
                    localRsvGrpCd.Add(long.Parse("0" + Util.ConvertToString(rsvGrpCd[i])));
                }
                else
                {
                    localRsvGrpCd.Add(null);
                }
            }

            using (var cmd = new OracleCommand())
            {
                // バインド変数の設定
                cmd.Parameters.Add("mode", mode);
                cmd.Parameters.Add("cslyear", cslYear);
                cmd.Parameters.Add("cslmonth", cslMonth);

                // バインド配列(引数)の設定
                cmd.Parameters.AddTable("perid", perId.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, inArraySize, (int)LengthConstants.LENGTH_PERSON_PERID);
                cmd.Parameters.AddTable("mancnt", localManCnt.ToArray(), ParameterDirection.Input, OracleDbType.Int32, inArraySize, 10);
                cmd.Parameters.AddTable("gender", localGender.ToArray(), ParameterDirection.Input, OracleDbType.Int32, inArraySize, 10);
                cmd.Parameters.AddTable("birth", localBirth.ToArray(), ParameterDirection.Input, OracleDbType.Date, inArraySize, 10);
                cmd.Parameters.AddTable("age", localAge.ToArray(), ParameterDirection.Input, OracleDbType.Int32, inArraySize, 10);
                cmd.Parameters.AddTable("csldivcd", cslDivCd.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, inArraySize, 12);
                cmd.Parameters.AddTable("cscd", csCd.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, inArraySize, (int)LengthConstants.LENGTH_COURSE_CSCD);
                cmd.Parameters.AddTable("rsvgrpcd", localRsvGrpCd.ToArray(), ParameterDirection.Input, OracleDbType.Int32, inArraySize, 10);
                cmd.Parameters.AddTable("ctrptcd", ctrPtCd.ToArray(), ParameterDirection.Input, OracleDbType.Int32, inArraySize, 10);
                cmd.Parameters.AddTable("optcd", optCd.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, inArraySize, 500);
                cmd.Parameters.AddTable("optbranchno", optBranchNo.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, inArraySize, 300);

                // バインド配列(戻り値)の設定
                outArraySize = 31;

                // バインド配列(戻り値)の設定
                OracleParameter sqlCslDate = cmd.Parameters.AddTable("csldate", ParameterDirection.Output, OracleDbType.Date, outArraySize, 10);
                OracleParameter sqlHoliDay = cmd.Parameters.AddTable("holiday", ParameterDirection.Output, OracleDbType.Decimal, outArraySize, 10);
                OracleParameter sqlStatus = cmd.Parameters.AddTable("status", ParameterDirection.Output, OracleDbType.Varchar2, outArraySize, 1);

                // ストアド呼び出し
                sql = @"
                        begin schedulepackage.getemptycalendar(
                          :mode
                          , :cslyear
                          , :cslmonth
                          , :perid
                          , :mancnt
                          , :gender
                          , :birth
                          , :age
                          , :csldivcd
                          , :cscd
                          , :rsvgrpcd
                          , :ctrptcd
                          , :optcd
                          , :optbranchno
                          , :csldate
                          , :holiday
                          , :status
                        );
                        end;
                ";

                // SQL実行
                ExecuteNonQuery(cmd, sql);

                // 戻り値の設定(エラーに関わらず戻す値)
                cslDate = ((OracleDate[])sqlCslDate.Value).Select(s => s.Value).ToList();
                holiday = ((OracleDecimal[])sqlHoliDay.Value).Select(s => s.Value).ToList();
                status = ((OracleString[])sqlStatus.Value).Select(s => s.Value).ToList();

            }

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 指定年月の予約空き状況取得(予約番号指定)
        /// </summary>
        /// <param name="mode">検索モード</param>
        /// <param name="cslYear">年</param>
        /// <param name="cslMonth">月</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="rsvGrpCd">予約群コード</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="holiday">休診日</param>
        /// <param name="status">状態</param>
        /// <returns>
        /// 0以上  日数
        /// -1     存在しない予約番号が指定された
        /// -2     受付済み、またはキャンセル受診情報が存在するため検索不能
        /// </returns>
        public long GetEmptyCalendarFromRsvNo(String mode, long cslYear, long cslMonth, List<dynamic> rsvNo, List<dynamic> rsvGrpCd,
            ref List<DateTime> cslDate, ref List<decimal?> holiday, ref List<string> status)
        {
            string sql = "";                                        // SQLステートメント
            long ret = 0;

            Int32 inArraySize = 0;                                  //配列のサイズ
            List<long?> localRsvGrpCd = new List<long?>();          // 予約群コード

            Int32 outArraySize = 0;                                 //配列のサイズ

            // 戻り値の仮の配列として予約番号の配列サイズを指定
            inArraySize = rsvNo.Count;

            // 引数値の値設定
            for (int i = 0; i < inArraySize; i++)
            {
                if (long.TryParse(Util.ConvertToString(rsvGrpCd[i]), out long tmpRsvGrpCd))
                {
                    localRsvGrpCd.Add(tmpRsvGrpCd);
                }
                else
                {
                    localRsvGrpCd.Add(null);
                }
            }

            using (var cmd = new OracleCommand())
            {
                // バインド変数の設定
                cmd.Parameters.Add("mode", mode);
                cmd.Parameters.Add("cslyear", cslYear);
                cmd.Parameters.Add("cslmonth", cslMonth);

                // バインド配列(引数)の設定
                cmd.Parameters.AddTable("rsvno", rsvNo.ToArray(), ParameterDirection.Input, OracleDbType.Int32, inArraySize, (int)LengthConstants.LENGTH_PERSON_PERID);
                cmd.Parameters.AddTable("rsvgrpcd", rsvGrpCd.ToArray(), ParameterDirection.Input, OracleDbType.Int32, inArraySize, 10);

                // 戻り値の仮の配列として日数の最大値である31を設定
                outArraySize = 31;

                // バインド変数(戻り値)の設定
                OracleParameter sqlRet = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                // バインド配列(戻り値)の設定
                OracleParameter sqlCslDate = cmd.Parameters.AddTable("csldate", ParameterDirection.Output, OracleDbType.Date, outArraySize, 10);
                OracleParameter sqlHoliDay = cmd.Parameters.AddTable("holiday", ParameterDirection.Output, OracleDbType.Decimal, outArraySize, 10);
                OracleParameter sqlStatus = cmd.Parameters.AddTable("status", ParameterDirection.Output, OracleDbType.Varchar2, outArraySize, 1);

                // ストアド呼び出し
                sql = @"
                        begin :ret := schedulepackage.getemptycalendarfromrsvno(
                          :mode
                          , :cslyear
                          , :cslmonth
                          , :rsvno
                          , :rsvgrpcd
                          , :csldate
                          , :holiday
                          , :status
                        );
                        end;
                ";

                // SQL実行
                ExecuteNonQuery(cmd, sql);

                // 戻り値の設定(エラーに関わらず戻す値)
                OracleDate[] dbCslDate = (OracleDate[])sqlCslDate.Value;
                cslDate = dbCslDate == null ? new List<DateTime>() : dbCslDate.Select(s => s.Value).ToList();

                OracleDecimal[] dbHoliday = (OracleDecimal[])sqlHoliDay.Value;
                holiday = dbHoliday == null ? new List<decimal?>() : dbHoliday.Select(s => s.IsNull ? null : (decimal?)s.Value).ToList();

                OracleString[] dbSqlStatus = (OracleString[])sqlStatus.Value;
                status = dbSqlStatus == null ? new List<string>() : dbSqlStatus.Select(s => s.Value).ToList();

                ret = ((OracleDecimal)sqlRet.Value).ToInt32();

            }


            // 戻り値の設定
            // ストアドが正常終了していればデータ件数を返す
            return ret == 0 ? cslDate.Count : ret;
        }

        /// <summary>
        /// 指定年月の予約空き状況取得
        /// </summary>
        /// <param name="mode">検索モード</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="manCnt">人数</param>
        /// <param name="gender">性別</param>
        /// <param name="birth">生年月日</param>
        /// <param name="age">受診時年齢</param>
        /// <param name="cslDivCd">受診区分コード</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="rsvGrpCd">予約群コード</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <param name="holiday">休診日</param>
        /// <param name="status">状態</param>
        /// <param name="findRsvGrpCd">各検索条件に対して検索された予約群のコレクション</param>
        public void GetEmptyStatus(String mode, List<dynamic> cslDate, List<dynamic> perId, List<dynamic> manCnt, List<dynamic> gender, List<dynamic> birth, List<dynamic> age, List<dynamic> csCd,
            List<dynamic> cslDivCd, List<dynamic> rsvGrpCd, List<dynamic> ctrPtCd, List<dynamic> optCd, List<dynamic> optBranchNo,
            ref List<decimal> holiday, ref List<string> status, ref List<decimal> findRsvGrpCd)
        {
            string sql = "";                                        // SQLステートメント

            Int32 inArraySize = 0;                                  //配列のサイズ
            List<string> localManCnt = new List<string>();          // 人数
            List<string> localGender = new List<string>();          // 性別
            List<string> localBirth = new List<string>();           // 生年月日
            List<string> localAge = new List<string>();             // 受診時年齢
            List<string> localRsvGrpCd = new List<string>();        // 予約群コード

            Int32 outArraySize = 0;                                 //配列のサイズ

            // 戻り値の仮の配列として個人ＩＤの配列サイズを指定
            inArraySize = perId.Count;

            for (int i = 0; i < inArraySize; i++)
            {

                if (!string.IsNullOrEmpty(Util.ConvertToString(manCnt[i])))
                {
                    localManCnt.Add(long.Parse("0" + Util.ConvertToString(manCnt[i])));
                }
                else
                {
                    localManCnt.Add(null);
                }
                if (!string.IsNullOrEmpty(Util.ConvertToString(gender[i])))
                {
                    localGender.Add(long.Parse("0" + Util.ConvertToString(gender[i])));
                }
                else
                {
                    localGender.Add(null);
                }
                if (!string.IsNullOrEmpty(Util.ConvertToString(birth[i])))
                {
                    localBirth.Add(long.Parse("0" + Util.ConvertToString(birth[i])));
                }
                else
                {
                    localBirth.Add(null);
                }
                if (!string.IsNullOrEmpty(Util.ConvertToString(age[i])))
                {
                    localAge.Add(long.Parse("0" + Util.ConvertToString(age[i])));
                }
                else
                {
                    localAge.Add(null);
                }
                if (!string.IsNullOrEmpty(Util.ConvertToString(rsvGrpCd[i])))
                {
                    localRsvGrpCd.Add(long.Parse("0" + Util.ConvertToString(rsvGrpCd[i])));
                }
                else
                {
                    localRsvGrpCd.Add(null);
                }
            }

            using (var cmd = new OracleCommand())
            {
                // バインド変数の設定
                cmd.Parameters.Add("mode", mode);
                cmd.Parameters.Add("csldate", cslDate);

                // バインド配列(引数)の設定
                cmd.Parameters.AddTable("perid", perId.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, inArraySize, (int)LengthConstants.LENGTH_PERSON_PERID);
                cmd.Parameters.AddTable("mancnt", localManCnt.ToArray(), ParameterDirection.Input, OracleDbType.Int32, inArraySize, 10);
                cmd.Parameters.AddTable("gender", localGender.ToArray(), ParameterDirection.Input, OracleDbType.Int32, inArraySize, 10);
                cmd.Parameters.AddTable("birth", localBirth.ToArray(), ParameterDirection.Input, OracleDbType.Date, inArraySize, 10);
                cmd.Parameters.AddTable("age", localAge.ToArray(), ParameterDirection.Input, OracleDbType.Int32, inArraySize, 10);
                cmd.Parameters.AddTable("csldivcd", cslDivCd.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, inArraySize, 12);
                cmd.Parameters.AddTable("cscd", csCd.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, inArraySize, (int)LengthConstants.LENGTH_COURSE_CSCD);
                cmd.Parameters.AddTable("rsvgrpcd", localRsvGrpCd.ToArray(), ParameterDirection.Input, OracleDbType.Int32, inArraySize, 10);
                cmd.Parameters.AddTable("ctrptcd", ctrPtCd.ToArray(), ParameterDirection.Input, OracleDbType.Int32, inArraySize, 10);
                cmd.Parameters.AddTable("optcd", optCd.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, inArraySize, 500);
                cmd.Parameters.AddTable("optbranchno", optBranchNo.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, inArraySize, 300);

                // 戻り値の仮の配列として日数の最大値である31を設定
                outArraySize = 31;

                // 戻り値の設定
                OracleParameter sqlHoliDay = cmd.Parameters.AddTable("holiday", ParameterDirection.Output, OracleDbType.Decimal, outArraySize, 10);
                OracleParameter sqlStatus = cmd.Parameters.AddTable("status", ParameterDirection.Output, OracleDbType.Varchar2, outArraySize, 1);

                // 予約群の配列サイズは検索条件のそれといっしょ
                OracleParameter sqlFindRsvGrpcd = cmd.Parameters.AddTable("findrsvgrpcd", ParameterDirection.Output, OracleDbType.Decimal, outArraySize, 10);

                // ストアド呼び出し
                sql = @"
                        begin schedulepackage.getemptystatus(
                          :mode
                          , :csldate
                          , :perid
                          , :mancnt
                          , :gender
                          , :birth
                          , :age
                          , :csldivcd
                          , :cscd
                          , :rsvgrpcd
                          , :ctrptcd
                          , :optcd
                          , :optbranchno
                          , :holiday
                          , :status
                          , :findrsvgrpcd
                        );
                        end;
                ";

                // SQL実行
                ExecuteNonQuery(cmd, sql);

                // 戻り値の設定(エラーに関わらず戻す値)
                holiday = ((OracleDecimal[])sqlHoliDay.Value).Select(s => s.Value).ToList();
                status = ((OracleString[])sqlStatus.Value).Select(s => s.Value).ToList();
                findRsvGrpCd = ((OracleDecimal[])sqlFindRsvGrpcd.Value).Select(s => s.Value).ToList();

            }

        }
    }
}
