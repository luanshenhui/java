/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.kpi.entity;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;
import com.thinkgem.jeesite.common.utils.excel.annotation.ExcelField;

/**
 * 企业绩效管理Entity
 * 
 * @author dhc
 * @version 2017-01-09
 */
public class DcaKpi extends DataEntity<DcaKpi> {

	private static final long serialVersionUID = 1L;
	private String kpiId; // 考核ID
	private String idxId; // 考核指标ID
	private String idxName; // 指标名称
	private Double kpiResult; // 绩效值
	private String createPerson; // 创建人
	private String updatePerson; // 更新者

	private String idxType;// 考核指标类型

	private String idxTypeName;// 考核指标类型文字
	private String checkResultCode;// 考核结果编码
	private String checkResultText;// 考核结果文字

	private List<DcaKpi> dataList;// 结果集

	public DcaKpi() {
		super();
	}

	public DcaKpi(String id) {
		super(id);
	}

	@Length(min = 1, max = 50, message = "考核ID长度必须介于 1 和 50 之间")
	@ExcelField(title = "NO.", align = 2, sort = 5)
	public String getKpiId() {
		return kpiId;
	}

	public void setKpiId(String kpiId) {
		this.kpiId = kpiId;
	}

	@ExcelField(title = "", sort = 1)
	@Length(min = 0, max = 50, message = "考核指标ID长度必须介于 0 和 50 之间")
	public String getIdxId() {
		return idxId;
	}

	public void setIdxId(String idxId) {
		this.idxId = idxId;
	}

	@ExcelField(title = "类型", align = 2, sort = 10)
	public String getIdxTypeName() {
		return idxTypeName;
	}

	public void setIdxTypeName(String idxTypeName) {
		this.idxTypeName = idxTypeName;
	}

	@ExcelField(title = "项目", align = 2, sort = 15)
	@Length(min = 0, max = 200, message = "指标名称长度必须介于 0 和 200 之间")
	public String getIdxName() {
		return idxName;
	}

	public void setIdxName(String idxName) {
		this.idxName = idxName;
	}

	@ExcelField(title = "绩效值", align = 2, sort = 20)
	public Double getKpiResult() {
		return kpiResult;
	}

	public void setKpiResult(Double kpiResult) {
		this.kpiResult = kpiResult;
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

	public String getIdxType() {
		return idxType;
	}

	public void setIdxType(String idxType) {
		this.idxType = idxType;
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

	public List<DcaKpi> getDataList() {
		if (null == dataList) {
			dataList = new ArrayList<>();
		}
		return dataList;
	}

	public void setDataList(List<DcaKpi> dataList) {
		this.dataList = dataList;
	}

}