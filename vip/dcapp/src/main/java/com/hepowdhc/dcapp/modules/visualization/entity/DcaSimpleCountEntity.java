/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.visualization.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 简单统计Entity
 * 
 * @author geshuo
 * @date 2017年1月5日
 */
public class DcaSimpleCountEntity extends DataEntity<DcaSimpleCountEntity> {

	private static final long serialVersionUID = 1L;

	/**
	 * 统计维度
	 */
	private String name;

	/**
	 * 统计数量
	 */
	private Long count;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Long getCount() {
		return count;
	}

	public void setCount(Long count) {
		this.count = count;
	}

}