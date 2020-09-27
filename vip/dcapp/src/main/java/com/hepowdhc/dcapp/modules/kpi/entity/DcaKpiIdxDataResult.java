/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.kpi.entity;

import java.util.ArrayList;
import java.util.List;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 绩效考核管理结果Entity
 * @author dhc
 * @version 2017-01-09
 */
public class DcaKpiIdxDataResult extends DataEntity<DcaKpiIdxDataResult> {
	
	private static final long serialVersionUID = 1L;
	/**
	 * 绩效指标类型
	 */
	private String idxType;
	/**
	 * 绩效指标类型名称
	 */
	private String idxTypeName;
	
	private List<DcaKpiIdxResult> dcaKpiIdxResult;


	public String getIdxType() {
		return idxType;
	}

	public void setIdxType(String idxType) {
		this.idxType = idxType;
	}

	public List<DcaKpiIdxResult> getDcaKpiIdxResult() {
		if (null == dcaKpiIdxResult) {
			dcaKpiIdxResult = new ArrayList<>();
		}
		return dcaKpiIdxResult;
	}

	public void setDcaKpiIdxResult(List<DcaKpiIdxResult> dcaKpiIdxResult) {
		this.dcaKpiIdxResult = dcaKpiIdxResult;
	}

	public String getIdxTypeName() {
		return idxTypeName;
	}

	public void setIdxTypeName(String idxTypeName) {
		this.idxTypeName = idxTypeName;
	}

}