package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class BilllingModel {
	private String ent_cname;//			报检单位中文名称
	private Date decl_date;//			报检日期
	private String oper_name;
	private String oper_date;
	private String bill_id;
	private String decl_no;
	private String book_no; 
	public String getOper_name() {
		return oper_name;
	}
	public void setOper_name(String oper_name) {
		this.oper_name = oper_name;
	}
	public String getOper_date() {
		return oper_date;
	}
	public void setOper_date(String oper_date) {
		this.oper_date = oper_date;
	}
	public String getEnt_cname() {
		return ent_cname;
	}
	public void setEnt_cname(String ent_cname) {
		this.ent_cname = ent_cname;
	}
	public Date getDecl_date() {
		return decl_date;
	}
	public void setDecl_date(Date decl_date) {
		this.decl_date = decl_date;
	}
	public String getDecl_no() {
		return decl_no;
	}
	public void setDecl_no(String decl_no) {
		this.decl_no = decl_no;
	}
	public String getBill_id() {
		return bill_id;
	}
	public void setBill_id(String bill_id) {
		this.bill_id = bill_id;
	}
	public String getBook_no() {
		return book_no;
	}
	public void setBook_no(String book_no) {
		this.book_no = book_no;
	}

	
	
}
