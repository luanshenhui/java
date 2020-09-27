package com.yulin.am;

public class Demo3 {
	public static void main(String[] args){
	
	int i = 12345;
	int a =0;
	 a= a*10+i%10;//5
	 i = i/10;//1234
	 a=a*10+i%10;//54
	 i = i/10;
	 a=a*10+i%10;//543;
	 i = i/10;
	 a=a*10+i%10;//5432
	 i = i/10;
	 a=a*10+i%10;
	 System.out.println(a);

}
}