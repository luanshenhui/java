package com.dpn.ciqqlc.standard.model;


public class LimsDTO {
	
	private byte[] content	;//		检测报告
	private String start_date	;//			检测时间
	private String create_dpt	;//			检测部门
	private String id;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public byte[] getContent() {
		return content;
	}
	public void setContent(byte[] content) {
		this.content = content;
	}
	public String getStart_date() {
		return start_date;
	}
	public void setStart_date(String start_date) {
		this.start_date = start_date;
	}
	public String getCreate_dpt() {
		return create_dpt;
	}
	public void setCreate_dpt(String create_dpt) {
		this.create_dpt = create_dpt;
	}
	

}
