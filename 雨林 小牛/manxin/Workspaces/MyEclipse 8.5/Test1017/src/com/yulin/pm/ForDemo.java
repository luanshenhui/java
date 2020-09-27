package com.yulin.pm;

public class ForDemo {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		/*for(int j=0;j<5;j++){//正三角形
			for(int i=0;i<=j;i++)
			{
				System.out.print("*");
			}
			System.out.println();
		}*/
		/*for(int j=0;j<5;j++){//倒三角形1
			for(int i=5;i>j;i--)
			{
				System.out.print("*");
			}
			System.out.println();
		}*/
		
		/*for(int j=0;j<5;j++){//倒三角形2
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
			//for(int i=0;i<=j;i++)//左侧三角形
			for(int i=0;i<2*j+1;i++)//等腰三角型//
			{
				System.out.print("*");
			}
			System.out.println();
		}*/
		
		/*for(int i=0;i<4;i++)//空心长方形
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
		
		/*for(int i=0;i<5;i++)//空心等腰三角形
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
		
		for(int j=0;j<4;j++){//空心菱形
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
