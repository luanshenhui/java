package cn.com.cgbchina.scheduler.manager;


import cn.com.cgbchina.scheduler.model.TaskFireLog;
import cn.com.cgbchina.scheduler.model.TaskScheduled;
import cn.com.cgbchina.scheduler.model.TaskScheduler;
import com.spirit.common.model.Response;

import java.util.List;

/**
 * 定时任务管理
 * 
 */
public interface SchedulerService {
	/** 获取所有任务 */
	List<TaskScheduled> getAllTaskDetail();

	/** 执行任务 */
	boolean execTaskSingle(String taskGroup, String taskName);

	TaskScheduler getSchedulerById(Integer id);

	TaskFireLog updateLog(TaskFireLog record);

	TaskFireLog getFireLogById(Integer id);
	/** 执行任务 */
	Response<Boolean> execTask(List<TaskScheduled> taskScheduls, String cmd);

	void deleteFireLog();

	void loadTask(List<TaskScheduled> taskScheduls);

	void delOldJob();
}
