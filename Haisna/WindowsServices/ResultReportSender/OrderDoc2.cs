using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Oracle.ManagedDataAccess.Client;
using Dapper;

namespace Fujitsu.Hainsi.WindowServices.ResultReportSender
{
    class OrderDoc2 : AbstractDao
    {
        public OrderDoc2() { }

        /// <summary>
        /// 版数取得
        /// </summary>
        /// <param name="makeMode">処理モード</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="orderNo">オーダー番号</param>
        /// <returns></returns>
        public dynamic Select(MessageMaker.MakeMode makeMode, int rsvNo, int orderNo)
        {
            string sql = " SELECT ";

            if (makeMode == MessageMaker.MakeMode.New)
            {
                sql += " ORDERSEQ ";
            }
            else
            {
                sql += " ORDERSEQ + 1 ORDERSEQ ";
            }

            sql += @"
                FROM 
                     ORDERDDOC2
                WHERE RSVNO   = :RSVNO
                  AND DOCCODE = :DOCCODE
                  AND DOCSEQ  = :DOCSEQ
                  AND ORDERNO = :ORDERNO
                ";

            var parameters = new
            {
                rsvno = rsvNo,
                doccode = "9999",
                docseq = "00",
                orderno = orderNo
            };

            try
            {
                return context.Database.Connection.Query(sql, parameters).ToList();
            }
            catch (OracleException ex)
            {
                throw new DataAccessException(ex.Message);
            }
        }
    }
}
