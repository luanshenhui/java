package com.dpn.ciqqlc.standard.model;

import java.util.Date;

/**
 * 出口食品生产企业备案系统审批
 * QLC_EXP_FOOD_PROD_APRV   
 * */
public class ExpFoodProdAprvDTO {
	/**
	 * 主键UUID
	 * */
	private String id;
	/**
	 * 申请编号
	 * */
	private String apply_no;
	/**
	 * 审批结果
	 * */
	private String approve_result;
	/**
	 * 审批人
	 * */
	private String approve_psn;
	/**
	 * 审批时间
	 * */
	private Date approve_date;
	/**
	 * 评审任务通知书
	 * */
	private String approve_notice;
	
	
	public String getApprove_notice() {
		return approve_notice;
	}
	public void setApprove_notice(String approve_notice) {
		this.approve_notice = approve_notice;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getApply_no() {
		return apply_no;
	}
	public void setApply_no(String apply_no) {
		this.apply_no = apply_no;
	}
	public String getApprove_result() {
		return approve_result;
	}
	public void setApprove_result(String approve_result) {
		this.approve_result = approve_result;
	}
	public String getApprove_psn() {
		return approve_psn;
	}
	public void setApprove_psn(String approve_psn) {
		this.approve_psn = approve_psn;
	}
	public Date getApprove_date() {
		return approve_date;
	}
	public void setApprove_date(Date approve_date) {
		this.approve_date = approve_date;
	}
	

}
