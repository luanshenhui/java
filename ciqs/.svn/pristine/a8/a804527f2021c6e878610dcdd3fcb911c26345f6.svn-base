package com.dpn.ciqqlc.standard.model;

public class BillLadingBookingDTO {
	
	private String bill_no;//		提单号
//	PORT_ORG_CODE	VARCHAR2(10)	N			申报口岸局代码，外联
//	PORT_DEPT_CODE	VARCHAR2(20)	N			申报科室代码，外联
//	TRAN_TYPE	VARCHAR2(2)	N	'0'		转关类型,0-非转关,1-转关运铁路,2-转关不运铁路
//	FLAG_YI	VARCHAR2(2)	N	'0'		疫情标示,0-无疫情,1-有疫情
	private String dest_area;//		货物目的区域
//	CREATED_DATE	DATE	N	sysdate		创建时间
//	DEC_DATE	DATE	N	to_date('190001010101','YYYYMMDDhh24mi')		申报时间
//	DEC_USER	VARCHAR2(30)	N			申报人，外联
//	DEC_ORG	VARCHAR2(20)	N			申报单位，外联
	private String approve_date;//	to_date('190001010101','YYYYMMDDhh24mi')		审批时间
	private String approve_user;//		审批人，外联
//	APPROVE_RESULT	NVARCHAR2(30)	N			审批意见（1：待审核，2：免检直放，3：查验，4：未通过，5：疫区处理）
	private String book_no	;//		主键，生成规则：监管口岸局代码+年月日+顺序号
	private String bill_id;//		提单编号
//	MOBILE_PHONE	NUMBER	Y			通知短信号码
//	SHIP_NAME_EN	VARCHAR2(35)	Y			船名
//	VOYAGE_NO	VARCHAR2(8)	Y			航次
//	GOODS_CAT	VARCHAR2(50)	Y			货物类型
	private String dec_org_name;	//		申报单位名称
//	IS_WASTER	VARCHAR2(1)	Y			是否废物
//	FLAG_DGOD	VARCHAR2(1)	Y	'0'		危险品标识0:否  1:是
//	DEC_TYPE	VARCHAR2(6)	Y			申报方式
//	DECL_GET_NO	VARCHAR2(20)	Y			转单号
	private String trans_flag;//	转内地局标识（0：无需转内地局；1：转内地局）
	private String dest_org_code;//			目的局DPN代码
//	INTEGRATION_SIGN	VARCHAR2(1)	Y	'0'		是否区域一体化0：否1：是
//	IS_RETURNC	VARCHAR2(1)	Y			是否退运
	public String getBill_no() {
		return bill_no;
	}
	public void setBill_no(String bill_no) {
		this.bill_no = bill_no;
	}
	public String getDest_area() {
		return dest_area;
	}
	public void setDest_area(String dest_area) {
		this.dest_area = dest_area;
	}
	public String getBill_id() {
		return bill_id;
	}
	public void setBill_id(String bill_id) {
		this.bill_id = bill_id;
	}
	public String getTrans_flag() {
		return trans_flag;
	}
	public void setTrans_flag(String trans_flag) {
		this.trans_flag = trans_flag;
	}
	public String getDest_org_code() {
		return dest_org_code;
	}
	public void setDest_org_code(String dest_org_code) {
		this.dest_org_code = dest_org_code;
	}
	public String getBook_no() {
		return book_no;
	}
	public void setBook_no(String book_no) {
		this.book_no = book_no;
	}
	public String getApprove_user() {
		return approve_user;
	}
	public void setApprove_user(String approve_user) {
		this.approve_user = approve_user;
	}
	public String getApprove_date() {
		return approve_date;
	}
	public void setApprove_date(String approve_date) {
		this.approve_date = approve_date;
	}
	public String getDec_org_name() {
		return dec_org_name;
	}
	public void setDec_org_name(String dec_org_name) {
		this.dec_org_name = dec_org_name;
	}


}
