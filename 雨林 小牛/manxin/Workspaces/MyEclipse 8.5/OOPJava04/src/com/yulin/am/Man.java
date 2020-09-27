package com.yulin.am;

public class Man extends Person implements Click{

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		int a = Person.a;
		System.out.println(Person.a());	//抽象类中的static 属性和方法可以使用
	}

	@Override
	public void speak() {
		System.out.println("Hello~");
	}

	@Override
	public void longer() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void pressed() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void songkai() {
		// TODO Auto-generated method stub
		
	}

}
