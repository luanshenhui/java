package day04;
/**
 * 静态方法： 属于类的方法，使用类名访问，没有隐含参数this
 * 经常用做 工具、工厂方法 如：randomTetromino
 * 如果方法与当前对象（this）无关就可以定义为静态方法
 * 与当前对象的有关的方法，使用非静态方法：如方块移动的方法
 * 就是非静态方法
 */
public class Demo02 {
	public static void main(String[] args) {
		Point p1 = new Point(3,4);
		Point p2 = new Point(6,8);
		double s1 = p1.distance(p2);//distance(p1, p2)
		double s2 = Point.distance(p1, p2);
		System.out.println(s1+","+s2); 
	}
}
class Point{//点类型
	int x; int y;
	public Point(int x, int y){this.x = x; this.y = y;}
	/** 计算当前点(this)到另外一个点(other)的距离 */
	public double distance(/*Point this*/ Point other){
		int a = this.x - other.x;int b = this.y - other.y;
		return Math.sqrt(a*a + b*b);
	}
	/** 计算 p1 到 p2 的距离 */
	public static double distance(Point p1, Point p2){
		int a =p1.x-p2.x; int b=p1.y - p2.y;
		return Math.sqrt(a*a + b*b);
	}
}
