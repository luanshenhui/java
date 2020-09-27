package com.netctoss.admin.action;

import java.util.List;

import com.netctoss.admin.dao.IAdminDAO;
import com.netctoss.admin.entity.Admin;
import com.netctoss.exception.DAOException;
import com.netctoss.role.dao.IRoleDAO;
import com.netctoss.role.entity.Privilege;
import com.netctoss.role.entity.Role;
import com.netctoss.util.DAOFactory;
import com.netctoss.util.PrivilegeReader;

public class FindAdminAction {
	private int page=1;
	private int pageSize=2;
	private Integer roleId;
	private Integer privilegeId;
	private List<Admin> admins;
	private List<Privilege> privileges;
	private List<Role> roles;
	private int totalPage;
	
	
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


	public Integer getRoleId() {
		return roleId;
	}


	public void setRoleId(Integer roleId) {
		this.roleId = roleId;
	}


	public Integer getPrivilegeId() {
		return privilegeId;
	}


	public void setPrivilegeId(Integer privilegeId) {
		this.privilegeId = privilegeId;
	}


	public List<Admin> getAdmins() {
		return admins;
	}


	public void setAdmins(List<Admin> admins) {
		this.admins = admins;
	}


	public List<Privilege> getPrivileges() {
		return privileges;
	}


	public void setPrivileges(List<Privilege> privileges) {
		this.privileges = privileges;
	}


	public List<Role> getRoles() {
		return roles;
	}


	public void setRoles(List<Role> roles) {
		this.roles = roles;
	}


	public int getTotalPage() {
		return totalPage;
	}


	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}


	public String execute(){
		privileges=PrivilegeReader.getPrivileges();
		IRoleDAO idao=(IRoleDAO) DAOFactory.getInstance("IRoleDAO");
		IAdminDAO adao=(IAdminDAO) DAOFactory.getInstance("IAdminDAO");
		try {
			roles=idao.findAll();
			admins=adao.findByCondition(roleId, privilegeId, page, pageSize);
			//System.out.println(admins);
			totalPage=adao.findTotalPage(roleId, privilegeId, pageSize);
		} catch (DAOException e) {
			e.printStackTrace();
		}
		return "success";
	}
}
