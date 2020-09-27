package com.netctoss.admin.dao;

import java.util.List;

import com.netctoss.admin.entity.Admin;
import com.netctoss.exception.DAOException;

public interface IAdminDAO {
	/**
	 * 更具条件查询
	 * @param roleId
	 * @param privilegeId
	 * @param page
	 * @param pageSize
	 * @return
	 * @throws DAOException
	 */
	public List<Admin> findByCondition(Integer roleId, Integer privilegeId,
			int page, int pageSize) throws DAOException;
	/**
	 * 查询总页数
	 * @param roleId
	 * @param privilegeId
	 * @param pageSize
	 * @return
	 * @throws DAOException
	 */
	public int findTotalPage(Integer roleId, Integer privilegeId,
			 int pageSize)throws DAOException;
	
	public void resetPassword(String[] ids) throws DAOException;
	public void saveAdmin(Admin a)throws DAOException;
	public Admin findById(Integer id) throws DAOException;
	public void updateAdmin(Admin a) throws DAOException;
	public void deleteAdmin(Integer id) throws DAOException;
}
