package day01;
/**
 * String����������
 * �ظ��������ǲ��ᴴ���¶���ġ�
 * @author Administrator
 *
 */
public class TestString2 {
	public static void main(String[] args) {
		String str1 = "HelloWorld";
		String str2 = "HelloWorld";
		String str3 = new String("HelloWorld");
		/**
		 * jvm�ڱ���Դ����ʱ�����ڱ�������У�
		 * ������������ı��ʽ���м��㣬������滻���ʽ��
		 * �������Խ�ʡ����ʱ�Ŀ�����
		 */
		String str4 = "Hello" + "World";
		/**
		 * ֻҪ���ʽ��һ���������������Ͳ����ٱ�������м���
		 */
		String str5 = "Hello";
		String str6 = "World";
		String str7 = str5 + str6;
		System.out.println(str1 == str2);//����ͬһ����		
		System.out.println(str1 == str3);//����ͬһ������
		System.out.println(str1.equals(str3));
		System.out.println(str1 == str4);//true
		System.out.println(str1 == str7);//false
		String str8 = "helloworld";
		//String��length�������length��ʲô����
		//string��length�Ƿ���  �������length������
		System.out.println(str8.length());
		System.out.println(str1 == str8);//false ����ͬһ����
	  //false ���ݲ�ͬ�����ִ�Сд
		System.out.println(str1.equals(str8));
		/**
		 * String�Լ����еıȽ����ݵķ���
		 * �÷����Ƚ��ַ�������ʱ���Դ�Сд
		 */
		System.out.println(str1.equalsIgnoreCase(str8));
		
	}
}
