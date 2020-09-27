package com.yulin.exam;

public class Exam {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Choice []cs=new Choice[1];
		
		
		cs[0]=new SingleChoice(10,"这题选B",new String[]{
				"...","B...","c...","D..."
		},5,"B");
		
		
		Paper p=new Paper(cs);
		p.show();
		//p.交卷();
		//p.显示得分();
	//加题
		//显示
		//答题
		//交卷
		//显示得分
	

	}

}
