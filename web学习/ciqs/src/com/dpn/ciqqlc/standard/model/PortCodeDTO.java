package com.dpn.ciqqlc.standard.model;

public class PortCodeDTO {

	private String port_code;//港口代码
	private String port_ename;//港口英文名称
	private String port_cname;//港口中文名称
	private String code_type;//港口类型
	private String create_date;//date创建时间
	private String create_user;//创建人
	private String flag_op;//A,D
	public String getPort_code() {
		return port_code;
	}
	public void setPort_code(String port_code) {
		this.port_code = port_code;
	}
	public String getPort_ename() {
		return port_ename;
	}
	public void setPort_ename(String port_ename) {
		this.port_ename = port_ename;
	}
	public String getPort_cname() {
		return port_cname;
	}
	public void setPort_cname(String port_cname) {
		this.port_cname = port_cname;
	}
	public String getCode_type() {
		return code_type;
	}
	public void setCode_type(String code_type) {
		this.code_type = code_type;
	}
	public String getCreate_date() {
		return create_date;
	}
	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}
	public String getCreate_user() {
		return create_user;
	}
	public void setCreate_user(String create_user) {
		this.create_user = create_user;
	}
	public String getFlag_op() {
		return flag_op;
	}
	public void setFlag_op(String flag_op) {
		this.flag_op = flag_op;
	}
	
}
