package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class HygieneLicenseEventDto {

	private String licence_id;// varchar2(36) n 主表id
	private String status;// n varchar2(2) y
							// "状态0：申报，1：受理，2：受理审核，3：人员随机:4：人员随机审核，5：决定，6：决定审批(补发同意)
	// private String 7：终止申请，8：终止审批，9：补发申请，10补发审批，11：撤销，12：注销，13:整改，
	// private String 14：现场查验，15：撤销审批，16：注销审批，17：补发不同意"
	private String opr_psn;// varchar2(30) y 操作人
	private Date opr_date;// date y 操作时间
	private String files;// varchar2(200) y 随附单据
	private String opr_date_str;
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

	public String getOpr_date_str() {
		return opr_date_str;
	}

	public void setOpr_date_str(String opr_date_str) {
		this.opr_date_str = opr_date_str;
	}

}
