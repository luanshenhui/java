package com.hepowdhc.dcapp.modules.gzw.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 风险Entity
 * 
 * @author dhc
 * @version 2016-11-22
 */
public class DcaCoRiskDataEntity extends DataEntity<DcaCoRiskDataEntity> {

	private static final long serialVersionUID = 1L;
	private String name; // 分类名称
	private Integer[] data; // 统计数据

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer[] getData() {
		return data;
	}

	public void setData(Integer[] data) {
		this.data = data;
	}

}