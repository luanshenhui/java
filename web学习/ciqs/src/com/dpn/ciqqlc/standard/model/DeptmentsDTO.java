package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class DeptmentsDTO 
{
	private String code;
	private String name;
	private String org_code;
	private Date created_date;
	private Date modify_date;
	private String created_user;
	private String flag_op;
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getOrg_code() {
		return org_code;
	}
	public void setOrg_code(String org_code) {
		this.org_code = org_code;
	}
	public Date getCreated_date() {
		return created_date;
	}
	public void setCreated_date(Date created_date) {
		this.created_date = created_date;
	}
	public Date getModify_date() {
		return modify_date;
	}
	public void setModify_date(Date modify_date) {
		this.modify_date = modify_date;
	}
	public String getCreated_user() {
		return created_user;
	}
	public void setCreated_user(String created_user) {
		this.created_user = created_user;
	}
	public String getFlag_op() {
		return flag_op;
	}
	public void setFlag_op(String flag_op) {
		this.flag_op = flag_op;
	}

}
