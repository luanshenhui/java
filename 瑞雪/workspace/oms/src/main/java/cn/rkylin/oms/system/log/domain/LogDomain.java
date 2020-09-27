package cn.rkylin.oms.system.log.domain;//

import cn.rkylin.oms.common.base.BaseEntity;

public class LogDomain extends BaseEntity{
	/**
	 * 序列号
	 */
	private static final long serialVersionUID = 4861187942435848318L;
	private String bizId;// 业务Id 
	private String tag;// 标签 
	private String user;// 用户 
	private String operTime;// 操作时间 
	private String operation;// 操作内容 
	private String sourceType;// 来源类型 
	private String detail;// 日志明细 
	private String logType;// 日志类型 
	public String getBizId() {
		return bizId;
	}
	public void setBizId(String bizId) {
		this.bizId = bizId;
	}
	public String getTag() {
		return tag;
	}
	public void setTag(String tag) {
		this.tag = tag;
	}
	public String getUser() {
		return user;
	}
	public void setUser(String user) {
		this.user = user;
	}
	public String getOperTime() {
		return operTime;
	}
	public void setOperTime(String operTime) {
		this.operTime = operTime;
	}
	public String getOperation() {
		return operation;
	}
	public void setOperation(String operation) {
		this.operation = operation;
	}
	public String getSourceType() {
		return sourceType;
	}
	public void setSourceType(String sourceType) {
		this.sourceType = sourceType;
	}
	public String getDetail() {
		return detail;
	}
	public void setDetail(String detail) {
		this.detail = detail;
	}
	public String getLogType() {
		return logType;
	}
	public void setLogType(String logType) {
		this.logType = logType;
	}
	
	

}
