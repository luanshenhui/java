package day03;

import java.util.Scanner;

/**
 * ��������� 
 */
public class Demo04 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		System.out.print("\t��ӭʹ�� ѧ���������\n"+
     "1.���ѧ��  2.ѧ���б�  3.ɾ��ѧ��  0.�뿪\n"+ 
     "��ѡ��");
		int cmd = in.nextInt();
		switch(cmd){
		case 0: System.out.println("�ף�Bye��"); break;
		case 1: System.out.println("���ѧ�� "); break;
		case 2: System.out.println("ѧ���б� "); break;
		case 3: System.out.println("ɾ��ѧ�� "); break;
		}
	}

}
