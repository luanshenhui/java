package com.dpn.ciqqlc.standard.model;


public class BillCiqGoodModel extends PageDto{
	private String bill_id;//提单号
	private String bill_no;//提单号
	private String ship_name_cn	;//船名
	private String ship_name_en	;//船名
	private String voyage_no;//航次
	private String decl_no	;//		报检号
	private String decl_date;//			报检日期
	private String ent_cname;//			报检单位中文名称
	private String warning;//	风险预警
	private String consignee_cname;//			收货人中文
	private String date_begin;
	private String date_over;
	private String type;//新旧区分
	private String book_no;
	private String org_code;
	private String port_dept_code;//科室
	private String insp_org_name;
	
	public String getInsp_org_name() {
		return insp_org_name;
	}
	public void setInsp_org_name(String insp_org_name) {
		this.insp_org_name = insp_org_name;
	}
	public String getBill_no() {
		return bill_no;
	}
	public void setBill_no(String bill_no) {
		this.bill_no = bill_no;
	}
	public String getShip_name_cn() {
		return ship_name_cn;
	}
	public void setShip_name_cn(String ship_name_cn) {
		this.ship_name_cn = ship_name_cn;
	}
	public String getVoyage_no() {
		return voyage_no;
	}
	public void setVoyage_no(String voyage_no) {
		this.voyage_no = voyage_no;
	}
	public String getDecl_no() {
		return decl_no;
	}
	public void setDecl_no(String decl_no) {
		this.decl_no = decl_no;
	}

	public String getDecl_date() {
		return decl_date;
	}
	public void setDecl_date(String decl_date) {
		this.decl_date = decl_date;
	}
	public String getEnt_cname() {
		return ent_cname;
	}
	public void setEnt_cname(String ent_cname) {
		this.ent_cname = ent_cname;
	}
	public String getWarning() {
		return warning;
	}
	public void setWarning(String warning) {
		this.warning = warning;
	}
	public String getConsignee_cname() {
		return consignee_cname;
	}
	public void setConsignee_cname(String consignee_cname) {
		this.consignee_cname = consignee_cname;
	}
	public String getDate_begin() {
		return date_begin;
	}
	public void setDate_begin(String date_begin) {
		this.date_begin = date_begin;
	}
	public String getDate_over() {
		return date_over;
	}
	public void setDate_over(String date_over) {
		this.date_over = date_over;
	}
	public String getBill_id() {
		return bill_id;
	}
	public void setBill_id(String bill_id) {
		this.bill_id = bill_id;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getShip_name_en() {
		return ship_name_en;
	}
	public void setShip_name_en(String ship_name_en) {
		this.ship_name_en = ship_name_en;
	}
	public String getBook_no() {
		return book_no;
	}
	public void setBook_no(String book_no) {
		this.book_no = book_no;
	}
	public String getPort_dept_code() {
		return port_dept_code;
	}
	public void setPort_dept_code(String port_dept_code) {
		this.port_dept_code = port_dept_code;
	}
	public String getOrg_code() {
		return org_code;
	}
	public void setOrg_code(String org_code) {
		this.org_code = org_code;
	}
	
	
}
