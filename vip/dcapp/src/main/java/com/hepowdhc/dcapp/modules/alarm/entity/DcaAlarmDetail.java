/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.alarm.entity;

import java.util.Date;
import java.util.List;

import org.hibernate.validator.constraints.Length;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.thinkgem.jeesite.common.persistence.DataEntity;
import com.thinkgem.jeesite.modules.sys.entity.DcaTraceUserRole;
import com.thinkgem.jeesite.modules.sys.entity.Office;

/**
 * 告警查询Entity
 * 
 * @author huibin.dong
 * @version 2016-11-15
 */
public class DcaAlarmDetail extends DataEntity<DcaAlarmDetail> {

	private static final long serialVersionUID = 1L;
	private String alarmDetailId; // 预警信息ID
	private String bizRoleId; // 业务角色id;via.dca_power_list
	private String powerId; // 权力id;via.dca_power_list
	private String riskId; // 风险清单id;via.dca_alarm_risk_list
	private String bizFlowId; // 业务实例id;via.ETL
	private String bizFlowName; // 业务实例名称
	private String bizOperPerson; // 业务操作人
	private String bizOperPost; // 业务操作人所属部门
	private String bizOperPostName; // 业务操作人所属部门名称
	private String bizDataId; // 业务数据id;via.ETL
	private String bizDataName; // 业务数据名称；画面表示为办理事项
	private String wfId; // 工作流id;via.workflow
	private String taskId; // 流程节点ID;via.workflow
	private String taskName; // 流程节点名;via.workflow
	private String alarmLevel; // 预警级别;读取数据字典
	private String alarmType; // 预警/风险维度;读取数据字典
	private String cpuResult; // 运算结果
	private String alarmMsg; // 告警信息
	private Date alarmTime1st; // 首次预警产生时间
	private String alarmStatus; // 告警状态
	private String visualScope; // 可视范围
	private String createPerson; // 创建人
	private String updatePerson; // 更新者
	private String alarmNumber; // 告警数量
	private String Quarter; // 季度
	private List<Office> officeList; // 更新者
	private List<DcaTraceUserRole> postList; // 登陆者所在岗位

	private String operPersonName; // 操作人名称
	private String type; // 用于区分预警和风险（预警-1;风险-2）

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public DcaAlarmDetail() {
		super();
	}

	public DcaAlarmDetail(String id) {
		super(id);
	}

	@Length(min = 1, max = 50, message = "预警信息ID长度必须介于 1 和 50 之间")
	public String getAlarmDetailId() {
		return alarmDetailId;
	}

	public void setAlarmDetailId(String alarmDetailId) {
		this.alarmDetailId = alarmDetailId;
	}

	@Length(min = 1, max = 50, message = "长度必须介于 0 和 50 之间")
	public String getBizRoleId() {
		return bizRoleId;
	}

	public void setBizRoleId(String bizRoleId) {
		this.bizRoleId = bizRoleId;
	}

	@Length(min = 1, max = 5, message = "长度必须介于 0 和 5 之间")
	public String getPowerId() {
		return powerId;
	}

	public void setPowerId(String powerId) {
		this.powerId = powerId;
	}

	@Length(min = 1, max = 50, message = "长度必须介于 0 和 50 之间")
	public String getRiskId() {
		return riskId;
	}

	public void setRiskId(String riskId) {
		this.riskId = riskId;
	}

	@Length(min = 1, max = 50, message = "长度必须介于 0 和 50 之间")
	public String getBizFlowId() {
		return bizFlowId;
	}

	public void setBizFlowId(String bizFlowId) {
		this.bizFlowId = bizFlowId;
	}

	@Length(min = 0, max = 100, message = "业务实例名称长度必须介于 0 和 100 之间")
	public String getBizFlowName() {
		return bizFlowName;
	}

	public void setBizFlowName(String bizFlowName) {
		this.bizFlowName = bizFlowName;
	}

	@Length(min = 0, max = 50, message = "业务操作人长度必须介于 0 和 50 之间")
	public String getBizOperPerson() {
		return bizOperPerson;
	}

	public void setBizOperPerson(String bizOperPerson) {
		this.bizOperPerson = bizOperPerson;
	}

	@Length(min = 0, max = 100, message = "业务操作人所属部门长度必须介于 0 和 100 之间")
	public String getBizOperPost() {
		return bizOperPost;
	}

	public void setBizOperPost(String bizOperPost) {
		this.bizOperPost = bizOperPost;
	}

	@Length(min = 1, max = 50, message = "长度必须介于 0 和 50 之间")
	public String getBizDataId() {
		return bizDataId;
	}

	public void setBizDataId(String bizDataId) {
		this.bizDataId = bizDataId;
	}

	@Length(min = 0, max = 100, message = "业务数据名称；画面表示为办理事项长度必须介于 0 和 100 之间")
	public String getBizDataName() {
		return bizDataName;
	}

	public void setBizDataName(String bizDataName) {
		this.bizDataName = bizDataName;
	}

	@Length(min = 1, max = 50, message = "长度必须介于 0 和 50 之间")
	public String getWfId() {
		return wfId;
	}

	public void setWfId(String wfId) {
		this.wfId = wfId;
	}

	@Length(min = 1, max = 50, message = "长度必须介于 0 和 50 之间")
	public String getTaskId() {
		return taskId;
	}

	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}

	@Length(min = 1, max = 50, message = "长度必须介于 0 和 100 之间")
	public String getTaskName() {
		return taskName;
	}

	public void setTaskName(String taskName) {
		this.taskName = taskName;
	}

	@Length(min = 0, max = 5, message = "预警级别;读取数据字典长度必须介于 0 和 5 之间")
	public String getAlarmLevel() {
		return alarmLevel;
	}

	public void setAlarmLevel(String alarmLevel) {
		this.alarmLevel = alarmLevel;
	}

	@Length(min = 0, max = 5, message = "预警/风险维度;读取数据字典长度必须介于 0 和 5 之间")
	public String getAlarmType() {
		return alarmType;
	}

	public void setAlarmType(String alarmType) {
		this.alarmType = alarmType;
	}

	@Length(min = 0, max = 500, message = "运算结果长度必须介于 0 和 500 之间")
	public String getCpuResult() {
		return cpuResult;
	}

	public void setCpuResult(String cpuResult) {
		this.cpuResult = cpuResult;
	}

	@Length(min = 0, max = 255, message = "告警信息长度必须介于 0 和 255 之间")
	public String getAlarmMsg() {
		return alarmMsg;
	}

	public void setAlarmMsg(String alarmMsg) {
		this.alarmMsg = alarmMsg;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getAlarmTime1st() {
		return alarmTime1st;
	}

	public void setAlarmTime1st(Date alarmTime1st) {
		this.alarmTime1st = alarmTime1st;
	}

	@Length(min = 0, max = 5, message = "告警状态长度必须介于 0 和 5 之间")
	public String getAlarmStatus() {
		return alarmStatus;
	}

	public void setAlarmStatus(String alarmStatus) {
		this.alarmStatus = alarmStatus;
	}

	@Length(min = 0, max = 100, message = "可视范围长度必须介于 0 和 100 之间")
	public String getVisualScope() {
		return visualScope;
	}

	public void setVisualScope(String visualScope) {
		this.visualScope = visualScope;
	}

	@Length(min = 0, max = 64, message = "创建人长度必须介于 0 和 64 之间")
	public String getCreatePerson() {
		return createPerson;
	}

	public void setCreatePerson(String createPerson) {
		this.createPerson = createPerson;
	}

	@Length(min = 0, max = 64, message = "更新者长度必须介于 0 和 64 之间")
	public String getUpdatePerson() {
		return updatePerson;
	}

	public void setUpdatePerson(String updatePerson) {
		this.updatePerson = updatePerson;
	}

	public String getBizOperPostName() {
		return bizOperPostName;
	}

	public void setBizOperPostName(String bizOperPostName) {
		this.bizOperPostName = bizOperPostName;
	}

	public List<Office> getOfficeList() {
		return officeList;
	}

	public void setOfficeList(List<Office> officeList) {
		this.officeList = officeList;
	}

	public List<DcaTraceUserRole> getPostList() {
		return postList;
	}

	public void setPostList(List<DcaTraceUserRole> postList) {
		this.postList = postList;
	}

	public String getOperPersonName() {
		return operPersonName;
	}

	public void setOperPersonName(String operPersonName) {
		this.operPersonName = operPersonName;
	}

	/**
	 * 年份
	 */
	private Integer year;

	public Integer getYear() {
		return year;
	}

	public void setYear(Integer year) {
		this.year = year;
	}

	public String getAlarmNumber() {
		return alarmNumber;
	}

	public void setAlarmNumber(String alarmNumber) {
		this.alarmNumber = alarmNumber;
	}

	public String getQuarter() {
		return Quarter;
	}

	public void setQuarter(String quarter) {
		Quarter = quarter;
	}

	private String idxDataType; // 业务类型（三重一大、投资、担保）
	public String getIdxDataType() {
		return idxDataType;
	}

	public void setIdxDataType(String idxDataType) {
		this.idxDataType = idxDataType;
	}

}