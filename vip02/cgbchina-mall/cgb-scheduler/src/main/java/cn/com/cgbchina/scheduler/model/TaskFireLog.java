package cn.com.cgbchina.scheduler.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Getter
@Setter
@ToString
public class TaskFireLog extends BaseModel {

    private static final long serialVersionUID = 9086751458732186086L;
    private Integer id;
    private String groupName;
    private String taskName;
    private Date startTime;
    private Date endTime;
    private String status;
    private String serverHost;
    private String serverDuid;
    private String fireInfo;

}