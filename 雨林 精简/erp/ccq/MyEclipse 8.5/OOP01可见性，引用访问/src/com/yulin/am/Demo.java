package com.yulin.am;

public class Demo {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		JuXing jx1=new JuXing();//��������
		
		jx1.w=10;
		//System.out.println(jx1.w++);//10
		//System.out.println(jx1.w++);
		//System.out.println(jx1.w++);
		jx1.h=20;
		
		JuXing jx2=jx1;
		//jx2.w--;
		//System.out.println(jx1.w);//10--
		jx2.w++;
		System.out.println(jx2.w);
		System.out.println(jx1.w++);//10++
		System.out.println(jx2.w++);
		System.out.println(jx2.w);
		System.out.println(jx2.w);
//һ���������������������
		//һ������ֻ��ֻ��һ������
	}

}
