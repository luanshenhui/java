package day03;
/**
 * Ĭ�Ϲ���������
 * ������  ���� ���ǲ��ܴ���������Ķ���  ����Ҳ�й�����
 * ֻҪ����  ��һ���й�����   
 * 1) Java ��һ���й�����!
 * 2) �����û�������κι�����,Java�������Զ����Ĭ���޲����Ĺ�����
 * 3) ����������˹�����, Java�������Ͳ�������κ�Ĭ�Ϲ�����   
 * javaBean �淶
 */
public class Demo01 {
	public static void main(String[] args) {
		Foo f = new Foo();//���õ���Ĭ�Ϲ�����
		//Koo k = new Koo();//�����, Koo û�� Koo()������
		Koo k1 = new Koo(8);//����Koo(int) ������
	}
}
class Foo{ //Foo(){} Ĭ�Ϲ�����
}
class Koo{
	Koo(int a){	System.out.println("Koo(int)"); }
}



