package com.hepowdhc.dcapp.modules.visualization.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

public class RiskDefinedStatistics extends DataEntity<RiskDefinedStatistics> {

	private static final long serialVersionUID = 1L;
	/**
	 * 界定状态
	 */
	private int defineStatus;
	/**
	 * 月份
	 */
	private int mon;
	/**
	 * 数量
	 */
	private int num;

	public int getDefineStatus() {
		return defineStatus;
	}

	public void setDefineStatus(int defineStatus) {
		this.defineStatus = defineStatus;
	}

	public int getMon() {
		return mon;
	}

	public void setMon(int mon) {
		this.mon = mon;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}
}
