package com.yulin.am;
import java.util.*;

public class ExceptionDemo {

	/**
	 * �쳣����
	 */
	static String[] is = new String[5];
	public static void main(String[] args) throws Exception{
		while(true){
			try{
				Scanner scan = new Scanner(System.in);
				int i = scan.nextInt();
				System.out.println("��������ǣ�" + i);
				break;
			}catch(InputMismatchException ime){
//				throw new Exception("�������Ϣ����");
				ime.printStackTrace();	//��ӡ������Ϣ
				continue;
			}
		}
		System.out.println("���������");
	}

}
