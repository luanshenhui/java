using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Data;

namespace Hainsi.Entity
{
    /// <summary>
    /// 請求締め処理制御用データアクセスオブジェクト
    /// </summary>
    public class DmdAddUpControlDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public DmdAddUpControlDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 請求締め処理を起動する
        /// </summary>
        /// <param name="closeDate">締め日</param>
        /// <param name="strDate">開始受診日</param>
        /// <param name="endDate">終了受診日</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="courseCd">コースコード</param>
        /// <returns>
        /// Insert関数
        /// </returns>

        // ストアドのテスト用に作成したメソッド
        // 単純なオラクルパラメータをストアドに渡すパターン
        public int ExecuteDmdAddUp(DateTime closeDate, DateTime strDate, DateTime endDate, string orgCd1, string orgCd2, string courseCd)
        {
            using (var transaction = BeginTransaction())
            {
                string sql = @"
                begin 
                    :ret := demandpackage.createbill( 
                        :closedate
                        , :strdate
                        , :enddate
                        , :orgcd1
                        , :orgcd2
                        , :coursecd
                   ); 
                end; 
            ";

                using (var cmd = new OracleCommand())
                {
                    try
                    {
                        // Inputは名前と値のみ
                        cmd.Parameters.Add("closedate", closeDate);
                        cmd.Parameters.Add("enddate", endDate);
                        cmd.Parameters.Add("strdate", strDate);
                        cmd.Parameters.Add("orgcd2", orgCd2);
                        cmd.Parameters.Add("orgcd1", orgCd1);
                        cmd.Parameters.Add("coursecd", courseCd);

                        // OutputはOracleDbTypeとParameterDirectionの指定が必要
                        OracleParameter ret = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);
                        ExecuteNonQuery(cmd, sql);

                        // トランザクションをコミット
                        transaction.Commit();

                        return ((OracleDecimal)ret.Value).ToInt32();
                    }
                    catch
                    {
                        // エラー発生時はトランザクションをアボートに設定
                        transaction.Rollback();
                        return -1;
                    }

                }

            }
        }
    }
}