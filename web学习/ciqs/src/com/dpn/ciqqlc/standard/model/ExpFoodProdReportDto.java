package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class ExpFoodProdReportDto {

	private String id;// varchar2(36) y 主键id
	private String apply_no;// varchar2(30) y 申请单号
	private String enter_no;// varchar2(20) y 备案编号
	private String company_cn_name;// nvarchar2(500) y 企业名称 中文
	private String company_adds;// nvarchar2(500) y 企业地址
	private String enter_type;// varchar2(50) y 备案类别
	private String juridical_psn;// varchar2(30) y 法人代表
	private String contacts;// varchar2(30) y 联系人
	private String contact_num;// varchar2(30) y 联系电话
	private String email;// varchar2(50) y 电子邮件
	private String company_pop;// varchar2(10) y 企业性质
	private String reg_capital;// varchar2(10) y 注册资本
	private String statement;// nvarchar2(1500) y 声明和承诺
	private String sign_name;// varchar2(100) y 法定代表人或授权负责人签名
	private Date sign_date;// date y 签名日期
	private String internal_auditor;// varchar2(30) Y 企业内审员
	
	private String userId;
	private String orgname;//企业名称
	private String productaddr;//地址
	private String recordnumber;//备案号
	private String headname;//	varchar2(100)	y	法人
	private String phone;
	private String corpnature;//	varchar2(50)	y	企业性质
	private String internalauditor;//	VARCHAR2(500)	Y	企业内审员
	
	private String attid;
	private String attname;
	private String path;
	private String filetype;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getApply_no() {
		return apply_no;
	}
	public void setApply_no(String apply_no) {
		this.apply_no = apply_no;
	}
	public String getEnter_no() {
		return enter_no;
	}
	public void setEnter_no(String enter_no) {
		this.enter_no = enter_no;
	}
	public String getCompany_cn_name() {
		return company_cn_name;
	}
	public void setCompany_cn_name(String company_cn_name) {
		this.company_cn_name = company_cn_name;
	}
	public String getCompany_adds() {
		return company_adds;
	}
	public void setCompany_adds(String company_adds) {
		this.company_adds = company_adds;
	}
	public String getEnter_type() {
		return enter_type;
	}
	public void setEnter_type(String enter_type) {
		this.enter_type = enter_type;
	}
	public String getJuridical_psn() {
		return juridical_psn;
	}
	public void setJuridical_psn(String juridical_psn) {
		this.juridical_psn = juridical_psn;
	}
	public String getContacts() {
		return contacts;
	}
	public void setContacts(String contacts) {
		this.contacts = contacts;
	}
	public String getContact_num() {
		return contact_num;
	}
	public void setContact_num(String contact_num) {
		this.contact_num = contact_num;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getCompany_pop() {
		return company_pop;
	}
	public void setCompany_pop(String company_pop) {
		this.company_pop = company_pop;
	}
	public String getReg_capital() {
		return reg_capital;
	}
	public void setReg_capital(String reg_capital) {
		this.reg_capital = reg_capital;
	}
	public String getStatement() {
		return statement;
	}
	public void setStatement(String statement) {
		this.statement = statement;
	}
	public String getSign_name() {
		return sign_name;
	}
	public void setSign_name(String sign_name) {
		this.sign_name = sign_name;
	}
	public Date getSign_date() {
		return sign_date;
	}
	public void setSign_date(Date sign_date) {
		this.sign_date = sign_date;
	}
	public String getInternal_auditor() {
		return internal_auditor;
	}
	public void setInternal_auditor(String internal_auditor) {
		this.internal_auditor = internal_auditor;
	}
	public String getOrgname() {
		return orgname;
	}
	public void setOrgname(String orgname) {
		this.orgname = orgname;
	}
	public String getProductaddr() {
		return productaddr;
	}
	public void setProductaddr(String productaddr) {
		this.productaddr = productaddr;
	}
	public String getRecordnumber() {
		return recordnumber;
	}
	public void setRecordnumber(String recordnumber) {
		this.recordnumber = recordnumber;
	}
	public String getHeadname() {
		return headname;
	}
	public void setHeadname(String headname) {
		this.headname = headname;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getCorpnature() {
		return corpnature;
	}
	public void setCorpnature(String corpnature) {
		this.corpnature = corpnature;
	}
	public String getInternalauditor() {
		return internalauditor;
	}
	public void setInternalauditor(String internalauditor) {
		this.internalauditor = internalauditor;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getAttid() {
		return attid;
	}
	public void setAttid(String attid) {
		this.attid = attid;
	}
	public String getAttname() {
		return attname;
	}
	public void setAttname(String attname) {
		this.attname = attname;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getFiletype() {
		return filetype;
	}
	public void setFiletype(String filetype) {
		this.filetype = filetype;
	}
	
	

}
