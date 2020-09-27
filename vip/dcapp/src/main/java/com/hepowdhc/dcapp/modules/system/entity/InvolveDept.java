/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.system.entity;

/**
 * 涉及部门Entity
 * 
 * @author zhengwei.cui
 * @version 2016-12-26
 */
public class InvolveDept {
	private String type; // 类型
	private String dept; // 部门
	private String riskRatio; // 风险占比

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getDept() {
		return dept;
	}

	public void setDept(String dept) {
		this.dept = dept;
	}

	public String getRiskRatio() {
		return riskRatio;
	}

	public void setRiskRatio(String riskRatio) {
		this.riskRatio = riskRatio;
	}
}
