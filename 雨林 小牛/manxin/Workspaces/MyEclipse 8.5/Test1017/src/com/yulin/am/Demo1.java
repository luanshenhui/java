package com.yulin.am;
import java.util.*;

public class Demo1 {

	/**
	 * ��Ͳ��50��  �ڶ������
	 * ������� ��ʾû��ô��  ��������
	 * ȫ������ �°�
	 */
	public static void main(String[] args) {
		for(int kc=50;kc>0;){
			System.out.println("��Ͳ��4Ԫһ�����ڶ�����ۣ�");
			System.out.println("��滹ʣ��"+kc);
			Scanner scan = new Scanner(System.in);
			System.out.println("��Ҫ����?");
			int in = scan.nextInt();
			if(in>kc){
				System.out.println("û����ô��~��");
			}else{
				int sum = 0;
				sum=in/2*6+in%2*4;
				System.out.println("һ�������ˣ�"+in+"����һ��:"+sum+"Ԫ");
				kc-=in;
			}
		}
		System.out.println("�Ѿ������ˣ������°���~");
		
	}

}
