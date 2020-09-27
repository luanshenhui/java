using System.Data;

#pragma warning disable CS1591

namespace Hainsi.Entity
{
    public class ExecDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ExecDao(IDbConnection connection) : base(connection)
        {
        }

        public void Run(string commandLine)
        {
            System.Diagnostics.Process p = new System.Diagnostics.Process();
            p.StartInfo.FileName = commandLine;
            p.StartInfo.UseShellExecute = false;
            p.StartInfo.RedirectStandardInput = true;
            p.StartInfo.RedirectStandardOutput = true;
            p.StartInfo.RedirectStandardError = true;
            p.StartInfo.CreateNoWindow = true;
            p.Start();
            p.WaitForExit();
            p.Close();
        }
    }
}
