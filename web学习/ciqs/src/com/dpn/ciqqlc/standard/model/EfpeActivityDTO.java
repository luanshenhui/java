package com.dpn.ciqqlc.standard.model;

import java.util.Date;

/**
 * 业务流程信息
 * @author Administrator
 *
 */
public class EfpeActivityDTO {
	
	private String applyid;//申请ID
	
	private String applytypename;//申请类型
	
	private String applycoed;//申请编号
	
	private String orgname;//机构名称
	
	private Date deliverydate;//送达日期
	
	private String applynotename;//流程环节
	
	private String username;//处理人
	
	private Date startdate;//申请日期

	public String getApplyid() {
		return applyid;
	}

	public void setApplyid(String applyid) {
		this.applyid = applyid;
	}

	public String getApplytypename() {
		return applytypename;
	}

	public void setApplytypename(String applytypename) {
		this.applytypename = applytypename;
	}

	public String getApplycoed() {
		return applycoed;
	}

	public void setApplycoed(String applycoed) {
		this.applycoed = applycoed;
	}

	public String getOrgname() {
		return orgname;
	}

	public void setOrgname(String orgname) {
		this.orgname = orgname;
	}

	public Date getDeliverydate() {
		return deliverydate;
	}

	public void setDeliverydate(Date deliverydate) {
		this.deliverydate = deliverydate;
	}

	public String getApplynotename() {
		return applynotename;
	}

	public void setApplynotename(String applynotename) {
		this.applynotename = applynotename;
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

}
