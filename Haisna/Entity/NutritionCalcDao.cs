using Entity.Helper;
using Hainsi.Common.Constants;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;

namespace Hainsi.Entity
{
    /// <summary>
    /// 栄養計算用データアクセスオブジェクト
    /// </summary>
    public class NutritionCalcDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public NutritionCalcDao(IDbConnection connection) : base(connection)
        {
        }

        private const int LENGTH_RECEIPT_DAYID = 4;     // 当日ＩＤ

        /// <summary>
        /// 指定された条件の計算処理を起動する
        /// </summary>
        /// <param name="updUser">更新者</param>
        /// <param name="ipAddress">ＩＰアドレス</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="dayIdFlg">1:ID 範囲指定、2:ID任意指定</param>
        /// <param name="calcFlg">配列（栄養計算,Ａ型行動パターン,失点判定,ストレス点数)0:計算非対象　1:計算対象</param>
        /// <param name="strDayId">検索開始ＩＤ</param>
        /// <param name="EndDayId">検索終了ＩＤ</param>
        /// <param name="arrDayId">検索ＩＤ（配列</param>
        /// <returns></returns>
        public Insert NutritionCalcStart(string updUser, string ipAddress, string cslDate, int dayIdFlg, string[] calcFlg, string strDayId, string EndDayId, List<string> arrDayId)
        {
            string sql; // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            int arraySize; // 配列サイズ

            if (2 == dayIdFlg)
            {
                // 配列数
                arraySize = arrDayId.Count;
            }
            else
            {
                arraySize = 1;
            }

            for (int i = 0; i < 4; i++)
            {
                if (Convert.ToInt32(calcFlg[i]) == 1)
                {
                    switch (i)
                    {
                        // 栄養計算
                        case 0:
                            // 栄養計算ストアド呼び出し
                            sql = @"
                                    begin :ret := nutritioncalcpackage(:upduser, :ipaddress, :csldate, :dayidflg, :strdayid, :enddayid, :arrdayid);
                                    end;
                                ";

                            using (var cmd = new OracleCommand())
                            {
                                // Inputは名前と値のみ
                                cmd.Parameters.Add("upduser", updUser);
                                cmd.Parameters.Add("ipaddress", ipAddress);
                                cmd.Parameters.Add("csldate", cslDate);
                                cmd.Parameters.Add("dayidflg", dayIdFlg);
                                cmd.Parameters.Add("strdayid", strDayId);
                                cmd.Parameters.Add("enddayid", EndDayId);
                                if (2 == dayIdFlg)
                                {
                                    cmd.Parameters.AddTable("arrdayid", arrDayId.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, LENGTH_RECEIPT_DAYID);
                                }
                                else
                                {
                                    cmd.Parameters.AddTable("arrdayid", ParameterDirection.Input, OracleDbType.Varchar2, arraySize, LENGTH_RECEIPT_DAYID);
                                }


                                ret2 = ExecuteNonQuery(cmd, sql);

                                if (ret2 > 0)
                                {
                                    ret = Insert.Normal;
                                    break;
                                }
                            }

                            break;
                        // Ａ型行動パターン
                        case 1:
                            break;
                        // 失点判定
                        case 2:
                            break;
                        // ストレス点数
                        case 3:
                            break;
                    }
                }
            }

            // 戻り値の設定
            return ret;
        }
    }
}
