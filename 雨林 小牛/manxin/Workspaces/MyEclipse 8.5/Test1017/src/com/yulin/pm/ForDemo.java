package com.yulin.pm;

public class ForDemo {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		/*for(int j=0;j<5;j++){//��������
			for(int i=0;i<=j;i++)
			{
				System.out.print("*");
			}
			System.out.println();
		}*/
		/*for(int j=0;j<5;j++){//��������1
			for(int i=5;i>j;i--)
			{
				System.out.print("*");
			}
			System.out.println();
		}*/
		
		/*for(int j=0;j<5;j++){//��������2
			for(int i=0;i<5-j;i++)
			{
				System.out.print("*");
			}
			System.out.println();
		}*/
		
		/*for(int j=0;j<5;j++){
			for(int i=0;i<5-j;i++)
			{
				System.out.print(".");
			}
			//for(int i=0;i<=j;i++)//���������
			for(int i=0;i<2*j+1;i++)//����������//
			{
				System.out.print("*");
			}
			System.out.println();
		}*/
		
		/*for(int i=0;i<4;i++)//���ĳ�����
		{
			for(int j=0;j<6;j++)
			{
				if(i==0 || i==3 || j==0 || j==5)
				{
					System.out.print("*");
				}else{
					System.out.print(" ");
				}
			}
			System.out.println();
		}*/
		
		/*for(int i=0;i<5;i++)//���ĵ���������
		{
			for(int j=0;j<5-i;j++){
				System.out.print(" ");
			}
			for(int j=0;j<2*i+1;j++){
				if(i==4 || i==0 || j==0 || j==2*i){
					System.out.print("*");
				}else{
				System.out.print(" ");
				}
			}
			System.out.println();
		}*/
		
		for(int j=0;j<4;j++){//��������
			for(int i=0;i<4-j;i++){
				System.out.print(" ");
			}
			for(int i=0;i<2*j+1;i++)
			{
				if(j==0 || i==0 || i==2*j){
					System.out.print("*");
				}else{
					System.out.print(" ");
				}
			}
			System.out.println();
		}
		for(int j=0;j<3;j++){
			for(int i=0;i<=j+1;i++){
				System.out.print(" ");
			}
			for(int i=0;i<5-2*j;i++){
				if(i==0 || i==4-(2*j))
				{
					System.out.print("*");
				}else{
					System.out.print(" ");
				}
			}
			System.out.println();
		}


	}

}
