package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class ContaDTO {
	
	private String conta_id	;//		集装箱序号
	private String bill_id	;//			提单编号
	private String bill_no	;//			提单号
	private String conta_no	;//			箱号.对于散货,数据为空
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


}
