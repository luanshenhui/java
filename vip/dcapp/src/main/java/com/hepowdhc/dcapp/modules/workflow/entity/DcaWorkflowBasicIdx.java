/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.entity;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 告警指标管理Entity
 * 
 * @author hanxin'an
 * @version 2016-11-08
 */
public class DcaWorkflowBasicIdx extends DataEntity<DcaWorkflowBasicIdx> {

	private static final long serialVersionUID = 1L;
	private String idxId; // 指标id
	private String idxName; // 指标名称
	private String idxSql; // sql语句
	private String idxDataType; // 指标数据类型
	private String createPerson; // 创建人
	private String updatePerson; // 更新者
	private String remarks;

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public DcaWorkflowBasicIdx() {
		super();
	}

	public DcaWorkflowBasicIdx(String id) {
		super(id);
	}

	@Length(min = 1, max = 50, message = "指标id长度必须介于 1 和 50 之间")
	public String getIdxId() {
		return idxId;
	}

	public void setIdxId(String idxId) {
		this.idxId = idxId;
	}

	@Length(min = 1, max = 30, message = "指标名称长度必须介于 1 和 30 之间且不能重复")
	public String getIdxName() {
		return idxName;
	}

	public void setIdxName(String idxName) {
		this.idxName = idxName;
	}

	@Length(min = 1, max = 600, message = "SQL语句长度必须介于 1 和 600 之间")
	public String getIdxSql() {
		return idxSql;
	}

	public void setIdxSql(String idxSql) {
		this.idxSql = idxSql;
	}

	@Length(min = 1, max = 5, message = "指标数据类型长度必须介于 1 和 5 之间")
	public String getIdxDataType() {
		return idxDataType;
	}

	public void setIdxDataType(String idxDataType) {
		this.idxDataType = idxDataType;
	}

	@Length(min = 0, max = 64, message = "创建人长度必须介于 0 和 64 之间")
	public String getCreatePerson() {
		return createPerson;
	}

	public void setCreatePerson(String createPerson) {
		this.createPerson = createPerson;
	}

	@Length(min = 0, max = 64, message = "更新者长度必须介于 0 和 64 之间")
	public String getUpdatePerson() {
		return updatePerson;
	}

	public void setUpdatePerson(String updatePerson) {
		this.updatePerson = updatePerson;
	}

}