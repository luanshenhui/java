package day02;
/**
 * �����������췽��
 * ���ڴ������ҳ�ʼ�����󣨳�ʼ�����ԣ�
 *  
 *  ���������� �� �����Ĳ��
 *  �������ж��壬���������أ�һ�����ж����������
 *  
 * ������������ҵ��: ��������������Ĵ����ͳ�ʼ������
 *    �﷨: ����������һ��,���ܶ��巵��ֵ,ʹ��new���������
 * ����: ҵ��:�Ƕ������Ϊ�����ܣ�
 *    �﷨�����������Ͳ�ͬ��һ�����巵��ֵ,ʹ�ö������õ���
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
	/** ������������������һ�£�û�з���ֵ */
	public Point(int x, int y){
		this.x = x; //��ʼ������
		this.y = y;
	}
}



