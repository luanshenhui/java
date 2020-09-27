using System;

#pragma warning disable CS1591

namespace Hainsi.Entity
{
	public class DataAccessException : Exception
    {
        public DataAccessException(string message) : base(message)
        {
        }

		public DataAccessException(string message, Exception ex) : base(message, ex)
		{
		}
	}
}
