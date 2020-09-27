package com.hepowdhc.dcapp.modules.gzw.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 业务数据量统计Entity
 * 
 * @author geshuo
 * @date 2017年1月3日
 */
public class DcaCoPowerInstanceDataCountEntity extends DataEntity<DcaCoPowerInstanceDataCountEntity> {

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
	 * 权力Id（截取前两位）
	 */
	private String powerId;

	/**
	 * 权力名称
	 */
	private String powerName;

	/**
	 * 实例数量
	 */
	private Long instanceCount;

	public String getCoId() {
		return coId;
	}

	public void setCoId(String coId) {
		this.coId = coId;
	}

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

	public Long getInstanceCount() {
		return instanceCount;
	}

	public void setInstanceCount(Long instanceCount) {
		this.instanceCount = instanceCount;
	}

	public String getCoName() {
		return coName;
	}

	public void setCoName(String coName) {
		this.coName = coName;
	}

}