package day03;

import java.util.Date;

/**
 * java.util.Date  �����������ں�ʱ�����
 * @author Administrator
 *
 */
public class DateDemo {
	public static void main(String[] args) {
		//����һ������������ǰϵͳʱ���Date����
		Date date = new Date();
		System.out.println(date);
		
		long now = date.getTime();//��ȡ����ֵ
		System.out.println(now);
		
		now += 1000 * 60 * 60 * 24;
		//�趨һ������ֵ��ʹdate�����ʾ���ʱ���
		date.setTime(now);
		System.out.println(date);
	}
}






