package com.yulin.pm;
import java.util.*;

public class ShulieDemo {

	/**
	 * Ԥ�ȣ�����һ����ݣ��ж��Ƿ�������
	 * ���꣺�ܱ�4���������ܱ�100���������ǿ��Ա�400����
	 * 
	 * ��ϰһ������Ѳ��������е�ǰ20λ
	 * 0,1,1,2,3,5,8,13��21......
	 * ǰ��λ��֪�����дӵ���λ��ʼ
	 * 
	 * ��ϰ�����ж�һ�����Ƿ�������
	 * ������ֻ�ܱ�1����������������
	 */
	public static void main(String[] args) {
		//Ԥ��
		/*Scanner scan = new Scanner(System.in);
		while(true){
			System.out.print("������һ����ݣ�");
			int year=scan.nextInt();
			if(year%4==0 && year%100!=0 || year%400==0){
				System.out.println("���꣡");
				break;
			}
			else{
				System.out.println("����,���������룺");
			}
		}*/
		
		//��ϰ1
	/*	int a=0,b=1,c;//����1
		for(int i=0;i<20;i++){
			c=a+b;
			System.out.println(c);
			a=b;
			b=c;
		}*/
		
		/*int a=0,b=1;//����2
		for(int i=0;i<10;i++){
			a=a+b;
			System.out.println(a);
			b=b+a;
			System.out.println(b);
		}*/
			
		
		//��ϰ2
		/*Scanner scan = new Scanner(System.in);
		System.out.print("������һ�����֣�");
		int number=scan.nextInt();
		int count=0;
		for(int i=1;i<=number;i++)
		{
			if(number%i==0){
				count++;				
			}		
		}
		if(count==2){
			System.out.println("���������������");
		}else{
			System.out.println("������Ĳ�������");
		}*/
		
		//���20�������е�����
	
		
		int count=0;
		for(int i=1;i<=20;i++){
			count = 0;
			for(int j=1;j<=i;j++)
			{
				if(i%j==0){
					count++;				
				}		
			}
			if(count==2){
				System.out.println("����:"+i);
			}
		}
		
		
		

	}

}
