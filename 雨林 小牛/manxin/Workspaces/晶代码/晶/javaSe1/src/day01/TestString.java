package day01;
/**
 * ����String��
 * ����ʵ��Ϊ�������
 * @author Administrator
 * String��һ���Ǳ�׼�ľ����Ż�����
 * String ��һ��final�� �����Ա��̳�  �ײ�ά�������ַ�����
 *
 */
public class TestString {
	public static void main(String[] args) {
		String str1 = "Hello";
		String str2 = str1;
		String str3 = "World";
		str1 += str3;
		System.out.println(str1);
		System.out.println(str2);
		System.out.println(str3);
	}
}




