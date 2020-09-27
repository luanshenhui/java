using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Data;

namespace Hainsi.Entity
{
    /// <summary>
    /// スクリーニング用データアクセスオブジェクト
    /// </summary>
    public class ScreeningDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ScreeningDao(IDbConnection connection) : base(connection)
        {

        }

        /// <summary>
        /// スクリーニング
        /// </summary>
        /// <param name="strCslDate">開始受診日</param>
        /// <param name="endCslDate">終了受診日</param>
        /// <param name="strDayId">開始当日ＩＤ</param>
        /// <param name="endDayId">終了当日ＩＤ</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="perId">個人ID</param>
        /// <param name="reJudge">再判定フラグ</param>
        /// <param name="entryCheck">未入力チェックフラグ</param>
        /// <returns></returns>
        public long Screening(DateTime strCslDate, DateTime endCslDate, string strDayId, string endDayId, string csCd, string judClassCd, string perId, long reJudge, long entryCheck)
        {
            using (var cmd = new OracleCommand())
            {
                // キー値及び更新値の設定
                cmd.Parameters.Add("strcsldate", OracleDbType.Date, strCslDate, ParameterDirection.Input);
                cmd.Parameters.Add("endcsldate", OracleDbType.Date, endCslDate, ParameterDirection.Input);
                if (!string.IsNullOrEmpty(strDayId))
                {
                    cmd.Parameters.Add("strdayid", OracleDbType.Int32, long.Parse(0 + strDayId), ParameterDirection.Input);
                }
                else
                {
                    cmd.Parameters.Add("strdayid", OracleDbType.Int32, null, ParameterDirection.Input);
                }
                if (!string.IsNullOrEmpty(endDayId))
                {
                    cmd.Parameters.Add("enddayid", OracleDbType.Int32, long.Parse(0 + endDayId), ParameterDirection.Input);
                }
                else
                {
                    cmd.Parameters.Add("enddayid", OracleDbType.Int32, null, ParameterDirection.Input);
                }
                cmd.Parameters.Add("cscd", OracleDbType.Varchar2, csCd, ParameterDirection.Input);
                cmd.Parameters.Add("judclasscd", OracleDbType.Varchar2, judClassCd, ParameterDirection.Input);
                cmd.Parameters.Add("perid", OracleDbType.Varchar2, (!string.IsNullOrEmpty(perId) ? perId : null), ParameterDirection.Input);
                cmd.Parameters.Add("rejudge", OracleDbType.Int32, reJudge, ParameterDirection.Input);
                cmd.Parameters.Add("entrycheck", OracleDbType.Int32, entryCheck, ParameterDirection.Input);

                // 戻り値のバインド変数定義
                OracleParameter objRet = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                //スクリーニング用ストアドパッケージの関数呼び出し
                string sql = @"
                                begin :ret := judgementpackage.screening(
                                  :strcsldate
                                  , :endcsldate
                                  , :strdayid
                                  , :enddayid
                                  , :cscd
                                  , :judclasscd
                                  , :perid
                                  , :entrycheck
                                  , :rejudge
                                );
                                end;
                ";

                // SQL実行
                ExecuteNonQuery(cmd, sql);

                // 戻り値の設定
                long ret = Convert.ToInt32((OracleDecimal)objRet.Value);

                return ret;
            }
        }
    }
}