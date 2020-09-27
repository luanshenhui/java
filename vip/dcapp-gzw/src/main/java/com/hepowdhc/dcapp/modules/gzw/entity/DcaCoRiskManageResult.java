package com.hepowdhc.dcapp.modules.gzw.entity;

import java.util.ArrayList;
import java.util.List;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 告警等级统计Entity
 * 
 * @author dhc
 * @date 2017年1月3日
 */
public class DcaCoRiskManageResult extends DataEntity<DcaCoRiskManageResult> {

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
	 * 数据list
	 */
	private List<DcaCoRiskManage> dataList;

	public String getCoId() {
		return coId;
	}

	public void setCoId(String coId) {
		this.coId = coId;
	}

	public String getCoName() {
		return coName;
	}

	public void setCoName(String coName) {
		this.coName = coName;
	}

	public List<DcaCoRiskManage> getDataList() {
		if (null == dataList) {
			dataList = new ArrayList<>();
		}
		return dataList;
	}

	public void setDataList(List<DcaCoRiskManage> dataList) {
		this.dataList = dataList;
	}

}