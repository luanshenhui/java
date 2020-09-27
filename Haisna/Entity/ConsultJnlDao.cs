using Dapper;
using Hainsi.Entity.Model.ConsultJnl;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Transactions;

namespace Hainsi.Entity
{
    /// <summary>
    /// 受診歴送信ジャーナルデータアクセスオブジェクト
    /// </summary>
    public class ConsultJnlDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ConsultJnlDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// カルテ／医事に送信する受診歴送信ジャーナルを取得する
        /// </summary>
        /// <param name="sendDiv">送信区分</param>
        /// <returns>受診歴送信ジャーナル</returns>
        public List<dynamic> SelectSendData(int[] sendDiv)
        {
            // パラメータ値の設定
            var sqlParam = new Dictionary<string, object>();

            // SQLステートメント定義
            string sql = @"
                    select
                        base_a.tskdate
                        , base_a.rsvno
                        , base_a.senddiv
                        , base_a.tskdiv
                        , base_a.comedate
                        , base_a.perid
                        , base_a.firstname
                        , base_a.lastname
                        , nvl(base_b.jyusin, 1) cslcount 
                    from
                        ( 
                            select
                                consult_jnl.tskdate
                                , consult_jnl.rsvno
                                , consult_jnl.senddiv
                                , consult_jnl.tskdiv
                                , consult_jnl.comedate
                                , consult.perid
                                , person.firstname
                                , person.lastname
                            from
                                receipt
                                , consult
                                , consult_jnl
                                , person 
                            where
                                consult_jnl.rsvno = consult.rsvno 
                                and consult.perid = person.perid 
                                and consult.rsvno = receipt.rsvno
                        ) base_a
                        , ( 
                            select
                                a.tskdate
                                , consult.perid
                                , count(consult.perid) jyusin 
                            from
                                consult
                                , receipt
                                , ( 
                                    select
                                        consult.perid
                                        , consult_jnl.tskdate 
                                    from
                                        consult
                                        , consult_jnl 
                                    where
                                        consult.rsvno = consult_jnl.rsvno
                                ) a 
                            where
                                consult.perid = a.perid 
                                and consult.rsvno = receipt.rsvno 
                                and receipt.comedate is not null 
                            group by
                                a.tskdate
                                , consult.perid
                        ) base_b 
                    where
                        base_a.tskdate = base_b.tskdate(+) 
                        and base_a.perid = base_b.perid(+) 
                ";

            if (sendDiv != null)
            {
                sql += @"                        and base_a.senddiv in (";
                int count = 1;
                foreach (int item in sendDiv)
                {
                    if (count > 1)
                    {
                        sql += @",";
                    }
                    sql += @":senddiv" + count.ToString();
                    sqlParam.Add("senddiv" + count.ToString(), item);
                    count++;
                }
                sql += @")";
            }

            sql += @"
                    order by
                        base_a.tskdate asc
                        , base_a.rsvno asc
                ";

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
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
        /// 受診歴送信ジャーナルの送信区分を更新する
        /// </summary>
        /// <param name="data">更新対象データ</param>
        /// <returns></returns>
        public int UpdateSendDiv(UpdateConsultJnl data)
        {
            using (var ts = new TransactionScope())
            {
                // SQL定義
                // 取得したレコードの送信区分に応じて
                // 更新もしくは削除を行うためロックをかける
                string sql = @"
                        select
                            senddiv 
                        from
                            consult_jnl 
                        where
                            consult_jnl.tskdate = :tskdate 
                            and consult_jnl.rsvno = :rsvno 
                        for update 
                ";

                // パラメータセット
                var sqlParam = new
                {
                    rsvno = data.RsvNo,
                    tskdate = data.TskDate,
                };

                // SQLステートメント実行
                dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();
                if (result == null)
                {
                    return 0;
                }

                // 現在の送信区分を取得する
                int befSendDiv = result.SENDDIV;

                if (befSendDiv == data.UpdSendDiv)
                {
                    // 現在の送信区分が更新対象送信区分と一致する場合

                    // SQL定義
                    sql = @"
                            update consult_jnl 
                            set
                                consult_jnl.senddiv = :senddiv 
                            where
                                consult_jnl.tskdate = :tskdate 
                                and consult_jnl.rsvno = :rsvno
                    ";

                    // パラメータセット
                    var updParam = new
                    {
                        rsvno = data.RsvNo,
                        tskdate = data.TskDate,
                        senddiv = data.AftSendDiv,
                    };

                    // 受診歴送信ジャーナルの送信区分を更新する
                    connection.Execute(sql, updParam);
                }
                else if (befSendDiv == data.DelSendDiv)
                {
                    // 現在の送信区分が削除対象送信区分と一致する場合

                    // SQL定義
                    sql = @"
                            delete 
                            from
                                consult_jnl 
                            where
                                consult_jnl.tskdate = :tskdate 
                                and consult_jnl.rsvno = :rsvno
                    ";

                    // パラメータセット
                    var delParam = new
                    {
                        rsvno = data.RsvNo,
                        tskdate = data.TskDate,
                    };

                    // 受診歴送信ジャーナルのレコードを削除する
                    connection.Execute(sql, delParam);
                }

                // トランザクションをコミット
                ts.Complete();

                return 1;
            }
        }
    }
}
