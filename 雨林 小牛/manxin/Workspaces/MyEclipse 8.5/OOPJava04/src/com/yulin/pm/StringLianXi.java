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
	
	
	//1.����һ����0~9��ɵ��ַ�����ͳ��ÿ���ַ����ֵĴ���
	public void showStr2(){
		Scanner scan = new Scanner(System.in);
		System.out.println("������0~9���ַ���");
		String in = scan.nextLine();
		char[] ch = {'0','1','2','3','4','5','6','7','8','9'};
		int[] count = new int[10];
		for(int i = 0;i < in.length();i++){
			char c = in.charAt(i);
//			int a = (int)c - 48;	//��ֵת��
			int a = Integer.parseInt(new String(new char[]{c}));	//Integer�ķ���
			count[a]++;
		}
		for(int i = 0;i < ch.length;i++){
			System.out.println(ch[i]+"���ֵĴ����ǣ�"+count[i]+"��");
		}
	} 	
	
/*	public void showStr2(){
		Scanner scan = new Scanner(System.in);
		System.out.println("������0~9���ַ���");
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
			System.out.println(ch[i]+"���ֵĴ����ǣ�"+count);
		//	break;
		}
		
	}*/
	
	//�����棺����һ���ַ�����ͳ��ÿ���ַ����ֵĴ���
	public void showStr3(){
		Scanner scan = new Scanner(System.in);
		System.out.println("�������ַ�����");
		String in = scan.nextLine();
		char[] ch = new char[0];
		int[] count = new int[0];
		for(int i = 0;i < in.length();i++){
			char c = in.charAt(i);
			int index = check(ch,c);
			if(index !=-1){
				count[index]++;
			}else{	//���û�� ������һ���ַ�
				ch=Arrays.copyOf(ch, ch.length+1);
				ch[ch.length-1]=c;
				count=Arrays.copyOf(count, count.length+1);
				count[count.length-1]=1;
			}
		}
		for(int i = 0;i < ch.length;i++){
			System.out.println(ch[i]+"���ֵĴ����ǣ�"+count[i]+"��");
		}
	}
	public int check(char[] cs,char c){
		//����c��cs�е��±�
		for(int i =0; i<cs.length;i++){
			if(c==cs[i]){
				return i;
			}
		}
		return -1;	//���cs��û��c����ַ����򷵻�-1
	}
	
	//2.����һ�����ֵ��ַ�������������С������������滻�ɡ�***��
/*	public void showStr1(){
		Scanner scan = new Scanner(System.in);
		System.out.println("������һ���ַ���");
		String str = scan.next();
		System.out.println(str.replace("������", "***"));
	}*/
	
	//��ѯInteger��Number API �����������
	//1.����һ���ַ�����ȡ���������е���������������ǵĺ�
	
	//2.����ַ���String str="1+2*3+4"�Ľ��

}
