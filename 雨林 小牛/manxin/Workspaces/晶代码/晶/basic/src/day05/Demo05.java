package day05;

import java.util.Arrays;

/**
 * ���ֲ����㷨 
 * �� Tom ���� λ��
 * 
 *   Andy Jerry John Tom Wang
 *
 * �� Tom ���� ���� ��ʾ�Ҳ���
 *
 *  Tom  Andy  Jerry  John  Wang  
 *  
 * �� Wang ���� λ��
 *
 *  Tom  Andy  Jerry  John  Wang  
 * 
 */
public class Demo05 {
	public static void main(String[] args) {
		String[] names={"Tom","Andy","Jerry","John","Wang"};
		//binary ������ Search ���� ��binarySearch ���ֲ���
		int index = Arrays.binarySearch(names,"Jerry");
		System.out.println(index);//2 �ҵ�
		index = Arrays.binarySearch(names,"Wang");
		System.out.println(index);//4 �ҵ�
		index = Arrays.binarySearch(names,"Tom");
		System.out.println(index);//���� �Ҳ�����
		//���ֲ��ң���δ����������϶��ֲ��ҽ���ǲ��ȶ��ģ�
		Arrays.sort(names);
		index = Arrays.binarySearch(names,"Tom");
		System.out.println(index);//3 �ҵ�Tom��
		index = Arrays.binarySearch(names,"Lee");
		System.out.println(index);//���� �Ҳ�����
	}
}






