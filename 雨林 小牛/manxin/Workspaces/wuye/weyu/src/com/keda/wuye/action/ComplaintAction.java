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
import com.keda.wuye.biz.ComplaintBiz;
import com.keda.wuye.biz.HousesBiz;
import com.keda.wuye.biz.RepairsBiz;
import com.keda.wuye.biz.impl.CarportBizImpl;
import com.keda.wuye.biz.impl.CommunityBizImpl;
import com.keda.wuye.biz.impl.ComplaintBizImpl;
import com.keda.wuye.biz.impl.HousesBizImpl;
import com.keda.wuye.biz.impl.RepairsBizImpl;
import com.keda.wuye.entity.Carport;
import com.keda.wuye.entity.Community;
import com.keda.wuye.entity.Complaint;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Repairs;
import com.opensymphony.xwork2.ActionSupport;

public class ComplaintAction extends ActionSupport{
	private String complaint_id;			//Ͷ�߱��
	private String complaint_resid;			//Ͷ��ҵ��
	private String complaint_date;			//Ͷ��ʱ��
	private String complaint_matter;		//Ͷ���¼�
	private String complaint_dealperson;	//������Ա
	private String complaint_way;			//���?ʽ
	private String complaint_result;		//������
	private String path;
	private String s;
	private List<Complaint> getdata;
	
	//��ȡС����?
	public String getComplaint()
	{
		ComplaintBiz complaintBiz = new ComplaintBizImpl();
		getdata = complaintBiz.getComplaint();
		path = "complaint_ui.jsp";
		return SUCCESS;			
	}
	
	//ģ���ѯ
	public String selectlike()
	{
		try {
			s=URLDecoder.decode(URLEncoder.encode(s, "iso-8859-1"), "utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		ComplaintBiz complaintBiz = new ComplaintBizImpl();
		getdata = complaintBiz.select(s);
		path = "complaint_ui.jsp";
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
		ComplaintBiz complaintBiz = new ComplaintBizImpl();
		resiIdList = complaintBiz.get_resiid();
		path="complaint.jsp";
		return SUCCESS;		
	}
	//��ʾ
	public String notice() throws IOException
	{
		HttpServletResponse resp = ServletActionContext.getResponse();
		resp.setHeader("pragma", "no-cache");
		resp.setHeader("cache-control", "no-cache");
		PrintWriter out = resp.getWriter();
		ComplaintBiz complaintBiz = new ComplaintBizImpl();
		//���com_id�ظ�
		if(complaintBiz.idEqual(complaint_id)==true)
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
	public String insertComplaint()
	{
		try {
			complaint_resid=URLDecoder.decode(URLEncoder.encode(complaint_resid, "iso-8859-1"), "utf8");
			complaint_matter=URLDecoder.decode(URLEncoder.encode(complaint_matter, "iso-8859-1"), "utf8");
			complaint_dealperson=URLDecoder.decode(URLEncoder.encode(complaint_dealperson, "iso-8859-1"), "utf8");
			complaint_way=URLDecoder.decode(URLEncoder.encode(complaint_way, "iso-8859-1"), "utf8");
			complaint_result=URLDecoder.decode(URLEncoder.encode(complaint_result, "iso-8859-1"), "utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		ComplaintBiz complaintBiz = new ComplaintBizImpl();
		complaintBiz.insertComplaint(complaint_id, complaint_resid, complaint_date, complaint_matter, complaint_dealperson, complaint_way, complaint_result);
		path = "comp_getComplaint";
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
	
	public String deleteComplaint()
	{	
		ComplaintBiz complaintBiz = new ComplaintBizImpl();
		for(int i=0;i<checkbox.length;i++)
		{
			complaintBiz.deleteComplaint(checkbox[i]);
		}
		path = "comp_getComplaint";
		return SUCCESS;	
	}
	
	//��ѯһ����Ϣ
	public String select()
	{
		ComplaintBiz complaintBiz = new ComplaintBizImpl();
		Complaint complaint = new Complaint();
		resiIdList = complaintBiz.get_resiid();
		complaint = complaintBiz.getComplaint(complaint_id);
		if(null==complaint)
		{
			return INPUT;
		}
	
		complaint_id = 	complaint.getComplaint_id();
		complaint_resid = complaint.getComplaint_resid();
		complaint_date = complaint.getComplaint_date();
		complaint_matter = complaint.getComplaint_matter();
		complaint_dealperson = complaint.getComplaint_dealperson();
		complaint_way = complaint.getComplaint_way();
		complaint_result = complaint.getComplaint_result();
		resiIdList.remove(complaint_resid);
		resiIdList.add(0, complaint_resid);
		path = "complaint_edit.jsp";
		return SUCCESS;	
	}
	//�޸���Ϣ
	public String update()
	{
		try {
			complaint_resid=URLDecoder.decode(URLEncoder.encode(complaint_resid, "iso-8859-1"), "utf8");
			complaint_matter=URLDecoder.decode(URLEncoder.encode(complaint_matter, "iso-8859-1"), "utf8");
			complaint_dealperson=URLDecoder.decode(URLEncoder.encode(complaint_dealperson, "iso-8859-1"), "utf8");
			complaint_way=URLDecoder.decode(URLEncoder.encode(complaint_way, "iso-8859-1"), "utf8");
			complaint_result=URLDecoder.decode(URLEncoder.encode(complaint_result, "iso-8859-1"), "utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		ComplaintBiz complaintBiz = new ComplaintBizImpl();
		complaintBiz.updateComplaint(complaint_id, complaint_resid, complaint_date, complaint_matter, complaint_dealperson, complaint_way, complaint_result);
		path = "comp_getComplaint";
		return SUCCESS;		
	}
	
	public String getComplaint_id() {
		return complaint_id;
	}
	public void setComplaint_id(String complaint_id) {
		this.complaint_id = complaint_id;
	}
	public String getComplaint_resid() {
		return complaint_resid;
	}
	public void setComplaint_resid(String complaint_resid) {
		this.complaint_resid = complaint_resid;
	}
	public String getComplaint_date() {
		return complaint_date;
	}
	public void setComplaint_date(String complaint_date) {
		this.complaint_date = complaint_date;
	}
	public String getComplaint_matter() {
		return complaint_matter;
	}
	public void setComplaint_matter(String complaint_matter) {
		this.complaint_matter = complaint_matter;
	}
	public String getComplaint_dealperson() {
		return complaint_dealperson;
	}
	public void setComplaint_dealperson(String complaint_dealperson) {
		this.complaint_dealperson = complaint_dealperson;
	}
	public String getComplaint_way() {
		return complaint_way;
	}
	public void setComplaint_way(String complaint_way) {
		this.complaint_way = complaint_way;
	}
	public String getComplaint_result() {
		return complaint_result;
	}
	public void setComplaint_result(String complaint_result) {
		this.complaint_result = complaint_result;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public List<Complaint> getGetdata() {
		return getdata;
	}
	public void setGetdata(List<Complaint> getdata) {
		this.getdata = getdata;
	}
	public String getS() {
		return s;
	}
	public void setS(String s) {
		this.s = s;
	}
}
