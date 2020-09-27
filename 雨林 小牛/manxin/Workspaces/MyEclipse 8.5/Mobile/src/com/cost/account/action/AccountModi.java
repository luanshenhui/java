package com.cost.account.action;

import com.cost.Factory.Factory;
import com.cost.account.Dao.AccountDao;
import com.cost.account.entity.Account;

public class AccountModi {
	private int id;
	private Account account;
	private String recommender_no;

	public String getRecommender_no() {
		return recommender_no;
	}

	public void setRecommender_no(String recommenderNo) {
		recommender_no = recommenderNo;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public Account getAccount() {
		return account;
	}

	public void setAccount(Account account) {
		this.account = account;
	}

	public String execute(){
		AccountDao dao = (AccountDao) Factory.getInstance("AccountDao");
		try {
			account = dao.findById(id);
			recommender_no = dao.findById(account.getRecommender_id()).getIdcard_no();
			account = dao.findById(id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "success";
	}
}
