package com.yulin.am;

public class Demo1 {
	public static void main(String[] args) {
		SibianXing sbx = new SibianXing();
		// sbx.l=3;
		// sbx.w=4;
		// sbx.h=5;

		sbx.setW(10);//
		// System.println(sbx.w);//私有不能公共访问
		System.out.println(sbx.mj(5));
		System.out.println(sbx.mj(3, 4));
		
		SibianXing sbx1=new SibianXing(5);
		SibianXing sbx2=new SibianXing(3,4);
	}
}