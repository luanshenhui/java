package day05;
/**
 * �����ڲ���:  
 *�����в��������Լ����������ʹ�������ڲ���Ľṹ 
 *�����е�ϵͳ�ṩ�Ĺ�������ʹ�������ڲ���
 */
public class Demo10 {
	public static void main(String[] args) {
		Xoo xoo = new Xoo();//����Xoo��ʵ��������������
		Xoo x1 = new Xoo(){};//����Xoo�ġ���������ʵ����
		//new Xoo(){}�Ǽ̳�Xoo������������������ʵ��
		//���� {} ����������壬{}�п���ʹ������﷨
		//�����ڲ�����ŵ㣺����������﷨�ǳ����գ���࣡
		//�������ʹ�������ڲ��� ��ô��new����ֻ���Ǹ�����߽ӿ�
		Xoo x2 = new Xoo(){
			public void test(){//��д����ķ���
				System.out.println("x2 test"); 
			}
		};
		x2.test();//�����д�Ժ�Ľ��
		//Yoo yoo = new Yoo();//������󣬲��ܴ����ӿ�ʵ��
		Yoo yoo = new Yoo(){};// ľ�����⣬���Ǵ���������ʵ��
		//Woo woo = new Woo(){};//�����û��ʵ�ֳ��󷽷�
		Woo woo = new Woo(){
			public void test() {//��������������ִ��
				System.out.println("woo test");
			}
		};
		woo.test();//������test����
	}
}
interface Yoo{
}
interface Woo{
	void test();
}

class Xoo{
	public void test(){
		System.out.println("Xoo test()");
	}
}


