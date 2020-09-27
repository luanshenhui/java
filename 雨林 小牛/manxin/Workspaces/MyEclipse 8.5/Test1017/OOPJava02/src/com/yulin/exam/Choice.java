package com.yulin.exam;

public class Choice {
	
	/**
	 * 模拟考试系统
	 *   父类：考题
	 *		属性：题干、选项、分数
	 *		方法：显示
	 */
	
	private int tihao;	//题号
	private String tigan;	//题干
	private String[] options = new String[4];	//选项 ABCD
	private int score;	//分数
	
	//显示
	public void show(){
		System.out.println(tihao+"."+tigan);
		System.out.println("   "+options[0]);
		System.out.println("   "+options[1]);
		System.out.println("   "+options[2]);
		System.out.println("   "+options[3]);	
	}
	
	//构造方法
	public Choice(){}//无参构造,
	
	//重载构造方法,有参构造方法
	public Choice(int tihao,String tigan,String[] options,int score){
		this.tihao = tihao;
		this.tigan = tigan;
		this.options = options;
		this.score = score;
	}
	
	//获得得分
	public int getScore(){
		return this.score;
	}

	public boolean panDuan(String string) {
		// TODO Auto-generated method stub
		return false;
	}

}
