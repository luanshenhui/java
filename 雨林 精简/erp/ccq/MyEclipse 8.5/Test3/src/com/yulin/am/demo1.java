package com.yulin.am;

import java.util.*;

public class demo1 {
	public static void main(String[] args) {
		for (int kc =50;kc>0;)
			for(int cc =20;cc>0;)
				for(int fc =60;fc>0;)
		{
			System.out.println("��������Ͳ��4Ԫһ�����ڶ������!");
			System.out.println("���"+kc+cc+fc);
			System.out.println("��������Ҫʲôζ��");
			Scanner sc = new Scanner(System.in);
			int in = sc.nextInt();
			in=kc;System.out.print("��Ҫ���ٱ�");
			if(in > kc){
				System.out.println("û��ô��..");
			}else{
				int all = (in % 2 == 0) ? (in / 2 * 6) : (in / 2 * 6 + 4);
				System.out.println("��һ�������ˣ�"+in+"��"+"�ܼ�"+all+"Ԫ");
				kc-=in;
			}
		}System.out.print("���Ѿ����꣬�°�ؼ�");
	}
	}