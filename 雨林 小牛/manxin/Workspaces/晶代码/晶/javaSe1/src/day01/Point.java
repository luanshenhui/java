package day01;
/**
 * Point类，测试Object相关方法
 * Point没有显示的继承Object，但会默认继承
 * 
 * javadoc命令，可以将一个类中所有的文档注释应用上
 *              生成该类的API文档。
 * 
 * @author Administrator
 *
 */
public class Point {
	private int x;
	private int y;
	
	public Point(int x,int y){
		this.x = x;
		this.y = y;
	}
	
	@Override
	public String toString() {		
		return "x=" + x + ",y=" + y;
	}
	
	public static void main(String[] args) {
		Point p = new Point(1,2);
		/**
		 * System.out.println(Object obj)
		 * 方法输出的就是给定对象的toString()方法的返回值
		 */
		System.out.println(p);
		
		
//		String info = p.toString();
//		/**
//		 * 输出对象句柄
//		 * day01.Point@de6ced
//		 */
//		System.out.println(info);
		
		println(p);
		String s = "hello";
		println(s);
		
		/**
		 * 
		 * "=="与"equals"的区别
		 * "=="比较是否为同一个对象
		 * "equals"比较两个对象内容是否一致
		 */
		Point p1 = new Point(1,2);
		Point p2 = new Point(1,2);
		System.out.println("同一个对象:"+(p1==p2));
		System.out.println("内容一样:"+(p1.equals(p2)));
				
	}
	
	/**
	 * 重写equals方法，定义内容相同的比较规则
	 */
	public boolean equals(Object obj) {
		/**
		 * 是有相同类型的对象，才具有可比性
		 * 因为Object的equals方法的参数定义为了Object
		 * 所以，我们要先判断传进来的对象是否为
		 * 当前类型的一个实例
		 */
		if(obj instanceof Point){
			Point p = (Point)obj;
			/**
			 * 定义比较内容的规则
			 * 这里不一定要求两个对象的所有属性值必须完全
			 * 相同，要结合实际的业务需求去写。
			 */
			return this.x == p.x && this.y == p.y;
		}
		//不是同一个类型的实例，没有可比性
		return false;
	}
	
	
	/**
	 * 参数利用了多态性，可以使方法更通用。
	 * 多态:父类引用接收子类对象
	 * @param obj
	 */
	public static void println(Object obj){
		System.out.println(obj);
	}

	
}







