package com.yulin.am;
import java.util.*;

public class WhileDemo {

	public static void main(String[] args) {
		/**while ��ϰ���ӿ���̨����������������������������������������Ϊ0ʱ����������
		 * 		�����棺�ӿ���̨����������������������Ϊ0ʱ���������룬������ֵ
		 */
		/*Scanner scan = new Scanner(System.in);
		System.out.println("������һ��������");
		int a=1;
		int max=a;
		while(a!=0){
			a=scan.nextInt();
			if(a>max){
				max=a;
				
			}
			//System.out.println("�����������Ϊ:"+a);
		}
		System.out.println("��������������Ϊ:"+max);*/
		
		/**do while
		 * ��ϰͬ��
		 */
	/*	Scanner scan = new Scanner(System.in);
		System.out.println("������һ������:");
		int a=0;
		int max=0;
		do{
			//����������Է���do����
			a=scan.nextInt();
			if(a>max){
				max=a;
			}
		//	System.out.println("���������������:"+a);
		}while(a!=0);
		System.out.println("���������������ǣ�"+max);*/
		
		/**for ������һ����������������������������룬����������ż��������ѭ��*/
		/*Scanner scan = new Scanner(System.in);
		int in=-1;
		for(System.out.println("������һ�����֣�");in%2!=0;System.out.println("��������һ�����֣�")){
			in=scan.nextInt();
			System.out.println("������������ǣ�"+in);
		}*/
		/**for ���ͼ�� ʵ�ľ��Σ����ǣ������ǣ�����*/
	/*	for(int i=0;i<4;i++){//����
			for(int j=0;j<5;j++){
				System.out.print("*");
			}
			System.out.println();
		}*/
		
	/*	for(int i=0;i<4;i++){//������
			for(int j=0;j<=i;j++)
			{
				System.out.print("*");
			}
			System.out.println();
		}*/
		
	/*	for(int i=0;i<4;i++){//������
			for(int j=0;j<4-i;j++){
				System.out.print("*");
			}
			System.out.println();
		}*/
		
/*		for(int i=0;i<4;i++){//����������
			for(int j=0;j<=i;j++){
				System.out.print(" ");
			}
			for(int j=0;j<4-i;j++){
				System.out.print("*");
			}
			System.out.println();
		}*/
		
/*		for(int i =0;i<4;i++){//��������
			for(int j=0;j<4-i;j++){
				System.out.print(" ");
			}
			for(int j=0;j<2*i+1;j++){
				System.out.print("*");
			}
			System.out.println();
		}*/
		
		/**�˷���
		 */
		for(int i=1;i<=9;i++){
			for(int j=1;j<=i;j++){
				System.out.print(j+"��"+i+"="+(i*j)+"\t");
			}
			System.out.println();
		}
		
		/**			*
		 * 		   * *
		 * 		  *	  *
		 * 		 *******
		 * 		* *   * *				δ���
		 * 	   *   * *   *
		 * 	  *************
		 */
	/*	for(int i=0;i<7;i++){
			for(int j=0;j<7-i;j++){
				System.out.print(".");
			}
			for(int j=0;j<2*i+1;j++){
				if(j==0 || i==6 || j==2*i){
					System.out.print("*");
				}else{
					System.out.print(" ");
				}
			}
			System.out.println();*/
		/*	for(int j=0;j<3;j++){//���Ŀ��ĵ���
			for(int a=0;a<=j+1;a++){
				System.out.print(".");
			}
			for(int a=0;a<5-2*j;a++){
				if(a==0 || a==4-(2*j) || j==0)
				{
					System.out.print("*");
				}else{
					System.out.print(" ");
				}
			}
			System.out.println();
	//	}*/
	
//		}
		
	}

}
