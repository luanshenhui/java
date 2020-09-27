package cn.rkylin.core.job;

import org.apache.commons.lang.StringUtils;


public class JobInitVO {
    private String jobClass;
    private String cronExpression;

    public String getJobClass() {
        return jobClass;
    }

    public void setJobClass(String jobClass) {
        this.jobClass = jobClass;
    }

    public String getCronExpression() {
        return cronExpression;
    }

    public void setCronExpression(String cronExpression) {
        this.cronExpression = cronExpression;
    }

    public boolean check(){
        return StringUtils.isNotEmpty(jobClass) && StringUtils.isNotEmpty(cronExpression) ? true : false;
    }
}
