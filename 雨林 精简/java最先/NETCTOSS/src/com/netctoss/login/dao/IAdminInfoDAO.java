package com.netctoss.login.dao;

import com.netctoss.exception.DAOException;
import com.netctoss.login.entity.AdminInfo;

public interface IAdminInfoDAO {
	public AdminInfo findByCodeAndPwd(String adminCode, String password)
			throws DAOException;
	public void modify(AdminInfo admin)throws DAOException;
}