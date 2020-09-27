package com.service.action;

import com.cost.Factory.Factory;
import com.service.dao.ServiceDao;
import com.service.entity.VO;

public class ServiceModi {
	private int id;
	private VO vo;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public VO getVo() {
		return vo;
	}
	public void setVo(VO vo) {
		this.vo = vo;
	}
	
	public String execute(){
		ServiceDao dao = (ServiceDao) Factory.getInstance("ServiceDao");
		try {
			vo = dao.findById(id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "success";
	}
}
