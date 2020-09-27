package com.cost.action;

import java.util.List;

import com.cost.Dao.CostDao;
import com.cost.Factory.Factory;
import com.cost.entity.Cost;
import com.cost.entity.Cost_Admin;


public class Action extends BaseAction{
	private List<Cost> list;
	CostDao dao = (CostDao)Factory.getInstance("CostDao");
	int page = 1;
	int pageSize = 4;
	int totalPage;
	private Cost_Admin admin;

	public Cost_Admin getAdmin() {
		return admin;
	}

	public void setAdmin(Cost_Admin admin) {
		this.admin = admin;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
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

	public List<Cost> getList() {
		return list;
	}

	public void setList(List<Cost> list) {
		this.list = list;
	}

	public String execute() {
		try {
			list = dao.findPage(page,pageSize);
			totalPage = dao.findTotalPage(pageSize);
			admin = (Cost_Admin) session.get("admin");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "success";
	}
//	public static void main(String[] args) {
//		try {
//			List<Cost> list = dao.findPage(1, 4);
//			System.out.println(list);
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}
}
