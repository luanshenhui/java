package day02;

import java.util.Scanner;

/**
 * ��ҳ�����ҳ �ٷ�ҳ ��ѯ�����ݿ�Ĳ�������
 * ����һ����12������ ��ôһҳ��5�� һ������ҳ
 * ��������  ����� rows   һҳ��size 10 
 * һ���ж���Ҳ  pages  
 * 
 * 
 * 
 * ���ݲ�ѯ���������ҳ���С�����ҳ������ 
 *   int rows = 34; ��ѯ������� �ڿ���̨�������
 *   int size = 10; ҳ���С
 *   int pages = ? // 4
 *   
 *   ���������������0������������������� ����+1
 */
public class Demo10 {
	public static void main(String[] args) {
//		Scanner in = new Scanner(System.in);
//		System.out.print("����������");
//		int rows = in.nextInt();
//		int size = 10;
//		int pages;
//		if(rows%size == 0){
//			pages = rows/size;
//		}else{
//			pages = rows/size+1;
//		}
//		//pages = rows%size == 0 ? rows/size : rows/size+1;
//		System.out.println("��ҳ������"+pages);
		Scanner sc = new Scanner(System.in);
		int rows = sc.nextInt();
		int size = 10;
		//?��ǰ�����һ���������ʽ�൱��if��������Ķ���
		//ð��ǰ���ֵ�ǵ��������ʽ������ʱ���ֵ
		//ð�ź����ֵ�ǵ��������ʽ��������ʱ���ֵ
		//��Ŀ�����
		int pages = rows%size ==0?rows/size:rows/size+1;
//		if(rows%size ==0){
//			pages=rows/size;
//		}else{
//			pages = rows/size+1;
//		}
		//�����価����Ҫ��ҵ���߼�
		//+��java��Ψһһ�������������
		//+�����������һ�����ַ���  ��ô�������һ���ַ�������
		System.out.println(pages);
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}





