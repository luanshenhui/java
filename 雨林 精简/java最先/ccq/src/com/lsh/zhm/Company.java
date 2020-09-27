package com.lsh.zhm;

import java.util.ArrayList;
import java.util.List;

public class Company {
	private int id;
	private String name;
	private List<Member> list = new ArrayList<Member>();

	public Company() {
		this(0, "");
	}

	public Company(int id, String name) {
		super();
		this.id = id;
		this.name = name;
	}

	public List<Member> getList() {
		return list;
	}

	public void setList(List<Member> list) {
		this.list = list;
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

	@Override
	public String toString() {
		return "Company [id=" + id + ", list=" + list + ", name=" + name + "]";
	}

}
