package com.yulin.exam;


public class Exam {

	/**
	 * 2014-10-28
	 * ģ�⿼��ϵͳ
	 * δ����������� �зַ���������
	 */
	public static void main(String[] args) {
		Choice[] c=new Choice[3];
/*		c[0]=new SingleChoice(1,"�ĸ����߲�:",new String[]{"A.��ݮ","B.������","C.�㽶","D.ľ��"},5,"B");
		c[1]=new MultipleChoice(2,"�ĸ���ˮ��:",new String[]{"A.�㽶","B.��ݮ","C.���","D.�Ͳ�"},5,"AB");*/
		//����
		Paper p = new Paper(c);
//		p.show();
		p.createQusetion();
		p.jiaojuan();
		p.showDefen();

	}

}
