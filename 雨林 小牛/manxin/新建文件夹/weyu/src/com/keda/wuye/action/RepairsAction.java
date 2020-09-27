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
import com.keda.wuye.biz.HousesBiz;
import com.keda.wuye.biz.RepairsBiz;
import com.keda.wuye.biz.impl.CarportBizImpl;
import com.keda.wuye.biz.impl.CommunityBizImpl;
import com.keda.wuye.biz.impl.HousesBizImpl;
import com.keda.wuye.biz.impl.RepairsBizImpl;
import com.keda.wuye.entity.Carport;
import com.keda.wuye.entity.Community;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Repairs;
import com.opensymphony.xwork2.ActionSupport;

public class RepairsAction extends ActionSupport{
	private String repairs_id;				//���ޱ��
	private String repairs_plantid;		//�豸���
	private String repairs_date;			//����ʱ��
	private String repairs_reason;		//����ԭ��
	private String repairs_way;			//���޷�ʽ
	private String repairs_person;		//������Ա
	private String repairs_result;		//���޽��
	private String path;
	private String s;
	private List<Repairs> getdata;
	
	//��ȡС����?
	public String getRepairs()
	{
		RepairsBiz repairsBiz = new RepairsBizImpl();
		getdata = repairsBiz.getRepairs();
		path = "repairs_ui.jsp";
		return SUCCESS;			
	}
	//��ȡС����?
	public String selectlike()
	{
		try {
			s=URLDecoder.decode(URLEncoder.encode(s, "iso-8859-1") , "utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		RepairsBiz repairsBiz = new RepairsBizImpl();
		getdata = repairsBiz.select(s);
		path = "repairs_ui.jsp";
		return SUCCESS;			
	}
	//��ȡ�����Ϣ
	private List<String> plantIdList = new ArrayList<String>();
	
	public List<String> getPlantIdList() {
		return plantIdList;
	}
	public void setPlantIdList(List<String> plantIdList) {
		this.plantIdList = plantIdList;
	}
	
	public String getplantid()
	{
		RepairsBiz repairsBiz = new RepairsBizImpl();
		plantIdList = repairsBiz.get_plantid();
		path="repairs.jsp";
		return SUCCESS;		
	}
	
	//��ʾ
	public String notice() throws IOException
	{
		HttpServletResponse resp = ServletActionContext.getResponse();
		resp.setHeader("pragma", "no-cache");
		resp.setHeader("cache-control", "no-cache");
		PrintWriter out = resp.getWriter();
		RepairsBiz repairsBiz = new RepairsBizImpl();
		//���com_id�ظ�
		if(repairsBiz.idEqual(repairs_id)==true)
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
	public String insertRepairs()
	{
		try {
			repairs_plantid=URLDecoder.decode(URLEncoder.encode(repairs_plantid, "iso-8859-1") , "utf8");
			repairs_reason=URLDecoder.decode(URLEncoder.encode(repairs_reason, "iso-8859-1") , "utf8");
			repairs_way=URLDecoder.decode(URLEncoder.encode(repairs_way, "iso-8859-1") , "utf8");
			repairs_person=URLDecoder.decode(URLEncoder.encode(repairs_person, "iso-8859-1") , "utf8");
			repairs_result=URLDecoder.decode(URLEncoder.encode(repairs_result, "iso-8859-1") , "utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}	
		RepairsBiz repairsBiz = new RepairsBizImpl();
		repairsBiz.insertRepairs(repairs_id, repairs_plantid, repairs_date, repairs_reason, repairs_way, repairs_person, repairs_result);
		path = "rep_getRepairs";
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
	
	public String deleteRepairs()
	{	
		RepairsBiz repairsBiz = new RepairsBizImpl();
		for(int i=0;i<checkbox.length;i++)
		{
			repairsBiz.deleteRepairs(checkbox[i]);
		}
		path = "rep_getRepairs";
		return SUCCESS;	
	}
	
	//��ѯһ����Ϣ
	public String select()
	{
		RepairsBiz repairsBiz = new RepairsBizImpl();
		Repairs repairs = new Repairs();
		plantIdList = repairsBiz.get_plantid();
		repairs = repairsBiz.getRepairs(repairs_id);
		if(null==repairs)
		{
			return INPUT;
		}
	
		repairs_id = repairs.getRepairs_id();
		repairs_plantid = repairs.getRepairs_plantid();
		repairs_date = repairs.getRepairs_date();
		repairs_reason = repairs.getRepairs_reason();
		repairs_way = repairs.getRepairs_way();
		repairs_person = repairs.getRepairs_person();
		repairs_result = repairs.getRepairs_result();
		plantIdList.remove(repairs_plantid);
		plantIdList.add(0, repairs_plantid);
		path = "repairs_edit.jsp";
		return SUCCESS;	
	}
	//�޸���Ϣ
	public String update()
	{
		try {
			repairs_plantid=URLDecoder.decode(URLEncoder.encode(repairs_plantid, "iso-8859-1") , "utf8");
			repairs_reason=URLDecoder.decode(URLEncoder.encode(repairs_reason, "iso-8859-1") , "utf8");
			repairs_way=URLDecoder.decode(URLEncoder.encode(repairs_way, "iso-8859-1") , "utf8");
			repairs_person=URLDecoder.decode(URLEncoder.encode(repairs_person, "iso-8859-1") , "utf8");
			repairs_result=URLDecoder.decode(URLEncoder.encode(repairs_result, "iso-8859-1") , "utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		RepairsBiz repairsBiz = new RepairsBizImpl();
		repairsBiz.updateRepairs(repairs_id, repairs_plantid, repairs_date, repairs_reason, repairs_way, repairs_person, repairs_result);
		path = "rep_getRepairs";
		return SUCCESS;		
	}
	
	public String getRepairs_id() {
		return repairs_id;
	}
	public void setRepairs_id(String repairs_id) {
		this.repairs_id = repairs_id;
	}
	public String getRepairs_plantid() {
		return repairs_plantid;
	}
	public void setRepairs_plantid(String repairs_plantid) {
		this.repairs_plantid = repairs_plantid;
	}
	public String getRepairs_date() {
		return repairs_date;
	}
	public void setRepairs_date(String repairs_date) {
		this.repairs_date = repairs_date;
	}
	public String getRepairs_reason() {
		return repairs_reason;
	}
	public void setRepairs_reason(String repairs_reason) {
		this.repairs_reason = repairs_reason;
	}
	public String getRepairs_way() {
		return repairs_way;
	}
	public void setRepairs_way(String repairs_way) {
		this.repairs_way = repairs_way;
	}
	public String getRepairs_person() {
		return repairs_person;
	}
	public void setRepairs_person(String repairs_person) {
		this.repairs_person = repairs_person;
	}
	public String getRepairs_result() {
		return repairs_result;
	}
	public void setRepairs_result(String repairs_result) {
		this.repairs_result = repairs_result;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public List<Repairs> getGetdata() {
		return getdata;
	}
	public void setGetdata(List<Repairs> getdata) {
		this.getdata = getdata;
	}
	public String getS() {
		return s;
	}
	public void setS(String s) {
		this.s = s;
	}
	
	
}
