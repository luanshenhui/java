package com.yulin.pm;
import java.util.*;

public class CaiShuAnli {
	/**
	 * 猜数字游戏：
		1.随机生成4个个位数
		2.向控制台输入你猜的数
		3.显示你猜的结果a,b
		4.a表示数对的个数
		5.b表示，数和位置都对的个数
		6.全部猜中游戏结束，显示猜的次数
		
		升级：选择游戏等级，简单，中级，困难，大师，分别猜4,6,8,10个数字
	 */
	public static void main(String[] args) {
		CaiShuAnli cs = new CaiShuAnli();
		cs.start();
	}
	
	private int check1(int[] rand,int[] input){	//用来校验数对的个数
		int count=0; //记录个数
		for(int i=0;i<rand.length;i++){
			for(int j=0;j<input.length;j++){
				if(rand[i]==input[j]){
					count++;
					break;  //结束最近的循环
				}
			}
		}
		return count;
	}
	
	private int check2(int[] rand,int[] input){	//用来校验数和位置都对的个数
		int count=0;
		for(int i=0;i<rand.length;i++){
			if(rand[i]==input[i]){
				count++;
			}
		}
		return count;
	}
	
	private int[] create(){	//随机生成一个长度为4的整数数组，元素的值为0~9
		Random rd = new Random();
		int[] rand=new int[4];
		for(int i=0;i<rand.length;i++){
			rand[i]=rd.nextInt(10);
		}
		return rand;
	}
	
	private int[] input(){	//从控制台输入一个长度为4的整数数组，元素的值为0~9
		int[] input=new int[4];
		Scanner scan = new Scanner(System.in);
		System.out.println("输入1000~9999中的一个数：");
		int in=scan.nextInt();
		for(int i=3;i>=0;i--){
			input[i]=in%10;	//拆分4位数
			in/=10;
		}
		return input;	
	}
	
	public void start(){	//组装方法
		System.out.println("~~~~~~~游戏开始~~~~~~");
		int[] rand = create();	//通过create方法创建一个数组
		System.out.println(Arrays.toString(rand));
		int[] input=input();	//通过input方法创建一个数组
		System.out.println(Arrays.toString(input));
		int count=1;	//从第一次开始猜算起
		while(true){
			int a=this.check1(rand, input);
			int b=this.check2(rand, input);
			System.out.println(a+","+b);
			if(b==4){
				System.out.println("游戏结束！");
				System.out.println("您一共猜了"+count+"次");
				break;
			}else{
				count++;
				input=input();	//如果没全猜中，则继续输入
			}
		}		
	}
}
