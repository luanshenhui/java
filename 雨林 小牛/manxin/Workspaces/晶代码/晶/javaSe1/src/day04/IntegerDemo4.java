package day04;
/**
 * 包装类的方法
 * @author Administrator
 *
 */
public class IntegerDemo4 {
	public static void main(String[] args) {
		//1 将字符串转换为基本类型数据
		/*
		 * 如果你现在获得的是string那么
		 * 你还想把他转换为int或者其他的基本数据类型的时候
		 * 通过包装类来调用对象的解析方法
		 * 方法里的参数是string类型
		 * 
		 */
		int a = Integer.parseInt("123");
		double d = Double.parseDouble("12.3");
		/**
		 * Integer提供了可以将数字转化为2进制和16进制并用
		 * 字符串去描述
		 */
		String bStr = Integer.toBinaryString(100);
		String hStr = Integer.toHexString(100);
		System.out.println("100的2进制形式:"+bStr);
		System.out.println("100的16进制形式:"+hStr);
		/**
		 * 包装类常用的常量
		 * 最大值
		 * 最小值
		 */
		int max = Integer.MAX_VALUE;
		int min = Integer.MIN_VALUE;
		double dMax = Double.MAX_VALUE;
	}
}





