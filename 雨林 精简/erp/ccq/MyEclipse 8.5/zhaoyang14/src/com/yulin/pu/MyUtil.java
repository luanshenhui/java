package com.yulin.pu;

public class MyUtil {
	public MyUtil() {

	}

	public static void write(P p) {//改成farther类也行
		//p.print();
		System.out.println(p.toString());
		System.out.println(p);
		
		//打印的时候会自动调用toString

	}

}
