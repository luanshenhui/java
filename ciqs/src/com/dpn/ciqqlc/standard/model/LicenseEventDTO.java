package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class LicenseEventDTO {

	private String licence_id;
	
	private String status;
	
	private String opr_psn;
	
	private Date opr_date;
	
	private String files;

	public String getLicence_id() {
		return licence_id;
	}

	public void setLicence_id(String licence_id) {
		this.licence_id = licence_id;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getOpr_psn() {
		return opr_psn;
	}

	public void setOpr_psn(String opr_psn) {
		this.opr_psn = opr_psn;
	}

	public Date getOpr_date() {
		return opr_date;
	}

	public void setOpr_date(Date opr_date) {
		this.opr_date = opr_date;
	}

	public String getFiles() {
		return files;
	}

	public void setFiles(String files) {
		this.files = files;
	}
	
	
}
