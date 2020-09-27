package com.netctoss.service.action;

import com.netctoss.exception.DAOException;
import com.netctoss.service.dao.IServiceDAO;
import com.netctoss.service.entity.Service;
import com.netctoss.util.DAOFactory;

public class AddServiceAction {
	private Service s;

	public Service getS() {
		return s;
	}

	public void setS(Service s) {
		this.s = s;
	}
	public String execute(){
		IServiceDAO dao=(IServiceDAO) DAOFactory.getInstance("IServiceDAO");
			try {
				dao.save(s);
			} catch (DAOException e) {
				e.printStackTrace();
				return "error";
			}
		return "success";
	}
}
