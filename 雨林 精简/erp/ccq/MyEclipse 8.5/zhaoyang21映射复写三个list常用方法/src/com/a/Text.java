package com.a;

public class Text {

	public static void main(String[] args) {		// TODO Auto-generated method stub
		//ֱ�Ӵ�������
		//Person person=new Person();
		//ͨ��������ƴ�������ķ�ʽ��(��)
		
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
