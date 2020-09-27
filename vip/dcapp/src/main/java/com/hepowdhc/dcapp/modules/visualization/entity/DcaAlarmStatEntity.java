/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.visualization.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 告警统计报表Entity
 * 
 * @author geshuo
 * @date 2016年12月7日
 */
public class DcaAlarmStatEntity extends DataEntity<DcaAlarmStatEntity> {

	private static final long serialVersionUID = 1L;

	/**
	 * 业务事项名称
	 */
	private String bizFlowName;

	/**
	 * 办理事项名称
	 */
	private String bizDataName;

	/**
	 * 黄色告警数量
	 */
	private Integer yellowCount;

	/**
	 * 橙色告警数量
	 */
	private Integer orangeCount;

	/**
	 * 红色告警数量
	 */
	private Integer redCount;

	/**
	 * 总告警数量
	 */
	private Integer totalCount;

	public String getBizFlowName() {
		return bizFlowName;
	}

	public void setBizFlowName(String bizFlowName) {
		this.bizFlowName = bizFlowName;
	}

	public String getBizDataName() {
		return bizDataName;
	}

	public void setBizDataName(String bizDataName) {
		this.bizDataName = bizDataName;
	}

	public Integer getYellowCount() {
		return yellowCount;
	}

	public void setYellowCount(Integer yellowCount) {
		this.yellowCount = yellowCount;
	}

	public Integer getOrangeCount() {
		return orangeCount;
	}

	public void setOrangeCount(Integer orangeCount) {
		this.orangeCount = orangeCount;
	}

	public Integer getRedCount() {
		return redCount;
	}

	public void setRedCount(Integer redCount) {
		this.redCount = redCount;
	}

	public Integer getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(Integer totalCount) {
		this.totalCount = totalCount;
	}

}