package com.cost.account.action;

import java.util.List;

import com.cost.Factory.Factory;
import com.cost.account.Dao.AccountDao;
import com.cost.account.entity.Account;

public class AccountAction {
	AccountDao dao = (AccountDao) Factory.getInstance("AccountDao");

	//输入
	private String idcard_no;//身份证
	private String real_name;//姓名
	private String login_name;//登录名
	private String status;//状态
	//输出
	private List<Account> list;
	int totalPage;
	
	//分页
	int page = 1;
	int pageSize;
	
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

	public String getIdcard_no() {
		return idcard_no;
	}

	public void setIdcard_no(String idcardNo) {
		idcard_no = idcardNo;
	}

	public String getReal_name() {
		return real_name;
	}

	public void setReal_name(String realName) {
		real_name = realName;
	}

	public String getLogin_name() {
		return login_name;
	}

	public void setLogin_name(String loginName) {
		login_name = loginName;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public List<Account> getList() {
		return list;
	}

	public void setList(List<Account> list) {
		this.list = list;
	}

	public String execute() {
		try {
			list = dao.findByCondition(idcard_no, real_name, login_name, status, page, pageSize);
			totalPage = dao.findTotalPage(idcard_no, real_name, login_name, status, pageSize);
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
