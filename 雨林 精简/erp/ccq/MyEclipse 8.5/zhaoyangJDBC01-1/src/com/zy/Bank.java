package com.zy;

public class Bank {
	
	private String name;
	private String password;
	private double money;
	private int id;
	
	
	public Bank() {
		// TODO Auto-generated constructor stub
	}
	
	public Bank(String name, String password) {
		super();
		this.name = name;
		this.password = password;
	}
	
	public Bank(int id, String name, String password, double money) {
		super();
		this.id=id;
		this.name=name;
		this.password=password;
		this.money=money;
	}

	
	public double getMoney() {
		return money;
	}

	public void setMoney(double money) {
		this.money = money;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public String getPassword() {
		return password;
	}



	public void setName(String name) {
		// TODO Auto-generated method stub
		this.name=name;
		
	}

	public void setPassword(String password) {
		// TODO Auto-generated method stub
		this.password=password;
		
	}

	@Override
	public String toString() {
		return "Bank [id=" + id + ", money=" + money + ", name=" + name
				+ ", password=" + password + "]";
	}
	
	

}
