package day03;
/**
 * ʵ�������������  ��������˸��๹������Ķ���
 * �������޲����Ĺ�����һ�����ø�����޲����Ĺ�����
 * @author Administrator
 *
 */
public class Test {
	public static void main(String[] args) {
		test1111 t = new test1111();
	}
}
class test111{
	public test111(int a) {
		// TODO Auto-generated constructor stub
	System.out.println("test");
	}
}
class test1111 extends test111{
	//���������޲����Ĺ�����  ���Ǹ�������һ���в����Ĺ����� ����
	//û���޲����Ĺ�����������±�����?��ô���أ�
	//1 �ڸ�����дһ���޲����Ĺ�����
	//2 �������е��޲����Ĺ������е�super���� �ﴫ����   
	//������Ҫ��������ø����е��ĸ��в����Ĺ����������Ӧ
	public test1111() {
		// TODO Auto-generated constructor stub
		//���ø���Ĺ�����
		super(5);
	}
}
