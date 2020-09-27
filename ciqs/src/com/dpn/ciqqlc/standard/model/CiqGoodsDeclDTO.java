package com.dpn.ciqqlc.standard.model;


public class CiqGoodsDeclDTO {

	private String decl_no	;//		主键报检号
	private String book_no;//			外联预约序号
	private String decl_date;//			报检日期
	private String trans_means_name;//			船名
	private String trans_means_code	;//			航次
	private String insp_org_code;//			施检机构代码
	private String insp_org_name;//			施检机构
	private String insp_dept_1;//		施检部门代码
	private String insp_dept_1_name;//		施检部门
	private String contactor;//			联系人
	private String telephone;//			电话
	private String ent_cname;//			报检单位中文名称
	private String ent_ename;//			报检单位英文名称
	private String consignor_cname;//			发货人中文
	private String consignor_ename;//			发货人英文
	private String consignee_cname;//			收货人中文
	private String consignee_ename;//			收货人英文
	private String decl_type_code;//			报检类别13入境检验检疫14流向15验证
	private String dest_org_code;//			目的局（内地局）
	private String dest_code;//			目的地
	private String decl_person_code;//			报检员编号
	private String decl_reg_no;//			报检企业登记号
	private String consignee_code;//			收货人代码
	private String consignor_code;//			发货人代码
	private String ent_property;//			企业性质代码
	private String entry_port_code;//			入境口岸代码（进境）
	private String entry_port_name;//			入境口岸名称
	private String desp_port_code;//			启运口岸代码(出境)
	private String desp_port_name;//			启运口岸名称
	private String trade_mode_code;//		贸易方式代码
	private String trade_mode_name;//			贸易方式名称
	private String contract_no;//			合同号
	private String trade_country_name;//			贸易国别
	private String carrier_note_no;//			提单号
	private String cert_type_codes;//			许可证/审批码
	private String desp_country_name;//		启运国家（地区）
	public String getDecl_no() {
		return decl_no;
	}
	public void setDecl_no(String decl_no) {
		this.decl_no = decl_no;
	}
	public String getBook_no() {
		return book_no;
	}
	public void setBook_no(String book_no) {
		this.book_no = book_no;
	}

	public String getDecl_date() {
		return decl_date;
	}
	public void setDecl_date(String decl_date) {
		this.decl_date = decl_date;
	}
	public String getTrans_means_name() {
		return trans_means_name;
	}
	public void setTrans_means_name(String trans_means_name) {
		this.trans_means_name = trans_means_name;
	}
	public String getTrans_means_code() {
		return trans_means_code;
	}
	public void setTrans_means_code(String trans_means_code) {
		this.trans_means_code = trans_means_code;
	}
	public String getInsp_org_code() {
		return insp_org_code;
	}
	public void setInsp_org_code(String insp_org_code) {
		this.insp_org_code = insp_org_code;
	}
	public String getInsp_org_name() {
		return insp_org_name;
	}
	public void setInsp_org_name(String insp_org_name) {
		this.insp_org_name = insp_org_name;
	}
	public String getInsp_dept_1() {
		return insp_dept_1;
	}
	public void setInsp_dept_1(String insp_dept_1) {
		this.insp_dept_1 = insp_dept_1;
	}
	public String getInsp_dept_1_name() {
		return insp_dept_1_name;
	}
	public void setInsp_dept_1_name(String insp_dept_1_name) {
		this.insp_dept_1_name = insp_dept_1_name;
	}
	public String getContactor() {
		return contactor;
	}
	public void setContactor(String contactor) {
		this.contactor = contactor;
	}
	public String getTelephone() {
		return telephone;
	}
	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}
	public String getEnt_cname() {
		return ent_cname;
	}
	public void setEnt_cname(String ent_cname) {
		this.ent_cname = ent_cname;
	}
	public String getEnt_ename() {
		return ent_ename;
	}
	public void setEnt_ename(String ent_ename) {
		this.ent_ename = ent_ename;
	}
	public String getConsignor_cname() {
		return consignor_cname;
	}
	public void setConsignor_cname(String consignor_cname) {
		this.consignor_cname = consignor_cname;
	}
	public String getConsignor_ename() {
		return consignor_ename;
	}
	public void setConsignor_ename(String consignor_ename) {
		this.consignor_ename = consignor_ename;
	}
	public String getConsignee_cname() {
		return consignee_cname;
	}
	public void setConsignee_cname(String consignee_cname) {
		this.consignee_cname = consignee_cname;
	}
	public String getConsignee_ename() {
		return consignee_ename;
	}
	public void setConsignee_ename(String consignee_ename) {
		this.consignee_ename = consignee_ename;
	}
	public String getDecl_type_code() {
		return decl_type_code;
	}
	public void setDecl_type_code(String decl_type_code) {
		this.decl_type_code = decl_type_code;
	}
	public String getDest_org_code() {
		return dest_org_code;
	}
	public void setDest_org_code(String dest_org_code) {
		this.dest_org_code = dest_org_code;
	}
	public String getDest_code() {
		return dest_code;
	}
	public void setDest_code(String dest_code) {
		this.dest_code = dest_code;
	}
	public String getDecl_person_code() {
		return decl_person_code;
	}
	public void setDecl_person_code(String decl_person_code) {
		this.decl_person_code = decl_person_code;
	}
	public String getDecl_reg_no() {
		return decl_reg_no;
	}
	public void setDecl_reg_no(String decl_reg_no) {
		this.decl_reg_no = decl_reg_no;
	}
	public String getConsignee_code() {
		return consignee_code;
	}
	public void setConsignee_code(String consignee_code) {
		this.consignee_code = consignee_code;
	}
	public String getConsignor_code() {
		return consignor_code;
	}
	public void setConsignor_code(String consignor_code) {
		this.consignor_code = consignor_code;
	}
	public String getEnt_property() {
		return ent_property;
	}
	public void setEnt_property(String ent_property) {
		this.ent_property = ent_property;
	}
	public String getEntry_port_code() {
		return entry_port_code;
	}
	public void setEntry_port_code(String entry_port_code) {
		this.entry_port_code = entry_port_code;
	}
	public String getEntry_port_name() {
		return entry_port_name;
	}
	public void setEntry_port_name(String entry_port_name) {
		this.entry_port_name = entry_port_name;
	}
	public String getDesp_port_code() {
		return desp_port_code;
	}
	public void setDesp_port_code(String desp_port_code) {
		this.desp_port_code = desp_port_code;
	}
	public String getDesp_port_name() {
		return desp_port_name;
	}
	public void setDesp_port_name(String desp_port_name) {
		this.desp_port_name = desp_port_name;
	}
	public String getTrade_mode_code() {
		return trade_mode_code;
	}
	public void setTrade_mode_code(String trade_mode_code) {
		this.trade_mode_code = trade_mode_code;
	}
	public String getTrade_mode_name() {
		return trade_mode_name;
	}
	public void setTrade_mode_name(String trade_mode_name) {
		this.trade_mode_name = trade_mode_name;
	}
	public String getContract_no() {
		return contract_no;
	}
	public void setContract_no(String contract_no) {
		this.contract_no = contract_no;
	}
	public String getTrade_country_name() {
		return trade_country_name;
	}
	public void setTrade_country_name(String trade_country_name) {
		this.trade_country_name = trade_country_name;
	}
	public String getCarrier_note_no() {
		return carrier_note_no;
	}
	public void setCarrier_note_no(String carrier_note_no) {
		this.carrier_note_no = carrier_note_no;
	}
	public String getCert_type_codes() {
		return cert_type_codes;
	}
	public void setCert_type_codes(String cert_type_codes) {
		this.cert_type_codes = cert_type_codes;
	}
	public String getDesp_country_name() {
		return desp_country_name;
	}
	public void setDesp_country_name(String desp_country_name) {
		this.desp_country_name = desp_country_name;
	}
	
}
