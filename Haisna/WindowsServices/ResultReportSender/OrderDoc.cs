using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Oracle.ManagedDataAccess.Client;
using Dapper;

namespace Fujitsu.Hainsi.WindowServices.ResultReportSender
{
    class OrderDoc : AbstractDao
    {
        public OrderDoc()
        {
        }
        
        public List<dynamic> Select(int rsvNo)
        {
            string sql = @"
                SELECT 
                     ORDEREDDOC.RSVNO
                    ,ORDEREDDOC.ORDERDIV
                    ,ORDEREDDOC.ORDERDATE
                    ,ORDEREDDOC.ORDERNO
                    ,ORDEREDDOC.RECENO
                    ,ORDEREDDOC.SENDDIV
                    ,ORDEREDDOC.SENDDATE
                    ,ORDEREDDOC.IPADDRESS
                    ,FREE.FREEFIELD1
                FROM 
                     ORDEREDDOC
                    ,FREE
                WHERE ORDEREDDOC.RSVNO = :RSVNO
                  AND ORDEREDDOC.ORDERDIV = :ORDERDIV
                  AND ORDEREDDOC.ORDERDIV = FREE.FREECD
                  AND FREE.FREECLASSCD = :FREECLASSCD
                ORDER BY
                     ORDEREDDOC.RSVNO ASC
                    ,ORDEREDDOC.ORDERDIV ASC
                    ,ORDEREDDOC.ORDERDATE ASC
                    ,ORDEREDDOC.ORDERNO ASC
                ";

            var parameters = new
            {
                rsvno = rsvNo,
                orderdiv = "ORD",
                freeclasscd = "ORDDIV000090"
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

        /// <summary>
        /// オーダー番号を新規発行する
        /// </summary>
        /// <returns></returns>
        public dynamic GenerateNewOrderNumber()
        {
            var sql = "SELECT ORDERNO.NEXTVAL ORDERNO FROM DUAL";

            try
            {
                return context.Database.Connection.Query(sql).SingleOrDefault();
            }
            catch (OracleException ex)
            {
                throw new DataAccessException(ex.Message);
            }
        }

        /// <summary>
        /// 電文付加連番取得
        /// </summary>
        /// <returns></returns>
        public dynamic GenerateNewSendNumber()
        {
            var sql = "SELECT SENDNO.NEXTVAL SENDNO FROM DUAL";

            try
            {
                return context.Database.Connection.Query(sql).SingleOrDefault();
            }
            catch (OracleException ex)
            {
                throw new DataAccessException(ex.Message);
            }
        }
    }
}
