package com.b;

public class text {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		A t1=new B();
		t1.m();
		
		//匿名类：实现的过程和创建对象的过程合二为一
		
		A t2=new A(){

			@Override
			public void m() {
				System.out.println("匿名类实现");
				
			}
			
		};//赋值语句=右边给左边要分号结束
		t2.m();
		
		A t3=new A(){

			@Override
			public void m() {
				// TODO Auto-generated method stub
				
			}
			
		};
		
		t3.m();
		
		A t4=new A(){

			@Override
			public void m() {
				// TODO Auto-generated method stub
				
			}
			
		};
	}

}
