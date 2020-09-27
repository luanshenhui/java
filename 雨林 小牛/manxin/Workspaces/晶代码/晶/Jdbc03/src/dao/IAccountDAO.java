package dao;

import entity.Account;

public interface IAccountDAO {
	public Account findByAccountNo(
			String accountNo) throws Exception;
	public void modify(Account a) throws Exception;
}
