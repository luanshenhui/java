package com.yulin.pm;
import java.util.*;
/**酒店客房管理系统******
 *	1.入住
 *		--->输入您的姓名
 *		--->输入房间号
 * 		--->入住成功
 *	2.退房
 *	 	--->输入房间号
 *	3.查房
 *		--->
 *	4.退出系统
 */
public class HotelMap {
	public static void main(String[] args){
		System.out.println("**********酒店客房管理系统**********");
		while(true){
			System.out.println("1.入住");
			System.out.println("2.退房");
			System.out.println("3.查房");
			System.out.println("4.退出系统");
			System.out.println("***********************************");
			int in = scan.nextInt();
			switch(in){
			case 1 : add();break; 
			case 2 : tui();break; 
			case 3 : cha();break; 
			case 4 : {
				System.err.println("*************欢迎下次光临***********");
				System.exit(0);
				}break; 
				default : System.out.println("输入错误！");
			}
		}
	}
	
	static Map<Integer,String> map = new HashMap<Integer,String>();
	static Scanner scan = new Scanner(System.in);
	
	private static void add() {
		System.out.println("请输入姓名：");
		String name = scan.next();
		System.out.println("请输入房间号：");
		int room = scan.nextInt();
		if(map.get(room) != null){		
			System.err.println("该房间已有人！");
		}else{
			map.put(room,name);
			System.out.println("***********入住成功**********");
		}
		
		
	}

	private static void tui() {
		System.out.println("请输入退房的房间号");
		int room = scan.nextInt();
		
		if(map.remove(room) != null)
		{
			System.out.println("**********退房成功**********");
		}else{
			System.err.println("该房间没有人！");
		}
	}

	private static void cha() {
		for(int i = 1; i < 4; i++){
			for(int j = 1; j < 6; j++){
				int room = i * 100 + j;	//配合两个for循环生成房间号
				System.out.print(
				(map.get(room) != null) ? "已住   " : room + " "
				);	
			}
			System.out.println();
		}
	}

}
