package day04;

import java.math.BigDecimal;

/**
 * BigDecimalDemo用于计算更精确的小数
 * 同时也可以表示一个很精确的小数
 * @author Administrator
 *
 */
public class BigDecimalDemo {
	public static void main(String[] args) {
		BigDecimal num1 = new BigDecimal("3.0");
		BigDecimal num2 = new BigDecimal("2.9");
		BigDecimal num3 = num1.subtract(num2);
		System.out.println(num3);
		
		/**
		 * 除法要注意，通常我们会使用除法的重载方法
		 * 添加舍入模式。(四舍五入)
		 * 若不添加这项，那么再遇到两个数相除商为无限小数时
		 * 会一致除下去，直到报错。
		 */
		BigDecimal num4 
				= num1.divide(num2,9,BigDecimal.ROUND_HALF_UP);
		System.out.println(num4);
	}
}





