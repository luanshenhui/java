package com.yulin.four;

public class A implements B {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		A a=new A();
		
		System.out.println(a.m(4,6,3,1));

	}

	
	@Override
	public int m(int a, int b) {
		// TODO Auto-generated method stub
		if (a > b) {
			return a;
		}
		return b;
	}

	@Override
	public int m(int a, int b, int c) {
		// TODO Auto-generated method stub
		
		return m(m(a,b),c);
	}

	@Override
	public int m(int a, int b, int c, int d) {
		
		return  m(m(a,b,c),d);
	}


	@Override
	public int m(int a, int b, int c, int d, int e) {
		
		return  m(m(a,b,c,d),e);
	}

}
