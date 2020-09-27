package com.netctoss.cost.action;

import java.util.List;

import com.netctoss.cost.dao.ICostDAO;
import com.netctoss.cost.entity.Cost;
import com.netctoss.exception.DAOException;
import com.netctoss.util.BaseAction;
import com.netctoss.util.DAOFactory;

/**
 * 查询资费的Action
 * @author soft01
 *
 */
public class FindCostAction extends BaseAction{
	/**
	 * 输出
	 * @return
	 */
	private List<Cost> costs;
	private int pages=1;
	private int totalPage;
	private int pageSize=3;
	private String colName;
	private String type;
	
	
	public String getColName() {
		return colName;
	}

	public void setColName(String colName) {
		this.colName = colName;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getPages() {
		return pages;
	}

	public void setPages(int pages) {
		this.pages = pages;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public List<Cost> getCosts() {
		return costs;
	}

	public void setCosts(List<Cost> costs) {
		this.costs = costs;
	}

	public String execute(){
		ICostDAO dao=(ICostDAO) DAOFactory.getInstance("ICostDAO");
		try {
			if("asc".equals(type)){
				costs=dao.findByPagesAsc(pages, pageSize, colName);
			}else if("desc".equals(type)){
				costs=dao.findByPagesDesc(pages, pageSize, colName);
			}else{
				costs=dao.findByPages(pages, pageSize);
			}
			
			totalPage=dao.getTotalPage(pageSize);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		} 
		return "success";
	}
}
