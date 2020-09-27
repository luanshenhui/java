package com.dpn.ciqqlc.standard.model;

import java.util.Date;

/**
 * 出口备案监管信息信息
 * @author Administrator
 *
 */
public class EfpeRegulatoryDTO {
	
	private String subid;//监管ID
	
	private String subname;//监管人员
	
	private String orgname;//机构名称
	
	private String plantype;//监管类型
	
	private String address;//地址
	
	private String plansupdate;//计划监管时间
	
	private String pesponsible;//监管负责人
	
	private Date updatedate;//更新时间
	
	private Date actualdate;//实际监管时间
	
	private String practicename;//实际监管人
	
	private Date startdate;//计划制定时间
	
	private String username;//计划制定人员
	
	private String liveresult;//现场检查结果

	public String getSubid() {
		return subid;
	}

	public void setSubid(String subid) {
		this.subid = subid;
	}

	public String getSubname() {
		return subname;
	}

	public void setSubname(String subname) {
		this.subname = subname;
	}

	public String getOrgname() {
		return orgname;
	}

	public void setOrgname(String orgname) {
		this.orgname = orgname;
	}

	public String getPlantype() {
		return plantype;
	}

	public void setPlantype(String plantype) {
		this.plantype = plantype;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPlansupdate() {
		return plansupdate;
	}

	public void setPlansupdate(String plansupdate) {
		this.plansupdate = plansupdate;
	}

	public String getPesponsible() {
		return pesponsible;
	}

	public void setPesponsible(String pesponsible) {
		this.pesponsible = pesponsible;
	}

	public Date getUpdatedate() {
		return updatedate;
	}

	public void setUpdatedate(Date updatedate) {
		this.updatedate = updatedate;
	}

	public Date getActualdate() {
		return actualdate;
	}

	public void setActualdate(Date actualdate) {
		this.actualdate = actualdate;
	}

	public String getPracticename() {
		return practicename;
	}

	public void setPracticename(String practicename) {
		this.practicename = practicename;
	}

	public Date getStartdate() {
		return startdate;
	}

	public void setStartdate(Date startdate) {
		this.startdate = startdate;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getLiveresult() {
		return liveresult;
	}

	public void setLiveresult(String liveresult) {
		this.liveresult = liveresult;
	}

}
