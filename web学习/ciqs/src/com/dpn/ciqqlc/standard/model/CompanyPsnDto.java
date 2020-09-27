package com.dpn.ciqqlc.standard.model;

import java.util.List;

public class CompanyPsnDto {
	
private String id	;//n	varchar2(50)	y			
private String ipc_no;//	n	varchar2(50)	y			
private String company_name;//	n	varchar2(50)	y			
private String company_address;//	n	varchar2(50)	y			
private String company_op;//	n	varchar2(50)	y			
private String ipc_product;//	n	varchar2(50)	y			
private String over_time;//	n	varchar2(50)	Y			
public String getId() {
	return id;
}
public void setId(String id) {
	this.id = id;
}
public String getIpc_no() {
	return ipc_no;
}
public void setIpc_no(String ipc_no) {
	this.ipc_no = ipc_no;
}
public String getCompany_name() {
	return company_name;
}
public void setCompany_name(String company_name) {
	this.company_name = company_name;
}
public String getCompany_address() {
	return company_address;
}
public void setCompany_address(String company_address) {
	this.company_address = company_address;
}
public String getCompany_op() {
	return company_op;
}
public void setCompany_op(String company_op) {
	this.company_op = company_op;
}
public String getIpc_product() {
	return ipc_product;
}
public void setIpc_product(String ipc_product) {
	this.ipc_product = ipc_product;
}
public String getOver_time() {
	return over_time;
}
public void setOver_time(String over_time) {
	this.over_time = over_time;
}
private String month;
private QlcEfpePsnDto lader;
private List person;
public String getMonth() {
	return month;
}
public void setMonth(String month) {
	this.month = month;
}
public QlcEfpePsnDto getLader() {
	return lader;
}
public void setLader(QlcEfpePsnDto lader) {
	this.lader = lader;
}
public List getPerson() {
	return person;
}
public void setPerson(List person) {
	this.person = person;
}




}
