using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Transactions;

namespace Hainsi.Entity
{
    /// <summary>
    /// 個人プロファイル取得ジャーナルデータアクセスオブジェクト
    /// </summary>
    public class PersonJnlDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public PersonJnlDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 個人プロファイル取得ジャーナルを取得する
        /// </summary>
        /// <returns>個人プロファイル取得ジャーナル</returns>
        public List<dynamic> SelectData()
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        tskdate
                        , perid 
                    from
                        person_jnl 
                    order by
                        tskdate
                        , perid
                ";

            // SQL実行
            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 送信電文の連番を取得する
        /// </summary>
        /// <returns>連番</returns>
        public int SelectSeqNo()
        {
            // SQL定義
            string sql = @"
                    select
                        sendno.nextval seqno 
                    from
                        dual
                ";

            // SQL実行
            dynamic result = connection.Query(sql).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? 0 : (int)result.SEQNO;
        }

        /// <summary>
        /// 個人プロファイル取得ジャーナルのレコードを削除する
        /// </summary>
        /// <param name="tskDate">処理日時</param>
        /// <param name="perId">個人ID</param>
        /// <returns>処理結果件数</returns>
        public int DeleteData(DateTime tskDate, string perId)
        {
            using (var ts = new TransactionScope())
            {
                // SQL定義
                string sql = @"
                        delete 
                        from
                            person_jnl 
                        where
                            person_jnl.tskdate = :tskdate 
                            and person_jnl.perid = :perid
                    ";

                // パラメータセット
                var delParam = new
                {
                    tskdate = tskDate,
                    perid = perId,
                    
                };

                // 個人プロファイル取得ジャーナルのレコードを削除する
                var result = connection.Execute(sql, delParam);

                // トランザクションをコミット
                ts.Complete();

                return result;
            }
        }
    }
}
