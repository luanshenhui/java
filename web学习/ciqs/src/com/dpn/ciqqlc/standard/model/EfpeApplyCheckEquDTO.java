package com.dpn.ciqqlc.standard.model;

import java.util.Date;

/**
 * 备案申请主要检验设备表
 * @author Administrator
 *
 */
public class EfpeApplyCheckEquDTO {
	
	private String checkid;//主键ID
	
	private String applyid;//申请ID
	
	private Date startdate;//申请日期
	
	private String culatesitua;//计量检定情况
	
	private String note;//备注
	
	private String checkproject;//检测项目
	
	private String operperson;//操作负责人
	
	private String equname;//设备名称

	public String getCheckid() {
		return checkid;
	}

	public void setCheckid(String checkid) {
		this.checkid = checkid;
	}

	public String getApplyid() {
		return applyid;
	}

	public void setApplyid(String applyid) {
		this.applyid = applyid;
	}

	public Date getStartdate() {
		return startdate;
	}

	public void setStartdate(Date startdate) {
		this.startdate = startdate;
	}

	public String getCulatesitua() {
		return culatesitua;
	}

	public void setCulatesitua(String culatesitua) {
		this.culatesitua = culatesitua;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public String getCheckproject() {
		return checkproject;
	}

	public void setCheckproject(String checkproject) {
		this.checkproject = checkproject;
	}

	public String getOperperson() {
		return operperson;
	}

	public void setOperperson(String operperson) {
		this.operperson = operperson;
	}

	public String getEquname() {
		return equname;
	}

	public void setEquname(String equname) {
		this.equname = equname;
	}

}
