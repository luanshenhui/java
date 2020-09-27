package com.dpn.ciqqlc.standard.model;

public class MailSteamerDTO {
	
	private String id ;//主键
	
	private String vsl_index;//序号
	
	private String dec_master_id;//业务主键

	private String cn_vsl_m;//中文船名

	private String full_vsl_m;//英文船名
	
	private String vsl_callsign;//呼号
	
	private String vsl_guid;//船舶id;
	
	private String dec_org;//申报单位
	
	private String chk_dec;//入境实施检疫方式申请：1锚地检疫、2靠泊检疫、3随船检疫、4电讯检疫
	
	private String chk_notify;//入境实施检疫方式审批：1锚地检疫、2靠泊检疫、3随船检疫、4电讯检疫
	
	private String traf_cert;//交通工具卫生证书签发港及日期
	
	private String ship_sanit_cert; //船舶免予卫生控制措施证书/船舶卫生控制措施证书签发港及日期
	
	private String last_four_port;//近四周寄港及日期
	
	private String approve_user;//审批人
	
	private String approve_date;//审批时间
	
	private String dec_date;//申请提交时间
	
	private String org_code;//直属局

	private String dept_code;//分支机构
	
	private String vsl_registry_cn;//船籍中文
	
	private String vsl_registry_en;//船籍英文

	private String vsl_grt;//总吨
	
	private String vsl_nrt;//净吨
	
	private String vsl_type;//船舶类型
	
	private String previous_port_cn;//发航港中文
	
	private String previous_port_en;//发航港英文
	
	private String sailor_total_foreign;//船员人数（外）

	private String sailor_total_china;//船员人数（中）
	
	private String imp_travel_total_foreign;//旅客人数（外）
	
	private String imp_travel_total_china;//旅客人数（中）
	
	private String blwt_load_date;//压舱水装载日期
	
	private String water_load_date;//饮水装载日期

	private String scc_cert_seq;//（免予）卫生控制证书序列号
	
	private String previous_port_date;//发航港日期
	
	private String sign_date;//签发日期
	
	private String scfc_cert_seq;//交通工具卫生证书序列号
	
	private String imp_cargo_name;//进港载货名称
	
	private String  imp_cargo_total;//进港载货数量
	
	private String food_lood_port;//食品装载港
	
	private String pass_port_date;
	
	private String vsl_imo_no;//IMO号
	
	private String vsl_no;//船舶编号
	
	private String exp_voyage_no;//出口航次

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getVsl_index() {
		return vsl_index;
	}

	public void setVsl_index(String vsl_index) {
		this.vsl_index = vsl_index;
	}

	public String getDec_master_id() {
		return dec_master_id;
	}

	public void setDec_master_id(String dec_master_id) {
		this.dec_master_id = dec_master_id;
	}

	public String getCn_vsl_m() {
		return cn_vsl_m;
	}

	public void setCn_vsl_m(String cn_vsl_m) {
		this.cn_vsl_m = cn_vsl_m;
	}

	public String getFull_vsl_m() {
		return full_vsl_m;
	}

	public void setFull_vsl_m(String full_vsl_m) {
		this.full_vsl_m = full_vsl_m;
	}

	public String getVsl_callsign() {
		return vsl_callsign;
	}

	public void setVsl_callsign(String vsl_callsign) {
		this.vsl_callsign = vsl_callsign;
	}

	public String getVsl_guid() {
		return vsl_guid;
	}

	public void setVsl_guid(String vsl_guid) {
		this.vsl_guid = vsl_guid;
	}

	public String getDec_org() {
		return dec_org;
	}

	public void setDec_org(String dec_org) {
		this.dec_org = dec_org;
	}

	public String getChk_dec() {
		return chk_dec;
	}

	public void setChk_dec(String chk_dec) {
		this.chk_dec = chk_dec;
	}

	public String getChk_notify() {
		return chk_notify;
	}

	public void setChk_notify(String chk_notify) {
		this.chk_notify = chk_notify;
	}

	public String getTraf_cert() {
		return traf_cert;
	}

	public void setTraf_cert(String traf_cert) {
		this.traf_cert = traf_cert;
	}

	public String getShip_sanit_cert() {
		return ship_sanit_cert;
	}

	public void setShip_sanit_cert(String ship_sanit_cert) {
		this.ship_sanit_cert = ship_sanit_cert;
	}

	public String getLast_four_port() {
		return last_four_port;
	}

	public void setLast_four_port(String last_four_port) {
		this.last_four_port = last_four_port;
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

	public String getDec_date() {
		return dec_date;
	}

	public void setDec_date(String dec_date) {
		this.dec_date = dec_date;
	}

	public String getOrg_code() {
		return org_code;
	}

	public void setOrg_code(String org_code) {
		this.org_code = org_code;
	}

	public String getDept_code() {
		return dept_code;
	}

	public void setDept_code(String dept_code) {
		this.dept_code = dept_code;
	}

	public String getVsl_registry_cn() {
		return vsl_registry_cn;
	}

	public void setVsl_registry_cn(String vsl_registry_cn) {
		this.vsl_registry_cn = vsl_registry_cn;
	}

	public String getVsl_registry_en() {
		return vsl_registry_en;
	}

	public void setVsl_registry_en(String vsl_registry_en) {
		this.vsl_registry_en = vsl_registry_en;
	}

	public String getVsl_grt() {
		return vsl_grt;
	}

	public void setVsl_grt(String vsl_grt) {
		this.vsl_grt = vsl_grt;
	}

	public String getVsl_nrt() {
		return vsl_nrt;
	}

	public void setVsl_nrt(String vsl_nrt) {
		this.vsl_nrt = vsl_nrt;
	}

	public String getVsl_type() {
		return vsl_type;
	}

	public void setVsl_type(String vsl_type) {
		this.vsl_type = vsl_type;
	}

	public String getPrevious_port_cn() {
		return previous_port_cn;
	}

	public void setPrevious_port_cn(String previous_port_cn) {
		this.previous_port_cn = previous_port_cn;
	}

	public String getPrevious_port_en() {
		return previous_port_en;
	}

	public void setPrevious_port_en(String previous_port_en) {
		this.previous_port_en = previous_port_en;
	}

	public String getSailor_total_foreign() {
		return sailor_total_foreign;
	}

	public void setSailor_total_foreign(String sailor_total_foreign) {
		this.sailor_total_foreign = sailor_total_foreign;
	}

	public String getSailor_total_china() {
		return sailor_total_china;
	}

	public void setSailor_total_china(String sailor_total_china) {
		this.sailor_total_china = sailor_total_china;
	}

	public String getImp_travel_total_foreign() {
		return imp_travel_total_foreign;
	}

	public void setImp_travel_total_foreign(String imp_travel_total_foreign) {
		this.imp_travel_total_foreign = imp_travel_total_foreign;
	}

	public String getImp_travel_total_china() {
		return imp_travel_total_china;
	}

	public void setImp_travel_total_china(String imp_travel_total_china) {
		this.imp_travel_total_china = imp_travel_total_china;
	}

	public String getBlwt_load_date() {
		return blwt_load_date;
	}

	public void setBlwt_load_date(String blwt_load_date) {
		this.blwt_load_date = blwt_load_date;
	}

	public String getWater_load_date() {
		return water_load_date;
	}

	public void setWater_load_date(String water_load_date) {
		this.water_load_date = water_load_date;
	}

	public String getScc_cert_seq() {
		return scc_cert_seq;
	}

	public void setScc_cert_seq(String scc_cert_seq) {
		this.scc_cert_seq = scc_cert_seq;
	}

	public String getPrevious_port_date() {
		return previous_port_date;
	}

	public void setPrevious_port_date(String previous_port_date) {
		this.previous_port_date = previous_port_date;
	}

	public String getSign_date() {
		return sign_date;
	}

	public void setSign_date(String sign_date) {
		this.sign_date = sign_date;
	}

	public String getScfc_cert_seq() {
		return scfc_cert_seq;
	}

	public void setScfc_cert_seq(String scfc_cert_seq) {
		this.scfc_cert_seq = scfc_cert_seq;
	}

	public String getImp_cargo_name() {
		return imp_cargo_name;
	}

	public void setImp_cargo_name(String imp_cargo_name) {
		this.imp_cargo_name = imp_cargo_name;
	}

	public String getImp_cargo_total() {
		return imp_cargo_total;
	}

	public void setImp_cargo_total(String imp_cargo_total) {
		this.imp_cargo_total = imp_cargo_total;
	}

	public String getFood_lood_port() {
		return food_lood_port;
	}

	public void setFood_lood_port(String food_lood_port) {
		this.food_lood_port = food_lood_port;
	}

	public String getPass_port_date() {
		return pass_port_date;
	}

	public void setPass_port_date(String pass_port_date) {
		this.pass_port_date = pass_port_date;
	}

	public String getExp_voyage_no() {
		return exp_voyage_no;
	}

	public void setExp_voyage_no(String exp_voyage_no) {
		this.exp_voyage_no = exp_voyage_no;
	}

	public String getVsl_imo_no() {
		return vsl_imo_no;
	}

	public void setVsl_imo_no(String vsl_imo_no) {
		this.vsl_imo_no = vsl_imo_no;
	}

	public String getVsl_no() {
		return vsl_no;
	}

	public void setVsl_no(String vsl_no) {
		this.vsl_no = vsl_no;
	}
}
