/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.kpi.entity;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 企业绩效管理Entity
 * 
 * @author dhc
 * @version 2017-01-09
 */
public class DcaKpiResult extends DataEntity<DcaKpiResult> {

	private static final long serialVersionUID = 1L;

	private String idName; // 指标名称
	private String kpiId; //

	private Integer nameId;
	private String idType;// 考核指标类型
	private String idTypeName;// 考核指标类型文字
	private String checkResultCode;// 考核结果编码
	private String checkResultText;// 考核结果文字

	private List<DcaKpiIdx> resultList;// 结果集

	public DcaKpiResult() {
		super();
	}

	public DcaKpiResult(String id) {
		super(id);
	}

	@Length(min = 0, max = 200, message = "指标名称长度必须介于 0 和 200 之间")
	public String getIdName() {
		return idName;
	}

	public void setIdName(String idName) {
		this.idName = idName;
	}

	public String getCheckResultCode() {
		return checkResultCode;
	}

	public void setCheckResultCode(String checkResultCode) {
		this.checkResultCode = checkResultCode;
	}

	public String getCheckResultText() {
		return checkResultText;
	}

	public void setCheckResultText(String checkResultText) {
		this.checkResultText = checkResultText;
	}

	public String getIdType() {
		return idType;
	}

	public void setIdType(String idType) {
		this.idType = idType;
	}

	public String getIdTypeName() {
		return idTypeName;
	}

	public void setIdTypeName(String idTypeName) {
		this.idTypeName = idTypeName;
	}

	public List<DcaKpiIdx> getResultList() {
		return resultList;
	}

	public void setResultList(List<DcaKpiIdx> resultList) {
		this.resultList = resultList;
	}

	public String getKpiId() {
		return kpiId;
	}

	public void setKpiId(String kpiId) {
		this.kpiId = kpiId;
	}

	public Integer getNameId() {
		return nameId;
	}

	public void setNameId(Integer nameId) {
		this.nameId = nameId;
	}
}