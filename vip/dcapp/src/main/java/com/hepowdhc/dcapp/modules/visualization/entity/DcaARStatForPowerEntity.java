/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.visualization.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

public class DcaARStatForPowerEntity extends DataEntity<DcaARStatForPowerEntity> {

	private static final long serialVersionUID = 1L;

	/**
	 * 权力id
	 */
	private String powerId;

	/**
	 * 权力名称
	 */
	private String label;

	/**
	 * 业务事项数量
	 */
	private Integer workCount;

	/**
	 * 告警数量
	 */
	private Integer alarmCount;

	/**
	 * 风险数量
	 */
	private Integer riskCount;

	public String getPowerId() {
		return powerId;
	}

	public void setPowerId(String powerId) {
		this.powerId = powerId;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public Integer getWorkCount() {
		return workCount;
	}

	public void setWorkCount(Integer workCount) {
		this.workCount = workCount;
	}

	public Integer getAlarmCount() {
		return alarmCount;
	}

	public void setAlarmCount(Integer alarmCount) {
		this.alarmCount = alarmCount;
	}

	public Integer getRiskCount() {
		return riskCount;
	}

	public void setRiskCount(Integer riskCount) {
		this.riskCount = riskCount;
	}

	private String idxDataType; // 业务类型（三重一大、投资、担保）
	public String getIdxDataType() {
		return idxDataType;
	}

	public void setIdxDataType(String idxDataType) {
		this.idxDataType = idxDataType;
	}

}