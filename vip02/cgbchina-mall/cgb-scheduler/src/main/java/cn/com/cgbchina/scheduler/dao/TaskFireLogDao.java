package cn.com.cgbchina.scheduler.dao;

import cn.com.cgbchina.scheduler.model.TaskFireLog;
import org.springframework.stereotype.Repository;

@Repository
public class TaskFireLogDao extends BaseDao<TaskFireLog> {
    public TaskFireLogDao() {
        super("TaskFireLogMapper");
    }
}