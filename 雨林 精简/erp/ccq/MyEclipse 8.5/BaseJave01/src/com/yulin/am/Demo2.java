package com.yulin.am;

public class Demo2 {
	 public static void main(String[] args){
		// int i;
		 //System.out.println(i);//����ֻ�и�ֵ����ʹ�á�
		// System.out.println(a);//��������֮�����ʹ��
		// int i;ͬһ���������ڣ�ͬһ�������������������
		/* for(int a =0; a<10;a++){
			 System.out.println("ѭ��"+a);
		 }
		 for(int a =0; a<10;a++){
			 System.out.println("ѭ��"+a);
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
	 
	 