package com.dpn.ciqqlc.standard.model;

import java.util.Date;

import org.apache.commons.lang.StringUtils;

/**
 * LicenseDecDTO 
 * 口岸卫生许可证申报
 * @author wangzhy
 * @since 1.0.0
 * @version 1.0.0
 */
public class LicenseDecDTO {
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
     * 申报时间
     */
	private Date declare_date;
	/**
     * 审批结果
     */
	private String approval_result;
	/**
     * 审批人/受理人
     */
	private String approval_user;
	
	private String approval_user2;
	/**
     * 审批时间//受理时间
     */
	private Date approval_date;
	
	private Date approval_date2;
	/**
     * 受理状态（0未受理 1受理）
     */
	private String status;
	/**
     * 受理局
     */
	private String admissible_org_code;
	/**
     * 受理局
     */
	private String admissible_org_name;
	/**
     * 评审组人员
     */
	private String approval_users_name;
	/**
     * 评审组人员(组长：组员)
     */
	private String approval_users_name2;
	/**
     * 评审组人员id
     */
	private String approval_users_id;
	/**
     * 评审结果
     */
	private String review_result;
	/**
     * 评审时间
     */
	private String review_date;
	/**
     * 申报时间long
     */
	private Long declare_dateLong;
	/**
     * 审批时间long
     */
	private Long approval_dateLong;
	/**
     * 警告天数
     */
	private int jb_date;
	/**
     * 决定人员
     */
	private String jd_user;
	/**
     * 评审上传文件名
     */
	private String file_name;
	/**
     * 延长期理由
     */
	private String prolong;
	/**
     * 评查结果
     */
	private String exam_result;
	/**
     * 初审结果
     */
	private String first_exam_result;
	/**
     * 评查人
     */
	private String exam_user;
	/**
     * 评查时间
     */
	private Date exam_date;	
	/**
     * 审查同意（1同意）
     */
	private String exam_status;
	/**
     * 决定结果（1准予 2不予）
     */
	private String jd_result;
	/**
     * 决定时间
     */
	private Date jd_date;
	/**
     * 决定审批
     */
	private String jd_sp;
	
	private String opr_psn;
	
	private Date opr_date;
	
	private String zz_result;
	
	private String zx_result;
	
	private String cx_result;
	
	private String comp_code;
	
	private String org_code;
	
	private String iszg;
	
	private String isdzbl;
	
	public String getIsdzbl() {
		return isdzbl;
	}
	public void setIsdzbl(String isdzbl) {
		this.isdzbl = isdzbl;
	}
	public String getFirst_exam_result() {
		return first_exam_result;
	}
	public void setFirst_exam_result(String first_exam_result) {
		this.first_exam_result = first_exam_result;
	}
	public String getApproval_user2() {
		return approval_user2;
	}
	public void setApproval_user2(String approval_user2) {
		this.approval_user2 = approval_user2;
	}
	public Date getApproval_date2() {
		return approval_date2;
	}
	public void setApproval_date2(Date approval_date2) {
		this.approval_date2 = approval_date2;
	}
	public String getIszg() {
		return iszg;
	}
	public void setIszg(String iszg) {
		this.iszg = iszg;
	}
	public String getApproval_users_name2() {
		return approval_users_name2;
	}
	public void setApproval_users_name2(String approval_users_name2) {
		this.approval_users_name2 = approval_users_name2;
	}
	public String getAdmissible_org_name() {
		return admissible_org_name;
	}
	public void setAdmissible_org_name(String admissible_org_name) {
		this.admissible_org_name = admissible_org_name;
	}
	public String getOrg_code() {
		return org_code;
	}
	public void setOrg_code(String org_code) {
		this.org_code = org_code;
	}
	public String getComp_code() {
		return comp_code;
	}
	public void setComp_code(String comp_code) {
		this.comp_code = comp_code;
	}
	public String getCx_result() {
		return cx_result;
	}
	public void setCx_result(String cx_result) {
		this.cx_result = cx_result;
	}
	public String getApproval_users_id() {
		return approval_users_id;
	}
	public void setApproval_users_id(String approval_users_id) {
		this.approval_users_id = approval_users_id;
	}
	public String getZz_result() {
		return zz_result;
	}
	public void setZz_result(String zz_result) {
		this.zz_result = zz_result;
	}
	public String getZx_result() {
		return zx_result;
	}
	public void setZx_result(String zx_result) {
		this.zx_result = zx_result;
	}
	public String getOpr_psn() {
		return opr_psn;
	}
	public void setOpr_psn(String opr_psn) {
		this.opr_psn = opr_psn;
	}
	public Date getOpr_date() {
		return opr_date;
	}
	public void setOpr_date(Date opr_date) {
		this.opr_date = opr_date;
	}
	public String getJd_sp() {
		return jd_sp;
	}
	public void setJd_sp(String jd_sp) {
		this.jd_sp = jd_sp;
	}
	public String getJd_result() {
		return jd_result;
	}
	public void setJd_result(String jd_result) {
		this.jd_result = jd_result;
	}
	public Date getJd_date() {
		return jd_date;
	}
	public void setJd_date(Date jd_date) {
		this.jd_date = jd_date;
	}
	public String getExam_status() {
		return exam_status;
	}
	public void setExam_status(String exam_status) {
		this.exam_status = exam_status;
	}
	public String getExam_user() {
		return exam_user;
	}
	public void setExam_user(String exam_user) {
		this.exam_user = exam_user;
	}
	public Date getExam_date() {
		return exam_date;
	}
	public void setExam_date(Date exam_date) {
		this.exam_date = exam_date;
	}
	public String getExam_result() {
		return exam_result;
	}
	public void setExam_result(String exam_result) {
		this.exam_result = exam_result;
	}
	public String getFile_name() {
		return file_name;
	}
	public void setFile_name(String file_name) {
		this.file_name = file_name;
	}
	public String getJd_user() {
		return jd_user;
	}
	public void setJd_user(String jd_user) {
		this.jd_user = jd_user;
	}
	public String getReview_date() {
		if(!StringUtils.isEmpty(this.review_date)){
			this.review_date = review_date.substring(0,this.review_date.length() -2);
		}
		return review_date;
	}
	public void setReview_date(String review_date) {
		this.review_date = review_date;
	}
	public int getJb_date() {
		return jb_date;
	}
	public void setJb_date(int jb_date) {
		this.jb_date = jb_date;
	}
	private String filePath;
	
	private String filePath2;
	
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String getFilePath2() {
		return filePath2;
	}
	public void setFilePath2(String filePath2) {
		this.filePath2 = filePath2;
	}
	
	public String getApproval_user() {
		return approval_user;
	}
	public void setApproval_user(String approval_user) {
		this.approval_user = approval_user;
	}
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
	public Date getDeclare_date() {
		return declare_date;
	}
	public void setDeclare_date(Date declare_date) {
		this.declare_date = declare_date;
	}
	public String getApproval_result() {
		return approval_result;
	}
	public void setApproval_result(String approval_result) {
		this.approval_result = approval_result;
	}
	public Date getApproval_date() {
		return approval_date;
	}
	public void setApproval_date(Date approval_date) {
		this.approval_date = approval_date;
	}
	public String getLicense_dno() {
		return license_dno;
	}
	public void setLicense_dno(String license_dno) {
		this.license_dno = license_dno;
	}
	public String getProlong() {
		return prolong;
	}
	public void setProlong(String prolong) {
		this.prolong = prolong;
	}
	
}
