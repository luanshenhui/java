package com.keda.wuye.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import com.keda.wuye.biz.AlarmBiz;
import com.keda.wuye.biz.CarportBiz;
import com.keda.wuye.biz.CommunityBiz;
import com.keda.wuye.biz.HousesBiz;
import com.keda.wuye.biz.impl.AlarmBizImpl;
import com.keda.wuye.biz.impl.CarportBizImpl;
import com.keda.wuye.biz.impl.CommunityBizImpl;
import com.keda.wuye.biz.impl.HousesBizImpl;
import com.keda.wuye.entity.Alarm;
import com.keda.wuye.entity.Carport;
import com.keda.wuye.entity.Community;
import com.opensymphony.xwork2.ActionSupport;

//��ȡС���嵥����ȡ����ת��resident_ui.jsp����
public class AlarmAction extends ActionSupport{
	private String alarm_id;			//�������
	private String alarm_date;			//����ʱ��
	private String alarm_location;		//�·��ص�
	private String alarm_matter;		//��������
	private String alarm_way;			//������ʽ
	private String alarm_dealway;		//���?ʽ
	private String alarm_dealperson;	//������Ա
	private String alarm_dealresult;	//������
	private String path;
	private List<Alarm> getdata;
	private String s;
	
	public String getS() {
		return s;
	}

	public void setS(String s) {
		this.s = s;
	}

	//��ȡС����?
	public String getAlarm()
	{
		AlarmBiz alarmBiz = new AlarmBizImpl();
		getdata = alarmBiz.getAlarm();
		path = "alarm_ui.jsp";
		return SUCCESS;			
	}
	
	//ģ���ѯ
	public String selectlike()
	{
		try {
			s=URLDecoder.decode(URLEncoder.encode(s, "iso-8859-1"),"utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		AlarmBiz alarmBiz = new AlarmBizImpl();
		getdata = alarmBiz.select(s);
		path = "alarm_ui.jsp";
		return SUCCESS;		
	}
	
	//��ʾ
	public String notice() throws IOException
	{
		HttpServletResponse resp = ServletActionContext.getResponse();
		resp.setHeader("pragma", "no-cache");
		resp.setHeader("cache-control", "no-cache");
		PrintWriter out = resp.getWriter();
		AlarmBiz alarmBiz = new AlarmBizImpl();
		//���com_id�ظ�
		if(alarmBiz.idEqual(alarm_id)==true)
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
	public String insertAlarm()
	{
		
		try {
			alarm_location=URLDecoder.decode(URLEncoder.encode(alarm_location, "iso-8859-1"),"utf8");
			alarm_matter=URLDecoder.decode(URLEncoder.encode(alarm_matter, "iso-8859-1"),"utf8");
			alarm_way=URLDecoder.decode(URLEncoder.encode(alarm_way, "iso-8859-1"),"utf8");
			alarm_dealway=URLDecoder.decode(URLEncoder.encode(alarm_dealway, "iso-8859-1"),"utf8");
			alarm_dealperson=URLDecoder.decode(URLEncoder.encode(alarm_dealperson, "iso-8859-1"),"utf8");
			alarm_dealresult=URLDecoder.decode(URLEncoder.encode(alarm_dealresult, "iso-8859-1"),"utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		AlarmBiz alarmBiz = new AlarmBizImpl();
		alarmBiz.insertAlarm(alarm_id, alarm_date, alarm_location, alarm_matter, alarm_way, alarm_dealway, alarm_dealperson, alarm_dealresult);
		path = "alarm_getAlarm";
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
	
	public String deleteAlarm()
	{	
		AlarmBiz alarmBiz = new AlarmBizImpl();
		for(int i=0;i<checkbox.length;i++)
		{
			alarmBiz.deleteAlarm(checkbox[i]);
		}
		path = "alarm_getAlarm";
		return SUCCESS;	
	}
	//��ѯһ����Ϣ
	public String select()
	{
		AlarmBiz alarmBiz = new AlarmBizImpl();
		Alarm alarm = new Alarm();
		alarm = alarmBiz.getAlarm(alarm_id);
		if(null==alarm)
		{
			return INPUT;
		}
	
		alarm_id = alarm.getAlarm_id();
		alarm_date = alarm.getAlarm_date();
		alarm_location = alarm.getAlarm_location();
		alarm_matter = alarm.getAlarm_matter();
		alarm_way = alarm.getAlarm_way();
		alarm_dealway = alarm.getAlarm_dealway();
		alarm_dealperson = alarm.getAlarm_dealperson();
		alarm_dealresult =alarm.getAlarm_dealresult();
		
		path = "alarm_edit.jsp";
		return SUCCESS;	
	}
	//�޸���Ϣ
	public String update()
	{
		try {
			alarm_location=URLDecoder.decode(URLEncoder.encode(alarm_location, "iso-8859-1"),"utf8");
			alarm_matter=URLDecoder.decode(URLEncoder.encode(alarm_matter, "iso-8859-1"),"utf8");
			alarm_way=URLDecoder.decode(URLEncoder.encode(alarm_way, "iso-8859-1"),"utf8");
			alarm_dealway=URLDecoder.decode(URLEncoder.encode(alarm_dealway, "iso-8859-1"),"utf8");
			alarm_dealperson=URLDecoder.decode(URLEncoder.encode(alarm_dealperson, "iso-8859-1"),"utf8");
			alarm_dealresult=URLDecoder.decode(URLEncoder.encode(alarm_dealresult, "iso-8859-1"),"utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		AlarmBiz alarmBiz = new AlarmBizImpl();
		alarmBiz.updateAlarm(alarm_id, alarm_date, alarm_location, alarm_matter, alarm_way, alarm_dealway, alarm_dealperson, alarm_dealresult);
		path = "alarm_getAlarm";
		return SUCCESS;		
	}
	
	
	public String getAlarm_id() {
		return alarm_id;
	}
	public void setAlarm_id(String alarm_id) {
		this.alarm_id = alarm_id;
	}
	public String getAlarm_date() {
		return alarm_date;
	}
	public void setAlarm_date(String alarm_date) {
		this.alarm_date = alarm_date;
	}
	public String getAlarm_location() {
		return alarm_location;
	}
	public void setAlarm_location(String alarm_location) {
		this.alarm_location = alarm_location;
	}
	public String getAlarm_matter() {
		return alarm_matter;
	}
	public void setAlarm_matter(String alarm_matter) {
		this.alarm_matter = alarm_matter;
	}
	public String getAlarm_way() {
		return alarm_way;
	}
	public void setAlarm_way(String alarm_way) {
		this.alarm_way = alarm_way;
	}
	public String getAlarm_dealway() {
		return alarm_dealway;
	}
	public void setAlarm_dealway(String alarm_dealway) {
		this.alarm_dealway = alarm_dealway;
	}
	public String getAlarm_dealperson() {
		return alarm_dealperson;
	}
	public void setAlarm_dealperson(String alarm_dealperson) {
		this.alarm_dealperson = alarm_dealperson;
	}
	public String getAlarm_dealresult() {
		return alarm_dealresult;
	}
	public void setAlarm_dealresult(String alarm_dealresult) {
		this.alarm_dealresult = alarm_dealresult;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public List<Alarm> getGetdata() {
		return getdata;
	}
	public void setGetdata(List<Alarm> getdata) {
		this.getdata = getdata;
	}
	
	
}
