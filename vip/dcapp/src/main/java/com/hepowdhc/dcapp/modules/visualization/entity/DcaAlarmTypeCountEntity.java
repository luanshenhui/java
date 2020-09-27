/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.visualization.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 简单统计Entity
 * 
 * @author geshuo
 * @date 2017年1月5日
 */
public class DcaAlarmTypeCountEntity extends DataEntity<DcaAlarmTypeCountEntity> {

	private static final long serialVersionUID = 1L;

	/**
	 * 告警级别
	 */
	private String alarmType;

	/**
	 * 统计数量
	 */
	private Long count;

	public Long getCount() {
		return count;
	}

	public void setCount(Long count) {
		this.count = count;
	}

	public String getAlarmType() {
		return alarmType;
	}

	public void setAlarmType(String alarmType) {
		this.alarmType = alarmType;
	}
}