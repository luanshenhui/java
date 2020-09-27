package service;

import java.util.Random;

import dao.AccountDAO;
import entity.Account;

public class AccountService {
	public String apply(String accountNo,
			double amount) throws Exception{
		/*
		 * step1,看帐号是否存在，如果
		 * 不存在，要提示用户；否则进行下一步。
		 */
		AccountDAO dao = new AccountDAO();
		Account a = dao.findByAccountNo(accountNo);
		if(a == null){
			//帐号不存在,抛出一个自定义异常
			throw new AccountNotExsitException();
		}
		/*
		 * step2,看余额是否充足
		 * 	(贷款的金额 <=余额 * 10)
		 */
		if(a.getBalance() * 10 < amount){
			throw new AccountLimitException();
		}
		/*
		 * step3,生成一个序号
		 */
		Random r = new Random();
		return r.nextInt(10000) + "";
	}
}
