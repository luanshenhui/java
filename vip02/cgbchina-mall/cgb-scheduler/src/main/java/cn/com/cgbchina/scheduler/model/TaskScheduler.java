package cn.com.cgbchina.scheduler.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Getter
@Setter
@ToString
public class TaskScheduler extends BaseModel {

    private static final long serialVersionUID = 2909427426717779697L;
    private Integer id;
    private String groupName;
    private String taskName;
    private String taskType;
    private String taskDesc;
    private String taskCron;
    private Date taskPreviousFireTime;
    private Date taskNextFireTime;
    private String contactEmail;
    private Integer enable;
    private Integer createBy;
    private Date createTime;
    private Integer updateBy;
    private Date updateTime;

}