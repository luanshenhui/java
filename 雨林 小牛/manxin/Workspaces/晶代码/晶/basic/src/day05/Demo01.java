package day05;

import java.util.Random;
import java.util.Scanner;

/**
 * 
 * ��ĸ�²���Ϸ
 * 
 * ҵ������������²⡰������ɡ����ַ�ϵ�У�5����,
 * ���ݡ��û����롱���ַ����С���顱�Ƿ�²�ɹ���
 * ������ɹ��͡���ʾ����������������²⡣
 *  
 * ҵ�����ݷ�����
 *   1) char[] answer ���²���ĸ����
 *   2) char[] input  ���������ĸ����
 *   3) int count �²����   
 *   4) int[] result = {�ַ�ƥ��������ƥ��ɹ�λ��}  
 *    �û���������кͱ��²����еıȽϽ��
 * ���ܷ������
 *   1��������� (generate)
 *      �����㷨��������������n�����ظ��Ĵ�д��ĸ
 *      char[] generate(int n)
 *      
 *   2���û�����(Input)
 *   	   �����㷨�����������ӿ���̨��ȡ���룬����5����д�ַ�
 *      char[] userInput()
 *      
 *   3�����(check)�û�����
 *   �����㷨��������������׼�𰸣�answer�����û�����
 *   ��input�������ؽ����{�ַ�ƥ��������ƥ��ɹ�λ��} 
 *      int[] check(char[] answer, char[] input)
 *      
 *   4��

 *     void show(int count, int[] result)
 *     
 *   5) main ������ɲ²����̿���
 * 		1��"���ɴ�"�ַ����У�5���ַ�
 * 		2���ȴ��û��Ĵ�����
 * 		3��"����û�����"�Ĵ𰸣���������� ƥ��������ƥ��λ��
 * 		4) ͳ�ƻش�����
 * 		5) ��ʾ�����, ���� (2)
 */
public class Demo01 {
	public static void main(String[] args) {
		char[] answer;
		char[] input;
		int count=0;
		int[] result;
		//��static���εķ�����������  ����ֱ������������
		answer = Demo01.generate(5);//1��"���ɴ�"�ַ����У�5���ַ�
		System.out.println(answer);
		System.out.println("��ӭʹ�ò��ַ���Ϸ��");
		while(true){
			input = userInput();//2)�ȴ��û��Ĵ�����
			result = check(answer, input);//"����û�����"�Ĵ�
			count++;//ͳ�ƻش�����
			show(count, result);//��ʾ�����
			if(result[0]==5 && result[1]==5){
				break;
			}
		}
	}
	public static char[] generate(int n){
		char[] chs = {'A','B','C','D','E','F','G','H'};
		//boolean����Ĭ�ϵ���false
		//Ϊ��������������ظ��õ�
		boolean[] used = new boolean[chs.length];
		int i;
		int index = 0;
		//�ǰ�ÿһ�������������ĸ�ŵ���answer��
		char[] answer = new char[n];
		Random r = new Random();
		do{
			i = r.nextInt(chs.length)+0;
			//used���������ĳһ��Ԫ����true
			if(used[i]){//���ʹ�ù�i�ͼ����´�ѭ��
				continue;
			}
			//chs[i]��������������������һ����ĸ
			//��ѡ�����Ǹ����ŵ�answer��������
			answer[index++] = chs[i];
			//��Ϊ�ظ���Ԫ���ǲ�������answer����������
			used[i] = true;
		}while(index != n);
		return answer;
	}
	public static char[] userInput(){
		Scanner in = new Scanner(System.in);
		char[] input = {};
		while(true){
			System.out.print("�����°ɣ�");
			String str = in.nextLine();
			// String �ṩ�� API�����������ַ��������е��ַ���
			// "ABCDE" toCharArray ���� {A, B, C, D, E}
			input = str.toCharArray();
			if(input.length == 5){
				break;
			}
			System.out.println("���Ȳ���ѽ!"); 
		}
		return input;
	}
	/*
	 * int[] a = {1,2,3}
	 * int[] b = {4,3,1}
	 */
	public static int[] check(char[] answer, char[] input){
		int[] result = {0,0};
		for(int i=0; i<answer.length; i++){
			for(int j=0; j<input.length; j++){
				if(answer[i]==input[j]){
					result[0]++;
					if(i==j){
						result[1]++;
					}
					break;
				}
			}
		}
		return result;
	}
	public static void show(int count, int[] result){
		System.out.print("�²�"+count + "��" );
		System.out.print(" ƥ���ַ�"+ result[0] + "��" );
		System.out.println(" ƥ��λ��"+ result[1] + "��" );
		if(result[0] == 5 && result[1]==5){
			System.out.println("��ϲ�����У�");
		}
	}
}












