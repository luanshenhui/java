package day05;

import java.util.Arrays;
/**
 * ��������� �� ׷��
 * 1) ���鴴���Ժ󳤶Ȳ��ɸı�  String ���ȶ������ǲ��ɱ�� 
 * string�ײ�ά�������ַ�����  
 * 2) ���ø�������ķ�ʽʵ�������㷨 
 * 3) ��������ʱ�����ø��Ʒ�������ԭ�������ݡ�
 * 
 * ����������Java API ʵ�ֵĳ����㷨��
 *  "a:"+a ->  "a:100" 
 */
public class Demo07 {
	public static void main(String[] args) {
		//����ԭ������������
		String[] playlist = {"����", "Poker Face"};
		System.out.println(Arrays.toString(playlist));
		playlist=new String[]{"����", "Poker Face","������"};
		System.out.println(Arrays.toString(playlist));
		//���ݣ�Ϊplaylist���ݲ�׷�� �� ���� ��������� 
		playlist=Arrays.copyOf(playlist, playlist.length+1);
		playlist[playlist.length-1] = "�����";
		System.out.println(Arrays.toString(playlist));  
		
		//1) ���������飨����������
		//2) �滻ԭ����
		String[] newOne = new String[playlist.length+1];
		System.arraycopy(playlist, 0, 
				newOne, 0, playlist.length);
		playlist = newOne;
		
		System.out.println(Arrays.toString(playlist));
		
		
	}
}








