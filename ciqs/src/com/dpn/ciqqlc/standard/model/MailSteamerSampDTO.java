package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class MailSteamerSampDTO {
	//QLC_MAIL_STEAMER_SAMP   邮轮业务表（抽样）
	
	private String id; //主键
	
	private String dec_master_id;//业务主键
	
	private String cn_vsl_m;//中文船名
	
	private String full_vsl_m;//英文船名
	
	private String samp_proj;//采样项目（舱名+检查要点）
	
	private String samp_file;//采样照片(照片文件名)
	
	private String samp_notice;//采样知情同意书/采样凭证
	
	private String samp_psn;//采集人
	
	private Date  samp_date;//送检时间
	
	private Date  create_date;//送检时间
	
    private String send_samp_comp;//送检单位
    
    private String result_cmd;//结果报告
    
    private String result_cmd_paper;//结果报告单
    
    private String special_sign;//特殊标记
    
    private boolean is_commit;//是否提交
    
    private String samp_stat;//完成状态 1：完成，0：未完成
    
    private String samp_video;//采样视频(视频文件名)
    
    private String samp_notice_video;//采样知情同意书/采样凭证-视频
    
    private String result_cmd_paper_video;//结果报告单-视频
    
    private String proc_type;//环节类型
    
    private String samp_psn_cn; // 采集人
    
    public Date getCreate_date() {
		return create_date;
	}

	public void setCreate_date(Date create_date) {
		this.create_date = create_date;
	}

	public String getSamp_psn_cn() {
		return samp_psn_cn;
	}

	public void setSamp_psn_cn(String samp_psn_cn) {
		this.samp_psn_cn = samp_psn_cn;
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

	public String getSamp_proj() {
		return samp_proj;
	}

	public void setSamp_proj(String samp_proj) {
		this.samp_proj = samp_proj;
	}

	public String getSamp_file() {
		return samp_file;
	}

	public void setSamp_file(String samp_file) {
		this.samp_file = samp_file;
	}

	public String getSamp_notice() {
		return samp_notice;
	}

	public void setSamp_notice(String samp_notice) {
		this.samp_notice = samp_notice;
	}

	public String getSamp_psn() {
		return samp_psn;
	}

	public void setSamp_psn(String samp_psn) {
		this.samp_psn = samp_psn;
	}

	public Date getSamp_date() {
		return samp_date;
	}

	public void setSamp_date(Date samp_date) {
		this.samp_date = samp_date;
	}

	public String getSend_samp_comp() {
		return send_samp_comp;
	}

	public void setSend_samp_comp(String send_samp_comp) {
		this.send_samp_comp = send_samp_comp;
	}

	public String getResult_cmd() {
		return result_cmd;
	}

	public void setResult_cmd(String result_cmd) {
		this.result_cmd = result_cmd;
	}

	public String getResult_cmd_paper() {
		return result_cmd_paper;
	}

	public void setResult_cmd_paper(String result_cmd_paper) {
		this.result_cmd_paper = result_cmd_paper;
	}

	public String getSpecial_sign() {
		return special_sign;
	}

	public void setSpecial_sign(String special_sign) {
		this.special_sign = special_sign;
	}

	public boolean getIs_commit() {
		return is_commit;
	}

	public void setIs_commit(boolean is_commit) {
		this.is_commit = is_commit;
	}

	public String getSamp_stat() {
		return samp_stat;
	}

	public void setSamp_stat(String samp_stat) {
		this.samp_stat = samp_stat;
	}

	public String getSamp_video() {
		return samp_video;
	}

	public void setSamp_video(String samp_video) {
		this.samp_video = samp_video;
	}

	public String getSamp_notice_video() {
		return samp_notice_video;
	}

	public void setSamp_notice_video(String samp_notice_video) {
		this.samp_notice_video = samp_notice_video;
	}

	public String getResult_cmd_paper_video() {
		return result_cmd_paper_video;
	}

	public void setResult_cmd_paper_video(String result_cmd_paper_video) {
		this.result_cmd_paper_video = result_cmd_paper_video;
	}

	public String getProc_type() {
		return proc_type;
	}

	public void setProc_type(String proc_type) {
		this.proc_type = proc_type;
	}

}
