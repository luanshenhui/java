package com.netctoss.admin.action;

import java.util.Arrays;
import java.util.List;

import com.netctoss.admin.dao.IAdminDAO;
import com.netctoss.admin.entity.Admin;
import com.netctoss.exception.DAOException;
import com.netctoss.role.dao.IRoleDAO;
import com.netctoss.role.entity.Role;
import com.netctoss.util.DAOFactory;

public class ToUpdateAdmin {
	private Integer id;
	private List<Role> roles;
	private Admin admin;
	
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public List<Role> getRoles() {
		return roles;
	}
	public void setRoles(List<Role> roles) {
		this.roles = roles;
	}
	public Admin getAdmin() {
		return admin;
	}
	public void setAdmin(Admin admin) {
		this.admin = admin;
	}
	
	public String execute(){
		IRoleDAO idao=(IRoleDAO) DAOFactory.getInstance("IRoleDAO");
		IAdminDAO adao=(IAdminDAO) DAOFactory.getInstance("IAdminDAO");
		try {
			roles=idao.findAll();
			admin=adao.findById(id);
			//System.out.println(Arrays.toString(admin.getRoleIds()));
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
