package com.yulin.exam;


public class Exam {

	/**
	 * 2014-10-28
	 * 模拟考试系统
	 * 未解决：随机题库 判分方法有问题
	 */
	public static void main(String[] args) {
		Choice[] c=new Choice[3];
/*		c[0]=new SingleChoice(1,"哪个是蔬菜:",new String[]{"A.草莓","B.西红柿","C.香蕉","D.木瓜"},5,"B");
		c[1]=new MultipleChoice(2,"哪个是水果:",new String[]{"A.香蕉","B.草莓","C.香菜","D.油菜"},5,"AB");*/
		//加题
		Paper p = new Paper(c);
//		p.show();
		p.createQusetion();
		p.jiaojuan();
		p.showDefen();

	}

}
