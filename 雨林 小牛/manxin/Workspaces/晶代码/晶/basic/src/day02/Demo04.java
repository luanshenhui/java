package day02;
/*
 * ����  �������  һ����   ��һ����������ֻ����һ�����͵�����
 * int[] String[] char[] Object[]
 * 
 * ¬ѩ��  ������ͨ��ѧ
 */
public class Demo04 {
	public static void main(String[] args) {
		int i = 0;
		System.out.println((i++) % 3);
		System.out.println(i++ % 3);
		System.out.println(i++ % 3);
		System.out.println(i++ % 3);
		System.out.println(i++ % 3);
		System.out.println(i++ % 3);
		System.out.println(i++ % 3);
		//int a = 1;
		//������±��Ǵ�0��ʼ��
		String[] players = { "��ٳ", "�˳�", "١��Ϊ" };
		//                     0       1       2
		String one = players[0];
		System.out.println(one);//��ٳ
		i = 0;
		System.out.println(players[i++%3]); 
		System.out.println(players[i++%3]); 
		System.out.println(players[i++%3]); 
		System.out.println(players[i++%3]); 
		System.out.println(players[i++%3]); 
	}
}




