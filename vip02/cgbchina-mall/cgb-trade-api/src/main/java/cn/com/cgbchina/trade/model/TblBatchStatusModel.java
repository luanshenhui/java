package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class TblBatchStatusModel implements Serializable {

    @Getter
    @Setter
    private Long id;//自增主键
    @Getter
    @Setter
    private String jobName;//作业名
    @Getter
    @Setter
    private String jobParam1;//作业参数1
    @Getter
    @Setter
    private String jobParam2;//作业参数2
    @Getter
    @Setter
    private String jobParam3;//作业参数3
    @Getter
    @Setter
    private String isSuccess;//是否成功
    @Getter
    @Setter
    private java.util.Date runTime;//运行时间
    @Getter
    @Setter
    private String exceptionMsg;//异常信息
}