package com.dpn.ciqqlc.standard.model;

import java.util.List;

public class ExpFoodProdPointDto {

//	private String id;// varchar2(36) y 主键id
//	private String apply_no;// varchar2(30) y 申请单号
//	private String deal_psn;// varchar2(30) y 处理人
//	private String deal_org;// varchar2(100) y 处理机构
//	private String deal_point;// varchar2(50) y 处理节点
//	private String deal_dec;// varchar2(50) y 处理决定
//	private String deal_sug;// varchar2(50) y 处理意见
//	private String deal_date;// date y 处理时间
//	private String proj_statu;// varchar2(10) y 处理环节
//	public String getId() {
//		return id;
//	}
//	public void setId(String id) {
//		this.id = id;
//	}
//	public String getApply_no() {
//		return apply_no;
//	}
//	public void setApply_no(String apply_no) {
//		this.apply_no = apply_no;
//	}
//	public String getDeal_psn() {
//		return deal_psn;
//	}
//	public void setDeal_psn(String deal_psn) {
//		this.deal_psn = deal_psn;
//	}
//	public String getDeal_org() {
//		return deal_org;
//	}
//	public void setDeal_org(String deal_org) {
//		this.deal_org = deal_org;
//	}
//	public String getDeal_point() {
//		return deal_point;
//	}
//	public void setDeal_point(String deal_point) {
//		this.deal_point = deal_point;
//	}
//	public String getDeal_dec() {
//		return deal_dec;
//	}
//	public void setDeal_dec(String deal_dec) {
//		this.deal_dec = deal_dec;
//	}
//	public String getDeal_sug() {
//		return deal_sug;
//	}
//	public void setDeal_sug(String deal_sug) {
//		this.deal_sug = deal_sug;
//	}
//	public String getDeal_date() {
//		return deal_date;
//	}
//	public void setDeal_date(String deal_date) {
//		this.deal_date = deal_date;
//	}
//	public String getProj_statu() {
//		return proj_statu;
//	}
//	public void setProj_statu(String proj_statu) {
//		this.proj_statu = proj_statu;
//	}
	
	
	
private String	commentid;
private String	wfnoteid;
private String	activityid;
private String	dualtype;
private String	dualcontent;
private String	createdate;
private String	username;
private String	belongorg;
private String	attid;
private String	atttitle;
private String	applytype;
private String	applynote;
private String	status;
private String	senddate;
private String	sendusername;
	
	public String getActivityid() {
		return activityid;
	}
	public void setActivityid(String activityid) {
		this.activityid = activityid;
	}
	public String getCommentid() {
		return commentid;
	}
	public void setCommentid(String commentid) {
		this.commentid = commentid;
	}
	public String getWfnoteid() {
		return wfnoteid;
	}
	public void setWfnoteid(String wfnoteid) {
		this.wfnoteid = wfnoteid;
	}
	public String getDualtype() {
		return dualtype;
	}
	public void setDualtype(String dualtype) {
		this.dualtype = dualtype;
	}
	public String getDualcontent() {
		return dualcontent;
	}
	public void setDualcontent(String dualcontent) {
		this.dualcontent = dualcontent;
	}

	public String getCreatedate() {
		return createdate;
	}
	public void setCreatedate(String createdate) {
		this.createdate = createdate;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getBelongorg() {
		return belongorg;
	}
	public void setBelongorg(String belongorg) {
		this.belongorg = belongorg;
	}
	public String getAttid() {
		return attid;
	}
	public void setAttid(String attid) {
		this.attid = attid;
	}
	public String getAtttitle() {
		return atttitle;
	}
	public void setAtttitle(String atttitle) {
		this.atttitle = atttitle;
	}
	public String getApplytype() {
		return applytype;
	}
	public void setApplytype(String applytype) {
		this.applytype = applytype;
	}
	public String getApplynote() {
		return applynote;
	}
	public void setApplynote(String applynote) {
		this.applynote = applynote;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getSenddate() {
		return senddate;
	}
	public void setSenddate(String senddate) {
		this.senddate = senddate;
	}
	public String getSendusername() {
		return sendusername;
	}
	public void setSendusername(String sendusername) {
		this.sendusername = sendusername;
	}

	private List<EfpeApplyCommentFileDto> fileList;
	private List<EfpeApplyNoticeDto> mbList;
	public List<EfpeApplyCommentFileDto> getFileList() {
		return fileList;
	}
	public void setFileList(List<EfpeApplyCommentFileDto> fileList) {
		this.fileList = fileList;
	}
	public List<EfpeApplyNoticeDto> getMbList() {
		return mbList;
	}
	public void setMbList(List<EfpeApplyNoticeDto> mbList) {
		this.mbList = mbList;
	}
	
}
