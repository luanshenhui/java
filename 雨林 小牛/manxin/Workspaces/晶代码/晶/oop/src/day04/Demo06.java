package day04;
/**
 * final �ı���
 * 1) final�ı�����ֻ�ܳ�ʼ��������"��"�޸ĵı���
 */
public class Demo06 {
	public static void main(String[] args) {
		final int a;//����/���� �ֲ����� 
		int b;
		a = 5;//��ʼ��
		b = 5;
		//a = 8;//������󣬲������޸ģ�
		b = 8;
		test(6,8);
	}
	public static void test(final int a, int b){
		//a = 5;//����� 
		b = 6;
		System.out.println(a+","+b);
	}
}









