using System.ComponentModel;
using System.Configuration;
using System.Linq;
using System.ServiceProcess;

namespace Fujitsu.Hainsi.WindowServices.Common
{
    [RunInstaller(true)]
    public partial class ProjectInstallerBase : System.Configuration.Install.Installer
    {
        public ProjectInstallerBase()
        {
            var serviceProcessInstaller = new ServiceProcessInstaller();
            serviceProcessInstaller.Account = ServiceAccount.LocalService;

            var serviceInstaller = new ServiceInstaller
            {
                // サービス名
                ServiceName = ConfigurationManager.AppSettings["ServiceName"].Trim(),
                // 表示名
                DisplayName = ConfigurationManager.AppSettings["ServiceDisplayName"].Trim(),
                // 説明
                Description = ConfigurationManager.AppSettings["ServiceDescription"].Trim(),
                // スタートアップの種類
                StartType = ServiceStartMode.Automatic
            };

            // 依存するサービス
            string serviceDependedOn = ConfigurationManager.AppSettings["ServiceDependedOn"];
            if (!string.IsNullOrWhiteSpace(serviceDependedOn))
            {
                serviceInstaller.ServicesDependedOn =
                    serviceDependedOn.Split(',').Select(item => item.Trim()).ToArray();
            }

            Installers.Add(serviceProcessInstaller);
            Installers.Add(serviceInstaller);
        }
    }
}
