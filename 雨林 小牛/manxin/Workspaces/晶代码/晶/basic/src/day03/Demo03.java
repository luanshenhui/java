package day03;

import java.util.Scanner;

/**
 * switch ... case  �����ʾ
 * switch: ����
 * case: ��...�����
 * break: ���
 */
public class Demo03 {
	public static void main(String[] args) {	
		Scanner in = new Scanner(System.in);
		System.out.print("����ٷ��Ʒ�����");
		//�ӿ���̨�������
		int score = in.nextInt();//85;
		String level;//����
		//switch()��ŵ����ͱ��ʽ
		switch(score/10){//10 ~ 0
		//case ����
		case 10:
		case 9: level = "�е�"; break;
		case 8: level = "����"; break;
		case 7: level = "�е�"; break;
		case 6: level = "����"; break;
		default: level = "������";
		}
		System.out.println("����"+level); 
	}
}





