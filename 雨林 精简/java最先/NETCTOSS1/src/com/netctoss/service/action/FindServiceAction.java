package com.netctoss.service.action;

import java.util.List;

import com.netctoss.exception.DAOException;
import com.netctoss.service.dao.IServiceDAO;
import com.netctoss.service.entity.QueryCodi;
import com.netctoss.service.vo.ServiceVO;
import com.netctoss.util.DAOFactory;

public class FindServiceAction {
	
	private List<ServiceVO> service;
	private QueryCodi q;
	private int page=1;
	private int pageSize=3;
	private int totalPage;
	
	
	public QueryCodi getQ() {
		return q;
	}
	public void setQ(QueryCodi q) {
		this.q = q;
	}
	
	public List<ServiceVO> getService() {
		return service;
	}
	public void setService(List<ServiceVO> service) {
		this.service = service;
	}
	public int getPage() {
		return page;
	}
	public void setPage(int page) {
		this.page = page;
	}
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	public int getTotalPage() {
		return totalPage;
	}
	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	public String execute(){
		IServiceDAO dao=(IServiceDAO) DAOFactory.getInstance("IServiceDAO");
		try {
			service=dao.findByCodition(q, page, pageSize);
			totalPage=dao.getTotalPage(q, pageSize);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
