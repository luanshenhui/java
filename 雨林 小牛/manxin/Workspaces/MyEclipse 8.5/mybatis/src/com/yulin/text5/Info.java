package com.yulin.text5;

public class Info {
	private int id;
	private int d_id;
	private String info;
	private Dept dept;

	public int getD_id() {
		return d_id;
	}
	public void setD_id(int dId) {
		d_id = dId;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getInfo() {
		return info;
	}
	public void setInfo(String info) {
		this.info = info;
	}
	public Dept getDept() {
		return dept;
	}
	public void setDept(Dept dept) {
		this.dept = dept;
	}
	public Info() {
		super();
	}
	public Info(int id, int dId, String info, Dept dept) {
		super();
		this.id = id;
		d_id = dId;
		this.info = info;
		this.dept = dept;
	}
	@Override
	public String toString() {
		return "Info [d_id=" + d_id + ", dept=" + dept + ", id=" + id
				+ ", info=" + info + "]";
	}
}
