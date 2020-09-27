/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.entity;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 工作流节点内容Entity
 * 
 * @author ThinkGem
 * @version 2016-11-17
 */
public class DcaWorkflowTaskContent extends DataEntity<DcaWorkflowTaskContent> {

	private static final long serialVersionUID = 1L;
	private String uuid; // UUID
	private String taskId; // 节点ID
	private String postId; // 岗位
	private String computeRule; // 计算公式，计算SQL
	private String alarmType; // 预警/风险维度
	private String alarmLevel; // 预警级别
	private String alarmLevelNeed; // 本节点需要时间预警级别设置
	private String alarmLevelSum; // 至本节点完成所需时间预警级别设置
	private Long timeNeed; // 本节点需要时间;触发条件
	private String timeNeedUnit; // 时间单位
	private Long timeSum; // 至本节点完成所需时间;触发条件
	private String timeSumUnit; // 至本节点完成所需时间的时间单位
	private String isRisk; // 是否为风险
	private String riskId; // 风险清单ID
	private String isManualJudge; // 是否可以人工界定风险 0:否；1：是
	private String isEffective; // 是否有效.0:停止；1：启用
	private String createPerson; // 创建人
	private String updatePerson; // 更新者

	public DcaWorkflowTaskContent() {
		super();
	}

	public DcaWorkflowTaskContent(String id) {
		super(id);
	}

	@Length(min = 1, max = 50, message = "UUID长度必须介于 1 和 50 之间")
	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	@Length(min = 0, max = 50, message = "节点ID长度必须介于 0 和 50 之间")
	public String getTaskId() {
		return taskId;
	}

	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}

	@Length(min = 0, max = 64, message = "岗位长度必须介于 0 和 64 之间")
	public String getPostId() {
		return postId;
	}

	public void setPostId(String postId) {
		this.postId = postId;
	}

	@Length(min = 0, max = 1000, message = "计算公式，计算SQL长度必须介于 0 和 1000 之间")
	public String getComputeRule() {
		return computeRule;
	}

	public void setComputeRule(String computeRule) {
		this.computeRule = computeRule;
	}

	@Length(min = 0, max = 5, message = "预警/风险维度长度必须介于 0 和 5 之间")
	public String getAlarmType() {
		return alarmType;
	}

	public void setAlarmType(String alarmType) {
		this.alarmType = alarmType;
	}

	@Length(min = 0, max = 5, message = "预警级别长度必须介于 0 和 5 之间")
	public String getAlarmLevel() {
		return alarmLevel;
	}

	public void setAlarmLevel(String alarmLevel) {
		this.alarmLevel = alarmLevel;
	}

	@Length(min = 0, max = 50, message = "本节点需要时间预警级别设置长度必须介于 0 和 50 之间")
	public String getAlarmLevelNeed() {
		return alarmLevelNeed;
	}

	public void setAlarmLevelNeed(String alarmLevelNeed) {
		this.alarmLevelNeed = alarmLevelNeed;
	}

	@Length(min = 0, max = 50, message = "至本节点完成所需时间预警级别设置长度必须介于 0 和 50 之间")
	public String getAlarmLevelSum() {
		return alarmLevelSum;
	}

	public void setAlarmLevelSum(String alarmLevelSum) {
		this.alarmLevelSum = alarmLevelSum;
	}

	public Long getTimeNeed() {
		return timeNeed;
	}

	public void setTimeNeed(Long timeNeed) {
		this.timeNeed = timeNeed;
	}

	@Length(min = 0, max = 5, message = "时间单位长度必须介于 0 和 5 之间")
	public String getTimeNeedUnit() {
		return timeNeedUnit;
	}

	public void setTimeNeedUnit(String timeNeedUnit) {
		this.timeNeedUnit = timeNeedUnit;
	}

	public Long getTimeSum() {
		return timeSum;
	}

	public void setTimeSum(Long timeSum) {
		this.timeSum = timeSum;
	}

	@Length(min = 0, max = 5, message = "至本节点完成所需时间的时间单位长度必须介于 0 和 5 之间")
	public String getTimeSumUnit() {
		return timeSumUnit;
	}

	public void setTimeSumUnit(String timeSumUnit) {
		this.timeSumUnit = timeSumUnit;
	}

	@Length(min = 0, max = 5, message = "是否为风险长度必须介于 0 和 5 之间")
	public String getIsRisk() {
		return isRisk;
	}

	public void setIsRisk(String isRisk) {
		this.isRisk = isRisk;
	}

	@Length(min = 0, max = 50, message = "风险清单ID长度必须介于 0 和 50 之间")
	public String getRiskId() {
		return riskId;
	}

	public void setRiskId(String riskId) {
		this.riskId = riskId;
	}

	@Length(min = 0, max = 10, message = "是否可以人工界定风险长度必须介于 0 和 10 之间")
	public String getIsManualJudge() {
		return isManualJudge;
	}

	public void setIsManualJudge(String isManualJudge) {
		this.isManualJudge = isManualJudge;
	}

	@Length(min = 0, max = 2, message = "是否有效长度必须介于 0 和 2 之间")
	public String getIsEffective() {
		return isEffective;
	}

	public void setIsEffective(String isEffective) {
		this.isEffective = isEffective;
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

}