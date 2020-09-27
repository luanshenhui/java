package service;

import java.util.Random;

import dao.AccountDAO;
import entity.Account;

public class AccountService {
	public String apply(String accountNo,
			double amount) throws Exception{
		/*
		 * step1,���ʺ��Ƿ���ڣ����
		 * �����ڣ�Ҫ��ʾ�û������������һ����
		 */
		AccountDAO dao = new AccountDAO();
		Account a = dao.findByAccountNo(accountNo);
		if(a == null){
			//�ʺŲ�����,�׳�һ���Զ����쳣
			throw new AccountNotExsitException();
		}
		/*
		 * step2,������Ƿ����
		 * 	(����Ľ�� <=��� * 10)
		 */
		if(a.getBalance() * 10 < amount){
			throw new AccountLimitException();
		}
		/*
		 * step3,����һ�����
		 */
		Random r = new Random();
		return r.nextInt(10000) + "";
	}
}
