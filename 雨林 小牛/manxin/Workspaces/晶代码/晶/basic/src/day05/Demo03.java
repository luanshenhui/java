package day05;

import java.util.Arrays;

/**
 * Arrays 
 *  equals ������ ���ڱȽ����������������  
 * ʹ��API������API������װ�˳����㷨���ܣ�ʹ����Щ����
 *    �򻯿������̣� ��߿���Ч��
 * �磺ʹ��toString���Ա�������������
 *    ʹ��equals���Ա�ݱȽ� ��������
 * API ��װ���㷨Ҳ�� for if ʵ�ֵģ�Ҳ���Բ��á�
 */
public class Demo03 {
	public static void main(String[] args) {
		char[] answer = {'A', 'C', 'D'};
		char[] input = {'A', 'C', 'D'}; // {'A', 'B', 'C'}; 
		boolean match = Arrays.equals(answer, input);
		//match ƥ��
		if(match){
			System.out.println("����ˣ�"); 
		}else{
			System.out.println("����ˣ�"); 
		}
	}
}
