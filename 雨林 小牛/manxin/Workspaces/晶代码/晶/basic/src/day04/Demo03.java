package day04;

import java.util.Random;
import java.util.Scanner;

/**
 * ��������Ϸ
 * 
 * ���ݷ�����ǰ����ҵ�����
 * 
 * ���ݷ�����
 *    num �Ǳ��²�����
 *    answer ���û��µĴ�
 *    count �²�Ĵ���
 * 
 * ���㷽����������̣���
 *    1) ������� num ��Χ 1~100 
 *    2) ��ʾ�û��²�����
 *    3) �õ��²�� answer
 *    4) �Ƚ��û�answer �� num
 *       4.1 �Ʒ� count++ 
 *       4.2 �����Ⱦͽ��� ��Ϸ
 *       4.3 ��ʾ��/С  
 *    5) ���� (2) 
 *    ����
 */
public class Demo03 {
	public static void main(String[] args) {
		int num;
		int answer;
		int count = 0;
		Scanner in = new Scanner(System.in);
		//��֤��  �������� ʹ��random
		Random random = new Random();
		//1�����ĸ�����ʼ   100 ��Χ
		num = random.nextInt(100)+1;
		System.out.println("�ף���ӭʹ�ò�������Ϸ��(*_^)");
		for(;;){
			System.out.print("�°ɣ�");
			answer = in.nextInt();
			count++;
			if(num==answer){
				System.out.println("(@_@)���ˣ���"+count);	
				break;
			}
			if(answer > num){
				System.out.println("�´��ˣ�������"+count);
			}else{
				System.out.println("��С�ˣ�������"+count);
			}
		}
	}
}











