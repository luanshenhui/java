package com.cost.account.action;
import java.sql.Date;

import com.cost.Factory.Factory;
import com.cost.account.Dao.AccountDao;
import com.cost.account.entity.Account;

public class AddAccount {
	private Account account;
	private Date birthdate;
	private int recommender_id;
	private String recommender_no;
	
	public String getRecommender_no() {
		return recommender_no;
	}

	public void setRecommender_no(String recommenderNo) {
		recommender_no = recommenderNo;
	}

	public Date getBirthdate() {
		return birthdate;
	}

	public void setBirthdate(Date birthdate) {
		this.birthdate = birthdate;
	}

	public int getRecommender_id() {
		return recommender_id;
	}

	public void setRecommender_id(int recommenderId) {
		recommender_id = recommenderId;
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
			System.out.println("Recommender_id"+account.getRecommender_id());
			System.out.println("Birthdate "+account.getBirthdate());
			System.out.println("tuijianrenren" + account);
			dao.saveAccount(account);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "success";
	}
}
