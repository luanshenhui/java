package com.netctoss.role.dao;

import static org.junit.Assert.*;

import org.junit.Test;

import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class RoleDAOImplTest {

	@Test
	public void testFindByPage() throws DAOException {
		IRoleDAO dao=(IRoleDAO) DAOFactory.getInstance("IRoleDAO");
		System.out.println(dao.findByPage(3, 2));
	}
	
	@Test
	public void testGetTotalPage() throws DAOException{
		IRoleDAO dao=(IRoleDAO) DAOFactory.getInstance("IRoleDAO");
		System.out.println(dao.getTotalPage(3));
	}
	
	@Test
	public void testfindById() throws DAOException{
		IRoleDAO dao=(IRoleDAO) DAOFactory.getInstance("IRoleDAO");
		System.out.println(dao.findById(1));
	}
	
	@Test
	public void testDeleteRole() throws DAOException{
		IRoleDAO dao=(IRoleDAO) DAOFactory.getInstance("IRoleDAO");
		dao.deleteRole(46);
	}
}
