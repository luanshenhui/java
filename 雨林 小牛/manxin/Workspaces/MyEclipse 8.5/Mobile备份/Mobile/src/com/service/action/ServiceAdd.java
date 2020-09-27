package com.service.action;

import com.cost.Factory.Factory;
import com.service.dao.ServiceDao;
import com.service.entity.Service;

public class ServiceAdd {
	private Service service;

	public Service getService() {
		return service;
	}

	public void setService(Service service) {
		this.service = service;
	}
	
	public String execute(){
		ServiceDao dao = (ServiceDao) Factory.getInstance("ServiceDao");
		try {
			dao.saveService(service);
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
