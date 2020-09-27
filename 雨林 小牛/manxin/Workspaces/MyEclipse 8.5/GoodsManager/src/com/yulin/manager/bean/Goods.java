package com.yulin.manager.bean;

import java.sql.Date;

import javax.xml.crypto.Data;

public class Goods {
	private int id;
	private String cls;
	private String name;
	private String input_time;
	@Override
	public String toString() {
		return "Goods [cls=" + cls + ", id=" + id + ", input_time="
				+ input_time + ", name=" + name + "]";
	}
	public Goods() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Goods(int id, String cls, String name, String inputTime) {
		super();
		this.id = id;
		this.cls = cls;
		this.name = name;
		this.input_time = inputTime;
	}
	public int getId() {
		return id;
	}
	public void setInput_time(String inputTime) {
		input_time = inputTime;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getCls() {
		return cls;
	}
	public void setCls(String cls) {
		this.cls = cls;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public String getInput_time() {
		return input_time;
	}

}
