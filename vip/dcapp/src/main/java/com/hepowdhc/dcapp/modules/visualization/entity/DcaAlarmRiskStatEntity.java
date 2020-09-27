/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.visualization.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

public class DcaAlarmRiskStatEntity extends DataEntity<DcaAlarmRiskStatEntity> {

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
	 * 记录数
	 */
	private Integer totalCount;

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

	public Integer getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(Integer totalCount) {
		this.totalCount = totalCount;
	}
}