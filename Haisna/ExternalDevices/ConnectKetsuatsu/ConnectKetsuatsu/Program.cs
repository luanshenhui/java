using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ConnectKetsuatsu
{
    static class Program
    {
        /// <summary>
        /// アプリケーションのメイン エントリ ポイントです。
        /// </summary>
        [STAThread]
        static void Main(string[] args)
        {

            string tokenCode = "";
            string execKey = "";
            string dayID = "";

            if (args.Length == 3)
            {
                tokenCode = args[0];
                execKey = args[1];
                dayID = args[2];
            }

            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            var form = new mainForm(args.Length, tokenCode, execKey, dayID);
            if (!form.IsDisposed)
            {
                Application.Run(form);
            }
        }
    }
}
