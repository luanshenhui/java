/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.riskmanage.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 风险Entity
 * 
 * @author ThinkGem
 * @version 2016-11-22
 */
public class RiskDataEntity extends DataEntity<RiskDataEntity> {

	private static final long serialVersionUID = 1L;
	private String name;
	private String type;
	private String stack;
	private Integer[] data;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getStack() {
		return stack;
	}

	public void setStack(String stack) {
		this.stack = stack;
	}

	public Integer[] getData() {
		return data;
	}

	public void setData(Integer[] data) {
		this.data = data;
	}

}