package day03;

import java.util.Scanner;

/**
 * 命令解释器 
 */
public class Demo04 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		System.out.print("\t欢迎使用 学生管理软件\n"+
     "1.添加学生  2.学生列表  3.删除学生  0.离开\n"+ 
     "请选择：");
		int cmd = in.nextInt();
		switch(cmd){
		case 0: System.out.println("亲，Bye！"); break;
		case 1: System.out.println("添加学生 "); break;
		case 2: System.out.println("学生列表 "); break;
		case 3: System.out.println("删除学生 "); break;
		}
	}

}
