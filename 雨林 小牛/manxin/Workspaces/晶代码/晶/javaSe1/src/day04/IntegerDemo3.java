package day04;

public class IntegerDemo3 {
	public static void main(String[] args) {
		Integer i = Integer.valueOf(1);
		/**
		 * 手动拆装箱
		 */
		int a = i.intValue();//拆箱		
		Integer c = Integer.valueOf(a);//装箱
		/**
		 * 自动拆装箱
		 */
		int d = i;
		Integer e = 1;
		print(d);
	}
	public static void print(Object o){
	}
}
