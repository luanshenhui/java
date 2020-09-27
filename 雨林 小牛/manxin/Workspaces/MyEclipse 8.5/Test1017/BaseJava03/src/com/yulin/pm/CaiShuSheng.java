package com.yulin.pm;
import java.util.*;

public class CaiShuSheng {

	public static void main(String[] args) {
		CaiShuSheng css = new CaiShuSheng();
		css.show();

	}
	
	//随机生成数 不能重复的数组
	private int[] create(){
		Random rd = new Random();
		int[] rand = new int[10];	
		for(int i=0;i<rand.length;i++){
			int in=rd.nextInt(10);//*****注意会忘记
			rand[i]=in;
			for(int j=0;j<i;j++){
				if(rand[j]==in){
					i--;
				}
			}
		}
		return rand;
	}
	
	//输入4个数
	private int[] input(){	
		Scanner scan = new Scanner(System.in);
		int[] input=new int[0];
		System.out.println("请输入1000~9999之间的数字：");
		int in=scan.nextInt();
		int length = Integer.toString(in).length();
		input=Arrays.copyOf(input, length);
		for(int i=input.length-1;i>=0;i--){
			input[i]=in%10;
			in/=10;
		}
		
		return input;
	}
	
	//验证数对
	private int check1(int[] rand,int[] input){
		int count=0;
		for(int i=0;i<rand.length;i++){
			for(int j=0;j<input.length;j++){
				if(rand[i]==input[j]){
					count++;
					break;
				}
			}
		}
		return count;
	}
	
	//验证数和位置都对
	private int check2(int[] rand,int[] input){
		int count=0;
		System.out.println(rand.length+","+input.length);
		for(int i=0;i<rand.length;i++){
			if(rand[i]==input[i]){
				count++;
			}
		}
		return count;
	}
	
	//选择难度 随机生成数组
	int level=0;
	private int[] select1(){
		System.out.println("请选择难度：1.简单 2.中级 3.困难 4.大师");
		Scanner scan = new Scanner(System.in);
		int in=scan.nextInt();
		int[] rand=create();	
		if(in==1){
			rand=Arrays.copyOf(rand, 4);
			level=4;
		}else if(in==2){
			rand=Arrays.copyOf(rand, 6);
			level=6;
		}else if(in==3){
			rand=Arrays.copyOf(rand, 8);
			level=8;
		}else if(in==4){
			rand=Arrays.copyOf(rand, 10);
			level=10;
		}
		return rand;
	}
	
	//组装方法
	public void show(){
		System.out.println("~~~~~~~~~游戏开始~~~~~~~~~");
		int[] rand=select1();
		System.out.println(Arrays.toString(rand));
		int[] input=input();
		System.out.println(Arrays.toString(input));
		int count=1;
		while(true){
			int a=check1(rand, input);
			int b=check2(rand, input);
			System.out.println(a+","+b);
			if(b==level){
				System.out.println("游戏结束！");
				System.out.println("您一共猜了："+count+"次");
				break;
			}else{
				input=input();
				count++;
			}
		}
	}
	
	
	
	
	

}
