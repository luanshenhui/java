package day03;

import java.util.Scanner;

/**
 * while��do while������
 * dao������  while��rst��next������
 * 
 * while���������ʽ����
 * 	������
 * ��
 * while ѭ��
 * 
 * while(ѭ������(�������ʽ)(1)){
 *   //ѭ����(2)
 * } 
 * (3)
 * while ��ִ������
 * {(1)-true->(2)}->{(1)-true->(2)}->(1)-false->����(3)
 * 
 * whileѭ��"һ������"������޹ص�ѭ��
 * ��������֤����̨����ķ����� 0~100 ֮��
 */
public class Demo12 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		int score = -1;/*0*/
		while(score <0 || score>100/*1*/){
			System.out.print("���������0~100����");
			score = in.nextInt();/*2*/
		}
		System.out.println("������"+score);/*3*/
//(0 socre=-1)->{(1 -1<0||-1>100)-true->(2 score=120)}->
//{(1 120<0||120>100)-true->(2 score=-3)}->
//{(1 -3<0||-1>100)-true->(2 score=85)}->
//(1 85<0||85>100)-false->(3 println(85))  
	}
}





