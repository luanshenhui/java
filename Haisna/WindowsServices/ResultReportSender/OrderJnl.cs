using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Oracle.ManagedDataAccess.Client;
using Dapper;

namespace Fujitsu.Hainsi.WindowServices.ResultReportSender
{
    class OrderJnl : AbstractDao
    {
        public OrderJnl()
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<dynamic> Select()
        {
            string sql = @"
                    SELECT 
                         TSKDATE 
                        ,RSVNO 
                        ,ODRDIV 
                        ,TSKDIV 
                        ,SENDDIV 
                    FROM 
                        ORDER_JNL 
                    WHERE ODRDIV = :ODRDIV 
                    ORDER BY 
                         TSKDATE ASC 
                        ,RSVNO ASC 
                    ";
            var parameters = new { ODRDIV = 2 };

            try
            {
                return context.Database.Connection.Query(sql, parameters).ToList();
            }
            catch(OracleException ex)
            {
                throw new DataAccessException(ex.Message);
            }
        }
    }
}
