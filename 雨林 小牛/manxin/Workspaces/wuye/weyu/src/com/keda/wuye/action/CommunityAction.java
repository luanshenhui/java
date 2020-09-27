package com.keda.wuye.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import com.keda.wuye.biz.CommunityBiz;
import com.keda.wuye.biz.impl.CommunityBizImpl;
import com.keda.wuye.entity.Community;
import com.opensymphony.xwork2.ActionSupport;

//��ȡС���嵥����ȡ����ת��resident_ui.jsp����
public class CommunityAction extends ActionSupport{
	private String path;	
	private String com_id;			//С����
	private String com_name;		//С�����
	private String com_date;		//��������
	private String com_principal;	//��Ҫ������
	private double com_area;		//ռ�����
	private double com_buildarea;	//�������
	private String com_location;	//λ��˵��
	private String s;
	private List<Community> getdate;
	
	
	
	//��ȡС����?
	public String getCommunity()
	{
		CommunityBiz communityBiz = new CommunityBizImpl();
		getdate = communityBiz.getCommunityDate();
		path = "community_ui.jsp";
		return SUCCESS;		
	}
	
	//ģ���ѯ
	public String selectlike()
	{
		CommunityBiz communityBiz = new CommunityBizImpl();
		try {
			s=URLDecoder.decode(URLEncoder.encode(s,"iso-8859-1"),"utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		getdate = communityBiz.select(s);
		path = "community_ui.jsp";
		return SUCCESS;		
	}
	
	public String notice() throws IOException
	{
		HttpServletResponse resp = ServletActionContext.getResponse();
		resp.setHeader("pragma", "no-cache");
		resp.setHeader("cache-control", "no-cache");
		PrintWriter out = resp.getWriter();
		CommunityBiz communityBiz = new CommunityBizImpl();
		//���com_id�ظ�
		System.out.println(communityBiz.idEqual(com_id));
		if(communityBiz.idEqual(com_id)==true)
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
	
	
	//�����Ϣ
	public String insertCommunity()
	{
		try {
			String encoder =URLEncoder.encode(com_name, "iso-8859-1");
			com_name=URLDecoder.decode(encoder,"utf8");
			String encoder1 =URLEncoder.encode(com_principal, "iso-8859-1");
			com_principal=URLDecoder.decode(encoder1,"utf8");
			String encoder2 =URLEncoder.encode(com_location, "iso-8859-1");
			com_location=URLDecoder.decode(encoder2,"utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		CommunityBiz communityBiz = new CommunityBizImpl();
		
		communityBiz.insertCommunity(com_id, com_name, com_date, com_principal, com_area, com_buildarea, com_location);
		path = "com_getCommunity";
		return SUCCESS;		
	}

	//�޸���Ϣ
	public String update()
	{
		try {
			String encoder =URLEncoder.encode(com_name, "iso-8859-1");
			com_name=URLDecoder.decode(encoder,"utf8");
			String encoder1 =URLEncoder.encode(com_principal, "iso-8859-1");
			com_principal=URLDecoder.decode(encoder1,"utf8");
			String encoder2 =URLEncoder.encode(com_location, "iso-8859-1");
			com_location=URLDecoder.decode(encoder2,"utf8");
			//com_date=URLDecoder.decode(URLEncoder.encode(com_date,"iso-8859-1"),"utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		CommunityBiz communityBiz = new CommunityBizImpl();
		System.out.println("��ֵ�ɹ�ô?"+com_id+com_name+com_date+com_principal+com_area+com_buildarea+com_location);
		communityBiz.updateCommunity(com_id, com_name, com_date, com_principal, com_area, com_buildarea, com_location);
		path = "com_getCommunity";
		return SUCCESS;		
	}
	
	//��ѯһ����Ϣ
	public String select()
	{
		CommunityBiz communityBiz = new CommunityBizImpl();
		Community community = new Community();
		community = communityBiz.getCommunity(com_id);
		if(null==community)
		{
			return INPUT;
		}
		com_id = community.getCom_id();			//С����
		com_name = community.getCom_name();		//С�����
		com_date = community.getCom_date();		//��������
		com_principal = community.getCom_principal();	//��Ҫ������
		com_area =community.getCom_area();		//ռ�����
		com_buildarea = community.getCom_buildarea();	//�������
		com_location = community.getCom_location();	//λ��˵��
		path = "community_edit.jsp";
		return SUCCESS;	
	}
	
	
	
	
	
	
	
	
	
	
	private String checkbox[];
	
	public String[] getCheckbox() {
		return checkbox;
	}

	public void setCheckbox(String[] checkbox) {
		this.checkbox = checkbox;
	}
	//ɾ����Ϣ
	public String deleteCommunity()
	{	
		CommunityBiz communityBiz = new CommunityBizImpl();
		for(int i=0;i<checkbox.length;i++)
		{
			System.out.println(checkbox[i]);
			communityBiz.deleteCommunity(checkbox[i]);
		}
		path = "com_getCommunity";
		return SUCCESS;	
	}
	
	
	public String getCom_id() {
		return com_id;
	}

	public void setCom_id(String com_id) {
		this.com_id = com_id;
	}

	public String getCom_name() {
		return com_name;
	}

	public void setCom_name(String com_name) {
		this.com_name = com_name;
	}

	public String getCom_date() {
		return com_date;
	}

	public void setCom_date(String com_date) {
		this.com_date = com_date;
	}

	public String getCom_principal() {
		return com_principal;
	}

	public void setCom_principal(String com_principal) {
		this.com_principal = com_principal;
	}

	public double getCom_area() {
		return com_area;
	}

	public void setCom_area(double com_area) {
		this.com_area = com_area;
	}

	public double getCom_buildarea() {
		return com_buildarea;
	}

	public void setCom_buildarea(double com_buildarea) {
		this.com_buildarea = com_buildarea;
	}

	public String getCom_location() {
		return com_location;
	}

	public void setCom_location(String com_location) {
		this.com_location = com_location;
	}
	
	public List<Community> getGetdate() {
		return getdate;
	}

	public void setGetdate(List<Community> getdate) {
		this.getdate = getdate;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public String getS() {
		return s;
	}

	public void setS(String s) {
		this.s = s;
	}
}
