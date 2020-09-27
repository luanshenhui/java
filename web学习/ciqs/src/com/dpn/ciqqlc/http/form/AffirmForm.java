package com.dpn.ciqqlc.http.form;


public class AffirmForm {
	private String vsl_cn_name;                     //中文船名
	private String vsl_en_name;                     //英文船名
	private String start_time;                      //开始时间
	private String end_time;                        //结束时间
	private String check_type_aprv;                 //检疫方式（审批）
	private String port_org;                        //直属局
	private String port_org_under;                  //分支机构
	public String getVsl_cn_name() {
		return vsl_cn_name;
	}
	public void setVsl_cn_name(String vsl_cn_name) {
		this.vsl_cn_name = vsl_cn_name;
	}
	public String getVsl_en_name() {
		return vsl_en_name;
	}
	public void setVsl_en_name(String vsl_en_name) {
		this.vsl_en_name = vsl_en_name;
	}
	public String getStart_time() {
		return start_time;
	}
	public void setStart_time(String start_time) {
		this.start_time = start_time;
	}
	public String getEnd_time() {
		return end_time;
	}
	public void setEnd_time(String end_time) {
		this.end_time = end_time;
	}
	public String getCheck_type_aprv() {
		return check_type_aprv;
	}
	public void setCheck_type_aprv(String check_type_aprv) {
		this.check_type_aprv = check_type_aprv;
	}
	public String getPort_org() {
		return port_org;
	}
	public void setPort_org(String port_org) {
		this.port_org = port_org;
	}
	public String getPort_org_under() {
		return port_org_under;
	}
	public void setPort_org_under(String port_org_under) {
		this.port_org_under = port_org_under;
	}
	
	
}
