package com.yulin.exam;

public class Exam {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Choice []cs=new Choice[1];
		
		
		cs[0]=new SingleChoice(10,"����ѡB",new String[]{
				"...","B...","c...","D..."
		},5,"B");
		
		
		Paper p=new Paper(cs);
		p.show();
		//p.����();
		//p.��ʾ�÷�();
	//����
		//��ʾ
		//����
		//����
		//��ʾ�÷�
	

	}

}
