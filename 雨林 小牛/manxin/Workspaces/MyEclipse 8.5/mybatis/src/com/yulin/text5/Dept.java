package com.yulin.text5;

import java.util.List;

public class Dept {
	private int id;
	private String name;
	private String location;
	
	private List<Info> infos;

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

	public List<Info> getInfos() {
		return infos;
	}

	public void setInfos(List<Info> infos) {
		this.infos = infos;
	}

	@Override
	public String toString() {
		return "Dept [id=" + id + ", infos=" + infos + ", location=" + location
				+ ", name=" + name + "]";
	}

	public Dept() {
		super();
	}

	public Dept(int id, String name, String location, List<Info> infos) {
		super();
		this.id = id;
		this.name = name;
		this.location = location;
		this.infos = infos;
	}
}
