package com.yulin.text2;

public class Dept {
	private int id;
	private String name;
	private String location;
	private DeptInfo info;
	
	public DeptInfo getInfo() {
		return info;
	}
	public void setInfo(DeptInfo info) {
		this.info = info;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public Dept() {
		super();
	}

	public Dept(int id, String name, String location, DeptInfo info) {
		super();
		this.id = id;
		this.name = name;
		this.location = location;
		this.info = info;
	}
	
	@Override
	public String toString() {
		return "Dept [id=" + id + ", info=" + info + ", location=" + location
				+ ", name=" + name + "]";
	}

	
}
