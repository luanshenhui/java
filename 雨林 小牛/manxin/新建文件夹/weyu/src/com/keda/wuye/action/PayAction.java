package com.keda.wuye.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import com.keda.wuye.biz.CarportBiz;
import com.keda.wuye.biz.CommunityBiz;
import com.keda.wuye.biz.FeeBiz;
import com.keda.wuye.biz.HousesBiz;
import com.keda.wuye.biz.PayBiz;
import com.keda.wuye.biz.impl.CarportBizImpl;
import com.keda.wuye.biz.impl.CommunityBizImpl;
import com.keda.wuye.biz.impl.FeeBizImpl;
import com.keda.wuye.biz.impl.HousesBizImpl;
import com.keda.wuye.biz.impl.PayBizImpl;
import com.keda.wuye.entity.Carport;
import com.keda.wuye.entity.Community;
import com.keda.wuye.entity.Fee;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Pay;
import com.opensymphony.xwork2.ActionSupport;

public class PayAction extends ActionSupport{
	private String pay_id;			//�ɷѱ��
	private String pay_resid;		//ҵ�����
	private String pay_feeid;		//���ñ�ţ����ࣩ
	private double pay_number;		//֧����Ŀ
	private String pay_date;		//֧��ʱ��
	private double pay_overdue;		//Ƿ����Ŀ
	private String path;
	private String s;
	private List<Pay> getdata;
	
	//��ȡ����?
	public String getPay()
	{
		PayBiz payBiz = new PayBizImpl();
		getdata = payBiz.getPay();
		path = "pay_ui.jsp";
		return SUCCESS;		
	}
	//��ȡ����?
	public String selectlike()
	{
		try {
			s=URLDecoder.decode(URLEncoder.encode(s, "iso-8859-1"),"utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		PayBiz payBiz = new PayBizImpl();
		getdata = payBiz.select(s);
		path = "pay_ui.jsp";
		return SUCCESS;		
	}
	//��ȡ�����Ϣ
	private List<String> resiIdList = new ArrayList<String>();
	
	private List<String> feeIdList = new ArrayList<String>();
	
	public List<String> getFeeIdList() {
		return feeIdList;
	}
	public void setFeeIdList(List<String> feeIdList) {
		this.feeIdList = feeIdList;
	}
	public List<String> getResiIdList() {
		return resiIdList;
	}
	public void setResiIdList(List<String> resiIdList) {
		this.resiIdList = resiIdList;
	}
	//��ȡס�����
	public String getresiid()
	{
		PayBiz payBiz = new PayBizImpl();
		resiIdList = payBiz.get_resiid();
		feeIdList = payBiz.get_feeid();
		path="pay.jsp";
		return SUCCESS;		
	}
	
	
	//��ʾ
	public String notice() throws IOException
	{
		HttpServletResponse resp = ServletActionContext.getResponse();
		resp.setHeader("pragma", "no-cache");
		resp.setHeader("cache-control", "no-cache");
		PrintWriter out = resp.getWriter();
		PayBiz payBiz = new PayBizImpl();
		//���com_id�ظ�
		if(payBiz.idEqual(pay_id)==true)
		{
			//������ʾҳ��
			out.println(1);
		}
		else
		{
			out.println(0);
		}
		out.flush();
		return NONE;
	}
	//���
	public String insertPay()
	{
		
		PayBiz payBiz = new PayBizImpl();
		payBiz.insertPay(pay_id, pay_resid, pay_feeid, pay_number, pay_date, pay_overdue);
		path = "pay_getPay";
		return SUCCESS;		
	}
	
	//ɾ����Ϣ
	private String checkbox[];
	
	public String[] getCheckbox() {
		return checkbox;
	}

	public void setCheckbox(String[] checkbox) {
		this.checkbox = checkbox;
	}
	
	public String deletePay()
	{	
		PayBiz payBiz = new PayBizImpl();
		for(int i=0;i<checkbox.length;i++)
		{
			payBiz.deletePay(checkbox[i]);
		}
		path = "pay_getPay";
		return SUCCESS;	
	}
	//��ѯһ����Ϣ
	public String select()
	{
		PayBiz payBiz = new PayBizImpl();
		Pay pay = new Pay();
		resiIdList = payBiz.get_resiid();
		feeIdList = payBiz.get_feeid();
		pay = payBiz.getPay(pay_id);
		if(null==pay)
		{
			return INPUT;
		}
	
		pay_id = pay.getPay_id();
		pay_resid = pay.getPay_resid();
		pay_feeid = pay.getPay_feeid();
		pay_number = pay.getPay_number();
		pay_date = pay.getPay_date();
		pay_overdue = pay.getPay_overdue();
		resiIdList.remove(pay_resid);
		resiIdList.add(0, pay_resid);
		feeIdList.remove(pay_feeid);
		feeIdList.add(0, pay_feeid);
		path = "pay_edit.jsp";
		return SUCCESS;	
	}
	
	//�޸���Ϣ
	public String update()
	{
		PayBiz payBiz = new PayBizImpl();
		payBiz.updatePay(pay_id, pay_resid, pay_feeid, pay_number, pay_date, pay_overdue);
		path = "pay_getPay";
		return SUCCESS;		
	}
	
	
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
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public List<Pay> getGetdata() {
		return getdata;
	}
	public void setGetdata(List<Pay> getdata) {
		this.getdata = getdata;
	}
	public String getS() {
		return s;
	}
	public void setS(String s) {
		this.s = s;
	}
	
	
}
