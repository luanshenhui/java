package com.yulin.am;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Scanner;

public class StringDemo {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		System.out.println("��������");
		String[]emps=new String[0]; 
		Scanner sc=new Scanner(System.in);
		while(2>1){
		System.out.println("��������Ĳ���");
		System.out.println("1�Ĳ���2��ѵ3ͻ��");
		int in=sc.nextInt();
		Date date = new Date();
		if(in==1){
			System.out.println("�����");
			String name =sc.next();
			String timeFomat1="yyyy-���� day hh:mm:ss";
			SimpleDateFormat sos=new SimpleDateFormat(timeFomat1);
			String time=sos.format(date);//��ʱ��ת�����ַ�
			emps=Arrays.copyOf(emps,emps.length+1);//����
			emps[emps.length-1]=name+"@"+time;//ƴ�ӱ���
			System.out.println("����ɹ�");
			System.out.println(name+"@"+time);
		}else if(in==2){
			for(String s :emps){//foreachѭ��
				String[]ss=s.split("@");
				System.out.println("Ա������"+ss[0]);
				System.out.println("��ֻ�Ǽ�"+ss[1]);
				System.out.println("-----------------");
				
			}
		}else if(in==3){
			System.out.println("hangying�´�ʹ��");
			System.exit(0);
			
		}
		
		}
	}

}
