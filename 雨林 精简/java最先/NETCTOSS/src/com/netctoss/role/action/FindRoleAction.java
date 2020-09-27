package com.netctoss.role.action;

import java.util.List;

import com.netctoss.exception.DAOException;
import com.netctoss.role.dao.IRoleDAO;
import com.netctoss.role.entity.Role;
import com.netctoss.util.DAOFactory;

public class FindRoleAction {
	private int page=1;
	private int pageSize=2;
	private int totalPage;
	private List<Role> roles;
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
	public List<Role> getRoles() {
		return roles;
	}
	public void setRoles(List<Role> roles) {
		this.roles = roles;
	}
	public String execute(){
		IRoleDAO dao=(IRoleDAO) DAOFactory.getInstance("IRoleDAO");
		try {
			roles=dao.findByPage(page, pageSize);
			totalPage=dao.getTotalPage(pageSize);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
