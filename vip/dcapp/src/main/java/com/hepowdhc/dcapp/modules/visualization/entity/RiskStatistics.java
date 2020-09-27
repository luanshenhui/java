package com.hepowdhc.dcapp.modules.visualization.entity;

import java.util.ArrayList;
import java.util.List;

import com.thinkgem.jeesite.common.persistence.DataEntity;

public class RiskStatistics extends DataEntity<RiskStatistics> {

	private static final long serialVersionUID = 1L;

	private List<Integer> isRisk = new ArrayList<Integer>();
	private List<Integer> isNotRisk = new ArrayList<Integer>();
	private List<Integer> Unattuned = new ArrayList<Integer>();
	private List<Integer> total = new ArrayList<Integer>();
	private String dt;

	public List<Integer> getIsRisk() {
		return isRisk;
	}

	public void setIsRisk(List<Integer> isRisk) {
		this.isRisk = isRisk;
	}

	public List<Integer> getIsNotRisk() {
		return isNotRisk;
	}

	public void setIsNotRisk(List<Integer> isNotRisk) {
		this.isNotRisk = isNotRisk;
	}

	public List<Integer> getUnattuned() {
		return Unattuned;
	}

	public void setUnattuned(List<Integer> unattuned) {
		Unattuned = unattuned;
	}

	public List<Integer> getTotal() {
		return total;
	}

	public void setTotal(List<Integer> total) {
		this.total = total;
	}

	public String getDt() {
		return dt;
	}

	public void setDt(String dt) {
		this.dt = dt;
	}

}
