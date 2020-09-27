package com.lsh.dlrc.domain;

public class PordDeptDomain {
	
	private String id;
	private String pId;
	private String name;
	private String sex;
	private String age;
	private Boolean checked;
	private Boolean open;
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
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public String getAge() {
		return age;
	}
	public void setAge(String age) {
		this.age = age;
	}
	public Boolean getChecked() {
		return true;
	}
	public void setChecked(Boolean checked) {
		this.checked = checked;
	}
	public String getpId() {
		return pId;
	}
	public void setpId(String pId) {
		this.pId = pId;
	}
	public Boolean getOpen() {
		return true;
	}
	public void setOpen(Boolean open) {
		this.open = open;
	}
	
}
