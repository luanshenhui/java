package com.yulin.am;

public class Demo1 {

	/**
	 * ����������
	 */
	
	public static void main(String[] args) {
		//JuXing
	/*	JuXing jx1 = new JuXing();	//jxΪ�ö����һ�����ã�ͨ��������������������������
		
		jx1.w=10;
		jx1.h=20;
		jx1.mj();
		
		JuXing jx2=jx1;
		
		jx2.w++;
		jx1.w++;
		
		System.out.println(jx1.w);
		System.out.println(jx2.w);*/
		//һ��������������������ã�һ������ֻ��ָ��һ������
		
		//SiBianXing
		SiBianXing sbx = new SiBianXing();
		
//		sbx.l=20;
//		sbx.w=10;	//˽�е����Բ���ֱ�ӷ���
//		sbx.h=15;
		
		sbx.setW(10);	//˽�е����Կ���ͨ�������ķ�������ֵ
		
//		System.out.println(sbx.w);	//��Ϊ˽�У����Բ���ֱ�ӷ���
		
		System.out.println(sbx.mj(5));
		System.out.println(sbx.mj(3,4));
		
		SiBianXing sbx1 = new SiBianXing(5);
		SiBianXing sbx2 = new SiBianXing(3,4);

	}

}
