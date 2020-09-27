package com.b;

public class B {
public static void m(int money) throws MyException{
	if(money>100){
		throw new MyException("ÄãµÄÇ®Óà¶î²»×ã!!");
	}
}
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try {
			m(500);
		} catch (MyException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
