package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class ContaEventDTO {
	
	private String event_id	;//编号
	private String conta_id	;//		集装箱序号
	private String bill_id	;//			提单编号
	private String bill_no	;//			提单号
	private String conta_no	;//			箱号.对于散货,数据为空
	private String ship_name_en	;//			英文船名
	private String ship_name_cn	;//			中文船名
	private String voyage_no	;//			航次
	private String op_code	;//			操作代码,派工,yx移箱,xz熏蒸,cy查验,rl放行  tx提箱
	private int fee	;//	0		费用
	private String plan_user;//			计划人
	private String plan_date;//		计划时间
	private String finish_user;//			完成人
	private String finish_date;//			完成时间
	private String plan_desc_1	;//			计划描述1
	private String plan_desc_2	;//			计划描述2
	private String plan_desc_3	;//			计划描述3
	private String feedback_desc_1	;//			反馈描述1
	private String feedback_desc_2	;//			反馈描述2
	private String remark	;//			备注
	private String ref_id	;//			引用
	private String port_org_code	;//			监管口岸局代码
	public String getEvent_id() {
		return event_id;
	}
	public void setEvent_id(String event_id) {
		this.event_id = event_id;
	}
	public String getConta_id() {
		return conta_id;
	}
	public void setConta_id(String conta_id) {
		this.conta_id = conta_id;
	}
	public String getBill_id() {
		return bill_id;
	}
	public void setBill_id(String bill_id) {
		this.bill_id = bill_id;
	}
	public String getBill_no() {
		return bill_no;
	}
	public void setBill_no(String bill_no) {
		this.bill_no = bill_no;
	}
	public String getConta_no() {
		return conta_no;
	}
	public void setConta_no(String conta_no) {
		this.conta_no = conta_no;
	}
	public String getShip_name_en() {
		return ship_name_en;
	}
	public void setShip_name_en(String ship_name_en) {
		this.ship_name_en = ship_name_en;
	}
	public String getShip_name_cn() {
		return ship_name_cn;
	}
	public void setShip_name_cn(String ship_name_cn) {
		this.ship_name_cn = ship_name_cn;
	}
	public String getVoyage_no() {
		return voyage_no;
	}
	public void setVoyage_no(String voyage_no) {
		this.voyage_no = voyage_no;
	}
	public String getOp_code() {
		return op_code;
	}
	public void setOp_code(String op_code) {
		this.op_code = op_code;
	}
	public int getFee() {
		return fee;
	}
	public void setFee(int fee) {
		this.fee = fee;
	}
	public String getPlan_user() {
		return plan_user;
	}
	public void setPlan_user(String plan_user) {
		this.plan_user = plan_user;
	}
	
	public String getPlan_date() {
		return plan_date;
	}
	public void setPlan_date(String plan_date) {
		this.plan_date = plan_date;
	}
	public String getFinish_user() {
		return finish_user;
	}
	public void setFinish_user(String finish_user) {
		this.finish_user = finish_user;
	}
	public String getFinish_date() {
		return finish_date;
	}
	public void setFinish_date(String finish_date) {
		this.finish_date = finish_date;
	}
	public String getPlan_desc_1() {
		return plan_desc_1;
	}
	public void setPlan_desc_1(String plan_desc_1) {
		this.plan_desc_1 = plan_desc_1;
	}
	public String getPlan_desc_2() {
		return plan_desc_2;
	}
	public void setPlan_desc_2(String plan_desc_2) {
		this.plan_desc_2 = plan_desc_2;
	}
	public String getPlan_desc_3() {
		return plan_desc_3;
	}
	public void setPlan_desc_3(String plan_desc_3) {
		this.plan_desc_3 = plan_desc_3;
	}
	public String getFeedback_desc_1() {
		return feedback_desc_1;
	}
	public void setFeedback_desc_1(String feedback_desc_1) {
		this.feedback_desc_1 = feedback_desc_1;
	}
	public String getFeedback_desc_2() {
		return feedback_desc_2;
	}
	public void setFeedback_desc_2(String feedback_desc_2) {
		this.feedback_desc_2 = feedback_desc_2;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getRef_id() {
		return ref_id;
	}
	public void setRef_id(String ref_id) {
		this.ref_id = ref_id;
	}
	public String getPort_org_code() {
		return port_org_code;
	}
	public void setPort_org_code(String port_org_code) {
		this.port_org_code = port_org_code;
	}


}
