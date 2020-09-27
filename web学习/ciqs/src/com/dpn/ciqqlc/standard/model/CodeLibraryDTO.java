package com.dpn.ciqqlc.standard.model;

import java.io.Serializable;

@SuppressWarnings("unchecked")
public class CodeLibraryDTO implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String code;
	private String name;
	private String type;
	private String port_org_code;
	private String create_user;
	private String create_date;
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
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getPort_org_code() {
		return port_org_code;
	}
	public void setPort_org_code(String port_org_code) {
		this.port_org_code = port_org_code;
	}
	public String getCreate_user() {
		return create_user;
	}
	public void setCreate_user(String create_user) {
		this.create_user = create_user;
	}
	public String getCreate_date() {
		return create_date;
	}
	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}
	public String getFlag_op() {
		return flag_op;
	}
	public void setFlag_op(String flag_op) {
		this.flag_op = flag_op;
	}
	
}
