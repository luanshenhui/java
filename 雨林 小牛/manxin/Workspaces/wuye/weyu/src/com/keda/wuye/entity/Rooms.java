package com.keda.wuye.entity;

public class Rooms {
	private String rooms_id;			//房间号
	private String rooms_housesid;		//房间楼盘号
	private String rooms_type;			//房型
	private double rooms_area;			//房间建筑面积
	private double rooms_usearea;		//室内面积
	public String getRooms_id() {
		return rooms_id;
	}
	public void setRooms_id(String rooms_id) {
		this.rooms_id = rooms_id;
	}
	public String getRooms_housesid() {
		return rooms_housesid;
	}
	public void setRooms_housesid(String rooms_housesid) {
		this.rooms_housesid = rooms_housesid;
	}
	public String getRooms_type() {
		return rooms_type;
	}
	public void setRooms_type(String rooms_type) {
		this.rooms_type = rooms_type;
	}
	public double getRooms_area() {
		return rooms_area;
	}
	public void setRooms_area(double rooms_area) {
		this.rooms_area = rooms_area;
	}
	public double getRooms_usearea() {
		return rooms_usearea;
	}
	public void setRooms_usearea(double rooms_usearea) {
		this.rooms_usearea = rooms_usearea;
	}
}
