package com.netctoss.login.dao;

import org.junit.Test;

import com.netctoss.exception.DAOException;
import com.netctoss.login.entity.AdminInfo;
import com.netctoss.util.DAOFactory;

public class AdminInfoImplTest {

	@Test
	public void testFindByCodeAndPwd() throws DAOException {
		IAdminInfoDAO dao=(IAdminInfoDAO) 
		DAOFactory.getInstance("IAdminInfoDAO");
		AdminInfo admin=dao.findByCodeAndPwd("1001_syl", "syl123");
		System.out.println(admin);
	}

}
