package centling.service.delivery;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import chinsoft.core.LogPrinter;

/**
 * 自动发货定时任务监听器
 */
public class BlAutoDeliveryTaskListener implements ServletContextListener {
	@Override
	public void contextDestroyed(ServletContextEvent event) {
		LogPrinter.info("自动发货定时任务销毁");
	}

	@Override
	public void contextInitialized(ServletContextEvent event) {
		// 启动定时任务
		new BlAutoDeliveryTimeManager();
		LogPrinter.info("自动发货定时任务启动");
	}
}