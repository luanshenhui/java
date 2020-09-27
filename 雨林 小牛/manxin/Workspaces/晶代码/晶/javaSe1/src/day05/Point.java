package day05;
/**
 * �Զ��巺��
 * ���͵��﷨
 * �ڶ������ʱ��������֮����<>���巺��
 * ����������������ĸ�����ֵ���ϣ����ֲ����ǵ�һ���ַ�
 * ��ָ��������ͣ��м���","�ֿ�
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
		
		//xҪ��������yҪ��С��
		Point<Integer,Double> p3 = new Point<Integer,Double>(1,2.3);
		int x2 = p3.getX();
		double y2 = p3.getY();
		
		dosome(p3);
	}
	/**
	 * ������һ����̬�Ĺ��̣������ڸ�֪jvm����ʱ���������
	 * ���ԣ���ָ������ʱ��Ĭ�Ͼ���Object
	 * @param p
	 */
	public static void dosome(Point p){
		p.setX("1123123");
		p.setY("2333333");
		System.out.println(p);
	}
	
}





