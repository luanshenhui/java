package day03;
/**
 * �̳�ʱ��, java ����ĳ�ʼ������
 * 1) �ݹ������
 * 2) �ݹ����ռ�
 * 3) �ݹ���ù�����
 * 4) ���ض��������
 * ˳��ִ��˳��  
 * ��������ʲôʱ����õģ� ��ʵ���������ʱ��  ϵͳ�Զ��ĵ����˶�Ӧ�Ĺ�����
 */
public class Demo05 {
	public static void main(String[] args) {
		Zoo z = new Zoo();
		System.out.println(z.a+","+z.b+","+z.c); 
		//10 6 6 
	}
}
class Xoo{
	int a = 0;
	public Xoo() { a = 10; }
}
class Yoo extends Xoo{
	int b = 2;
	public Yoo() {super(); a=5;b=6;}
}
class Zoo extends Yoo{
	int c = 5;
	public Zoo() { super(); a=8;b=9;c=6;}
}





