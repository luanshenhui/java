package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class CertificationFileModel extends EfpeApplyFileDTO{
	
private String cerid;//主键ID
	
	private String cerorg;//认证机构
	
	private String applyid;//申请ID
	
	private String cerkind;//认证种类
	
	private Date startdate;//申请日期
	
	private String cerno;//证书编号
	
	private Date limitdate;//有效期限

	public String getCerid() {
		return cerid;
	}

	public void setCerid(String cerid) {
		this.cerid = cerid;
	}

	public String getCerorg() {
		return cerorg;
	}

	public void setCerorg(String cerorg) {
		this.cerorg = cerorg;
	}

	public String getApplyid() {
		return applyid;
	}

	public void setApplyid(String applyid) {
		this.applyid = applyid;
	}

	public String getCerkind() {
		return cerkind;
	}

	public void setCerkind(String cerkind) {
		this.cerkind = cerkind;
	}

	public Date getStartdate() {
		return startdate;
	}

	public void setStartdate(Date startdate) {
		this.startdate = startdate;
	}

	public String getCerno() {
		return cerno;
	}

	public void setCerno(String cerno) {
		this.cerno = cerno;
	}

	public Date getLimitdate() {
		return limitdate;
	}

	public void setLimitdate(Date limitdate) {
		this.limitdate = limitdate;
	}
	
	

}
