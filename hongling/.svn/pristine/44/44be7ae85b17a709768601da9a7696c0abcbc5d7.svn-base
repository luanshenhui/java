package rcmtm.synchronousOrden;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * 同步订单任务的调度
 * 
 * @author dell
 * 
 */
public class OrdenSynchronousScheduled {

	private ScheduledExecutorService singleService = Executors
			.newSingleThreadScheduledExecutor();

	public void SynchronousOrdens() {
		// 执行时间 间隔 此处定义为每半小时执行一次
		 long period = 1000 * 60 * 30;
//		long period = 1000 * 60;
		// 从现在开始(启动触 发)delay毫秒之后，每隔period 毫秒(半小时)扫瞄一次数据库
		long delay = 1000 * 10;
		// 扫描电商订单状态
		singleService.scheduleAtFixedRate(new SearchOrdenTask(), delay, period,
				TimeUnit.MILLISECONDS);
	}

	/**
	 * 关闭线程池
	 */
	public void shutdownOrdenSynchronous() {
//		System.out.println("订单同步停止");
		singleService.shutdownNow();
	}
}
