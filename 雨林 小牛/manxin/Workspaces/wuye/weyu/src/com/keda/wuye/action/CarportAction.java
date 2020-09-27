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

import com.keda.wuye.biz.AlarmBiz;
import com.keda.wuye.biz.CarportBiz;
import com.keda.wuye.biz.impl.AlarmBizImpl;
import com.keda.wuye.biz.impl.CarportBizImpl;
import com.keda.wuye.entity.Carport;
import com.opensymphony.xwork2.ActionSupport;

public class CarportAction extends ActionSupport{
	
	private String carport_id;			//��λ��
	private String carport_resid;		//�������
	private String carport_carnum;		//���ƺ�
	private String carport_cartype;		//������
	private double carport_area;		//��λ���
	private String path;
	private String s;
	private List<Carport> getdata;
	
	//��ȡС����?
	public String getCarport()
	{
		CarportBiz carportBiz = new CarportBizImpl();
		getdata = carportBiz.getCarport();
		path = "carport_ui.jsp";
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
		CarportBiz carportBiz = new CarportBizImpl();
		getdata = carportBiz.select(s);
		path = "carport_ui.jsp";
		return SUCCESS;			
	}
	
	//��ȡ�����Ϣ
	private List<String> resiIdList = new ArrayList<String>();
	
	public List<String> getResiIdList() {
		return resiIdList;
	}
	public void setResiIdList(List<String> resiIdList) {
		this.resiIdList = resiIdList;
	}

	public String getresiid()
	{
		CarportBiz carportBiz = new CarportBizImpl();
		resiIdList = carportBiz.get_resiid();
		path="carport.jsp";
		return SUCCESS;		
	}
	
	//��ʾ
	public String notice() throws IOException
	{
		HttpServletResponse resp = ServletActionContext.getResponse();
		resp.setHeader("pragma", "no-cache");
		resp.setHeader("cache-control", "no-cache");
		PrintWriter out = resp.getWriter();
		CarportBiz carportBiz = new CarportBizImpl();
		//���com_id�ظ�
		if(carportBiz.idEqual(carport_id)==true)
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
	public String insertCarport()
	{
		try {
			carport_cartype=URLDecoder.decode(URLEncoder.encode(carport_cartype, "ISO-8859-1"), "UTF8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		CarportBiz carportBiz = new CarportBizImpl();
		carportBiz.insertCarport(carport_id, carport_resid, carport_carnum, carport_cartype, carport_area);
		path = "car_getCarport";
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
	
	public String deleteCarport()
	{	
		CarportBiz carportBiz = new CarportBizImpl();
		for(int i=0;i<checkbox.length;i++)
		{
			carportBiz.deleteCarport(checkbox[i]);
		}
		path = "car_getCarport";
		return SUCCESS;	
	}
	

	//��ѯһ����Ϣ
	public String select()
	{
		CarportBiz carportBiz = new CarportBizImpl();
		Carport carport = new Carport();
		resiIdList = carportBiz.get_resiid();
		carport = carportBiz.getCarport(carport_id);
		if(null==carport)
		{
			return INPUT;
		}
	
		carport_id = carport.getCarport_id();
		carport_resid = carport.getCarport_resid();
		carport_carnum = carport.getCarport_carnum();
		carport_cartype = carport.getCarport_cartype();
		carport_area = carport.getCarport_area();
		resiIdList.remove(carport_resid);
		resiIdList.add(0, carport_resid);
		path = "carport_edit.jsp";
		return SUCCESS;	
	}
	//�޸���Ϣ
	public String update()
	{
		try {
			carport_cartype=URLDecoder.decode(URLEncoder.encode(carport_cartype, "ISO-8859-1"), "UTF8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		CarportBiz carportBiz = new CarportBizImpl();
		carportBiz.updateCarport(carport_id, carport_resid, carport_carnum, carport_cartype, carport_area);
		path = "car_getCarport";
		return SUCCESS;		
	}
	
	
	
	public String getCarport_id() {
		return carport_id;
	}
	public void setCarport_id(String carport_id) {
		this.carport_id = carport_id;
	}
	public String getCarport_resid() {
		return carport_resid;
	}
	public void setCarport_resid(String carport_resid) {
		this.carport_resid = carport_resid;
	}
	public String getCarport_carnum() {
		return carport_carnum;
	}
	public void setCarport_carnum(String carport_carnum) {
		this.carport_carnum = carport_carnum;
	}
	public String getCarport_cartype() {
		return carport_cartype;
	}
	public void setCarport_cartype(String carport_cartype) {
		this.carport_cartype = carport_cartype;
	}
	public double getCarport_area() {
		return carport_area;
	}
	public void setCarport_area(double carport_area) {
		this.carport_area = carport_area;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public List<Carport> getGetdata() {
		return getdata;
	}
	public void setGetdata(List<Carport> getdata) {
		this.getdata = getdata;
	}

	public String getS() {
		return s;
	}

	public void setS(String s) {
		this.s = s;
	}
	
	
}
