package com.netctoss.service.action;

import java.util.List;

import com.netctoss.cost.dao.ICostDAO;
import com.netctoss.cost.entity.Cost;
import com.netctoss.exception.DAOException;
import com.netctoss.service.dao.IServiceDAO;
import com.netctoss.service.vo.ServiceVO;
import com.netctoss.util.DAOFactory;

public class ToUpdateServiceAction {
	private int id;
	private ServiceVO s;
	private List<Cost> costs;
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
	public List<Cost> getCosts() {
		return costs;
	}
	public void setCosts(List<Cost> costs) {
		this.costs = costs;
	}
	public String execute(){
		ICostDAO cdao=(ICostDAO) DAOFactory.getInstance("ICostDAO");
		IServiceDAO sdao=(IServiceDAO) DAOFactory.getInstance("IServiceDAO");
		try {
			costs=cdao.findAll();
			s=sdao.findById(id);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
