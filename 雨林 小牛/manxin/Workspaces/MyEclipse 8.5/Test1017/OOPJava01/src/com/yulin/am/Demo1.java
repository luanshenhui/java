package com.yulin.am;

public class Demo1 {

	/**
	 * 面向对象基础
	 */
	
	public static void main(String[] args) {
		//JuXing
	/*	JuXing jx1 = new JuXing();	//jx为该对象的一个引用，通过操作这个引用来操作这个对象
		
		jx1.w=10;
		jx1.h=20;
		jx1.mj();
		
		JuXing jx2=jx1;
		
		jx2.w++;
		jx1.w++;
		
		System.out.println(jx1.w);
		System.out.println(jx2.w);*/
		//一个对象可以有无数的引用，一个引用只能指向一个对象
		
		//SiBianXing
		SiBianXing sbx = new SiBianXing();
		
//		sbx.l=20;
//		sbx.w=10;	//私有的属性不能直接访问
//		sbx.h=15;
		
		sbx.setW(10);	//私有的属性可以通过公共的方法来赋值
		
//		System.out.println(sbx.w);	//因为私有，所以不能直接访问
		
		System.out.println(sbx.mj(5));
		System.out.println(sbx.mj(3,4));
		
		SiBianXing sbx1 = new SiBianXing(5);
		SiBianXing sbx2 = new SiBianXing(3,4);

	}

}
