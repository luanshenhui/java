package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class ExpFoodProdCheckDto {
	private String id;
	private String apply_no;
	private String check_code_id;
	private String check_proc_type;
	private String check_result;
	private String check_disc;
	private String check_type;
	private String chech_psn;
	private Date check_date;
	private String verdict;
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
	public String getCheck_code_id() {
		return check_code_id;
	}
	public void setCheck_code_id(String check_code_id) {
		this.check_code_id = check_code_id;
	}
	public String getCheck_proc_type() {
		return check_proc_type;
	}
	public void setCheck_proc_type(String check_proc_type) {
		this.check_proc_type = check_proc_type;
	}
	public String getCheck_result() {
		return check_result;
	}
	public void setCheck_result(String check_result) {
		this.check_result = check_result;
	}
	public String getCheck_disc() {
		return check_disc;
	}
	public void setCheck_disc(String check_disc) {
		this.check_disc = check_disc;
	}
	public String getCheck_type() {
		return check_type;
	}
	public void setCheck_type(String check_type) {
		this.check_type = check_type;
	}
	public String getChech_psn() {
		return chech_psn;
	}
	public void setChech_psn(String chech_psn) {
		this.chech_psn = chech_psn;
	}
	public Date getCheck_date() {
		return check_date;
	}
	public void setCheck_date(Date check_date) {
		this.check_date = check_date;
	}
	public String getVerdict() {
		return verdict;
	}
	public void setVerdict(String verdict) {
		this.verdict = verdict;
	}

}
