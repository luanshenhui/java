package day05;

import java.util.Arrays;

/**
 * ����ʽ���� 
 * �㷨��������Ԫ�ط�Ϊ���飬ǰ�����Ѿ�����ģ�������δ����
 *   �������ÿ��Ԫ�ز��뵽ǰ��ĺ���λ��
 * ���У�i �������ÿ��������Ԫ��λ��
 *      j ����ǰ��ÿ�����Ƚ�Ԫ��λ��
 *      k ����������Ԫ�� 
 */
public class Demo08 {
	public static void main(String[] args) {
		int[] ary = {10, 6, 2, 9, 2, 1};
		Demo08.sort(ary);//Arrays.sort(ary)
		System.out.println(Arrays.toString(ary)); 
	}
	public static void sort(int[] ary){
		int i,j,k;
		for(i=1; i<ary.length; i++){
			k = ary[i];//ȡ��
			//�ƶ�
			for(j=i-1; j>=0 && k<ary[j]; j--){
				ary[j+1] = ary[j];//Ԫ��[j]����ƶ�
			}
			ary[j+1] = k;//����
		}
	}
}
