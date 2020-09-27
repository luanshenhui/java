/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.gzw.entity;

import java.util.List;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 单表生成Entity
 * @author ThinkGem
 * @version 2017-01-02
 */
public class DcaCompanyReport extends DataEntity<DcaCompanyReport> {
	
	private static final long serialVersionUID = 1L;
	private List<String> companylist;
	private List<String> reviewTypelist;
	private List<List<String>> typelist;
	private List<String> sumlist;
	private DcaCompany dcaCompany;
	
	public DcaCompany getDcaCompany() {
		return dcaCompany;
	}
	public void setDcaCompany(DcaCompany dcaCompany) {
		this.dcaCompany = dcaCompany;
	}
	public List<String> getSumlist() {
		return sumlist;
	}
	public void setSumlist(List<String> sumlist) {
		this.sumlist = sumlist;
	}
	public List<List<String>> getTypelist() {
		return typelist;
	}
	public void setTypelist(List<List<String>> typelist) {
		this.typelist = typelist;
	}
	public List<String> getReviewTypelist() {
		return reviewTypelist;
	}
	public void setReviewTypelist(List<String> reviewTypelist) {
		this.reviewTypelist = reviewTypelist;
	}
	public List<String> getCompanylist() {
		return companylist;
	}
	public void setCompanylist(List<String> companylist) {
		this.companylist = companylist;
	}
}