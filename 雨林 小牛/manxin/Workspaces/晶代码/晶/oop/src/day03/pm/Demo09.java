package day03.pm;
/**
 * ��д�ķ����Ǹ��ݶ������͵��ö�Ӧ�ķ��� 
 * ˽�з������ܱ�������д! 
 * �̳�  �����̳и�������еĶ���  ������Ϊ�ɼ��Ե�ԭ�� ��private���ε�
 * ������ʹ�ò���
 */
public class Demo09 {
	public static void main(String[] args) {
		Foo f = new Koo();
		f.t();
	}
}
//�����ĵ���������ʾ������������ �����������д�������ʽ���� 
//��ô����ݶ���������
class Foo{
	public void t(/*Foo this*/){this.test();this.test2();}
	private void test(){System.out.println("Foo test()");}
	public void test2(){System.out.println("Foo test2()");}
}
class Koo extends Foo{
	public void test(){System.out.println("Koo test()");}
	public void test2(){System.out.println("Koo test2()");}
}

