package dao;

import static org.junit.Assert.*;

import org.junit.Test;

public class AccountDAOTest {

	@Test
	public void testFindByAccountNo() throws Exception {
		AccountDAO dao = new AccountDAO();
		System.out.println(
				dao.findByAccountNo("62251000"));
		
	}

}
