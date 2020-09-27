package chinsoft.service.orden;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import chinsoft.core.LogPrinter;

public class AutoOrdens implements ServletContextListener{

	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		// TODO Auto-generated method stub
		LogPrinter.info("自动更新状态定时任务销毁");
	}

	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		// TODO Auto-generated method stub
		new AutoUpdateOrdenStatus();
		LogPrinter.info("自动更新状态定时任务开始");
	}

}
