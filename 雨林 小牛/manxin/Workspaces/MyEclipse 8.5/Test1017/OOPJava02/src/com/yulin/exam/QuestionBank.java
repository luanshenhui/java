package com.yulin.exam;

/**
 * ���
 */
public class QuestionBank {

	Choice[] c = new Choice[10];
	// int in=0; //��¼������±�
	{
		c[0] = new SingleChoice(1, "�ĸ����߲�:", new String[] { "A.��ݮ", "B.������",
				"C.�㽶", "D.ľ��" }, 10, "B");
		c[1] = new MultipleChoice(2, "�ĸ���ˮ��:", new String[] { "A.�㽶", "B.��ݮ",
				"C.���", "D.�Ͳ�" }, 10, "AB");
		c[2] = new MultipleChoice(3, "�ĸ��ǿ���:", new String[] { "A.����", "B.Ħ��",
				"C.���", "D.�̲�" }, 10, "AB");
		c[3] = new MultipleChoice(4, "�ĸ��ǹ�֭:", new String[] { "A.��֭", "B.ƻ��֭",
				"C.�̲�", "D.����" }, 10, "AB");
		c[4] = new MultipleChoice(5, "�ĸ����߲�:", new String[] { "A.���", "B.�Ͳ�",
				"C.�㽶", "D.��ݮ" }, 10, "AB");
		c[5] = new MultipleChoice(6, "�ĸ�����:", new String[] { "A.����", "B.����",
				"C.����", "D.è" }, 10, "ABC");
		c[6] = new SingleChoice(7, "�ĸ���ˮ��:", new String[] { "A.��ݮ", "B.������",
				"C.���", "D.�۲�" }, 10, "B");
		c[7] = new SingleChoice(8, "�ĸ��ǿ���:", new String[] { "A.�̲�", "B.����",
				"C.���", "D.�ײ�" }, 10, "B");
		c[8] = new SingleChoice(9, "�ĸ��ǹ�֭:", new String[] { "A.����", "B.��֭",
				"C.�̲�", "D.�̲�" }, 10, "B");
		c[9] = new SingleChoice(10, "�ĸ�����:", new String[] { "A.����", "B.�ȴ���",
				"C.è", "D.��" }, 10, "B");
	}

}
