package com.d;

public class A extends Thread {
	private Bank bank;
	public A(Bank bank){
		this.bank=bank;
	}
	
	@Override
	public void run() {
		for(int i=1;i<100;i++){
			bank.getMoney(i);
		}
	}
	

}
