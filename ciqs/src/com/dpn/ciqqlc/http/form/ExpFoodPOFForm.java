package com.dpn.ciqqlc.http.form;

import java.util.Date;

import com.dpn.ciqqlc.standard.model.PageDto;

public class ExpFoodPOFForm extends PageDto{
	private String id;
	/**
	 * 申请号
	 * */
	private String applyNo;
	/**
	 * 企业名称
	 * */
	private String compName;
	/**
	 * 申请开始时间
	 * */
	private Date applyDate1;
	/**
	 * 申请结束时间
	 * */
	private Date applyDate2;
	
	private String code;
	
	private String approveNotice;
	

	public String getApproveNotice() {
		return approveNotice;
	}
	public void setApproveNotice(String approveNotice) {
		this.approveNotice = approveNotice;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getApplyNo() {
		return applyNo;
	}
	public void setApplyNo(String applyNo) {
		this.applyNo = applyNo;
	}
	public String getCompName() {
		return compName;
	}
	public void setCompName(String compName) {
		this.compName = compName;
	}
	public Date getApplyDate1() {
		return applyDate1;
	}
	public void setApplyDate1(Date applyDate1) {
		this.applyDate1 = applyDate1;
	}
	public Date getApplyDate2() {
		return applyDate2;
	}
	public void setApplyDate2(Date applyDate2) {
		this.applyDate2 = applyDate2;
	}
}
