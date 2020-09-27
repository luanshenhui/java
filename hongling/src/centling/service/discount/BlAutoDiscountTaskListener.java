package centling.service.discount;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import chinsoft.core.LogPrinter;

/**
 * 每月折扣返款定时任务监听器
 */
public class BlAutoDiscountTaskListener implements ServletContextListener {
	@Override
	public void contextDestroyed(ServletContextEvent event) {
		LogPrinter.info("每月折扣返款定时任务销毁");
	}

	@Override
	public void contextInitialized(ServletContextEvent event) {
		// 启动定时任务
		new BlAutoDiscountTimeManager();
		LogPrinter.info("每月折扣返款定时任务启动");
	}
}