package day05;

import java.util.Arrays;
/**
 * Arrays �� �����㷨
 */
public class Demo04 {
	public static void main(String[] args) {
		int[] score = {67, 49, 88, 69, 95};
		Arrays.sort(score);//С -> ��
		System.out.println(Arrays.toString(score));  
//		�ҵ��������ܲ���Arrays.sort(score) �ŵ�toString���������
		//��Ӧ��unicode����  0  48  a 97  A 65
		String[] names = {"Tom", "Jerry", "Andy", "John","0"};
		Arrays.sort(names);
		System.out.println(Arrays.toString(names));
		//ʹ��null ���� names 
		Arrays.fill(names, null);
		System.out.println(Arrays.toString(names));
		
	}
}


