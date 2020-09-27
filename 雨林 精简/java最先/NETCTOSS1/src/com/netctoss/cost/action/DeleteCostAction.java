package com.netctoss.cost.action;

import com.netctoss.cost.dao.ICostDAO;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class DeleteCostAction {
	private int id;
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String execute(){
		ICostDAO dao=(ICostDAO) DAOFactory.getInstance("ICostDAO");
		try {
			dao.deleteById(id);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
