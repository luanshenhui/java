package com.dpn.ciqqlc.http.form;

public class DeclarationForm {
	private String startdate;//开始时间
	
	private String enddate;//结束时间 
	
	private String cnVslm;//中文船名
	
	private String fullVslm;//英文船名

	public String getStartdate() {
		return startdate;
	}

	public void setStartdate(String startdate) {
		this.startdate = startdate;
	}

	public String getEnddate() {
		return enddate;
	}

	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}

	public String getCnVslm() {
		return cnVslm;
	}

	public void setCnVslm(String cnVslm) {
		this.cnVslm = cnVslm;
	}

	public String getFullVslm() {
		return fullVslm;
	}

	public void setFullVslm(String fullVslm) {
		this.fullVslm = fullVslm;
	}
}
