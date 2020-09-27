package com.keda.wuye.entity;

public class Complaint {
	private String complaint_id;			//投诉编号
	private String complaint_resid;			//投诉业主
	private String complaint_date;			//投诉时间
	private String complaint_matter;		//投诉事件
	private String complaint_dealperson;	//处理人员
	private String complaint_way;			//处理方式
	private String complaint_result;		//处理结果
	public String getComplaint_id() {
		return complaint_id;
	}
	public void setComplaint_id(String complaint_id) {
		this.complaint_id = complaint_id;
	}
	public String getComplaint_resid() {
		return complaint_resid;
	}
	public void setComplaint_resid(String complaint_resid) {
		this.complaint_resid = complaint_resid;
	}
	public String getComplaint_date() {
		return complaint_date;
	}
	public void setComplaint_date(String complaint_date) {
		this.complaint_date = complaint_date;
	}
	public String getComplaint_matter() {
		return complaint_matter;
	}
	public void setComplaint_matter(String complaint_matter) {
		this.complaint_matter = complaint_matter;
	}
	public String getComplaint_dealperson() {
		return complaint_dealperson;
	}
	public void setComplaint_dealperson(String complaint_dealperson) {
		this.complaint_dealperson = complaint_dealperson;
	}
	public String getComplaint_way() {
		return complaint_way;
	}
	public void setComplaint_way(String complaint_way) {
		this.complaint_way = complaint_way;
	}
	public String getComplaint_result() {
		return complaint_result;
	}
	public void setComplaint_result(String complaint_result) {
		this.complaint_result = complaint_result;
	}
}
