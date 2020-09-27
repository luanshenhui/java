using Fujitsu.Hainsi.WindowServices.Common;
using System.ServiceProcess;

namespace Fujitsu.Hainsi.WindowServices.ResultReportSender
{
    class Program : ManagedInstaller
    {
        public const string ServiceName = "ResultReportSender";
        public const string DisplayName = "Hainsi Result Report Sender";

        /// <summary>
        /// アプリケーションのメイン エントリ ポイントです。
        /// </summary>
        static void Main(string[] args)
        {
            // 引数が存在する場合はインストール／アンインストールを行う
            if (args.Length >= 1)
            {
                Install(ServiceName, args);
                return;
            }

            // 引数が存在しない場合はサービスを登録
            ServiceBase[] ServicesToRun;
            ServicesToRun = new ServiceBase[]
            {
                new Service()
            };
            ServiceBase.Run(ServicesToRun);
        }
    }
}
