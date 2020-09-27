package day04;
/**
 * 方法(Method)，就是数学函数(Function)
 *  方法: 业务方面： 是功能，是动作，一般采用动词命名
 *   数据层面：是利用算法操作数据模型，实现业务功能
 *   方法就是数据算法。
 * 方法的语法：
 *   1) 方法在类中定义！（不能再方法中定义方法）
 *   2) 方法可以有修饰词 public static(以后在面向对象课程讲)
 *   3) 方法需要声明明确的返回值类型，如果没有返回值void声明
 *   4) 方法有方法名(distance), 习惯上首字母小写，第二个
 *     单词开始首字母大写，如：getUserName()
 *   5) 方法参数列表 (int x1, int y1, int x2, int y2) 
 *     是方法功能实现的前提条件。
 *   6) {} 是方法体，是方法的算法过程语句块
 *     如果方法声明的返回值，必须在方法体使用return 语句
 *     返回数据！
 *   7) 使用方法名调用方法，执行方法的功能。
 */
public class Demo07 {
	public static void main(String[] args) {
		double s = distance(3, 4, 6, 8);//方法的调用
		System.out.println(s); 
		s = distance(0, 0, 5, 5);
		System.out.println(s); 
	}
	/** 计算距离(distance)的方法，封装了计算距离的功能*/
	public static double distance(
			int x1, int y1, int x2, int y2){
		int a = x1-x2; int b = y1-y2;
		return Math.sqrt(a*a + b*b);//返回
	}
}




