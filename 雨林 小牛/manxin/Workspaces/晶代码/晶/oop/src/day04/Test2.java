package day04;
/*
 * abstract�ǳ������˼  ��������Ӧ����ʲô�ӿ�
 * ������ �й�����  ���ǲ���ʵ����������Ķ��� Ϊɶ��--
 * ��Ϊ����������г��󷽷�  ����ʵ��������֮����ó��󷽷���û������
 * ��Ϊ���󷽷�û�з�����
 * ������һ�����̳У���һ�������ࣩ  Ϊɶ---
 * ��Ϊ����ʵ����������Ķ��� ���� �����Ķ����û���� ����Ҫ������
 * ��ȥ��ɷ�����ʵ��
 * ����һ��ʵ�ֳ����������еĳ��󷽷�
 * �������п�����ͨ�ı���  �����г���
 * ��������ͨ����  �����г��󷽷�
 * 
 */
public abstract class Test2 {
	public Test2() {
		// TODO Auto-generated constructor stub
	}
	public static void main(String[] args) {
		//Test2 t = new Test2();
	}
	int a =1;
	//����  ϵͳ�涨�Ļ����Լ������  ���������� ����ȫ�Ǵ�д
	public static final int A = 2;
	public static final double PI = 3.141592628;
	//��ͨ����
	public void test(){}
	//���󷽷�  �൱���˼Ҹ�����һ������ ������Ҫ����ȥʵ��
	//���󷽷�û�з�����  ��abstract����
	public abstract void test1();
}
//Ҫ�Ǽ̳��˳�����  ��ô��ͱ���ʵ�ֳ����������еĳ��󷽷�
//������С��  ����ĳ��󷽷��൱������  һ���̳��˳����� ��ô
//С�� �ͱ����ʵ�ֳ��󷽷�
class b2 extends Test2{

	@Override
	public void test1() {
		// TODO Auto-generated method stub
		
	}
	
}

