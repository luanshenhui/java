package day05;

import java.util.Arrays;

/**
 * Arrays API
 *  toSting 
 */
public class Demo02 {
	public static void main(String[] args) {
		String[] names={"Tom", "Andy", "Jerry", "John"}; 
		System.out.println(names);
		//��ӡ��������  forѭ��  ����  �������ÿһ��Ԫ�����
		for(int i=0; i<names.length; i++){
			// i= 0 1 2 3 
			System.out.print(names[i]+",");
		}
		System.out.println(); 
		//��ǿforѭ��  Ҳ����ѭ��  String ��Ԫ�ص�����
		//string �ǿ�������������� �������Ԫ�ص�����
		//names �����������
		for (String string : names) {
			System.out.println(string);
		}
		//�򵥵������������, ʹ��Arrays.toString()�����������
		//  ���Ӽ�෽��
		// toString ���������������Ϊһ���ַ���
		String str = Arrays.toString(names);
		//"[Tom, Andy, Jerry, John]"
		System.out.println(str); 
		System.out.println(Arrays.toString(names));  
	}
}



