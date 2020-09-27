package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class CheckResultModel {

	private String applyCompany;//申请单位
	private Date  applyTime;//申请日期（时间段）
	
	private String companyName;//企业名称
	private String icp;//企业备案号
	private String 	purpose;//最终目的国家/地区
	private Date seaOutTime;//出运日期
	private String zsNumber;//证书号
	private String fpNumber;//发票号
	private Date fpDate;//发票日期
	
	public String getApplyCompany() {
		return applyCompany;
	}
	public void setApplyCompany(String applyCompany) {
		this.applyCompany = applyCompany;
	}
	public Date getApplyTime() {
		return applyTime;
	}
	public void setApplyTime(Date applyTime) {
		this.applyTime = applyTime;
	}
	public String getCompanyName() {
		return companyName;
	}
	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	public String getIcp() {
		return icp;
	}
	public void setIcp(String icp) {
		this.icp = icp;
	}
	public String getPurpose() {
		return purpose;
	}
	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}
	public Date getSeaOutTime() {
		return seaOutTime;
	}
	public void setSeaOutTime(Date seaOutTime) {
		this.seaOutTime = seaOutTime;
	}
	public String getZsNumber() {
		return zsNumber;
	}
	public void setZsNumber(String zsNumber) {
		this.zsNumber = zsNumber;
	}
	public String getFpNumber() {
		return fpNumber;
	}
	public void setFpNumber(String fpNumber) {
		this.fpNumber = fpNumber;
	}
	public Date getFpDate() {
		return fpDate;
	}
	public void setFpDate(Date fpDate) {
		this.fpDate = fpDate;
	}	
	
	

}
