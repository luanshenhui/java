package com.dpn.ciqqlc.standard.model;

public class UsersModel {
	private String id;//用户代码，主键
	private String password;//密码
	private String name;//用户姓名
	private String dept_code;//用户所属科室
	private String level_code;
	private String org_code;//所属组织代码
	private String org_name;//所属组织代码
	private String directy_under_org; // 直属局代码
	private String flag_op;//操作标示,A.D
	private String card_no;
	
	
	public String getDirecty_under_org() {
		return directy_under_org;
	}
	public void setDirecty_under_org(String directy_under_org) {
		this.directy_under_org = directy_under_org;
	}
	public String getCard_no() {
		return card_no;
	}
	public void setCard_no(String card_no) {
		this.card_no = card_no;
	}
	public String getId() {
		return id;
	}
	public String getLevel_code() {
		return level_code;
	}
	public void setLevel_code(String level_code) {
		this.level_code = level_code;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDept_code() {
		return dept_code;
	}
	public void setDept_code(String dept_code) {
		this.dept_code = dept_code;
	}
	public String getOrg_code() {
		return org_code;
	}
	public void setOrg_code(String org_code) {
		this.org_code = org_code;
	}
	public String getOrg_name() {
		return org_name;
	}
	public void setOrg_name(String org_name) {
		this.org_name = org_name;
	}
	public String getFlag_op() {
		return flag_op;
	}
	public void setFlag_op(String flag_op) {
		this.flag_op = flag_op;
	}
	
	

}
