package com.netctoss.service.dao;

import org.junit.Test;

import com.netctoss.exception.DAOException;
import com.netctoss.service.entity.QueryCodi;
import com.netctoss.util.DAOFactory;

public class ServiceDAOImplTest {

	@Test
	public void testFindByCodition() throws DAOException {
		IServiceDAO dao=(IServiceDAO) DAOFactory.getInstance("IServiceDAO");
		QueryCodi q=new QueryCodi();
		q.setIdcardNo("330682196903190613");
		System.out.println(dao.findByCodition(null, 1, 3));
	}
	@Test
	public void testgetTotalPage() throws DAOException {
		IServiceDAO dao=(IServiceDAO) DAOFactory.getInstance("IServiceDAO");
		QueryCodi q=new QueryCodi();
		q.setIdcardNo("330682196903190613");
		System.out.println(dao.getTotalPage(q, 3));
	}
	
	@Test
	public void testfindById() throws DAOException {
		IServiceDAO dao=(IServiceDAO) DAOFactory.getInstance("IServiceDAO");
		System.out.println(dao.findById(2008));
	}
}
