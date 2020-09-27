using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 団体グループデータアクセスオブジェクト
    /// </summary>
    public class OrgGrpDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public OrgGrpDao(IDbConnection connection) : base(connection)
        {

        }

        /// <summary>
        /// 団体グループの一覧を団体グループコードの昇順で取得する
        /// </summary>
        /// <returns></returns>
        public List<dynamic> SelectOrgGrp_PList()
        {
            // 団体グループの一覧を団体グループコードの昇順で取得
            string sql = @"
                        select
                            orggrpcd
                            , grpname 
                        from
                            orggrp_p 
                        where
                            systemgrp is null 
                        order by
                            orggrpcd
                       ";

            return connection.Query(sql).ToList();
        }
    }
}
