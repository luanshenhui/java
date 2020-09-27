package com.dpn.ciqqlc.standard.model;

public class VslDecDto {

private String	id;//	n	varchar2(36)	n			主键 uuid
//private String	vsl_dec_id	n	varchar2(50)	n			业务主键
//private String	vsl_cn_name	n	varchar2(50)	n			中文船名
private String	vsl_en_name;//	n	varchar2(50)	n			英文船名
//private String	country_cn_name	n	varchar2(50)	y			中文国籍
//private String	country_en_name	n	varchar2(50)	y			英文国籍
//private String	call_sign	n	varchar2(50)	y			呼号
//private String	total_ton	n	varchar2(50)	y			总吨
//private String	net_ton	n	varchar2(50)	y			净吨
private String	cur_cargo_sit	;//	varchar2(50)	y			载货种类数量及预靠泊地点
//private String	his_cargo_sit	n	varchar2(50)	y			上航次载货种类数量及本次到港作业任务
//private String	shipper_psn_num	n	varchar2(50)	y			船员人数
//private String	visitor_psn_num	n	varchar2(50)	y			旅客人数
//private String	start_ship_sit	n	varchar2(50)	y			发航港及出发日期
private String	est_arriv_date	;//	date	y			预计抵达日期及时间
//private String	last_four_port	n	varchar2(500)	y			近四周寄港及日期
//private String	ship_sanit_cert	n	varchar2(50)	y			船舶免予卫生控制措施证书/船舶卫生控制措施证书签发港及日期
//private String	traf_cert	n	varchar2(50)	y			交通工具卫生证书签发港及日期
//private String	having_patient	n	varchar2(50)	y			船上有无病人
//private String	having_corpse	n	varchar2(50)	y			船上是否有人非因意外死亡
//private String	having_mdk_mdi_cps	n	varchar2(50)	y			在航海中船上是否有鼠类或其它医学媒介生物反常死亡
//private String	dec_date	n	date	y			申报时间
//private String	dec_user	n	varchar2(50)	y			申报人员
//private String	check_type_dec	n	varchar2(50)	y			检疫方式（申报）
//private String	aprv_date	n	date	y			审批时间
//private String	aprv_user	n	varchar2(50)	y			审批人员
private String	check_type_aprv	;//	varchar2(50)	y			检疫方式（审批）
//private String	create_date	n	date	n			数据同步时间
//private String	port_org	n	varchar2(50)	y			直属局
//private String	port_org_under	n	varchar2(50)	y			分支机构
public String getId() {
	return id;
}
public void setId(String id) {
	this.id = id;
}
public String getVsl_en_name() {
	return vsl_en_name;
}
public void setVsl_en_name(String vsl_en_name) {
	this.vsl_en_name = vsl_en_name;
}
public String getCur_cargo_sit() {
	return cur_cargo_sit;
}
public void setCur_cargo_sit(String cur_cargo_sit) {
	this.cur_cargo_sit = cur_cargo_sit;
}
public String getEst_arriv_date() {
	return est_arriv_date;
}
public void setEst_arriv_date(String est_arriv_date) {
	this.est_arriv_date = est_arriv_date;
}
public String getCheck_type_aprv() {
	return check_type_aprv;
}
public void setCheck_type_aprv(String check_type_aprv) {
	this.check_type_aprv = check_type_aprv;
}


	
}
