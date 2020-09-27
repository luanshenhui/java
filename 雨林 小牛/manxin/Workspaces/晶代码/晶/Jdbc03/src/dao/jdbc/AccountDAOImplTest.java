package dao.jdbc;

import org.junit.Test;

import util.Factory;

import dao.IAccountDAO;
import entity.Account;

public class AccountDAOImplTest {

	@Test
	public void testFindByAccountNo() throws Exception {
		IAccountDAO dao = 
			(IAccountDAO) Factory.getInstance(
					"IAccountDAO");
		Account a = dao.findByAccountNo(
				"6225881003192000");
		System.out.println(a);
	}
	
	@Test
	public void testModify() throws Exception{
		IAccountDAO dao = 
			(IAccountDAO) Factory.getInstance(
					"IAccountDAO");
		Account a = dao.findByAccountNo(
				"6225881003192000");
		a.setBalance(a.getBalance() - 800);
		dao.modify(a);
	}

}
