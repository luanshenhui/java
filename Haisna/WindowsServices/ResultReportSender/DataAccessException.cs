using System;

namespace Fujitsu.Hainsi.WindowServices.ResultReportSender
{
    public class DataAccessException : Exception
    {
        public DataAccessException(string message) : base(message)
        {
        }
    }
}
