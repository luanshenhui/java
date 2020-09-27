package com.yulin.am;

public class Demo2 {
	 public static void main(String[] args){
		// int i;
		 //System.out.println(i);//变量只有赋值才能使用。
		// System.out.println(a);//变量声明之后才能使用
		// int i;同一个作用域内，同一个变量名不能声明多次
		/* for(int a =0; a<10;a++){
			 System.out.println("循环"+a);
		 }
		 for(int a =0; a<10;a++){
			 System.out.println("循环"+a);
			 }*/
		/* int a =3,b=5,c;
		 c=a;a=b;b=c;
			 System.out.println(b);
		
		System.out.println(a);
 	 }*/
	 int i = 12345;
	 
	 int a =0;
	 a= a*10+i%10;//5
	 i = i/10;
	 a=a*10+i%10;//54
	 i = i/10;
	 a =a*10+i%10;//543;
	 i = i/10;
	 a=a*10+i%10;//5432
	 
	 System.out.println(a);
	 
	 
	 
	 
	 
	 int b =i%10;//5
	 i=i/10;//1234
	 int c=i%10;//4
	 i = i/10;//123

	 
}

} 
	 
	 