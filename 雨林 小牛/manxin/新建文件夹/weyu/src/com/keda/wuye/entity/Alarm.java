package com.keda.wuye.entity;

public class Alarm {
	private String alarm_id;			//报警编号
	private String alarm_date;			//报警时间
	private String alarm_location;		//事发地点
	private String alarm_matter;		//案情内容
	private String alarm_way;			//报警方式
	private String alarm_dealway;		//处理方式
	private String alarm_dealperson;	//处理人员
	private String alarm_dealresult;	//处理结果
	public String getAlarm_id() {
		return alarm_id;
	}
	public void setAlarm_id(String alarm_id) {
		this.alarm_id = alarm_id;
	}
	public String getAlarm_date() {
		return alarm_date;
	}
	public void setAlarm_date(String alarm_date) {
		this.alarm_date = alarm_date;
	}
	public String getAlarm_location() {
		return alarm_location;
	}
	public void setAlarm_location(String alarm_location) {
		this.alarm_location = alarm_location;
	}
	public String getAlarm_matter() {
		return alarm_matter;
	}
	public void setAlarm_matter(String alarm_matter) {
		this.alarm_matter = alarm_matter;
	}
	public String getAlarm_way() {
		return alarm_way;
	}
	public void setAlarm_way(String alarm_way) {
		this.alarm_way = alarm_way;
	}
	public String getAlarm_dealway() {
		return alarm_dealway;
	}
	public void setAlarm_dealway(String alarm_dealway) {
		this.alarm_dealway = alarm_dealway;
	}
	public String getAlarm_dealperson() {
		return alarm_dealperson;
	}
	public void setAlarm_dealperson(String alarm_dealperson) {
		this.alarm_dealperson = alarm_dealperson;
	}
	public String getAlarm_dealresult() {
		return alarm_dealresult;
	}
	public void setAlarm_dealresult(String alarm_dealresult) {
		this.alarm_dealresult = alarm_dealresult;
	}
}
