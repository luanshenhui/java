package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class MailSteamerHlthCheckModel {
	//QLC_MAIL_STEAMER_HLTH_CHECK   邮轮业务卫生监督表
	
	private String id; //主键
	
	private String dec_master_id;//业务主键
	
	private String hun_name;//舱名
	
	private String hun_pic;//舱名照片
	
	private String hlth_check_type;//卫生监督类型（1：一般卫生监督:2：专项卫生监督）
	
	private String table_type;//表格类型（1：宿舱；2：厨房配餐间及供餐区域）
	
	private String check_impo;//检查要点ID
	
	private String  check_result;//检查结果
	
	private String viwe_evind;//所见证据（舱名+type）（同时存video表中的类型）
			
	private String samp_check;//采样（舱名+type）（同时存video表中的类型）
	
	private String check_deal;//检疫处理（舱名+type）（同时存video表中的类型）
	
	private String check_psn;//操作人
		
	private Date check_date;// 操作时间
	
	private String viwe_discription; // 所见证据描述


	public String getViwe_discription() {
		return viwe_discription;
	}

	public void setViwe_discription(String viwe_discription) {
		this.viwe_discription = viwe_discription;
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

	public String getHun_name() {
		return hun_name;
	}

	public void setHun_name(String hun_name) {
		this.hun_name = hun_name;
	}

	public String getHun_pic() {
		return hun_pic;
	}

	public void setHun_pic(String hun_pic) {
		this.hun_pic = hun_pic;
	}

	public String getHlth_check_type() {
		return hlth_check_type;
	}

	public void setHlth_check_type(String hlth_check_type) {
		this.hlth_check_type = hlth_check_type;
	}

	public String getTable_type() {
		return table_type;
	}

	public void setTable_type(String table_type) {
		this.table_type = table_type;
	}

	public String getCheck_impo() {
		return check_impo;
	}

	public void setCheck_impo(String check_impo) {
		this.check_impo = check_impo;
	}

	public String getCheck_result() {
		return check_result;
	}

	public void setCheck_result(String check_result) {
		this.check_result = check_result;
	}

	public String getViwe_evind() {
		return viwe_evind;
	}

	public void setViwe_evind(String viwe_evind) {
		this.viwe_evind = viwe_evind;
	}

	public String getSamp_check() {
		return samp_check;
	}

	public void setSamp_check(String samp_check) {
		this.samp_check = samp_check;
	}

	public String getCheck_deal() {
		return check_deal;
	}

	public void setCheck_deal(String check_deal) {
		this.check_deal = check_deal;
	}

	public String getCheck_psn() {
		return check_psn;
	}

	public void setCheck_psn(String check_psn) {
		this.check_psn = check_psn;
	}

	public Date getCheck_date() {
		return check_date;
	}

	public void setCheck_date(Date check_date) {
		this.check_date = check_date;
	}
	
	
}
