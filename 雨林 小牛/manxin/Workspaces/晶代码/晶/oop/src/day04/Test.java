package day04;
//static�������Ե�ʱ�� ����ֱ������������
//static���η�����ʱ�� ����ֱ������������  �ڱ�������������
//��ô����ֱ��д����������  ��Ϊǰ�����������ʡ��
//static ����������
public class Test {
	static int a = 1;
	public static void test(){
		
	}
	public static void main(String[] args) {
		Test.a = 2;
		Test.test();
		test();
	}
}
class test11{
	public void test1(){
		//test();
	}
}
