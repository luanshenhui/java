package day02;
/**
 * 构造器，构造方法
 * 用于创建并且初始化对象（初始化属性）
 *  
 *  构造器方法 和 方法的差别
 *  都在类中定义，都可以重载（一个类有多个构造器）
 *  
 * 构造器方法：业务: 构造器描述对象的创建和初始化过程
 *    语法: 名称与类名一致,不能定义返回值,使用new运算符调用
 * 方法: 业务:是对象的行为（功能）
 *    语法：名称与类型不同，一定定义返回值,使用对象引用调用
 */
public class Demo04 {
	public static void main(String[] args) {
		Point p1 = new Point(3, 4);
		Point p2 = new Point(5, 5);
		System.out.println(p1.x);
		System.out.println(p2.x);
	}
}
class Point{
	int x;
	int y;
	/** 构造器，名字与类名一致，没有返回值 */
	public Point(int x, int y){
		this.x = x; //初始化属性
		this.y = y;
	}
}



