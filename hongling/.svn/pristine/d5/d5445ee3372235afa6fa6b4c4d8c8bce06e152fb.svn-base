package rcmtm.synchronousDealCash;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * 同步订单任务的调度
 * 
 * @author dell
 * 
 */
public class DealCashSynchronousScheduled {

	private ScheduledExecutorService singleService = Executors.newSingleThreadScheduledExecutor();

	public void SynchronousDeals() {
		// 执行时间 间隔 此处定义为每1小时执行一次
		 long period = 1000 * 60 * 60;
//		long period = 1000 * 60;
		// 从现在开始(启动触 发)delay毫秒之后，每隔一小时扫瞄一次OA流程
		long delay = 1000 * 10;
		// 扫描deal状态
		singleService.scheduleAtFixedRate(new SearchDealCashTask(), delay, period,TimeUnit.MILLISECONDS);
	}

	/**
	 * 关闭线程池
	 */
	public void shutdownDealCashSynchronous() {
//		System.out.println("订单同步停止");
		singleService.shutdownNow();
	}
}
