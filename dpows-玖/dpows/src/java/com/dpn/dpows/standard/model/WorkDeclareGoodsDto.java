package com.dpn.dpows.standard.model;
/**
* WorkDeclareGoodsDtoDto.
*
* @author zhaoqian@dpn.com.cn
* @since 1.0.0 zhaoqian@dpn.com.cn
* @version 1.0.0 zhaoqian@dpn.com.cn
* Created by ZhaoQian on 2017-9-6 14:27:26
**/public class WorkDeclareGoodsDto {
						// 字段              字段名         字段类型         是否可为空
	private String id;//申报货物ID  VARCHAR2(32)  N	private String status;//审核状态  NUMBER(22)  Y	private String verify_user_id;//审批人用户ID	VERIFY_USER_ID	VARCHAR2(32)	verifyUserId	private String verify_opinion;//审批意见	VERIFY_OPINION	VARCHAR2(2048)	verifyOpinion	//接口参数	private String declareGoodsId;	//private String status;	private String verifyUserId;	private String verifyOpinion;		public WorkDeclareGoodsDto(){}	public String getDeclareGoodsId() {		return declareGoodsId;	}	public void setDeclareGoodsId(String declareGoodsId) {		this.declareGoodsId = declareGoodsId;		this.id = declareGoodsId;	}	public String getStatus() {		return status;	}	public void setStatus(String status) {		this.status = status;	}	public String getVerifyUserId() {		return verifyUserId;	}	public void setVerifyUserId(String verifyUserId) {		this.verifyUserId = verifyUserId;		this.verify_user_id = verifyUserId;	}	public String getVerifyOpinion() {		return verifyOpinion;	}	public void setVerifyOpinion(String verifyOpinion) {		this.verifyOpinion = verifyOpinion;		this.verify_opinion = verifyOpinion;	}	public String getId() {		return id;	}	public void setId(String id) {		this.id = id;	}	public String getVerify_user_id() {		return verify_user_id;	}	public void setVerify_user_id(String verify_user_id) {		this.verify_user_id = verify_user_id;	}	public String getVerify_opinion() {		return verify_opinion;	}	public void setVerify_opinion(String verify_opinion) {		this.verify_opinion = verify_opinion;	}	
	
}
