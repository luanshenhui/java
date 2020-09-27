package com.hepowdhc.dcapp.modules.gzw.entity;

import java.util.Date;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 企业业务实例表Entity
 * 
 * @author geshuo
 * @date 2017年1月3日
 */
public class DcaCoPowerInstanceCountEntity extends DataEntity<DcaCoPowerInstanceCountEntity> {

	private static final long serialVersionUID = 1L;

	/**
	 * 主键
	 */
	private String uuId;

	/**
	 * 工作流id
	 */
	private String wfId;

	/**
	 * 权力id
	 */
	private String powerId;

	/**
	 * 实例数量
	 */
	private Long instanceCount;

	/**
	 * 删除标记
	 */
	private String delFlag;

	/**
	 * 创建人
	 */
	private String createPerson;

	/**
	 * 创建时间
	 */
	private Date createDate;

	/**
	 * 更新人
	 */
	private String updatePerson;

	/**
	 * 更新时间
	 */
	private Date updateDate;

	/**
	 * 备注
	 */
	private String remarks;

	/**
	 * 实例节点的数据数量
	 */
	private Long instanceNodeCount;

	/**
	 * 企业id
	 */
	private String coId;

	public String getUuId() {
		return uuId;
	}

	public void setUuId(String uuId) {
		this.uuId = uuId;
	}

	public String getWfId() {
		return wfId;
	}

	public void setWfId(String wfId) {
		this.wfId = wfId;
	}

	public String getPowerId() {
		return powerId;
	}

	public void setPowerId(String powerId) {
		this.powerId = powerId;
	}

	public Long getInstanceCount() {
		return instanceCount;
	}

	public void setInstanceCount(Long instanceCount) {
		this.instanceCount = instanceCount;
	}

	public String getDelFlag() {
		return delFlag;
	}

	public void setDelFlag(String delFlag) {
		this.delFlag = delFlag;
	}

	public String getCreatePerson() {
		return createPerson;
	}

	public void setCreatePerson(String createPerson) {
		this.createPerson = createPerson;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public String getUpdatePerson() {
		return updatePerson;
	}

	public void setUpdatePerson(String updatePerson) {
		this.updatePerson = updatePerson;
	}

	public Date getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public Long getInstanceNodeCount() {
		return instanceNodeCount;
	}

	public void setInstanceNodeCount(Long instanceNodeCount) {
		this.instanceNodeCount = instanceNodeCount;
	}

	public String getCoId() {
		return coId;
	}

	public void setCoId(String coId) {
		this.coId = coId;
	}

}