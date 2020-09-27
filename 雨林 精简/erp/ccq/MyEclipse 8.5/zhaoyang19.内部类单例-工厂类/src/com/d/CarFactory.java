package com.d;

public class CarFactory {

	public static Car getCar(String s) {
		// TODO Auto-generated method stub
		if(s.equals("1")){
			return new Audi();
		}else if(s.equals("2")){
			return new Benz();
		}
		return null;
	}

}
