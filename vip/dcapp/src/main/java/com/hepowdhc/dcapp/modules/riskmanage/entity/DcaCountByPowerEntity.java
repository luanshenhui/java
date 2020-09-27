/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.riskmanage.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 按权力统计Entity
 */
public class DcaCountByPowerEntity extends DataEntity<DcaCountByPowerEntity> {

	private static final long serialVersionUID = 1L;

	/**
	 * 权力id
	 */
	private String powerId;

	/**
	 * 权力名称
	 */
	private String powerName;

	/**
	 * 数量
	 */
	private Long totalCount;

	public String getPowerId() {
		return powerId;
	}

	public void setPowerId(String powerId) {
		this.powerId = powerId;
	}

	public String getPowerName() {
		return powerName;
	}

	public void setPowerName(String powerName) {
		this.powerName = powerName;
	}

	public Long getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(Long totalCount) {
		this.totalCount = totalCount;
	}

}