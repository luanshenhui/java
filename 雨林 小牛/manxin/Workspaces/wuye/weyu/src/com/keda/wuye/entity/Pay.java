package com.keda.wuye.entity;

public class Pay {
	private String pay_id;			//�ɷѱ��
	private String pay_resid;		//ҵ�����
	private String pay_feeid;		//���ñ�ţ����ࣩ
	private double pay_number;		//֧����Ŀ
	private String pay_date;		//֧��ʱ��
	private double pay_overdue;		//Ƿ����Ŀ
	public String getPay_id() {
		return pay_id;
	}
	public void setPay_id(String pay_id) {
		this.pay_id = pay_id;
	}
	public String getPay_resid() {
		return pay_resid;
	}
	public void setPay_resid(String pay_resid) {
		this.pay_resid = pay_resid;
	}
	public String getPay_feeid() {
		return pay_feeid;
	}
	public void setPay_feeid(String pay_feeid) {
		this.pay_feeid = pay_feeid;
	}
	public double getPay_number() {
		return pay_number;
	}
	public void setPay_number(double pay_number) {
		this.pay_number = pay_number;
	}
	public String getPay_date() {
		return pay_date;
	}
	public void setPay_date(String pay_date) {
		this.pay_date = pay_date;
	}
	public double getPay_overdue() {
		return pay_overdue;
	}
	public void setPay_overdue(double pay_overdue) {
		this.pay_overdue = pay_overdue;
	}
}
