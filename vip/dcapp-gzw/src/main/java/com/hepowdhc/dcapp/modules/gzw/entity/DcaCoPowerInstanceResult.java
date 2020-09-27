package com.hepowdhc.dcapp.modules.gzw.entity;

import java.util.ArrayList;
import java.util.List;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 业务数据量统计结果
 * 
 * @author geshuo
 * @date 2017年1月3日
 */
public class DcaCoPowerInstanceResult extends DataEntity<DcaCoPowerInstanceResult> {

	private static final long serialVersionUID = 1L;

	/**
	 * 企业id
	 */
	private String coId;

	/**
	 * 企业名称
	 */
	private String coName;

	private List<DcaCoPowerInstanceDataCountEntity> dataList;

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

	public List<DcaCoPowerInstanceDataCountEntity> getDataList() {
		if (null == dataList) {
			dataList = new ArrayList<>();
		}
		return dataList;
	}

	public void setDataList(List<DcaCoPowerInstanceDataCountEntity> dataList) {
		this.dataList = dataList;
	}

}