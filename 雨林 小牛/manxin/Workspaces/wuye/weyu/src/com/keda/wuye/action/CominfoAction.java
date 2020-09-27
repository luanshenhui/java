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


import com.keda.wuye.biz.CominfoBiz;
import com.keda.wuye.biz.HousesBiz;
import com.keda.wuye.biz.RoomsBiz;
import com.keda.wuye.biz.impl.CominfoBizImpl;
import com.keda.wuye.biz.impl.HousesBizImpl;
import com.keda.wuye.biz.impl.RoomsBizImpl;
import com.keda.wuye.entity.Cominfo;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Rooms;
import com.opensymphony.xwork2.ActionSupport;

public class CominfoAction extends ActionSupport{
	private String cominfo_id;		//С����
	private String cominfo_bus;		//�ܱ߹���
	private String cominfo_medical;	//�ܱ�ҽ��
	private String cominfo_news;	//С������
	private String cominfo_weather;	//����Ԥ��
	private String cominfo_notice;	//С���
	private String path;
	private String s;
	private List<Cominfo> getdata;
	
	//��ȡ����?
	public String getCominfo()
	{
		CominfoBiz cominfoBiz = new CominfoBizImpl();
		getdata = cominfoBiz.getCominfo();
		path = "cominfo_ui.jsp";
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

		CominfoBiz cominfoBiz = new CominfoBizImpl();
		getdata = cominfoBiz.select(s);
		path = "cominfo_ui.jsp";
		return SUCCESS;		
	}
	
	//���
	public String insertCominfo()
	{
		CominfoBiz cominfoBiz = new CominfoBizImpl();
		try {
			cominfo_bus=URLDecoder.decode(URLEncoder.encode(cominfo_bus, "iso-8859-1"),"utf8");
			cominfo_medical=URLDecoder.decode(URLEncoder.encode(cominfo_medical, "iso-8859-1"),"utf8");
			cominfo_news=URLDecoder.decode(URLEncoder.encode(cominfo_news, "iso-8859-1"),"utf8");
			cominfo_weather=URLDecoder.decode(URLEncoder.encode(cominfo_weather, "iso-8859-1"),"utf8");
			cominfo_notice=URLDecoder.decode(URLEncoder.encode(cominfo_notice, "iso-8859-1"),"utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		cominfoBiz.insertCominfo(cominfo_id, cominfo_bus, cominfo_medical, cominfo_news, cominfo_weather, cominfo_notice);
		path = "comi_getCominfo";
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
		CominfoBiz cominfoBiz = new CominfoBizImpl();
		comIdList = cominfoBiz.get_comid();
		path="cominfo.jsp";
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
	
	public String deleteCominfo()
	{	
		CominfoBiz cominfoBiz = new CominfoBizImpl();
		for(int i=0;i<checkbox.length;i++)
		{
			cominfoBiz.deleteCominfo(checkbox[i]);
		}
		path = "comi_getCominfo";
		return SUCCESS;	
	}

	//�޸���Ϣ
	public String update()
	{
		try {
			cominfo_bus=URLDecoder.decode(URLEncoder.encode(cominfo_bus, "iso-8859-1"),"utf8");
			cominfo_medical=URLDecoder.decode(URLEncoder.encode(cominfo_medical, "iso-8859-1"),"utf8");
			cominfo_news=URLDecoder.decode(URLEncoder.encode(cominfo_news, "iso-8859-1"),"utf8");
			cominfo_weather=URLDecoder.decode(URLEncoder.encode(cominfo_weather, "iso-8859-1"),"utf8");
			cominfo_notice=URLDecoder.decode(URLEncoder.encode(cominfo_notice, "iso-8859-1"),"utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		CominfoBiz cominfoBiz = new CominfoBizImpl();
		cominfoBiz.updateCominfo(cominfo_id, cominfo_bus, cominfo_medical, cominfo_news, cominfo_weather, cominfo_notice);
		path = "comi_getCominfo";
		return SUCCESS;		
	}
	
	//��ѯһ����Ϣ
	public String select()
	{
		CominfoBiz cominfoBiz = new CominfoBizImpl();
		Cominfo cominfo = new Cominfo();
		cominfo = cominfoBiz.getCominfo(cominfo_id);
		if(null==cominfo)
		{
			return INPUT;
		}
		cominfo_id = cominfo.getCominfo_id();
		cominfo_bus = cominfo.getCominfo_bus();
		cominfo_medical = cominfo.getCominfo_medical();
		cominfo_news = cominfo.getCominfo_news();
		cominfo_weather = cominfo.getCominfo_weather();
		cominfo_notice = cominfo.getCominfo_notice();	
		path = "cominfo_edit.jsp";
		return SUCCESS;	
	}
	

	public String getCominfo_id() {
		return cominfo_id;
	}

	public void setCominfo_id(String cominfo_id) {
		this.cominfo_id = cominfo_id;
	}

	public String getCominfo_bus() {
		return cominfo_bus;
	}

	public void setCominfo_bus(String cominfo_bus) {
		this.cominfo_bus = cominfo_bus;
	}

	public String getCominfo_medical() {
		return cominfo_medical;
	}

	public void setCominfo_medical(String cominfo_medical) {
		this.cominfo_medical = cominfo_medical;
	}

	public String getCominfo_news() {
		return cominfo_news;
	}

	public void setCominfo_news(String cominfo_news) {
		this.cominfo_news = cominfo_news;
	}

	public String getCominfo_weather() {
		return cominfo_weather;
	}

	public void setCominfo_weather(String cominfo_weather) {
		this.cominfo_weather = cominfo_weather;
	}

	public String getCominfo_notice() {
		return cominfo_notice;
	}

	public void setCominfo_notice(String cominfo_notice) {
		this.cominfo_notice = cominfo_notice;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public List<Cominfo> getGetdata() {
		return getdata;
	}

	public void setGetdata(List<Cominfo> getdata) {
		this.getdata = getdata;
	}

	public String getS() {
		return s;
	}

	public void setS(String s) {
		this.s = s;
	}
	

	
	
	
}
