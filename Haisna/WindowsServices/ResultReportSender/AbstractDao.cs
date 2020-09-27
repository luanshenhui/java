using Dapper;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Fujitsu.Hainsi.WindowServices.ResultReportSender
{
    public abstract class AbstractDao
    {
        protected OracleDbContext context;

        public AbstractDao()
        {
            this.context = new OracleDbContext();
        }

        public AbstractDao(OracleDbContext context)
        {
            this.context = context;
        }
    }
}
