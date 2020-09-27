package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class LocalePunishDTO {
	private String id;                   //主键 UUID
	private String punish_id;            //业务主键
	private Date   punish_time;          //处罚时间
	private String  punish_time_str;	 // 处罚时间字符串
	private String party_name;           //当事人名称
	private String identifi_style;       //证件类型
	private String identifi_number;      //证件号码
	private String address;              //地址
	private String legal_represent;      //法定代表人
	private String legal_represent_phone;//法定代表人联系电话
	private String illegal_object;       //违法标的
	private String illegal_address;      //违法行为发生地
	private Date   illegal_time;         //违法行为发生时间
	private String party_represent;      //当事人现场代表
	private String party_represent_phone;//当事人现场代表联系电话
	private String survey_content;       //调查内容
	private String party_assign;         //当事人所属单位
	private String illegal_content;      //违反法规内容(名称，条目，款目，项目以英文逗号隔开)
	private String illegal_act;		 //违反法规内容文字
	private String legislative_authority;//执法根据(名称，条目，款目，项目以英文逗号隔开)
	private String punish_style;         //处罚方式 0-警告，1-罚款
	private String warnning_content;     //警告内容
	private String punish_money;         //罚款数额
	private String forfeit_pay_style;    //缴纳罚款方式 1-二维码支付，2银行卡支付
	private String forfeit_status;       //缴费状态 0-未交，1-已交
	private Date   pay_time;             //缴费时间
	private String bank_card;            //银行卡卡号
	private String reconsider;           //行政复议机构
	private String law_executor;         //执法人
	private String port_org_code;        //直属局
	private String port_dept_code;       //分支机构
	private String result_status;        //结案状态 0-未结案，1-已结案
		
	private String cur_psn_sign;		 // 当事人现场代表签名
	
	public String getIllegal_act() {
		return illegal_act;
	}
	public void setIllegal_act(String illegal_act) {
		this.illegal_act = illegal_act;
	}
	public String getPunish_time_str() {
		return punish_time_str;
	}
	public void setPunish_time_str(String punish_time_str) {
		this.punish_time_str = punish_time_str;
	}
	public String getCur_psn_sign() {
		return cur_psn_sign;
	}
	public void setCur_psn_sign(String cur_psn_sign) {
		this.cur_psn_sign = cur_psn_sign;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPunish_id() {
		return punish_id;
	}
	public void setPunish_id(String punish_id) {
		this.punish_id = punish_id;
	}
	public Date getPunish_time() {
		return punish_time;
	}
	public void setPunish_time(Date punish_time) {
		this.punish_time = punish_time;
	}
	public String getParty_name() {
		return party_name;
	}
	public void setParty_name(String party_name) {
		this.party_name = party_name;
	}
	public String getIdentifi_style() {
		return identifi_style;
	}
	public void setIdentifi_style(String identifi_style) {
		this.identifi_style = identifi_style;
	}
	public String getIdentifi_number() {
		return identifi_number;
	}
	public void setIdentifi_number(String identifi_number) {
		this.identifi_number = identifi_number;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getLegal_represent() {
		return legal_represent;
	}
	public void setLegal_represent(String legal_represent) {
		this.legal_represent = legal_represent;
	}
	public String getLegal_represent_phone() {
		return legal_represent_phone;
	}
	public void setLegal_represent_phone(String legal_represent_phone) {
		this.legal_represent_phone = legal_represent_phone;
	}
	public String getIllegal_object() {
		return illegal_object;
	}
	public void setIllegal_object(String illegal_object) {
		this.illegal_object = illegal_object;
	}
	public String getIllegal_address() {
		return illegal_address;
	}
	public void setIllegal_address(String illegal_address) {
		this.illegal_address = illegal_address;
	}
	public Date getIllegal_time() {
		return illegal_time;
	}
	public void setIllegal_time(Date illegal_time) {
		this.illegal_time = illegal_time;
	}
	public String getParty_represent() {
		return party_represent;
	}
	public void setParty_represent(String party_represent) {
		this.party_represent = party_represent;
	}
	public String getParty_represent_phone() {
		return party_represent_phone;
	}
	public void setParty_represent_phone(String party_represent_phone) {
		this.party_represent_phone = party_represent_phone;
	}
	public String getSurvey_content() {
		return survey_content;
	}
	public void setSurvey_content(String survey_content) {
		this.survey_content = survey_content;
	}
	public String getParty_assign() {
		return party_assign;
	}
	public void setParty_assign(String party_assign) {
		this.party_assign = party_assign;
	}
	public String getIllegal_content() {
		return illegal_content;
	}
	public void setIllegal_content(String illegal_content) {
		this.illegal_content = illegal_content;
	}
	public String getLegislative_authority() {
		return legislative_authority;
	}
	public void setLegislative_authority(String legislative_authority) {
		this.legislative_authority = legislative_authority;
	}
	public String getPunish_style() {
		return punish_style;
	}
	public void setPunish_style(String punish_style) {
		this.punish_style = punish_style;
	}
	public String getWarnning_content() {
		return warnning_content;
	}
	public void setWarnning_content(String warnning_content) {
		this.warnning_content = warnning_content;
	}
	public String getPunish_money() {
		return punish_money;
	}
	public void setPunish_money(String punish_money) {
		this.punish_money = punish_money;
	}
	public String getForfeit_pay_style() {
		return forfeit_pay_style;
	}
	public void setForfeit_pay_style(String forfeit_pay_style) {
		this.forfeit_pay_style = forfeit_pay_style;
	}
	public String getForfeit_status() {
		return forfeit_status;
	}
	public void setForfeit_status(String forfeit_status) {
		this.forfeit_status = forfeit_status;
	}
	public Date getPay_time() {
		return pay_time;
	}
	public void setPay_time(Date pay_time) {
		this.pay_time = pay_time;
	}
	public String getBank_card() {
		return bank_card;
	}
	public void setBank_card(String bank_card) {
		this.bank_card = bank_card;
	}
	public String getReconsider() {
		return reconsider;
	}
	public void setReconsider(String reconsider) {
		this.reconsider = reconsider;
	}
	public String getLaw_executor() {
		return law_executor;
	}
	public void setLaw_executor(String law_executor) {
		this.law_executor = law_executor;
	}
	public String getPort_org_code() {
		return port_org_code;
	}
	public void setPort_org_code(String port_org_code) {
		this.port_org_code = port_org_code;
	}
	public String getPort_dept_code() {
		return port_dept_code;
	}
	public void setPort_dept_code(String port_dept_code) {
		this.port_dept_code = port_dept_code;
	}
	public String getResult_status() {
		return result_status;
	}
	public void setResult_status(String result_status) {
		this.result_status = result_status;
	}
	
	
}
