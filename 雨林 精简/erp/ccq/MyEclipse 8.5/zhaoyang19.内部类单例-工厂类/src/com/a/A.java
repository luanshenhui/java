package com.a;

public class A {

	/**
	 * Ƕ���ࣺ���������ж�����
	 *    ��̬Ƕ����static�������ֺ�����
	 *    �Ǿ�̬Ƕ���ࣺ�ڲ���һ��ָ����
	 *          1����Ա�ڲ���
	 *          2���ֲ��ڲ��ࣺ�������涨��
	 *          3�������ڲ���
	 *          
	 *��һ���ļ�����Զ������࣬��ֻ����һ��public���β����ļ�����ͬ          
	 *          
	 */
	
	static class B{
		
	}
	
	class C{
		
	}
	
	public void m(){
		class D{
		}
		D d=new D();//�۶���
	}
	public static void main(String[] args) {
		//�� ������̬Ƕ�������
		A.B b=new A.B();//��������ܴ�������A,��̬�����
		
		
		//�ڴ����Ǿ�̬��Ƕ��
		A a=new A();//�Ǿ�̬Ҫ�ȴ�������
		A.C c=a.new C();
	}

}
