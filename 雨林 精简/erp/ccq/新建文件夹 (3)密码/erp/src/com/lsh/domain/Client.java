/**
 * 
 */
package com.lsh.domain;

/**
 * @author 栾慎辉
 *
 * 2015-2-2上午11:09:31
 * 
 * 客户表
 */
public class Client extends BaseDomain {
	private String name;
	private String address;
	private String linkman;
	private long phone;
	private String bank;
	private long account;
	
	
	public Client() {
		this("","","",0,"",0);
	}
	public Client(String name, String address, String linkman, long phone,
			String bank, long account) {
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
	public long getPhone() {
		return phone;
	}
	public void setPhone(long phone) {
		this.phone = phone;
	}
	public String getBank() {
		return bank;
	}
	public void setBank(String bank) {
		this.bank = bank;
	}
	public long getAccount() {
		return account;
	}
	public void setAccount(long account) {
		this.account = account;
	}
	@Override
	public String toString() {
		return "Client [account=" + account + ", address=" + address
				+ ", bank=" + bank + ", linkman=" + linkman + ", name=" + name
				+ ", phone=" + phone + "]";
	}
	
}
