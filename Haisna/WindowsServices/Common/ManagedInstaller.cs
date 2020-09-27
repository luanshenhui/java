using System;
using System.Configuration.Install;
using System.Reflection;
using System.ServiceProcess;

namespace Fujitsu.Hainsi.WindowServices.Common
{
    public abstract class ManagedInstaller
    {
        protected static void Install(string serviceName, string[] args)
        {
            // アプリケーションのパスを取得
            Assembly myAssembly = Assembly.GetEntryAssembly();
            string path = myAssembly.Location;

            // アンインストール指定時の処理
            if (String.Compare(args[0].ToLower(), "/u") == 0)
            {
                // サービスが存在する場合はアンインストールを実施
                if (FindService(serviceName))
                {
                    string[] param = { "/u", path };
                    ManagedInstallerClass.InstallHelper(param);
                }

                return;
            }

            // サービスが存在しない場合はインストールを実施
            if (!FindService(serviceName))
            {
                string[] param = { path };
                ManagedInstallerClass.InstallHelper(param);
            }
        }

        /// <summary>
        /// すべてのサービスから指定された名称のサービスが存在するかを検索します。
        /// </summary>
        /// <param name="serviceName">サービス名</param>
        /// <returns>存在する場合はtrueを返す</returns>
        public static bool FindService(string serviceName)
        {
            bool check = false;

            ServiceController[] services = ServiceController.GetServices();

            foreach (ServiceController service in services)
            {
                if (String.Compare(service.ServiceName, serviceName, true) == 0)
                {
                    check = true;
                    break;
                }
            }

            return check;
        }
    }
}
