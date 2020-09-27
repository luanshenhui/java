package com.netctoss.account.action;

import java.util.List;

import com.netctoss.account.dao.IAccountDAO;
import com.netctoss.account.entity.Account;
import com.netctoss.account.entity.QueryCodi;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class FindAccountAction {
	//输入
	private QueryCodi q;
	private int page=1;
	private int pageSize=3;
	private int totalPage;
	//输出
	private List<Account> accounts;
	
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
	public QueryCodi getQ() {
		return q;
	}
	public void setQ(QueryCodi q) {
		this.q = q;
	}
	public List<Account> getAccounts() {
		return accounts;
	}
	public void setAccounts(List<Account> accounts) {
		this.accounts = accounts;
	}
	public String execute(){
		IAccountDAO dao=(IAccountDAO) DAOFactory.getInstance("IAccountDAO");
		try {
			accounts=dao.findByCondition(q,page,pageSize);
			totalPage=dao.getTotalPage(q,pageSize);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
