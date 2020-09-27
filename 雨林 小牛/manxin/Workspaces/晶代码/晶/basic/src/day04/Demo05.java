package day04;

import java.util.Scanner;

/**
 * ѧ���ɼ�����
 * 
 * ����ģ�����
 *   names = { "Tom", "Jerry", "Andy", "John" }
 *   score = {  85  ,      67,    66,     98  }
 *              0          1       2       3
 * �㷨��ƣ�ҵ����ʵ��
 * 1 �ɼ�����  
 *   ������ʾÿ���������ӿ���̨��ȡ������䵽��Ӧ�ķ�������
 * 2 �ɼ��б�, ������ƽ���ɼ�
 *   ����ÿ��������������ʾ��Ӧ�ĳɼ���ͳ���ܷ�
 *   ��������ʾƽ���֡�
 * 3 ��ѯ ĳ�˵ĳɼ�
 *   �ȴ������ѯ������
 *   �������������� ����������ҵ�����ʾ�����Ͷ�Ӧ�ĳɼ���
 */
public class Demo05 {
	public static void main(String[] args) {
		//��������Ͳ��ǽ����ڻ����������� ��������ͬ������
		String[] names = {"Tom","Jerry","Andy","John"};
		int[] score = new int[names.length];
		//�������̨����
		Scanner in = new Scanner(System.in);
		System.out.println("\t��ӭʹ�óɼ�����");
		while(true){
			System.out.print(
					"1.�ɼ�¼��  2.�ɼ���  3.��ѯ  0.�뿪, ѡ��:");
			String cmd = in.nextLine();//�ӿ���̨��ȡһ���ַ���
			//�Ƚ��ַ�������ʹ��equals()������
			//��� �� �ַ��������������Ƚ�
			if("0".equals(cmd)){
				System.out.println("�ף��ټ���(T_T)!"); break;
			}else if("1".equals(cmd)){//cmd command ����
				//����
				System.out.println("��ʼ����ɼ�");
				for(int i=0; i<names.length; i++){
					String name = names[i];//name ����ÿ������
					System.out.print((i+1)+" ���� "+name+" �ĳɼ���");
					String str = in.nextLine();//"95"
					//parseInt ��10���Ƶ��ַ���ת��Ϊ����
					score[i]=Integer.parseInt(str);//"95" -> 95(int)
				}
			}else if("2".equals(cmd)){
				//�ɼ���
				int sum = 0;
				for(int i=0; i<names.length; i++){
					String name = names[i];
					System.out.println(
							(i+1) + "." + name +"�ĳɼ�:"+score[i]);
					sum += score[i];
				}
				System.out.println("ƽ���ɼ���"+(sum/names.length));
			}else if("3".equals(cmd)){
				// 3.��ѯ
				System.out.print("�����ѯ������");
				String name = in.nextLine();
				for(int i=0; i<names.length; i++){
					if(name.equals(names[i])){
						System.out.println(
								(i+1) + "." + name +"�ĳɼ�:"+score[i]);
						break;
					}
				}
			}else{
				System.out.println("�������!");
			}
		}
	}
}










