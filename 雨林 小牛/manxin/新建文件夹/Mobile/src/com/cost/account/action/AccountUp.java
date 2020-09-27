package com.cost.account.action;


import java.sql.Date;

import com.cost.Factory.Factory;
import com.cost.account.Dao.AccountDao;
import com.cost.account.entity.Account;

public class AccountUp {
	private int id;
	private int recommender_id;
	private String login_name;
	private String login_newpwd;//新密码的文本框
	private String real_name;
	private String idcard_no;
	private Date birthdate;
	private String gender;
	private String occupation;
	private String telephone;
	private String email;
	private String mailaddress;
	private String zipcode;
	private String qq;
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

	public int getRecommender_id() {
		return recommender_id;
	}

	public void setRecommender_id(int recommenderId) {
		recommender_id = recommenderId;
	}

	public String getLogin_name() {
		return login_name;
	}

	public void setLogin_name(String loginName) {
		login_name = loginName;
	}

	public String getLogin_passwd() {
		return login_newpwd;
	}

	public void setLogin_passwd(String loginPasswd) {
		login_newpwd = loginPasswd;
	}

	public String getReal_name() {
		return real_name;
	}

	public void setReal_name(String realName) {
		real_name = realName;
	}

	public String getIdcard_no() {
		return idcard_no;
	}

	public void setIdcard_no(String idcardNo) {
		idcard_no = idcardNo;
	}

	public Date getBirthdate() {
		return birthdate;
	}

	public void setBirthdate(Date birthdate) {
		this.birthdate = birthdate;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getOccupation() {
		return occupation;
	}

	public void setOccupation(String occupation) {
		this.occupation = occupation;
	}

	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getMailaddress() {
		return mailaddress;
	}

	public void setMailaddress(String mailaddress) {
		this.mailaddress = mailaddress;
	}

	public String getZipcode() {
		return zipcode;
	}

	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}

	public String getQq() {
		return qq;
	}

	public void setQq(String qq) {
		this.qq = qq;
	}

	public String execute(){
		AccountDao dao = (AccountDao) Factory.getInstance("AccountDao");
		Account account = new Account();
		account.setId(id);
		account.setRecommender_id(recommender_id);
		account.setLogin_name(login_name);
		account.setLogin_passwd(login_newpwd);
		System.out.println(login_newpwd);//测试
		account.setReal_name(real_name);
		account.setIdcard_no(idcard_no);
		account.setBirthdate(birthdate);
		account.setGender(gender);
		account.setOccupation(occupation);
		account.setTelephone(telephone);
		account.setEmail(email);
		account.setMailaddress(mailaddress);
		account.setZipcode(zipcode);
		account.setQq(qq);
		try {
			Account a = dao.findById(account.getId());
			recommender_no = dao.findById(a.getRecommender_id()).getIdcard_no();
			System.out.println(recommender_no);
			dao.upAccount(account);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "success";
	}
}
