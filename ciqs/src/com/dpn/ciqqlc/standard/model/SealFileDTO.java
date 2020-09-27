package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class SealFileDTO {

	private String id;
	
	private String licence_id;
	
	private String doc_type;
	
	private Date create_date;
	
	private String create_user;
	
	private String doc_file_path;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getLicence_id() {
		return licence_id;
	}

	public void setLicence_id(String licence_id) {
		this.licence_id = licence_id;
	}

	public String getDoc_type() {
		return doc_type;
	}

	public void setDoc_type(String doc_type) {
		this.doc_type = doc_type;
	}

	public Date getCreate_date() {
		return create_date;
	}

	public void setCreate_date(Date create_date) {
		this.create_date = create_date;
	}

	public String getCreate_user() {
		return create_user;
	}

	public void setCreate_user(String create_user) {
		this.create_user = create_user;
	}

	public String getDoc_file_path() {
		return doc_file_path;
	}

	public void setDoc_file_path(String doc_file_path) {
		this.doc_file_path = doc_file_path;
	}
	
	
}
