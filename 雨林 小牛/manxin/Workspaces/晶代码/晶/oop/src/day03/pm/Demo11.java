package day03.pm;

import day03.pm.sub.Koo;

/**
 *             ����     ����    ����      ����
 * public       v 	  v    v     v
 * protected    v     v    v 
 * default      v     v     
 * private      v
 * �������δ�
 * Java ����˽�����Թ��е����Է��ʷ��� 
 * ������Ա���ʹ��private  ʵ����   ���Ǻͱ�һһ��Ӧ���Ǹ���
 * �������������ʹ��private  �������get set ����
 */
public class Demo11 {
	public static void main(String[] args) {
		Noo noo = new Noo();
		System.out.println(noo.a);//5, ���пɼ� 
		//System.out.println(noo.b);//�������, b ���ɼ�
		System.out.println(noo.getB());//6
		System.out.println(noo.c);//8, ͬpackage �ɼ�
		System.out.println(noo.d);//10  ͬpackage �ɼ�
		
		Koo koo = new Koo();
		//day03.pm.sub.Koo k = new day03.pm.sub.Koo();
		System.out.println(koo.a);//5 ����
		//System.out.println(koo.b);//˽�� ���ɼ�
		//System.out.println(koo.c);//Ĭ�ϵ�, ��ͬ�����ɼ�
		//System.out.println(koo.d);//������, ��ͬ�����ɼ�
		Xoo xoo = new Xoo();
		xoo.test();
	}
}
class Xoo extends Koo{//Koo �������� day03.pm.sub����
	public void test(){
		//super �ǶԸ����Ͷ��������, ���Է��ʸ���������/����
		//һ������¿���ʡ��, Ҳ���Բ�ʡ��
		System.out.println(super.a);//a   
		//System.out.println(b);//˽��,���಻�ɼ�
		//System.out.println(c);//Ĭ�ϵ�, ��ͬ�� ���ɼ�
		System.out.println(d);//������, �����пɼ�
	}
}

class Noo{
	public int a = 5;//���е�
	private int b = 6;//˽�е�
	int c = 8;//Ĭ�Ϸ�������,�ڵ�ǰ��(package)����Ч
	protected int d = 10;//����������: ��ǰ��,�������� 
	public int getB(){
		return b;
	}
}