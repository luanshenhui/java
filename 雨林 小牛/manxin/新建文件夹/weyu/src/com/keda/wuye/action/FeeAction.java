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


import com.keda.wuye.biz.FeeBiz;
import com.keda.wuye.biz.HousesBiz;
import com.keda.wuye.biz.RoomsBiz;
import com.keda.wuye.biz.impl.FeeBizImpl;
import com.keda.wuye.biz.impl.HousesBizImpl;
import com.keda.wuye.biz.impl.RoomsBizImpl;
import com.keda.wuye.entity.Fee;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Rooms;
import com.opensymphony.xwork2.ActionSupport;

public class FeeAction extends ActionSupport{
	private String fee_id;			//���ñ��
	private String fee_comid;		//����С���
	private String fee_name;		//������
	private double fee_standard;	//���ñ�׼
	private String fee_date;		//��׼����ʱ��
	private String path;
	private String s;
	private List<Fee> getdata;
	
	//��ȡ����?
	public String getFee()
	{
		FeeBiz feeBiz = new FeeBizImpl();
		getdata = feeBiz.getFee();
		path = "fee_ui.jsp";
		return SUCCESS;		
	}
	//ģ���ѯ
	public String selectlike()
	{
		try {
			s=URLDecoder.decode(URLEncoder.encode(s, "ISO-8859-1"), "UTF8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}	
		FeeBiz feeBiz = new FeeBizImpl();
		getdata = feeBiz.select(s);
		path = "fee_ui.jsp";
		return SUCCESS;		
	}
	//���
	public String insertFee()
	{
		try {
			fee_name=URLDecoder.decode(URLEncoder.encode(fee_name, "ISO-8859-1"), "UTF8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		FeeBiz feeBiz = new FeeBizImpl();
		feeBiz.insertFee(fee_id, fee_comid, fee_name, fee_standard, fee_date);
		path = "fee_getFee";
		return SUCCESS;		
	}

	//��ȡ�����Ϣ
	private List<String> comIdList = new ArrayList<String>();
	
	public List<String> getComIdList() {
		return comIdList;
	}
	public void setComIdList(List<String> comIdList) {
		this.comIdList = comIdList;
	}
	public String getcomid()
	{
		FeeBiz feeBiz = new FeeBizImpl();
		comIdList = feeBiz.get_comid();
		path="fee.jsp";
		return SUCCESS;		
	}
	
	//��ʾ
	public String notice() throws IOException
	{
		HttpServletResponse resp = ServletActionContext.getResponse();
		resp.setHeader("pragma", "no-cache");
		resp.setHeader("cache-control", "no-cache");
		PrintWriter out = resp.getWriter();
		FeeBiz feeBiz = new FeeBizImpl();
		//���com_id�ظ�
		System.out.println(feeBiz.idEqual(fee_id));
		if(feeBiz.idEqual(fee_id)==true)
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
	
	//ɾ����Ϣ
	private String checkbox[];
	
	public String[] getCheckbox() {
		return checkbox;
	}

	public void setCheckbox(String[] checkbox) {
		this.checkbox = checkbox;
	}
	
	public String deleteFee()
	{	
		FeeBiz feeBiz = new FeeBizImpl();
		for(int i=0;i<checkbox.length;i++)
		{
			feeBiz.deleteFee(checkbox[i]);
		}
		path = "fee_getFee";
		return SUCCESS;	
	}
	

	//�޸���Ϣ
	public String update()
	{
		try {
			fee_name=URLDecoder.decode(URLEncoder.encode(fee_name, "ISO-8859-1"), "UTF8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		FeeBiz feeBiz = new FeeBizImpl();
		feeBiz.updateFee(fee_id, fee_comid, fee_name, fee_standard, fee_date);
		path = "fee_getFee";
		return SUCCESS;		
	}
	
	//��ѯһ����Ϣ
	public String select()
	{
		FeeBiz feeBiz = new FeeBizImpl();
		Fee fee = new Fee();
		comIdList = feeBiz.get_comid();
		fee = feeBiz.getFee(fee_id);
		if(null==fee)
		{
			return INPUT;
		}
	
		fee_id = fee.getFee_id();
		fee_comid = fee.getFee_comid();
		fee_name = fee.getFee_name();
		fee_standard = fee.getFee_standard();
		fee_date = fee.getFee_date();
		comIdList.remove(fee_comid);
		comIdList.add(0, fee_comid);
		path = "fee_edit.jsp";
		return SUCCESS;	
	}
	
	
	
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

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public List<Fee> getGetdata() {
		return getdata;
	}

	public void setGetdata(List<Fee> getdata) {
		this.getdata = getdata;
	}

	public String getS() {
		return s;
	}

	public void setS(String s) {
		this.s = s;
	}
	

	
}
