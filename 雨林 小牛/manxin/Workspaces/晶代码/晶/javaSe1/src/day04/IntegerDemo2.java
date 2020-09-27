package day04;

public class IntegerDemo2 {
	public static void main(String[] args) {
		/**
		 * 包装类对字面量的优化
		 * 使用常量池的方式缓存字面量
		 * 这样在出现重复字面量时，不创建新的对象。
		 */
		Integer a = Integer.valueOf(1);
		Integer b = Integer.valueOf(1);
	
		System.out.println(a == b);
		
	}
}
