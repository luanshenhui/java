package com.a;

public class Text {

	public static void main(String[] args) {		// TODO Auto-generated method stub
		//直接创建对象
		//Person person=new Person();
		//通过反射机制创建对象的方式：(记)
		
			try {
				Class c=Class.forName("com.a.Person");
				Object obj=c.newInstance();
				
				Person per=(Person)obj;
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (InstantiationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		
	}

}
