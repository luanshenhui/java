using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Oracle.ManagedDataAccess.Client;
using Dapper;

namespace Fujitsu.Hainsi.WindowServices.ResultReportSender
{
    class PersonAttribute : AbstractDao
    {
        public PersonAttribute() { }

        public dynamic Select(int rsvno)
        {
            string sql = @"
                    SELECT 
                         RECEIPT.CSLDATE
                        ,RECEIPT.DAYID
                        ,CONSULT.PERID
                        ,PERSON.LASTNAME
                        ,PERSON.FIRSTNAME
                        ,PERSON.LASTKNAME
                        ,PERSON.FIRSTKNAME
                        ,PERSON.ROMENAME
                        ,PERSON.GENDER
                        ,PERSON.BIRTH
                    FROM 
                         RECEIPT
                        ,CONSULT
                        ,PERSON
                    WHERE RECEIPT.RSVNO = :RSVNO
                      AND RECEIPT.RSVNO = CONSULT.RSVNO
                      AND PERSON.PERID = CONSULT.PERID
                    ";

            var parameters = new { rsvno = rsvno };

            try
            {
                return context.Database.Connection.Query(sql, parameters).FirstOrDefault();
            }
            catch(OracleException ex)
            {
                throw new DataAccessException(ex.Message);
            }
        }
    }
}
