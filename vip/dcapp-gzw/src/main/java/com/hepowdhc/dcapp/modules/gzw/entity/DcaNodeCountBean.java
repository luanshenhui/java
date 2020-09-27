package com.hepowdhc.dcapp.modules.gzw.entity;

/**
 * 节点统计数据
 * 
 * @author geshuo
 * @date 2017年1月5日
 */
public class DcaNodeCountBean {

	private Long alarmCount;
	private Long riskCount;
	private Long bizDataCount;

	public Long getAlarmCount() {
		return alarmCount;
	}

	public void setAlarmCount(Long alarmCount) {
		this.alarmCount = alarmCount;
	}

	public Long getRiskCount() {
		return riskCount;
	}

	public void setRiskCount(Long riskCount) {
		this.riskCount = riskCount;
	}

	public Long getBizDataCount() {
		return bizDataCount;
	}

	public void setBizDataCount(Long bizDataCount) {
		this.bizDataCount = bizDataCount;
	}

}