/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.system.entity;

/**
 * 时间维度Entity
 * 
 * @author zhengwei.cui
 * @version 2016-12-26
 */
public class TimeDimension {
	private String type; // 类型
	private Integer quarter; // 季度
	private String quarterName; // 季度
	private String alarmNum; // 告警数
	private String riskNum; // 风险数

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Integer getQuarter() {
		return quarter;
	}

	public void setQuarter(Integer quarter) {
		this.quarter = quarter;
	}

	public String getQuarterName() {
		return quarterName;
	}

	public void setQuarterName(String quarterName) {
		this.quarterName = quarterName;
	}

	public String getAlarmNum() {
		return alarmNum;
	}

	public void setAlarmNum(String alarmNum) {
		this.alarmNum = alarmNum;
	}

	public String getRiskNum() {
		return riskNum;
	}

	public void setRiskNum(String riskNum) {
		this.riskNum = riskNum;
	}
}
