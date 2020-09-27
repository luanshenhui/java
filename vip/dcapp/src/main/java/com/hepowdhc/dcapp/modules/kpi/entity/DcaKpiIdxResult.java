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
public class DcaKpiIdxResult extends DataEntity<DcaKpiIdxResult> {
	
	private static final long serialVersionUID = 1L;
	/**
	 * 绩效指标类型
	 */
	private String idxType;
	/**
	 * 绩效指标类型名称
	 */
	private String idxTypeName;

	/**
	 * 指标Id
	 */
	private String idxId;
	
	/**
	 * 指标名称
	 */
	private String idxName;

	private List<DcaKpiIdx> dataList;

	public String getIdxType() {
		return idxType;
	}

	public void setIdxType(String idxType) {
		this.idxType = idxType;
	}

	public String getIdxId() {
		return idxId;
	}

	public void setIdxId(String idxId) {
		this.idxId = idxId;
	}

	public List<DcaKpiIdx> getDataList() {
		if (null == dataList) {
			dataList = new ArrayList<>();
		}
		return dataList;
	}

	public void setDataList(List<DcaKpiIdx> dataList) {
		this.dataList = dataList;
	}

	public String getIdxName() {
		return idxName;
	}

	public void setIdxName(String idxName) {
		this.idxName = idxName;
	}

	public String getIdxTypeName() {
		return idxTypeName;
	}

	public void setIdxTypeName(String idxTypeName) {
		this.idxTypeName = idxTypeName;
	}

}