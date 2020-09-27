package day05;
/**
 * 自定义泛型
 * 泛型的语法
 * 在定义类的时候，在类名之后用<>定义泛型
 * 泛型命名可以是字母与数字的组合，数字不能是第一个字符
 * 若指定多个泛型，中间用","分开
 * @author Administrator
 *
 */
public class Point<X,Y> {
	private X x;
	private Y y;
	
	public Point(X x,Y y){
		this.x = x;
		this.y = y;
	}
	
	public X getX(){
		return this.x;
	}
	
	public Y getY(){
		return this.y;
	}	
	
	public void setX(X x) {
		this.x = x;
	}

	public void setY(Y y) {
		this.y = y;
	}

	public String toString(){
		return "x="+x+",y="+y;
	}
	
	public static void main(String[] args) {
		Point<Integer,Integer> p = new Point<Integer,Integer>(1,2);
		int x = p.getX();
		System.out.println(p);
		
		Point<Double,Double> p2 = new Point<Double,Double>(1.1,2.2);
		double x1 = p2.getX();
		
		//x要求整数，y要求小数
		Point<Integer,Double> p3 = new Point<Integer,Double>(1,2.3);
		int x2 = p3.getX();
		double y2 = p3.getY();
		
		dosome(p3);
	}
	/**
	 * 泛型是一个动态的过程，是用于告知jvm运行时该类的属性
	 * 所以，不指定泛型时，默认就是Object
	 * @param p
	 */
	public static void dosome(Point p){
		p.setX("1123123");
		p.setY("2333333");
		System.out.println(p);
	}
	
}





