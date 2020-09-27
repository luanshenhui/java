package com.netctoss.cost.action;

import com.netctoss.cost.dao.ICostDAO;
import com.netctoss.cost.entity.Cost;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class VildNameAction {
	private String name;
	private boolean ok;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public boolean isOk() {
		return ok;
	}
	public void setOk(boolean ok) {
		this.ok = ok;
	}
	public String execute(){
		ICostDAO dao=(ICostDAO) DAOFactory.getInstance("ICostDAO");
		try {
			Cost cost=dao.findByName(name);
			if(cost==null){
				ok=true;
			}else{
				ok=false;
			}
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
