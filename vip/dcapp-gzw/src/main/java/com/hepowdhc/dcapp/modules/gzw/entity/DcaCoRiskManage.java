/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.gzw.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 企业风险管理Entity
 * 
 * @author zhengwei.cui
 * @version 2017-01-03
 */
public class DcaCoRiskManage extends DataEntity<DcaCoRiskManage> {

	private static final long serialVersionUID = 1L;

	private String riskManageId; // 风险管理ID
	private String riskId; // 风险清单id

	private String riskLevel; // 风险等级
	private String defineStatus; // 界定状态;数据字典
	private String coId; // 企业ID
	private String coName; // 企业名称
	private String riskNum; // 风险数
	private String curYear; // 当前年份

	private String powerId; // 权力id
	private String speCommittee; // 专委会
	private String powerName; // 权力名称
	private Integer powerNum; // 记录数
	private Integer month; // 月份

	public String getCurYear() {
		return curYear;
	}

	public void setCurYear(String curYear) {
		this.curYear = curYear;
	}

	public String getPowerName() {
		return powerName;
	}

	public void setPowerName(String powerName) {
		this.powerName = powerName;
	}

	public Integer getPowerNum() {
		return powerNum;
	}

	public void setPowerNum(Integer powerNum) {
		this.powerNum = powerNum;
	}

	public String getSpeCommittee() {
		return speCommittee;
	}

	public void setSpeCommittee(String speCommittee) {
		this.speCommittee = speCommittee;
	}

	public Integer getMonth() {
		return month;
	}

	public void setMonth(Integer month) {
		this.month = month;
	}

	public String getRiskNum() {
		return riskNum;
	}

	public void setRiskNum(String riskNum) {
		this.riskNum = riskNum;
	}

	public String getRiskManageId() {
		return riskManageId;
	}

	public void setRiskManageId(String riskManageId) {
		this.riskManageId = riskManageId;
	}

	public String getPowerId() {
		return powerId;
	}

	public void setPowerId(String powerId) {
		this.powerId = powerId;
	}

	public String getRiskId() {
		return riskId;
	}

	public void setRiskId(String riskId) {
		this.riskId = riskId;
	}

	public String getRiskLevel() {
		return riskLevel;
	}

	public void setRiskLevel(String riskLevel) {
		this.riskLevel = riskLevel;
	}

	public String getDefineStatus() {
		return defineStatus;
	}

	public void setDefineStatus(String defineStatus) {
		this.defineStatus = defineStatus;
	}

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

}