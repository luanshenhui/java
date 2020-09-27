package day04;
/**
 * 包装类
 * @author Administrator
 *
 */
public class IntegerDemo {
	public static void main(String[] args) {
		//int的包装类Integer
		Integer i = new Integer(1);
		
		//获取包装类实例保存的基本类型数据
		int a = i.intValue();
		
		System.out.println(a);
	}
}
