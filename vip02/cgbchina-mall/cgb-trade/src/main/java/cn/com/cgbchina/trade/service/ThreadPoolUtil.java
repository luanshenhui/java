package cn.com.cgbchina.trade.service;

import org.springframework.beans.factory.annotation.Value;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * Created by on 16-7-21.
 */

public class ThreadPoolUtil {

	private static ThreadPoolExecutor threadPool;

	@Value("#{app.corePoolSize}")
	private int corePoolSize;

	@Value("#{app.maximumPoolSize}")
	private int maximumPoolSize;

	@Value("#{app.keepAliveTime}")
	private int keepAliveTime;

	@Value("#{app.workQueue}")
	private int workQueue;

	/**
	 * 获取线程池
	 * @return
	 */
	public ThreadPoolExecutor getThreadPool(){
		//线程池维护线程的最少数量
		corePoolSize = 1;
		//线程池维护线程的最大数量
		maximumPoolSize = 10;
		//线程池维护线程所允许的空闲时间
		keepAliveTime = 1;
		//缓冲队列
		workQueue = 50;
		//新建一个线程池：6个参数分别代表：线程池最小数、最大数量、每个线程允许的空闲时间、时间单位、线程等待队列、线程池对拒绝任务的处理策略
		if(threadPool != null){
			return threadPool;
		}
		threadPool = new ThreadPoolExecutor(corePoolSize, maximumPoolSize, keepAliveTime, TimeUnit.SECONDS, new ArrayBlockingQueue(workQueue), new ThreadPoolExecutor.CallerRunsPolicy());
		return threadPool;
	}

}
