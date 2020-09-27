package com.d;

public class Bank {
	private int money;
	
	public Bank(int money){
		this.money=money;
	}
	public  void getMoney(int m){
		if(m<money){
			try {
				Thread.sleep(1000);//让当前线程停10s种
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			money=money-m;
			System.out.println("余额"+money);
		}else{
			System.out.println("余额不足");
		}
	}
	public static void main(String[] args) {
//		Bank bank=new Bank(100);
//		for(int i=1;i<100;i++){
//			bank.getMoney(i);
//		}
		
		Bank bank=new Bank(100);
		A a1=new A(bank);
		a1.start();
		
		A a2=new A(bank);
		a2.start();
		
	}
}
