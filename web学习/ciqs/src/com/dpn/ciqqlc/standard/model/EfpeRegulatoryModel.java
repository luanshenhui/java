package com.dpn.ciqqlc.standard.model;

import java.util.Date;
import java.util.List;

public class EfpeRegulatoryModel {
/**************************监管表信息*******************************/
private String	liveResult;//	varchar2(40)	y	现场检查结果
private String	userName;//	varchar2(200)	y	计划制定人员
private Date	startDate;//	date	y	计划制定时间
private String	practiceName;//	varchar2(500)	y	实际监管人
private Date	actualDate;//	date	y	实际监管时间
private String	subId;//	varchar2(40)	n	监管id
private String	pesponsible;//	varchar2(100)	y	监管负责人
private String	plansupDate	;//varchar2(40)	y	计划监管时间
private String	address	;//varchar2(500)	y	地址
private String	planType	;//varchar2(40)	y	监管类型
private String	orgName	;//varchar2(200)	y	机构名称
private String	subName	;//varchar2(500)	y	监管人员
private String	userId	;//varchar2(40)	n	用户ID

/**************************企业表信息EFPE_ENTERPRISES*******************************/
private String enterprisesId;//	varchar2(40)	n	企业id
private String enterprisesname;//	varchar2(200)	y	企业名称
private String headname;
private String blno;
private String productname;//	varchar2(100)	y	主营产品

private String depname;
private String psn_id;

private String apply_no;
private String orgname;
private String ipc_product; 
private String applyid;
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
public String getLiveResult() {
	return liveResult;
}
public void setLiveResult(String liveResult) {
	this.liveResult = liveResult;
}
public String getUserName() {
	return userName;
}
public void setUserName(String userName) {
	this.userName = userName;
}
public Date getStartDate() {
	return startDate;
}
public void setStartDate(Date startDate) {
	this.startDate = startDate;
}
public String getPracticeName() {
	return practiceName;
}
public void setPracticeName(String practiceName) {
	this.practiceName = practiceName;
}
public Date getActualDate() {
	return actualDate;
}
public void setActualDate(Date actualDate) {
	this.actualDate = actualDate;
}
public String getSubId() {
	return subId;
}
public void setSubId(String subId) {
	this.subId = subId;
}
public String getPesponsible() {
	return pesponsible;
}
public void setPesponsible(String pesponsible) {
	this.pesponsible = pesponsible;
}
public String getPlansupDate() {
	return plansupDate;
}
public void setPlansupDate(String plansupDate) {
	this.plansupDate = plansupDate;
}
public String getAddress() {
	return address;
}
public void setAddress(String address) {
	this.address = address;
}
public String getPlanType() {
	return planType;
}
public void setPlanType(String planType) {
	this.planType = planType;
}
public String getOrgName() {
	return orgName;
}
public void setOrgName(String orgName) {
	this.orgName = orgName;
}
public String getSubName() {
	return subName;
}
public void setSubName(String subName) {
	this.subName = subName;
}
public String getUserId() {
	return userId;
}
public void setUserId(String userId) {
	this.userId = userId;
}


public String getEnterprisesId() {
	return enterprisesId;
}
public void setEnterprisesId(String enterprisesId) {
	this.enterprisesId = enterprisesId;
}
public String getEnterprisesname() {
	return enterprisesname;
}
public void setEnterprisesname(String enterprisesname) {
	this.enterprisesname = enterprisesname;
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
public String getPsn_id() {
	return psn_id;
}
public void setPsn_id(String psn_id) {
	this.psn_id = psn_id;
}
public String getApply_no() {
	return apply_no;
}
public void setApply_no(String apply_no) {
	this.apply_no = apply_no;
}
public String getOrgname() {
	return orgname;
}
public void setOrgname(String orgname) {
	this.orgname = orgname;
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
public String getBlno() {
	return blno;
}
public void setBlno(String blno) {
	this.blno = blno;
}
public String getHeadname() {
	return headname;
}
public void setHeadname(String headname) {
	this.headname = headname;
}

}
