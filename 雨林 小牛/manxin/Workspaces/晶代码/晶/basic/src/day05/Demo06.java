package day05;

import java.util.Arrays;

/**
 * ��ֵ  ����
 * 
 * ����ĸ��� 
 * ջ�ڴ棺����ڶ��ڴ� �Ƚ�С   �����  �Ƚ���� ����ȳ���ԭ�� 
 * �洢���ǻ����������ͺ����ñ���  
 * ���ڴ棺�Ƚϴ�   ����     �洢���Ƕ���
 * 
 * 
 * �����;�����������㷨
 */
public class Demo06 {
	public static void main(String[] args) {
//��������ĸ�ֵ, �������黹��ͬһ����ary1 ary2 �໥Ӱ��
		int[] ary1 = {4,5,6};
		int[] ary2 = ary1;
		ary2[1]++;
		System.out.println(Arrays.toString(ary1));
		System.out.println(Arrays.toString(ary2));
//����ĸ���  1��ʹ��forѭ��ʵ�֣� 2��ʹ��API
		//��ary1���õ�������и���
		int[] ary3 = new int[ary1.length];
		for(int i=0; i<ary1.length; i++){
			ary3[i] = ary1[i];
		}
		ary3[1]++;
		System.out.println(Arrays.toString(ary1));
		System.out.println(Arrays.toString(ary3));
		//ʹ��API System.arraycopy() ʵ�ָ���
		//���� ary1 Ϊ ary4
		int[] ary4 = new int[ary1.length];
		//(Դ���飬Դ������ʼλ�ã�Ŀ�����飬Ŀ��������ʼλ�ã�����)
		System.arraycopy(ary1, 0, ary4, 0, ary1.length);
		//ary1 = [4, 6, 6] 
		//ary4 = [4, 6, 6] 
		System.out.println(Arrays.toString(ary1));
		System.out.println(Arrays.toString(ary4));
		//ʹ�� Arrays.copyOf() �������ײ����arraycopy 
		//����ary1 �� ary5 , copyOf() Java5 ����API
		int[] ary5 = Arrays.copyOf(ary1, ary1.length);
		System.out.println(Arrays.toString(ary1));
		System.out.println(Arrays.toString(ary5));
	}
}




