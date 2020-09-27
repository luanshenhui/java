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
		
		//3主要解决解耦问题，可以定义一个工厂类用于生产接口中的所有实现类
		Car car=CarFactory.getCar("1");
		car.driver();

	}

}
