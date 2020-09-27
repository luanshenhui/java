package com.netctoss.role.dao;

import java.util.List;

import com.netctoss.exception.DAOException;
import com.netctoss.role.entity.Role;

public interface IRoleDAO {
	public List<Role> findAll() throws DAOException;

	public List<Role> findByPage(int page, int pageSize) throws DAOException;

	public int getTotalPage(int pageSize) throws DAOException;

	public void saveRole(Role role) throws DAOException;

	public Role findById(int id) throws DAOException;

	public void updateRole(Role role) throws DAOException;

	public void deleteRole(int id) throws DAOException;
}
