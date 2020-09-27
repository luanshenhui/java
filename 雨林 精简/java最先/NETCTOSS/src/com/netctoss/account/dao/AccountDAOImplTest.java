package com.netctoss.account.dao;

import org.junit.Test;

import com.netctoss.account.entity.QueryCodi;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class AccountDAOImplTest {

	@Test
	public void testgetTotalPage() throws DAOException {
		IAccountDAO dao=(IAccountDAO) DAOFactory.getInstance("IAccountDAO");
		System.out.println(dao.getTotalPage(null,3));
	}

	@Test
	public void testFindByCondition() {
		IAccountDAO dao=(IAccountDAO) DAOFactory.getInstance("IAccountDAO");
		try {
			//System.out.println(dao.findByCondition(null));
			QueryCodi q=new QueryCodi();
			q.setStatus("1");
			//q.setLoginName("taiji001");
			System.out.println(dao.findByCondition(q,1,3));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
