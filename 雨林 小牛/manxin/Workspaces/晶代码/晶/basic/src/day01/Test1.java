package day01;

import java.util.Arrays;

/*
 * ������  
 * javaΪʲô�ǿ�ƽ̨�ģ�  jvm java�����     .class  
 * ����  ������������ĸ  _ $ ��ͷ  ������Խ� ��ĸ  _ $ ����
 * boolean byte char  short int float double long
 * 1/8byte  8    16    16   32    32   64     64
 * ���̿������  if else  for  while do while switch case 
 * ���顣������
 * 
 */
public class Test1 {
	//����һ������  ��ô����������м��ַ�ʽ�أ�  ����
	public static void main(String[] args) {
		int[] ary = {1,2,3,4,5,6};
		//�������һ������ֵ  ������ֱ�ӵ��������Ԫ��
		System.out.println(ary);
		//1   ??�����length��string��length��ʲô����
		//      answer�� �����length��һ������ 
		//              string��length��һ������
		for(int i = 0; i<=ary.length-1; i++){
			System.out.print(ary[i]);
		}
		System.out.println();
		//2  ��ѭ��  ��ǿforѭ��  ����ҵ�������бȽϳ��õ�
		//��forѭ��  �ײ���ʹ�õ�����ʵ�ֵ�  ��Ϊ������֧�ָ��ֿ��
		for(int a : ary){
			System.out.print(a);
		}
		System.out.println();
		//3  ʹ�������Դ���api   api�����˼�java�����Դ��� �ṩ����
		System.out.println(Arrays.toString(ary));
	}
}
