package cn.com.cgbchina.scheduler.dao;


import cn.com.cgbchina.scheduler.model.TaskScheduler;
import org.springframework.stereotype.Repository;

@Repository
public class TaskSchedulerDao extends BaseDao<TaskScheduler> {
    public TaskSchedulerDao() {
        super("TaskSchedulerMapper");
    }
}