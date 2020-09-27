package com.netctoss.admin.dao;

import static org.junit.Assert.fail;

import org.junit.Test;

import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class AdminDAOImplTest {

	@Test
	public void testFindByCondition() throws DAOException {
		IAdminDAO dao=(IAdminDAO) DAOFactory.getInstance("IAdminDAO");
		System.out.println(dao.findByCondition(null, null, 1, 2));
	}

	@Test
	public void testFindTotalPage() throws DAOException {
		IAdminDAO dao=(IAdminDAO) DAOFactory.getInstance("IAdminDAO");
		System.out.println(dao.findTotalPage(1, 1, 2));
	}
	
	@Test
	public void testfindById() throws DAOException{
		IAdminDAO dao=(IAdminDAO) DAOFactory.getInstance("IAdminDAO");
		System.out.println(dao.findById(1006));
	}
}
