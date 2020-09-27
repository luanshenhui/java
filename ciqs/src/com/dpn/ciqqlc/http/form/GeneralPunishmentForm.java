package com.dpn.ciqqlc.http.form;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class GeneralPunishmentForm implements Serializable{
	
	private static final long serialVersionUID = 1L;
	
	private String step;
	private String status;
	private List<GeneralPunishmentForm> forms;
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
	 * 申报局
	 */
	private String declare_org;
	
	/**
	 * 受理局
	 */
	private String accept_org;
	
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
	 * step1:申报状态
	 */
	private String step_1_status;
	/**
	 * step1:申报时间
	 */
	private Date step_1_date;
	/**
	 * step1:申报时间
	 */
	private String step_1_date_begin;
	/**
	 * step1:申报时间
	 */
	private String step_1_date_end;
	/**
	 * step1:业务处/办事处
	 */
	private String step_1_org;
	/**
	 * step1:申报人
	 */
	private String step_1_psn;
	/**
	 * step2:稽查受理状态
	 */
	private String step_2_status;
	/**
	 * step2:稽查受理时间
	 */
	private Date step_2_date;
	/**
	 * step2:稽查受理时间
	 */
	private String step_2_date_begin;
	/**
	 * step2:稽查受理时间
	 */
	private String step_2_date_end;
	/**
	 * step2:业务处/办事处
	 */
	private String step_2_org;
	/**
	 * step2:稽查受理人
	 */
	private String step_2_psn;
	/**
	 * step3:稽查审核状态
	 */
	private String step_3_status;
	/**
	 * step3:稽查审核时间
	 */
	private Date step_3_date;
	/**
	 * step3:稽查审核时间
	 */
	private String step_3_date_begin;
	/**
	 * step3:稽查审核时间
	 */
	private String step_3_date_end;
	/**
	 * step3:业务处/办事处
	 */
	private String step_3_org;
	/**
	 * step3:稽查审核人
	 */
	private String step_3_psn;
	/**
	 * step4:稽查审批状态
	 */
	private String step_4_status;
	/**
	 * step4:稽查审批时间
	 */
	private Date step_4_date;
	/**
	 * step4:稽查审批时间
	 */
	private String step_4_date_begin;
	/**
	 * step4:稽查审批时间
	 */
	private String step_4_date_end;
	/**
	 * step4:业务处/办事处
	 */
	private String step_4_org;
	/**
	 * step4:稽查审批人
	 */
	private String step_4_psn;
	/**
	 * step5:法制受理状态
	 */
	private String step_5_status;
	/**
	 * step5:法制受理时间
	 */
	private Date step_5_date;
	/**
	 * step5:法制受理时间
	 */
	private String step_5_date_begin;
	/**
	 * step5:法制受理时间
	 */
	private String step_5_date_end;
	/**
	 * step5:业务处/办事处
	 */
	private String step_5_org;
	/**
	 * step5:法制受理人
	 */
	private String step_5_psn;
	/**
	 * step6:法制审批状态
	 */
	private String step_6_status;
	/**
	 * step6:法制审批时间
	 */
	private Date step_6_date;
	/**
	 * step6:法制审批时间
	 */
	private String step_6_date_begin;
	/**
	 * step6:法制审批时间
	 */
	private String step_6_date_end;
	/**
	 * step6:业务处/办事处
	 */
	private String step_6_org;
	/**
	 * step6:法制审批人
	 */
	private String step_6_psn;
	/**
	 * step7:立案审批状态
	 */
	private String step_7_status;
	/**
	 * step7:立案审批时间
	 */
	private Date step_7_date;
	/**
	 * step7:立案审批时间
	 */
	private String step_7_date_begin;
	/**
	 * step7:立案审批时间
	 */
	private String step_7_date_end;
	/**
	 * step7:业务处/办事处
	 */
	private String step_7_org;
	/**
	 * step7:立案审批人
	 */
	private String step_7_psn;
	/**
	 * step8:延期审批状态
	 */
	private String step_8_status;
	/**
	 * step8:延期审批时间
	 */
	private Date step_8_date;
	/**
	 * step8:延期审批时间
	 */
	private String step_8_date_begin;
	/**
	 * step8:延期审批时间
	 */
	private String step_8_date_end;
	/**
	 * step8:业务处/办事处
	 */
	private String step_8_org;
	/**
	 * step8:延期审批人
	 */
	private String step_8_psn;
	/**
	 * step9:申报状态
	 */
	private String step_9_status;
	/**
	 * step9:申报时间
	 */
	private Date step_9_date;
	/**
	 * step9:申报时间
	 */
	private String step_9_date_begin;
	/**
	 * step9:申报时间
	 */
	private String step_9_date_end;
	/**
	 * step9:业务处/办事处
	 */
	private String step_9_org;
	/**
	 * step9:申报人
	 */
	private String step_9_psn;
	/**
	 * step10:申报状态
	 */
	private String step_10_status;
	/**
	 * step10:申报时间
	 */
	private Date step_10_date;
	/**
	 * step10:申报时间
	 */
	private String step_10_date_begin;
	/**
	 * step10:申报时间
	 */
	private String step_10_date_end;
	/**
	 * step10:业务处/办事处
	 */
	private String step_10_org;
	/**
	 * step10:申报人
	 */
	private String step_10_psn;
	/**
	 * step11:申报状态
	 */
	private String step_11_status;
	/**
	 * step11:申报时间
	 */
	private Date step_11_date;
	/**
	 * step11:申报时间
	 */
	private String step_11_date_begin;
	/**
	 * step11:申报时间
	 */
	private String step_11_date_end;
	/**
	 * step11:业务处/办事处
	 */
	private String step_11_org;
	/**
	 * step11:申报人
	 */
	private String step_11_psn;
	/**
	 * step12:申报状态
	 */
	private String step_12_status;
	/**
	 * step12:申报时间
	 */
	private Date step_12_date;
	/**
	 * step12:申报时间
	 */
	private String step_12_date_begin;
	/**
	 * step12:申报时间
	 */
	private String step_12_date_end;
	/**
	 * step12:业务处/办事处
	 */
	private String step_12_org;
	/**
	 * step12:申报人
	 */
	private String step_12_psn;
	/**
	 * step13:申报状态
	 */
	private String step_13_status;
	/**
	 * step13:申报时间
	 */
	private Date step_13_date;
	/**
	 * step13:申报时间
	 */
	private String step_13_date_begin;
	/**
	 * step13:申报时间
	 */
	private String step_13_date_end;
	/**
	 * step13:业务处/办事处
	 */
	private String step_13_org;
	/**
	 * step13:申报人
	 */
	private String step_13_psn;
	/**
	 * step14:申报状态
	 */
	private String step_14_status;
	/**
	 * step14:申报时间
	 */
	private Date step_14_date;
	/**
	 * step14:申报时间
	 */
	private String step_14_date_begin;
	/**
	 * step14:申报时间
	 */
	private String step_14_date_end;
	/**
	 * step14:业务处/办事处
	 */
	private String step_14_org;
	/**
	 * step14:申报人
	 */
	private String step_14_psn;
	
	/**
	 * 分页参数
	 */
	private String firstRcd;
	/**
	 * 分页参数
	 */
	private String lastRcd;
	
	/**
	 * step3:稽查审核状态
	 */
	private String step_16_status;
	/**
	 * step3:稽查审核时间
	 */
	private Date step_16_date;
	/**
	 * step3:稽查审核时间
	 */
	private String step_16_date_begin;
	/**
	 * step3:稽查审核时间
	 */
	private String step_16_date_end;
	/**
	 * step3:业务处/办事处
	 */
	private String step_16_org;
	/**
	 * step3:稽查审核人
	 */
	private String step_16_psn;
	
	/**
	 * step5:法制受理状态
	 */
	private String step_17_status;
	/**
	 * step5:法制受理时间
	 */
	private Date step_17_date;
	/**
	 * step5:法制受理时间
	 */
	private String step_17_date_begin;
	/**
	 * step5:法制受理时间
	 */
	private String step_17_date_end;
	/**
	 * step5:业务处/办事处
	 */
	private String step_17_org;
	/**
	 * step5:法制受理人
	 */
	private String step_17_psn;
	
	/**
	 * step5:法制受理状态
	 */
	private String step_20_status;
	/**
	 * step5:法制受理时间
	 */
	private Date step_20_date;
	/**
	 * step5:法制受理时间
	 */
	private String step_20_date_begin;
	/**
	 * step5:法制受理时间
	 */
	private String step_20_date_end;
	/**
	 * step5:业务处/办事处
	 */
	private String step_20_org;
	/**
	 * step5:法制受理人
	 */
	private String step_20_psn;
	
	
	public String getAccept_org() {
		return accept_org;
	}
	public void setAccept_org(String accept_org) {
		this.accept_org = accept_org;
	}
	public String getDeclare_org() {
		return declare_org;
	}
	public void setDeclare_org(String declare_org) {
		this.declare_org = declare_org;
	}
	public String getStep_16_status() {
		return step_16_status;
	}
	public void setStep_16_status(String step_16_status) {
		this.step_16_status = step_16_status;
	}
	public Date getStep_16_date() {
		return step_16_date;
	}
	public void setStep_16_date(Date step_16_date) {
		this.step_16_date = step_16_date;
	}
	public String getStep_16_date_begin() {
		return step_16_date_begin;
	}
	public void setStep_16_date_begin(String step_16_date_begin) {
		this.step_16_date_begin = step_16_date_begin;
	}
	public String getStep_16_date_end() {
		return step_16_date_end;
	}
	public void setStep_16_date_end(String step_16_date_end) {
		this.step_16_date_end = step_16_date_end;
	}
	public String getStep_16_org() {
		return step_16_org;
	}
	public void setStep_16_org(String step_16_org) {
		this.step_16_org = step_16_org;
	}
	public String getStep_16_psn() {
		return step_16_psn;
	}
	public void setStep_16_psn(String step_16_psn) {
		this.step_16_psn = step_16_psn;
	}
	public String getStep_17_status() {
		return step_17_status;
	}
	public void setStep_17_status(String step_17_status) {
		this.step_17_status = step_17_status;
	}
	public Date getStep_17_date() {
		return step_17_date;
	}
	public void setStep_17_date(Date step_17_date) {
		this.step_17_date = step_17_date;
	}
	public String getStep_17_date_begin() {
		return step_17_date_begin;
	}
	public void setStep_17_date_begin(String step_17_date_begin) {
		this.step_17_date_begin = step_17_date_begin;
	}
	public String getStep_17_date_end() {
		return step_17_date_end;
	}
	public void setStep_17_date_end(String step_17_date_end) {
		this.step_17_date_end = step_17_date_end;
	}
	public String getStep_17_org() {
		return step_17_org;
	}
	public void setStep_17_org(String step_17_org) {
		this.step_17_org = step_17_org;
	}
	public String getStep_17_psn() {
		return step_17_psn;
	}
	public void setStep_17_psn(String step_17_psn) {
		this.step_17_psn = step_17_psn;
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
	public String getStep_1_status() {
		return step_1_status;
	}
	public void setStep_1_status(String step_1_status) {
		this.step_1_status = step_1_status;
	}
	public Date getStep_1_date() {
		return step_1_date;
	}
	public void setStep_1_date(Date step_1_date) {
		this.step_1_date = step_1_date;
	}
	public String getStep_1_date_begin() {
		return step_1_date_begin;
	}
	public void setStep_1_date_begin(String step_1_date_begin) {
		this.step_1_date_begin = step_1_date_begin;
	}
	public String getStep_1_date_end() {
		return step_1_date_end;
	}
	public void setStep_1_date_end(String step_1_date_end) {
		this.step_1_date_end = step_1_date_end;
	}
	public String getStep_1_org() {
		return step_1_org;
	}
	public void setStep_1_org(String step_1_org) {
		this.step_1_org = step_1_org;
	}
	public String getStep_1_psn() {
		return step_1_psn;
	}
	public void setStep_1_psn(String step_1_psn) {
		this.step_1_psn = step_1_psn;
	}
	public String getStep_2_status() {
		return step_2_status;
	}
	public void setStep_2_status(String step_2_status) {
		this.step_2_status = step_2_status;
	}
	public Date getStep_2_date() {
		return step_2_date;
	}
	public void setStep_2_date(Date step_2_date) {
		this.step_2_date = step_2_date;
	}
	public String getStep_2_date_begin() {
		return step_2_date_begin;
	}
	public void setStep_2_date_begin(String step_2_date_begin) {
		this.step_2_date_begin = step_2_date_begin;
	}
	public String getStep_2_date_end() {
		return step_2_date_end;
	}
	public void setStep_2_date_end(String step_2_date_end) {
		this.step_2_date_end = step_2_date_end;
	}
	public String getStep_2_org() {
		return step_2_org;
	}
	public void setStep_2_org(String step_2_org) {
		this.step_2_org = step_2_org;
	}
	public String getStep_2_psn() {
		return step_2_psn;
	}
	public void setStep_2_psn(String step_2_psn) {
		this.step_2_psn = step_2_psn;
	}
	public String getStep_3_status() {
		return step_3_status;
	}
	public void setStep_3_status(String step_3_status) {
		this.step_3_status = step_3_status;
	}
	public Date getStep_3_date() {
		return step_3_date;
	}
	public void setStep_3_date(Date step_3_date) {
		this.step_3_date = step_3_date;
	}
	public String getStep_3_date_begin() {
		return step_3_date_begin;
	}
	public void setStep_3_date_begin(String step_3_date_begin) {
		this.step_3_date_begin = step_3_date_begin;
	}
	public String getStep_3_date_end() {
		return step_3_date_end;
	}
	public void setStep_3_date_end(String step_3_date_end) {
		this.step_3_date_end = step_3_date_end;
	}
	public String getStep_3_org() {
		return step_3_org;
	}
	public void setStep_3_org(String step_3_org) {
		this.step_3_org = step_3_org;
	}
	public String getStep_3_psn() {
		return step_3_psn;
	}
	public void setStep_3_psn(String step_3_psn) {
		this.step_3_psn = step_3_psn;
	}
	public String getStep_4_status() {
		return step_4_status;
	}
	public void setStep_4_status(String step_4_status) {
		this.step_4_status = step_4_status;
	}
	public Date getStep_4_date() {
		return step_4_date;
	}
	public void setStep_4_date(Date step_4_date) {
		this.step_4_date = step_4_date;
	}
	public String getStep_4_date_begin() {
		return step_4_date_begin;
	}
	public void setStep_4_date_begin(String step_4_date_begin) {
		this.step_4_date_begin = step_4_date_begin;
	}
	public String getStep_4_date_end() {
		return step_4_date_end;
	}
	public void setStep_4_date_end(String step_4_date_end) {
		this.step_4_date_end = step_4_date_end;
	}
	public String getStep_4_org() {
		return step_4_org;
	}
	public void setStep_4_org(String step_4_org) {
		this.step_4_org = step_4_org;
	}
	public String getStep_4_psn() {
		return step_4_psn;
	}
	public void setStep_4_psn(String step_4_psn) {
		this.step_4_psn = step_4_psn;
	}
	public String getStep_5_status() {
		return step_5_status;
	}
	public void setStep_5_status(String step_5_status) {
		this.step_5_status = step_5_status;
	}
	public Date getStep_5_date() {
		return step_5_date;
	}
	public void setStep_5_date(Date step_5_date) {
		this.step_5_date = step_5_date;
	}
	public String getStep_5_date_begin() {
		return step_5_date_begin;
	}
	public void setStep_5_date_begin(String step_5_date_begin) {
		this.step_5_date_begin = step_5_date_begin;
	}
	public String getStep_5_date_end() {
		return step_5_date_end;
	}
	public void setStep_5_date_end(String step_5_date_end) {
		this.step_5_date_end = step_5_date_end;
	}
	public String getStep_5_org() {
		return step_5_org;
	}
	public void setStep_5_org(String step_5_org) {
		this.step_5_org = step_5_org;
	}
	public String getStep_5_psn() {
		return step_5_psn;
	}
	public void setStep_5_psn(String step_5_psn) {
		this.step_5_psn = step_5_psn;
	}
	public String getStep_6_status() {
		return step_6_status;
	}
	public void setStep_6_status(String step_6_status) {
		this.step_6_status = step_6_status;
	}
	public Date getStep_6_date() {
		return step_6_date;
	}
	public void setStep_6_date(Date step_6_date) {
		this.step_6_date = step_6_date;
	}
	public String getStep_6_date_begin() {
		return step_6_date_begin;
	}
	public void setStep_6_date_begin(String step_6_date_begin) {
		this.step_6_date_begin = step_6_date_begin;
	}
	public String getStep_6_date_end() {
		return step_6_date_end;
	}
	public void setStep_6_date_end(String step_6_date_end) {
		this.step_6_date_end = step_6_date_end;
	}
	public String getStep_6_org() {
		return step_6_org;
	}
	public void setStep_6_org(String step_6_org) {
		this.step_6_org = step_6_org;
	}
	public String getStep_6_psn() {
		return step_6_psn;
	}
	public void setStep_6_psn(String step_6_psn) {
		this.step_6_psn = step_6_psn;
	}
	public String getStep_7_status() {
		return step_7_status;
	}
	public void setStep_7_status(String step_7_status) {
		this.step_7_status = step_7_status;
	}
	public Date getStep_7_date() {
		return step_7_date;
	}
	public void setStep_7_date(Date step_7_date) {
		this.step_7_date = step_7_date;
	}
	public String getStep_7_date_begin() {
		return step_7_date_begin;
	}
	public void setStep_7_date_begin(String step_7_date_begin) {
		this.step_7_date_begin = step_7_date_begin;
	}
	public String getStep_7_date_end() {
		return step_7_date_end;
	}
	public void setStep_7_date_end(String step_7_date_end) {
		this.step_7_date_end = step_7_date_end;
	}
	public String getStep_7_org() {
		return step_7_org;
	}
	public void setStep_7_org(String step_7_org) {
		this.step_7_org = step_7_org;
	}
	public String getStep_7_psn() {
		return step_7_psn;
	}
	public void setStep_7_psn(String step_7_psn) {
		this.step_7_psn = step_7_psn;
	}
	public String getStep_8_status() {
		return step_8_status;
	}
	public void setStep_8_status(String step_8_status) {
		this.step_8_status = step_8_status;
	}
	public Date getStep_8_date() {
		return step_8_date;
	}
	public void setStep_8_date(Date step_8_date) {
		this.step_8_date = step_8_date;
	}
	public String getStep_8_date_begin() {
		return step_8_date_begin;
	}
	public void setStep_8_date_begin(String step_8_date_begin) {
		this.step_8_date_begin = step_8_date_begin;
	}
	public String getStep_8_date_end() {
		return step_8_date_end;
	}
	public void setStep_8_date_end(String step_8_date_end) {
		this.step_8_date_end = step_8_date_end;
	}
	public String getStep_8_org() {
		return step_8_org;
	}
	public void setStep_8_org(String step_8_org) {
		this.step_8_org = step_8_org;
	}
	public String getStep_8_psn() {
		return step_8_psn;
	}
	public void setStep_8_psn(String step_8_psn) {
		this.step_8_psn = step_8_psn;
	}
	public String getStep_9_status() {
		return step_9_status;
	}
	public void setStep_9_status(String step_9_status) {
		this.step_9_status = step_9_status;
	}
	public Date getStep_9_date() {
		return step_9_date;
	}
	public void setStep_9_date(Date step_9_date) {
		this.step_9_date = step_9_date;
	}
	public String getStep_9_date_begin() {
		return step_9_date_begin;
	}
	public void setStep_9_date_begin(String step_9_date_begin) {
		this.step_9_date_begin = step_9_date_begin;
	}
	public String getStep_9_date_end() {
		return step_9_date_end;
	}
	public void setStep_9_date_end(String step_9_date_end) {
		this.step_9_date_end = step_9_date_end;
	}
	public String getStep_9_org() {
		return step_9_org;
	}
	public void setStep_9_org(String step_9_org) {
		this.step_9_org = step_9_org;
	}
	public String getStep_9_psn() {
		return step_9_psn;
	}
	public void setStep_9_psn(String step_9_psn) {
		this.step_9_psn = step_9_psn;
	}
	public String getStep_10_status() {
		return step_10_status;
	}
	public void setStep_10_status(String step_10_status) {
		this.step_10_status = step_10_status;
	}
	public Date getStep_10_date() {
		return step_10_date;
	}
	public void setStep_10_date(Date step_10_date) {
		this.step_10_date = step_10_date;
	}
	public String getStep_10_date_begin() {
		return step_10_date_begin;
	}
	public void setStep_10_date_begin(String step_10_date_begin) {
		this.step_10_date_begin = step_10_date_begin;
	}
	public String getStep_10_date_end() {
		return step_10_date_end;
	}
	public void setStep_10_date_end(String step_10_date_end) {
		this.step_10_date_end = step_10_date_end;
	}
	public String getStep_10_org() {
		return step_10_org;
	}
	public void setStep_10_org(String step_10_org) {
		this.step_10_org = step_10_org;
	}
	public String getStep_10_psn() {
		return step_10_psn;
	}
	public void setStep_10_psn(String step_10_psn) {
		this.step_10_psn = step_10_psn;
	}
	public String getStep_11_status() {
		return step_11_status;
	}
	public void setStep_11_status(String step_11_status) {
		this.step_11_status = step_11_status;
	}
	public Date getStep_11_date() {
		return step_11_date;
	}
	public void setStep_11_date(Date step_11_date) {
		this.step_11_date = step_11_date;
	}
	public String getStep_11_date_begin() {
		return step_11_date_begin;
	}
	public void setStep_11_date_begin(String step_11_date_begin) {
		this.step_11_date_begin = step_11_date_begin;
	}
	public String getStep_11_date_end() {
		return step_11_date_end;
	}
	public void setStep_11_date_end(String step_11_date_end) {
		this.step_11_date_end = step_11_date_end;
	}
	public String getStep_11_org() {
		return step_11_org;
	}
	public void setStep_11_org(String step_11_org) {
		this.step_11_org = step_11_org;
	}
	public String getStep_11_psn() {
		return step_11_psn;
	}
	public void setStep_11_psn(String step_11_psn) {
		this.step_11_psn = step_11_psn;
	}
	public String getStep_12_status() {
		return step_12_status;
	}
	public void setStep_12_status(String step_12_status) {
		this.step_12_status = step_12_status;
	}
	public Date getStep_12_date() {
		return step_12_date;
	}
	public void setStep_12_date(Date step_12_date) {
		this.step_12_date = step_12_date;
	}
	public String getStep_12_date_begin() {
		return step_12_date_begin;
	}
	public void setStep_12_date_begin(String step_12_date_begin) {
		this.step_12_date_begin = step_12_date_begin;
	}
	public String getStep_12_date_end() {
		return step_12_date_end;
	}
	public void setStep_12_date_end(String step_12_date_end) {
		this.step_12_date_end = step_12_date_end;
	}
	public String getStep_12_org() {
		return step_12_org;
	}
	public void setStep_12_org(String step_12_org) {
		this.step_12_org = step_12_org;
	}
	public String getStep_12_psn() {
		return step_12_psn;
	}
	public void setStep_12_psn(String step_12_psn) {
		this.step_12_psn = step_12_psn;
	}
	public String getStep_13_status() {
		return step_13_status;
	}
	public void setStep_13_status(String step_13_status) {
		this.step_13_status = step_13_status;
	}
	public Date getStep_13_date() {
		return step_13_date;
	}
	public void setStep_13_date(Date step_13_date) {
		this.step_13_date = step_13_date;
	}
	public String getStep_13_date_begin() {
		return step_13_date_begin;
	}
	public void setStep_13_date_begin(String step_13_date_begin) {
		this.step_13_date_begin = step_13_date_begin;
	}
	public String getStep_13_date_end() {
		return step_13_date_end;
	}
	public void setStep_13_date_end(String step_13_date_end) {
		this.step_13_date_end = step_13_date_end;
	}
	public String getStep_13_org() {
		return step_13_org;
	}
	public void setStep_13_org(String step_13_org) {
		this.step_13_org = step_13_org;
	}
	public String getStep_13_psn() {
		return step_13_psn;
	}
	public void setStep_13_psn(String step_13_psn) {
		this.step_13_psn = step_13_psn;
	}

	public List<GeneralPunishmentForm> getForms() {
		return forms;
	}

	public void setForms(List<GeneralPunishmentForm> forms) {
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
	public String getStep_14_status() {
		return step_14_status;
	}
	public void setStep_14_status(String step_14_status) {
		this.step_14_status = step_14_status;
	}
	public Date getStep_14_date() {
		return step_14_date;
	}
	public void setStep_14_date(Date step_14_date) {
		this.step_14_date = step_14_date;
	}
	public String getStep_14_date_begin() {
		return step_14_date_begin;
	}
	public void setStep_14_date_begin(String step_14_date_begin) {
		this.step_14_date_begin = step_14_date_begin;
	}
	public String getStep_14_date_end() {
		return step_14_date_end;
	}
	public void setStep_14_date_end(String step_14_date_end) {
		this.step_14_date_end = step_14_date_end;
	}
	public String getStep_14_org() {
		return step_14_org;
	}
	public void setStep_14_org(String step_14_org) {
		this.step_14_org = step_14_org;
	}
	public String getStep_14_psn() {
		return step_14_psn;
	}
	public void setStep_14_psn(String step_14_psn) {
		this.step_14_psn = step_14_psn;
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
	public String getStep_20_status() {
		return step_20_status;
	}
	public void setStep_20_status(String step_20_status) {
		this.step_20_status = step_20_status;
	}
	public Date getStep_20_date() {
		return step_20_date;
	}
	public void setStep_20_date(Date step_20_date) {
		this.step_20_date = step_20_date;
	}
	public String getStep_20_date_begin() {
		return step_20_date_begin;
	}
	public void setStep_20_date_begin(String step_20_date_begin) {
		this.step_20_date_begin = step_20_date_begin;
	}
	public String getStep_20_date_end() {
		return step_20_date_end;
	}
	public void setStep_20_date_end(String step_20_date_end) {
		this.step_20_date_end = step_20_date_end;
	}
	public String getStep_20_org() {
		return step_20_org;
	}
	public void setStep_20_org(String step_20_org) {
		this.step_20_org = step_20_org;
	}
	public String getStep_20_psn() {
		return step_20_psn;
	}
	public void setStep_20_psn(String step_20_psn) {
		this.step_20_psn = step_20_psn;
	}
}
