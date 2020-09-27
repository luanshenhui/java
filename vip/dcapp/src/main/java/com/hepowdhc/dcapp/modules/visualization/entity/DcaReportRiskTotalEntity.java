package com.hepowdhc.dcapp.modules.visualization.entity;

import java.util.List;

import com.thinkgem.jeesite.common.persistence.DataEntity;
import com.thinkgem.jeesite.modules.sys.entity.Office;
import com.thinkgem.jeesite.modules.sys.entity.User;

public class DcaReportRiskTotalEntity extends DataEntity<DcaReportRiskTotalEntity> {

	private static final long serialVersionUID = 1L;

	/**
	 * 操作人
	 */
	private String operator;
	/**
	 * 操作人id
	 */
	private String operatorID;

	/**
	 * 操作人所属部门名称
	 */
	private String officeName;

	/**
	 * 操作人所属部门id
	 */
	private String officeID;

	/**
	 * 所属部门
	 */
	private List<String> officeList;

	/**
	 * 统计数据
	 */
	private List<DcaAlarmStatEntity> riskList;

	/**
	 * 年份数据
	 */
	private List<Integer> yearList;

	/**
	 * 操作人
	 */
	private List<User> operList;

	/**
	 * 所属部门数据
	 */
	private List<Office> departLists;

	private List<DcaReportRiskEntity> reportList;

	public String getOperator() {
		return operator;
	}

	public void setOperator(String operator) {
		this.operator = operator;
	}

	public List<String> getOfficeList() {
		return officeList;
	}

	public void setOfficeList(List<String> officeList) {
		this.officeList = officeList;
	}

	public List<DcaReportRiskEntity> getReportList() {
		return reportList;
	}

	public void setReportList(List<DcaReportRiskEntity> reportList) {
		this.reportList = reportList;
	}

	public List<DcaAlarmStatEntity> getRiskList() {
		return riskList;
	}

	public void setRiskList(List<DcaAlarmStatEntity> riskList) {
		this.riskList = riskList;
	}

	public List<User> getOperList() {
		return operList;
	}

	public void setOperList(List<User> operList) {
		this.operList = operList;
	}

	public List<Integer> getYearList() {
		return yearList;
	}

	public void setYearList(List<Integer> yearList) {
		this.yearList = yearList;
	}

	public List<Office> getDepartLists() {
		return departLists;
	}

	public void setDepartLists(List<Office> departLists) {
		this.departLists = departLists;
	}

	public String getOfficeName() {
		return officeName;
	}

	public void setOfficeName(String officeName) {
		this.officeName = officeName;
	}

	public String getOfficeID() {
		return officeID;
	}

	public void setOfficeID(String officeID) {
		this.officeID = officeID;
	}

	public String getOperatorID() {
		return operatorID;
	}

	public void setOperatorID(String operatorID) {
		this.operatorID = operatorID;
	}
}
