package com.yulin.exam;
import java.io.*;
/**
 * 抽象父类
 * 属性：题号、题干、分数
 * 抽象方法：显示：用来显示试题；判断对错：返回得分
 */
public abstract class Question {
	private int 题号;
	private String 题干;
	private int 分数;
	
	public int get题号() {
		return 题号;
	}

	public void set题号(int 题号) {
		this.题号 = 题号;
	}

	public String get题干() {
		return 题干;
	}

	public void set题干(String 题干) {
		this.题干 = 题干;
	}

	public int get分数() {
		return 分数;
	}

	public void set分数(int 分数) {
		this.分数 = 分数;
	}
	
	public Question(){}
	
	public Question(String 题干, int 分数){ 
		super();
		this.题干 = 题干;
		this.分数 = 分数;
	}
	
	public abstract void 显示();
	
	public abstract int 判断(String 用户答案);
	
}
