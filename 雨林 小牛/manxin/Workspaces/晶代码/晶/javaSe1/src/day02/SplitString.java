package day02;

import java.util.Arrays;

/**
 * ����ַ���
 * @author Administrator
 *split ��servlet��ʱ��Ҫʹ�õġ�����
 */
public class SplitString {
	public static void main(String[] args) {
		String str = "ffff 123123 45678 98786 3453";
		String[] array = str.split("\\s");
		System.out.println("��:"+array.length+"��");
		System.out.println(Arrays.toString(array));
		str = "123,456,789,1234,56456,,,,,,,,,,";
		array = str.split(",");
		System.out.println(array.length);
		System.out.println(Arrays.toString(array));
		/**
		 * �ض���ͼƬ��
		 */
		String imgName = "111.jpg";
		/**
		 * ����:
		 *   1:��ͼƬ������"."���в��
		 *   2:��ȡͼƬ�ĺ�׺��
		 *   3:���ɵ�ǰϵͳʱ��
		 *   4:�õ�ǰϵͳʱ�����ͼƬ��׺������µ�ͼƬ��
		 *   
		 *   ������������Ŀ��2��
		 *   1:���Ᵽ���ڷ�������ʱ��������ͻ����
		 *   2:��ֹXSS����  HTML����ע�빥��
		 */
		//1
		String[] names = imgName.split("\\.");
		System.out.println(Arrays.toString(names));
		//2
		String fileName = names[1];
		System.out.println(fileName);
		//3
		long now = System.currentTimeMillis();
		//4
		String newName = now+"."+fileName;
		System.out.println("newName:"+newName);
		
	}
}



















