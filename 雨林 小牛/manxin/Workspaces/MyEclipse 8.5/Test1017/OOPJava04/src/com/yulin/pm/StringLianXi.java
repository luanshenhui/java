package com.yulin.pm;
import java.util.*;
import java.lang.*;

public class StringLianXi {
	public static void main(String[] args){
		StringLianXi sl = new StringLianXi();
//		sl.showStr1();
		String str="adv125df";
//		int a = new Integer(Integer.getInteger(str));
		
//		System.out.println(Integer.);
		sl.showStr2();
	}
	
	
	//1.输入一个有0~9组成的字符串，统计每个字符出现的次数
	public void showStr2(){
		Scanner scan = new Scanner(System.in);
		System.out.println("请输入0~9的字符串");
		String in = scan.nextLine();
		char[] ch = {'0','1','2','3','4','5','6','7','8','9'};
		int[] count = new int[10];
		for(int i = 0;i < in.length();i++){
			char c = in.charAt(i);
//			int a = (int)c - 48;	//等值转换
			int a = Integer.parseInt(new String(new char[]{c}));	//Integer的方法
			count[a]++;
		}
		for(int i = 0;i < ch.length;i++){
			System.out.println(ch[i]+"出现的次数是："+count[i]+"次");
		}
	} 	
	
/*	public void showStr2(){
		Scanner scan = new Scanner(System.in);
		System.out.println("请输入0~9的字符串");
		String str = scan.next();
		char[] ch = new char[str.length()];
		int count = 0;
		for(int i = 0;i < str.length();i++){
			ch[i] = str.charAt(i);
		}
		for(int i = 0;i < ch.length;i++){		
			for(int j = 0;j < str.length();j++){
				if(ch[i]-ch[j] == 0){
					count++;
				}
			}
			System.out.println(ch[i]+"出现的次数是："+count);
		//	break;
		}
		
	}*/
	
	//升级版：输入一个字符串，统计每个字符出现的次数
	public void showStr3(){
		Scanner scan = new Scanner(System.in);
		System.out.println("请输入字符串：");
		String in = scan.nextLine();
		char[] ch = new char[0];
		int[] count = new int[0];
		for(int i = 0;i < in.length();i++){
			char c = in.charAt(i);
			int index = check(ch,c);
			if(index !=-1){
				count[index]++;
			}else{	//如果没有 则增添一个字符
				ch=Arrays.copyOf(ch, ch.length+1);
				ch[ch.length-1]=c;
				count=Arrays.copyOf(count, count.length+1);
				count[count.length-1]=1;
			}
		}
		for(int i = 0;i < ch.length;i++){
			System.out.println(ch[i]+"出现的次数是："+count[i]+"次");
		}
	}
	public int check(char[] cs,char c){
		//返回c在cs中的下标
		for(int i =0; i<cs.length;i++){
			if(c==cs[i]){
				return i;
			}
		}
		return -1;	//如果cs中没有c这个字符，则返回-1
	}
	
	//2.输入一个汉字的字符串，如果里面有“共产党”则替换成“***”
/*	public void showStr1(){
		Scanner scan = new Scanner(System.in);
		System.out.println("请输入一串字符：");
		String str = scan.next();
		System.out.println(str.replace("共产党", "***"));
	}*/
	
	//查询Integer和Number API 完成下列需求
	//1.输入一个字符串，取出其中所有的整数，计算出他们的和
	
	//2.输出字符串String str="1+2*3+4"的结果

}
