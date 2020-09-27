package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.Date;

/**
 * Created by 11150121040023 on 2016/8/15.
 */
@Setter
@Getter
@ToString
public class BatchStatusModel extends BaseModel implements Serializable {
    private static final long serialVersionUID = 3687256148940530322L;
    private Long id;
    private String jobName;
    private String jobParam1;
    private String jobParam2;
    private String jobParam3;
    private String isSuccess;
    private Date runTime;
    private String exceptionMsg;
    private String beginDate;
}
