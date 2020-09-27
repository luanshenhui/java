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


import com.keda.wuye.biz.HousesBiz;
import com.keda.wuye.biz.ResidentBiz;
import com.keda.wuye.biz.RoomsBiz;
import com.keda.wuye.biz.impl.HousesBizImpl;
import com.keda.wuye.biz.impl.ResidentBizImpl;
import com.keda.wuye.biz.impl.RoomsBizImpl;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Resident;
import com.keda.wuye.entity.Rooms;
import com.opensymphony.xwork2.ActionSupport;

public class ResidentAction extends ActionSupport{
	private String resident_id;			//ҵ�����
	private String resident_roomsid;	//����
	private String resident_name;		//ҵ������
	private String resident_phone;		//ҵ���绰
	private String resident_unit;		//ҵ����λ
	private String resident_sex;		//ҵ���Ա�
	private String path;
	private String s;
	private List<Resident> getdata;
	//��ȡס���?
	public String getResident()
	{
		ResidentBiz residentBiz = new ResidentBizImpl();
		getdata = residentBiz.getResident();
		path = "resident_ui.jsp";
		return SUCCESS;		
	}
	//��ȡס���?
	public String selectlike()
	{
		try {
			s=URLDecoder.decode(URLEncoder.encode(s, "iso-8859-1"), "utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		ResidentBiz residentBiz = new ResidentBizImpl();
		getdata = residentBiz.select(s);
		path = "resident_ui.jsp";
		return SUCCESS;		
	}

	//���
	public String insertResident()
	{
		try {
			resident_name=URLDecoder.decode(URLEncoder.encode(resident_name, "iso-8859-1"), "utf8");
			resident_sex=URLDecoder.decode(URLEncoder.encode(resident_sex, "iso-8859-1"), "utf8");
			resident_unit=URLDecoder.decode(URLEncoder.encode(resident_unit, "iso-8859-1"), "utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		ResidentBiz residentBiz = new ResidentBizImpl();
		residentBiz.insertResident(resident_id, resident_name, resident_phone, resident_roomsid, resident_sex, resident_unit);
		path = "resi_getResident";
		return SUCCESS;		
	}
	//��ȡ�����Ϣ
	private List<String> residentIdList = new ArrayList<String>();
	
	public List<String> getResidentIdList() {
		return residentIdList;
	}

	public void setResidentIdList(List<String> residentIdList) {
		this.residentIdList = residentIdList;
	}

	public String getroomid()
	{
		ResidentBiz residentBiz = new ResidentBizImpl();
		residentIdList = residentBiz.get_roomid();
		path="resident.jsp";
		return SUCCESS;		
	}
	
	//��ʾ
	public String notice() throws IOException
	{
		HttpServletResponse resp = ServletActionContext.getResponse();
		resp.setHeader("pragma", "no-cache");
		resp.setHeader("cache-control", "no-cache");
		PrintWriter out = resp.getWriter();
		ResidentBiz residentBiz = new ResidentBizImpl();
		//���id�ظ�
		if(residentBiz.idEqual(resident_id)==true)
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
	
	//�޸���Ϣ
	public String update()
	{
		try {
			resident_name=URLDecoder.decode(URLEncoder.encode(resident_name, "iso-8859-1"), "utf8");
			resident_sex=URLDecoder.decode(URLEncoder.encode(resident_sex, "iso-8859-1"), "utf8");
			resident_unit=URLDecoder.decode(URLEncoder.encode(resident_unit, "iso-8859-1"), "utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		ResidentBiz residentBiz = new ResidentBizImpl();
		residentBiz.updateResident(resident_id, resident_name, resident_phone, resident_roomsid, resident_sex, resident_unit);
		path = "resi_getResident";
		return SUCCESS;		
	}
	
	//��ѯһ����Ϣ
	public String select()
	{
		ResidentBiz residentBiz = new ResidentBizImpl();
		Resident resident = new Resident();
		residentIdList = residentBiz.get_roomid();
		resident = residentBiz.getResident(resident_id);
		
		if(null==resident)
		{
			return INPUT;
		}
		resident_id = resident.getResident_id();
		resident_name = resident.getResident_name();
		resident_phone = resident.getResident_phone();
		resident_roomsid = resident.getResident_roomsid();
		resident_sex = resident.getResident_sex();
		resident_unit = resident.getResident_unit();
		residentIdList.remove(resident_roomsid);
		residentIdList.add(0, resident_roomsid);	
		path = "resident_edit.jsp";
		return SUCCESS;	
	}
	//ɾ��
	//��ѡ��
	private String checkbox[];
	
	public String[] getCheckbox() {
		return checkbox;
	}

	public void setCheckbox(String[] checkbox) {
		this.checkbox = checkbox;
	}
	
	public String deleteResident()
	{	
		ResidentBiz residentBiz = new ResidentBizImpl();
		for(int i=0;i<checkbox.length;i++)
		{
			residentBiz.deleteResident(checkbox[i]);
		}
		path = "resi_getResident";
		return SUCCESS;	
	}
	
	
	
	public String getResident_id() {
		return resident_id;
	}
	public void setResident_id(String resident_id) {
		this.resident_id = resident_id;
	}
	public String getResident_roomsid() {
		return resident_roomsid;
	}
	public void setResident_roomsid(String resident_roomsid) {
		this.resident_roomsid = resident_roomsid;
	}
	public String getResident_name() {
		return resident_name;
	}
	public void setResident_name(String resident_name) {
		this.resident_name = resident_name;
	}
	public String getResident_phone() {
		return resident_phone;
	}
	public void setResident_phone(String resident_phone) {
		this.resident_phone = resident_phone;
	}
	public String getResident_unit() {
		return resident_unit;
	}
	public void setResident_unit(String resident_unit) {
		this.resident_unit = resident_unit;
	}
	public String getResident_sex() {
		return resident_sex;
	}
	public void setResident_sex(String resident_sex) {
		this.resident_sex = resident_sex;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}





	public List<Resident> getGetdata() {
		return getdata;
	}





	public void setGetdata(List<Resident> getdata) {
		this.getdata = getdata;
	}

	public String getS() {
		return s;
	}

	public void setS(String s) {
		this.s = s;
	}
	
}
