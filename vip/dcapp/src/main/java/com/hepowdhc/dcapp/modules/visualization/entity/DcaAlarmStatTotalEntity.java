/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.visualization.entity;

import java.util.List;

import com.thinkgem.jeesite.common.persistence.DataEntity;
import com.thinkgem.jeesite.modules.sys.entity.Office;
import com.thinkgem.jeesite.modules.sys.entity.User;

/**
 * 告警统计报表Entity
 * 
 * @author geshuo
 * @date 2016年12月7日
 */
public class DcaAlarmStatTotalEntity extends DataEntity<DcaAlarmStatTotalEntity> {

	private static final long serialVersionUID = 1L;

	/**
	 * 统计数据
	 */
	private List<DcaAlarmStatEntity> alarmList;

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
	private List<Office> officeList;

	public List<DcaAlarmStatEntity> getAlarmList() {
		return alarmList;
	}

	public void setAlarmList(List<DcaAlarmStatEntity> alarmList) {
		this.alarmList = alarmList;
	}

	public List<Integer> getYearList() {
		return yearList;
	}

	public void setYearList(List<Integer> yearList) {
		this.yearList = yearList;
	}

	public List<User> getOperList() {
		return operList;
	}

	public void setOperList(List<User> operList) {
		this.operList = operList;
	}

	public List<Office> getOfficeList() {
		return officeList;
	}

	public void setOfficeList(List<Office> officeList) {
		this.officeList = officeList;
	}

}