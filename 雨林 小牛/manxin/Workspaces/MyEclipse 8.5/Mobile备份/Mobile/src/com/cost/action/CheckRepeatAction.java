package com.cost.action;

import com.cost.Dao.CostDao;
import com.cost.Factory.Factory;
import com.cost.entity.Cost;

public class CheckRepeatAction {
	
	
	private boolean repeat;
	private String name;
	
	public boolean isRepeat() {
		return repeat;
	}
	public void setRepeat(boolean repeat) {
		this.repeat = repeat;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String execute(){
		CostDao dao = (CostDao) Factory.getInstance("CostDao");
		//1.调用DAO 根据资费名称查询资费数据
		Cost cost = null;
		try {
			cost = dao.findByName(name);
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
		//2.判断是否重复
		if(cost == null){
			repeat = false; 
		}else{
			repeat = true;
		}
		return "success";
	}

}
