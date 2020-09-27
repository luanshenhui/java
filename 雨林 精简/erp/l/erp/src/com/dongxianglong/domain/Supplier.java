/**
 * 
 */
package com.dongxianglong.domain;

/**
 * @author 董祥龙
 *
 * 2015-2-2上午10:57:30
 * 供应商类
 */
public class Supplier extends BaseDomain {
	
	private String name;
	
	private String address;
	
	private String linkman;
	
	private String phone;
	
	private String bank;
	
	private String account;
	
	public Supplier() {
		this("","","","","","");
	}

	public Supplier(String name, String address, String linkman, String phone,
			String bank, String account) {
		super();
		this.name = name;
		this.address = address;
		this.linkman = linkman;
		this.phone = phone;
		this.bank = bank;
		this.account = account;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getLinkman() {
		return linkman;
	}

	public void setLinkman(String linkman) {
		this.linkman = linkman;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getBank() {
		return bank;
	}

	public void setBank(String bank) {
		this.bank = bank;
	}

	public String getAccount() {
		return account;
	}

	public void setAccount(String account) {
		this.account = account;
	}


	public String toString() {
		return "Supplier [account=" + account + ", address=" + address
				+ ", bank=" + bank + ", linkman=" + linkman + ", name=" + name
				+ ", phone=" + phone + "]";
	}
	
	
	

}
