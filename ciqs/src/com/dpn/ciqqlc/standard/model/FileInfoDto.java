package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class FileInfoDto extends PageDto{
	
	private String id;
	private String main_id;
	private String file_name;
	private String file_location;
	private String create_user;
	private Date create_date;
	private String create_date_begin;
	private String create_date_end;
	private String key_name;
	private String remark;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getMain_id() {
		return main_id;
	}
	public void setMain_id(String main_id) {
		this.main_id = main_id;
	}
	public String getFile_name() {
		return file_name;
	}
	public void setFile_name(String file_name) {
		this.file_name = file_name;
	}
	public String getFile_location() {
		return file_location;
	}
	public void setFile_location(String file_location) {
		this.file_location = file_location;
	}
	public String getCreate_user() {
		return create_user;
	}
	public void setCreate_user(String create_user) {
		this.create_user = create_user;
	}
	public Date getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Date create_date) {
		this.create_date = create_date;
	}
	public String getCreate_date_begin() {
		return create_date_begin;
	}
	public void setCreate_date_begin(String create_date_begin) {
		this.create_date_begin = create_date_begin;
	}
	public String getCreate_date_end() {
		return create_date_end;
	}
	public void setCreate_date_end(String create_date_end) {
		this.create_date_end = create_date_end;
	}
	
	private String user_name;
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getKey_name() {
		return key_name;
	}
	public void setKey_name(String key_name) {
		this.key_name = key_name;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	
}
