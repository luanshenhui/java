package cn.com.cgbchina.scheduler.manager;

import cn.com.cgbchina.scheduler.model.TaskFireLog;
import cn.com.cgbchina.scheduler.manager.SchedulerService;
import cn.com.cgbchina.common.utils.LocalHostUtil;
import com.alibaba.dubbo.common.json.JSON;
import com.google.common.base.Throwables;
import lombok.extern.slf4j.Slf4j;
import org.quartz.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * 调度监听器
 *
 */
@Slf4j
public class TaskListener implements JobListener {

	@Autowired
	private SchedulerService schedulerService;
	/**
	 * 日志表状态，初始状态，插入
	 */
	private static final String INIT_STATS = "I";
	/**
	 * 日志表状态，成功
	 */
	private static final String SUCCESS_STATS = "S";
	/**
	 * 日志表状态，失败
	 */
	private static final String ERROR_STATS = "E";
	/**
	 * 日志表状态，未执行
	 */
	private static final String UN_STATS = "N";

	private static final String JOB_LOG = "jobLog";
	// 线程池
	private ExecutorService executorService = Executors.newCachedThreadPool();

	public String getName() {
		return "taskListener";
	}

	public void jobExecutionVetoed(JobExecutionContext context) {

	}

	// 任务开始前
	public void jobToBeExecuted(final JobExecutionContext context) {
		final JobDataMap jobDataMap = context.getJobDetail().getJobDataMap();
		JobKey jobKey = context.getJobDetail().getKey();
		String groupName = jobKey.getGroup();
		String jobName = jobKey.getName();
		String desc = context.getJobDetail().getDescription();
		// 保存日志
		final TaskFireLog tlog = new TaskFireLog();
		boolean isRunning = false;
		try {
			List<JobExecutionContext> executingJobs = context.getScheduler().getCurrentlyExecutingJobs();
			for (JobExecutionContext executingJob : executingJobs) {
				JobKey jKey = executingJob.getJobDetail().getKey();
				if (jKey.getGroup().equals(groupName) && jKey.getName().equals(jobName)) {
					isRunning = true;
					break;
				}
			}
		} catch (SchedulerException e) {
			log.error(context.getJobDetail().getDescription() + "执行异常:{}.", Throwables.getStackTraceAsString(e));
			return;
		}
		if (isRunning) {
			log.info(desc + groupName + "." + jobName + " 前一个任务正在执行中....");
			tlog.setFireInfo("前一个任务正在执行中");
		} else {
			log.info(desc + groupName + "." + jobName + " 任务执行开始....");
		}
		tlog.setStartTime(context.getFireTime());
		tlog.setGroupName(groupName);
		tlog.setTaskName(jobName);
		tlog.setStatus(INIT_STATS);
		tlog.setServerHost(LocalHostUtil.getIpAddress());
//		log.setServerDuid(LocalHostUtil.geMacAddress());
		schedulerService.updateLog(tlog);
		jobDataMap.put(JOB_LOG, tlog);
	}

	// 任务结束后
	public void jobWasExecuted(final JobExecutionContext context, JobExecutionException exp) {
		Timestamp end = new Timestamp(System.currentTimeMillis());
		final JobDataMap jobDataMap = context.getJobDetail().getJobDataMap();
		if (ERROR_STATS.equals(jobDataMap.get("taskStatus"))) {
			return;
		}
		String groupName = context.getJobDetail().getKey().getGroup();
		String jobName = context.getJobDetail().getKey().getName();
		String desc = context.getJobDetail().getDescription();
		// 更新任务执行状态
		final TaskFireLog tlog = (TaskFireLog) jobDataMap.get(JOB_LOG);
		tlog.setEndTime(end);
		if (exp != null) {
			tlog.setStatus(ERROR_STATS);
			tlog.setFireInfo(exp.getMessage());
			log.error(desc + groupName + "." + jobName + " 任务执行失败{}." , Throwables.getStackTraceAsString(exp));
		} else {
			if (tlog.getStatus().equals(INIT_STATS)) {
				tlog.setStatus(SUCCESS_STATS);
				log.info(desc + groupName + "." + jobName + " 任务执行成功.");
			}
		}
		executorService.submit(new Runnable() {
			public void run() {
				try {
					schedulerService.updateLog(tlog);
				} catch (Exception e) {
					try {
						log.error("Update TaskRunLog cause error. The log object is : {}" , JSON.json(tlog),
								Throwables.getStackTraceAsString(e));
					} catch (IOException e1) {
						e1.printStackTrace();
					}
				}
			}
		});
	}

}