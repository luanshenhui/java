package com.d;

public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
//		//1
//		Audi audi=new Audi();
//		audi.driver();
//		
//		//2
//		Car car=new Audi();
//		car.driver();
		
		//3��Ҫ����������⣬���Զ���һ�����������������ӿ��е�����ʵ����
		Car car=CarFactory.getCar("1");
		car.driver();

	}

}
