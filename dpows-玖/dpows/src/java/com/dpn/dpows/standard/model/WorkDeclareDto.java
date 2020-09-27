package com.dpn.dpows.standard.model;import java.util.List;

/*** WorkDeclareDtoDto.*
* @author zhaoqian@dpn.com.cn
* @since 1.0.0 zhaoqian@dpn.com.cn
* @version 1.0.0 zhaoqian@dpn.com.cn
* Created by ZhaoQian on 2017-9-6 14:27:26
**/
public class WorkDeclareDto {
						// 字段              字段名         字段类型         是否可为空	private String id;//申报ID  VARCHAR2(32)  N	private String declare_no;//申报单号  VARCHAR2(32)  Y	private String manager_user_id;//初始审批人用户ID  VARCHAR2(32)  Y	private String current_user_id;//当前审批人用户ID  VARCHAR2(32)  Y
	private String verify_opinion;//审批意见  VARCHAR2(2048)  Y
	private String verify_status;//审批状态  NUMBER(22)  Y
			//接口参数	private String managerUserId;//	private String currentUserId;//	private String verifyStatus;//	private String verifyOpinion;//		private List<WorkDeclareGoodsDto> goods;			public WorkDeclareDto(){}					public List<WorkDeclareGoodsDto> getGoods() {		return goods;	}	public void setGoods(List<WorkDeclareGoodsDto> goods) {		this.goods = goods;	}	public String getId() {		return id;	}	public void setId(String id) {		this.id = id;	}	public String getDeclare_no() {		return declare_no;	}	public void setDeclare_no(String declare_no) {		this.declare_no = declare_no;	}	public String getManager_user_id() {		return manager_user_id;	}	public void setManager_user_id(String manager_user_id) {		this.manager_user_id = manager_user_id;	}	public String getCurrent_user_id() {		return current_user_id;	}	public void setCurrent_user_id(String current_user_id) {		this.current_user_id = current_user_id;	}	public String getVerify_opinion() {		return verify_opinion;	}	public void setVerify_opinion(String verify_opinion) {		this.verify_opinion = verify_opinion;	}	public String getVerify_status() {		return verify_status;	}	public void setVerify_status(String verify_status) {		this.verify_status = verify_status;	}	public String getManagerUserId() {		return managerUserId;	}	public void setManagerUserId(String managerUserId) {		this.managerUserId = managerUserId;		this.manager_user_id = managerUserId;	}	public String getCurrentUserId() {		return currentUserId;	}	public void setCurrentUserId(String currentUserId) {		this.currentUserId = currentUserId;		this.current_user_id = currentUserId;	}	public String getVerifyStatus() {		return verifyStatus;	}	public void setVerifyStatus(String verifyStatus) {		this.verifyStatus = verifyStatus;		this.verify_status = verifyStatus;	}	public String getVerifyOpinion() {		return verifyOpinion;	}	public void setVerifyOpinion(String verifyOpinion) {		this.verifyOpinion = verifyOpinion;		this.verify_opinion = verifyOpinion;	}			
}
