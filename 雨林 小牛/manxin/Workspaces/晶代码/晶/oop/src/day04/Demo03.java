package day04;
/**
 * ��̬����� 
 * static����� ��������ڼ���Ѿ�����
 * ��̬�ķ������ȼ�������ͨ����
 */
public class Demo03 {
	public static void main(String[] args) {
		Foo f1 = new Foo();
		Foo f2 = new Foo();
	}
}
class Foo{
	//System.out.println("HI");//����������в��������
	{System.out.println("HI");}//����飬����ʹ�ã��������
	//��������ʱ��ִ�У������ڹ������е����
	//��̬����飬�Ƚ�����, ����Ĵ���飬��������ڼ�ִ��
	//ִֻ��һ�Σ����ڼ��ؾ�̬��Դ���������ļ���ͼƬ�زĵ�
	static{System.out.println("Foo class loaded");};
}




