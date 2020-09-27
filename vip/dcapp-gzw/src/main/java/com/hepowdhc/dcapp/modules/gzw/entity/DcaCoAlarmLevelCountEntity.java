package com.hepowdhc.dcapp.modules.gzw.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 告警等级统计Entity
 * 
 * @author geshuo
 * @date 2017年1月3日
 */
public class DcaCoAlarmLevelCountEntity extends DataEntity<DcaCoAlarmLevelCountEntity> {

	private static final long serialVersionUID = 1L;

	/**
	 * 企业id
	 */
	private String coId;

	/**
	 * 企业名称
	 */
	private String coName;

	/**
	 * 告警等级
	 */
	private String alarmLevel;

	/**
	 * 告警数量
	 */
	private Long alarmCount;

	public String getCoId() {
		return coId;
	}

	public void setCoId(String coId) {
		this.coId = coId;
	}

	public String getCoName() {
		return coName;
	}

	public void setCoName(String coName) {
		this.coName = coName;
	}

	public String getAlarmLevel() {
		return alarmLevel;
	}

	public void setAlarmLevel(String alarmLevel) {
		this.alarmLevel = alarmLevel;
	}

	public Long getAlarmCount() {
		return alarmCount;
	}

	public void setAlarmCount(Long alarmCount) {
		this.alarmCount = alarmCount;
	}

}