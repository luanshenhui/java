package com.dpn.ciqqlc.http.form;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class YbcfQueryIo implements Serializable{
	
	private static final long serialVersionUID = 1L;
	
	private String step;
	
	private String status;
	
	private List<YbcfQueryIo> forms;
	
	/**
	 * :条件拼接
	 * key:value
	 */
	private List<QueryBaseIo> wList;
	
	/**
	 * :条件拼接
	 * key:value
	 */
	private String wListStr;
	
	/**
	 * 审理意见
	 */
	private String forward_step;
	/**
	 * 提交状态（是否提交） 0-未提交 1-已提交
	 */
	private String submit_status;
	
	/**
	 * 主键 UUID
	 * */
	private String id;
	/**
	 * 预申报号
	 * */
	private String pre_report_no;
	/**
	 * 单位名称
	 * */
	private String comp_name;
	/**
	 * 姓名
	 * */
	private String psn_name;
	/**
	 * 性别
	 * */
	private String gender;
	/**
	 * 出生年月
	 * */
	private String birth;
	/**
	 * 国籍
	 * */
	private String nation;
	/**
	 * 法定代表人
	 * */
	private String corporate_psn;
	/**
	 * 住址或地址
	 * */
	private String addr;
	/**
	 * 联系电话
	 * */
	private String tel;
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
	 * 审批科室
	 */
	private String audit_dpmt;
	/**
	 * 直属局
	 */
	private String belong_org;
	/**
	 * 立案号
	 */
	private String case_no;
	/**
	 * 业务主键
	 */
	private String main_id;
	/**
	 * 归档状态
	 */
	private String finished_status;
	
	
	/** 二轮新增字段*/
	
	/**个人住址*/
	private String per_addr;
	
	/**年龄*/
	private String age;
	
	/**联系人*/
	private String contacts_name;
	
	
	/**
	 * :申报状态
	 */
	private String step_status;
	/**
	 * :申报时间
	 */
	private Date step_date;
	/**
	 * :申报时间
	 */
	private String step_date_begin;
	/**
	 * 申报时间
	 */
	private String step_date_end;
	/**
	 * 业务处/办事处
	 */
	private String step_org;
	/**
	 * 申报人
	 */
	private String step_psn;
	
	/**
	 * 分页参数
	 */
	private String firstRcd;
	/**
	 * 分页参数
	 */
	private String lastRcd;
	
	/**
	 * 申报局
	 */
	private String declare_org;
	
	/**
	 * 受理局
	 */
	private String accept_org;
	
	/**
	 * 相关局
	 */
	private String org_code;
	
	
	public String getOrg_code() {
		return org_code;
	}
	public void setOrg_code(String org_code) {
		this.org_code = org_code;
	}
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
	public String getStep() {
		return step;
	}
	public void setStep(String step) {
		this.step = step;
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
	public String getPre_report_no() {
		return pre_report_no;
	}
	public void setPre_report_no(String pre_report_no) {
		this.pre_report_no = pre_report_no;
	}
	public String getComp_name() {
		return comp_name;
	}
	public void setComp_name(String comp_name) {
		this.comp_name = comp_name;
	}
	public String getPsn_name() {
		return psn_name;
	}
	public void setPsn_name(String psn_name) {
		this.psn_name = psn_name;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getBirth() {
		return birth;
	}
	public void setBirth(String birth) {
		this.birth = birth;
	}
	public String getNation() {
		return nation;
	}
	public void setNation(String nation) {
		this.nation = nation;
	}
	public String getCorporate_psn() {
		return corporate_psn;
	}
	public void setCorporate_psn(String corporate_psn) {
		this.corporate_psn = corporate_psn;
	}
	public String getAddr() {
		return addr;
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
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
	public String getAudit_dpmt() {
		return audit_dpmt;
	}
	public void setAudit_dpmt(String audit_dpmt) {
		this.audit_dpmt = audit_dpmt;
	}
	public String getBelong_org() {
		return belong_org;
	}
	public void setBelong_org(String belong_org) {
		this.belong_org = belong_org;
	}
	public String getCase_no() {
		return case_no;
	}
	public void setCase_no(String case_no) {
		this.case_no = case_no;
	}
	public String getMain_id() {
		return main_id;
	}
	public void setMain_id(String main_id) {
		this.main_id = main_id;
	}
	public String getFinished_status() {
		return finished_status;
	}
	public void setFinished_status(String finished_status) {
		this.finished_status = finished_status;
	}

	public List<YbcfQueryIo> getForms() {
		return forms;
	}

	public void setForms(List<YbcfQueryIo> forms) {
		this.forms = forms;
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
	public String getForward_step() {
		return forward_step;
	}
	public void setForward_step(String forward_step) {
		this.forward_step = forward_step;
	}

	public String getSubmit_status() {
		return submit_status;
	}
	public void setSubmit_status(String submit_status) {
		this.submit_status = submit_status;
	}
	public String getPer_addr() {
		return per_addr;
	}
	public void setPer_addr(String per_addr) {
		this.per_addr = per_addr;
	}
	public String getAge() {
		return age;
	}
	public void setAge(String age) {
		this.age = age;
	}
	public String getContacts_name() {
		return contacts_name;
	}
	public void setContacts_name(String contacts_name) {
		this.contacts_name = contacts_name;
	}
	public String getStep_status() {
		return step_status;
	}
	public void setStep_status(String step_status) {
		this.step_status = step_status;
	}
	public Date getStep_date() {
		return step_date;
	}
	public void setStep_date(Date step_date) {
		this.step_date = step_date;
	}
	public String getStep_date_begin() {
		return step_date_begin;
	}
	public void setStep_date_begin(String step_date_begin) {
		this.step_date_begin = step_date_begin;
	}
	public String getStep_date_end() {
		return step_date_end;
	}
	public void setStep_date_end(String step_date_end) {
		this.step_date_end = step_date_end;
	}
	public String getStep_org() {
		return step_org;
	}
	public void setStep_org(String step_org) {
		this.step_org = step_org;
	}
	public String getStep_psn() {
		return step_psn;
	}
	public void setStep_psn(String step_psn) {
		this.step_psn = step_psn;
	}
	public List<QueryBaseIo> getwList() {
		return wList;
	}
	public void setwList(List<QueryBaseIo> wList) {
		this.wList = wList;
	}
	public String getwListStr() {
		return wListStr;
	}
	public void setwListStr(String wListStr) {
		this.wListStr = wListStr;
	}
	
}
