package day04;
/**
 * ��̬������ ������ķ�����ʹ���������ʣ�û����������this
 * �������� ���ߡ��������� �磺randomTetromino
 * ��������뵱ǰ����this���޹ؾͿ��Զ���Ϊ��̬����
 * �뵱ǰ������йصķ�����ʹ�÷Ǿ�̬�������緽���ƶ��ķ���
 * ���ǷǾ�̬����
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
class Point{//������
	int x; int y;
	public Point(int x, int y){this.x = x; this.y = y;}
	/** ���㵱ǰ��(this)������һ����(other)�ľ��� */
	public double distance(/*Point this*/ Point other){
		int a = this.x - other.x;int b = this.y - other.y;
		return Math.sqrt(a*a + b*b);
	}
	/** ���� p1 �� p2 �ľ��� */
	public static double distance(Point p1, Point p2){
		int a =p1.x-p2.x; int b=p1.y - p2.y;
		return Math.sqrt(a*a + b*b);
	}
}
