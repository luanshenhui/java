using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity
{
    /// <summary>
    /// 誘導データアクセスオブジェクト
    /// </summary>
    public class YudoDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public YudoDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 診察状態を取得する
        /// </summary>
        /// <returns>診察状態</returns>
        public List<dynamic> SelectConsultationMonitorStatus()
        {
            // パラメータの定義
            var sqlParams = new Dictionary<string, object>()
            {
                {"cslymd", DateTime.Today.ToString("yyyyMMdd") }
            };

            // ステートメント定義
            var sql = @"
                    select
                      kenshin_jotai_code
                      , dayid
                      , room_id
                    from
                      kenshin_trans 
                    where
                      cslymd = :cslymd 
                      and yudo_kensa_bunrui_code = '100220'
                      and room_id = '221'
                      and kenshin_jotai_code in ('100030', '100027')
                      and rownum < 2 
                    union all 
                    select
                      kenshin_jotai_code
                      , dayid
                      , room_id 
                    from
                      kenshin_trans 
                    where
                      cslymd = :cslymd 
                      and yudo_kensa_bunrui_code = '100220' 
                      and room_id = '222'
                      and kenshin_jotai_code in ('100030', '100027') 
                      and rownum < 2
                    ";

            return connection.Query(sql, sqlParams).ToList();
        }
    }
}
