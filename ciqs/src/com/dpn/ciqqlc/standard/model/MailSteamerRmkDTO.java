package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class MailSteamerRmkDTO {
	//LC_MAIL_STEAMER_RMK   邮轮业务表
	private String id; //主键
	
	private String dec_master_id;//业务主键
	
	private String cn_vsl_m;//中文船名
	
	private String full_vsl_m;//英文船名
	
	private String cent_war_level;//总局风险等级
	
	private String cent_war_notice;//总局疫情报告、警示通报

	private String other_notice;//其他方面通报

	private String insp_type;//检疫方式(输入的)
	
	private String warning_level;//先期风险评估结果

	private String expt_iterm;//异常事项
	
	private String  decl_rmk;//申报备注
	
	private Date decl_insp_date;//申请书填制时间

	private String decl_insp_psn;//申请书填制人
	
	private String check_result;//检疫查验结果
	
	private String heth_supe_result;//卫生监督结果
	
	private String samp_result;//样品实验室结果
	
	private Date  check_result_date;//结果判定时间
	
	private String check_result_psn;//	结果判定人
	
	private String dec_ciq_id;// 卫检检疫申报单号（工作序号）
	
	private String vsl_guid;// 船舶GUID
	
	private String vsl_callsign;// 船舶呼号
	
	private String chk_dec;// 入境实施检疫方式申请：1锚地检疫、2靠泊检疫、3随船检疫、4电讯检疫
	
	private String chk_notify;// 入境实施检疫方式审批：1锚地检疫、2靠泊检疫、3随船检疫、4电讯检疫
	
	private String quar_resault;// 登船检疫结果：A通过\R不通过
	
	private String previous_port_date;// 发航港日期
	
	private String previous_port;// 发航/驶往港代码
	
	private String imp_cargo_name;// 进港载货名称
	
	private String imp_cargo_total;// 进港载货数量
	
	private String imp_cargo_unit;// 进港载货单位
	
	private String cargo_last_voy;// 上航次载货种类及数量
	
	private String sailor_total;// 船员人数
	
	private String imp_travel_total;// 旅客人数
	
	private String chk_patients;// 船上有无病人：Y有；N无
	
	private String chk_died;// 船上是否有人非因意外死亡
	
	private String chk_died_other;// 在航海中船上是否有鼠类或其他医学媒介生物反常死亡：Y有；N无
	
	private String quar_user;// 实施检疫人员
	
	private String quar_date;// 检疫完成时间
	
	private String quar_remarks;// 检疫备注
	
	private String vsl_grt;// 总吨
	
	private String vsl_nrt;// 净吨
	
	private String sign_date; // 签发日期
	
	private String dec_arrive_time;// 预计抵港时间
	
	private String last_four_port;// 近四周寄港及日期
	
	private String ship_sanit_cert;// 船舶免予卫生控制措施证书/船舶卫生控制措施证书签发港及日期
	
	private String traf_cert;// 交通工具卫生证书签发港及日期
	
	
	public String getShip_sanit_cert() {
		return ship_sanit_cert;
	}

	public void setShip_sanit_cert(String ship_sanit_cert) {
		this.ship_sanit_cert = ship_sanit_cert;
	}

	public String getTraf_cert() {
		return traf_cert;
	}

	public void setTraf_cert(String traf_cert) {
		this.traf_cert = traf_cert;
	}

	public String getLast_four_port() {
		return last_four_port;
	}

	public void setLast_four_port(String last_four_port) {
		this.last_four_port = last_four_port;
	}

	public String getDec_arrive_time() {
		return dec_arrive_time;
	}

	public void setDec_arrive_time(String dec_arrive_time) {
		this.dec_arrive_time = dec_arrive_time;
	}

	public String getDec_ciq_id() {
		return dec_ciq_id;
	}

	public void setDec_ciq_id(String dec_ciq_id) {
		this.dec_ciq_id = dec_ciq_id;
	}

	public String getVsl_guid() {
		return vsl_guid;
	}

	public void setVsl_guid(String vsl_guid) {
		this.vsl_guid = vsl_guid;
	}

	public String getVsl_callsign() {
		return vsl_callsign;
	}

	public void setVsl_callsign(String vsl_callsign) {
		this.vsl_callsign = vsl_callsign;
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

	public String getQuar_resault() {
		return quar_resault;
	}

	public void setQuar_resault(String quar_resault) {
		this.quar_resault = quar_resault;
	}

	public String getPrevious_port_date() {
		return previous_port_date;
	}

	public void setPrevious_port_date(String previous_port_date) {
		this.previous_port_date = previous_port_date;
	}

	public String getPrevious_port() {
		return previous_port;
	}

	public void setPrevious_port(String previous_port) {
		this.previous_port = previous_port;
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

	public String getImp_cargo_unit() {
		return imp_cargo_unit;
	}

	public void setImp_cargo_unit(String imp_cargo_unit) {
		this.imp_cargo_unit = imp_cargo_unit;
	}

	public String getCargo_last_voy() {
		return cargo_last_voy;
	}

	public void setCargo_last_voy(String cargo_last_voy) {
		this.cargo_last_voy = cargo_last_voy;
	}

	public String getSailor_total() {
		return sailor_total;
	}

	public void setSailor_total(String sailor_total) {
		this.sailor_total = sailor_total;
	}

	public String getImp_travel_total() {
		return imp_travel_total;
	}

	public void setImp_travel_total(String imp_travel_total) {
		this.imp_travel_total = imp_travel_total;
	}

	public String getChk_patients() {
		return chk_patients;
	}

	public void setChk_patients(String chk_patients) {
		this.chk_patients = chk_patients;
	}

	public String getChk_died() {
		return chk_died;
	}

	public void setChk_died(String chk_died) {
		this.chk_died = chk_died;
	}

	public String getChk_died_other() {
		return chk_died_other;
	}

	public void setChk_died_other(String chk_died_other) {
		this.chk_died_other = chk_died_other;
	}

	public String getQuar_user() {
		return quar_user;
	}

	public void setQuar_user(String quar_user) {
		this.quar_user = quar_user;
	}

	public String getQuar_date() {
		return quar_date;
	}

	public void setQuar_date(String quar_date) {
		this.quar_date = quar_date;
	}

	public String getQuar_remarks() {
		return quar_remarks;
	}

	public void setQuar_remarks(String quar_remarks) {
		this.quar_remarks = quar_remarks;
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

	public String getSign_date() {
		return sign_date;
	}

	public void setSign_date(String sign_date) {
		this.sign_date = sign_date;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
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

	public String getCent_war_level() {
		return cent_war_level;
	}

	public void setCent_war_level(String cent_war_level) {
		this.cent_war_level = cent_war_level;
	}

	public String getCent_war_notice() {
		return cent_war_notice;
	}

	public void setCent_war_notice(String cent_war_notice) {
		this.cent_war_notice = cent_war_notice;
	}

	public String getOther_notice() {
		return other_notice;
	}

	public void setOther_notice(String other_notice) {
		this.other_notice = other_notice;
	}

	public String getInsp_type() {
		return insp_type;
	}

	public void setInsp_type(String insp_type) {
		this.insp_type = insp_type;
	}

	public String getWarning_level() {
		return warning_level;
	}

	public void setWarning_level(String warning_level) {
		this.warning_level = warning_level;
	}

	public String getExpt_iterm() {
		return expt_iterm;
	}

	public void setExpt_iterm(String expt_iterm) {
		this.expt_iterm = expt_iterm;
	}

	public String getDecl_rmk() {
		return decl_rmk;
	}

	public void setDecl_rmk(String decl_rmk) {
		this.decl_rmk = decl_rmk;
	}

	public Date getDecl_insp_date() {
		return decl_insp_date;
	}

	public void setDecl_insp_date(Date decl_insp_date) {
		this.decl_insp_date = decl_insp_date;
	}

	public String getDecl_insp_psn() {
		return decl_insp_psn;
	}

	public void setDecl_insp_psn(String decl_insp_psn) {
		this.decl_insp_psn = decl_insp_psn;
	}

	public String getCheck_result() {
		return check_result;
	}

	public void setCheck_result(String check_result) {
		this.check_result = check_result;
	}

	public String getHeth_supe_result() {
		return heth_supe_result;
	}

	public void setHeth_supe_result(String heth_supe_result) {
		this.heth_supe_result = heth_supe_result;
	}

	public String getSamp_result() {
		return samp_result;
	}

	public void setSamp_result(String samp_result) {
		this.samp_result = samp_result;
	}

	public Date getCheck_result_date() {
		return check_result_date;
	}

	public void setCheck_result_date(Date check_result_date) {
		this.check_result_date = check_result_date;
	}

	public String getCheck_result_psn() {
		return check_result_psn;
	}

	public void setCheck_result_psn(String check_result_psn) {
		this.check_result_psn = check_result_psn;
	}


}
