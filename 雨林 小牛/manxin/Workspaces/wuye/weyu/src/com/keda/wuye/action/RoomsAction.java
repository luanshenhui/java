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
import com.keda.wuye.biz.RoomsBiz;
import com.keda.wuye.biz.impl.HousesBizImpl;
import com.keda.wuye.biz.impl.RoomsBizImpl;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Rooms;
import com.opensymphony.xwork2.ActionSupport;

public class RoomsAction extends ActionSupport{
	private String rooms_id;			//�����
	private String rooms_housesid;		//����¥�̺�
	private String rooms_type;			//����
	private double rooms_area;			//���佨�����
	private double rooms_usearea;		//�������
	private String path;
	private String s;
	private List<Rooms> getdata;
	
	//��ȡ����?
	public String getRooms()
	{
		RoomsBiz roomsBiz = new RoomsBizImpl();
		getdata = roomsBiz.getRooms();
		path = "rooms_ui.jsp";
		return SUCCESS;		
	}
	//��ȡ����?
	public String selectlike()
	{
		try {
			s=URLDecoder.decode(URLEncoder.encode(s, "iso-8859-1"), "utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		RoomsBiz roomsBiz = new RoomsBizImpl();
		getdata = roomsBiz.select(s);
		path = "rooms_ui.jsp";
		return SUCCESS;		
	}

	//���
	public String insertRooms()
	{
		try {
			rooms_type=URLDecoder.decode(URLEncoder.encode(rooms_type, "iso-8859-1"), "utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		RoomsBiz roomsBiz = new RoomsBizImpl();
		roomsBiz.insertRooms(rooms_id, rooms_housesid, rooms_type, rooms_area, rooms_usearea);
		path = "room_getRooms";
		return SUCCESS;		
	}
	
	//��ȡ�����Ϣ
	private List<String> houseIdList = new ArrayList<String>();
	
	public List<String> getHouseIdList() {
		return houseIdList;
	}

	public void setHouseIdList(List<String> houseIdList) {
		this.houseIdList = houseIdList;
	}
	
	public String gethouseid()
	{
		RoomsBiz roomsBiz = new RoomsBizImpl();
		houseIdList = roomsBiz.get_houseid();
		path="rooms.jsp";
		return SUCCESS;		
	}
	
	//��ʾ
	public String notice() throws IOException
	{
		HttpServletResponse resp = ServletActionContext.getResponse();
		resp.setHeader("pragma", "no-cache");
		resp.setHeader("cache-control", "no-cache");
		PrintWriter out = resp.getWriter();
		RoomsBiz roomsBiz = new RoomsBizImpl();
		//���id�ظ�
		if(roomsBiz.idEqual(rooms_id)==true)
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
			rooms_type=URLDecoder.decode(URLEncoder.encode(rooms_type, "iso-8859-1"), "utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		RoomsBiz roomsBiz = new RoomsBizImpl();
		roomsBiz.updateRooms(rooms_id, rooms_housesid, rooms_type, rooms_area, rooms_usearea);
		path = "room_getRooms";
		return SUCCESS;		
	}
	
	//��ѯһ����Ϣ
	public String select()
	{
		RoomsBiz roomsBiz = new RoomsBizImpl();
		Rooms rooms = new Rooms();
		houseIdList = roomsBiz.get_houseid();
		rooms = roomsBiz.getRooms(rooms_id);
		if(null==rooms)
		{
			return INPUT;
		}
		rooms_id = rooms.getRooms_id();
		rooms_housesid = rooms.getRooms_housesid();
		rooms_type = rooms.getRooms_type();
		rooms_area = rooms.getRooms_area();
		rooms_usearea = rooms.getRooms_usearea();
		houseIdList.remove(rooms_housesid);
		houseIdList.add(0, rooms_housesid);

		path = "room_edit.jsp";
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
	
	public String deleteRooms()
	{	
		RoomsBiz roomsBiz = new RoomsBizImpl();
		for(int i=0;i<checkbox.length;i++)
		{
			roomsBiz.deleteRooms(checkbox[i]);
			System.out.println(checkbox[i]);
		}
		path = "room_getRooms";
		return SUCCESS;	
	}
	
	public String getRooms_id() {
		return rooms_id;
	}
	public void setRooms_id(String rooms_id) {
		this.rooms_id = rooms_id;
	}
	public String getRooms_housesid() {
		return rooms_housesid;
	}
	public void setRooms_housesid(String rooms_housesid) {
		this.rooms_housesid = rooms_housesid;
	}
	public String getRooms_type() {
		return rooms_type;
	}
	public void setRooms_type(String rooms_type) {
		this.rooms_type = rooms_type;
	}
	public double getRooms_area() {
		return rooms_area;
	}
	public void setRooms_area(double rooms_area) {
		this.rooms_area = rooms_area;
	}
	public double getRooms_usearea() {
		return rooms_usearea;
	}
	public void setRooms_usearea(double rooms_usearea) {
		this.rooms_usearea = rooms_usearea;
	}




	public String getPath() {
		return path;
	}




	public void setPath(String path) {
		this.path = path;
	}




	public List<Rooms> getGetdata() {
		return getdata;
	}




	public void setGetdata(List<Rooms> getdata) {
		this.getdata = getdata;
	}


	public String getS() {
		return s;
	}


	public void setS(String s) {
		this.s = s;
	}
	
	
}
