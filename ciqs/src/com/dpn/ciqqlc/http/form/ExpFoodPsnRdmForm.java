package com.dpn.ciqqlc.http.form;

import java.util.Date;

public class ExpFoodPsnRdmForm {
	/**
	 * 主键UUID
	 * */
	private String id;
	/**
	 * 申请编号
	 * */
	private String apply_no;
	/**
	 * 人员表ID
	 * */
	private String psn_id;
	/**
	 * 姓名
	 * */
	private String psn_name;
	/**
	 * 专业
	 * */
	private String psn_prof;
	/**
	 * 特长
	 * */
	private String psn_goodat;
	/**
	 * 级别
	 * */
	private String psn_level;
	/**
	 * 是否在岗
	 * */
	private String in_post;
	/**
	 * 所在范围(一级部门、二级部门、三级部门)
	 * */
	private String bel_scope;
	/**
	 * 随机操作时间
	 * */
	private Date rdm_date;
	/**
	 * 随机操作人
	 * */
	private String rdm_user;
	/**
	 * 随机类型（1：人工干预；2：系统自动随机）
	 * */
	private String rdm_type;
	/**
	 * 小组身份（0：组长；1：组员）
	 * */
	private String psn_type;
	/**
	 * 类型（1：口岸许可证随机人员  2：食品备案）
	 * */
	private String type;
	
	
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
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
	public String getPsn_id() {
		return psn_id;
	}
	public void setPsn_id(String psn_id) {
		this.psn_id = psn_id;
	}
	public String getPsn_name() {
		return psn_name;
	}
	public void setPsn_name(String psn_name) {
		this.psn_name = psn_name;
	}
	public String getPsn_prof() {
		return psn_prof;
	}
	public void setPsn_prof(String psn_prof) {
		this.psn_prof = psn_prof;
	}
	public String getPsn_goodat() {
		return psn_goodat;
	}
	public void setPsn_goodat(String psn_goodat) {
		this.psn_goodat = psn_goodat;
	}
	public String getPsn_level() {
		return psn_level;
	}
	public void setPsn_level(String psn_level) {
		this.psn_level = psn_level;
	}
	public String getIn_post() {
		return in_post;
	}
	public void setIn_post(String in_post) {
		this.in_post = in_post;
	}
	public String getBel_scope() {
		return bel_scope;
	}
	public void setBel_scope(String bel_scope) {
		this.bel_scope = bel_scope;
	}
	public Date getRdm_date() {
		return rdm_date;
	}
	public void setRdm_date(Date rdm_date) {
		this.rdm_date = rdm_date;
	}
	public String getRdm_user() {
		return rdm_user;
	}
	public void setRdm_user(String rdm_user) {
		this.rdm_user = rdm_user;
	}
	public String getRdm_type() {
		return rdm_type;
	}
	public void setRdm_type(String rdm_type) {
		this.rdm_type = rdm_type;
	}
	/**
	 * 申请时间
	 */
	private Date apply_time;
	private Date apply_date;
	/**
	 * 流程环节
	 */
	private String proc_type;
	/**
	 * 申请形式
	 */
	private String apply_type;
	/**
	 * 企业名称
	 */
	private String comp_name;
	
	public String getComp_name() {
		return comp_name;
	}
	public void setComp_name(String comp_name) {
		this.comp_name = comp_name;
	}
	public String getApply_type() {
		return apply_type;
	}
	public void setApply_type(String apply_type) {
		this.apply_type = apply_type;
	}
	public String getProc_type() {
		return proc_type;
	}
	public void setProc_type(String proc_type) {
		this.proc_type = proc_type;
	}
	public Date getApply_time() {
		return apply_time;
	}
	public void setApply_time(Date apply_time) {
		this.apply_time = apply_time;
	}
	
	private String apply_time_begin;
	private String apply_time_over;

	public String getApply_time_begin() {
		return apply_time_begin;
	}
	public void setApply_time_begin(String apply_time_begin) {
		this.apply_time_begin = apply_time_begin;
	}
	public String getApply_time_over() {
		return apply_time_over;
	}
	public void setApply_time_over(String apply_time_over) {
		this.apply_time_over = apply_time_over;
	}
	public Date getApply_date() {
		return apply_date;
	}
	public void setApply_date(Date apply_date) {
		this.apply_date = apply_date;
	}
	public String getPsn_type() {
		return psn_type;
	}
	public void setPsn_type(String psn_type) {
		this.psn_type = psn_type;
	}
}
