package com.cost.account.action;

import com.cost.Factory.Factory;
import com.cost.account.Dao.AccountDao;
import com.cost.account.entity.Account;

public class CheckRecommender {
	
	private String recommender;
	private Account account;

	public Account getAccount() {
		return account;
	}
	public void setAccount(Account account) {
		this.account = account;
	}
	public String getRecommender() {
		return recommender;
	}
	public void setRecommender(String recommender) {
		this.recommender = recommender;
	}
	
	public String execute(){
		AccountDao dao = (AccountDao) Factory.getInstance("AccountDao");
		try {
			account = dao.findByIdcardNo(recommender);
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
