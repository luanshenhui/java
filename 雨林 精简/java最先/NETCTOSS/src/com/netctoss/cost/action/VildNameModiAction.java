package com.netctoss.cost.action;

import com.netctoss.cost.dao.ICostDAO;
import com.netctoss.cost.entity.Cost;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class VildNameModiAction {
	private int id;
	private String name;
	private boolean flag;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public boolean isFlag() {
		return flag;
	}
	public void setFlag(boolean flag) {
		this.flag = flag;
	}
	public String execute(){
		ICostDAO dao=(ICostDAO) DAOFactory.getInstance("ICostDAO");
		try {
			Cost cost=dao.vaildModiName(id, name);
			if(cost!=null){
				flag=true;
			}else{
				flag=false;
			}
		} catch (DAOException e) {
			e.printStackTrace();
		}
		return "success";
	}
}
