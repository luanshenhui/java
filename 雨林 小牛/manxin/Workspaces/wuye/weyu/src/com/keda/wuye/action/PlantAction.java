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
import com.keda.wuye.biz.PlantBiz;
import com.keda.wuye.biz.impl.CommunityBizImpl;
import com.keda.wuye.biz.impl.HousesBizImpl;
import com.keda.wuye.biz.impl.PlantBizImpl;
import com.keda.wuye.entity.Community;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Plant;
import com.opensymphony.xwork2.ActionSupport;

public class PlantAction extends ActionSupport {
	private String plant_id; // �豸���
	private String plant_name; // �豸����
	private String plant_comid; // �豸����С����
	private String plant_factory; // �豸�����
	private String plant_date; // �豸�������
	private int plant_num; // �豸����
	private int plant_repaircycle; // �豸��������
	private String path;
	private String s;
	private List<Plant> getdata;

	// ��ȡС����?
	public String getPlant() {
		PlantBiz plantBiz = new PlantBizImpl();
		getdata = plantBiz.getPlant();
		path = "plant_ui.jsp";
		return SUCCESS;
	}

	// ��ȡС����?
	public String selectlike() {
		try {
			s = URLDecoder.decode(URLEncoder.encode(s, "iso-8859-1"), "utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		PlantBiz plantBiz = new PlantBizImpl();
		getdata = plantBiz.select(s);
		path = "plant_ui.jsp";
		return SUCCESS;
	}

	// ��ȡ�����Ϣ
	private List<String> comIdList = new ArrayList<String>();

	public List<String> getComIdList() {
		return comIdList;
	}

	public void setComIdList(List<String> comIdList) {
		this.comIdList = comIdList;
	}

	public String getcomid() {
		PlantBiz plantBiz = new PlantBizImpl();
		comIdList = plantBiz.get_comid();
		path = "plant.jsp";
		return SUCCESS;
	}

	// ��ʾ
	public String notice() throws IOException {
		HttpServletResponse resp = ServletActionContext.getResponse();
		resp.setHeader("pragma", "no-cache");
		resp.setHeader("cache-control", "no-cache");
		PrintWriter out = resp.getWriter();
		PlantBiz plantBiz = new PlantBizImpl();
		// ���com_id�ظ�
		if (plantBiz.idEqual(plant_id) == true) {
			// ������ʾҳ��
			out.println(1);
		} else {
			out.println(0);
		}
		out.flush();
		return NONE;
	}

	// ���
	public String insertPlant() {
		try {
			plant_name = URLDecoder.decode(URLEncoder.encode(plant_name, "iso-8859-1"), "utf8");
			plant_factory = URLDecoder.decode(URLEncoder.encode(plant_factory, "iso-8859-1"), "utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		PlantBiz plantBiz = new PlantBizImpl();
		plantBiz.insertPlant(plant_id, plant_name, plant_comid, plant_factory,
				plant_date, plant_num, plant_repaircycle);
		path = "pl_getPlant";
		return SUCCESS;
	}

	// ɾ����Ϣ
	private String checkbox[];

	public String[] getCheckbox() {
		return checkbox;
	}

	public void setCheckbox(String[] checkbox) {
		this.checkbox = checkbox;
	}

	public String deletePlant() {
		PlantBiz plantBiz = new PlantBizImpl();
		for (int i = 0; i < checkbox.length; i++) {
			plantBiz.deletePlant(checkbox[i]);
		}
		path = "pl_getPlant";
		return SUCCESS;
	}

	// ��ѯһ����Ϣ
	public String select() {
		PlantBiz plantBiz = new PlantBizImpl();
		Plant plant = new Plant();
		comIdList = plantBiz.get_comid();
		plant = plantBiz.getPlant(plant_id);
		if (null == plant) {
			return INPUT;
		}
		plant_id = plant.getPlant_id();
		plant_name = plant.getPlant_name();
		plant_comid = plant.getPlant_comid();
		plant_factory = plant.getPlant_factory();
		plant_date = plant.getPlant_date();
		plant_num = plant.getPlant_num();
		plant_repaircycle = plant.getPlant_repaircycle();
		comIdList.remove(plant_comid);
		comIdList.add(0, plant_comid);
		path = "plant_edit.jsp";
		return SUCCESS;
	}

	// �޸���Ϣ
	public String update() {
		try {
			plant_name = URLDecoder.decode(URLEncoder.encode(plant_name, "iso-8859-1"), "utf8");
			plant_factory = URLDecoder.decode(URLEncoder.encode(plant_factory, "iso-8859-1"), "utf8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		PlantBiz plantBiz = new PlantBizImpl();
		plantBiz.updatePlant(plant_id, plant_name, plant_comid, plant_factory,
				plant_date, plant_num, plant_repaircycle);
		path = "pl_getPlant";
		return SUCCESS;
	}

	public String getPlant_id() {
		return plant_id;
	}

	public void setPlant_id(String plant_id) {
		this.plant_id = plant_id;
	}

	public String getPlant_name() {
		return plant_name;
	}

	public void setPlant_name(String plant_name) {
		this.plant_name = plant_name;
	}

	public String getPlant_comid() {
		return plant_comid;
	}

	public void setPlant_comid(String plant_comid) {
		this.plant_comid = plant_comid;
	}

	public String getPlant_factory() {
		return plant_factory;
	}

	public void setPlant_factory(String plant_factory) {
		this.plant_factory = plant_factory;
	}

	public String getPlant_date() {
		return plant_date;
	}

	public void setPlant_date(String plant_date) {
		this.plant_date = plant_date;
	}

	public int getPlant_num() {
		return plant_num;
	}

	public void setPlant_num(int plant_num) {
		this.plant_num = plant_num;
	}

	public int getPlant_repaircycle() {
		return plant_repaircycle;
	}

	public void setPlant_repaircycle(int plant_repaircycle) {
		this.plant_repaircycle = plant_repaircycle;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public List<Plant> getGetdata() {
		return getdata;
	}

	public void setGetdata(List<Plant> getdata) {
		this.getdata = getdata;
	}

	public String getS() {
		return s;
	}

	public void setS(String s) {
		this.s = s;
	}

}
