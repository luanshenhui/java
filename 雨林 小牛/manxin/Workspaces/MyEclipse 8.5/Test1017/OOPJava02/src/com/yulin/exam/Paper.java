package com.yulin.exam;
import java.util.*;

/**
 * �ࣺ�Ծ�
 *	���ԣ�ѡ����[5]		�û���[5]
 *	��������ʾ�����⡢������ʾ�÷�
 */

public class Paper {
	private Choice[] xuanze;	//ѡ����
	private String[] yonghu;	//�û���
	private int score=0;	//�ȷ�
	
	public Paper(){}
	 
	public Paper(Choice[] xuanze){
		this.xuanze=xuanze;	
		this.yonghu=new String[xuanze.length];
	}
	
	//��ʾ������ѭ����ʾѡ����
/*	public void show(){
		for(int i=0;i<xuanze.length;i++){
			xuanze[i].show();
			
			yonghu[i]=dati2();
		}
	}*/
	
	//���⣺����Scanner����û���
	public void dati1(){	//һ�����
		Scanner scan = new Scanner(System.in);
		for(int i=0;i<yonghu.length;i++){
			yonghu[i]=scan.next();
		}
	}
	
	public String dati2(){	//��һ����
		System.out.print("���Ĵ���:");
		Scanner scan = new Scanner(System.in);
		return scan.next();
	}
	
	//�����о��ҷ��ص÷�
	public int jiaojuan(){	
		for(int i=0;i<xuanze.length;i++){
			if(xuanze[in].panDuan(yonghu[in])){
				score+=xuanze[in].getScore();
			}
		}
		return score;
	}
	
	//��ʾ�÷֣���ʾ���÷�
	String str;	//���б�׼
	public void showDefen(){
				
		if(score >= 60 && score < 90){
			System.out.println(str="��ͨ");
		}else if(score >=90){
			System.out.println(str="����");
		}else if(score <60){
			System.out.println(str="������");
		}
		System.out.println("�����ĵ÷���:"+score+","+str);
	}
	
	//����������е���,�����⣬�����������ͬ����
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
