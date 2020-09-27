package com.yulin.exam;
import java.util.*;

/**
 * 类：试卷
 *	属性：选择题[5]		用户答案[5]
 *	方法：显示、答题、交卷、显示得分
 */

public class Paper {
	private Choice[] xuanze;	//选择题
	private String[] yonghu;	//用户答案
	private int score=0;	//等分
	
	public Paper(){}
	 
	public Paper(Choice[] xuanze){
		this.xuanze=xuanze;	
		this.yonghu=new String[xuanze.length];
	}
	
	//显示：利用循环显示选择题
/*	public void show(){
		for(int i=0;i<xuanze.length;i++){
			xuanze[i].show();
			
			yonghu[i]=dati2();
		}
	}*/
	
	//答题：利用Scanner获得用户答案
	public void dati1(){	//一起答题
		Scanner scan = new Scanner(System.in);
		for(int i=0;i<yonghu.length;i++){
			yonghu[i]=scan.next();
		}
	}
	
	public String dati2(){	//逐一答题
		System.out.print("您的答案是:");
		Scanner scan = new Scanner(System.in);
		return scan.next();
	}
	
	//交卷：判卷并且返回得分
	public int jiaojuan(){	
		for(int i=0;i<xuanze.length;i++){
			if(xuanze[in].panDuan(yonghu[in])){
				score+=xuanze[in].getScore();
			}
		}
		return score;
	}
	
	//显示得分：显示最后得分
	String str;	//评判标准
	public void showDefen(){
				
		if(score >= 60 && score < 90){
			System.out.println(str="普通");
		}else if(score >=90){
			System.out.println(str="优秀");
		}else if(score <60){
			System.out.println(str="不及格");
		}
		System.out.println("您最后的得分是:"+score+","+str);
	}
	
	//随机抽出题库中的题,检查题库，不能随机出相同的题
	Random rd = new Random();
	int in = rd.nextInt(3);
	public void createQusetion(){
		QuestionBank qb = new QuestionBank();
		boolean[] bo = new boolean[10];
//		Random rd = new Random();
		
		for(int i=0;i<xuanze.length;i++){
			in = rd.nextInt(3);
			xuanze[in] = qb.c[in];
			xuanze[in].show();		
			yonghu[in]=dati2();
		}
	}
}
