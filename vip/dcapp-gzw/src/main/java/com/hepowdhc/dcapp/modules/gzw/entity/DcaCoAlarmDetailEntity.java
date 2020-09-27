package com.hepowdhc.dcapp.modules.gzw.entity;

import java.util.Date;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 企业告警信息表Entity
 * 
 * @author geshuo
 * @date 2017年1月3日
 */
public class DcaCoAlarmDetailEntity extends DataEntity<DcaCoAlarmDetailEntity> {

	private static final long serialVersionUID = 1L;

	/**
	 * 主键
	 */
	private String alarmDetailId;

	private String bizRoleId;

	/**
	 * 权力id
	 */
	private String powerId;

	private String riskId;

	private String bizFlowId;

	private String bizFlowName;

	private String bizOperPerson;

	private String bizOperPost;

	private String bizDataId;

	private String bizDataName;

	private String wfId;

	private String taskId;
	private String taskName;

	/**
	 * 告警等级
	 */
	private String alarmLevel;
	private String alarmType;
	private String cpuResult;
	private String alarmMsg;
	private String alarmTime1st;
	private String alarmStatus;
	private String visualScope;
	private String delFlag;
	private String createPerson;
	private Date createDate;
	private String updatePerson;
	private Date updateDate;
	private String remarks;

	/**
	 * 企业id
	 */
	private String coId;

	public String getAlarmDetailId() {
		return alarmDetailId;
	}

	public void setAlarmDetailId(String alarmDetailId) {
		this.alarmDetailId = alarmDetailId;
	}

	public String getBizRoleId() {
		return bizRoleId;
	}

	public void setBizRoleId(String bizRoleId) {
		this.bizRoleId = bizRoleId;
	}

	public String getPowerId() {
		return powerId;
	}

	public void setPowerId(String powerId) {
		this.powerId = powerId;
	}

	public String getRiskId() {
		return riskId;
	}

	public void setRiskId(String riskId) {
		this.riskId = riskId;
	}

	public String getBizFlowId() {
		return bizFlowId;
	}

	public void setBizFlowId(String bizFlowId) {
		this.bizFlowId = bizFlowId;
	}

	public String getBizFlowName() {
		return bizFlowName;
	}

	public void setBizFlowName(String bizFlowName) {
		this.bizFlowName = bizFlowName;
	}

	public String getBizOperPerson() {
		return bizOperPerson;
	}

	public void setBizOperPerson(String bizOperPerson) {
		this.bizOperPerson = bizOperPerson;
	}

	public String getBizOperPost() {
		return bizOperPost;
	}

	public void setBizOperPost(String bizOperPost) {
		this.bizOperPost = bizOperPost;
	}

	public String getBizDataId() {
		return bizDataId;
	}

	public void setBizDataId(String bizDataId) {
		this.bizDataId = bizDataId;
	}

	public String getBizDataName() {
		return bizDataName;
	}

	public void setBizDataName(String bizDataName) {
		this.bizDataName = bizDataName;
	}

	public String getWfId() {
		return wfId;
	}

	public void setWfId(String wfId) {
		this.wfId = wfId;
	}

	public String getTaskId() {
		return taskId;
	}

	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}

	public String getTaskName() {
		return taskName;
	}

	public void setTaskName(String taskName) {
		this.taskName = taskName;
	}

	public String getAlarmLevel() {
		return alarmLevel;
	}

	public void setAlarmLevel(String alarmLevel) {
		this.alarmLevel = alarmLevel;
	}

	public String getAlarmType() {
		return alarmType;
	}

	public void setAlarmType(String alarmType) {
		this.alarmType = alarmType;
	}

	public String getCpuResult() {
		return cpuResult;
	}

	public void setCpuResult(String cpuResult) {
		this.cpuResult = cpuResult;
	}

	public String getAlarmMsg() {
		return alarmMsg;
	}

	public void setAlarmMsg(String alarmMsg) {
		this.alarmMsg = alarmMsg;
	}

	public String getAlarmTime1st() {
		return alarmTime1st;
	}

	public void setAlarmTime1st(String alarmTime1st) {
		this.alarmTime1st = alarmTime1st;
	}

	public String getAlarmStatus() {
		return alarmStatus;
	}

	public void setAlarmStatus(String alarmStatus) {
		this.alarmStatus = alarmStatus;
	}

	public String getVisualScope() {
		return visualScope;
	}

	public void setVisualScope(String visualScope) {
		this.visualScope = visualScope;
	}

	public String getDelFlag() {
		return delFlag;
	}

	public void setDelFlag(String delFlag) {
		this.delFlag = delFlag;
	}

	public String getCreatePerson() {
		return createPerson;
	}

	public void setCreatePerson(String createPerson) {
		this.createPerson = createPerson;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public String getUpdatePerson() {
		return updatePerson;
	}

	public void setUpdatePerson(String updatePerson) {
		this.updatePerson = updatePerson;
	}

	public Date getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getCoId() {
		return coId;
	}

	public void setCoId(String coId) {
		this.coId = coId;
	}

}