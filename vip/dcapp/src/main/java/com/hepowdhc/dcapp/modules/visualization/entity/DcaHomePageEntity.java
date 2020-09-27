/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.visualization.entity;

import java.util.List;

import com.hepowdhc.dcapp.modules.alarm.entity.DcaAlarmDetail;
import com.hepowdhc.dcapp.modules.workflow.entity.Dict;
import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 首页Entity
 * 
 * @author liuc
 * @date 2016年12月23日
 */
public class DcaHomePageEntity extends DataEntity<DcaHomePageEntity> {

	private static final long serialVersionUID = 1L;

	private Integer bizDataCount; // 业务数据量

	private Integer riskAlarmLevelRCount; // 风险等级数量（红）
	private Integer riskAlarmLevelOCount; // 风险等级数量（橙）
	private Integer riskAlarmLevelYCount; // 风险等级数量（黄）

	private Integer riskAlarmLevelProcessedRCount; // 风险等级已处理数量（红）
	private Integer riskAlarmLevelProcessedOCount; // 风险等级已处理数量（橙）
	private Integer riskAlarmLevelProcessedYCount; // 风险等级已处理数量（黄）

	private Integer alarmLevelRCount; // 告警等级数量（红）
	private Integer alarmLevelOCount; // 告警等级数量（橙）
	private Integer alarmLevelYCount; // 告警等级数量（黄）

	private Integer alarmLevelProcessedRCount; // 告警等级已处理数量（红）
	private Integer alarmLevelProcessedOCount; // 告警等级已处理数量（橙）
	private Integer alarmLevelProcessedYCount; // 告警等级已处理数量（黄）

	private String closingTime; // 截止时间

	private List<Dict> powerName;

	// 刷新时间
	private String refreshTime;

	// 总业务流程数
	private String totalNumber;
	// 企业效能
	private String efficiency;
	// 自动播放频次
	private String frequency;
	// 时间维度（柱状图使用）
	private List<DcaHomePageFields> timeDimensionList;
	// 各部门风险状况（饼图使用）
	private List<DcaHomePageFields> involvedDepartmentList;
	// 业务综合效能分析（雷达图使用）
	private List<DcaHomePageFields> efficiencyAnalysisList;
	
	// 职责清单数量
	private Integer dutyListCount;
	
	// 涉及部门数量
	private Integer involvedDeptCount;
	
	// 关键流程数量
	private Integer keyWorkFlowCount;
	
	// 风险点数量
	private Integer riskListCount;
	
	// 告警风险列表
	private List<DcaAlarmDetail> alarmAndRiskList;
	
	public Integer getBizDataCount() {
		return bizDataCount;
	}

	public void setBizDataCount(Integer bizDataCount) {
		this.bizDataCount = bizDataCount;
	}

	public Integer getRiskAlarmLevelRCount() {
		return riskAlarmLevelRCount;
	}

	public void setRiskAlarmLevelRCount(Integer riskAlarmLevelRCount) {
		this.riskAlarmLevelRCount = riskAlarmLevelRCount;
	}

	public Integer getRiskAlarmLevelOCount() {
		return riskAlarmLevelOCount;
	}

	public void setRiskAlarmLevelOCount(Integer riskAlarmLevelOCount) {
		this.riskAlarmLevelOCount = riskAlarmLevelOCount;
	}

	public Integer getRiskAlarmLevelYCount() {
		return riskAlarmLevelYCount;
	}

	public void setRiskAlarmLevelYCount(Integer riskAlarmLevelYCount) {
		this.riskAlarmLevelYCount = riskAlarmLevelYCount;
	}

	public Integer getRiskAlarmLevelProcessedRCount() {
		return riskAlarmLevelProcessedRCount;
	}

	public void setRiskAlarmLevelProcessedRCount(Integer riskAlarmLevelProcessedRCount) {
		this.riskAlarmLevelProcessedRCount = riskAlarmLevelProcessedRCount;
	}

	public Integer getRiskAlarmLevelProcessedOCount() {
		return riskAlarmLevelProcessedOCount;
	}

	public void setRiskAlarmLevelProcessedOCount(Integer riskAlarmLevelProcessedOCount) {
		this.riskAlarmLevelProcessedOCount = riskAlarmLevelProcessedOCount;
	}

	public Integer getRiskAlarmLevelProcessedYCount() {
		return riskAlarmLevelProcessedYCount;
	}

	public void setRiskAlarmLevelProcessedYCount(Integer riskAlarmLevelProcessedYCount) {
		this.riskAlarmLevelProcessedYCount = riskAlarmLevelProcessedYCount;
	}

	public Integer getAlarmLevelRCount() {
		return alarmLevelRCount;
	}

	public void setAlarmLevelRCount(Integer alarmLevelRCount) {
		this.alarmLevelRCount = alarmLevelRCount;
	}

	public Integer getAlarmLevelOCount() {
		return alarmLevelOCount;
	}

	public void setAlarmLevelOCount(Integer alarmLevelOCount) {
		this.alarmLevelOCount = alarmLevelOCount;
	}

	public Integer getAlarmLevelYCount() {
		return alarmLevelYCount;
	}

	public void setAlarmLevelYCount(Integer alarmLevelYCount) {
		this.alarmLevelYCount = alarmLevelYCount;
	}

	public Integer getAlarmLevelProcessedRCount() {
		return alarmLevelProcessedRCount;
	}

	public void setAlarmLevelProcessedRCount(Integer alarmLevelProcessedRCount) {
		this.alarmLevelProcessedRCount = alarmLevelProcessedRCount;
	}

	public Integer getAlarmLevelProcessedOCount() {
		return alarmLevelProcessedOCount;
	}

	public void setAlarmLevelProcessedOCount(Integer alarmLevelProcessedOCount) {
		this.alarmLevelProcessedOCount = alarmLevelProcessedOCount;
	}

	public Integer getAlarmLevelProcessedYCount() {
		return alarmLevelProcessedYCount;
	}

	public void setAlarmLevelProcessedYCount(Integer alarmLevelProcessedYCount) {
		this.alarmLevelProcessedYCount = alarmLevelProcessedYCount;
	}

	public String getClosingTime() {
		return closingTime;
	}

	public void setClosingTime(String closingTime) {
		this.closingTime = closingTime;
	}

	public String getRefreshTime() {
		return refreshTime;
	}

	public void setRefreshTime(String refreshTime) {
		this.refreshTime = refreshTime;
	}

	public String getTotalNumber() {
		return totalNumber;
	}

	public void setTotalNumber(String totalNumber) {
		this.totalNumber = totalNumber;
	}

	public String getEfficiency() {
		return efficiency;
	}

	public void setEfficiency(String efficiency) {
		this.efficiency = efficiency;
	}

	public String getFrequency() {
		return frequency;
	}

	public void setFrequency(String frequency) {
		this.frequency = frequency;
	}

	public List<DcaHomePageFields> getTimeDimensionList() {
		return timeDimensionList;
	}

	public void setTimeDimensionList(List<DcaHomePageFields> timeDimensionList) {
		this.timeDimensionList = timeDimensionList;
	}

	public List<DcaHomePageFields> getInvolvedDepartmentList() {
		return involvedDepartmentList;
	}

	public void setInvolvedDepartmentList(List<DcaHomePageFields> involvedDepartmentList) {
		this.involvedDepartmentList = involvedDepartmentList;
	}

	public List<DcaHomePageFields> getEfficiencyAnalysisList() {
		return efficiencyAnalysisList;
	}

	public void setEfficiencyAnalysisList(List<DcaHomePageFields> efficiencyAnalysisList) {
		this.efficiencyAnalysisList = efficiencyAnalysisList;
	}

	public List<Dict> getPowerName() {
		return powerName;
	}

	public void setPowerName(List<Dict> powerName) {
		this.powerName = powerName;
	}

	public Integer getDutyListCount() {
		return dutyListCount;
	}

	public void setDutyListCount(Integer dutyListCount) {
		this.dutyListCount = dutyListCount;
	}

	public Integer getInvolvedDeptCount() {
		return involvedDeptCount;
	}

	public void setInvolvedDeptCount(Integer involvedDeptCount) {
		this.involvedDeptCount = involvedDeptCount;
	}

	public Integer getKeyWorkFlowCount() {
		return keyWorkFlowCount;
	}

	public void setKeyWorkFlowCount(Integer keyWorkFlowCount) {
		this.keyWorkFlowCount = keyWorkFlowCount;
	}

	public Integer getRiskListCount() {
		return riskListCount;
	}

	public void setRiskListCount(Integer riskListCount) {
		this.riskListCount = riskListCount;
	}

	public List<DcaAlarmDetail> getAlarmAndRiskList() {
		return alarmAndRiskList;
	}

	public void setAlarmAndRiskList(List<DcaAlarmDetail> alarmAndRiskList) {
		this.alarmAndRiskList = alarmAndRiskList;
	}

}