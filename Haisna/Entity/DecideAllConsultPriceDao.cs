using Hainsi.Common;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Data;

namespace Hainsi.Entity
{
    /// <summary>
    /// 負担金額情報取得用データアクセスオブジェクト
    /// </summary>
    public class DecideAllConsultPriceDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public DecideAllConsultPriceDao(IDbConnection connection) : base(connection)
        {

        }

        /// <summary>
        /// 指定予約番号の負担金額情報を取得する(DecideAllConsultPrice)
        /// </summary>
        /// <param name="strDate">対象受診日開始日</param>
        /// <param name="endDate">対象受診日終了日</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="forceUpdate"> 1:受診金額を強制的に再作成</param>
        /// <param name="putLog"> 0:開始終了のみ、1:エラーのみ、2:全て</param>
        /// <returns>
        /// 処理レコード件数
        /// </returns>

        // ストアドのテスト用に作成したメソッド
        // 単純なオラクルパラメータをストアドに渡すパターン
        public int DecideAllConsultPrice(DateTime strDate, DateTime endDate, string orgCd1, string orgCd2, int forceUpdate = 0, int putLog = 0)
        {
            // 数値でないなら0セット
            if (!Util.IsNumber(Convert.ToString(forceUpdate)) || "".Equals(Convert.ToString(forceUpdate).Trim()))
            {
                forceUpdate = 0;
            }
            if (!Util.IsNumber(Convert.ToString(putLog)) || "".Equals(Convert.ToString(putLog).Trim()))
            {
                putLog = 0;
            }

            string sql = @"
                begin 
                    :ret := demandpackage.rebuildconsultprice( 
                        :strdate
                        , :enddate
                        , :orgcd1
                        , :orgcd2
                        , :forceupdate
                        , :putlog
                    ); 
                end; 
             ";

            using (var cmd = new OracleCommand())
            {
                // Inputは名前と値のみ
                cmd.Parameters.Add("strdate", strDate);
                cmd.Parameters.Add("enddate", endDate);
                cmd.Parameters.Add("orgcd1", orgCd1);
                cmd.Parameters.Add("orgcd2", orgCd2);
                cmd.Parameters.Add("forceupdate", forceUpdate);
                cmd.Parameters.Add("putlog", putLog);

                // OutputはOracleDbTypeとParameterDirectionの指定が必要
                OracleParameter ret = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                ExecuteNonQuery(cmd, sql);

                return ((OracleDecimal)ret.Value).ToInt32();
            }
        }
    }
}