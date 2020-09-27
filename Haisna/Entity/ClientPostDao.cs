using Dapper;
using Hainsi.Entity.Model;
using System.Data;
using System.Linq;

#pragma warning disable CS1591

namespace Hainsi.Entity
{
    public class ClientPostDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ClientPostDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 計測結果をテーブルに登録する
        /// </summary>
        /// <param name="clientData">登録するデータ</param>
        /// <returns></returns>
        public int Register(ClientDeviceModel clientData)
        {
            // SQL定義
            string sql = @"
                merge into clientpost
                using (select :execkey   execkey,
                              :postclass postclass,
                              :data      data,
                              :ipaddress ipaddress
                         from dual
                ) phantom
                on (clientpost.execkey = phantom.execkey)
                when matched then
                update set postclass = phantom.postclass,
                           data      = phantom.data,
                           insdate   = sysdate,
                           ipaddress = phantom.ipaddress
                when not matched then
                insert (
                       execkey,
                       postclass,
                       data,
                       ipaddress
                ) values (
                       :execkey,
                       :postclass,
                       :data,
                       :ipaddress
                )
            ";

            // パラメータセット
            var sqlParam = new
            {
                execkey = clientData.ExecKey,
                postclass = clientData.PostClass,
                data = clientData.Data,
                ipaddress = clientData.IpAddress
            };

            // SQL実行
            return connection.Execute(sql, sqlParam);
        }

        /// <summary>
        /// 計測機器から登録した検査結果を取得する
        /// </summary>
        /// <param name="execKey">EXECキー</param>
        /// <returns>検査結果</returns>
        public dynamic Select(long execKey)
        {
            // SQL定義
            string sql = @"select * from clientpost where execkey = :execkey";

            // パラメータセット
            var sqlParam = new { execkey = execKey };

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }
    }
}
