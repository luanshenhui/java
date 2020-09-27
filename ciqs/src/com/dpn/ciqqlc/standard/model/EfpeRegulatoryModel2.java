package com.dpn.ciqqlc.standard.model;

import java.util.Date;
import java.util.List;

public class EfpeRegulatoryModel2 {
	
	/**************************监管表信息*******************************/
	private String	liveresult;//	varchar2(40)	y	现场检查结果
	private String	username;//	varchar2(200)	y	计划制定人员
	private Date	startdate;//	date	y	计划制定时间
	private String	practicename;//	varchar2(500)	y	实际监管人
	private Date	actualdate;//	date	y	实际监管时间
	private String	subid;//	varchar2(40)	n	监管id
	private String	pesponsible;//	varchar2(100)	y	监管负责人
	private String	plansupdate	;//varchar2(40)	y	计划监管时间
	private String	address	;//varchar2(500)	y	地址
	private String	plantype	;//varchar2(40)	y	监管类型
	private String	orgname	;//varchar2(200)	y	机构名称
	private String	subname	;//varchar2(500)	y	监管人员
	private String	userid	;//varchar2(40)	n	用户ID

	/**************************企业表信息EFPE_ENTERPRISES*******************************/
	private String enterprisesid;//	varchar2(40)	n	企业id
	private String enterprisesname;//	varchar2(200)	y	企业名称
	private String productname;
	private String depname;
	/**
	 * 分页参数
	 */
	private String firstRcd;
	/**
	 * 分页参数
	 */
	private String lastRcd;
	private String month;
	private QlcEfpePsnDto lader;
	private List person;
	private String startdate_begin;
	private String startdate_end;
	private String applycode;
	private String apply_no;
	private String ipc_product; 
	private String applyid;
	public String getLiveresult() {
		return liveresult;
	}
	public void setLiveresult(String liveresult) {
		this.liveresult = liveresult;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public Date getStartdate() {
		return startdate;
	}
	public void setStartdate(Date startdate) {
		this.startdate = startdate;
	}
	public String getPracticename() {
		return practicename;
	}
	public void setPracticename(String practicename) {
		this.practicename = practicename;
	}
	public Date getActualdate() {
		return actualdate;
	}
	public void setActualdate(Date actualdate) {
		this.actualdate = actualdate;
	}
	public String getSubid() {
		return subid;
	}
	public void setSubid(String subid) {
		this.subid = subid;
	}
	public String getPesponsible() {
		return pesponsible;
	}
	public void setPesponsible(String pesponsible) {
		this.pesponsible = pesponsible;
	}
	public String getPlansupdate() {
		return plansupdate;
	}
	public void setPlansupdate(String plansupdate) {
		this.plansupdate = plansupdate;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getPlantype() {
		return plantype;
	}
	public void setPlantype(String plantype) {
		this.plantype = plantype;
	}
	public String getOrgname() {
		return orgname;
	}
	public void setOrgname(String orgname) {
		this.orgname = orgname;
	}
	public String getSubname() {
		return subname;
	}
	public void setSubname(String subname) {
		this.subname = subname;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getEnterprisesid() {
		return enterprisesid;
	}
	public void setEnterprisesid(String enterprisesid) {
		this.enterprisesid = enterprisesid;
	}
	public String getEnterprisesname() {
		return enterprisesname;
	}
	public void setEnterprisesname(String enterprisesname) {
		this.enterprisesname = enterprisesname;
	}
	public String getProductname() {
		return productname;
	}
	public void setProductname(String productname) {
		this.productname = productname;
	}
	public String getDepname() {
		return depname;
	}
	public void setDepname(String depname) {
		this.depname = depname;
	}
	public String getFirstRcd() {
		return firstRcd;
	}
	public void setFirstRcd(String firstRcd) {
		this.firstRcd = firstRcd;
	}
	public String getLastRcd() {
		return lastRcd;
	}
	public void setLastRcd(String lastRcd) {
		this.lastRcd = lastRcd;
	}
	public String getMonth() {
		return month;
	}
	public void setMonth(String month) {
		this.month = month;
	}
	public QlcEfpePsnDto getLader() {
		return lader;
	}
	public void setLader(QlcEfpePsnDto lader) {
		this.lader = lader;
	}
	public List getPerson() {
		return person;
	}
	public void setPerson(List person) {
		this.person = person;
	}
	public String getStartdate_begin() {
		return startdate_begin;
	}
	public void setStartdate_begin(String startdate_begin) {
		this.startdate_begin = startdate_begin;
	}
	public String getStartdate_end() {
		return startdate_end;
	}
	public void setStartdate_end(String startdate_end) {
		this.startdate_end = startdate_end;
	}
	public String getApply_no() {
		return apply_no;
	}
	public void setApply_no(String apply_no) {
		this.apply_no = apply_no;
	}
	public String getIpc_product() {
		return ipc_product;
	}
	public void setIpc_product(String ipc_product) {
		this.ipc_product = ipc_product;
	}
	public String getApplyid() {
		return applyid;
	}
	public void setApplyid(String applyid) {
		this.applyid = applyid;
	}
	public String getApplycode() {
		return applycode;
	}
	public void setApplycode(String applycode) {
		this.applycode = applycode;
	}
	
	

}
