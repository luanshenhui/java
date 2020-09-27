package cn.com.cgbchina.scheduler.manager;

import cn.com.cgbchina.scheduler.dao.TaskFireLogDao;
import cn.com.cgbchina.scheduler.dao.TaskSchedulerDao;
import cn.com.cgbchina.scheduler.model.TaskFireLog;
import cn.com.cgbchina.scheduler.model.TaskScheduled;
import cn.com.cgbchina.scheduler.model.TaskScheduler;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

/**
 * 定时任务管理
 */
@Service
public class SchedulerServiceImpl implements SchedulerService {

    private static final Logger log = LoggerFactory.getLogger(SchedulerServiceImpl.class);
    @Autowired
    private TaskSchedulerDao taskSchedulerDao;
    @Autowired
    private TaskFireLogDao logDao;

    @Resource
    private SchedulerManager schedulerManager;

    // 获取所有作业
    public List<TaskScheduled> getAllTaskDetail() {
        return schedulerManager.getAllJobDetail();
    }

    // 执行作业
    public boolean execTaskSingle(String taskGroup, String taskName) {
        TaskScheduled taskScheduler = new TaskScheduled();
        taskScheduler.setTaskGroup(taskGroup);
        taskScheduler.setTaskName(taskName);
        return schedulerManager.runJob(taskScheduler);
    }

    @Transactional
    public void loadTask(List<TaskScheduled> taskScheduls) {
        for (TaskScheduled ts : taskScheduls) {
            // 任务是否已经导入定时器
            TaskScheduler tsr = new TaskScheduler();
            tsr.setGroupName(ts.getTaskGroup());
            tsr.setTaskName(ts.getTaskName());
            tsr.setTaskDesc(ts.getDesc());
            tsr.setTaskCron(ts.getTaskCron());
            try {
                tsr.setEnable(Integer.valueOf(ts.getStatus()));
            } catch (Exception e) {
                tsr.setEnable(1);
            }
            tsr.setTaskType(ts.getTaskType());
            List<TaskScheduler> tskSlist = taskSchedulerDao.selectByObj(tsr);
            if (tskSlist.size() == 0) {
                tsr.setCreateTime(new Date());
                taskSchedulerDao.insert(tsr);
            } else {
                tsr.setUpdateTime(new Date());
                tsr.setId(tskSlist.get(0).getId());
                taskSchedulerDao.updateByPrimaryKey(tsr);
            }
        }
        //任务导入定时器
//        schedulerManager.addTaskJob(taskScheduls);
    }

    @Override
    public void delOldJob() {

    }

    private TaskScheduler updateScheduler(TaskScheduler record) {
        if (record.getId() == null) {
            record.setCreateTime(new Date());
            taskSchedulerDao.insert(record);
        } else {
            record.setUpdateTime(new Date());
            taskSchedulerDao.updateByPrimaryKey(record);
        }
        return record;
    }
    // 执行任务
    @Transactional
    public Response<Boolean> execTask(List<TaskScheduled> taskScheduls, String cmd) {
        Response<Boolean> response = new Response<>();
        try {
            if ("delete".equals(cmd)) {
                try {
                    for (TaskScheduled ts : taskScheduls) {
                        TaskScheduler tsr = new TaskScheduler();
                        tsr.setGroupName(ts.getTaskGroup());
                        tsr.setTaskName(ts.getTaskName());
                        taskSchedulerDao.deleteByObj(tsr);
//                        schedulerManager.delJob(ts);
                        if (log.isInfoEnabled()) {
                            log.info(ts.getDesc() + "任务删除.");
                        }
                    }
                } catch (Exception e) {
                    System.out.println(Throwables.getStackTraceAsString(e));
                }
            } else if ("start".equals(cmd)) {
                loadTask(taskScheduls);
            } else if ("stop".equals(cmd)) {
                for (TaskScheduled ts : taskScheduls) {
                    schedulerManager.stopJob(ts);
                    if (log.isInfoEnabled()) {
                        log.info(ts.getDesc() + "任务停止.");
                    }
                }
            } else if ("reload".equals(cmd)) {
                schedulerManager.refreshScheduler();
            }
            response.setResult(Boolean.TRUE);
            return response;
        } catch (Exception e) {
            log.error("error{}.",Throwables.getStackTraceAsString(e));
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }

    // 暂停/恢复/删除作业
    private void openCloseTask(List<TaskScheduled> taskScheduls, String status) {
        boolean flg = false;
        for (TaskScheduled ts : taskScheduls) {
            if ("start".equals(status)) {
                flg = schedulerManager.resumeJob(ts);
                if (log.isInfoEnabled()) {
                    log.info(ts.getDesc() + "任务启动.");
                }

            } else if ("stop".equals(status)) {
                flg = schedulerManager.stopJob(ts);
                if (log.isInfoEnabled()) {
                    log.info(ts.getDesc() + "任务停止.");
                }
            }
        }
    }

    public TaskScheduler getSchedulerById(Integer id) {
        return taskSchedulerDao.selectByPrimaryKey(id);
    }

    public TaskFireLog getFireLogById(Integer id) {
        return logDao.selectByPrimaryKey(id);
    }

    @Transactional
    public TaskFireLog updateLog(TaskFireLog record) {
        if (record.getId() == null) {
            logDao.insert(record);
        } else {
            logDao.updateByPrimaryKey(record);
        }
        return record;
    }

    @Transactional
    public void deleteFireLog() {
        TaskFireLog record = new TaskFireLog();
        record.setStartTime(new DateTime(DateHelper.getyyyyMMdd()).minusDays(15).toDate());
        logDao.deleteByObj(record);
    }
}
