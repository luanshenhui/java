package com.hepowdhc.dcapp.modules.gzw.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 风险Entity
 * 
 * @author dhc
 * @version 2016-11-22
 */
public class DcaCoRiskDefineDataEntity extends DataEntity<DcaCoRiskDefineDataEntity> {

	private static final long serialVersionUID = 1L;

	private String month; // 月份
	private String riskNum; // 风险数
	private String nonRiskNum; // 非风险数
	private String notDefined; // 未界定数
	private String totalNum; // 总数

	public String getMonth() {
		return month;
	}

	public void setMonth(String month) {
		this.month = month;
	}

	public String getRiskNum() {
		return riskNum;
	}

	public void setRiskNum(String riskNum) {
		this.riskNum = riskNum;
	}

	public String getNonRiskNum() {
		return nonRiskNum;
	}

	public void setNonRiskNum(String nonRiskNum) {
		this.nonRiskNum = nonRiskNum;
	}

	public String getNotDefined() {
		return notDefined;
	}

	public void setNotDefined(String notDefined) {
		this.notDefined = notDefined;
	}

	public String getTotalNum() {
		return totalNum;
	}

	public void setTotalNum(String totalNum) {
		this.totalNum = totalNum;
	}

}