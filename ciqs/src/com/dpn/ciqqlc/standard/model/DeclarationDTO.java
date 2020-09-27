package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class DeclarationDTO {
	private String id ;//主键
	
	private String rowNum;//序号
	
	public String getRowNum() {
		return rowNum;
	}

	public void setRowNum(String rowNum) {
		this.rowNum = rowNum;
	}
	
	private String dec_master_id;//业务主键

	private String cn_vsl_m;//中文船名

	private String full_vsl_m;//英文船名
	
	private String vsl_callsign;//呼号
	
	private String dec_org;//申报单位
	
	private Date dec_date;//申请提交时间 
	
	private String ciq_resault;//申报审批状态
	
	private String cent_war_level;//风险等级
	
	private String insp_type;//检疫方式
	
	private String mail_dec;//邮轮入境检疫申报	
	
	public String getMail_dec() {
		return mail_dec;
	}

	public void setMail_dec(String mail_dec) {
		this.mail_dec = mail_dec;
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

	public String getVsl_callsign() {
		return vsl_callsign;
	}

	public void setVsl_callsign(String vsl_callsign) {
		this.vsl_callsign = vsl_callsign;
	}

	public String getDec_org() {
		return dec_org;
	}

	public void setDec_org(String dec_org) {
		this.dec_org = dec_org;
	}
	
	public Date getDec_date() {
		return dec_date;
	}

	public void setDec_date(Date dec_date) {
		this.dec_date = dec_date;
	}

	public String getCiq_resault() {
		return ciq_resault;
	}

	public void setCiq_resault(String ciq_resault) {
		this.ciq_resault = ciq_resault;
	}

	public String getInsp_type() {
		return insp_type;
	}

	public void setInsp_type(String insp_type) {
		this.insp_type = insp_type;
	}

	public String getExpt_iterm() {
		return expt_iterm;
	}

	public void setExpt_iterm(String expt_iterm) {
		this.expt_iterm = expt_iterm;
	}

	private String expt_iterm;//异常事项
	
	private String file_name;//附件名称

	public String getFile_name() {
		return file_name;
	}

	public void setFile_name(String file_name) {
		this.file_name = file_name;
	}

	public String getCent_war_level() {
		return cent_war_level;
	}

	public void setCent_war_level(String cent_war_level) {
		this.cent_war_level = cent_war_level;
	}

}
