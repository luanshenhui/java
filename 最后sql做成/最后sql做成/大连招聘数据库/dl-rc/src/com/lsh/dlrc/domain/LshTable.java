package com.lsh.dlrc.domain;

public class LshTable {
	private String sys_id;
	private String name;

	public String getSys_id() {
		return sys_id;
	}

	public void setSys_id(String sys_id) {
		this.sys_id = sys_id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return "LshTable [sys_id=" + sys_id + ", name=" + name + "]";
	}

}
