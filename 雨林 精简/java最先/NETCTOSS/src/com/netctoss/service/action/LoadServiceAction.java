package com.netctoss.service.action;

import com.netctoss.exception.DAOException;
import com.netctoss.service.dao.IServiceDAO;
import com.netctoss.service.vo.ServiceVO;
import com.netctoss.util.DAOFactory;

public class LoadServiceAction {
	private int id;
	private ServiceVO s;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public ServiceVO getS() {
		return s;
	}
	public void setS(ServiceVO s) {
		this.s = s;
	}
	public String execute(){
		IServiceDAO dao=(IServiceDAO) DAOFactory.getInstance("IServiceDAO");
		try {
			s=dao.findById(id);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
