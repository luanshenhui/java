/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.visualization.entity;

import java.util.List;

import com.thinkgem.jeesite.common.persistence.DataEntity;
import com.thinkgem.jeesite.modules.sys.entity.Office;

public class DcaAlarmRiskDefineEntity extends DataEntity<DcaAlarmRiskDefineEntity> {

	private static final long serialVersionUID = 1L;

	/**
	 * 界定状态
	 */
	private String defineStatus;

	/**
	 * 界定状态名称
	 */
	private String label;

	/**
	 * 风险界定记录数
	 */
	private Integer totalCount;

	/**
	 * 风险记录数
	 * 
	 * @return
	 */
	private Integer riskCount;
	/**
	 * 告警记录数
	 * 
	 * @return
	 */

	private Integer alarmCount;
	/**
	 * 年份数
	 * 
	 * @return
	 */
	private String year;

	/**
	 * 月份
	 */
	private Integer month;

	/**
	 * 风险月份记录数
	 * 
	 * @return
	 */
	private Integer riskMonthCount;

	/**
	 * 告警月份记录数
	 * 
	 * @return
	 */
	private Integer alarmMonthCount;

	/**
	 * 风险数组
	 */
	private Integer[] riskArray;

	/**
	 * 告警数组
	 */
	private Integer[] alarmArray;
	/**
	 * 当前用户ID
	 */
	private String userId;
	/**
	 * 当前用户部门ID
	 */
	private String officeId;

	/**
	 * 当前用户部门名称
	 * 
	 * @return
	 */
	private String officeName;

	/**
	 * 是否有下属部门 parentID list
	 * 
	 * @return
	 */
	private List<Office> parentList;

	/**
	 * 业务类型（三重一大、投资、担保）
	 */
	private String idxDataType;
	public String getIdxDataType() {
		return idxDataType;
	}

	public void setIdxDataType(String idxDataType) {
		this.idxDataType = idxDataType;
	}

	public Integer getMonth() {
		return month;
	}

	public void setMonth(Integer month) {
		this.month = month;
	}

	public String getDefineStatus() {
		return defineStatus;
	}

	public void setDefineStatus(String defineStatus) {
		this.defineStatus = defineStatus;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public Integer getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(Integer totalCount) {
		this.totalCount = totalCount;
	}

	public Integer getRiskCount() {
		return riskCount;
	}

	public void setRiskCount(Integer riskCount) {
		this.riskCount = riskCount;
	}

	public Integer getAlarmCount() {
		return alarmCount;
	}

	public void setAlarmCount(Integer alarmCount) {
		this.alarmCount = alarmCount;
	}

	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public Integer getRiskMonthCount() {
		return riskMonthCount;
	}

	public void setRiskMonthCount(Integer riskMonthCount) {
		this.riskMonthCount = riskMonthCount;
	}

	public Integer getAlarmMonthCount() {
		return alarmMonthCount;
	}

	public void setAlarmMonthCount(Integer alarmMonthCount) {
		this.alarmMonthCount = alarmMonthCount;
	}

	public Integer[] getRiskArray() {
		return riskArray;
	}

	public void setRiskArray(Integer[] riskArray) {
		this.riskArray = riskArray;
	}

	public Integer[] getAlarmArray() {
		return alarmArray;
	}

	public void setAlarmArray(Integer[] alarmArray) {
		this.alarmArray = alarmArray;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getOfficeId() {
		return officeId;
	}

	public void setOfficeId(String officeId) {
		this.officeId = officeId;
	}

	public String getOfficeName() {
		return officeName;
	}

	public void setOfficeName(String officeName) {
		this.officeName = officeName;
	}

	public List<Office> getParentList() {
		return parentList;
	}

	public void setParentList(List<Office> parentList) {
		this.parentList = parentList;
	}

}