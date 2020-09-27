package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class GeneralPunishmentHistoryDTO {
	/**
	 * 主键 UUID
	 * */
	private String id;
	/**
	 * 预申报号
	 * */
	private String pre_report_no;
	/**
	 * 当前环节(CODE)
	 * */
	private String audit_step;
	/**
	 * 当前环节状态(CODE)
	 * */
	private String audit_status;
	/**
	 * 当前环节处理时间
	 * */
	private Date audit_date;
	/**
	 * 当前环节机构
	 * */
	private String audit_org;
	/**
	 * 当前环节处理人
	 * */
	private String audit_psn;
	
	/**
	 * 文档ID 格式 (id,id)
	 */
	private String doc_id;
	
	/**
	 * 附件ID
	 */
	private String file_id;
	
	private String main_id;
	
	/**
	 * 申报局
	 */
	private String declare_org;
	
	/**
	 * 受理局
	 */
	private String accept_org;
	
	/**
	 * 直属局
	 */
	private String belong_org;
	
	public String getDeclare_org() {
		return declare_org;
	}
	public void setDeclare_org(String declare_org) {
		this.declare_org = declare_org;
	}
	public String getAccept_org() {
		return accept_org;
	}
	public void setAccept_org(String accept_org) {
		this.accept_org = accept_org;
	}
	public String getBelong_org() {
		return belong_org;
	}
	public void setBelong_org(String belong_org) {
		this.belong_org = belong_org;
	}
	public String getMain_id() {
		return main_id;
	}
	public void setMain_id(String main_id) {
		this.main_id = main_id;
	}
	/**
	 * 预期流程
	 */
	private String forward_step;
	
	public String getForward_step() {
		return forward_step;
	}
	public void setForward_step(String forward_step) {
		this.forward_step = forward_step;
	}
	public String getFile_id() {
		return file_id;
	}
	public void setFile_id(String file_id) {
		this.file_id = file_id;
	}
	public String getDoc_id() {
		return doc_id;
	}
	public void setDoc_id(String doc_id) {
		this.doc_id = doc_id;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPre_report_no() {
		return pre_report_no;
	}
	public void setPre_report_no(String pre_report_no) {
		this.pre_report_no = pre_report_no;
	}
	public String getAudit_step() {
		return audit_step;
	}
	public void setAudit_step(String audit_step) {
		this.audit_step = audit_step;
	}
	public String getAudit_status() {
		return audit_status;
	}
	public void setAudit_status(String audit_status) {
		this.audit_status = audit_status;
	}
	public Date getAudit_date() {
		return audit_date;
	}
	public void setAudit_date(Date audit_date) {
		this.audit_date = audit_date;
	}
	public String getAudit_org() {
		return audit_org;
	}
	public void setAudit_org(String audit_org) {
		this.audit_org = audit_org;
	}
	public String getAudit_psn() {
		return audit_psn;
	}
	public void setAudit_psn(String audit_psn) {
		this.audit_psn = audit_psn;
	}
	
}
