package com.zhaoyang;

public class Bank {

	private String name;
	private String password;
	private double money;
	private int id;
	
	public Bank(){
		this(0,"","",0.0);
	}
	public Bank(int id, String name, String password, double money) {
		super();
		this.id=id;
		this.name=name;
		this.password=password;
		this.money=money;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public double getMoney() {
		return money;
	}

	public void setMoney(double money) {
		this.money = money;
	}

	@Override
	public String toString() {
		return this.getId()+","+this.getName()+","+this.getPassword()+","+this.getMoney();
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

}
