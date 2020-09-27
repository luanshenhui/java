package com.yulin.exam;

/**
 * 题库
 */
public class QuestionBank {

	Choice[] c = new Choice[10];
	// int in=0; //记录数组的下标
	{
		c[0] = new SingleChoice(1, "哪个是蔬菜:", new String[] { "A.草莓", "B.西红柿",
				"C.香蕉", "D.木瓜" }, 10, "B");
		c[1] = new MultipleChoice(2, "哪个是水果:", new String[] { "A.香蕉", "B.草莓",
				"C.香菜", "D.油菜" }, 10, "AB");
		c[2] = new MultipleChoice(3, "哪个是咖啡:", new String[] { "A.拿铁", "B.摩卡",
				"C.红茶", "D.绿茶" }, 10, "AB");
		c[3] = new MultipleChoice(4, "哪个是果汁:", new String[] { "A.橙汁", "B.苹果汁",
				"C.奶茶", "D.咖啡" }, 10, "AB");
		c[4] = new MultipleChoice(5, "哪个是蔬菜:", new String[] { "A.香菜", "B.油菜",
				"C.香蕉", "D.草莓" }, 10, "AB");
		c[5] = new MultipleChoice(6, "哪个是鱼:", new String[] { "A.鳗鱼", "B.草鱼",
				"C.鲤鱼", "D.猫" }, 10, "ABC");
		c[6] = new SingleChoice(7, "哪个是水果:", new String[] { "A.草莓", "B.西红柿",
				"C.香菜", "D.芹菜" }, 10, "B");
		c[7] = new SingleChoice(8, "哪个是咖啡:", new String[] { "A.绿茶", "B.拿铁",
				"C.红茶", "D.白茶" }, 10, "B");
		c[8] = new SingleChoice(9, "哪个是果汁:", new String[] { "A.咖啡", "B.橙汁",
				"C.奶茶", "D.绿茶" }, 10, "B");
		c[9] = new SingleChoice(10, "哪个是鱼:", new String[] { "A.猩猩", "B.热带鱼",
				"C.猫", "D.狗" }, 10, "B");
	}

}
