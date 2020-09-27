package cn.com.cgbchina.scheduler.manager;

import cn.com.cgbchina.scheduler.model.TaskScheduled;
import org.quartz.JobDetail;
import org.quartz.Trigger;

import java.util.List;

/**
 * 调度器管理
 * 
 */
public interface SchedulerManager {

	public List<TaskScheduled> getAllJobDetail();

	public JobDetail getJobDetailByTriggerName(Trigger trigger);

	/** 获取运行中任务 */
	public List<TaskScheduled> getRuningJobDetail();

	/** 暂停任务 */
	public boolean stopJob(TaskScheduled scheduleJob);

	/** 恢复任务 */
	public boolean resumeJob(TaskScheduled scheduleJob);

	/** 运行任务 */
	public boolean runJob(TaskScheduled scheduleJob);

	/** 刷新调度(新增任务为暂停状态) */
	public boolean refreshScheduler();

	void addTaskJob(List<TaskScheduled> taskSchedulers);

	/** check任务是否存在 */
	boolean checkExists(TaskScheduled scheduleJob);

	/** 删除定时器Job */
	boolean delJob(TaskScheduled scheduleJob);
}
