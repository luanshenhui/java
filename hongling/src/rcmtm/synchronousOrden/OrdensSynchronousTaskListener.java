package rcmtm.synchronousOrden;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import chinsoft.core.LogPrinter;

public class OrdensSynchronousTaskListener implements ServletContextListener {
	private OrdenSynchronousScheduled ordenSynchronousScheduled = new OrdenSynchronousScheduled();

	@Override
	public void contextDestroyed(ServletContextEvent event) {
		// 关闭时任务
		ordenSynchronousScheduled.shutdownOrdenSynchronous();
		LogPrinter.info("订单信息同步更新任务停止");
	}

	@Override
	public void contextInitialized(ServletContextEvent event) {
		// 启动定时任务
		ordenSynchronousScheduled.SynchronousOrdens();
		LogPrinter.info("订单状态同步更新任务开始");
	}
}
