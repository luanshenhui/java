package com.dpn.ciqqlc.http.form;

import java.util.Date;

/**
 * MailObjCheckForm.
 * 
 * @author wangzhy
 * @since 1.0.0 
 * @version 1.0.0 
 */
/* *****************************************************************************
 * 备忘记录
 * -> 
********************************************************************************
 * 变更履历
 * -> 1.0.0 2017-08-17  
***************************************************************************** */
public class MailObjCheckForm {
	
	private String package_no;

	private String consignee_name;
	
	private String cago_name;
	
	private String startIntrceptDate;
	
	private String endIntrceptDate;
	
	private String deal_type;
	
	private String port_org_code;
	
	private String port_zsorg_code;
	
	private String port_dept_code;

	public String getPort_zsorg_code() {
		return port_zsorg_code;
	}

	public void setPort_zsorg_code(String port_zsorg_code) {
		this.port_zsorg_code = port_zsorg_code;
	}

	public String getPackage_no() {
		return package_no;
	}

	public void setPackage_no(String package_no) {
		this.package_no = package_no;
	}

	public String getConsignee_name() {
		return consignee_name;
	}

	public void setConsignee_name(String consignee_name) {
		this.consignee_name = consignee_name;
	}

	public String getCago_name() {
		return cago_name;
	}

	public void setCago_name(String cago_name) {
		this.cago_name = cago_name;
	}

	public String getStartIntrceptDate() {
		return startIntrceptDate;
	}

	public void setStartIntrceptDate(String startIntrceptDate) {
		this.startIntrceptDate = startIntrceptDate;
	}

	public String getEndIntrceptDate() {
		return endIntrceptDate;
	}

	public void setEndIntrceptDate(String endIntrceptDate) {
		this.endIntrceptDate = endIntrceptDate;
	}

	public String getDeal_type() {
		return deal_type;
	}

	public void setDeal_type(String deal_type) {
		this.deal_type = deal_type;
	}

	public String getPort_org_code() {
		return port_org_code;
	}

	public void setPort_org_code(String port_org_code) {
		this.port_org_code = port_org_code;
	}

	public String getPort_dept_code() {
		return port_dept_code;
	}

	public void setPort_dept_code(String port_dept_code) {
		this.port_dept_code = port_dept_code;
	}
	
	
}
