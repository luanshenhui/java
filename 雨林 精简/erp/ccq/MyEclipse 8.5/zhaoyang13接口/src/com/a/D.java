package com.a;

public class D extends F implements A,E{

	@Override
	public void m() {
		// TODO Auto-generated method stub
		System.out.println("实现方法");
	}

	@Override
	public boolean ma() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public void m2() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void m3() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void me() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public boolean ma(int a, int b) {
		// TODO Auto-generated method stub
		return false;
	}
	public static void main(String[] args) {
		D d=new D();
		d.m2();
	}

}
