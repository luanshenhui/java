package cn.com.cgbchina.scheduler.manager;

import cn.com.cgbchina.scheduler.model.TaskScheduled;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.quartz.*;
import org.quartz.impl.matchers.GroupMatcher;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.Map.Entry;

/**
 * 默认的定时任务管理器
 * 
 */
@Slf4j
@Component
public class DefaultSchedulerManager implements SchedulerManager, InitializingBean {
	@Setter
	private Scheduler scheduler;
	@Setter
	private TriggerLoader triggerLoader;
	@Setter
	private JobListener jobListener;

	// 调度初始化入口
	public void afterPropertiesSet() throws Exception {
		if (this.jobListener != null) {
			log.info("Initing task scheduler[" + this.scheduler.getSchedulerName() + "] ");
			log.info("Add JobListener : " + jobListener.getName());
			this.scheduler.getListenerManager().addJobListener(jobListener);
		}

		// 根据配置的初始化装载
		if (this.triggerLoader != null) {
			log.info("Initing task scheduler[" + this.scheduler.getSchedulerName() + "] ");
			log.info("Initing triggerLoader[" + this.triggerLoader.getClass().getName() + "].");
			Map<Trigger, JobDetail> loadResultMap = this.triggerLoader.loadTriggers();
			if (loadResultMap != null) {
				for (Entry<Trigger, JobDetail> entry : loadResultMap.entrySet()) {
					this.addJobDetail(entry.getValue());
					this.addTrigger(entry.getKey());
				}
				log.info("Initing triggerLoader[" + this.triggerLoader.getClass().getName() + "] end .");
			} else {
				log.warn("No triggers loaded by triggerLoader[" + this.triggerLoader.getClass().getName() + "].");
			}
		} else {
			log.warn("No TriggerLoader for initing.");
		}
	}

	private void addTrigger(Trigger trigger) {
		Trigger oldTrigger = null;
		try {
			oldTrigger = scheduler.getTrigger(trigger.getKey());
		} catch (Exception e) {
		}
		try {
			if (oldTrigger == null) {
				log.info("Try to add trigger : " + trigger);
				// '任务状态 0禁用 1启用 2删除'
				int enabled = trigger.getJobDataMap().getIntValue("enable");
				if (enabled == 0) {

				} else if (enabled == 1) {
					scheduler.scheduleJob(trigger);
				} else if (enabled == 2) {

				}
			} else {
				// '任务状态 0禁用 1启用 2删除'
				int enabled = trigger.getJobDataMap().getIntValue("enable");
				if (enabled == 0) {
					scheduler.pauseTrigger(trigger.getKey());
				} else if (enabled == 1) {
					scheduler.rescheduleJob(trigger.getKey(), trigger);
				} else if (enabled == 2) {
					scheduler.pauseTrigger(trigger.getKey());
				}
			}
		} catch (SchedulerException e) {
			log.error("Try to add trigger : " + trigger + "  cause error : ", e);
		}
	}

	private void updateTrigger(Trigger trigger) {
		Trigger oldTrigger = null;
		try {
			oldTrigger = scheduler.getTrigger(trigger.getKey());
		} catch (Exception e) {
		}
		try {
			if (oldTrigger != null) {
				log.info("Try to update trigger : " + trigger);
				scheduler.rescheduleJob(trigger.getKey(), trigger);
				if (trigger.getJobDataMap().getIntValue("enable") != 2) {
					scheduler.pauseTrigger(trigger.getKey());
				}
			} else {
				log.warn("Can't update trigger : " + trigger);
			}
		} catch (SchedulerException e) {
			log.error("Try to update trigger : " + trigger + ", the old trigger is : "
					+ (oldTrigger == null ? "null" : oldTrigger.toString()) + " cause error : ", e);
		}
	}

	private void addJobDetail(JobDetail jobDetail) {
		JobDetail oldJobDetail = null;
		try {
			oldJobDetail = this.scheduler.getJobDetail(jobDetail.getKey());
		} catch (Exception e) {
		}
		try {
			if (oldJobDetail == null) {
				log.info("Try to add jobDetail : " + jobDetail);
				// '任务状态 0禁用 1启用 2删除'
				int enabled = jobDetail.getJobDataMap().getIntValue("enable");
				if (enabled == 0) {
				} else if (enabled == 1) {
					this.scheduler.addJob(jobDetail, true);
				}
			} else {
				// '任务状态 0禁用 1启用 2删除'
				int enabled = jobDetail.getJobDataMap().getIntValue("enable");
				if (enabled == 0) {
					this.scheduler.pauseJob(jobDetail.getKey());
				} else if (enabled == 1) {
					this.scheduler.addJob(jobDetail, true);
				} else if (enabled == 2) {
					this.scheduler.deleteJob(jobDetail.getKey());
				}
			}
		} catch (Exception e) {
			log.error("Try to add jobDetail : " + jobDetail + ", the old jobDetail is : "
					+ (oldJobDetail == null ? "null" : oldJobDetail.toString()) + " cause error : ", e);
		}
	}

	private void updateJobDetail(JobDetail jobDetail) {
		JobDetail oldJobDetail = null;
		try {
			oldJobDetail = this.scheduler.getJobDetail(jobDetail.getKey());
		} catch (Exception e) {
		}
		try {
			if (oldJobDetail != null) {
				log.info("Try to update oldJobDetail : " + oldJobDetail);
				this.scheduler.addJob(jobDetail, true);
			} else {
				log.warn("Can't update JobDetail : " + jobDetail);
			}
		} catch (SchedulerException e) {
			log.error("Try to update JobDetail : " + jobDetail + ", the old JobDetail is : "
					+ (oldJobDetail == null ? "null" : oldJobDetail.toString()) + " cause error : ", e);
		}
	}
	// 判断Job是否已经导入到定时器
	public boolean checkExists(TaskScheduled scheduleJob) {
		try {
			JobKey jobKey = JobKey.jobKey(scheduleJob.getTaskName(), scheduleJob.getTaskGroup());
			return scheduler.checkExists(jobKey);
		} catch (Exception e) {
			log.error("Try to checkExists Job cause error : ", e);
		}
		return false;
	}
	// 删除定时器Job
	public boolean delJob(TaskScheduled scheduleJob) {
		try {
			JobKey jobKey = JobKey.jobKey(scheduleJob.getTaskName(), scheduleJob.getTaskGroup());
			return scheduler.deleteJob(jobKey);
		} catch (Exception e) {
			log.error("Try to checkExists Job cause error : ", e);
		}
		return false;
	}

	public List<TaskScheduled> getAllJobDetail() {
		List<TaskScheduled> result = new LinkedList<TaskScheduled>();
		try {
			GroupMatcher<JobKey> matcher = GroupMatcher.jobGroupContains("");
			Set<JobKey> jobKeys = scheduler.getJobKeys(matcher);
			for (JobKey jobKey : jobKeys) {
				List<? extends Trigger> triggers = scheduler.getTriggersOfJob(jobKey);
				for (Trigger trigger : triggers) {
					TaskScheduled job = new TaskScheduled();
					job.setTaskName(jobKey.getName());
					job.setTaskGroup(jobKey.getGroup());
					Trigger.TriggerState triggerState = scheduler.getTriggerState(trigger.getKey());
					job.setStatus(triggerState.name());
					if (trigger instanceof CronTrigger) {
						CronTrigger cronTrigger = (CronTrigger) trigger;
						String cronExpression = cronTrigger.getCronExpression();
						job.setTaskCron(cronExpression);
					}
					job.setPreviousFireTime(trigger.getPreviousFireTime());
					job.setNextFireTime(trigger.getNextFireTime());
					job.setDesc(trigger.getJobDataMap().getString("desc"));
					result.add(job);
				}
			}
		} catch (Exception e) {
			log.error("Try to load All JobDetail cause error : ", e);
		}
		return result;
	}

	public JobDetail getJobDetailByTriggerName(Trigger trigger) {
		try {
			return this.scheduler.getJobDetail(trigger.getJobKey());
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
		return null;
	}

	// 获取运行中任务
	public List<TaskScheduled> getRuningJobDetail() {
		List<TaskScheduled> jobList = null;
		try {
			List<JobExecutionContext> executingJobs = scheduler.getCurrentlyExecutingJobs();
			jobList = new ArrayList<TaskScheduled>(executingJobs.size());
			for (JobExecutionContext executingJob : executingJobs) {
				TaskScheduled job = new TaskScheduled();
				JobDetail jobDetail = executingJob.getJobDetail();
				JobKey jobKey = jobDetail.getKey();
				Trigger trigger = executingJob.getTrigger();
				job.setTaskName(jobKey.getName());
				job.setTaskGroup(jobKey.getGroup());
				Trigger.TriggerState triggerState = scheduler.getTriggerState(trigger.getKey());
				job.setStatus(triggerState.name());
				if (trigger instanceof CronTrigger) {
					CronTrigger cronTrigger = (CronTrigger) trigger;
					String cronExpression = cronTrigger.getCronExpression();
					job.setTaskCron(cronExpression);
				}
				job.setPreviousFireTime(trigger.getPreviousFireTime());
				job.setNextFireTime(trigger.getNextFireTime());
				job.setDesc(trigger.getJobDataMap().getString("desc"));
				jobList.add(job);
			}
		} catch (Exception e) {
			log.error("Try to load running JobDetail cause error : ", e);
		}
		return jobList;
	}

	// 暂停任务
	public boolean stopJob(TaskScheduled scheduleJob) {
		try {
			JobKey jobKey = JobKey.jobKey(scheduleJob.getTaskName(), scheduleJob.getTaskGroup());
			scheduler.pauseJob(jobKey);
			return true;
		} catch (Exception e) {
			log.error("Try to stop Job cause error : ", e);
		}
		return false;
	}

	// 启动任务
	public boolean resumeJob(TaskScheduled scheduleJob) {
		try {
			JobKey jobKey = JobKey.jobKey(scheduleJob.getTaskName(), scheduleJob.getTaskGroup());
			scheduler.resumeJob(jobKey);
			return true;
		} catch (Exception e) {
			log.error("Try to resume Job cause error : ", e);
		}
		return false;
	}

	// 执行任务
	public boolean runJob(TaskScheduled scheduleJob) {
		try {
			JobKey jobKey = JobKey.jobKey(scheduleJob.getTaskName(), scheduleJob.getTaskGroup());
			scheduler.triggerJob(jobKey);
			return true;
		} catch (Exception e) {
			log.error("Try to resume Job cause error : ", e);
		}
		return false;
	}
	private void addTasks(List<TaskScheduled> taskSchedulers) {
		Map<Trigger, JobDetail> resultMap = Maps.newHashMap();
		for (TaskScheduled scheduled : taskSchedulers) {
			JobDataMap jobDataMap = new JobDataMap();
			jobDataMap.put("id", scheduled.getId());
			jobDataMap.put("enable", scheduled.getStatus());
			jobDataMap.put("desc", scheduled.getDesc());
			jobDataMap.put("taskType", scheduled.getTaskType());
			jobDataMap.put("params", scheduled.getParamArgs());

			if (scheduled.getPromotionStartDate() == null) {
				JobDetail jobDetail = JobBuilder.newJob(JobTask.class)
						.withIdentity(scheduled.getTaskName(), scheduled.getTaskGroup())
						.withDescription(scheduled.getDesc()).storeDurably(true).usingJobData(jobDataMap).build();
				Trigger trigger = TriggerBuilder.newTrigger()
						.withSchedule(CronScheduleBuilder.cronSchedule(scheduled.getTaskCron()))
						.withIdentity(scheduled.getTaskName(), scheduled.getTaskGroup())
						.withDescription(scheduled.getDesc()).forJob(jobDetail).usingJobData(jobDataMap).build();
				this.addJobDetail(jobDetail);
				this.addTrigger(trigger);
			} else {
				JobDetail jobDetail = JobBuilder.newJob(JobTask.class)
						.withIdentity(scheduled.getTaskName(), scheduled.getTaskGroup())
						.withDescription(scheduled.getDesc()).storeDurably(false).usingJobData(jobDataMap).build();
				Trigger trigger = TriggerBuilder.newTrigger()
						.startAt(scheduled.getPromotionStartDate())
						.withIdentity(scheduled.getTaskName(), scheduled.getTaskGroup())
						.withDescription(scheduled.getDesc()).forJob(jobDetail).usingJobData(jobDataMap).build();
				try {
					this.scheduler.scheduleJob(jobDetail, trigger);
				} catch (SchedulerException e) {
					log.error("promotion scheduler erro{}", Throwables.getStackTraceAsString(e));
				}
			}
		}
	}
	// 追加任务
	public void addTaskJob(List<TaskScheduled> taskSchedulers) {
		addTasks(taskSchedulers);
	}

	public boolean refreshScheduler() {
		try {
			// 根据配置的初始化装载
			if (this.triggerLoader != null) {
				log.info("Initing task scheduler[" + this.scheduler.getSchedulerName() + "]");
				// 获取原始调度状态
				List<TaskScheduled> scheduleJobs = getAllJobDetail();
				Map<String, String> stateMap = Maps.newHashMap();
				for (TaskScheduled scheduleJob : scheduleJobs) {
					stateMap.put(scheduleJob.getTaskGroup() + "." + scheduleJob.getTaskName(), scheduleJob.getStatus());
				}
				// 清空调度
				scheduler.clear();
				// 加载调度
				log.info("Initing triggerLoader[" + this.triggerLoader.getClass().getName() + "].");
				Map<Trigger, JobDetail> loadResultMap = this.triggerLoader.loadTriggers();
				if (loadResultMap != null) {
					for (Entry<Trigger, JobDetail> entry : loadResultMap.entrySet()) {
						this.addJobDetail(entry.getValue());
						this.addTrigger(entry.getKey());
						JobKey jobKey = entry.getValue().getKey();
						String key = jobKey.getGroup() + "." + jobKey.getName();
						// 新增任务或原来为暂停状态
						if ("PAUSED".equals(stateMap.get(key)) || !stateMap.containsKey(key)) {
							scheduler.pauseJob(jobKey);
						}
					}
					log.info("Initing triggerLoader[" + this.triggerLoader.getClass().getName() + "] end .");
				} else {
					log.warn("No triggers loaded by triggerLoader[" + this.triggerLoader.getClass().getName() + "].");
				}
			} else {
				log.warn("No TriggerLoader for initing.");
			}
			return true;
		} catch (Exception e) {
			log.error("Try to refresh scheduler cause error : ", e);
		}
		return false;
	}
}
