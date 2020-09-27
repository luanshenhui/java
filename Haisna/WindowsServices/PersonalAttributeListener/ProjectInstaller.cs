using System;
using System.ComponentModel;
using System.ServiceProcess;

namespace Fujitsu.Hainsi.WindowServices.PersonalAttributeListener
{
    [RunInstaller(true)]
    public partial class ProjectInstaller : System.Configuration.Install.Installer
    {
        public ProjectInstaller()
        {
            var serviceProcessInstaller = new ServiceProcessInstaller();
            serviceProcessInstaller.Username = Environment.UserName;
            serviceProcessInstaller.Account = ServiceAccount.LocalSystem;

            var serviceInstaller = new ServiceInstaller();
            serviceInstaller.ServiceName = Program.ServiceName;
            serviceInstaller.DisplayName = Program.DisplayName;
            serviceInstaller.StartType = ServiceStartMode.Automatic;

            Installers.Add(serviceProcessInstaller);
            Installers.Add(serviceInstaller);
        }
    }
}
