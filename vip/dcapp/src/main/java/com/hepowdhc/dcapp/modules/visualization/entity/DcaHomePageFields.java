package com.hepowdhc.dcapp.modules.visualization.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

public class DcaHomePageFields extends DataEntity<DcaHomePageEntity> {

	private static final long serialVersionUID = 1L;
	// 时间
	private String time;
	// 告警数
	private String alarmNumber;
	// 风险数
	private String riskNumber;
	// 部门
	private String deptName;
	// 风险占比
	private String proportion;
	// 效能名
	private String performanceName;
	// 效能值
	private String efficiencyValue;
	// 颜色
	private String colorValue;

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String getAlarmNumber() {
		return alarmNumber;
	}

	public void setAlarmNumber(String alarmNumber) {
		this.alarmNumber = alarmNumber;
	}

	public String getRiskNumber() {
		return riskNumber;
	}

	public void setRiskNumber(String riskNumber) {
		this.riskNumber = riskNumber;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public String getProportion() {
		return proportion;
	}

	public void setProportion(String proportion) {
		this.proportion = proportion;
	}

	public String getPerformanceName() {
		return performanceName;
	}

	public void setPerformanceName(String performanceName) {
		this.performanceName = performanceName;
	}

	public String getEfficiencyValue() {
		return efficiencyValue;
	}

	public void setEfficiencyValue(String efficiencyValue) {
		this.efficiencyValue = efficiencyValue;
	}

	public String getColorValue() {
		return colorValue;
	}

	public void setColorValue(String colorValue) {
		this.colorValue = colorValue;
	}

}
