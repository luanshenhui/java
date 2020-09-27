package day06;

import java.util.Arrays;
import java.util.Random;

/**
 * ����ѩ
 * 
 * ʵ������ ˫ɫ���Ʊ���� �㷨
 * 
 * ʵ�ַ��� ���ز�Ʊ���� ��:[03, 06, 08, 12, 15, 23, 08]
 * 
 * 1) ���ɺ������
 *   ���� ���� ��"01" ~ "33"
 *   ʹ�ñ�ǣ�  f, f, ... 
 *   ����� :   { ^, ^, ^, ^, ^, ^}
 *   index = 0 ���ɺ���ĸ���
 * 2) ������ɫ�����
 * ��һ��33���������  ������������� ѡ��6�����ظ���   Ȼ���� �ڶ�����������
 * ����   �������һ����ɫ����   0~16
 * 
 * 
 */




public class Demo10 {
	public static void main(String[] args) {
		String[] balls = gen();
		System.out.println(Arrays.toString(balls)); 
	}
	public static String[] gen(){
		String[] pool = {"01","02","03","04","05","06","07",
				"08","09","10","11","12","13","14","15","16",
				"17","18","19","20","21","22","23","24","25",
				"26","27","28","29","30","31","32","33"};
		boolean[] used = new boolean[pool.length];
		String[] balls = new String[6];
		int index = 0;
		Random r = new Random();
		do{
			int i = r.nextInt(pool.length);
			if(used[i]){continue;}
			balls[index++] = pool[i];
			used[i] = true;		
		}while(index!=balls.length);
		Arrays.sort(balls);
		//���ݣ�׷����ɫ�����
		balls = Arrays.copyOf(balls, balls.length+1);
		balls[balls.length-1] = pool[r.nextInt(16)];
		return balls;
	}
}


