package com.keda.wuye.entity;

public class Fee {
	private String fee_id;			//费用编号
	private String fee_comid;		//费用小区号
	private String fee_name;		//费用名
	private double fee_standard;	//费用标准
	private String fee_date;		//标准更新时间
	public String getFee_id() {
		return fee_id;
	}
	public void setFee_id(String fee_id) {
		this.fee_id = fee_id;
	}
	public String getFee_comid() {
		return fee_comid;
	}
	public void setFee_comid(String fee_comid) {
		this.fee_comid = fee_comid;
	}
	public String getFee_name() {
		return fee_name;
	}
	public void setFee_name(String fee_name) {
		this.fee_name = fee_name;
	}
	public double getFee_standard() {
		return fee_standard;
	}
	public void setFee_standard(double fee_standard) {
		this.fee_standard = fee_standard;
	}
	public String getFee_date() {
		return fee_date;
	}
	public void setFee_date(String fee_date) {
		this.fee_date = fee_date;
	}
}
