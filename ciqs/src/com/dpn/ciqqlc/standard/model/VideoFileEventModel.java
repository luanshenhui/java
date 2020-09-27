package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class VideoFileEventModel {
	
	private String id;

	private String proc_main_id;

	private String proc_type;
	
	private String top_proc_type;
	
	private String file_type;
	
	private String file_name;
	
	private String port_dept_code;
	
	private String port_org_code;
	
	private String create_user;
	
	private Date create_date;

	private String create_date_str;
	
	private String qt_name;

	private String name;
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCreate_date_str() {
		return create_date_str;
	}

	public void setCreate_date_str(String create_date_str) {
		this.create_date_str = create_date_str;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getProc_main_id() {
		return proc_main_id;
	}

	public void setProc_main_id(String proc_main_id) {
		this.proc_main_id = proc_main_id;
	}

	public String getProc_type() {
		return proc_type;
	}

	public void setProc_type(String proc_type) {
		this.proc_type = proc_type;
	}

	public String getTop_proc_type() {
		return top_proc_type;
	}

	public void setTop_proc_type(String top_proc_type) {
		this.top_proc_type = top_proc_type;
	}

	public String getFile_type() {
		return file_type;
	}

	public void setFile_type(String file_type) {
		this.file_type = file_type;
	}

	public String getFile_name() {
		return file_name;
	}

	public void setFile_name(String file_name) {
		this.file_name = file_name;
	}

	public String getPort_dept_code() {
		return port_dept_code;
	}

	public void setPort_dept_code(String port_dept_code) {
		this.port_dept_code = port_dept_code;
	}

	public String getPort_org_code() {
		return port_org_code;
	}

	public void setPort_org_code(String port_org_code) {
		this.port_org_code = port_org_code;
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

	public String getQt_name() {
		return qt_name;
	}

	public void setQt_name(String qt_name) {
		this.qt_name = qt_name;
	}

	
}
