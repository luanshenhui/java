package day05;

import java.util.Arrays;

/**
 * ð������
 * �㷨���ԣ�ÿ�ִαȽ����ڵ�Ԫ�أ�������󽻻� 
 *    ���� n-1 ���ִ�����������
 *  i ����ÿ��������ִ�
 *  j �� j+1 �������ڵ�Ԫ��
 */
public class Demo09 {
	public static void main(String[] args) {
		int[] ary = {9, 2, 10, 5, 7, 1};
		Demo09.sort(ary);
		System.out.println(Arrays.toString(ary)); 
	}
	public static void sort(int[] ary){
		for(int i=0; i<ary.length-1; i++){
			for(int j=0; j<ary.length-i-1; j++){
				if(ary[j]>ary[j+1]){
					int t = ary[j];
					ary[j] = ary[j+1];
					ary[j+1] = t;
				}
				
			}
		}
	}
}
