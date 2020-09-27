/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.entity;

import java.util.List;

import com.hepowdhc.dcapp.modules.risklist.entity.DcaAlarmRiskList;
import com.hepowdhc.dcapp.modules.risklist.entity.DcaPowerList;
import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 工作流节点内容Entity
 * 
 * @author ThinkGem
 * @version 2016-11-17
 */
public class DcaWorkflowTaskContentPop extends DataEntity<DcaWorkflowTaskContentPop> {

	private static final long serialVersionUID = 1L;

	// 基础条件
	private String wfId; // 工作流Id
	private String taskId; // 节点Id
	private String taskName; // 节点名称
	private String bizRoleId; // 业务角色ID 多选,逗号隔开
	private List<DcaPowerList> bizRoleIdList; // 业务角色IDList
	private String bizTaskId; // 业务节点ID
	private String isShow; // 本节点是否启用

	// 时间约束
	private String alarmTypeTime; // 预警/风险维度，时间约束
	private String isEffectiveTime; // 时间约束是否启用.0:停止；1：启用
	private Long timeNeed; // 本节点需要时间;触发条件
	private String timeNeedUnit; // 时间单位
	private String timeStart1; // 本节点需要时间黄色
	private String timeStart2; // 本节点需要时间橙色
	private String timeStart3; // 本节点需要时间红色
	private String timeEnd1; // 本节点需要时间黄色
	private String timeEnd2; // 本节点需要时间橙色
	private String timeEnd3; // 本节点需要时间红色
	private Long timeSum; // 至本节点完成所需时间;触发条件
	private String timeSumUnit; // 至本节点完成所需时间的时间单位
	private String timeSumStart1; // 至本节点需要时间黄色
	private String timeSumStart2; // 至本节点需要时间橙色
	private String timeSumStart3; // 至本节点需要时间红色
	private String timeSumEnd1; // 至本节点需要时间黄色
	private String timeSumEnd2; // 至本节点需要时间橙色
	private String timeSumEnd3; // 至本节点需要时间红色
	private String isRiskTime; // 是否为风险 时间约束
	private String riskIdTime; // 风险清单ID 时间约束
	private String isManualJudgeTime; // 是否可以人工界定风险 0:否；1：是 时间约束

	// 职能约束
	private String alarmTypeCompetency; // 预警/风险维度，职能约束
	private String isEffectiveCompetency; // 职能约束是否启用.0:停止；1：启用
	private String isRiskCompetency; // 是否为风险 职能约束
	private String riskIdCompetency; // 风险清单ID 职能约束
	private String isManualJudgeCompetency; // 是否可以人工界定风险 0:否；1：是 职能约束
	private String postId; // 岗位
	private String postName; // 岗位
	private String alarmLevelCompetency; // 预警级别，职能约束

	// 行为约束
	private String alarmTypeAction; // 预警/风险维度,行为约束
	private String isEffectiveAction; // 行为约束是否启用.0:停止；1：启用
	private String isRiskAction; // 是否为风险 行为约束
	private String riskIdAction; // 风险清单ID 行为约束
	private String isManualJudgeAction; // 是否可以人工界定风险 0:否；1：是 行为约束
	private String alarmLevelAction; // 预警级别,行为约束
	private String computeRuleAction; // 计算公式，计算SQL,行为约束

	// 互证约束
	private String alarmTypeMutually; // 预警/风险维度,互证约束
	private String isEffectiveMutually; // 互证约束是否启用.0:停止；1：启用
	private String isRiskMutually; // 是否为风险 互证约束
	private String riskIdMutually; // 风险清单ID 互证约束
	private String isManualJudgeMutually; // 是否可以人工界定风险 0:否；1：是 互证约束
	private String alarmLevelMutually; // 预警级别,互证约束
	private String computeRuleMutually; // 计算公式，计算SQL,互证约束

	private List<DcaAlarmRiskList> riskList; // 风险清单

	public String getTaskName() {
		return taskName;
	}

	public void setTaskName(String taskName) {
		this.taskName = taskName;
	}

	public String getBizRoleId() {
		return bizRoleId;
	}

	public void setBizRoleId(String bizRoleId) {
		this.bizRoleId = bizRoleId;
	}

	public String getBizTaskId() {
		return bizTaskId;
	}

	public void setBizTaskId(String bizTaskId) {
		this.bizTaskId = bizTaskId;
	}

	public String getAlarmTypeTime() {
		return alarmTypeTime;
	}

	public void setAlarmTypeTime(String alarmTypeTime) {
		this.alarmTypeTime = alarmTypeTime;
	}

	public String getAlarmTypeCompetency() {
		return alarmTypeCompetency;
	}

	public void setAlarmTypeCompetency(String alarmTypeCompetency) {
		this.alarmTypeCompetency = alarmTypeCompetency;
	}

	public String getAlarmTypeAction() {
		return alarmTypeAction;
	}

	public void setAlarmTypeAction(String alarmTypeAction) {
		this.alarmTypeAction = alarmTypeAction;
	}

	public String getAlarmTypeMutually() {
		return alarmTypeMutually;
	}

	public void setAlarmTypeMutually(String alarmTypeMutually) {
		this.alarmTypeMutually = alarmTypeMutually;
	}

	public String getIsEffectiveTime() {
		return isEffectiveTime;
	}

	public void setIsEffectiveTime(String isEffectiveTime) {
		this.isEffectiveTime = isEffectiveTime;
	}

	public String getIsEffectiveCompetency() {
		return isEffectiveCompetency;
	}

	public void setIsEffectiveCompetency(String isEffectiveCompetency) {
		this.isEffectiveCompetency = isEffectiveCompetency;
	}

	public String getIsEffectiveAction() {
		return isEffectiveAction;
	}

	public void setIsEffectiveAction(String isEffectiveAction) {
		this.isEffectiveAction = isEffectiveAction;
	}

	public String getIsEffectiveMutually() {
		return isEffectiveMutually;
	}

	public void setIsEffectiveMutually(String isEffectiveMutually) {
		this.isEffectiveMutually = isEffectiveMutually;
	}

	public Long getTimeNeed() {
		return timeNeed;
	}

	public void setTimeNeed(Long timeNeed) {
		this.timeNeed = timeNeed;
	}

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

	public String getTimeSumUnit() {
		return timeSumUnit;
	}

	public void setTimeSumUnit(String timeSumUnit) {
		this.timeSumUnit = timeSumUnit;
	}

	public String getIsRiskTime() {
		return isRiskTime;
	}

	public void setIsRiskTime(String isRiskTime) {
		this.isRiskTime = isRiskTime;
	}

	public String getIsRiskCompetency() {
		return isRiskCompetency;
	}

	public void setIsRiskCompetency(String isRiskCompetency) {
		this.isRiskCompetency = isRiskCompetency;
	}

	public String getIsRiskAction() {
		return isRiskAction;
	}

	public void setIsRiskAction(String isRiskAction) {
		this.isRiskAction = isRiskAction;
	}

	public String getIsRiskMutually() {
		return isRiskMutually;
	}

	public void setIsRiskMutually(String isRiskMutually) {
		this.isRiskMutually = isRiskMutually;
	}

	public String getRiskIdTime() {
		return riskIdTime;
	}

	public void setRiskIdTime(String riskIdTime) {
		this.riskIdTime = riskIdTime;
	}

	public String getRiskIdCompetency() {
		return riskIdCompetency;
	}

	public void setRiskIdCompetency(String riskIdCompetency) {
		this.riskIdCompetency = riskIdCompetency;
	}

	public String getRiskIdAction() {
		return riskIdAction;
	}

	public void setRiskIdAction(String riskIdAction) {
		this.riskIdAction = riskIdAction;
	}

	public String getRiskIdMutually() {
		return riskIdMutually;
	}

	public void setRiskIdMutually(String riskIdMutually) {
		this.riskIdMutually = riskIdMutually;
	}

	public String getIsManualJudgeTime() {
		return isManualJudgeTime;
	}

	public void setIsManualJudgeTime(String isManualJudgeTime) {
		this.isManualJudgeTime = isManualJudgeTime;
	}

	public String getIsManualJudgeCompetency() {
		return isManualJudgeCompetency;
	}

	public void setIsManualJudgeCompetency(String isManualJudgeCompetency) {
		this.isManualJudgeCompetency = isManualJudgeCompetency;
	}

	public String getIsManualJudgeAction() {
		return isManualJudgeAction;
	}

	public void setIsManualJudgeAction(String isManualJudgeAction) {
		this.isManualJudgeAction = isManualJudgeAction;
	}

	public String getIsManualJudgeMutually() {
		return isManualJudgeMutually;
	}

	public void setIsManualJudgeMutually(String isManualJudgeMutually) {
		this.isManualJudgeMutually = isManualJudgeMutually;
	}

	public String getPostId() {
		return postId;
	}

	public void setPostId(String postId) {
		this.postId = postId;
	}

	public String getAlarmLevelCompetency() {
		return alarmLevelCompetency;
	}

	public void setAlarmLevelCompetency(String alarmLevelCompetency) {
		this.alarmLevelCompetency = alarmLevelCompetency;
	}

	public String getAlarmLevelAction() {
		return alarmLevelAction;
	}

	public void setAlarmLevelAction(String alarmLevelAction) {
		this.alarmLevelAction = alarmLevelAction;
	}

	public String getAlarmLevelMutually() {
		return alarmLevelMutually;
	}

	public void setAlarmLevelMutually(String alarmLevelMutually) {
		this.alarmLevelMutually = alarmLevelMutually;
	}

	public String getComputeRuleAction() {
		return computeRuleAction;
	}

	public void setComputeRuleAction(String computeRuleAction) {
		this.computeRuleAction = computeRuleAction;
	}

	public String getComputeRuleMutually() {
		return computeRuleMutually;
	}

	public void setComputeRuleMutually(String computeRuleMutually) {
		this.computeRuleMutually = computeRuleMutually;
	}

	public String getTimeStart1() {
		return timeStart1;
	}

	public void setTimeStart1(String timeStart1) {
		this.timeStart1 = timeStart1;
	}

	public String getTimeStart2() {
		return timeStart2;
	}

	public void setTimeStart2(String timeStart2) {
		this.timeStart2 = timeStart2;
	}

	public String getTimeStart3() {
		return timeStart3;
	}

	public void setTimeStart3(String timeStart3) {
		this.timeStart3 = timeStart3;
	}

	public String getTimeEnd1() {
		return timeEnd1;
	}

	public void setTimeEnd1(String timeEnd1) {
		this.timeEnd1 = timeEnd1;
	}

	public String getTimeEnd2() {
		return timeEnd2;
	}

	public void setTimeEnd2(String timeEnd2) {
		this.timeEnd2 = timeEnd2;
	}

	public String getTimeEnd3() {
		return timeEnd3;
	}

	public void setTimeEnd3(String timeEnd3) {
		this.timeEnd3 = timeEnd3;
	}

	public String getTimeSumStart1() {
		return timeSumStart1;
	}

	public void setTimeSumStart1(String timeSumStart1) {
		this.timeSumStart1 = timeSumStart1;
	}

	public String getTimeSumStart2() {
		return timeSumStart2;
	}

	public void setTimeSumStart2(String timeSumStart2) {
		this.timeSumStart2 = timeSumStart2;
	}

	public String getTimeSumStart3() {
		return timeSumStart3;
	}

	public void setTimeSumStart3(String timeSumStart3) {
		this.timeSumStart3 = timeSumStart3;
	}

	public String getTimeSumEnd1() {
		return timeSumEnd1;
	}

	public void setTimeSumEnd1(String timeSumEnd1) {
		this.timeSumEnd1 = timeSumEnd1;
	}

	public String getTimeSumEnd2() {
		return timeSumEnd2;
	}

	public void setTimeSumEnd2(String timeSumEnd2) {
		this.timeSumEnd2 = timeSumEnd2;
	}

	public String getTimeSumEnd3() {
		return timeSumEnd3;
	}

	public void setTimeSumEnd3(String timeSumEnd3) {
		this.timeSumEnd3 = timeSumEnd3;
	}

	public String getIsShow() {
		return isShow;
	}

	public void setIsShow(String isShow) {
		this.isShow = isShow;
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

	public List<DcaPowerList> getBizRoleIdList() {
		return bizRoleIdList;
	}

	public void setBizRoleIdList(List<DcaPowerList> bizRoleIdList) {
		this.bizRoleIdList = bizRoleIdList;
	}

	public List<DcaAlarmRiskList> getRiskList() {
		return riskList;
	}

	public void setRiskList(List<DcaAlarmRiskList> riskList) {
		this.riskList = riskList;
	}

	public String getPostName() {
		return postName;
	}

	public void setPostName(String postName) {
		this.postName = postName;
	}

}