package com.b;

public class text {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		A t1=new B();
		t1.m();
		
		//�����ࣺʵ�ֵĹ��̺ʹ�������Ĺ��̺϶�Ϊһ
		
		A t2=new A(){

			@Override
			public void m() {
				System.out.println("������ʵ��");
				
			}
			
		};//��ֵ���=�ұ߸����Ҫ�ֺŽ���
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
