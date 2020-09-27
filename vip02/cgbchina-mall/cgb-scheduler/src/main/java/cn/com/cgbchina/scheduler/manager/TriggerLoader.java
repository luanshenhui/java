package cn.com.cgbchina.scheduler.manager;

import cn.com.cgbchina.scheduler.dao.TaskSchedulerDao;
import cn.com.cgbchina.scheduler.model.TaskScheduler;
import com.google.common.collect.Maps;
import org.quartz.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.Map;

/**
 * 作业加载器
 *
 */
public class TriggerLoader {
	@Autowired
	private TaskSchedulerDao taskSchedulerDao;

	public Map<Trigger, JobDetail> loadTriggers() {
//		List<TaskScheduler> taskSchedulers = taskSchedulerDao.selectAll();
		Map<Trigger, JobDetail> resultMap = Maps.newHashMap();
//		for (TaskScheduler taskScheduler : taskSchedulers) {
//			JobDataMap jobDataMap = new JobDataMap();
//			jobDataMap.put("id", taskScheduler.getId());
//			jobDataMap.put("enable", taskScheduler.getEnable());
//			jobDataMap.put("taskType", taskScheduler.getTaskType());
//			jobDataMap.put("contactEmail", taskScheduler.getContactEmail());
//			jobDataMap.put("desc", taskScheduler.getTaskDesc());
//			JobDetail jobDetail = JobBuilder.newJob(JobTask.class)
//					.withIdentity(taskScheduler.getTaskName(), taskScheduler.getGroupName())
//					.withDescription(taskScheduler.getTaskDesc()).storeDurably(true).usingJobData(jobDataMap).build();
//
//			Trigger trigger = TriggerBuilder.newTrigger()
//					.withSchedule(CronScheduleBuilder.cronSchedule(taskScheduler.getTaskCron()))
//					.withIdentity(taskScheduler.getTaskName(), taskScheduler.getGroupName())
//					.withDescription(taskScheduler.getTaskDesc()).forJob(jobDetail).usingJobData(jobDataMap).build();
//
//			resultMap.put(trigger, jobDetail);
//		}

		// 定期删除Ｌｏｇ
		JobDataMap jobDataMap = new JobDataMap();
		jobDataMap.put("enable", 1);
		jobDataMap.put("taskType", "local");
		jobDataMap.put("desc", "定期删除定时批处理Log");
		JobDetail jobDetail = JobBuilder.newJob(JobTask.class)
				.withIdentity("deleteFireLog", "SchedulerServiceImpl")
				.withDescription("定期删除定时批处理Log").storeDurably(true).usingJobData(jobDataMap).build();

		Trigger trigger = TriggerBuilder.newTrigger()
				.withSchedule(CronScheduleBuilder.cronSchedule("0 0 0 1,15 * ?"))
				.withIdentity("deleteFireLog", "SchedulerServiceImpl")
				.withDescription("定期删除定时批处理Log").forJob(jobDetail).usingJobData(jobDataMap).build();

		resultMap.put(trigger, jobDetail);
		return resultMap;
	}

}
