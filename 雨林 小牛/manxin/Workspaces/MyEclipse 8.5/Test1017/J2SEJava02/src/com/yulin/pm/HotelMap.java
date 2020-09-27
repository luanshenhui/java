package com.yulin.pm;
import java.util.*;
/**�Ƶ�ͷ�����ϵͳ******
 *	1.��ס
 *		--->������������
 *		--->���뷿���
 * 		--->��ס�ɹ�
 *	2.�˷�
 *	 	--->���뷿���
 *	3.�鷿
 *		--->
 *	4.�˳�ϵͳ
 */
public class HotelMap {
	public static void main(String[] args){
		System.out.println("**********�Ƶ�ͷ�����ϵͳ**********");
		while(true){
			System.out.println("1.��ס");
			System.out.println("2.�˷�");
			System.out.println("3.�鷿");
			System.out.println("4.�˳�ϵͳ");
			System.out.println("***********************************");
			int in = scan.nextInt();
			switch(in){
			case 1 : add();break; 
			case 2 : tui();break; 
			case 3 : cha();break; 
			case 4 : {
				System.err.println("*************��ӭ�´ι���***********");
				System.exit(0);
				}break; 
				default : System.out.println("�������");
			}
		}
	}
	
	static Map<Integer,String> map = new HashMap<Integer,String>();
	static Scanner scan = new Scanner(System.in);
	
	private static void add() {
		System.out.println("������������");
		String name = scan.next();
		System.out.println("�����뷿��ţ�");
		int room = scan.nextInt();
		if(map.get(room) != null){		
			System.err.println("�÷��������ˣ�");
		}else{
			map.put(room,name);
			System.out.println("***********��ס�ɹ�**********");
		}
		
		
	}

	private static void tui() {
		System.out.println("�������˷��ķ����");
		int room = scan.nextInt();
		
		if(map.remove(room) != null)
		{
			System.out.println("**********�˷��ɹ�**********");
		}else{
			System.err.println("�÷���û���ˣ�");
		}
	}

	private static void cha() {
		for(int i = 1; i < 4; i++){
			for(int j = 1; j < 6; j++){
				int room = i * 100 + j;	//�������forѭ�����ɷ����
				System.out.print(
				(map.get(room) != null) ? "��ס   " : room + " "
				);	
			}
			System.out.println();
		}
	}

}
