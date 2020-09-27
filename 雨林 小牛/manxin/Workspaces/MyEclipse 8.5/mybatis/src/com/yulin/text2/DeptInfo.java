package com.yulin.text2;

public class DeptInfo {
	private int dept_id;
	private String info;
	public DeptInfo() {
		super();
		// TODO Auto-generated constructor stub
	}
	public int getDept_id() {
		return dept_id;
	}
	public void setDept_id(int deptId) {
		dept_id = deptId;
	}
	public String getInfo() {
		return info;
	}
	public void setInfo(String info) {
		this.info = info;
	}
	public DeptInfo(int deptId, String info) {
		super();
		dept_id = deptId;
		this.info = info;
	}
	@Override
	public String toString() {
		return "DeptInfo [dept_id=" + dept_id + ", info=" + info + "]";
	}
	
	
}
