package com.netctoss.service.action;

import com.netctoss.exception.DAOException;
import com.netctoss.service.dao.IServiceDAO;
import com.netctoss.service.entity.ServiceUpdate;
import com.netctoss.util.DAOFactory;

public class UpdateServiceAction {
	private ServiceUpdate sud;
	
	public ServiceUpdate getSud() {
		return sud;
	}

	public void setSud(ServiceUpdate sud) {
		this.sud = sud;
	}

	public String execute(){
		IServiceDAO dao=(IServiceDAO) DAOFactory.getInstance("IServiceDAO");
		try {
			ServiceUpdate s=dao.findServiceUpdateByServiceId(sud.getServiceId());
			if(s!=null){
				dao.updateServiceUpdate(sud);
			}else{
				dao.saveServiceBak(sud);
			}
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
