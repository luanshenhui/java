package rcmtm.synchronousDealCash;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import chinsoft.core.LogPrinter;

public class DealCashSynchronousTaskListener implements ServletContextListener {
	private DealCashSynchronousScheduled dealCashSynchronousScheduled = new DealCashSynchronousScheduled();

	@Override
	public void contextDestroyed(ServletContextEvent event) {
		// 关闭时任务
		dealCashSynchronousScheduled.shutdownDealCashSynchronous();
		LogPrinter.info("订单现金信息同步更新任务停止");
	}

	@Override
	public void contextInitialized(ServletContextEvent event) {
		// 启动定时任务
		dealCashSynchronousScheduled.SynchronousDeals();
		LogPrinter.info("订单现金信息同步更新任务开始");
	}
}
