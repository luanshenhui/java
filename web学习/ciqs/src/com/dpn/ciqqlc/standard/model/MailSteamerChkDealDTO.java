package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class MailSteamerChkDealDTO {
	//QLC_MAIL_STEAMER_CHK_DEAL   邮轮业务检疫处理表
	private String id;//主键 UUID
	
	private String dec_master_id;//业务主键
	
	private String check_deal_proj;//检疫处理项目（同采样）
	
	private String check_deal_pic;//检疫处理照片（照片文件名）
	
	private String check_deal_notice;//检疫处理通知书
	
	private String check_deal_couse;//依据
	
	private String check_deal_method;//方法
	
	private String check_deal_finish_st;//完成状态
	
	private String check_deal_company;//处理公司
		
	private Date check_deal_date;//检疫处理时间	
	
	private String check_deal_psn;//检疫处理人
	
	private String check_deal_tgt;//检疫处理对象
	
	private String special_sign;//特殊标记
	
	private boolean is_commit;//是否提交
	
	private String qualified_flag;//是否合格
	
	private String check_deal_video;//检疫处理视频（视频文件名）
	
	private String check_deal_notice_video;//检疫处理通知书-视频
	
	private String proc_type;//环节类型

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

	public String getCheck_deal_proj() {
		return check_deal_proj;
	}

	public void setCheck_deal_proj(String check_deal_proj) {
		this.check_deal_proj = check_deal_proj;
	}

	public String getCheck_deal_pic() {
		return check_deal_pic;
	}

	public void setCheck_deal_pic(String check_deal_pic) {
		this.check_deal_pic = check_deal_pic;
	}

	public String getCheck_deal_notice() {
		return check_deal_notice;
	}

	public void setCheck_deal_notice(String check_deal_notice) {
		this.check_deal_notice = check_deal_notice;
	}

	public String getCheck_deal_couse() {
		return check_deal_couse;
	}

	public void setCheck_deal_couse(String check_deal_couse) {
		this.check_deal_couse = check_deal_couse;
	}

	public String getCheck_deal_method() {
		return check_deal_method;
	}

	public void setCheck_deal_method(String check_deal_method) {
		this.check_deal_method = check_deal_method;
	}

	public String getCheck_deal_finish_st() {
		return check_deal_finish_st;
	}

	public void setCheck_deal_finish_st(String check_deal_finish_st) {
		this.check_deal_finish_st = check_deal_finish_st;
	}

	public String getCheck_deal_company() {
		return check_deal_company;
	}

	public void setCheck_deal_company(String check_deal_company) {
		this.check_deal_company = check_deal_company;
	}

	public Date getCheck_deal_date() {
		return check_deal_date;
	}

	public void setCheck_deal_date(Date check_deal_date) {
		this.check_deal_date = check_deal_date;
	}

	public String getCheck_deal_psn() {
		return check_deal_psn;
	}

	public void setCheck_deal_psn(String check_deal_psn) {
		this.check_deal_psn = check_deal_psn;
	}

	public String getSpecial_sign() {
		return special_sign;
	}

	public void setSpecial_sign(String special_sign) {
		this.special_sign = special_sign;
	}

	public boolean isIs_commit() {
		return is_commit;
	}

	public void setIs_commit(boolean is_commit) {
		this.is_commit = is_commit;
	}

	public String getQualified_flag() {
		return qualified_flag;
	}

	public void setQualified_flag(String qualified_flag) {
		this.qualified_flag = qualified_flag;
	}

	public String getCheck_deal_video() {
		return check_deal_video;
	}

	public void setCheck_deal_video(String check_deal_video) {
		this.check_deal_video = check_deal_video;
	}

	public String getCheck_deal_notice_video() {
		return check_deal_notice_video;
	}

	public void setCheck_deal_notice_video(String check_deal_notice_video) {
		this.check_deal_notice_video = check_deal_notice_video;
	}

	public String getProc_type() {
		return proc_type;
	}

	public void setProc_type(String proc_type) {
		this.proc_type = proc_type;
	}

	public String getCheck_deal_tgt() {
		return check_deal_tgt;
	}

	public void setCheck_deal_tgt(String check_deal_tgt) {
		this.check_deal_tgt = check_deal_tgt;
	}

}
