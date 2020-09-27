package com.dpn.ciqqlc.standard.model;


import java.io.Serializable;

import javax.servlet.http.HttpServletRequest;

@SuppressWarnings(value={"all"})
public class UserInfoAppDTO  implements Serializable {
	
	private String id;
	private String name;
	private String org_code;
	private String dept_code;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
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
	public String getDept_code() {
		return dept_code;
	}
	public void setDept_code(String dept_code) {
		this.dept_code = dept_code;
	}
	
	
}