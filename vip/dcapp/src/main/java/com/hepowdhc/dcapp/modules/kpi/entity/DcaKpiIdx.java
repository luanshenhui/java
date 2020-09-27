/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.kpi.entity;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 企业绩效管理Entity
 * 
 * @author dhc
 * @version 2017-01-09
 */
public class DcaKpiIdx extends DataEntity<DcaKpiIdx> {

	private static final long serialVersionUID = 1L;
	private String uuId;
	private String idxId; // 考核指标ID
	private String idxName; // 指标名称
	private String idxType; // 绩效指标类型;读取数据字典
	private String idxResult; // 指标结果;读取数据字典
	private Double criticalityValue; // 临界值
	private String createPerson; // 创建人
	private String updatePerson; // 更新者

	private String idxTypeName;
	private String colName; // 列表名字

	private String dataMap; // 考核结果和绩效临界值

	private String kpiResult;// kpi绩效值

	public String getDataMap() {
		return dataMap;
	}

	public void setDataMap(String dataMap) {
		this.dataMap = dataMap;
	}

	public DcaKpiIdx() {
		super();
	}

	public DcaKpiIdx(String id) {
		super(id);
	}

	public String getUuId() {
		return uuId;
	}

	public void setUuId(String uuId) {
		this.uuId = uuId;
	}

	@Length(min = 1, max = 50, message = "考核指标ID长度必须介于 1 和 50 之间")
	public String getIdxId() {
		return idxId;
	}

	public void setIdxId(String idxId) {
		this.idxId = idxId;
	}

	@Length(min = 1, max = 200, message = "指标名称长度必须介于 1 和 200 之间")
	public String getIdxName() {
		return idxName;
	}

	public void setIdxName(String idxName) {
		this.idxName = idxName;
	}

	@Length(min = 0, max = 5, message = "绩效指标类型;读取数据字典长度必须介于 0 和 5 之间")
	public String getIdxType() {
		return idxType;
	}

	public void setIdxType(String idxType) {
		this.idxType = idxType;
	}

	@Length(min = 0, max = 5, message = "指标结果;读取数据字典长度必须介于 0 和 5 之间")
	public String getIdxResult() {
		return idxResult;
	}

	public void setIdxResult(String idxResult) {
		this.idxResult = idxResult;
	}

	public Double getCriticalityValue() {
		return criticalityValue;
	}

	public void setCriticalityValue(Double criticalityValue) {
		this.criticalityValue = criticalityValue;
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

	public String getIdxTypeName() {
		return idxTypeName;
	}

	public void setIdxTypeName(String idxTypeName) {
		this.idxTypeName = idxTypeName;
	}

	public String getColName() {
		return colName;
	}

	public void setColName(String colName) {
		this.colName = colName;
	}

	public String getKpiResult() {
		return kpiResult;
	}

	public void setKpiResult(String kpiResult) {
		this.kpiResult = kpiResult;
	}
}