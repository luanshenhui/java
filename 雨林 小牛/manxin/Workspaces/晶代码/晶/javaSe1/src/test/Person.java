package test;
/*
 * ��һ����java���ļ���   ������һ����public������
 * �������  
 * �� ��һ��������ֻ�����ֶ���   ���ԣ���Ա����  ʵ��������   ����
 * ����  ������һ������������
 */
public class Person {
	//����
	int eye;
	static int lege;
	//����  �����ܸ�ɶ
	public void eat(){
		
	}
	public int add(int a,int b){
		int c  = a + b;
		return c;
	}
	public static void drink(){
		
	}
	public static void main(String[] args) {
		//������÷�����������
		Person yujiawen = new Person();
		yujiawen.eat();
		yujiawen.add(1, 2);
		yujiawen.eye = 32;
		yujiawen.lege = 2;
		//��static���ε����Ի��߷���  ֱ������������  �����ɶ������
		Person.drink();
		Person.lege = 3;
	}
}
