package com.dpn.ciqqlc.standard.model;

import java.util.Date;


/**
 * LicenseDecDTO 
 * 口岸卫生许可证申报
 * @author wangzhy
 * @since 1.0.0
 * @version 1.0.0
 */
public class LicenseDecJsonDTO {
    /**
     * 主键ID
     */
	private String id;
	/**
     * 业务单号
     */
	private String license_dno;
	/**
     * 单位名称
     */
	private String comp_name;
	/**
     * 单位地址
     */
	private String comp_addr;
	/**
     * 经营地址
     */
	private String management_addr;
	/**
     * 经营面积
     */
	private String management_area;
	/**
     * 法定代表人（负责人或业主）
     */
	private String legal_name;
	/**
     * 联系人
     */
	private String contacts_name;
	/**
     * 联系电话
     */
	private String contacts_phone;
	/**
     * 电子邮箱
     */
	private String mailbox;
	/**
     * 传真
     */
	private String fax;
	/**
     * 从业人员人数
     */
	private String employee_num;
	/**
     * 是否通过体系认证、验证（证书号）
     */
	private String certificate_numver;
	/**
     * 经营类别
     */
	private String management_type;
	/**
     * 申请经营范围
     */
	private String apply_scope;
	/**
     * 申请类型
     */
	private String apply_type;
	/**
     * 原卫生许可证证号
     */
	private String hygiene_license_number;
	/**
     * 申报人
     */
	private String declare_user;
	/**
     * 审批结果
     */
	private String approval_result;
	/**
     * 审批时间
     */
	private String status;
	/**
     * 受理局
     */
	private String admissible_org_code;
	/**
     * 审查组人员
     */
	private String approval_users_name;
	/**
     * 评审结果
     */
	private String review_result;
	/**
     * 申报时间long
     */
	private Long declare_dateLong;
	/**
     * 审批时间long
     */
	private Long approval_dateLong;
	
	public String getReview_result() {
		return review_result;
	}
	public void setReview_result(String review_result) {
		this.review_result = review_result;
	}
	public Long getDeclare_dateLong() {
		return declare_dateLong;
	}
	public void setDeclare_dateLong(Long declare_dateLong) {
		this.declare_dateLong = declare_dateLong;
	}
	public Long getApproval_dateLong() {
		return approval_dateLong;
	}
	public void setApproval_dateLong(Long approval_dateLong) {
		this.approval_dateLong = approval_dateLong;
	}
	public String getApproval_users_name() {
		return approval_users_name;
	}
	public void setApproval_users_name(String approval_users_name) {
		this.approval_users_name = approval_users_name;
	}
	public String getAdmissible_org_code() {
		return admissible_org_code;
	}
	public void setAdmissible_org_code(String admissible_org_code) {
		this.admissible_org_code = admissible_org_code;
	}
	
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getComp_name() {
		return comp_name;
	}
	public void setComp_name(String comp_name) {
		this.comp_name = comp_name;
	}
	public String getComp_addr() {
		return comp_addr;
	}
	public void setComp_addr(String comp_addr) {
		this.comp_addr = comp_addr;
	}
	public String getManagement_addr() {
		return management_addr;
	}
	public void setManagement_addr(String management_addr) {
		this.management_addr = management_addr;
	}
	public String getManagement_area() {
		return management_area;
	}
	public void setManagement_area(String management_area) {
		this.management_area = management_area;
	}
	public String getLegal_name() {
		return legal_name;
	}
	public void setLegal_name(String legal_name) {
		this.legal_name = legal_name;
	}
	public String getContacts_name() {
		return contacts_name;
	}
	public void setContacts_name(String contacts_name) {
		this.contacts_name = contacts_name;
	}
	public String getContacts_phone() {
		return contacts_phone;
	}
	public void setContacts_phone(String contacts_phone) {
		this.contacts_phone = contacts_phone;
	}
	public String getMailbox() {
		return mailbox;
	}
	public void setMailbox(String mailbox) {
		this.mailbox = mailbox;
	}
	public String getFax() {
		return fax;
	}
	public void setFax(String fax) {
		this.fax = fax;
	}
	public String getEmployee_num() {
		return employee_num;
	}
	public void setEmployee_num(String employee_num) {
		this.employee_num = employee_num;
	}
	public String getCertificate_numver() {
		return certificate_numver;
	}
	public void setCertificate_numver(String certificate_numver) {
		this.certificate_numver = certificate_numver;
	}
	public String getManagement_type() {
		return management_type;
	}
	public void setManagement_type(String management_type) {
		this.management_type = management_type;
	}
	public String getApply_scope() {
		return apply_scope;
	}
	public void setApply_scope(String apply_scope) {
		this.apply_scope = apply_scope;
	}
	public String getApply_type() {
		return apply_type;
	}
	public void setApply_type(String apply_type) {
		this.apply_type = apply_type;
	}
	public String getHygiene_license_number() {
		return hygiene_license_number;
	}
	public void setHygiene_license_number(String hygiene_license_number) {
		this.hygiene_license_number = hygiene_license_number;
	}
	public String getDeclare_user() {
		return declare_user;
	}
	public void setDeclare_user(String declare_user) {
		this.declare_user = declare_user;
	}
	public String getApproval_result() {
		return approval_result;
	}
	public void setApproval_result(String approval_result) {
		this.approval_result = approval_result;
	}
	public String getLicense_dno() {
		return license_dno;
	}
	public void setLicense_dno(String license_dno) {
		this.license_dno = license_dno;
	}
	
}
