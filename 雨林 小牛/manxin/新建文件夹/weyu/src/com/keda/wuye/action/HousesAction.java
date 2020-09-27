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

import com.keda.wuye.biz.CommunityBiz;
import com.keda.wuye.biz.HousesBiz;
import com.keda.wuye.biz.impl.CommunityBizImpl;
import com.keda.wuye.biz.impl.HousesBizImpl;
import com.keda.wuye.entity.Community;
import com.keda.wuye.entity.Houses;
import com.opensymphony.xwork2.ActionSupport;

public class HousesAction extends ActionSupport{
	private String houses_id;		//¥�̱��
	private String houses_comid;		//С����
	private String houses_date;		//��������
	private int houses_floor;		//¥�̲���
	private double houses_area;		//¥�����
	private String houses_face;		//¥�̷���
	private String houses_type;		//¥������
	private String path;
	private String s;
	private List<Houses> getdata;
	
	
	public List<Houses> getGetdata() {
		return getdata;
	}
	public void setGetdata(List<Houses> getdata) {
		this.getdata = getdata;
	}
	//��ȡС����?
	public String getHouses()
	{
		HousesBiz housesBiz = new HousesBizImpl();
		getdata = housesBiz.getHouses();
		for(int i=0;i<getdata.size();i++)
		{
			System.out.println(getdata.get(i).getHouses_id());
		}
		path = "houses_ui.jsp";
		return SUCCESS;			
	}
	
	//��ȡС����?
	public String selectlike()
	{
		try {
			s=URLDecoder.decode(URLEncoder.encode(s, "iso-8859-1"),"utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		HousesBiz housesBiz = new HousesBizImpl();
		getdata = housesBiz.select(s);
		path = "houses_ui.jsp";
		return SUCCESS;			
	}
	//��ʾ
	public String notice() throws IOException
	{
		HttpServletResponse resp = ServletActionContext.getResponse();
		resp.setHeader("pragma", "no-cache");
		resp.setHeader("cache-control", "no-cache");
		PrintWriter out = resp.getWriter();
		HousesBiz housesBiz = new HousesBizImpl();
		//���com_id�ظ�
		if(housesBiz.idEqual(houses_id)==true)
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
			houses_comid=URLDecoder.decode(URLEncoder.encode(houses_comid, "iso-8859-1"), "utf8");
			houses_face=URLDecoder.decode(URLEncoder.encode(houses_face, "iso-8859-1"), "utf8");
			houses_type=URLDecoder.decode(URLEncoder.encode(houses_type, "iso-8859-1"), "utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		HousesBiz housesBiz = new HousesBizImpl();
		housesBiz.updateHouses(houses_id, houses_comid, houses_date, houses_floor, houses_area, houses_face, houses_type);
		path = "house_getHouses";
		return SUCCESS;		
	}
	
	//��ѯһ����Ϣ
	public String select()
	{
		HousesBiz housesBiz = new HousesBizImpl();
		Houses houses = new Houses();
		houses = housesBiz.getHouses(houses_id);
		comIdList = housesBiz.get_comid();
		if(null==houses)
		{
			return INPUT;
		}
		houses_id = houses.getHouses_id();
		houses_comid = houses.getHouses_comid();
		houses_date = houses.getHouses_date();
		houses_floor = houses.getHouses_floor();
		houses_area = houses.getHouses_area();
		houses_face = houses.getHouses_face();
		houses_type = houses.getHouses_type();
		comIdList.remove(houses_comid);
		comIdList.add(0, houses_comid);
		path = "house_edit.jsp";
		return SUCCESS;	
	}
	
	
	
	//���
	public String insertHouses()
	{
		try {
			houses_comid=URLDecoder.decode(URLEncoder.encode(houses_comid, "iso-8859-1"), "utf8");
			houses_face=URLDecoder.decode(URLEncoder.encode(houses_face, "iso-8859-1"), "utf8");
			houses_type=URLDecoder.decode(URLEncoder.encode(houses_type, "iso-8859-1"), "utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		HousesBiz housesBiz = new HousesBizImpl();
		housesBiz.insertHouses(houses_id,houses_comid,houses_date, houses_floor, houses_area, houses_face, houses_type);
		path = "house_getHouses";
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
		HousesBiz housesBiz = new HousesBizImpl();
		comIdList = housesBiz.get_comid();
		path="houses.jsp";
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
	
	public String deleteHouses()
	{	
		HousesBiz housesBiz = new HousesBizImpl();
		for(int i=0;i<checkbox.length;i++)
		{
			housesBiz.deleteHouses(checkbox[i]);
		}
		path = "house_getHouses";
		return SUCCESS;	
	}
	
	public String getHouses_id() {
		return houses_id;
	}
	public void setHouses_id(String houses_id) {
		this.houses_id = houses_id;
	}
	public String getHouses_comid() {
		return houses_comid;
	}
	public void setHouses_comid(String houses_comid) {
		this.houses_comid = houses_comid;
	}
	public String getHouses_date() {
		return houses_date;
	}
	public void setHouses_date(String houses_date) {
		this.houses_date = houses_date;
	}
	public int getHouses_floor() {
		return houses_floor;
	}
	public void setHouses_floor(int houses_floor) {
		this.houses_floor = houses_floor;
	}
	public double getHouses_area() {
		return houses_area;
	}
	public void setHouses_area(double houses_area) {
		this.houses_area = houses_area;
	}
	public String getHouses_face() {
		return houses_face;
	}
	public void setHouses_face(String houses_face) {
		this.houses_face = houses_face;
	}
	public String getHouses_type() {
		return houses_type;
	}
	public void setHouses_type(String houses_type) {
		this.houses_type = houses_type;
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
